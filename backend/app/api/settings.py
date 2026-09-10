from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.deps import get_current_user, require_admin
from app.db.session import get_db
from app.models.empresa import Empresa, Usuario
from app.schemas.empresa import EmpresaOut, EmpresaUpdate

router = APIRouter(prefix="/settings", tags=["settings"])


def _to_out(empresa: Empresa) -> EmpresaOut:
    # Conversión explícita UUID -> str porque PostgreSQL devuelve objetos UUID
    # pero Pydantic EmpresaOut espera str (validación estricta). Usar model_validate
    # directo falla con "Input should be a valid string [type=string_type, input_value=UUID(...)]"
    # ver error real en logs: backend/app/api/settings.py -> pydantic ValidationError 4 errors dep_id/prv_id/dis_id/emp_id
    return EmpresaOut(
        emp_id=str(empresa.emp_id) if empresa.emp_id else "",
        emp_ruc=empresa.emp_ruc,
        emp_razon_social=empresa.emp_razon_social,
        emp_nombre_comercial=empresa.emp_nombre_comercial,
        emp_direccion=empresa.emp_direccion,
        emp_lema=empresa.emp_lema,
        emp_email=empresa.emp_email,
        emp_celular1=empresa.emp_celular1,
        emp_celular2=empresa.emp_celular2,
        emp_telefono1=empresa.emp_telefono1,
        emp_telefono2=empresa.emp_telefono2,
        emp_nro_cuenta1=empresa.emp_nro_cuenta1,
        emp_nro_cuenta2=empresa.emp_nro_cuenta2,
        dep_id=str(empresa.dep_id) if empresa.dep_id else None,
        prv_id=str(empresa.prv_id) if empresa.prv_id else None,
        dis_id=str(empresa.dis_id) if empresa.dis_id else None,
        estado=empresa.estado,
        created_at=empresa.created_at,
        updated_at=empresa.updated_at,
        created_by=empresa.created_by,
        updated_by=empresa.updated_by,
    )


@router.get("", response_model=EmpresaOut)
def get_settings(db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    empresa = db.scalar(select(Empresa).where(Empresa.emp_id == usuario.emp_id))
    if not empresa:
        raise HTTPException(status_code=404, detail="Empresa no encontrada para tu usuario.")
    return _to_out(empresa)


@router.put("", response_model=EmpresaOut)
def update_settings(payload: EmpresaUpdate, db: Session = Depends(get_db), usuario: Usuario = Depends(require_admin)):
    empresa = db.scalar(select(Empresa).where(Empresa.emp_id == usuario.emp_id))
    if not empresa:
        raise HTTPException(status_code=404, detail="Empresa no encontrada.")
    patch = payload.model_dump(exclude_unset=True)
    # Validar RUC único si cambia
    if "emp_ruc" in patch and patch["emp_ruc"] is not None and patch["emp_ruc"] != empresa.emp_ruc:
        existing = db.scalar(select(Empresa).where(Empresa.emp_ruc == patch["emp_ruc"]))
        if existing:
            raise HTTPException(status_code=409, detail=f"Ya existe otra empresa con RUC {patch['emp_ruc']}")
    for key, value in patch.items():
        setattr(empresa, key, value)
    db.commit()
    db.refresh(empresa)
    return _to_out(empresa)
