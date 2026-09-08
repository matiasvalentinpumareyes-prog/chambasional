"""
Schemas para tenancy: empresa, usuario_personal, usuario — sección 2 DATABASE.md.

Tablas:
  empresa (emp_id) — tenant raíz, única tabla sin emp_id (es el tenant)
  usuario_personal (usp_id, emp_id) — ficha personal por empresa
  usuario (usu_id, emp_id, rol_id, usp_id) — login por empresa

Referencia: backend/db/database_postgres.sql:148-221
Nombres exactos a BD (español donde la BD es español: emp_id, usu_id, usp_id).
"""

from datetime import datetime

from pydantic import BaseModel, EmailStr, Field


# ---------------------------------------------------------------------------
# Empresa (tenant)
# ---------------------------------------------------------------------------

class EmpresaBase(BaseModel):
    emp_ruc: str = Field(..., min_length=11, max_length=11, description="RUC 11 dígitos (uq_empresa_ruc)")
    emp_razon_social: str = Field(..., min_length=1, max_length=255)
    emp_nombre_comercial: str = Field(..., min_length=1, max_length=255)
    emp_direccion: str | None = Field(None, max_length=255)
    emp_lema: str | None = Field(None, max_length=255)
    emp_email: EmailStr | None = Field(None, description="Email corporativo")
    emp_celular1: str | None = Field(None, max_length=20)
    emp_celular2: str | None = Field(None, max_length=20)
    emp_telefono1: str | None = Field(None, max_length=20)
    emp_telefono2: str | None = Field(None, max_length=20)
    emp_nro_cuenta1: str | None = Field(None, max_length=100)
    emp_nro_cuenta2: str | None = Field(None, max_length=100)
    # emp_logo BYTEA no se expone como base64 en schema base para evitar payloads gigantes
    dep_id: str | None = Field(None, description="FK departamento.dep_id")
    prv_id: str | None = Field(None, description="FK provincia.prv_id")
    dis_id: str | None = Field(None, description="FK distrito.dis_id")

    model_config = {"from_attributes": True}


class EmpresaCreate(EmpresaBase):
    """Payload creación de empresa (solo superadmin)."""

    estado: int = Field(default=1)
    created_by: str | None = None


class EmpresaUpdate(BaseModel):
    """Patch parcial de empresa."""

    emp_ruc: str | None = Field(None, min_length=11, max_length=11)
    emp_razon_social: str | None = Field(None, min_length=1, max_length=255)
    emp_nombre_comercial: str | None = Field(None, min_length=1, max_length=255)
    emp_direccion: str | None = Field(None, max_length=255)
    emp_lema: str | None = Field(None, max_length=255)
    emp_email: EmailStr | None = None
    emp_celular1: str | None = Field(None, max_length=20)
    emp_celular2: str | None = Field(None, max_length=20)
    emp_telefono1: str | None = Field(None, max_length=20)
    emp_telefono2: str | None = Field(None, max_length=20)
    emp_nro_cuenta1: str | None = Field(None, max_length=100)
    emp_nro_cuenta2: str | None = Field(None, max_length=100)
    dep_id: str | None = None
    prv_id: str | None = None
    dis_id: str | None = None
    estado: int | None = None

    model_config = {"from_attributes": True}


class EmpresaOut(EmpresaBase):
    emp_id: str = Field(..., description="PK UUID (uuid_generate_v1mc())")
    estado: int = Field(..., description="1 activo")
    created_at: datetime | None = None
    updated_at: datetime | None = None
    created_by: str | None = None
    updated_by: str | None = None

    # Campos resueltos (opcionales) para UI
    departamento_nombre: str | None = None
    provincia_nombre: str | None = None
    distrito_nombre: str | None = None

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Usuario personal (ficha)
# ---------------------------------------------------------------------------

