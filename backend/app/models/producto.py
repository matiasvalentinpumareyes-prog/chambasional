"""Tabla principal producto — controla catálogo comercial.

Tablas:
  categorias (cat_id, emp_id, cat_nombre)
  producto_marca (prd_marca_id, emp_id, prd_marca_nombre)
  producto (prd_id, emp_id, cat_id, prd_marca_id, prd_sku, prd_codbarra, prd_nombre)
  producto_precios (prd_precios_id, emp_id, prd_id, prd_precios, fecha_inicio/fin)

Separado de stock para control independiente de inventario.
Referencia: database_postgres.sql:227-305
"""
import uuid
from datetime import datetime

from sqlalchemy import String, Text, SmallInteger, Numeric, ForeignKey, UniqueConstraint, ForeignKeyConstraint, CheckConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base, TimestampMixin


def gen_uuid() -> str:
    return str(uuid.uuid4())


class Categoria(Base, TimestampMixin):
    __tablename__ = "categorias"
    __table_args__ = (
        UniqueConstraint("emp_id", "cat_nombre", name="uq_categoria_emp_nombre"),
        UniqueConstraint("emp_id", "cat_id", name="uq_categoria_emp_id"),
    )

    cat_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    cat_nombre: Mapped[str] = mapped_column(String(100), nullable=False)
    cat_descripcion: Mapped[str | None] = mapped_column(Text, nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    empresa: Mapped["app.models.empresa.Empresa"] = relationship()


class ProductoMarca(Base, TimestampMixin):
    __tablename__ = "producto_marca"
    __table_args__ = (
        UniqueConstraint("emp_id", "prd_marca_nombre", name="uq_marca_emp_nombre"),
        UniqueConstraint("emp_id", "prd_marca_id", name="uq_marca_emp_id"),
    )

    prd_marca_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    prd_marca_nombre: Mapped[str] = mapped_column(String(100), nullable=False)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)


class Producto(Base, TimestampMixin):
    __tablename__ = "producto"
    __table_args__ = (
        UniqueConstraint("emp_id", "prd_id", name="uq_producto_emp_prd"),
        UniqueConstraint("emp_id", "prd_sku", name="uq_producto_emp_sku"),
        UniqueConstraint("emp_id", "prd_codbarra", name="uq_producto_emp_codbarra"),
        ForeignKeyConstraint(["emp_id", "cat_id"], ["categorias.emp_id", "categorias.cat_id"], name="fk_producto_categoria"),
        ForeignKeyConstraint(["emp_id", "cat_id", "subcat_id"], ["subcategorias.emp_id", "subcategorias.cat_id", "subcategorias.subcat_id"], name="fk_producto_subcategoria"),
        ForeignKeyConstraint(["emp_id", "prd_marca_id"], ["producto_marca.emp_id", "producto_marca.prd_marca_id"], name="fk_producto_marca"),
        CheckConstraint("subcat_id IS NULL OR cat_id IS NOT NULL", name="chk_producto_subcat_requiere_cat"),
    )

    prd_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    cat_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    subcat_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    prd_marca_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    prd_sku: Mapped[str | None] = mapped_column(String(100), nullable=True)
    prd_codbarra: Mapped[str | None] = mapped_column(String(100), nullable=True)
    prd_nombre: Mapped[str] = mapped_column(String(150), nullable=False)
    prd_descripcion: Mapped[str | None] = mapped_column(Text, nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    empresa: Mapped["app.models.empresa.Empresa"] = relationship()
    categoria: Mapped["Categoria | None"] = relationship(foreign_keys="[Producto.emp_id, Producto.cat_id]", overlaps="empresa")
    subcategoria: Mapped["app.models.subcategoria.Subcategoria | None"] = relationship(foreign_keys="[Producto.emp_id, Producto.cat_id, Producto.subcat_id]", overlaps="categoria,empresa")
    marca: Mapped["ProductoMarca | None"] = relationship(foreign_keys="[Producto.emp_id, Producto.prd_marca_id]", overlaps="categoria,empresa,subcategoria")


class ProductoPrecio(Base, TimestampMixin):
    __tablename__ = "producto_precios"
    __table_args__ = (
        UniqueConstraint("emp_id", "prd_precios_id", name="uq_producto_precio_emp_id"),
        ForeignKeyConstraint(["emp_id", "prd_id"], ["producto.emp_id", "producto.prd_id"], name="fk_producto_precio_producto"),
    )

    prd_precios_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(String(36), nullable=False)
    prd_id: Mapped[str] = mapped_column(String(36), nullable=False)
    prd_precios: Mapped[float] = mapped_column(Numeric(10, 2), nullable=False, default=0)
    prd_precios_undmedida: Mapped[str | None] = mapped_column(String(3), nullable=True)
    prd_precios_undproducto: Mapped[str | None] = mapped_column(String(20), nullable=True)
    prd_precios_ganancia: Mapped[float | None] = mapped_column(Numeric(10, 2), nullable=True)
    prd_precios_lista: Mapped[float | None] = mapped_column(Numeric(10, 2), nullable=True)
    prd_precios_costo: Mapped[float | None] = mapped_column(Numeric(10, 2), nullable=True)
    fecha_inicio: Mapped[datetime] = mapped_column(nullable=False)
    fecha_fin: Mapped[datetime | None] = mapped_column(nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    producto: Mapped["Producto"] = relationship(foreign_keys="[ProductoPrecio.emp_id, ProductoPrecio.prd_id]")
