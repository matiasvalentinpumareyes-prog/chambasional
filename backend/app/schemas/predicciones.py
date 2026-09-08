"""
Schemas para modelos y predicciones — sección 7 DATABASE.md.

Tablas:
  version_modelo (vrm_id, emp_id) — catálogo de modelos versionados
  model_metrics (mdm_id, emp_id, vrm_id)
  predicciones (pdc_id, emp_id, cli_id, vrm_id)
  (cliente_features, prediccion_explicaciones están en cliente.py)

Referencia: backend/db/database_postgres.sql:529-589
Nombres exactos a BD (español donde la BD es español: vrm_id, pdc_id).
"""

from datetime import datetime
from decimal import Decimal
from typing import Any

from pydantic import BaseModel, Field


# ---------------------------------------------------------------------------
# Version modelo (DB: version_modelo)
# ---------------------------------------------------------------------------

class VersionModeloBase(BaseModel):
    emp_id: str = Field(..., description="Tenant empresa.emp_id")
    vrm_name: str = Field(..., min_length=1, max_length=100, description="Nombre modelo (uq_modelo_emp_version)")
    vrm_version: str = Field(..., min_length=1, max_length=50, description="Versión semántica ej v1.0.0")
    vrm_algorithm: str | None = Field(None, max_length=100, description="Algoritmo ej random_forest, xgboost, logistic_regression")
    trained_at: datetime | None = Field(None, description="Fecha de entrenamiento")
    metadata: dict[str, Any] | None = Field(None, description="JSON con hiperparámetros, features, dataset_version, etc.")

    model_config = {"from_attributes": True}


class VersionModeloCreate(VersionModeloBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class VersionModeloUpdate(BaseModel):
    vrm_name: str | None = Field(None, min_length=1, max_length=100)
    vrm_version: str | None = Field(None, min_length=1, max_length=50)
    vrm_algorithm: str | None = Field(None, max_length=100)
    trained_at: datetime | None = None
    metadata: dict[str, Any] | None = None
    estado: int | None = None

    model_config = {"from_attributes": True}


class VersionModeloOut(VersionModeloBase):
    vrm_id: str = Field(..., description="PK UUID (uq_modelo_emp_id)")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Model metrics (DB: model_metrics)
# ---------------------------------------------------------------------------

class ModelMetricDBBase(BaseModel):
    emp_id: str
    vrm_id: str = Field(..., description="FK (emp_id, vrm_id) -> version_modelo")
    mdm_metric_name: str = Field(..., min_length=1, max_length=100, description="accuracy | precision | recall | f1 | roc_auc | pr_auc")
    mdm_metric_value: Decimal = Field(..., description="DECIMAL(12,6)")
    evaluation_date: datetime = Field(..., description="DEFAULT CURRENT_TIMESTAMP")
    metadata: dict[str, Any] | None = None

    model_config = {"from_attributes": True}


class ModelMetricDBCreate(ModelMetricDBBase):
    created_by: str | None = None


class ModelMetricDBOut(ModelMetricDBBase):
    mdm_id: str = Field(..., description="PK UUID")
    created_at: datetime | None = None
    updated_at: datetime | None = None

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Predicciones (DB: predicciones)
# ---------------------------------------------------------------------------

class PrediccionBase(BaseModel):
    emp_id: str
    cli_id: str = Field(..., description="FK (emp_id, cli_id) -> cliente")
    vrm_id: str | None = Field(None, description="FK (emp_id, vrm_id) -> version_modelo nullable")
    pdc_tipo_prediccion: str = Field(..., min_length=1, max_length=50, description="Tipo ej churn, valor_vida, proxima_compra")
    pdc_prob_abandono: Decimal | None = Field(None, description="Probabilidad 0-1 DECIMAL(8,5)")
    pdc_valor: Decimal | None = Field(None, description="Valor predicho DECIMAL(14,2)")
    pdc_fecha: datetime = Field(..., description="Fecha de predicción DEFAULT CURRENT_TIMESTAMP")
    expires_at: datetime | None = Field(None, description="Expiración opcional")
    metadata: dict[str, Any] | None = Field(None, description="JSON con features usadas, razones, etc.")

    model_config = {"from_attributes": True}


class PrediccionCreate(PrediccionBase):
    created_by: str | None = None


class PrediccionUpdate(BaseModel):
    pdc_tipo_prediccion: str | None = Field(None, min_length=1, max_length=50)
    pdc_prob_abandono: Decimal | None = None
    pdc_valor: Decimal | None = None
    expires_at: datetime | None = None
    metadata: dict[str, Any] | None = None

    model_config = {"from_attributes": True}


class PrediccionOut(PrediccionBase):
    pdc_id: str = Field(..., description="PK UUID (uq_prediccion_emp_id)")
    created_at: datetime | None = None
    updated_at: datetime | None = None
    # Resueltos
    cliente_nombre: str | None = Field(None, description="cliente.cli_nombre_razon_social resuelto")
    modelo_version: str | None = Field(None, description="version_modelo.vrm_version resuelto")

    model_config = {"from_attributes": True}
