from datetime import date, datetime

from pydantic import BaseModel, EmailStr, Field

from app.models.customer import ActivityStatus, Channel, CustomerSegment, CustomerStatus, CustomerValue
from app.models.prediction import RiskLevel


class RFMOut(BaseModel):
    recency_days: int
    frequency: int
    monetary: float
    r: int
    f: int
    m: int

    @property
    def rfm_score(self) -> str:
        return f"{self.r}{self.f}{self.m}"


class ChurnOut(BaseModel):
    model_config = {"protected_namespaces": ()}

    customer_id: str
    churn_probability: float
    churn_score: int
    risk_level: RiskLevel
    prediction_date: datetime
    model_version: str
    reasons: list[str]
    confidence: float


class NextPurchaseOut(BaseModel):
    expected_next_purchase_date: datetime | None
    days_until_expected_purchase: int | None
    purchase_probability: float | None
    confidence: float | None


class CustomerBase(BaseModel):
    first_name: str = Field(min_length=1, max_length=120)
    last_name: str = Field(min_length=1, max_length=120)
    email: EmailStr | None = None
    phone: str | None = Field(default=None, max_length=30)
    birth_date: date | None = None
    city: str | None = Field(default=None, max_length=120)
    preferred_channel: Channel = Channel.email
    consent: bool = False


class CustomerCreate(CustomerBase):
    pass


class CustomerUpdate(BaseModel):
    first_name: str | None = None
    last_name: str | None = None
    email: EmailStr | None = None
    phone: str | None = None
    city: str | None = None
    preferred_channel: Channel | None = None
    consent: bool | None = None


class CustomerOut(CustomerBase):
    id: str
    business_id: str
    status: CustomerStatus
    registered_at: datetime
    last_purchase_at: datetime | None
    purchase_count: int
    total_spend: float
    avg_ticket: float
    avg_interval_days: int | None
    segment: CustomerSegment
    customer_value: CustomerValue
    activity_status: ActivityStatus
    rfm: RFMOut
    churn: ChurnOut | None = None
    next_purchase: NextPurchaseOut | None = None

    model_config = {"from_attributes": True}
