"""API usuarios y roles — tablas usuario, usuario_personal, roles.

Todo dentro de /configuracion en el frontend, pero endpoints separados para control:
  GET    /usuarios              — lista usuarios de mi empresa (emp_id)
  POST   /usuarios              — crea usuario + persona
  GET    /usuarios/{usu_id}     — detalle con persona y rol
  PUT    /usuarios/{usu_id}     — actualiza usu_usuario, usu_email, rol_id, estado, password
  GET    /usuarios/me/personal  — datos personales del usuario logueado (usp_id)
  PUT    /usuarios/me/personal  — actualiza mis datos personales (usp_nombres, usp_dni, usp_celular)
  GET    /roles                 — lista roles (catálogo global)
"""
from fastapi import APIRouter, Depends, Query
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.deps import get_current_user, require_admin
from app.core.errors import ConflictError, NotFoundError
from app.core.security import hash_password
from app.db.session import get_db
from app.models.catalogs import Rol
from app.models.empresa import Usuario, UsuarioPersonal
from app.schemas.empresa import UsuarioCreate, UsuarioOut, UsuarioUpdate, UsuarioPersonalOut, UsuarioPersonalUpdate

router = APIRouter(prefix="/usuarios", tags=["usuarios"])
roles_router = APIRouter(prefix="/roles", tags=["roles"])


def _to_usuario_out(db: Session, usu: Usuario) -> UsuarioOut:
    rol = usu.rol
    persona = None
    if usu.usp_id:
        persona = db.scalar(select(UsuarioPersonal).where(UsuarioPersonal.emp_id == usu.emp_id, UsuarioPersonal.usp_id == usu.usp_id))
    return UsuarioOut(
        emp_id=usu.emp_id,
        usu_usuario=usu.usu_usuario,
        usu_email=usu.usu_email,
        rol_id=usu.rol_id,
        usp_id=usu.usp_id,
        usu_id=usu.usu_id,
        estado=usu.estado,
        created_at=usu.created_at,
        updated_at=usu.updated_at,
        rol_nombre=rol.rol_nombre if rol else None,
        persona_nombres=persona.usp_nombres if persona else None,
        empresa_nombre=usu.empresa.emp_nombre_comercial if hasattr(usu, 'empresa') and usu.empresa else None,
    )


