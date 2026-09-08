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

__all__ = ["Customer", "Channel", "CustomerStatus", "ActivityStatus", "CustomerSegment", "CustomerValue"]
