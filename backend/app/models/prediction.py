"""Shim compatibilidad — `from app.models.prediction import Prediction` tras migración."""
from enum import Enum

from app.models.ia import Prediccion as Prediction
from app.models.marketing import Recomendacion as Recommendation
from app.models.cliente import ClienteFeatures  # noqa: F401

class RiskLevel(str, Enum):
    @classmethod
    def _missing_(cls, value):
        if isinstance(value, str):
            obj = str.__new__(cls, value)
            obj._name_ = value
            obj._value_ = value
            return obj
        return None

class RecommendationMethod(str, Enum):
    @classmethod
    def _missing_(cls, value):
        if isinstance(value, str):
            obj = str.__new__(cls, value)
            obj._name_ = value
            obj._value_ = value
            return obj
        return None

class Strategy:
    pass

__all__ = ["Prediction", "Recommendation", "RiskLevel", "RecommendationMethod", "Strategy"]
