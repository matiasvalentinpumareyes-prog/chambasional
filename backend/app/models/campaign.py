"""Shim compatibilidad — `from app.models.campaign import Campaign` tras migración."""
from enum import Enum

from app.models.campanas import Campaign, CampaignRecipient
from app.models.campanas import Comunicacion as Communication

class CampaignStatus(str, Enum):
    """Estado campañas dinámico (campaigns.estado) — sin hardcode."""
    @classmethod
    def _missing_(cls, value):
        if isinstance(value, (str, int)):
            v = str(value)
            obj = str.__new__(cls, v)
            obj._name_ = v
            obj._value_ = v
            return obj
        return None

class RecipientStatus(str, Enum):
    @classmethod
    def _missing_(cls, value):
        if isinstance(value, (str, int)):
            v = str(value)
            obj = str.__new__(cls, v)
            obj._name_ = v
            obj._value_ = v
            return obj
        return None

__all__ = ["Campaign", "CampaignRecipient", "Communication", "CampaignStatus", "RecipientStatus"]
