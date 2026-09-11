from fastapi import APIRouter, Depends, Query
from sqlalchemy import select, func, or_
from sqlalchemy.orm import Session

from app.core.deps import get_current_user
from app.core.errors import ConflictError, NotFoundError
from app.db.session import get_db
from app.models.empresa import Empresa, Usuario
from app.schemas.empresa import EmpresaCreate, EmpresaOut, EmpresaUpdate

router = APIRouter(prefix="/empresas", tags=["empresas"])


def _to_out(empresa: Empresa) -> EmpresaOut:
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


@router.get("", response_model=list[EmpresaOut], summary="Lista empresas — nombres BD emp_id/emp_ruc")
def list_empresas(
    search: str | None = Query(None, description="Buscar por emp_ruc o emp_nombre_comercial"),
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
):
    # Para MVP: lista todas si es SUPERADMIN, si no solo su empresa
    # Detectar rol
    rol_codigo = usuario.rol.rol_codigo if hasattr(usuario, 'rol') and usuario.rol else ""
    stmt = select(Empresa).where(Empresa.estado == 1)
    if rol_codigo != "SUPERADMIN":
        # No superadmin: solo su empresa
        stmt = stmt.where(Empresa.emp_id == usuario.emp_id)
    if search:
        like = f"%{search.lower()}%"
        stmt = stmt.where(or_(func.lower(Empresa.emp_ruc).like(like), func.lower(Empresa.emp_nombre_comercial).like(like), func.lower(Empresa.emp_razon_social).like(like)))
    stmt = stmt.order_by(Empresa.emp_nombre_comercial.asc())
    rows = list(db.scalars(stmt))
    return [_to_out(r) for r in rows]


@router.get("/{emp_id}", response_model=EmpresaOut, summary="Detalle empresa")
def get_empresa(emp_id: str, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    empresa = db.scalar(select(Empresa).where(Empresa.emp_id == emp_id))
    if not empresa:
        raise NotFoundError("EMPRESA_NOT_FOUND", "Empresa no encontrada.")
    # Validar acceso: si no es superadmin, solo su empresa
    rol_codigo = usuario.rol.rol_codigo if hasattr(usuario, 'rol') and usuario.rol else ""
    if rol_codigo != "SUPERADMIN" and str(empresa.emp_id) != str(usuario.emp_id):
        raise NotFoundError("EMPRESA_NOT_FOUND", "Empresa no encontrada.")
    return _to_out(empresa)


@router.post("", response_model=EmpresaOut, status_code=201, summary="Crear empresa — usa emp_ruc/emp_razon_social BD")
def create_empresa(payload: EmpresaCreate, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    # Validar RUC único (uq_empresa_ruc)
    if db.scalar(select(Empresa).where(Empresa.emp_ruc == payload.emp_ruc)):
        raise ConflictError("RUC_ALREADY_EXISTS", f"Ya existe una empresa con RUC {payload.emp_ruc}")
    empresa = Empresa(
        emp_ruc=payload.emp_ruc,
        emp_razon_social=payload.emp_razon_social,
        emp_nombre_comercial=payload.emp_nombre_comercial,
        emp_direccion=payload.emp_direccion,
        emp_lema=payload.emp_lema,
        emp_email=payload.emp_email,
        emp_celular1=payload.emp_celular1,
        emp_celular2=payload.emp_celular2,
        emp_telefono1=payload.emp_telefono1,
        emp_telefono2=payload.emp_telefono2,
        emp_nro_cuenta1=payload.emp_nro_cuenta1,
        emp_nro_cuenta2=payload.emp_nro_cuenta2,
        dep_id=payload.dep_id,
        prv_id=payload.prv_id,
        dis_id=payload.dis_id,
        estado=payload.estado or 1,
        created_by=str(usuario.usu_id) if usuario.usu_id else None,
    )
    db.add(empresa)
    db.commit()
    db.refresh(empresa)
    return _to_out(empresa)


@router.put("/{emp_id}", response_model=EmpresaOut, summary="Actualizar empresa — permite editar existente")
def update_empresa(emp_id: str, payload: EmpresaUpdate, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    empresa = db.scalar(select(Empresa).where(Empresa.emp_id == emp_id))
    if not empresa:
        raise NotFoundError("EMPRESA_NOT_FOUND", "Empresa no encontrada.")
    # Permiso: solo SUPERADMIN puede editar cualquiera, otros solo su propia empresa
    rol_codigo = usuario.rol.rol_codigo if hasattr(usuario, 'rol') and usuario.rol else ""
    if rol_codigo != "SUPERADMIN" and str(empresa.emp_id) != str(usuario.emp_id):
        raise NotFoundError("EMPRESA_NOT_FOUND", "Empresa no encontrada.")
    patch = payload.model_dump(exclude_unset=True)
    # Validar RUC único si cambia
    if "emp_ruc" in patch and patch["emp_ruc"] and patch["emp_ruc"] != empresa.emp_ruc:
        if db.scalar(select(Empresa).where(Empresa.emp_ruc == patch["emp_ruc"])):
            raise ConflictError("RUC_ALREADY_EXISTS", f"Ya existe otra empresa con RUC {patch['emp_ruc']}")
    for k, v in patch.items():
        setattr(empresa, k, v)
    empresa.updated_by = str(usuario.usu_id) if usuario.usu_id else None
    db.commit()
    db.refresh(empresa)
    return _to_out(empresa)
