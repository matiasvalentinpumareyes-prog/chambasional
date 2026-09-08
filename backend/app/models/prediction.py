"""Shim compatibilidad — `from app.models.prediction import Prediction` tras migración."""
from enum import Enum

from app.models.ia import Prediccion as Prediction
from app.models.marketing import Recomendacion as Recommendation
from app.models.cliente import ClienteFeatures  # noqa: F401

class RiskLevel(str, Enum):
    low = "low"
    medium = "medium"
    high = "high"
    critical = "critical"

class RecommendationMethod(str, Enum):
    rules = "rules"
    collaborative_filtering = "collaborative_filtering"
    frequency = "frequency"
    cold_start = "cold_start"

class Strategy:
    pass

__all__ = ["Prediction", "Recommendation", "RiskLevel", "RecommendationMethod", "Strategy"]
