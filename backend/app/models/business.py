"""Shim compatibilidad — `from app.models.business import Business, User` tras migración."""
from enum import Enum

from app.models.empresa import Empresa as Business
from app.models.empresa import Usuario as User
from app.models.empresa import UsuarioPersonal  # noqa: F401

class UserRole(str, Enum):
    admin = "ADMIN_EMPRESA"
    business_user = "OPERADOR"

def gen_uuid():
    from app.models.base import gen_uuid as _gen
    return _gen()

__all__ = ["Business", "User", "UserRole", "gen_uuid"]
