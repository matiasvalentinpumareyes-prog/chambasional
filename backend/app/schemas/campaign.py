from datetime import datetime

from pydantic import BaseModel, Field

from app.models.campaign import CampaignStatus
from app.models.customer import Channel, CustomerSegment


class CampaignCreate(BaseModel):
    name: str = Field(min_length=1, max_length=200)
    description: str = ""
    segment: CustomerSegment | None = None
    target_customer_ids: list[str] = Field(default_factory=list)
    product_id: str | None = None
    offer: str
    channel: Channel
    start_date: datetime
    end_date: datetime | None = None
    message: str


class CampaignMetricsOut(BaseModel):
    targeted: int
    with_consent: int
    without_consent: int
    estimated_cost: float
    potential_revenue: float
    sent: int
    opened: int
    responded: int
    converted: int
    recovered_customers: int
    recovered_revenue: float
    roi: float | None


class CampaignOut(BaseModel):
    id: str
    business_id: str
    name: str
    description: str
    segment: CustomerSegment | None
    product_id: str | None
    offer: str
    channel: Channel
    start_date: datetime
    end_date: datetime | None
    message: str
    status: CampaignStatus
    metrics: CampaignMetricsOut | None = None
    target_customer_ids: list[str] = Field(default_factory=list)

    model_config = {"from_attributes": True}


class CampaignStatusUpdate(BaseModel):
    status: CampaignStatus


class SimulationResult(BaseModel):
    targeted: int
    estimated_conversion_rate: float
    estimated_converted: int
    estimated_recovered_revenue: float
    estimated_cost: float
    estimated_roi: float | None
    is_simulation: bool = True
