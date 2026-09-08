"""
Schemas para stock — tabla principal producto_stock.

Tabla:
  producto_stock (stock_id, emp_id, prd_id, stk_cantidad Numeric(10,2), stk_min Int, stk_max Int)
1:1 por (emp_id, prd_id) UNIQUE uq_producto_stock_producto.

Separado de producto para control independiente de inventario.
Referencia: database_postgres.sql:307-324
Nombres exactos BD (español: stock_id, stk_cantidad, stk_min, stk_max).
"""
from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, Field


class ProductoStockBase(BaseModel):
    emp_id: str = Field(..., description="Tenant empresa.emp_id")
    prd_id: str = Field(..., description="FK (emp_id, prd_id) -> producto (UNIQUE emp_id, prd_id)")
    stk_cantidad: Decimal = Field(..., ge=0, description="Cantidad DECIMAL(10,2) DEFAULT 0.00")
    stk_min: int = Field(default=0, ge=0, description="Stock mínimo alerta")
    stk_max: int | None = Field(None, ge=0, description="Stock máximo opcional")
    model_config = {"from_attributes": True}


class ProductoStockCreate(ProductoStockBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class ProductoStockUpdate(BaseModel):
    stk_cantidad: Decimal | None = Field(None, ge=0)
    stk_min: int | None = Field(None, ge=0)
    stk_max: int | None = Field(None, ge=0)
    estado: int | None = None
    model_config = {"from_attributes": True}


class ProductoStockOut(ProductoStockBase):
    stock_id: str = Field(..., description="PK UUID")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None
    prd_nombre: str | None = Field(None, description="Nombre producto resuelto")
    prd_sku: str | None = None
    alerta_bajo_minimo: bool | None = Field(None, description="Calculado: stk_cantidad < stk_min")
    alerta_sobre_maximo: bool | None = Field(None, description="Calculado: stk_max != NULL and stk_cantidad > stk_max")
    model_config = {"from_attributes": True}


class ProductoStockMovimiento(BaseModel):
    """Payload para POST /stock/movimiento — ajuste de inventario."""

    emp_id: str = Field(..., description="Tenant")
    prd_id: str = Field(..., description="FK producto")
    delta: Decimal = Field(..., description="Delta positivo = ingreso, negativo = egreso (ej -2.00)")
    motivo: str | None = Field(None, max_length=255, description="Motivo ej 'venta', 'ajuste inventario', 'devolución'")
    costo_unitario: Decimal | None = Field(None, ge=0, description="Costo unitario opcional para recalcular")
    model_config = {"from_attributes": True}
