"""Shim compatibilidad — `from app.models.customer import Customer` sigue funcionando tras migración.
Usar en código nuevo: `from app.models.cliente import Cliente` (nombres exactos BD: cli_id, emp_id).
"""
from enum import Enum

from app.models.cliente import Cliente as Customer
from app.models.cliente import ClienteConsentimiento, ClienteSegmento, ClienteFeatures  # noqa: F401

class Channel(str, Enum):
    email = "EMAIL"
    whatsapp = "WHATSAPP"
    sms = "SMS"
    internal = "PUSH"

class CustomerStatus(str, Enum):
    active = "1"
    inactive = "0"

class ActivityStatus(str, Enum):
    active = "ACTIVO"
    at_risk = "EN_RIESGO"
    dormant = "PERDIDO"
    lost = "PERDIDO"

class CustomerSegment(str, Enum):
    vip = "LEAL"
    loyal = "LEAL"
    frequent = "ACTIVO"
    new = "NUEVO"
    potential = "NUEVO"
    at_risk = "EN_RIESGO"
    dormant = "PERDIDO"
    lost = "PERDIDO"
    high_value = "LEAL"
    low_value = "NUEVO"

class CustomerValue(str, Enum):
    low = "low"
    medium = "medium"
    high = "high"

# Alias legacy para código viejo que usa business_id/id/first_name etc.
try:
    Customer.business_id = property(lambda self: self.emp_id)
    Customer.id = property(lambda self: self.cli_id)
    Customer.first_name = property(lambda self: (self.cli_nombre_razon_social or "").split(" ")[0] if self.cli_nombre_razon_social else "")
    Customer.last_name = property(lambda self: " ".join((self.cli_nombre_razon_social or "").split(" ")[1:]) if self.cli_nombre_razon_social else "")
    Customer.email = property(lambda self: self.cli_email)
    Customer.phone = property(lambda self: self.cli_celular)
    Customer.birth_date = property(lambda self: self.cli_birthday)
    Customer.city = property(lambda self: None)
    Customer.status = property(lambda self: CustomerStatus.active if self.estado == 1 else CustomerStatus.inactive)
except Exception:
    pass

__all__ = ["Customer", "Channel", "CustomerStatus", "ActivityStatus", "CustomerSegment", "CustomerValue"]
