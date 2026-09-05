import enum
from datetime import datetime

from sqlalchemy import DateTime, Enum, Float, ForeignKey, JSON, String
from sqlalchemy.orm import Mapped, mapped_column

from app.db.session import Base
from app.models.business import gen_uuid
from app.models.common import TimestampMixin


class RiskLevel(str, enum.Enum):
    low = "low"
    medium = "medium"
    high = "high"
    critical = "critical"


class Prediction(Base, TimestampMixin):
    """
    Predicción de churn de un cliente en un momento dado (sección 13).
    Se guarda un registro por cada recálculo, para poder auditar
    predicciones pasadas y saber exactamente qué versión de modelo generó
    cada una (trazabilidad pedida en la sección 48).
    """

    __tablename__ = "predictions"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    business_id: Mapped[str] = mapped_column(ForeignKey("businesses.id", ondelete="CASCADE"), nullable=False, index=True)
    customer_id: Mapped[str] = mapped_column(ForeignKey("customers.id", ondelete="CASCADE"), nullable=False, index=True)

    churn_probability: Mapped[float] = mapped_column(Float, nullable=False)
    churn_score: Mapped[int] = mapped_column(nullable=False)
    risk_level: Mapped[RiskLevel] = mapped_column(Enum(RiskLevel, name="risk_level"), nullable=False, index=True)
    confidence: Mapped[float] = mapped_column(Float, nullable=False)
    reasons: Mapped[list] = mapped_column(JSON, default=list, nullable=False)

    expected_next_purchase_date: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    days_until_expected_purchase: Mapped[int | None] = mapped_column(nullable=True)
    purchase_probability: Mapped[float | None] = mapped_column(Float, nullable=True)

    prediction_date: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    model_version: Mapped[str] = mapped_column(String(50), nullable=False)


class RecommendationMethod(str, enum.Enum):
    rules = "rules"
    collaborative_filtering = "collaborative_filtering"
    frequency = "frequency"
    cold_start = "cold_start"


class Recommendation(Base, TimestampMixin):
    """Recomendación de producto para un cliente (sección 18-19)."""

    __tablename__ = "recommendations"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    business_id: Mapped[str] = mapped_column(ForeignKey("businesses.id", ondelete="CASCADE"), nullable=False, index=True)
    customer_id: Mapped[str] = mapped_column(ForeignKey("customers.id", ondelete="CASCADE"), nullable=False, index=True)
    product_id: Mapped[str] = mapped_column(ForeignKey("products.id", ondelete="CASCADE"), nullable=False, index=True)

    score: Mapped[int] = mapped_column(nullable=False)
    confidence: Mapped[float] = mapped_column(Float, nullable=False)
    reasons: Mapped[list] = mapped_column(JSON, default=list, nullable=False)
    method: Mapped[RecommendationMethod] = mapped_column(Enum(RecommendationMethod, name="recommendation_method"), nullable=False)

    generated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    model_version: Mapped[str] = mapped_column(String(50), nullable=False)


class Strategy(Base, TimestampMixin):
    """
    Estrategia de recuperación generada para un cliente en riesgo
    (secciones 20, 21, 26, 27). Es el resultado final que consume la
    pantalla "¿A quién contactar hoy?" del frontend.
    """

    __tablename__ = "strategies"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    business_id: Mapped[str] = mapped_column(ForeignKey("businesses.id", ondelete="CASCADE"), nullable=False, index=True)
    customer_id: Mapped[str] = mapped_column(ForeignKey("customers.id", ondelete="CASCADE"), nullable=False, index=True)
    prediction_id: Mapped[str | None] = mapped_column(ForeignKey("predictions.id", ondelete="SET NULL"), nullable=True)
    recommended_product_id: Mapped[str | None] = mapped_column(ForeignKey("products.id", ondelete="SET NULL"), nullable=True)

    priority_score: Mapped[int] = mapped_column(nullable=False, index=True)
    recovery_probability: Mapped[float] = mapped_column(Float, nullable=False)
    recommended_action: Mapped[str] = mapped_column(String(20), nullable=False)  # Channel
    recommended_offer: Mapped[str] = mapped_column(String(100), nullable=False)
    recommended_timing: Mapped[str] = mapped_column(String(20), nullable=False)
    reason: Mapped[str] = mapped_column(String(1000), nullable=False)
    message: Mapped[str] = mapped_column(String(1000), nullable=False)
    cooldown_ok: Mapped[bool] = mapped_column(nullable=False, default=True)

    generated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    model_version: Mapped[str] = mapped_column(String(50), nullable=False)
