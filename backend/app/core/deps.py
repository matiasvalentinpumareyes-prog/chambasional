from fastapi import Depends
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session

from app.core.errors import ForbiddenError, UnauthorizedError
from app.core.security import decode_access_token
from app.db.session import get_db
from app.models.business import User, UserRole

oauth2_scheme = OAuth2PasswordBearer(tokenUrl=f"/api/auth/login", auto_error=False)


def get_current_user(token: str | None = Depends(oauth2_scheme), db: Session = Depends(get_db)) -> User:
    if not token:
        raise UnauthorizedError(message="No se envió un token de autenticación.")
    payload = decode_access_token(token)
    if not payload or "sub" not in payload:
        raise UnauthorizedError()
    user = db.get(User, payload["sub"])
    if not user or not user.is_active:
        raise UnauthorizedError(message="Usuario inválido o inactivo.")
    return user


def require_admin(user: User = Depends(get_current_user)) -> User:
    """Protege endpoints exclusivos del rol Administrador (sección 5)."""
    if user.role != UserRole.admin:
        raise ForbiddenError(message="Esta acción requiere rol de administrador.")
    return user
