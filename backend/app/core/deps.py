from fastapi import Depends
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from sqlalchemy import select

from app.core.errors import ForbiddenError, UnauthorizedError
from app.core.security import decode_access_token
from app.db.session import get_db
from app.models.empresa import Usuario
from app.models.catalogs import Rol

oauth2_scheme = OAuth2PasswordBearer(tokenUrl=f"/api/auth/login", auto_error=False)


def get_current_user(token: str | None = Depends(oauth2_scheme), db: Session = Depends(get_db)) -> Usuario:
    if not token:
        raise UnauthorizedError(message="No se envió un token de autenticación.")
    payload = decode_access_token(token)
    if not payload or "sub" not in payload:
        raise UnauthorizedError()
    # payload sub es usu_id (antes user.id)
    usu_id = payload["sub"]
    usuario = db.get(Usuario, usu_id)
    if not usuario or usuario.estado != 1:
        raise UnauthorizedError(message="Usuario inválido o inactivo.")
    return usuario


def get_current_usuario(token: str | None = Depends(oauth2_scheme), db: Session = Depends(get_db)) -> Usuario:
    """Alias español — usar en código nuevo."""
    return get_current_user(token, db)


def require_admin(usuario: Usuario = Depends(get_current_user)) -> Usuario:
    """Protege endpoints exclusivos de rol ADMIN_EMPRESA / SUPERADMIN."""
    # Buscar rol_codigo
    if not usuario.rol_id:
        raise ForbiddenError(message="Usuario sin rol asignado.")
    rol = usuario.rol
    rol_codigo = rol.rol_codigo if rol else ""
    if rol_codigo not in ("SUPERADMIN", "ADMIN_EMPRESA"):
        raise ForbiddenError(message="Esta acción requiere rol de administrador (ADMIN_EMPRESA).")
    return usuario


def require_role(rol_codigos: list[str]):
    """Factory para requerir uno de varios roles (ej. MARKETING, OPERADOR)."""
    def _check(usuario: Usuario = Depends(get_current_user)) -> Usuario:
        if not usuario.rol_id:
            raise ForbiddenError(message="Usuario sin rol.")
        rol = usuario.rol
        if not rol or rol.rol_codigo not in rol_codigos:
            raise ForbiddenError(message=f"Se requiere uno de los roles: {', '.join(rol_codigos)}")
        return usuario
    return _check
