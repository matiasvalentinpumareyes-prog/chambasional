"""
Schemas para catálogo producto — tablas principales y auxiliares.

Tablas principales:
  producto (prd_id, emp_id, cat_id, prd_marca_id, prd_sku, prd_codbarra, prd_nombre)
Auxiliares:
  categorias (cat_id, cat_nombre)
  producto_marca (prd_marca_id, prd_marca_nombre)
  producto_precios (prd_precios_id, prd_precios, fecha_inicio/fin)

Separado de stock para control independiente (producto_stock en stock.py).

Referencia: database_postgres.sql:227-305
Nombres exactos BD (español donde la BD es español: prd_id, cat_id, stock_id).
"""
from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, Field


# ---------------------------------------------------------------------------
# Categorias
# ---------------------------------------------------------------------------

class CategoriaBase(BaseModel):
    emp_id: str = Field(..., description="FK empresa.emp_id (tenant)")
    cat_nombre: str = Field(..., min_length=1, max_length=100, description="Nombre único por empresa (uq_categoria_emp_nombre)")
    cat_descripcion: str | None = Field(None, description="Descripción TEXT")
    model_config = {"from_attributes": True}


class CategoriaCreate(CategoriaBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class CategoriaUpdate(BaseModel):
    cat_nombre: str | None = Field(None, min_length=1, max_length=100)
    cat_descripcion: str | None = None
    estado: int | None = None
    model_config = {"from_attributes": True}


class CategoriaOut(CategoriaBase):
    cat_id: str = Field(..., description="PK UUID")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None
    created_by: str | None = None
    updated_by: str | None = None
    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Producto marca
# ---------------------------------------------------------------------------

class ProductoMarcaBase(BaseModel):
    emp_id: str = Field(..., description="FK empresa.emp_id")
    prd_marca_nombre: str = Field(..., min_length=1, max_length=100, description="Nombre marca único por empresa (uq_marca_emp_nombre)")
    model_config = {"from_attributes": True}


class ProductoMarcaCreate(ProductoMarcaBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class ProductoMarcaUpdate(BaseModel):
    prd_marca_nombre: str | None = Field(None, min_length=1, max_length=100)
    estado: int | None = None
    model_config = {"from_attributes": True}


class ProductoMarcaOut(ProductoMarcaBase):
    prd_marca_id: str = Field(..., description="PK UUID")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None
    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Producto
# ---------------------------------------------------------------------------

class ProductoBase(BaseModel):
    emp_id: str = Field(..., description="Tenant empresa.emp_id")
    cat_id: str | None = Field(None, description="FK (emp_id, cat_id) -> categorias")
    prd_marca_id: str | None = Field(None, description="FK (emp_id, prd_marca_id) -> producto_marca")
    prd_sku: str | None = Field(None, max_length=100, description="SKU único por empresa (uq_producto_emp_sku)")
    prd_codbarra: str | None = Field(None, max_length=100, description="Código barras (uq_producto_emp_codbarra)")
    prd_nombre: str = Field(..., min_length=1, max_length=150, description="Nombre comercial")
    prd_descripcion: str | None = Field(None, description="TEXT")
    model_config = {"from_attributes": True}


class ProductoCreate(ProductoBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class ProductoUpdate(BaseModel):
    cat_id: str | None = None
    prd_marca_id: str | None = None
    prd_sku: str | None = Field(None, max_length=100)
    prd_codbarra: str | None = Field(None, max_length=100)
    prd_nombre: str | None = Field(None, min_length=1, max_length=150)
    prd_descripcion: str | None = None
    estado: int | None = None
    model_config = {"from_attributes": True}


class ProductoOut(ProductoBase):
    prd_id: str = Field(..., description="PK UUID")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None
    categoria_nombre: str | None = None
    marca_nombre: str | None = None
    precio_vigente: Decimal | None = Field(None, description="Precio vigente de producto_precios.fecha_fin IS NULL")
    costo_vigente: Decimal | None = None
    stk_cantidad: Decimal | None = Field(None, description="Stock actual de producto_stock")
    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Producto precios — histórico con vigencia
# ---------------------------------------------------------------------------

class ProductoPrecioBase(BaseModel):
    emp_id: str = Field(..., description="Tenant")
    prd_id: str = Field(..., description="FK (emp_id, prd_id) -> producto")
    prd_precios: Decimal = Field(..., ge=0, description="Precio venta DECIMAL(10,2)")
    prd_precios_undmedida: str | None = Field(None, max_length=3, description="CHAR(3) ej UND, KG")
    prd_precios_undproducto: str | None = Field(None, max_length=20)
    prd_precios_ganancia: Decimal | None = Field(None, description="Ganancia DECIMAL(10,2)")
    prd_precios_lista: Decimal | None = Field(None, description="Precio lista")
    prd_precios_costo: Decimal | None = Field(None, description="Costo")
    fecha_inicio: datetime = Field(..., description="Inicio vigencia DEFAULT CURRENT_TIMESTAMP")
    fecha_fin: datetime | None = Field(None, description="Fin vigencia NULL = vigente")
    model_config = {"from_attributes": True}


class ProductoPrecioCreate(ProductoPrecioBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class ProductoPrecioUpdate(BaseModel):
    prd_precios: Decimal | None = Field(None, ge=0)
    prd_precios_undmedida: str | None = Field(None, max_length=3)
    prd_precios_undproducto: str | None = Field(None, max_length=20)
    prd_precios_ganancia: Decimal | None = None
    prd_precios_lista: Decimal | None = None
    prd_precios_costo: Decimal | None = None
    fecha_inicio: datetime | None = None
    fecha_fin: datetime | None = None
    estado: int | None = None
    model_config = {"from_attributes": True}


class ProductoPrecioOut(ProductoPrecioBase):
    prd_precios_id: str = Field(..., description="PK UUID")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None
    model_config = {"from_attributes": True}
