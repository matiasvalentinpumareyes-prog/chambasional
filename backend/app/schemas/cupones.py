"""
Schemas para cupones, recomendaciones y canjes — secciones 9, 11 DATABASE.md.

Tablas:
  cupones (cup_id, emp_id)
  recomendaciones (rec_id, emp_id, cli_id, est_id, pdc_id, prd_id, cup_id)
  cupon_canjes (ccn_id, emp_id, cup_id, cli_id, venta_id, cpg_recipient_id)

Referencia: backend/db/database_postgres.sql:640-702, 808-833
"""

from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, Field


# ---------------------------------------------------------------------------
# Cupones
# ---------------------------------------------------------------------------

class CuponBase(BaseModel):
    emp_id: str = Field(..., description="Tenant")
    cup_codigo: str = Field(..., min_length=1, max_length=80, description="Código único por empresa (uq_cupon_emp_codigo) ej VERANO10")
    cup_nombre: str = Field(..., min_length=1, max_length=150)
    cup_tipo: str = Field(..., min_length=1, max_length=20, description="porcentaje | monto_fijo")
    cup_valor: Decimal = Field(..., ge=0, description="Valor DECIMAL(14,2) ej 10.00 para 10% o monto")
    cup_min_compra: Decimal | None = Field(None, ge=0, description="Mínimo de compra para aplicar")
    cup_max_descuento: Decimal | None = Field(None, ge=0, description="Tope de descuento")
    cup_limite_uso_total: int | None = Field(None, ge=0, description="Límite global de usos")
    cup_limite_uso_cliente: int | None = Field(default=1, ge=0, description="Límite por cliente")
    cup_usos_actuales: int = Field(default=0, ge=0, description="Contador actual")
    fecha_inicio: datetime = Field(..., description="Inicio vigencia")
    fecha_fin: datetime | None = Field(None, description="Fin vigencia NULL = sin expiración")

    model_config = {"from_attributes": True}


class CuponCreate(CuponBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class CuponUpdate(BaseModel):
    cup_codigo: str | None = Field(None, min_length=1, max_length=80)
    cup_nombre: str | None = Field(None, min_length=1, max_length=150)
    cup_tipo: str | None = Field(None, min_length=1, max_length=20)
    cup_valor: Decimal | None = Field(None, ge=0)
    cup_min_compra: Decimal | None = None
    cup_max_descuento: Decimal | None = None
    cup_limite_uso_total: int | None = None
    cup_limite_uso_cliente: int | None = None
    fecha_inicio: datetime | None = None
    fecha_fin: datetime | None = None
    estado: int | None = None

    model_config = {"from_attributes": True}


class CuponOut(CuponBase):
    cup_id: str = Field(..., description="PK UUID (uq_cupon_emp_id)")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None
    vigente: bool | None = Field(None, description="Calculado: fecha_inicio <= now <= fecha_fin si aplica")

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Recomendaciones (DB: recomendaciones) — genera ofertas personalizadas
# ---------------------------------------------------------------------------

class RecomendacionBase(BaseModel):
    emp_id: str
    cli_id: str = Field(..., description="FK (emp_id, cli_id) -> cliente")
    est_id: str = Field(..., description="FK (emp_id, est_id) -> estrategias")
    pdc_id: str = Field(..., description="FK (emp_id, pdc_id) -> predicciones")
    prd_id: str | None = Field(None, description="FK (emp_id, prd_id) -> producto nullable")
    cup_id: str | None = Field(None, description="FK (emp_id, cup_id) -> cupones nullable")
    rec_titulo: str = Field(..., min_length=1, max_length=200)
    rec_descripcion: str | None = Field(None, description="TEXT")
    prioridad: int = Field(default=1, ge=1)
    rec_accion_recomendada: str | None = Field(None, description="TEXT ej 'Enviar WhatsApp con cupón'")
    recommended_offer: Decimal | None = Field(None, description="DECIMAL(14,2) monto/oferta sugerida")
    expires_at: datetime | None = None

    model_config = {"from_attributes": True}


class RecomendacionCreate(RecomendacionBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class RecomendacionUpdate(BaseModel):
    rec_titulo: str | None = Field(None, min_length=1, max_length=200)
    rec_descripcion: str | None = None
    prioridad: int | None = Field(None, ge=1)
    rec_accion_recomendada: str | None = None
    recommended_offer: Decimal | None = None
    expires_at: datetime | None = None
    estado: int | None = None

    model_config = {"from_attributes": True}


class RecomendacionOut(RecomendacionBase):
    rec_id: str = Field(..., description="PK UUID (uq_recomendacion_emp_id)")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None
    # Resueltos
    cliente_nombre: str | None = None
    estrategia_nombre: str | None = None
    producto_nombre: str | None = None
    cupon_codigo: str | None = None

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Canjes de cupones (DB: cupon_canjes)
# ---------------------------------------------------------------------------

class CuponCanjeBase(BaseModel):
    emp_id: str
    cup_id: str = Field(..., description="FK (emp_id, cup_id) -> cupones")
    cli_id: str = Field(..., description="FK (emp_id, cli_id) -> cliente")
    venta_id: str | None = Field(None, description="FK (emp_id, venta_id) -> ventas nullable")
    cpg_recipient_id: str | None = Field(None, description="FK (emp_id, cpg_recipient_id) -> campaign_recipients nullable")
    fecha_canjes: datetime = Field(..., description="DEFAULT CURRENT_TIMESTAMP")
    importe_descuento: Decimal = Field(default=Decimal("0.00"), description="DECIMAL(14,2)")

    model_config = {"from_attributes": True}


class CuponCanjeCreate(CuponCanjeBase):
    created_by: str | None = None


class CuponCanjeOut(CuponCanjeBase):
    ccn_id: str = Field(..., description="PK UUID")
    created_at: datetime | None = None
    updated_at: datetime | None = None
    # UNIQUE por (emp_id, cup_id, cli_id, venta_id) — valida 1 canje por venta
    cupon_codigo: str | None = None
    cliente_nombre: str | None = None

    model_config = {"from_attributes": True}
