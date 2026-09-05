import enum
from datetime import datetime

from sqlalchemy import DateTime, Enum, ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.session import Base
from app.models.business import gen_uuid
from app.models.common import Money, TimestampMixin
from app.models.customer import Channel, CustomerSegment


class CampaignStatus(str, enum.Enum):
    draft = "draft"
    scheduled = "scheduled"
    active = "active"
    paused = "paused"
    finished = "finished"
    cancelled = "cancelled"


class Campaign(Base, TimestampMixin):
    __tablename__ = "campaigns"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    business_id: Mapped[str] = mapped_column(ForeignKey("businesses.id", ondelete="CASCADE"), nullable=False, index=True)
    product_id: Mapped[str | None] = mapped_column(ForeignKey("products.id", ondelete="SET NULL"), nullable=True)

    name: Mapped[str] = mapped_column(String(200), nullable=False)
    description: Mapped[str] = mapped_column(String(1000), default="", nullable=False)
    segment: Mapped[CustomerSegment | None] = mapped_column(Enum(CustomerSegment, name="campaign_segment"), nullable=True)
    channel: Mapped[Channel] = mapped_column(Enum(Channel, name="campaign_channel"), nullable=False)
    offer: Mapped[str] = mapped_column(String(100), nullable=False)
    message: Mapped[str] = mapped_column(String(2000), nullable=False)
    status: Mapped[CampaignStatus] = mapped_column(Enum(CampaignStatus, name="campaign_status"), default=CampaignStatus.draft, nullable=False, index=True)

    start_date: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    end_date: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    recipients: Mapped[list["CampaignRecipient"]] = relationship(back_populates="campaign", cascade="all, delete-orphan")


class RecipientStatus(str, enum.Enum):
    pending = "pending"
    sent = "sent"
    opened = "opened"
    responded = "responded"
    converted = "converted"
    excluded_no_consent = "excluded_no_consent"
    excluded_cooldown = "excluded_cooldown"


class CampaignRecipient(Base, TimestampMixin):
    """
    Relación campaña-cliente con el resultado individual, usada para
    calcular ROI y clientes recuperados (secciones 24, 29).
    """

    __tablename__ = "campaign_recipients"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    campaign_id: Mapped[str] = mapped_column(ForeignKey("campaigns.id", ondelete="CASCADE"), nullable=False, index=True)
    customer_id: Mapped[str] = mapped_column(ForeignKey("customers.id", ondelete="CASCADE"), nullable=False, index=True)

    status: Mapped[RecipientStatus] = mapped_column(Enum(RecipientStatus, name="recipient_status"), default=RecipientStatus.pending, nullable=False)
    recovered_revenue: Mapped[float | None] = mapped_column(Money, nullable=True)
    recovered_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    campaign: Mapped["Campaign"] = relationship(back_populates="recipients")


class Communication(Base, TimestampMixin):
    """
    Registro de cada comunicación enviada a un cliente (usado para
    calcular el communication_cooldown, sección 30).
    """

    __tablename__ = "communications"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    business_id: Mapped[str] = mapped_column(ForeignKey("businesses.id", ondelete="CASCADE"), nullable=False, index=True)
    customer_id: Mapped[str] = mapped_column(ForeignKey("customers.id", ondelete="CASCADE"), nullable=False, index=True)
    campaign_id: Mapped[str | None] = mapped_column(ForeignKey("campaigns.id", ondelete="SET NULL"), nullable=True)

    channel: Mapped[Channel] = mapped_column(Enum(Channel, name="communication_channel"), nullable=False)
    sent_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    provider: Mapped[str] = mapped_column(String(50), default="mock", nullable=False)
    success: Mapped[bool] = mapped_column(default=True, nullable=False)
