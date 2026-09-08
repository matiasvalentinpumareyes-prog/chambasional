"""
Schemas para dominio cliente y features IA — secciones 4, 6 DATABASE.md.

Tablas:
  cliente (cli_id, emp_id, doc_id)
  cliente_consentimientos (cco_id, emp_id, cli_id, can_id)
  cliente_segmento (cli_segmento_id, emp_id, cli_id, seg_id) — estado actual 1:1
  cliente_segmento_historial (csh_id)
  cliente_features (cft_id, emp_id, cli_id, fecha_snapshot) — incluye ALTER patrones/intervalos
  cliente_estacionalidad (ces_id, emp_id, cli_id, mes 1..12)
  tipos_direccion_explicacion (tde_id, emp_id) — única sin timestamps
  prediccion_explicaciones (pex_id, emp_id, pdc_id, tde_id)

Referencia: backend/db/database_postgres.sql:329-386, 442-523, 954-1054
Nombres exactos a BD (español donde la BD es español: cli_id, cco_id, cft_id, etc.).
"""

from datetime import date, datetime
from decimal import Decimal
from typing import Any

from pydantic import BaseModel, EmailStr, Field


# ---------------------------------------------------------------------------
# Cliente (tabla cliente)
# ---------------------------------------------------------------------------

class ClienteBase(BaseModel):
    emp_id: str = Field(..., description="Tenant empresa.emp_id")
    doc_id: str = Field(..., description="FK documento.doc_id (DNI/RUC/CE)")
    cli_ndocumento: str | None = Field(None, max_length=15, description="Número de documento (uq_cliente_emp_documento)")
    cli_nombre_razon_social: str = Field(..., min_length=1, max_length=255)
    cli_direccion: str | None = Field(None, max_length=255)
    cli_email: EmailStr | None = Field(None, description="Email único por empresa (uq_cliente_emp_email)")
    cli_celular: str | None = Field(None, max_length=30)
    cli_birthday: date | None = Field(None, description="Fecha nacimiento")
    cli_genero: int | None = Field(None, description="0/1 pequeño, según implementación")
    dep_id: str | None = Field(None, description="FK departamento.dep_id")
    prv_id: str | None = Field(None, description="FK provincia.prv_id")
    dis_id: str | None = Field(None, description="FK distrito.dis_id")

    model_config = {"from_attributes": True}


