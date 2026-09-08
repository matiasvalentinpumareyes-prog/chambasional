"""Shim legacy — `from app.schemas.campaign import CampaignCreate` tras migración.
Usar en código nuevo: `from app.schemas.campanas import CampaignDBCreate` (cpg_name, can_id).
"""
from pydantic import BaseModel, Field

from app.schemas.campanas import CampaignDBCreate as CampaignCreate
from app.schemas.campanas import CampaignDBOut as CampaignOut
from app.schemas.campanas import CampaignDBBase, CampaignRecipientDBOut  # noqa: F401

# Alias para imports legacy
CampaignMetricsOut = CampaignDBOut  # placeholder

class CampaignStatusUpdate(BaseModel):
    status: str = Field(default="draft")
    model_config = {"from_attributes": True}

class SimulationResult(BaseModel):
    targeted: int = 0
    estimated_conversion_rate: float = 0
    estimated_converted: int = 0
    estimated_recovered_revenue: float = 0
    estimated_cost: float = 0
    estimated_roi: float | None = None
    is_simulation: bool = True
    model_config = {"from_attributes": True}

__all__ = ["CampaignCreate", "CampaignOut", "CampaignStatusUpdate", "SimulationResult"]
