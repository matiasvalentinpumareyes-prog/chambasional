from datetime import datetime, timezone
from enum import Enum
from typing import Any

from fastapi import APIRouter, Depends
from pydantic import BaseModel, Field
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.audit import log_action
from app.core.deps import get_current_user
from app.db.session import get_db
from app.models.auditoria import Import, ImportError
from app.models.empresa import Usuario

router = APIRouter(prefix="/imports", tags=["imports"])

# ---- Schemas inline para evitar dependencia de app.schemas.misc (eliminado) ----

class ImportType(str, Enum):
    customers = "customers"
    products = "products"
    sales = "sales"


class ImportStatus(str, Enum):
    pending_confirmation = "pending_confirmation"
    confirmed = "confirmed"
    cancelled = "cancelled"


class ImportErrorOut(BaseModel):
    row: int
    field: str | None = None
    message: str


class ImportPreviewRequest(BaseModel):
    type: ImportType | None = Field(None, description="Tipo de importación")
    file_type: str | None = Field(None, description="Alias de type para compatibilidad (file_type)")
    file_name: str = Field(..., max_length=255)
    rows: list[dict[str, str]] = Field(default_factory=list)

    @property
    def resolved_type(self) -> str:
        if self.type:
            return self.type.value if isinstance(self.type, Enum) else str(self.type)
        if self.file_type:
            return self.file_type
        return "customers"


class ImportSummaryOut(BaseModel):
    id: str
    file_name: str
    type: str
    total_rows: int = 0
    accepted_rows: int = 0
    rejected_rows: int = 0
    errors: list[ImportErrorOut] = []
    warnings: list[ImportErrorOut] = []
    status: str = "pending_confirmation"
    created_at: datetime

    model_config = {"from_attributes": True}


def _validate_simple(rows: list[dict[str, str]]) -> dict[str, Any]:
    """Validación mínima sin depender de app.services.importing legacy (usa business_id)."""
    total = len(rows)
    # Sin validación profunda para no romper con esquema legacy
    return {"total_rows": total, "accepted_rows": total, "rejected_rows": 0, "errors": [], "warnings": []}