class ClienteCreate(ClienteBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class ClienteUpdate(BaseModel):
    doc_id: str | None = None
    cli_ndocumento: str | None = Field(None, max_length=15)
    cli_nombre_razon_social: str | None = Field(None, min_length=1, max_length=255)
    cli_direccion: str | None = Field(None, max_length=255)
    cli_email: EmailStr | None = None
    cli_celular: str | None = Field(None, max_length=30)
    cli_birthday: date | None = None
    cli_genero: int | None = None
    dep_id: str | None = None
    prv_id: str | None = None
    dis_id: str | None = None
    estado: int | None = None

    model_config = {"from_attributes": True}


class ClienteOut(ClienteBase):
    cli_id: str = Field(..., description="PK UUID")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None
    # Resueltos
    documento_tipo: str | None = None
    segmento_actual: str | None = None

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Consentimientos por canal (RGPD / consentimiento por canal)
# ---------------------------------------------------------------------------

class ClienteConsentimientoBase(BaseModel):
    emp_id: str = Field(..., description="Tenant")
    cli_id: str = Field(..., description="FK (emp_id, cli_id) -> cliente")
    can_id: str = Field(..., description="FK canales_marketing.can_id")
    consentimiento: int = Field(default=0, description="0 no | 1 sí")
    fecha_otorgado: datetime | None = None
    fecha_revocado: datetime | None = None
    fuente: str | None = Field(None, max_length=100, description="Origen ej 'checkout', 'web'")
    evidencia: str | None = Field(None, max_length=255)
    version_politica: str | None = Field(None, max_length=50)

    model_config = {"from_attributes": True}


class ClienteConsentimientoCreate(ClienteConsentimientoBase):
    created_by: str | None = None


class ClienteConsentimientoUpdate(BaseModel):
    consentimiento: int | None = None
    fecha_otorgado: datetime | None = None
    fecha_revocado: datetime | None = None
    fuente: str | None = Field(None, max_length=100)
    evidencia: str | None = Field(None, max_length=255)
    version_politica: str | None = Field(None, max_length=50)

    model_config = {"from_attributes": True}


class ClienteConsentimientoOut(ClienteConsentimientoBase):
    cco_id: str = Field(..., description="PK UUID")
    created_at: datetime | None = None
    updated_at: datetime | None = None
    canal_nombre: str | None = None
    canal_codigo: str | None = None

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Segmento actual (1:1 por cliente)
# ---------------------------------------------------------------------------

class ClienteSegmentoBase(BaseModel):
    emp_id: str = Field(..., description="Tenant")
    cli_id: str = Field(..., description="FK (emp_id, cli_id) -> cliente (UNIQUE emp_id, cli_id)")
    seg_id: str = Field(..., description="FK segmentos.seg_id")
    puntuacion: Decimal | None = Field(None, description="Score DECIMAL(8,5)")
    fecha_asignacion: datetime = Field(..., description="DEFAULT CURRENT_TIMESTAMP")

    model_config = {"from_attributes": True}


class ClienteSegmentoCreate(ClienteSegmentoBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class ClienteSegmentoUpdate(BaseModel):
    seg_id: str | None = None
    puntuacion: Decimal | None = None
    estado: int | None = None

    model_config = {"from_attributes": True}


class ClienteSegmentoOut(ClienteSegmentoBase):
    cli_segmento_id: str = Field(..., description="PK UUID")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None
    segmento_nombre: str | None = None
    segmento_codigo: str | None = None

    model_config = {"from_attributes": True}


class ClienteSegmentoHistorialOut(BaseModel):
    csh_id: str
    emp_id: str
    cli_id: str
    seg_anterior_id: str | None = None
    seg_nuevo_id: str
    puntuacion_anterior: Decimal | None = None
    puntuacion_nueva: Decimal | None = None
    motivo: str | None = Field(None, max_length=150)
    changed_at: datetime
    created_at: datetime | None = None
    updated_at: datetime | None = None

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Features snapshot (cliente_features) — núcleo IA
# ---------------------------------------------------------------------------

class ClienteFeaturesBase(BaseModel):
    emp_id: str
    cli_id: str = Field(..., description="FK (emp_id, cli_id) -> cliente")
    fecha_snapshot: datetime = Field(..., description="UNIQUE por (emp_id, cli_id, fecha_snapshot)")
    recencia_dias: int | None = Field(None, ge=0)
    frecuencia_30d: int = Field(default=0, ge=0)
    frecuencia_90d: int = Field(default=0, ge=0)
    frecuencia_365d: int = Field(default=0, ge=0)
    ticket_promedio: Decimal = Field(default=Decimal("0.00"), description="DECIMAL(14,2)")
    gasto_total_30d: Decimal = Field(default=Decimal("0.00"))
    gasto_total_90d: Decimal = Field(default=Decimal("0.00"))
    gasto_total_365d: Decimal = Field(default=Decimal("0.00"))
    dias_desde_ultima_compra: int | None = None
    categoria_favorita_id: str | None = Field(None, description="FK (emp_id, cat_id)")
    producto_favorito_id: str | None = Field(None, description="FK (emp_id, prd_id)")
    margen_estimado_90d: Decimal | None = None
    descuento_promedio_90d: Decimal | None = None
    valor_vida_estimado: Decimal | None = None
    score_churn: Decimal | None = Field(None, description="DECIMAL(8,5) para índices")
    metadata: dict[str, Any] | None = Field(None, description="JSON libre")
    # Columnas añadidas por ALTER 981
    total_compras_historicas: int = Field(default=0, ge=0)
    intervalo_promedio_dias: Decimal | None = Field(None, description="DECIMAL(8,2)")
    intervalo_desviacion_dias: Decimal | None = None
    intervalo_cv: Decimal | None = Field(None, description="Coeficiente variación DECIMAL(6,4)")
    pat_id: str | None = Field(None, description="FK patrones_compra.pat_id")
    ratio_riesgo_actual: Decimal | None = Field(None, description="DECIMAL(8,4) índice ratio_riesgo")

    model_config = {"from_attributes": True}


class ClienteFeaturesCreate(ClienteFeaturesBase):
    created_by: str | None = None


class ClienteFeaturesOut(ClienteFeaturesBase):
    cft_id: str = Field(..., description="PK UUID")
    created_at: datetime | None = None
    updated_at: datetime | None = None
    patron_nombre: str | None = None
    categoria_nombre: str | None = None
    producto_nombre: str | None = None

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Estacionalidad (12 filas por cliente, mes 1..12)
# ---------------------------------------------------------------------------

class ClienteEstacionalidadBase(BaseModel):
    emp_id: str
    cli_id: str = Field(..., description="FK (emp_id, cli_id) -> cliente")
    mes: int = Field(..., ge=1, le=12, description="1..12 CHECK chk_estacionalidad_mes")
    num_compras_historicas: int = Field(default=0, ge=0)
    gasto_total_mes: Decimal = Field(default=Decimal("0.00"), description="DECIMAL(14,2)")
    gasto_promedio_mes: Decimal = Field(default=Decimal("0.00"))
    ultima_actualizacion: datetime = Field(..., description="DEFAULT CURRENT_TIMESTAMP")

    model_config = {"from_attributes": True}


class ClienteEstacionalidadCreate(ClienteEstacionalidadBase):
    created_by: str | None = None


class ClienteEstacionalidadOut(ClienteEstacionalidadBase):
    ces_id: str = Field(..., description="PK UUID")
    created_at: datetime | None = None
    updated_at: datetime | None = None

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Tipos dirección explicación + predicción explicaciones (XAI)
# ---------------------------------------------------------------------------

class TipoDireccionExplicacionBase(BaseModel):
    emp_id: str = Field(..., description="Tenant (único catálogo por empresa, sí lleva emp_id)")
    codigo: str = Field(..., min_length=1, max_length=50, description="UNIQUE por (emp_id, codigo)")
    nombre: str = Field(..., min_length=1, max_length=100)
    descripcion: str | None = Field(None, max_length=255)
    activo: int = Field(default=1, description="SMALLINT 0/1 — única tabla sin created_at/updated_at")

    model_config = {"from_attributes": True}


class TipoDireccionExplicacionCreate(TipoDireccionExplicacionBase):
    pass


class TipoDireccionExplicacionOut(TipoDireccionExplicacionBase):
    tde_id: str = Field(..., description="PK UUID (UNIQUE emp_id, tde_id para FK compuesta)")

    model_config = {"from_attributes": True}


class PrediccionExplicacionBase(BaseModel):
    emp_id: str
    pdc_id: str = Field(..., description="FK (emp_id, pdc_id) -> predicciones")
    tde_id: str = Field(..., description="FK (emp_id, tde_id) -> tipos_direccion_explicacion")
    feature_nombre: str = Field(..., min_length=1, max_length=100, description="UNIQUE por (emp_id, pdc_id, feature_nombre)")
    feature_valor: str | None = Field(None, max_length=150)
    impacto: Decimal = Field(..., description="DECIMAL(10,6) positivo empuja a churn, negativo lo frena")
    orden_importancia: int = Field(default=1, ge=1)

    model_config = {"from_attributes": True}


class PrediccionExplicacionCreate(PrediccionExplicacionBase):
    created_by: str | None = None


class PrediccionExplicacionOut(PrediccionExplicacionBase):
    pex_id: str = Field(..., description="PK UUID")
    created_at: datetime | None = None
    updated_at: datetime | None = None
    direccion_codigo: str | None = None
    direccion_nombre: str | None = None

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# DTOs computados (no tablas) — RFM/Churn/NextPurchase, antes en customer.py
# ---------------------------------------------------------------------------

class RFMOut(BaseModel):
    recencia_dias: int | None = Field(None, ge=0)
    frecuencia_30d: int = Field(default=0)
    recencia_dias_calc: int | None = None
    r: int = Field(default=1, ge=1, le=5)
    f: int = Field(default=1, ge=1, le=5)
    m: int = Field(default=1, ge=1, le=5)
    recency_days: int | None = Field(None, description="Alias recencia_dias")
    frequency: int | None = None
    monetary: float | None = None
    @property
    def rfm_score(self) -> str:
        return f"{self.r}{self.f}{self.m}"
    model_config = {"from_attributes": True, "populate_by_name": True}

class ChurnOut(BaseModel):
    cli_id: str = Field(..., description="cliente.cli_id")
    pdc_prob_abandono: float | None = Field(None, ge=0, le=1, description="predicciones.pdc_prob_abandono")
    churn_probability: float | None = Field(None, ge=0, le=1, description="Alias pdc_prob_abandono")
    pdc_fecha: datetime | None = None
    prediction_date: datetime | None = None
    model_config = {"from_attributes": True, "populate_by_name": True, "protected_namespaces": ()}

class NextPurchaseOut(BaseModel):
    expected_next_purchase_date: datetime | None = None
    days_until_expected_purchase: int | None = None
    purchase_probability: float | None = None
    model_config = {"from_attributes": True}
