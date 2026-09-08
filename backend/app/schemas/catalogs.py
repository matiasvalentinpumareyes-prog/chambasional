"""
Schemas para catálogos base globales (sin emp_id) — sección 1 de DATABASE.md.

Tablas cubiertas:
  departamento (dep_id), provincia (prv_id), distrito (dis_id),
  documento (doc_id), metodos_pago (mtp_id), canales_marketing (can_id),
  segmentos (seg_id), roles (rol_id),
  auditoria_entidades (ade_id), auditoria_accion (ada_id),
  patrones_compra (pat_id)

Todos comparten: estado SMALLINT DEFAULT 1, created_at/updated_at,
created_by/updated_by, PK UUID DEFAULT uuid_generate_v1mc().

Referencia: backend/db/database_postgres.sql:12-142 y 954-980
"""

from datetime import datetime
from typing import Optional

from pydantic import BaseModel, Field


# ---------------------------------------------------------------------------
# Base común
# ---------------------------------------------------------------------------

class CatalogBaseOut(BaseModel):
    estado: int = Field(default=1, description="0 inactivo | 1 activo | 2/3 estados especiales")
    created_at: datetime | None = None
    updated_at: datetime | None = None
    created_by: str | None = Field(None, max_length=100)
    updated_by: str | None = Field(None, max_length=100)

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# 1. Ubigeo: departamento -> provincia -> distrito
# ---------------------------------------------------------------------------

class DepartamentoBase(BaseModel):
    dep_nombre: str = Field(..., min_length=1, max_length=100, description="Nombre del departamento (uq_departamento_nombre)")

    model_config = {"from_attributes": True}


