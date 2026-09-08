"""Tabla principal producto_stock — control de inventario.

Tabla: producto_stock (stock_id, emp_id, prd_id, stk_cantidad Numeric(10,2), stk_min Int, stk_max Int)
1:1 por (emp_id, prd_id) con UNIQUE uq_producto_stock_producto.
Separado de producto para control independiente de stock (entradas/salidas, alertas).

Referencia: database_postgres.sql:307-324
"""
import uuid

from sqlalchemy import String, SmallInteger, Integer, Numeric, UniqueConstraint, ForeignKeyConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base, TimestampMixin


def gen_uuid() -> str:
    return str(uuid.uuid4())


class ProductoStock(Base, TimestampMixin):
    __tablename__ = "producto_stock"
    __table_args__ = (
        UniqueConstraint("emp_id", "prd_id", name="uq_producto_stock_producto"),
        UniqueConstraint("emp_id", "stock_id", name="uq_producto_stock_id"),
        ForeignKeyConstraint(["emp_id", "prd_id"], ["producto.emp_id", "producto.prd_id"], name="fk_producto_stock_producto"),
    )

    stock_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(String(36), nullable=False)
    prd_id: Mapped[str] = mapped_column(String(36), nullable=False)
    stk_cantidad: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False, default=0)
    stk_min: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    stk_max: Mapped[int | None] = mapped_column(Integer, nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    producto: Mapped["app.models.producto.Producto"] = relationship(foreign_keys="[ProductoStock.emp_id, ProductoStock.prd_id]")
