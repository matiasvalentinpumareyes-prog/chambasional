"""Tabla subcategorias — hija de categorias, padre de producto.

Tabla: subcategorias (subcat_id, emp_id, cat_id, subcat_nombre, subcat_descripcion)
UNIQUE(cat_id, subcat_nombre), UNIQUE(emp_id,subcat_id), UNIQUE(emp_id,cat_id,subcat_id)
FK(emp_id,cat_id)->categorias(emp_id,cat_id)

Referencia: database_postgres.sql:243
Nombres exactos BD (español: subcat_id, cat_id, emp_id).
"""
import uuid

from sqlalchemy import String, Text, SmallInteger, ForeignKey, UniqueConstraint, ForeignKeyConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base, TimestampMixin


def gen_uuid() -> str:
    return str(uuid.uuid4())


class Subcategoria(Base, TimestampMixin):
    __tablename__ = "subcategorias"
    __table_args__ = (
        UniqueConstraint("cat_id", "subcat_nombre", name="uq_subcategoria_cat_nombre"),
        UniqueConstraint("emp_id", "subcat_id", name="uq_subcategoria_emp_id"),
        UniqueConstraint("emp_id", "cat_id", "subcat_id", name="uq_subcategoria_emp_cat_id"),
        ForeignKeyConstraint(["emp_id", "cat_id"], ["categorias.emp_id", "categorias.cat_id"], name="fk_subcategoria_categoria"),
    )

    subcat_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    cat_id: Mapped[str] = mapped_column(String(36), nullable=False)
    subcat_nombre: Mapped[str] = mapped_column(String(100), nullable=False)
    subcat_descripcion: Mapped[str | None] = mapped_column(Text, nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    categoria: Mapped["app.models.producto.Categoria"] = relationship(foreign_keys="[Subcategoria.emp_id, Subcategoria.cat_id]")