class UsuarioPersonalBase(BaseModel):
    emp_id: str = Field(..., description="FK empresa.emp_id (tenant)")
    usp_dni: str | None = Field(None, min_length=8, max_length=8, description="DNI 8 dígitos (uq_usuario_personal_emp_dni)")
    usp_nombres: str = Field(..., min_length=1, max_length=255, description="Nombres completos")
    usp_celular: str | None = Field(None, max_length=20)

    model_config = {"from_attributes": True}


class UsuarioPersonalCreate(UsuarioPersonalBase):
    estado: int = Field(default=1)
    created_by: str | None = None


class UsuarioPersonalUpdate(BaseModel):
    usp_dni: str | None = Field(None, min_length=8, max_length=8)
    usp_nombres: str | None = Field(None, min_length=1, max_length=255)
    usp_celular: str | None = Field(None, max_length=20)
    estado: int | None = None

    model_config = {"from_attributes": True}


class UsuarioPersonalOut(UsuarioPersonalBase):
    usp_id: str = Field(..., description="PK UUID")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None
    created_by: str | None = None
    updated_by: str | None = None

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Usuario (cuenta login) — refleja tabla usuario + roles
# ---------------------------------------------------------------------------

class UsuarioBase(BaseModel):
    emp_id: str = Field(..., description="Tenant empresa.emp_id")
    usu_usuario: str = Field(..., min_length=3, max_length=100, description="Username único por empresa (uq_usuario_emp_usuario)")
    usu_email: EmailStr = Field(..., description="Email único por empresa (uq_usuario_emp_email)")
    rol_id: str | None = Field(None, description="FK roles.rol_id (nullable)")
    usp_id: str | None = Field(None, description="FK compuesta (emp_id, usp_id) -> usuario_personal")

    model_config = {"from_attributes": True}


class UsuarioCreate(UsuarioBase):
    """Creación de usuario. La password se envía en claro y se hashea en el servicio."""

    password: str = Field(..., min_length=8, max_length=128, description="Contraseña en claro; se guarda como usu_password_hash")
    estado: int = Field(default=1)
    created_by: str | None = None


class UsuarioUpdate(BaseModel):
    usu_usuario: str | None = Field(None, min_length=3, max_length=100)
    usu_email: EmailStr | None = None
    password: str | None = Field(None, min_length=8, max_length=128, description="Si se envía, se re-hashea")
    rol_id: str | None = None
    usp_id: str | None = None
    estado: int | None = None

    model_config = {"from_attributes": True}


class UsuarioOut(UsuarioBase):
    usu_id: str = Field(..., description="PK UUID")
    estado: int
    created_at: datetime | None = None
    updated_at: datetime | None = None
    created_by: str | None = None
    updated_by: str | None = None

    # Campos resueltos
    rol_nombre: str | None = Field(None, description="Nombre del rol resuelto")
    persona_nombres: str | None = Field(None, description="Nombres de usuario_personal resuelto")
    empresa_nombre: str | None = Field(None, description="Nombre comercial de la empresa")

    model_config = {"from_attributes": True}


# ---------------------------------------------------------------------------
# Configuración empresa (antes BusinessSettings en misc.py) — no tabla, DTO
# ---------------------------------------------------------------------------

class DiscountRule(BaseModel):
    seg_codigo: str = Field(..., description="segmentos.seg_codigo")
    max_descuento_pct: float = Field(..., ge=0, le=100)
    model_config = {"from_attributes": True}

class EmpresaSettingsOut(BaseModel):
    emp_id: str = Field(..., description="empresa.emp_id")
    emp_nombre_comercial: str = Field(..., description="empresa.emp_nombre_comercial")
    emp_email: str | None = None
    estado: int
    created_at: datetime | None = None
    model_config = {"from_attributes": True}

class EmpresaSettingsUpdate(BaseModel):
    emp_nombre_comercial: str | None = Field(None, max_length=255)
    emp_email: str | None = None
    emp_direccion: str | None = None
    estado: int | None = None
    model_config = {"from_attributes": True}

# Alias legacy para compatibilidad (BusinessSettings -> EmpresaSettings)
BusinessSettingsOut = EmpresaSettingsOut
BusinessSettingsUpdate = EmpresaSettingsUpdate


