import uuid
from datetime import datetime

from sqlalchemy import String, Text, SmallInteger, Numeric, ForeignKey, UniqueConstraint, ForeignKeyConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base, TimestampMixin


def gen_uuid() -> str:
    return str(uuid.uuid4())


class Campaign(Base, TimestampMixin):
    __tablename__ = "campaigns"
    __table_args__ = (
        UniqueConstraint("emp_id", "cpg_id", name="uq_campaign_emp_id"),
        UniqueConstraint("emp_id", "cpg_name", name="uq_campaign_emp_nombre"),
        ForeignKeyConstraint(["emp_id", "est_id"], ["estrategias.emp_id", "estrategias.est_id"], name="fk_campaign_estrategia"),
    )

    cpg_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    est_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    can_id: Mapped[str] = mapped_column(ForeignKey("canales_marketing.can_id"), nullable=False)
    cpg_name: Mapped[str] = mapped_column(String(150), nullable=False)
    cpg_description: Mapped[str | None] = mapped_column(Text, nullable=True)
    cpg_subject: Mapped[str | None] = mapped_column(String(200), nullable=True)
    cpg_content: Mapped[str | None] = mapped_column(Text, nullable=True)
    cpg_budget: Mapped[float] = mapped_column(Numeric(14, 2), default=0, nullable=False)
    start_date: Mapped[datetime | None] = mapped_column(nullable=True)
    end_date: Mapped[datetime | None] = mapped_column(nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=3, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    canal: Mapped["app.models.catalogs.CanalMarketing"] = relationship()
    estrategia: Mapped["app.models.marketing.Estrategia | None"] = relationship(foreign_keys="[Campaign.emp_id, Campaign.est_id]")
    recipients: Mapped[list["CampaignRecipient"]] = relationship(back_populates="campaign", cascade="all, delete-orphan")


class CampaignRecipient(Base, TimestampMixin):
    __tablename__ = "campaign_recipients"
    __table_args__ = (
        UniqueConstraint("emp_id", "cpg_recipient_id", name="uq_campaign_recipient_emp_id"),
        UniqueConstraint("emp_id", "cpg_id", "cli_id", name="uq_campaign_recipient_cliente"),
        ForeignKeyConstraint(["emp_id", "cpg_id"], ["campaigns.emp_id", "campaigns.cpg_id"], name="fk_campaign_recipient_campaign"),
        ForeignKeyConstraint(["emp_id", "cli_id"], ["cliente.emp_id", "cliente.cli_id"], name="fk_campaign_recipient_cliente"),
        ForeignKeyConstraint(["emp_id", "rec_id"], ["recomendaciones.emp_id", "recomendaciones.rec_id"], name="fk_campaign_recipient_recomendacion"),
        ForeignKeyConstraint(["emp_id", "venta_id"], ["ventas.emp_id", "ventas.venta_id"], name="fk_campaign_recipient_venta"),
    )

    cpg_recipient_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    cpg_id: Mapped[str] = mapped_column(String(36), nullable=False)
    cli_id: Mapped[str] = mapped_column(String(36), nullable=False)
    can_id: Mapped[str] = mapped_column(ForeignKey("canales_marketing.can_id"), nullable=False)
    rec_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=2, nullable=False)
    sent_at: Mapped[datetime | None] = mapped_column(nullable=True)
    delivered_at: Mapped[datetime | None] = mapped_column(nullable=True)
    opened_at: Mapped[datetime | None] = mapped_column(nullable=True)
    clicked_at: Mapped[datetime | None] = mapped_column(nullable=True)
    converted_at: Mapped[datetime | None] = mapped_column(nullable=True)
    venta_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    conversion_value: Mapped[float | None] = mapped_column(Numeric(14, 2), nullable=True)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    campaign: Mapped["Campaign"] = relationship(back_populates="recipients", foreign_keys="[CampaignRecipient.emp_id, CampaignRecipient.cpg_id]")
    canal: Mapped["app.models.catalogs.CanalMarketing"] = relationship()


class Comunicacion(Base, TimestampMixin):
    __tablename__ = "communicaciones"
    __table_args__ = (
        ForeignKeyConstraint(["emp_id", "cli_id"], ["cliente.emp_id", "cliente.cli_id"], name="fk_comunicacion_cliente"),
        ForeignKeyConstraint(["emp_id", "cpg_recipient_id"], ["campaign_recipients.emp_id", "campaign_recipients.cpg_recipient_id"], name="fk_comunicacion_recipient"),
        ForeignKeyConstraint(["emp_id", "venta_id"], ["ventas.emp_id", "ventas.venta_id"], name="fk_comunicacion_venta"),
    )

    com_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    cli_id: Mapped[str] = mapped_column(String(36), nullable=False)
    cpg_recipient_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    can_id: Mapped[str] = mapped_column(ForeignKey("canales_marketing.can_id"), nullable=False)
    com_asunto: Mapped[str | None] = mapped_column(String(200), nullable=True)
    com_contenido: Mapped[str] = mapped_column(Text, nullable=False)
    provider_message_id: Mapped[str | None] = mapped_column(String(150), nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=2, nullable=False)
    sent_at: Mapped[datetime | None] = mapped_column(nullable=True)
    delivered_at: Mapped[datetime | None] = mapped_column(nullable=True)
    opened_at: Mapped[datetime | None] = mapped_column(nullable=True)
    clicked_at: Mapped[datetime | None] = mapped_column(nullable=True)
    converted_at: Mapped[datetime | None] = mapped_column(nullable=True)
    venta_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    canal: Mapped["app.models.catalogs.CanalMarketing"] = relationship()
