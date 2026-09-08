"""
Schemas para motor de reglas y estrategias — secciones 8-9 DATABASE.md.

Tablas:
  estrategias (est_id, emp_id) — catálogo de estrategias de marketing
  rules (rle_id, emp_id, est_id) — reglas con condiciones JSON y acciones JSON

Referencia: backend/db/database_postgres.sql:595-634
Nombres exactos a BD (español donde la BD es español: est_id, rle_id).
"""

from datetime import datetime
from typing import Any

from pydantic import BaseModel, Field


# ---------------------------------------------------------------------------
# Estrategias
# ---------------------------------------------------------------------------

class EstrategiaBase(BaseModel):
    emp_id: str = Field(..., description="Tenant empresa.emp_id")
    est_nombre: str = Field(..., min_length=1, max_length=150, description="Nombre único por empresa (uq_estrategia_emp_nombre)")
    est_descripcion: str | None = Field(None, description="TEXT")
    est_objetivo: str | None = Field(None, max_length=100, description="Objetivo ej retencion, reactivacion, upsell")
    est_action_type: str | None = Field(None, max_length=50, description="Tipo de acción ej descuento, mensaje, llamada")
    configuracion: dict[str, Any] | None = Field(None, description="JSON con parámetros (cupón, canal, timing, etc.)")

    model_config = {"from_attributes": True}


class EstrategiaCreate(EstrategiaBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class EstrategiaUpdate(BaseModel):
    est_nombre: str | None = Field(None, min_length=1, max_length=150)
    est_descripcion: str | None = None
    est_objetivo: str | None = Field(None, max_length=100)
    est_action_type: str | None = Field(None, max_length=50)
    configuracion: dict[str, Any] | None = None
    estado: int | None = None

    model_config = {"from_attributes": True}


class EstrategiaOut(EstrategiaBase):
    est_id: str = Field(..., description="PK UUID (uq_estrategia_emp_id)")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Rules (motor de reglas)
# ---------------------------------------------------------------------------

class RuleBase(BaseModel):
    emp_id: str = Field(..., description="Tenant")
    est_id: str | None = Field(None, description="FK (emp_id, est_id) -> estrategias nullable")
    rle_nombre: str = Field(..., min_length=1, max_length=150, description="Nombre único por empresa (uq_rule_emp_nombre)")
    rle_descripcion: str | None = Field(None, description="TEXT")
    rle_rule_type: str = Field(..., min_length=1, max_length=50, description="Tipo ej churn, rfm, estacionalidad")
    rle_condiciones: dict[str, Any] = Field(..., description="JSON NOT NULL con árbol de condiciones")
    rle_acciones: dict[str, Any] | None = Field(None, description="JSON con acciones a ejecutar")
    rle_prioridad: int = Field(default=1, ge=1, description="Prioridad para evaluación (idx_rule_emp_prioridad)")

    model_config = {"from_attributes": True}


class RuleCreate(RuleBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class RuleUpdate(BaseModel):
    est_id: str | None = None
    rle_nombre: str | None = Field(None, min_length=1, max_length=150)
    rle_descripcion: str | None = None
    rle_rule_type: str | None = Field(None, min_length=1, max_length=50)
    rle_condiciones: dict[str, Any] | None = None
    rle_acciones: dict[str, Any] | None = None
    rle_prioridad: int | None = Field(None, ge=1)
    estado: int | None = None

    model_config = {"from_attributes": True}


class RuleOut(RuleBase):
    rle_id: str = Field(..., description="PK UUID")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None
    estrategia_nombre: str | None = None

    model_config = {"from_attributes": True}