# ---- Roles (catálogo global, dinámico) ----
@roles_router.get("", summary="Lista roles desde BD (sin hardcode)")
def list_roles(db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    rows = db.scalars(select(Rol).where(Rol.estado == 1).order_by(Rol.rol_codigo)).all()
    return [{"rol_id": r.rol_id, "rol_codigo": r.rol_codigo, "rol_nombre": r.rol_nombre, "rol_descripcion": r.rol_descripcion} for r in rows]


# ---- Usuarios ----
@router.get("", summary="Lista usuarios de mi empresa (emp_id)")
def list_usuarios(
    search: str | None = Query(None, description="Buscar por usu_usuario o usu_email"),
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
):
    stmt = select(Usuario).where(Usuario.emp_id == usuario.emp_id)
    if search:
        from sqlalchemy import or_, func
        like = f"%{search.lower()}%"
        stmt = stmt.where(or_(func.lower(Usuario.usu_usuario).like(like), func.lower(Usuario.usu_email).like(like)))
    stmt = stmt.order_by(Usuario.usu_usuario)
    rows = list(db.scalars(stmt))
    return [_to_usuario_out(db, r) for r in rows]


@router.get("/{usu_id}", summary="Detalle usuario con persona y rol")
def get_usuario(usu_id: str, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    usu = db.scalar(select(Usuario).where(Usuario.emp_id == usuario.emp_id, Usuario.usu_id == usu_id))
    if not usu:
        raise NotFoundError("USUARIO_NOT_FOUND", "Usuario no encontrado.")
    return _to_usuario_out(db, usu)


@router.post("", summary="Crear usuario + persona (admin)", status_code=201)
def create_usuario(payload: UsuarioCreate, db: Session = Depends(get_db), usuario: Usuario = Depends(require_admin)):
    # Forzar emp_id del token
    payload.emp_id = usuario.emp_id

    # Validar rol existe
    if payload.rol_id:
        rol = db.get(Rol, payload.rol_id)
        if not rol:
            raise NotFoundError("ROL_NOT_FOUND", "Rol no existe.")

    # Validar unicidad
    if db.scalar(select(Usuario).where(Usuario.emp_id == usuario.emp_id, Usuario.usu_usuario == payload.usu_usuario)):
        raise ConflictError("USU_USUARIO_EXISTS", "Ya existe ese usu_usuario en tu empresa.")
    if db.scalar(select(Usuario).where(Usuario.emp_id == usuario.emp_id, Usuario.usu_email == payload.usu_email)):
        raise ConflictError("USU_EMAIL_EXISTS", "Ya existe ese usu_email en tu empresa.")

    # Crear persona primero si se envía usp info via password payload? UsuarioCreate no trae persona, pero podemos crear una básica
    # Si payload trae usp_id, usarlo; si no, crear persona con mismo nombre que usu_usuario
    usp_id = payload.usp_id
    if not usp_id:
        # Crear persona mínima
        pers = UsuarioPersonal(emp_id=usuario.emp_id, usp_nombres=payload.usu_usuario, estado=1)
        db.add(pers)
        db.flush()
        usp_id = pers.usp_id

    usu = Usuario(
        emp_id=usuario.emp_id,
        usu_usuario=payload.usu_usuario,
        usu_email=payload.usu_email,
        usu_password_hash=hash_password(payload.password),
        rol_id=payload.rol_id,
        usp_id=usp_id,
        estado=payload.estado,
    )
    db.add(usu)
    db.commit()
    db.refresh(usu)
    return _to_usuario_out(db, usu)


@router.put("/{usu_id}", summary="Actualizar usuario (admin o propio)")
def update_usuario(usu_id: str, payload: UsuarioUpdate, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    target = db.scalar(select(Usuario).where(Usuario.emp_id == usuario.emp_id, Usuario.usu_id == usu_id))
    if not target:
        raise NotFoundError("USUARIO_NOT_FOUND", "Usuario no encontrado.")
    # Solo admin puede editar otros, o uno mismo
    if usuario.usu_id != usu_id:
        # verificar admin
        require_admin(usuario)

    patch = payload.model_dump(exclude_unset=True)
    if "password" in patch and patch["password"]:
        target.usu_password_hash = hash_password(patch.pop("password"))
    if "rol_id" in patch and patch["rol_id"]:
        rol = db.get(Rol, patch["rol_id"])
        if not rol:
            raise NotFoundError("ROL_NOT_FOUND", "Rol no existe.")
    for k, v in patch.items():
        if k in ("emp_id",):  # nunca cambiar emp_id
            continue
        setattr(target, k, v)
    db.commit()
    db.refresh(target)
    return _to_usuario_out(db, target)


# ---- Mi perfil personal (usuario_personal) ----
@router.get("/me/personal", summary="Mi ficha personal (usp_id)")
def get_mi_personal(db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    if not usuario.usp_id:
        raise NotFoundError("PERSONAL_NOT_FOUND", "Tu usuario no tiene ficha personal asociada (usp_id).")
    pers = db.scalar(select(UsuarioPersonal).where(UsuarioPersonal.emp_id == usuario.emp_id, UsuarioPersonal.usp_id == usuario.usp_id))
    if not pers:
        raise NotFoundError("PERSONAL_NOT_FOUND", "Ficha personal no encontrada.")
    return UsuarioPersonalOut(
        emp_id=pers.emp_id, usp_dni=pers.usp_dni, usp_nombres=pers.usp_nombres, usp_celular=pers.usp_celular,
        usp_id=pers.usp_id, estado=pers.estado, created_at=pers.created_at, updated_at=pers.updated_at,
    )


@router.put("/me/personal", summary="Actualizar mi ficha personal")
def update_mi_personal(payload: UsuarioPersonalUpdate, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    if not usuario.usp_id:
        # Crear ficha si no existe
        pers = UsuarioPersonal(emp_id=usuario.emp_id, usp_nombres=payload.usp_nombres or usuario.usu_usuario, usp_dni=payload.usp_dni, usp_celular=payload.usp_celular, estado=1)
        db.add(pers)
        db.commit()
        db.refresh(pers)
        usuario.usp_id = pers.usp_id
        db.commit()
        return UsuarioPersonalOut(emp_id=pers.emp_id, usp_dni=pers.usp_dni, usp_nombres=pers.usp_nombres, usp_celular=pers.usp_celular, usp_id=pers.usp_id, estado=pers.estado, created_at=pers.created_at, updated_at=pers.updated_at)

    pers = db.scalar(select(UsuarioPersonal).where(UsuarioPersonal.emp_id == usuario.emp_id, UsuarioPersonal.usp_id == usuario.usp_id))
    if not pers:
        raise NotFoundError("PERSONAL_NOT_FOUND", "Ficha personal no encontrada.")
    patch = payload.model_dump(exclude_unset=True)
    for k, v in patch.items():
        setattr(pers, k, v)
    db.commit()
    db.refresh(pers)
    return UsuarioPersonalOut(emp_id=pers.emp_id, usp_dni=pers.usp_dni, usp_nombres=pers.usp_nombres, usp_celular=pers.usp_celular, usp_id=pers.usp_id, estado=pers.estado, created_at=pers.created_at, updated_at=pers.updated_at)
