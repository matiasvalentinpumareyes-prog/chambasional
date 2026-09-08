"""Shim compatibilidad — `from app.models.campaign import Campaign` tras migración."""
from enum import Enum

from app.models.campanas import Campaign, CampaignRecipient
from app.models.campanas import Comunicacion as Communication

class CampaignStatus(str, Enum):
    draft = "3"
    scheduled = "3"
    active = "1"
    paused = "1"
    finished = "1"
    cancelled = "0"

class RecipientStatus(str, Enum):
    pending = "2"
    sent = "1"
    opened = "1"
    responded = "1"
    converted = "1"
    excluded_no_consent = "0"
    excluded_cooldown = "0"

__all__ = ["Campaign", "CampaignRecipient", "Communication", "CampaignStatus", "RecipientStatus"]
