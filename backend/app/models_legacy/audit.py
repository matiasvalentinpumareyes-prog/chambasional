import enum
from datetime import datetime

from sqlalchemy import DateTime, Enum, ForeignKey, JSON, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.session import Base
from app.models.business import gen_uuid
from app.models.common import TimestampMixin


class ImportType(str, enum.Enum):
    customers = "customers"
    products = "products"
    sales = "sales"


class ImportStatus(str, enum.Enum):
    pending_confirmation = "pending_confirmation"
    confirmed = "confirmed"
    cancelled = "cancelled"


class Import(Base, TimestampMixin):
    __tablename__ = "imports"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    business_id: Mapped[str] = mapped_column(ForeignKey("businesses.id", ondelete="CASCADE"), nullable=False, index=True)
    user_id: Mapped[str | None] = mapped_column(ForeignKey("users.id", ondelete="SET NULL"), nullable=True)

    file_name: Mapped[str] = mapped_column(String(255), nullable=False)
    type: Mapped[ImportType] = mapped_column(Enum(ImportType, name="import_type"), nullable=False)
    total_rows: Mapped[int] = mapped_column(nullable=False)
    accepted_rows: Mapped[int] = mapped_column(nullable=False)
    rejected_rows: Mapped[int] = mapped_column(nullable=False)
    status: Mapped[ImportStatus] = mapped_column(Enum(ImportStatus, name="import_status"), default=ImportStatus.pending_confirmation, nullable=False)

    errors: Mapped[list["ImportRowError"]] = relationship(back_populates="import_", cascade="all, delete-orphan")


class ImportRowError(Base, TimestampMixin):
    __tablename__ = "import_errors"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    import_id: Mapped[str] = mapped_column(ForeignKey("imports.id", ondelete="CASCADE"), nullable=False, index=True)
    row: Mapped[int] = mapped_column(nullable=False)
    field: Mapped[str | None] = mapped_column(String(100), nullable=True)
    message: Mapped[str] = mapped_column(String(500), nullable=False)
    severity: Mapped[str] = mapped_column(String(20), default="error", nullable=False)  # "error" | "warning"

    import_: Mapped["Import"] = relationship(back_populates="errors")


class ModelStatus(str, enum.Enum):
    training = "training"
    candidate = "candidate"
    production = "production"
    deprecated = "deprecated"
    failed = "failed"


class ModelVersion(Base, TimestampMixin):
    """Versionado de modelos ML (sección 48). Nunca se sobrescribe: cada
    entrenamiento crea una fila nueva, y solo se promueve a "production"
    si supera al modelo actual (sección 47)."""

    __tablename__ = "model_versions"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    business_id: Mapped[str] = mapped_column(ForeignKey("businesses.id", ondelete="CASCADE"), nullable=False, index=True)

    model_name: Mapped[str] = mapped_column(String(100), nullable=False)
    version: Mapped[str] = mapped_column(String(50), nullable=False)
    training_date: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    dataset_version: Mapped[str] = mapped_column(String(50), nullable=False)
    features: Mapped[list] = mapped_column(JSON, default=list, nullable=False)
    status: Mapped[ModelStatus] = mapped_column(Enum(ModelStatus, name="model_status"), default=ModelStatus.training, nullable=False, index=True)
    file_path: Mapped[str | None] = mapped_column(String(500), nullable=True)

    metrics: Mapped[list["ModelMetric"]] = relationship(back_populates="model_version", cascade="all, delete-orphan")


class ModelMetric(Base, TimestampMixin):
    __tablename__ = "model_metrics"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    model_version_id: Mapped[str] = mapped_column(ForeignKey("model_versions.id", ondelete="CASCADE"), nullable=False, index=True)
    name: Mapped[str] = mapped_column(String(50), nullable=False)  # accuracy, precision, recall, f1, roc_auc, pr_auc
    value: Mapped[float] = mapped_column(nullable=False)

    model_version: Mapped["ModelVersion"] = relationship(back_populates="metrics")


class Rule(Base, TimestampMixin):
    """
    Motor de reglas configurable (sección 21). Cada regla se guarda como
    una condición estructurada (JSON) y una acción, para poder editarse
    desde el backend/configuración sin tocar código ni el frontend.
    """

    __tablename__ = "rules"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    business_id: Mapped[str] = mapped_column(ForeignKey("businesses.id", ondelete="CASCADE"), nullable=False, index=True)

    name: Mapped[str] = mapped_column(String(200), nullable=False)
    conditions: Mapped[dict] = mapped_column(JSON, nullable=False)
    action: Mapped[dict] = mapped_column(JSON, nullable=False)
    priority: Mapped[int] = mapped_column(default=100, nullable=False)
    is_active: Mapped[bool] = mapped_column(default=True, nullable=False)


class AuditLog(Base, TimestampMixin):
    """Auditoría de acciones importantes (sección 51)."""

    __tablename__ = "audit_logs"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    business_id: Mapped[str | None] = mapped_column(ForeignKey("businesses.id", ondelete="SET NULL"), nullable=True, index=True)
    user_id: Mapped[str | None] = mapped_column(ForeignKey("users.id", ondelete="SET NULL"), nullable=True)

    action: Mapped[str] = mapped_column(String(100), nullable=False)
    entity: Mapped[str] = mapped_column(String(100), nullable=False)
    entity_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    ip_address: Mapped[str | None] = mapped_column(String(50), nullable=True)
    result: Mapped[str] = mapped_column(String(20), default="success", nullable=False)
    metadata_json: Mapped[dict | None] = mapped_column(JSON, nullable=True)
