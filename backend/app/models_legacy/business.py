import enum
import uuid

from sqlalchemy import Boolean, Enum, ForeignKey, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.session import Base
from app.models.common import TimestampMixin


def gen_uuid() -> str:
    return str(uuid.uuid4())


class UserRole(str, enum.Enum):
    admin = "admin"
    business_user = "business_user"


class Business(Base, TimestampMixin):
    """
    Representa a un negocio (multi-tenancy, sección 33). Toda entidad de
    negocio en el sistema se relaciona con un business_id, y el backend
    filtra SIEMPRE por ese campo en cada consulta — nunca se confía
    solamente en el frontend para el aislamiento entre negocios.
    """

    __tablename__ = "businesses"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    name: Mapped[str] = mapped_column(String(200), nullable=False)
    currency: Mapped[str] = mapped_column(String(3), default="PEN", nullable=False)
    timezone: Mapped[str] = mapped_column(String(50), default="America/Lima", nullable=False)
    analysis_window_days: Mapped[int] = mapped_column(Integer, default=365, nullable=False)
    churn_threshold_medium: Mapped[int] = mapped_column(Integer, default=30, nullable=False)
    churn_threshold_high: Mapped[int] = mapped_column(Integer, default=60, nullable=False)
    churn_threshold_critical: Mapped[int] = mapped_column(Integer, default=80, nullable=False)
    campaign_cooldown_days: Mapped[int] = mapped_column(Integer, default=7, nullable=False)
    language: Mapped[str] = mapped_column(String(2), default="es", nullable=False)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)

    users: Mapped[list["User"]] = relationship(back_populates="business")


class User(Base, TimestampMixin):
    __tablename__ = "users"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    business_id: Mapped[str] = mapped_column(ForeignKey("businesses.id", ondelete="CASCADE"), nullable=False, index=True)
    name: Mapped[str] = mapped_column(String(200), nullable=False)
    email: Mapped[str] = mapped_column(String(255), unique=True, nullable=False, index=True)
    hashed_password: Mapped[str] = mapped_column(String(255), nullable=False)
    role: Mapped[UserRole] = mapped_column(Enum(UserRole, name="user_role"), default=UserRole.business_user, nullable=False)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)

    business: Mapped["Business"] = relationship(back_populates="users")
