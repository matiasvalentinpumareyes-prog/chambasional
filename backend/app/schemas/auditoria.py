"""
Schemas para auditoría e importaciones (DB real) — sección 12 DATABASE.md.

Tablas:
  auditoria_logs (adl_id, emp_id, usu_id, ade_id, ada_id)
  imports (imp_id, emp_id, usu_id)
  import_errors (imp_error_id, emp_id, imp_id)

Referencia: backend/db/database_postgres.sql:839-906
Nombres exactos a BD (español donde la BD es español: adl_id, imp_id, etc.).
"""

from datetime import datetime
from typing import Any

from pydantic import BaseModel, Field


# ---------------------------------------------------------------------------
# Auditoría logs (DB: auditoria_logs)
# ---------------------------------------------------------------------------

class AuditoriaLogBase(BaseModel):
    emp_id: str = Field(..., description="FK empresa.emp_id (tenant)")
    usu_id: str = Field(..., description="FK compuesta (emp_id, usu_id) -> usuario")
    ade_id: str = Field(..., description="FK auditoria_entidades.ade_id")
    ada_id: str = Field(..., description="FK auditoria_accion.ada_id")
    adl_tabla: str = Field(..., min_length=1, max_length=64, description="Tabla afectada (denormalizada)")
    adl_registro_id: str = Field(..., min_length=1, max_length=100, description="PK del registro afectado")
    adl_usuario: str = Field(..., min_length=1, max_length=100, description="Usuario textual (denormalizado)")
    adl_fecha_hora: datetime = Field(..., description="DEFAULT CURRENT_TIMESTAMP")
    adl_valor_anterior: dict[str, Any] | None = Field(None, description="JSON")
    adl_valor_nuevo: dict[str, Any] | None = Field(None, description="JSON")
    ip_address: str | None = Field(None, max_length=45, description="IPv4/IPv6")
    user_agent: str | None = Field(None, description="TEXT")

    model_config = {"from_attributes": True}


class AuditoriaLogCreate(AuditoriaLogBase):
    created_by: str | None = None  # No usado en DB real; audit tiene created_at/updated_at simples


class AuditoriaLogOut(AuditoriaLogBase):
    adl_id: str = Field(..., description="PK UUID")
    created_at: datetime | None = None
    updated_at: datetime | None = None
    entidad_nombre: str | None = None
    accion_codigo: str | None = None

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Imports (DB: imports)
# ---------------------------------------------------------------------------

class ImportDBBase(BaseModel):
    emp_id: str = Field(..., description="Tenant")
    usu_id: str = Field(..., description="FK (emp_id, usu_id) -> usuario")
    file_name: str = Field(..., min_length=1, max_length=255)
    file_type: str | None = Field(None, max_length=50, description="Tipo de archivo ej 'clientes', 'productos', 'ventas'")
    total_rows: int = Field(default=0, ge=0)
    successful_rows: int = Field(default=0, ge=0)
    failed_rows: int = Field(default=0, ge=0)
    started_at: datetime | None = None
    completed_at: datetime | None = None

    model_config = {"from_attributes": True}


class ImportDBCreate(ImportDBBase):
    estado: int = Field(default=2, description="DEFAULT 2 (en proceso / pendiente)")
    created_by: str | None = None


class ImportDBUpdate(BaseModel):
    file_name: str | None = Field(None, min_length=1, max_length=255)
    file_type: str | None = Field(None, max_length=50)
    total_rows: int | None = None
    successful_rows: int | None = None
    failed_rows: int | None = None
    estado: int | None = None
    started_at: datetime | None = None
    completed_at: datetime | None = None

    model_config = {"from_attributes": True}


class ImportDBOut(ImportDBBase):
    imp_id: str = Field(..., description="PK UUID")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None
    usuario_nombre: str | None = None

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Import errors (DB: import_errors)
# ---------------------------------------------------------------------------

class ImportErrorDBBase(BaseModel):
    emp_id: str = Field(..., description="FK empresa.emp_id (no parte de FK a imports)")
    imp_id: str = Field(..., description="FK imports.imp_id")
    imp_error_row_number: int | None = Field(None, description="Fila del archivo (nullable)")
    imp_error_field_name: str | None = Field(None, max_length=100)
    error_type: str | None = Field(None, max_length=100, description="Tipo ej 'validation', 'duplicate', 'fk'")
    error_message: str = Field(..., description="TEXT NOT NULL")
    raw_data: dict[str, Any] | None = Field(None, description="JSON con fila original")

    model_config = {"from_attributes": True}


class ImportErrorDBCreate(ImportErrorDBBase):
    created_by: str | None = None


class ImportErrorDBOut(ImportErrorDBBase):
    imp_error_id: str = Field(..., description="PK UUID")
    created_at: datetime | None = None
    updated_at: datetime | None = None

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Import completo con errores (para historial)
# ---------------------------------------------------------------------------

class ImportCompletoOut(ImportDBOut):
    errors: list[ImportErrorDBOut] = Field(default_factory=list)

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# DTOs compatibilidad (antes en misc.py) — preview import
# ---------------------------------------------------------------------------

class ImportPreviewRequest(BaseModel):
    file_name: str = Field(..., max_length=255)
    file_type: str = Field(..., max_length=50, description="clientes|productos|ventas")
    rows: list[dict[str, str]] = Field(default_factory=list)
    model_config = {"from_attributes": True}

# Alias legacy para imports que aún usan misc
ImportSummaryOut = ImportCompletoOut
ImportErrorOut = ImportErrorDBOut
