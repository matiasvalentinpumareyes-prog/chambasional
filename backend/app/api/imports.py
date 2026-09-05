from datetime import datetime, timezone

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.audit import log_action
from app.core.deps import get_current_user
from app.db.session import get_db
from app.models.audit import Import, ImportRowError, ImportStatus
from app.models.business import User
from app.schemas.misc import ImportPreviewRequest, ImportSummaryOut
from app.services.importing import validate_rows

router = APIRouter(prefix="/imports", tags=["imports"])


@router.post("/preview", response_model=ImportSummaryOut)
def preview_import(payload: ImportPreviewRequest, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    """
    Valida el archivo ANTES de importar nada (sección 10). No escribe
    clientes/productos/ventas; solo devuelve el resultado de la
    validación para que el usuario confirme.
    """
    result = validate_rows(db, user.business_id, payload.type, payload.rows)
    return ImportSummaryOut(
        id="preview-not-persisted",
        file_name=payload.file_name,
        type=payload.type,
        total_rows=result["total_rows"],
        accepted_rows=result["accepted_rows"],
        rejected_rows=result["rejected_rows"],
        errors=result["errors"],
        warnings=result["warnings"],
        status=ImportStatus.pending_confirmation,
        created_at=datetime.now(timezone.utc),
    )


@router.get("", response_model=list[ImportSummaryOut])
def import_history(db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    from sqlalchemy import select
    imports = list(db.scalars(select(Import).where(Import.business_id == user.business_id).order_by(Import.created_at.desc())))
    return [
        ImportSummaryOut(
            id=i.id, file_name=i.file_name, type=i.type, total_rows=i.total_rows,
            accepted_rows=i.accepted_rows, rejected_rows=i.rejected_rows,
            errors=[{"row": e.row, "field": e.field, "message": e.message} for e in i.errors if e.severity == "error"],
            warnings=[{"row": e.row, "field": e.field, "message": e.message} for e in i.errors if e.severity == "warning"],
            status=i.status, created_at=i.created_at,
        )
        for i in imports
    ]


@router.post("/{import_id}/confirm", response_model=ImportSummaryOut)
def confirm_import(import_id: str, payload: ImportPreviewRequest, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    """
    Confirma la importación: revalida (nunca confiar en un resultado
    cacheado del cliente) y registra el resumen para el historial. La
    escritura real de clientes/productos/ventas fila por fila reutiliza
    los mismos endpoints de creación para no duplicar lógica de negocio.
    """
    result = validate_rows(db, user.business_id, payload.type, payload.rows)

    record = Import(
        business_id=user.business_id, user_id=user.id, file_name=payload.file_name, type=payload.type,
        total_rows=result["total_rows"], accepted_rows=result["accepted_rows"], rejected_rows=result["rejected_rows"],
        status=ImportStatus.confirmed,
    )
    db.add(record)
    db.flush()

    for e in result["errors"]:
        db.add(ImportRowError(import_id=record.id, row=e["row"], field=e["field"], message=e["message"], severity="error"))
    for w in result["warnings"]:
        db.add(ImportRowError(import_id=record.id, row=w["row"], field=w["field"], message=w["message"], severity="warning"))

    db.commit()
    db.refresh(record)

    log_action(db, business_id=user.business_id, user_id=user.id, action="CONFIRMED_IMPORT", entity="import", entity_id=record.id,
               metadata={"type": payload.type.value, "accepted_rows": result["accepted_rows"]})

    return ImportSummaryOut(
        id=record.id, file_name=record.file_name, type=record.type, total_rows=record.total_rows,
        accepted_rows=record.accepted_rows, rejected_rows=record.rejected_rows,
        errors=result["errors"], warnings=result["warnings"], status=record.status, created_at=record.created_at,
    )
