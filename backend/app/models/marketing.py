import uuid
from datetime import datetime

from sqlalchemy import String, Text, SmallInteger, Integer, Numeric, ForeignKey, UniqueConstraint, ForeignKeyConstraint, JSON
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base, TimestampMixin


def gen_uuid() -> str:
    return str(uuid.uuid4())


class Estrategia(Base, TimestampMixin):
    __tablename__ = "estrategias"
    __table_args__ = (
        UniqueConstraint("emp_id", "est_nombre", name="uq_estrategia_emp_nombre"),
        UniqueConstraint("emp_id", "est_id", name="uq_estrategia_emp_id"),
    )

    est_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    est_nombre: Mapped[str] = mapped_column(String(150), nullable=False)
    est_descripcion: Mapped[str | None] = mapped_column(Text, nullable=True)
    est_objetivo: Mapped[str | None] = mapped_column(String(100), nullable=True)
    est_action_type: Mapped[str | None] = mapped_column(String(50), nullable=True)
    configuracion: Mapped[dict | None] = mapped_column(JSON, nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    rules: Mapped[list["Rule"]] = relationship(back_populates="estrategia")


class Rule(Base, TimestampMixin):
    __tablename__ = "rules"
    __table_args__ = (
        UniqueConstraint("emp_id", "rle_nombre", name="uq_rule_emp_nombre"),
        ForeignKeyConstraint(["emp_id", "est_id"], ["estrategias.emp_id", "estrategias.est_id"], name="fk_rule_estrategia"),
    )

    rle_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    est_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    rle_nombre: Mapped[str] = mapped_column(String(150), nullable=False)
    rle_descripcion: Mapped[str | None] = mapped_column(Text, nullable=True)
    rle_rule_type: Mapped[str] = mapped_column(String(50), nullable=False)
    rle_condiciones: Mapped[dict] = mapped_column(JSON, nullable=False)
    rle_acciones: Mapped[dict | None] = mapped_column(JSON, nullable=True)
    rle_prioridad: Mapped[int] = mapped_column(Integer, default=1, nullable=False)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    estrategia: Mapped["Estrategia | None"] = relationship(back_populates="rules", foreign_keys="[Rule.emp_id, Rule.est_id]")


class Cupon(Base, TimestampMixin):
    __tablename__ = "cupones"
    __table_args__ = (
        UniqueConstraint("emp_id", "cup_codigo", name="uq_cupon_emp_codigo"),
        UniqueConstraint("emp_id", "cup_id", name="uq_cupon_emp_id"),
    )

    cup_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    cup_codigo: Mapped[str] = mapped_column(String(80), nullable=False)
    cup_nombre: Mapped[str] = mapped_column(String(150), nullable=False)
    cup_tipo: Mapped[str] = mapped_column(String(20), nullable=False)
    cup_valor: Mapped[float] = mapped_column(Numeric(14, 2), default=0, nullable=False)
    cup_min_compra: Mapped[float | None] = mapped_column(Numeric(14, 2), nullable=True)
    cup_max_descuento: Mapped[float | None] = mapped_column(Numeric(14, 2), nullable=True)
    cup_limite_uso_total: Mapped[int | None] = mapped_column(Integer, nullable=True)
    cup_limite_uso_cliente: Mapped[int | None] = mapped_column(Integer, default=1, nullable=True)
    cup_usos_actuales: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    fecha_inicio: Mapped[datetime] = mapped_column(nullable=False)
    fecha_fin: Mapped[datetime | None] = mapped_column(nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)


class Recomendacion(Base, TimestampMixin):
    __tablename__ = "recomendaciones"
    __table_args__ = (
        UniqueConstraint("emp_id", "rec_id", name="uq_recomendacion_emp_id"),
        ForeignKeyConstraint(["emp_id", "cli_id"], ["cliente.emp_id", "cliente.cli_id"], name="fk_recomendacion_cliente"),
        ForeignKeyConstraint(["emp_id", "est_id"], ["estrategias.emp_id", "estrategias.est_id"], name="fk_recomendacion_estrategia"),
        ForeignKeyConstraint(["emp_id", "pdc_id"], ["predicciones.emp_id", "predicciones.pdc_id"], name="fk_recomendacion_prediccion"),
        ForeignKeyConstraint(["emp_id", "prd_id"], ["producto.emp_id", "producto.prd_id"], name="fk_recomendacion_producto"),
        ForeignKeyConstraint(["emp_id", "cup_id"], ["cupones.emp_id", "cupones.cup_id"], name="fk_recomendacion_cupon"),
    )

    rec_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    cli_id: Mapped[str] = mapped_column(String(36), nullable=False)
    est_id: Mapped[str] = mapped_column(String(36), nullable=False)
    pdc_id: Mapped[str] = mapped_column(String(36), nullable=False)
    prd_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    cup_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    rec_titulo: Mapped[str] = mapped_column(String(200), nullable=False)
    rec_descripcion: Mapped[str | None] = mapped_column(Text, nullable=True)
    prioridad: Mapped[int] = mapped_column(Integer, default=1, nullable=False)
    rec_accion_recomendada: Mapped[str | None] = mapped_column(Text, nullable=True)
    recommended_offer: Mapped[float | None] = mapped_column(Numeric(14, 2), nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    expires_at: Mapped[datetime | None] = mapped_column(nullable=True)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)


class CuponCanje(Base, TimestampMixin):
    __tablename__ = "cupon_canjes"
    __table_args__ = (
        UniqueConstraint("emp_id", "cup_id", "cli_id", "venta_id", name="uq_cupon_canje_cliente_venta"),
        ForeignKeyConstraint(["emp_id", "cup_id"], ["cupones.emp_id", "cupones.cup_id"], name="fk_canje_cupon"),
        ForeignKeyConstraint(["emp_id", "cli_id"], ["cliente.emp_id", "cliente.cli_id"], name="fk_canje_cliente"),
        ForeignKeyConstraint(["emp_id", "venta_id"], ["ventas.emp_id", "ventas.venta_id"], name="fk_canje_venta"),
        ForeignKeyConstraint(["emp_id", "cpg_recipient_id"], ["campaign_recipients.emp_id", "campaign_recipients.cpg_recipient_id"], name="fk_canje_recipient"),
    )

    ccn_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    cup_id: Mapped[str] = mapped_column(String(36), nullable=False)
    cli_id: Mapped[str] = mapped_column(String(36), nullable=False)
    venta_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    cpg_recipient_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    fecha_canjes: Mapped[datetime] = mapped_column(nullable=False)
    importe_descuento: Mapped[float] = mapped_column(Numeric(14, 2), default=0, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
