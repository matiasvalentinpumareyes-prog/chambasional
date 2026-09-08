"""Shim compatibilidad — `from app.models.audit import AuditLog` tras migración."""
from enum import Enum

from app.models.auditoria import AuditoriaLog as AuditLog
from app.models.auditoria import Import, ImportError as ImportRowError
from app.models.ia import VersionModelo as ModelVersion
from app.models.ia import ModelMetric
from app.models.marketing import Rule

class ImportType(str, Enum):
    customers = "clientes"
    products = "productos"
    sales = "ventas"

class ImportStatus(str, Enum):
    pending_confirmation = "2"
    confirmed = "1"
    cancelled = "0"

class ModelStatus(str, Enum):
    training = "1"
    candidate = "1"
    production = "1"
    deprecated = "0"
    failed = "0"

__all__ = ["AuditLog", "Import", "ImportRowError", "ModelMetric", "ModelVersion", "Rule", "ImportType", "ImportStatus", "ModelStatus"]
