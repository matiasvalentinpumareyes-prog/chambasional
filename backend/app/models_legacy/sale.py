import enum
from datetime import datetime

from sqlalchemy import DateTime, Enum, ForeignKey, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.session import Base
from app.models.business import gen_uuid
from app.models.common import Money, TimestampMixin
from app.models.customer import Channel


class PaymentMethod(str, enum.Enum):
    cash = "cash"
    card = "card"
    digital_wallet = "digital_wallet"
    other = "other"


class Sale(Base, TimestampMixin):
    __tablename__ = "sales"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    business_id: Mapped[str] = mapped_column(ForeignKey("businesses.id", ondelete="CASCADE"), nullable=False, index=True)
    customer_id: Mapped[str] = mapped_column(ForeignKey("customers.id", ondelete="RESTRICT"), nullable=False, index=True)

    date: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False, index=True)
    channel: Mapped[Channel] = mapped_column(Enum(Channel, name="sale_channel"), default=Channel.internal, nullable=False)
    payment_method: Mapped[PaymentMethod | None] = mapped_column(Enum(PaymentMethod, name="payment_method"), nullable=True)

    discount_total: Mapped[float] = mapped_column(Money, default=0, nullable=False)
    total: Mapped[float] = mapped_column(Money, nullable=False)

    customer: Mapped["Customer"] = relationship(back_populates="sales")  # noqa: F821
    items: Mapped[list["SaleItem"]] = relationship(back_populates="sale", cascade="all, delete-orphan")


class SaleItem(Base, TimestampMixin):
    __tablename__ = "sale_items"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    sale_id: Mapped[str] = mapped_column(ForeignKey("sales.id", ondelete="CASCADE"), nullable=False, index=True)
    product_id: Mapped[str] = mapped_column(ForeignKey("products.id", ondelete="RESTRICT"), nullable=False, index=True)

    quantity: Mapped[int] = mapped_column(Integer, nullable=False)
    unit_price: Mapped[float] = mapped_column(Money, nullable=False)
    discount: Mapped[float] = mapped_column(Money, default=0, nullable=False)
    subtotal: Mapped[float] = mapped_column(Money, nullable=False)

    sale: Mapped["Sale"] = relationship(back_populates="items")
    product: Mapped["Product"] = relationship()  # noqa: F821
