"""
Schemas para campañas y comunicaciones (DB real) — sección 10 DATABASE.md.

Tablas:
  campaigns (cpg_id, emp_id, est_id, can_id) — cabecera
  campaign_recipients (cpg_recipient_id, emp_id, cpg_id, cli_id, can_id, rec_id, venta_id)
  communicaciones (com_id, emp_id, cli_id, cpg_recipient_id, can_id, venta_id)

Referencia: backend/db/database_postgres.sql:708-803
Nombres exactos a BD (español/inglés según BD: cpg_id, com_id, cpg_recipient_id).
"""

from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, Field


# ---------------------------------------------------------------------------
# Campaigns (DB: campaigns)
# ---------------------------------------------------------------------------

class CampaignDBBase(BaseModel):
    emp_id: str = Field(..., description="Tenant empresa.emp_id")
    est_id: str | None = Field(None, description="FK (emp_id, est_id) -> estrategias nullable")
    can_id: str = Field(..., description="FK canales_marketing.can_id")
    cpg_name: str = Field(..., min_length=1, max_length=150, description="Nombre único por empresa (uq_campaign_emp_nombre)")
    cpg_description: str | None = Field(None, description="TEXT")
    cpg_subject: str | None = Field(None, max_length=200, description="Asunto")
    cpg_content: str | None = Field(None, description="Contenido TEXT (puede ser plantilla)")
    cpg_budget: Decimal = Field(default=Decimal("0.00"), description="Presupuesto DECIMAL(14,2)")
    start_date: datetime | None = Field(None, description="Inicio")
    end_date: datetime | None = Field(None, description="Fin")

    model_config = {"from_attributes": True}


class CampaignDBCreate(CampaignDBBase):
    estado: int = Field(default=3, description="DEFAULT 3 (draft/scheduled según convención)")
    created_by: str | None = None


class CampaignDBUpdate(BaseModel):
    est_id: str | None = None
    can_id: str | None = None
    cpg_name: str | None = Field(None, min_length=1, max_length=150)
    cpg_description: str | None = None
    cpg_subject: str | None = Field(None, max_length=200)
    cpg_content: str | None = None
    cpg_budget: Decimal | None = None
    start_date: datetime | None = None
    end_date: datetime | None = None
    estado: int | None = None

    model_config = {"from_attributes": True}


class CampaignDBOut(CampaignDBBase):
    cpg_id: str = Field(..., description="PK UUID (uq_campaign_emp_id)")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None
    estrategia_nombre: str | None = None
    canal_nombre: str | None = None
    canal_codigo: str | None = None

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Campaign recipients (DB: campaign_recipients)
# ---------------------------------------------------------------------------

class CampaignRecipientDBBase(BaseModel):
    emp_id: str
    cpg_id: str = Field(..., description="FK (emp_id, cpg_id) -> campaigns")
    cli_id: str = Field(..., description="FK (emp_id, cli_id) -> cliente (UNIQUE emp_id, cpg_id, cli_id)")
    can_id: str = Field(..., description="FK canales_marketing.can_id")
    rec_id: str | None = Field(None, description="FK (emp_id, rec_id) -> recomendaciones nullable")
    sent_at: datetime | None = None
    delivered_at: datetime | None = None
    opened_at: datetime | None = None
    clicked_at: datetime | None = None
    converted_at: datetime | None = None
    venta_id: str | None = Field(None, description="FK (emp_id, venta_id) -> ventas nullable (conversión)")
    conversion_value: Decimal | None = Field(None, description="DECIMAL(14,2) valor de conversión")

    model_config = {"from_attributes": True}


class CampaignRecipientDBCreate(CampaignRecipientDBBase):
    estado: int = Field(default=2, description="DEFAULT 2 (pending/scheduled)")
    created_by: str | None = None


class CampaignRecipientDBUpdate(BaseModel):
    can_id: str | None = None
    rec_id: str | None = None
    estado: int | None = None
    sent_at: datetime | None = None
    delivered_at: datetime | None = None
    opened_at: datetime | None = None
    clicked_at: datetime | None = None
    converted_at: datetime | None = None
    venta_id: str | None = None
    conversion_value: Decimal | None = None

    model_config = {"from_attributes": True}


class CampaignRecipientDBOut(CampaignRecipientDBBase):
    cpg_recipient_id: str = Field(..., description="PK UUID (uq_campaign_recipient_emp_id)")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None
    cliente_nombre: str | None = None
    campana_nombre: str | None = None
    canal_nombre: str | None = None

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Comunicaciones (DB: communicaciones) — log por envío
# ---------------------------------------------------------------------------

class ComunicacionBase(BaseModel):
    emp_id: str
    cli_id: str = Field(..., description="FK (emp_id, cli_id) -> cliente")
    cpg_recipient_id: str | None = Field(None, description="FK (emp_id, cpg_recipient_id) -> campaign_recipients nullable")
    can_id: str = Field(..., description="FK canales_marketing.can_id")
    com_asunto: str | None = Field(None, max_length=200)
    com_contenido: str = Field(..., description="TEXT NOT NULL — cuerpo del mensaje")
    provider_message_id: str | None = Field(None, max_length=150, description="ID del proveedor externo")
    sent_at: datetime | None = None
    delivered_at: datetime | None = None
    opened_at: datetime | None = None
    clicked_at: datetime | None = None
    converted_at: datetime | None = None
    venta_id: str | None = Field(None, description="FK (emp_id, venta_id) -> ventas nullable")

    model_config = {"from_attributes": True}


class ComunicacionCreate(ComunicacionBase):
    estado: int = Field(default=2, description="DEFAULT 2")
    created_by: str | None = None


class ComunicacionUpdate(BaseModel):
    com_asunto: str | None = Field(None, max_length=200)
    com_contenido: str | None = None
    provider_message_id: str | None = Field(None, max_length=150)
    estado: int | None = None
    sent_at: datetime | None = None
    delivered_at: datetime | None = None
    opened_at: datetime | None = None
    clicked_at: datetime | None = None
    converted_at: datetime | None = None
    venta_id: str | None = None

    model_config = {"from_attributes": True}


class ComunicacionOut(ComunicacionBase):
    com_id: str = Field(..., description="PK UUID")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None
    cliente_nombre: str | None = None
    canal_nombre: str | None = None
    campana_nombre: str | None = None

    model_config = {"from_attributes": True}
