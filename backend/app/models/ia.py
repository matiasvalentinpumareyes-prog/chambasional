import uuid
from datetime import datetime

from sqlalchemy import String, Text, SmallInteger, Numeric, ForeignKey, UniqueConstraint, ForeignKeyConstraint, JSON
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base, TimestampMixin


def gen_uuid() -> str:
    return str(uuid.uuid4())


class VersionModelo(Base, TimestampMixin):
    __tablename__ = "version_modelo"
    __table_args__ = (
        UniqueConstraint("emp_id", "vrm_name", "vrm_version", name="uq_modelo_emp_version"),
        UniqueConstraint("emp_id", "vrm_id", name="uq_modelo_emp_id"),
    )

    vrm_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    vrm_name: Mapped[str] = mapped_column(String(100), nullable=False)
    vrm_version: Mapped[str] = mapped_column(String(50), nullable=False)
    vrm_algorithm: Mapped[str | None] = mapped_column(String(100), nullable=True)
    trained_at: Mapped[datetime | None] = mapped_column(nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    metadata_json: Mapped[dict | None] = mapped_column("metadata", JSON, nullable=True)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    empresa: Mapped["app.models.empresa.Empresa"] = relationship()
    metrics: Mapped[list["ModelMetric"]] = relationship(back_populates="version_modelo", cascade="all, delete-orphan")


class ModelMetric(Base, TimestampMixin):
    __tablename__ = "model_metrics"
    __table_args__ = (
        ForeignKeyConstraint(["emp_id", "vrm_id"], ["version_modelo.emp_id", "version_modelo.vrm_id"], name="fk_model_metrics_modelo"),
    )

    mdm_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    vrm_id: Mapped[str] = mapped_column(String(36), nullable=False)
    mdm_metric_name: Mapped[str] = mapped_column(String(100), nullable=False)
    mdm_metric_value: Mapped[float] = mapped_column(Numeric(12, 6), nullable=False)
    evaluation_date: Mapped[datetime] = mapped_column(nullable=False)
    metadata_json: Mapped[dict | None] = mapped_column("metadata", JSON, nullable=True)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    version_modelo: Mapped["VersionModelo"] = relationship(back_populates="metrics", foreign_keys="[ModelMetric.emp_id, ModelMetric.vrm_id]")


class Prediccion(Base, TimestampMixin):
    __tablename__ = "predicciones"
    __table_args__ = (
        UniqueConstraint("emp_id", "pdc_id", name="uq_prediccion_emp_id"),
        ForeignKeyConstraint(["emp_id", "cli_id"], ["cliente.emp_id", "cliente.cli_id"], name="fk_predicciones_cliente"),
        ForeignKeyConstraint(["emp_id", "vrm_id"], ["version_modelo.emp_id", "version_modelo.vrm_id"], name="fk_predicciones_modelo"),
    )

    pdc_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    cli_id: Mapped[str] = mapped_column(String(36), nullable=False)
    vrm_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    pdc_tipo_prediccion: Mapped[str] = mapped_column(String(50), nullable=False)
    pdc_prob_abandono: Mapped[float | None] = mapped_column(Numeric(8, 5), nullable=True)
    pdc_valor: Mapped[float | None] = mapped_column(Numeric(14, 2), nullable=True)
    pdc_fecha: Mapped[datetime] = mapped_column(nullable=False)
    expires_at: Mapped[datetime | None] = mapped_column(nullable=True)
    metadata_json: Mapped[dict | None] = mapped_column("metadata", JSON, nullable=True)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    cliente: Mapped["app.models.cliente.Cliente"] = relationship(foreign_keys="[Prediccion.emp_id, Prediccion.cli_id]")
    version_modelo: Mapped["VersionModelo | None"] = relationship(foreign_keys="[Prediccion.emp_id, Prediccion.vrm_id]", overlaps="cliente")
    explicaciones: Mapped[list["app.models.cliente.PrediccionExplicacion"]] = relationship(overlaps="cliente,version_modelo")
