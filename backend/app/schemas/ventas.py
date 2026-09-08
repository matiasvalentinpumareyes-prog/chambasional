"""
Schemas para ventas (DB real) — sección 5 DATABASE.md.

Tablas:
  ventas (venta_id, emp_id, cli_id, mtp_id, cupon_id)
  venta_items (ven_item_id, emp_id, venta_id, prd_id)

Referencia: backend/db/database_postgres.sql:392-437
Nombres exactos a BD (español donde la BD es español: venta_id, ven_item_id, prd_id).
"""

from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, Field


# ---------------------------------------------------------------------------
# Ventas (DB: ventas)
# ---------------------------------------------------------------------------

class VentaBase(BaseModel):
    emp_id: str = Field(..., description="Tenant empresa.emp_id")
    cli_id: str = Field(..., description="FK (emp_id, cli_id) -> cliente")
    ven_descuento: Decimal = Field(default=Decimal("0.00"), description="DECIMAL(14,2) DEFAULT 0.00")
    ven_total: Decimal = Field(default=Decimal("0.00"), description="DECIMAL(14,2)")
    mtp_id: str | None = Field(None, description="FK metodos_pago.mtp_id nullable")
    cupon_id: str | None = Field(None, description="FK (emp_id, cup_id) -> cupones nullable (FK diferida)")
    venta_origen: str | None = Field(None, max_length=50, description="Origen ej 'tienda', 'web', 'whatsapp'")

    model_config = {"from_attributes": True}


class VentaCreate(VentaBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class VentaUpdate(BaseModel):
    cli_id: str | None = None
    ven_descuento: Decimal | None = None
    ven_total: Decimal | None = None
    mtp_id: str | None = None
    cupon_id: str | None = None
    venta_origen: str | None = Field(None, max_length=50)
    estado: int | None = None

    model_config = {"from_attributes": True}


class VentaOut(VentaBase):
    venta_id: str = Field(..., description="PK UUID (uq_venta_emp_id)")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None
    # Resueltos
    cliente_nombre: str | None = None
    metodo_pago_nombre: str | None = None
    cupon_codigo: str | None = None

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Venta items (DB: venta_items)
# ---------------------------------------------------------------------------

class VentaItemBase(BaseModel):
    emp_id: str = Field(..., description="Tenant")
    venta_id: str = Field(..., description="FK (emp_id, venta_id) -> ventas")
    prd_id: str = Field(..., description="FK (emp_id, prd_id) -> producto")
    cantidad: Decimal = Field(default=Decimal("1.000"), description="DECIMAL(12,3) DEFAULT 1.000")
    precio_unitario: Decimal = Field(default=Decimal("0.00"), description="DECIMAL(14,2)")
    descuento: Decimal = Field(default=Decimal("0.00"), description="DECIMAL(14,2)")
    subtotal: Decimal = Field(default=Decimal("0.00"), description="DECIMAL(14,2) cantidad*precio - descuento")
    costo_unitario: Decimal | None = Field(None, description="DECIMAL(14,2) costo al momento de la venta")

    model_config = {"from_attributes": True}


class VentaItemCreate(VentaItemBase):
    created_by: str | None = None


class VentaItemUpdate(BaseModel):
    cantidad: Decimal | None = Field(None, ge=0)
    precio_unitario: Decimal | None = None
    descuento: Decimal | None = None
    subtotal: Decimal | None = None
    costo_unitario: Decimal | None = None

    model_config = {"from_attributes": True}


class VentaItemOut(VentaItemBase):
    ven_item_id: str = Field(..., description="PK UUID (uq_venta_item_emp_id)")
    created_at: datetime | None = None
    updated_at: datetime | None = None
    producto_nombre: str | None = None
    producto_sku: str | None = None

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Venta completa con items (para respuestas agregadas)
# ---------------------------------------------------------------------------

class VentaCompletaOut(VentaOut):
    items: list[VentaItemOut] = Field(default_factory=list, description="Líneas de la venta")

    model_config = {"from_attributes": True}
