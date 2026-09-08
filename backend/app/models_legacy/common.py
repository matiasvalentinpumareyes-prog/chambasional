from datetime import datetime, timezone

from sqlalchemy import DateTime, Numeric
from sqlalchemy.orm import Mapped, mapped_column

# Tipo de columna para dinero: NUMERIC(12,2), nunca float (sección 72 del brief).
# 12 dígitos totales, 2 decimales -> soporta hasta 9,999,999,999.99.
Money = Numeric(12, 2)


def utcnow() -> datetime:
    return datetime.now(timezone.utc)


class TimestampMixin:
    """Añade created_at / updated_at a cualquier modelo (sección 32)."""

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=utcnow, nullable=False)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=utcnow, onupdate=utcnow, nullable=False
    )
