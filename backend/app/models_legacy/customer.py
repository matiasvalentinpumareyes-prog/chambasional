import enum
from datetime import date, datetime

from sqlalchemy import Boolean, Date, DateTime, Enum, ForeignKey, Integer, String, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.session import Base
from app.models.business import gen_uuid
from app.models.common import Money, TimestampMixin


class Channel(str, enum.Enum):
    email = "email"
    whatsapp = "whatsapp"
    sms = "sms"
    internal = "internal"


class CustomerStatus(str, enum.Enum):
    active = "active"
    inactive = "inactive"


class ActivityStatus(str, enum.Enum):
    active = "active"
    at_risk = "at_risk"
    dormant = "dormant"
    lost = "lost"


class CustomerSegment(str, enum.Enum):
    vip = "vip"
    loyal = "loyal"
    frequent = "frequent"
    new = "new"
    potential = "potential"
    at_risk = "at_risk"
    dormant = "dormant"
    lost = "lost"
    high_value = "high_value"
    low_value = "low_value"


class CustomerValue(str, enum.Enum):
    low = "low"
    medium = "medium"
    high = "high"


class Customer(Base, TimestampMixin):
    """
    Cliente del negocio. Los campos derivados (segment, rfm_*, churn_*,
    next_purchase_*) se recalculan periódicamente por los jobs (sección 25)
    y también de forma inmediata al registrar una venta nueva — nunca se
    editan manualmente desde la API.
    """

    __tablename__ = "customers"
    __table_args__ = (UniqueConstraint("business_id", "email", name="uq_customer_business_email"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    business_id: Mapped[str] = mapped_column(ForeignKey("businesses.id", ondelete="CASCADE"), nullable=False, index=True)

    first_name: Mapped[str] = mapped_column(String(120), nullable=False)
    last_name: Mapped[str] = mapped_column(String(120), nullable=False)
    email: Mapped[str | None] = mapped_column(String(255), nullable=True, index=True)
    phone: Mapped[str | None] = mapped_column(String(30), nullable=True)
    birth_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    city: Mapped[str | None] = mapped_column(String(120), nullable=True)
    registered_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)

    preferred_channel: Mapped[Channel] = mapped_column(Enum(Channel, name="channel"), default=Channel.email, nullable=False)
    consent: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    status: Mapped[CustomerStatus] = mapped_column(Enum(CustomerStatus, name="customer_status"), default=CustomerStatus.active, nullable=False)

    # Métricas derivadas (recalculadas, ver app/services/rfm.py y churn.py)
    last_purchase_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    purchase_count: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    total_spend: Mapped[float] = mapped_column(Money, default=0, nullable=False)
    avg_ticket: Mapped[float] = mapped_column(Money, default=0, nullable=False)
    avg_interval_days: Mapped[int | None] = mapped_column(Integer, nullable=True)

    segment: Mapped[CustomerSegment] = mapped_column(Enum(CustomerSegment, name="customer_segment"), default=CustomerSegment.new, nullable=False, index=True)
    customer_value: Mapped[CustomerValue] = mapped_column(Enum(CustomerValue, name="customer_value"), default=CustomerValue.low, nullable=False)
    activity_status: Mapped[ActivityStatus] = mapped_column(Enum(ActivityStatus, name="activity_status"), default=ActivityStatus.active, nullable=False, index=True)

    # RFM (sección 11)
    rfm_recency_days: Mapped[int] = mapped_column(Integer, default=9999, nullable=False)
    rfm_frequency: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    rfm_monetary: Mapped[float] = mapped_column(Money, default=0, nullable=False)
    rfm_r: Mapped[int] = mapped_column(Integer, default=1, nullable=False)
    rfm_f: Mapped[int] = mapped_column(Integer, default=1, nullable=False)
    rfm_m: Mapped[int] = mapped_column(Integer, default=1, nullable=False)

    sales: Mapped[list["Sale"]] = relationship(back_populates="customer")  # noqa: F821
