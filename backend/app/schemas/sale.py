from datetime import datetime

from pydantic import BaseModel, Field

from app.models.customer import Channel
from app.models.sale import PaymentMethod


class SaleItemCreate(BaseModel):
    product_id: str
    quantity: int = Field(gt=0)
    discount_pct: float = Field(default=0, ge=0, le=1)


class SaleItemOut(BaseModel):
    product_id: str
    product_name: str
    quantity: int
    unit_price: float
    discount: float
    subtotal: float

    model_config = {"from_attributes": True}


class SaleCreate(BaseModel):
    customer_id: str
    items: list[SaleItemCreate] = Field(min_length=1)
    channel: Channel = Channel.internal
    payment_method: PaymentMethod | None = None


class SaleOut(BaseModel):
    id: str
    business_id: str
    customer_id: str
    customer_name: str
    date: datetime
    items: list[SaleItemOut]
    discount_total: float
    total: float
    channel: Channel
    payment_method: PaymentMethod | None

    model_config = {"from_attributes": True}
