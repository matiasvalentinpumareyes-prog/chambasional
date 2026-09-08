"""
Schemas para subcategorias — hija de categorias.

Tabla: subcategorias (subcat_id, emp_id, cat_id, subcat_nombre, subcat_descripcion)
UNIQUE(cat_id, subcat_nombre), UNIQUE(emp_id, subcat_id), UNIQUE(emp_id, cat_id, subcat_id)
FK(emp_id, cat_id) -> categorias(emp_id, cat_id)

Referencia: database_postgres.sql:243
Nombres exactos BD (español: subcat_id, cat_id, emp_id).
"""
from datetime import datetime

from pydantic import BaseModel, Field


class SubcategoriaBase(BaseModel):
    emp_id: str = Field(..., description="FK empresa.emp_id (tenant)")
    cat_id: str = Field(..., description="FK (emp_id, cat_id) -> categorias")
    subcat_nombre: str = Field(..., min_length=1, max_length=100, description="Nombre único por categoría (uq_subcategoria_cat_nombre)")
    subcat_descripcion: str | None = Field(None, description="Descripción TEXT")

    model_config = {"from_attributes": True}


class SubcategoriaCreate(SubcategoriaBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class SubcategoriaUpdate(BaseModel):
    cat_id: str | None = None
    subcat_nombre: str | None = Field(None, min_length=1, max_length=100)
    subcat_descripcion: str | None = None
    estado: int | None = None

    model_config = {"from_attributes": True}


class SubcategoriaOut(SubcategoriaBase):
    subcat_id: str = Field(..., description="PK UUID")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None
    created_by: str | None = None
    updated_by: str | None = None
    categoria_nombre: str | None = Field(None, description="categorias.cat_nombre resuelto")

    model_config = {"from_attributes": True}
