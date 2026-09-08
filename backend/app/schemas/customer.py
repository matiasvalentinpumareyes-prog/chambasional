"""Shim legacy — `from app.schemas.customer import CustomerOut` tras migración.
Usar en código nuevo: `from app.schemas.cliente import ClienteOut` (nombres exactos BD).
Este shim provee compatibilidad para APIs no migradas aún (predictions, etc.).
"""
from datetime import date, datetime
from pydantic import BaseModel, EmailStr, Field

# Re-exportar cliente real
from app.schemas.cliente import ClienteOut as ClienteOutReal, ClienteCreate, ClienteUpdate  # noqa: F401

# Alias para imports legacy
CustomerCreate = ClienteCreate
CustomerUpdate = ClienteUpdate
CustomerOut = ClienteOutReal

# Clases legacy que no existen en BD pero usadas por servicios (RFM, Churn) — mantener para compat
class RFMOut(BaseModel):
    recency_days: int = 0
    frequency: int = 0
    monetary: float = 0
    r: int = 1
    f: int = 1
    m: int = 1
    @property
    def rfm_score(self) -> str:
        return f"{self.r}{self.f}{self.m}"
    model_config = {"from_attributes": True}

class ChurnOut(BaseModel):
    customer_id: str = ""
    churn_probability: float = 0
    churn_score: int = 0
    risk_level: str = "low"
    prediction_date: datetime = Field(default_factory=lambda: datetime.now())
    model_version: str = ""
    reasons: list[str] = []
    confidence: float = 0
    model_config = {"from_attributes": True, "protected_namespaces": ()}

class NextPurchaseOut(BaseModel):
    expected_next_purchase_date: datetime | None = None
    days_until_expected_purchase: int | None = None
    purchase_probability: float | None = None
    confidence: float = 0
    model_config = {"from_attributes": True}

class CustomerBase(BaseModel):
    first_name: str = ""
    last_name: str = ""
    email: EmailStr | None = None
    phone: str | None = None
    birth_date: date | None = None
    city: str | None = None
    preferred_channel: str = "EMAIL"
    consent: bool = False
    model_config = {"from_attributes": True}

__all__ = ["CustomerCreate", "CustomerUpdate", "CustomerOut", "RFMOut", "ChurnOut", "NextPurchaseOut", "CustomerBase"]
