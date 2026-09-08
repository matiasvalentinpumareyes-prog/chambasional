import uuid
from datetime import datetime, timezone

from sqlalchemy import DateTime
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column


def gen_uuid() -> str:
    return str(uuid.uuid4())


def utcnow() -> datetime:
    return datetime.now(timezone.utc)


class Base(DeclarativeBase):
    """Clase base declarativa — todas las tablas heredan de aquí."""
    pass


class TimestampMixin:
    """Mixin con created_at / updated_at idéntico a database_postgres.sql (TIMESTAMP DEFAULT CURRENT_TIMESTAMP + trigger set_updated_at)."""
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=utcnow, nullable=False)
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=utcnow, onupdate=utcnow, nullable=False)
