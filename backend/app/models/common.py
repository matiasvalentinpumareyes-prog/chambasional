from datetime import datetime, timezone
import uuid

from sqlalchemy import DateTime, Numeric
from sqlalchemy.orm import Mapped, mapped_column
from app.models.base import Base  # re-export para compatibilidad

# Tipos de dinero según BD real
Money = Numeric(12, 2)          # ventas, recomendaciones
Money10 = Numeric(10, 2)        # producto_precios
Money14 = Numeric(14, 2)        # ventas, cupones
Money12_3 = Numeric(12, 3)      # venta_items.cantidad
Money12_6 = Numeric(12, 6)      # model_metrics
Money8_5 = Numeric(8, 5)        # puntuaciones, score_churn
Money8_4 = Numeric(8, 4)        # ratio_riesgo


def gen_uuid() -> str:
    return str(uuid.uuid4())


def utcnow() -> datetime:
    return datetime.now(timezone.utc)


class TimestampMixin:
    """Añade created_at / updated_at a cualquier modelo (sección 32)."""

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=utcnow, nullable=False)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=utcnow, onupdate=utcnow, nullable=False
    )
