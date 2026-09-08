"""Shim compatibilidad — `from app.models.audit import AuditLog` tras migración."""
from enum import Enum

from app.models.auditoria import AuditoriaLog as AuditLog
from app.models.auditoria import Import, ImportError as ImportRowError
from app.models.ia import VersionModelo as ModelVersion
from app.models.ia import ModelMetric
from app.models.marketing import Rule

class ImportType(str, Enum):
    @classmethod
    def _missing_(cls, value):
        if isinstance(value, str):
            obj = str.__new__(cls, value)
            obj._name_ = value
            obj._value_ = value
            return obj
        return None

class ImportStatus(str, Enum):
    @classmethod
    def _missing_(cls, value):
        if isinstance(value, str):
            v = str(value)
            obj = str.__new__(cls, v)
            obj._name_ = v
            obj._value_ = v
            return obj
        return None

class ModelStatus(str, Enum):
    @classmethod
    def _missing_(cls, value):
        if isinstance(value, str):
            v = str(value)
            obj = str.__new__(cls, v)
            obj._name_ = v
            obj._value_ = v
            return obj
        return None

__all__ = ["AuditLog", "Import", "ImportRowError", "ModelMetric", "ModelVersion", "Rule", "ImportType", "ImportStatus", "ModelStatus"]
