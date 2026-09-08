from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.audit import log_action
from app.core.deps import get_current_user
from app.core.errors import ConflictError, UnauthorizedError
from app.core.security import create_access_token, hash_password, verify_password
from app.db.session import get_db
from app.models.catalogs import Rol
from app.models.empresa import Empresa, Usuario, UsuarioPersonal
from app.schemas.auth import LoginRequest, RegisterRequest, TokenResponse, UsuarioOut

router = APIRouter(prefix="/auth", tags=["auth"])


def _usuario_out(usuario: Usuario) -> UsuarioOut:
    # Resolver rol y empresa y persona
    rol = usuario.rol
    empresa = usuario.empresa
    # persona via usp_id
    usp_nombres = None
    if usuario.usp_id:
        # buscar persona
        from sqlalchemy import select as _select
        # lazy import to avoid cycle
        pass
    # Simplificar: si tiene relación personal, buscar
    persona_nombres = None
    if usuario.usp_id:
        # Nota: relación no directa, buscar manual
        from app.db.session import SessionLocal  # noqa
        pass
    # Usar atributos directos si existen
    rol_codigo = rol.rol_codigo if rol else None
    rol_nombre = rol.rol_nombre if rol else None
    emp_nombre = empresa.emp_nombre_comercial if empresa else ""
    emp_ruc = empresa.emp_ruc if empresa else None
    # persona nombres: buscar via DB si necesario (evita N+1, se hace en caller)
    return UsuarioOut(
        usu_id=usuario.usu_id,
        emp_id=usuario.emp_id,
        usu_usuario=usuario.usu_usuario,
        usu_email=usuario.usu_email,
        rol_id=usuario.rol_id,
        rol_codigo=rol_codigo,
        rol_nombre=rol_nombre,
        usp_id=usuario.usp_id,
        usp_nombres=None,  # se resuelve en get_current_user si se necesita
        emp_nombre_comercial=emp_nombre,
        emp_ruc=emp_ruc,
        estado=usuario.estado,
        created_at=usuario.created_at,
    )


@router.post("/register", response_model=TokenResponse)
def register(payload: RegisterRequest, db: Session = Depends(get_db)):
    # Validar RUC único y usuario único por empresa futura
    existing_emp = db.scalar(select(Empresa).where(Empresa.emp_ruc == payload.emp_ruc))
    if existing_emp:
        raise ConflictError("RUC_ALREADY_REGISTERED", f"Ya existe una empresa con RUC {payload.emp_ruc}")

    # Buscar rol
    rol = db.scalar(select(Rol).where(Rol.rol_codigo == payload.rol_codigo))
    if not rol:
        # fallback a ADMIN_EMPRESA
        rol = db.scalar(select(Rol).where(Rol.rol_codigo == "ADMIN_EMPRESA"))
        if not rol:
            raise ConflictError("ROL_NOT_FOUND", f"Rol {payload.rol_codigo} no existe. Inicializa seeds de roles.")

    empresa = Empresa(
        emp_ruc=payload.emp_ruc,
        emp_razon_social=payload.emp_razon_social,
        emp_nombre_comercial=payload.emp_nombre_comercial,
        emp_email=payload.emp_email,
    )
    db.add(empresa)
    db.flush()  # genera emp_id

    usuario_personal = UsuarioPersonal(
        emp_id=empresa.emp_id,
        usp_nombres=payload.usp_nombres,
        usp_dni=payload.usp_dni,
    )
    db.add(usuario_personal)
    db.flush()

    # Validar usuario único
    existing_user = db.scalar(select(Usuario).where(Usuario.emp_id == empresa.emp_id, Usuario.usu_email == payload.usu_email))
    if existing_user:
        raise ConflictError("EMAIL_ALREADY_REGISTERED", "Ya existe un usuario con este correo en la empresa.")

    usuario = Usuario(
        emp_id=empresa.emp_id,
        usu_usuario=payload.usu_usuario,
        usu_email=payload.usu_email,
        usu_password_hash=hash_password(payload.password),
        rol_id=rol.rol_id if rol else None,
        usp_id=usuario_personal.usp_id,
    )
    db.add(usuario)
    db.commit()
    db.refresh(usuario)
    # cargar relaciones
    db.refresh(empresa)

    # Auditoría
    try:
        log_action(db, business_id=empresa.emp_id, user_id=usuario.usu_id, action="REGISTER_BUSINESS", entity="empresa", entity_id=empresa.emp_id)
    except Exception:
        pass

    token = create_access_token(subject=usuario.usu_id, extra_claims={"emp_id": empresa.emp_id, "rol_codigo": rol.rol_codigo if rol else "", "usu_usuario": usuario.usu_usuario})
    out = _usuario_out(usuario)
    # completar persona nombres
    out.usp_nombres = usuario_personal.usp_nombres
    return TokenResponse(token=token, user=out)


@router.post("/login", response_model=TokenResponse)
def login(payload: LoginRequest, db: Session = Depends(get_db)):
    # Buscar usuario por usu_email o usu_usuario dentro de emp_id si se provee
    usuario = None
    if payload.usu_email:
        if payload.emp_id:
            usuario = db.scalar(select(Usuario).where(Usuario.emp_id == payload.emp_id, Usuario.usu_email == payload.usu_email))
        else:
            usuario = db.scalar(select(Usuario).where(Usuario.usu_email == payload.usu_email))
    elif payload.usu_usuario:
        if payload.emp_id:
            usuario = db.scalar(select(Usuario).where(Usuario.emp_id == payload.emp_id, Usuario.usu_usuario == payload.usu_usuario))
        else:
            usuario = db.scalar(select(Usuario).where(Usuario.usu_usuario == payload.usu_usuario))
    else:
        raise UnauthorizedError(message="Debe enviar usu_email o usu_usuario.")

    if not usuario or not verify_password(payload.password, usuario.usu_password_hash):
        raise UnauthorizedError(message="Correo/usuario o contraseña incorrectos.")
    if usuario.estado != 1:
        raise UnauthorizedError(message="Esta cuenta está desactivada (estado !=1).")

    rol = usuario.rol
    rol_codigo = rol.rol_codigo if rol else ""

    try:
        log_action(db, business_id=usuario.emp_id, user_id=usuario.usu_id, action="LOGIN", entity="usuario", entity_id=usuario.usu_id)
    except Exception:
        pass

    token = create_access_token(subject=usuario.usu_id, extra_claims={"emp_id": usuario.emp_id, "rol_codigo": rol_codigo, "usu_usuario": usuario.usu_usuario})
    out = _usuario_out(usuario)
    # resolver persona nombres si existe
    if usuario.usp_id:
        persona = db.scalar(select(UsuarioPersonal).where(UsuarioPersonal.emp_id == usuario.emp_id, UsuarioPersonal.usp_id == usuario.usp_id))
        if persona:
            out.usp_nombres = persona.usp_nombres
    return TokenResponse(token=token, user=out)


@router.get("/me", response_model=UsuarioOut)
def me(current_user: Usuario = Depends(get_current_user), db: Session = Depends(get_db)):
    out = _usuario_out(current_user)
    if current_user.usp_id:
        persona = db.scalar(select(UsuarioPersonal).where(UsuarioPersonal.emp_id == current_user.emp_id, UsuarioPersonal.usp_id == current_user.usp_id))
        if persona:
            out.usp_nombres = persona.usp_nombres
    return out
