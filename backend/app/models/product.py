import enum

from sqlalchemy import Enum, ForeignKey, Integer, String, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.session import Base
from app.models.business import gen_uuid
from app.models.common import Money, TimestampMixin


class ProductStatus(str, enum.Enum):
    active = "active"
    inactive = "inactive"


class Category(Base, TimestampMixin):
    __tablename__ = "categories"
    __table_args__ = (UniqueConstraint("business_id", "name", name="uq_category_business_name"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    business_id: Mapped[str] = mapped_column(ForeignKey("businesses.id", ondelete="CASCADE"), nullable=False, index=True)
    name: Mapped[str] = mapped_column(String(150), nullable=False)

    products: Mapped[list["Product"]] = relationship(back_populates="category_rel")


class Product(Base, TimestampMixin):
    __tablename__ = "products"
    __table_args__ = (UniqueConstraint("business_id", "sku", name="uq_product_business_sku"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    business_id: Mapped[str] = mapped_column(ForeignKey("businesses.id", ondelete="CASCADE"), nullable=False, index=True)
    category_id: Mapped[str | None] = mapped_column(ForeignKey("categories.id", ondelete="SET NULL"), nullable=True)

    sku: Mapped[str] = mapped_column(String(50), nullable=False)
    name: Mapped[str] = mapped_column(String(200), nullable=False)
    description: Mapped[str | None] = mapped_column(String(1000), nullable=True)
    price: Mapped[float] = mapped_column(Money, nullable=False)
    cost: Mapped[float | None] = mapped_column(Money, nullable=True)
    stock: Mapped[int | None] = mapped_column(Integer, nullable=True)
    status: Mapped[ProductStatus] = mapped_column(Enum(ProductStatus, name="product_status"), default=ProductStatus.active, nullable=False)

    category_rel: Mapped["Category | None"] = relationship(back_populates="products")

    @property
    def margin_pct(self) -> float | None:
        """Margen porcentual calculado, nunca almacenado de forma redundante."""
        if self.cost is None or self.price in (None, 0):
            return None
        return round(float((self.price - self.cost) / self.price) * 100, 1)
