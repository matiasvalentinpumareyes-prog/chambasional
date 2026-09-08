"""Shim legacy — `from app.schemas.misc import ...` tras migración.
Usar en código nuevo: `from app.schemas.auditoria import ...` , `from app.schemas.predicciones import ...` , `from app.schemas.empresa import ...`
"""
from pydantic import BaseModel, Field
from datetime import datetime

# Re-exportar desde nuevos esquemas
try:
    from app.schemas.auditoria import ImportDBOut as ImportSummaryOut  # type: ignore
    from app.schemas.auditoria import ImportErrorDBOut as ImportErrorOut  # type: ignore
except ImportError:
    class ImportErrorOut(BaseModel):
        row: int = 0
        field: str | None = None
        message: str = ""
        model_config = {"from_attributes": True}
    class ImportSummaryOut(BaseModel):
        id: str = ""
        file_name: str = ""
        type: str = "clientes"
        total_rows: int = 0
        accepted_rows: int = 0
        rejected_rows: int = 0
        errors: list[ImportErrorOut] = []
        warnings: list[ImportErrorOut] = []
        status: str = "pending_confirmation"
        created_at: datetime = Field(default_factory=datetime.now)
        model_config = {"from_attributes": True}

try:
    from app.schemas.predicciones import VersionModeloOut as ModelVersionOut  # type: ignore
    from app.schemas.predicciones import ModelMetricDBOut  # noqa
    class ModelMetricOut(BaseModel):
        accuracy: float = 0
        precision: float = 0
        recall: float = 0
        f1: float = 0
        roc_auc: float = 0
        pr_auc: float = 0
        model_config = {"from_attributes": True}
except ImportError:
    class ModelMetricOut(BaseModel):
        accuracy: float = 0
        precision: float = 0
        recall: float = 0
        f1: float = 0
        roc_auc: float = 0
        pr_auc: float = 0
        model_config = {"from_attributes": True}
    class ModelVersionOut(BaseModel):
        id: str = ""
        model_name: str = ""
        version: str = ""
        training_date: datetime = Field(default_factory=datetime.now)
        dataset_version: str = ""
        features: list[str] = []
        status: str = "training"
        metrics: ModelMetricOut = Field(default_factory=ModelMetricOut)
        model_config = {"from_attributes": True}

class ImportPreviewRequest(BaseModel):
    type: str = Field(default="clientes")
    file_name: str = ""
    rows: list[dict[str, str]] = []
    model_config = {"from_attributes": True}

class DiscountRule(BaseModel):
    segment: str = ""
    maxDiscountPct: float = 0
    model_config = {"from_attributes": True}

class BusinessSettingsOut(BaseModel):
    business_name: str = ""
    currency: str = "PEN"
    timezone: str = "America/Lima"
    analysis_window_days: int = 365
    churn_threshold_medium: int = 30
    churn_threshold_high: int = 60
    churn_threshold_critical: int = 80
    campaign_cooldown_days: int = 7
    available_channels: list[str] = []
    discount_rules: list[DiscountRule] | None = None
    language: str = "es"
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
    model_config = {"from_attributes": True}

__all__ = ["ImportErrorOut", "ImportPreviewRequest", "ImportSummaryOut", "ModelMetricOut", "ModelVersionOut", "DiscountRule", "BusinessSettingsOut", "BusinessSettingsUpdate"]
