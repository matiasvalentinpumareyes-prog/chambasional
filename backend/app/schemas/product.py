from pydantic import BaseModel, Field

from app.models.product import ProductStatus


class ProductBase(BaseModel):
    sku: str = Field(min_length=1, max_length=50)
    name: str = Field(min_length=1, max_length=200)
    description: str | None = None
    category: str = Field(min_length=1, max_length=150)
    price: float = Field(gt=0)
    cost: float | None = Field(default=None, ge=0)
    stock: int | None = Field(default=None, ge=0)


class ProductCreate(ProductBase):
    status: ProductStatus = ProductStatus.active


class ProductUpdate(BaseModel):
    sku: str | None = None
    name: str | None = None
    description: str | None = None
    category: str | None = None
    price: float | None = Field(default=None, gt=0)
    cost: float | None = Field(default=None, ge=0)
    stock: int | None = Field(default=None, ge=0)
    status: ProductStatus | None = None


class ProductOut(ProductBase):
    id: str
    business_id: str
    margin: float | None = None
    status: ProductStatus

    model_config = {"from_attributes": True}
