import uuid
from datetime import datetime

from sqlalchemy import String, SmallInteger, Numeric, ForeignKey, UniqueConstraint, ForeignKeyConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base, TimestampMixin


def gen_uuid() -> str:
    return str(uuid.uuid4())


class Venta(Base, TimestampMixin):
    __tablename__ = "ventas"
    __table_args__ = (
        UniqueConstraint("emp_id", "venta_id", name="uq_venta_emp_id"),
        ForeignKeyConstraint(["emp_id", "cli_id"], ["cliente.emp_id", "cliente.cli_id"], name="fk_ventas_cliente"),
    )

    venta_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    cli_id: Mapped[str] = mapped_column(String(36), nullable=False)
    ven_descuento: Mapped[float] = mapped_column(Numeric(14, 2), default=0, nullable=False)
    ven_total: Mapped[float] = mapped_column(Numeric(14, 2), default=0, nullable=False)
    mtp_id: Mapped[str | None] = mapped_column(ForeignKey("metodos_pago.mtp_id"), nullable=True)
    cupon_id: Mapped[str | None] = mapped_column(String(36), nullable=True)  # FK diferida a cupones(emp_id,cup_id)
    venta_origen: Mapped[str | None] = mapped_column(String(50), nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    cliente: Mapped["app.models.cliente.Cliente"] = relationship(foreign_keys="[Venta.emp_id, Venta.cli_id]")
    metodo_pago: Mapped["app.models.catalogs.MetodoPago | None"] = relationship()
    items: Mapped[list["VentaItem"]] = relationship(back_populates="venta", cascade="all, delete-orphan")


class VentaItem(Base, TimestampMixin):
    __tablename__ = "venta_items"
    __table_args__ = (
        UniqueConstraint("emp_id", "ven_item_id", name="uq_venta_item_emp_id"),
        ForeignKeyConstraint(["emp_id", "venta_id"], ["ventas.emp_id", "ventas.venta_id"], name="fk_venta_item_venta"),
        ForeignKeyConstraint(["emp_id", "prd_id"], ["producto.emp_id", "producto.prd_id"], name="fk_venta_item_producto"),
    )

    ven_item_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(String(36), nullable=False)
    venta_id: Mapped[str] = mapped_column(String(36), nullable=False)
    prd_id: Mapped[str] = mapped_column(String(36), nullable=False)
    cantidad: Mapped[float] = mapped_column(Numeric(12, 3), default=1.0, nullable=False)
    precio_unitario: Mapped[float] = mapped_column(Numeric(14, 2), default=0, nullable=False)
    descuento: Mapped[float] = mapped_column(Numeric(14, 2), default=0, nullable=False)
    subtotal: Mapped[float] = mapped_column(Numeric(14, 2), default=0, nullable=False)
    costo_unitario: Mapped[float | None] = mapped_column(Numeric(14, 2), nullable=True)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    venta: Mapped["Venta"] = relationship(back_populates="items", foreign_keys="[VentaItem.emp_id, VentaItem.venta_id]")
    producto: Mapped["app.models.comercio.Producto"] = relationship(foreign_keys="[VentaItem.emp_id, VentaItem.prd_id]", overlaps="venta,items")
