"""Shim compatibilidad — `from app.models.business import Business, User` tras migración."""
from enum import Enum

from app.models.empresa import Empresa as Business
from app.models.empresa import Usuario as User
from app.models.empresa import UsuarioPersonal  # noqa: F401

class UserRole(str, Enum):
    """Roles dinámicos vía roles.rol_codigo — sin hardcode."""
    @classmethod
    def _missing_(cls, value):
        if isinstance(value, str):
            obj = str.__new__(cls, value)
            obj._name_ = value
            obj._value_ = value
            return obj
        return None

def gen_uuid():
    from app.models.base import gen_uuid as _gen
    return _gen()

# Alias propiedades para compatibilidad legacy (business_id -> emp_id, business -> empresa)
try:
    User.business_id = property(lambda self: self.emp_id)
    User.business = property(lambda self: self.empresa if hasattr(self, 'empresa') else None)
    User.id = property(lambda self: self.usu_id)
    User.name = property(lambda self: self.usu_usuario)
    User.email = property(lambda self: self.usu_email)
    User.hashed_password = property(lambda self: self.usu_password_hash)
    User.is_active = property(lambda self: self.estado == 1)
except Exception:
    pass

try:
    Business.id = property(lambda self: self.emp_id)
    Business.name = property(lambda self: self.emp_nombre_comercial)
except Exception:
    pass

__all__ = ["Business", "User", "UserRole", "gen_uuid"]