class DepartamentoCreate(DepartamentoBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class DepartamentoUpdate(BaseModel):
    dep_nombre: str | None = Field(None, min_length=1, max_length=100)
    estado: int | None = None

    model_config = {"from_attributes": True}


class DepartamentoOut(DepartamentoBase, CatalogBaseOut):
    dep_id: str = Field(..., description="PK UUID (uuid_generate_v1mc())")


class ProvinciaBase(BaseModel):
    dep_id: str = Field(..., description="FK departamento.dep_id")
    prv_nombre: str = Field(..., min_length=1, max_length=100, description="Nombre provincia (uq_provincia_dep_nombre)")

    model_config = {"from_attributes": True}


class ProvinciaCreate(ProvinciaBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class ProvinciaUpdate(BaseModel):
    dep_id: str | None = None
    prv_nombre: str | None = Field(None, min_length=1, max_length=100)
    estado: int | None = None

    model_config = {"from_attributes": True}


class ProvinciaOut(ProvinciaBase, CatalogBaseOut):
    prv_id: str = Field(..., description="PK UUID")
    departamento: DepartamentoOut | None = Field(None, description="Departamento resuelto")


class DistritoBase(BaseModel):
    prv_id: str = Field(..., description="FK provincia.prv_id")
    dis_nombre: str = Field(..., min_length=1, max_length=100, description="Nombre distrito (uq_distrito_prv_nombre)")

    model_config = {"from_attributes": True}


class DistritoCreate(DistritoBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class DistritoUpdate(BaseModel):
    prv_id: str | None = None
    dis_nombre: str | None = Field(None, min_length=1, max_length=100)
    estado: int | None = None

    model_config = {"from_attributes": True}


class DistritoOut(DistritoBase, CatalogBaseOut):
    dis_id: str = Field(..., description="PK UUID")
    provincia: ProvinciaOut | None = None


# ---------------------------------------------------------------------------
# 2. Documento (tipos DNI/RUC/CE/Pasaporte...)
# ---------------------------------------------------------------------------

class DocumentoBase(BaseModel):
    doc_tipo: str = Field(..., min_length=1, max_length=100, description="Código del tipo ej DNI, RUC, CE (uq_documento_tipo)")
    doc_descripcion: str | None = Field(None, max_length=100, description="Descripción legible")

    model_config = {"from_attributes": True}


class DocumentoCreate(DocumentoBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class DocumentoUpdate(BaseModel):
    doc_tipo: str | None = Field(None, min_length=1, max_length=100)
    doc_descripcion: str | None = Field(None, max_length=100)
    estado: int | None = None

    model_config = {"from_attributes": True}


class DocumentoOut(DocumentoBase, CatalogBaseOut):
    doc_id: str = Field(..., description="PK UUID")


# ---------------------------------------------------------------------------
# 3. Métodos de pago
# ---------------------------------------------------------------------------

class MetodoPagoBase(BaseModel):
    mtp_nombre: str = Field(..., min_length=1, max_length=50, description="Nombre método ej Efectivo, Tarjeta, Yape (uq_metodo_pago_nombre)")

    model_config = {"from_attributes": True}


class MetodoPagoCreate(MetodoPagoBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class MetodoPagoUpdate(BaseModel):
    mtp_nombre: str | None = Field(None, min_length=1, max_length=50)
    estado: int | None = None

    model_config = {"from_attributes": True}


class MetodoPagoOut(MetodoPagoBase, CatalogBaseOut):
    mtp_id: str = Field(..., description="PK UUID")


# ---------------------------------------------------------------------------
# 4. Canales de marketing
# ---------------------------------------------------------------------------

class CanalMarketingBase(BaseModel):
    can_codigo: str = Field(..., min_length=1, max_length=30, description="Código único ej EMAIL, SMS, WHATSAPP, PUSH (uq_canal_codigo)")
    can_nombre: str = Field(..., min_length=1, max_length=100, description="Nombre legible (uq_canal_nombre)")
    requiere_consentimiento: int = Field(default=1, description="1 requiere consentimiento, 0 no")

    model_config = {"from_attributes": True}


class CanalMarketingCreate(CanalMarketingBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class CanalMarketingUpdate(BaseModel):
    can_codigo: str | None = Field(None, min_length=1, max_length=30)
    can_nombre: str | None = Field(None, min_length=1, max_length=100)
    requiere_consentimiento: int | None = None
    estado: int | None = None

    model_config = {"from_attributes": True}


class CanalMarketingOut(CanalMarketingBase, CatalogBaseOut):
    can_id: str = Field(..., description="PK UUID")


# ---------------------------------------------------------------------------
# 5. Segmentos
# ---------------------------------------------------------------------------

class SegmentoBase(BaseModel):
    seg_codigo: str = Field(..., min_length=1, max_length=50, description="Código ej NUEVO, ACTIVO, EN_RIESGO, PERDIDO, RECUPERADO, LEAL (uq_segmento_codigo)")
    seg_nombre: str = Field(..., min_length=1, max_length=100, description="Nombre legible (uq_segmento_nombre)")
    seg_descripcion: str | None = Field(None, max_length=255)
    seg_tipo: str | None = Field(None, max_length=50, description="CICLO_VIDA | CHURN | RECUPERACION | VALOR")

    model_config = {"from_attributes": True}


class SegmentoCreate(SegmentoBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class SegmentoUpdate(BaseModel):
    seg_codigo: str | None = Field(None, min_length=1, max_length=50)
    seg_nombre: str | None = Field(None, min_length=1, max_length=100)
    seg_descripcion: str | None = Field(None, max_length=255)
    seg_tipo: str | None = Field(None, max_length=50)
    estado: int | None = None

    model_config = {"from_attributes": True}


class SegmentoOut(SegmentoBase, CatalogBaseOut):
    seg_id: str = Field(..., description="PK UUID")


# ---------------------------------------------------------------------------
# 6. Roles
# ---------------------------------------------------------------------------

class RolBase(BaseModel):
    rol_codigo: str = Field(..., min_length=1, max_length=50, description="Código ej SUPERADMIN, ADMIN_EMPRESA, MARKETING, OPERADOR, AUDITOR (uq_rol_codigo)")
    rol_nombre: str = Field(..., min_length=1, max_length=100)
    rol_descripcion: str | None = Field(None, max_length=255)

    model_config = {"from_attributes": True}


class RolCreate(RolBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class RolUpdate(BaseModel):
    rol_codigo: str | None = Field(None, min_length=1, max_length=50)
    rol_nombre: str | None = Field(None, min_length=1, max_length=100)
    rol_descripcion: str | None = Field(None, max_length=255)
    estado: int | None = None

    model_config = {"from_attributes": True}


class RolOut(RolBase, CatalogBaseOut):
    rol_id: str = Field(..., description="PK UUID")


# ---------------------------------------------------------------------------
# 7. Auditoría entidades / acción
# ---------------------------------------------------------------------------

class AuditoriaEntidadBase(BaseModel):
    ade_codigo: str = Field(..., min_length=1, max_length=50, description="Código entidad (uq_auditoria_entidad_codigo)")
    ade_nombre: str = Field(..., min_length=1, max_length=100)
    ade_tabla: str = Field(..., min_length=1, max_length=64, description="Nombre físico de tabla (uq_auditoria_entidad_tabla)")
    ade_descripcion: str | None = Field(None, max_length=255)

    model_config = {"from_attributes": True}


class AuditoriaEntidadCreate(AuditoriaEntidadBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class AuditoriaEntidadOut(AuditoriaEntidadBase, CatalogBaseOut):
    ade_id: str = Field(..., description="PK UUID")


class AuditoriaAccionBase(BaseModel):
    ada_accion: str = Field(..., min_length=1, max_length=30, description="Acción ej INSERT, UPDATE, DELETE, LOGIN (uq_auditoria_accion)")
    ada_descripcion: str | None = Field(None, max_length=255)

    model_config = {"from_attributes": True}


class AuditoriaAccionCreate(AuditoriaAccionBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class AuditoriaAccionOut(AuditoriaAccionBase, CatalogBaseOut):
    ada_id: str = Field(..., description="PK UUID")


# ---------------------------------------------------------------------------
# 8. Patrones de compra (UNICA, CASUAL, RECURRENTE, ESTACIONAL, DESCONOCIDO)
# ---------------------------------------------------------------------------

class PatronCompraBase(BaseModel):
    pat_codigo: str = Field(..., min_length=1, max_length=30, description="UNICA | CASUAL | RECURRENTE | ESTACIONAL | DESCONOCIDO (uq_patron_codigo)")
    pat_nombre: str = Field(..., min_length=1, max_length=100)
    pat_descripcion: str | None = Field(None, max_length=255)

    model_config = {"from_attributes": True}


class PatronCompraCreate(PatronCompraBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class PatronCompraUpdate(BaseModel):
    pat_codigo: str | None = Field(None, min_length=1, max_length=30)
    pat_nombre: str | None = Field(None, min_length=1, max_length=100)
    pat_descripcion: str | None = Field(None, max_length=255)
    estado: int | None = None

    model_config = {"from_attributes": True}


class PatronCompraOut(PatronCompraBase, CatalogBaseOut):
    pat_id: str = Field(..., description="PK UUID")
