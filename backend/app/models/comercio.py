import uuid
from datetime import datetime

from sqlalchemy import String, Text, SmallInteger, Integer, Numeric, ForeignKey, UniqueConstraint, ForeignKeyConstraint
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
        ForeignKeyConstraint(["emp_id", "prd_marca_id"], ["producto_marca.emp_id", "producto_marca.prd_marca_id"], name="fk_producto_marca"),
    )

    prd_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    cat_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
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
    marca: Mapped["ProductoMarca | None"] = relationship(foreign_keys="[Producto.emp_id, Producto.prd_marca_id]", overlaps="categoria,empresa")

    @property
    def margin_pct(self) -> float | None:
        # No se persiste; cálculo a partir de precio vigente (producto_precios) si se desea.
        return None


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

    producto: Mapped["Producto"] = relationship(foreign_keys="[ProductoStock.emp_id, ProductoStock.prd_id]")