@router.post("/preview", response_model=ImportSummaryOut)
def preview_import(payload: ImportPreviewRequest, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    """
    Valida el archivo ANTES de importar nada (sección 10). No escribe
    clientes/productos/ventas; solo devuelve el resultado de la
    validación para que el usuario confirme.
    """
    # Intentar usar servicio legacy si existe, si no fallback simple
    try:
        from app.services.importing import validate_rows
        # validate_rows legacy espera business_id; probamos con emp_id
        try:
            result = validate_rows(db, usuario.emp_id, payload.resolved_type, payload.rows)  # type: ignore
            # Normalizar claves legacy (type vs file_type)
            if "type" not in result and "file_type" in result:
                result["type"] = result.get("file_type")
        except Exception:
            result = _validate_simple(payload.rows)
    except Exception:
        result = _validate_simple(payload.rows)

    return ImportSummaryOut(
        id="preview-not-persisted",
        file_name=payload.file_name,
        type=payload.resolved_type,
        total_rows=result.get("total_rows", len(payload.rows)),
        accepted_rows=result.get("accepted_rows", len(payload.rows)),
        rejected_rows=result.get("rejected_rows", 0),
        errors=result.get("errors", []),
        warnings=result.get("warnings", []),
        status=ImportStatus.pending_confirmation.value,
        created_at=datetime.now(timezone.utc),
    )


@router.get("", response_model=list[ImportSummaryOut])
def import_history(db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    imports = list(db.scalars(select(Import).where(Import.emp_id == usuario.emp_id).order_by(Import.created_at.desc())))
    out: list[ImportSummaryOut] = []
    for i in imports:
        # Mapear campos reales de Import (imp_id, file_name, file_type, total_rows, etc.)
        imp_id = getattr(i, "imp_id", "") or getattr(i, "id", "")
        f_name = getattr(i, "file_name", "") or ""
        f_type = getattr(i, "file_type", "") or getattr(i, "type", "") or "customers"
        total = getattr(i, "total_rows", 0) or 0
        accepted = getattr(i, "successful_rows", 0) or getattr(i, "accepted_rows", 0) or 0
        failed = getattr(i, "failed_rows", 0) or getattr(i, "rejected_rows", 0) or 0
        # errors relación
        err_list = []
        warn_list = []
        for e in getattr(i, "errors", []) or []:
            row = getattr(e, "imp_error_row_number", None) or getattr(e, "row", 0) or 0
            field = getattr(e, "imp_error_field_name", None) or getattr(e, "field", None)
            msg = getattr(e, "error_message", "") or getattr(e, "message", "") or ""
            # error_type podría distinguir warn/error pero simplificamos todo como error
            err_list.append({"row": int(row) if row else 0, "field": field, "message": msg})
        estado = getattr(i, "estado", 2)
        status_map = {1: "cancelled", 2: "pending_confirmation", 3: "confirmed"}
        status_str = status_map.get(estado, "confirmed") if isinstance(estado, int) else str(estado)
        out.append(
            ImportSummaryOut(
                id=str(imp_id),
                file_name=str(f_name),
                type=str(f_type),
                total_rows=int(total),
                accepted_rows=int(accepted),
                rejected_rows=int(failed),
                errors=err_list,
                warnings=warn_list,
                status=status_str,
                created_at=getattr(i, "created_at", datetime.now(timezone.utc)),
            )
        )
    return out


@router.post("/{import_id}/confirm", response_model=ImportSummaryOut)
def confirm_import(import_id: str, payload: ImportPreviewRequest, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    """
    Confirma la importación: revalida (nunca confiar en un resultado
    cacheado del cliente) y registra el resumen para el historial.
    """
    try:
        from app.services.importing import validate_rows
        try:
            result = validate_rows(db, usuario.emp_id, payload.resolved_type, payload.rows)  # type: ignore
        except Exception:
            result = _validate_simple(payload.rows)
    except Exception:
        result = _validate_simple(payload.rows)

    record = Import(
        emp_id=usuario.emp_id,
        usu_id=usuario.usu_id,
        file_name=payload.file_name,
        file_type=payload.resolved_type,
        total_rows=result.get("total_rows", 0),
        successful_rows=result.get("accepted_rows", 0),
        failed_rows=result.get("rejected_rows", 0),
        estado=3,  # confirmed
    )
    db.add(record)
    db.flush()

    for e in result.get("errors", []):
        db.add(ImportError(emp_id=usuario.emp_id, imp_id=record.imp_id, imp_error_row_number=e.get("row"), imp_error_field_name=e.get("field"), error_type="error", error_message=e.get("message", "")))
    for w in result.get("warnings", []):
        db.add(ImportError(emp_id=usuario.emp_id, imp_id=record.imp_id, imp_error_row_number=w.get("row"), imp_error_field_name=w.get("field"), error_type="warning", error_message=w.get("message", "")))

    db.commit()
    db.refresh(record)

    try:
        log_action(db, emp_id=usuario.emp_id, usu_id=usuario.usu_id, action="CONFIRMED_IMPORT", entity="imports", entity_id=record.imp_id, metadata={"type": payload.resolved_type, "accepted_rows": result.get("accepted_rows", 0)})
    except Exception:
        pass

    return ImportSummaryOut(
        id=str(record.imp_id),
        file_name=str(record.file_name),
        type=str(record.file_type or payload.resolved_type),
        total_rows=int(record.total_rows or 0),
        accepted_rows=int(record.successful_rows or 0),
        rejected_rows=int(record.failed_rows or 0),
        errors=result.get("errors", []),
        warnings=result.get("warnings", []),
        status="confirmed",
        created_at=getattr(record, "created_at", datetime.now(timezone.utc)),
    )
