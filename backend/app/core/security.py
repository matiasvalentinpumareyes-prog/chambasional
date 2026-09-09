from datetime import datetime, timedelta, timezone
from typing import Any

from jose import JWTError, jwt
from passlib.context import CryptContext

from app.core.config import settings

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def hash_password(password: str) -> str:
    """Nunca se guarda una contraseña en texto plano (regla 94.15)."""
    return pwd_context.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)


def create_access_token(subject: str, extra_claims: dict[str, Any] | None = None) -> str:
    expire = datetime.now(timezone.utc) + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    # Convertir UUID a str para que json.dumps no falle (TypeError: UUID not JSON serializable)
    def _stringify(v: Any) -> Any:
        try:
            import uuid
            if isinstance(v, uuid.UUID):
                return str(v)
        except Exception:
            pass
        return v

    to_encode: dict[str, Any] = {"sub": _stringify(subject), "exp": expire}
    if extra_claims:
        to_encode.update({k: _stringify(v) for k, v in extra_claims.items()})
    return jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)


def decode_access_token(token: str) -> dict[str, Any] | None:
    try:
        return jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
    except JWTError:
        return None
