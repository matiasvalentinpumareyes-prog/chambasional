from datetime import datetime

from pydantic import BaseModel

from app.models.audit import ImportStatus, ImportType, ModelStatus
from app.models.customer import Channel


class ImportErrorOut(BaseModel):
    row: int
    field: str | None
    message: str


class ImportPreviewRequest(BaseModel):
    type: ImportType
    file_name: str
    rows: list[dict[str, str]]


class ImportSummaryOut(BaseModel):
    id: str
    file_name: str
    type: ImportType
    total_rows: int
    accepted_rows: int
    rejected_rows: int
    errors: list[ImportErrorOut]
    warnings: list[ImportErrorOut]
    status: ImportStatus
    created_at: datetime

    model_config = {"from_attributes": True}


class ModelMetricOut(BaseModel):
    accuracy: float
    precision: float
    recall: float
    f1: float
    roc_auc: float
    pr_auc: float


class ModelVersionOut(BaseModel):
    id: str
    model_name: str
    version: str
    training_date: datetime
    dataset_version: str
    features: list[str]
    metrics: ModelMetricOut
    status: ModelStatus

    model_config = {"from_attributes": True, "protected_namespaces": ()}


class DiscountRule(BaseModel):
    segment: str
    max_discount_pct: float


class BusinessSettingsOut(BaseModel):
    business_name: str
    currency: str
    timezone: str
    analysis_window_days: int
    churn_threshold_medium: int
    churn_threshold_high: int
    churn_threshold_critical: int
    campaign_cooldown_days: int
    available_channels: list[Channel]
    language: str

    model_config = {"from_attributes": True}


class BusinessSettingsUpdate(BaseModel):
    business_name: str | None = None
    currency: str | None = None
    timezone: str | None = None
    analysis_window_days: int | None = None
    churn_threshold_medium: int | None = None
    churn_threshold_high: int | None = None
    churn_threshold_critical: int | None = None
    campaign_cooldown_days: int | None = None
    language: str | None = None
