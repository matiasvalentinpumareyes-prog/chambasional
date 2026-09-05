from datetime import datetime

from pydantic import BaseModel

from app.models.customer import Channel, CustomerValue
from app.models.prediction import RecommendationMethod


class RecommendationOut(BaseModel):
    customer_id: str
    product_id: str
    product_name: str
    score: int
    reasons: list[str]
    confidence: float
    method: RecommendationMethod
    generated_at: datetime
    model_version: str

    model_config = {"from_attributes": True, "protected_namespaces": ()}


class StrategyOut(BaseModel):
    customer_id: str
    customer_name: str
    priority_score: int
    churn_probability: float
    recovery_probability: float
    customer_value: CustomerValue
    recommended_product: RecommendationOut | None
    recommended_action: Channel
    recommended_offer: str
    recommended_timing: str
    reason: str
    message: str
    cooldown_ok: bool
    has_consent: bool
