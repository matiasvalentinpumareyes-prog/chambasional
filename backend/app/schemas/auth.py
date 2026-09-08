from datetime import datetime

from pydantic import BaseModel, EmailStr, Field


class RegisterRequest(BaseModel):
    """Registro inicial de tenant — crea empresa + usuario_personal + usuario admin.

    Nombres exactos a BD: empresa.emp_ruc, emp_razon_social, emp_nombre_comercial,
    usuario_personal.usp_nombres/usp_dni, usuario.usu_usuario/usu_email, roles.rol_codigo.
    """

    emp_ruc: str = Field(..., min_length=11, max_length=11, description="RUC 11 dígitos (empresa.emp_ruc, uq_empresa_ruc)")
    emp_razon_social: str = Field(..., min_length=2, max_length=255, description="empresa.emp_razon_social")
    emp_nombre_comercial: str = Field(..., min_length=2, max_length=255, description="empresa.emp_nombre_comercial")
    emp_email: EmailStr | None = Field(None, description="empresa.emp_email")
    # persona
    usp_nombres: str = Field(..., min_length=2, max_length=255, description="usuario_personal.usp_nombres")
    usp_dni: str | None = Field(None, min_length=8, max_length=8, description="usuario_personal.usp_dni")
    # usuario login
    usu_usuario: str = Field(..., min_length=3, max_length=100, description="usuario.usu_usuario (uq_usuario_emp_usuario)")
    usu_email: EmailStr = Field(..., description="usuario.usu_email (uq_usuario_emp_email)")
    password: str = Field(..., min_length=8, max_length=128, description="Se hashea a usuario.usu_password_hash")
    rol_codigo: str = Field(default="ADMIN_EMPRESA", max_length=50, description="roles.rol_codigo (SUPERADMIN/ADMIN_EMPRESA/MARKETING/OPERADOR/AUDITOR)")


class LoginRequest(BaseModel):
    """Login por emp_id + credenciales. Acepta usu_usuario o usu_email.

    BD: usuario.usu_usuario / usuario.usu_email + usuario.usu_password_hash.
    """

    emp_id: str | None = Field(None, description="Opcional: empresa.emp_id para multi-tenant; si se omite se busca por email global")
    usu_usuario: str | None = Field(None, max_length=100, description="usuario.usu_usuario")
    usu_email: EmailStr | None = Field(None, description="usuario.usu_email")
    password: str = Field(..., min_length=1, description="Contraseña en claro")


class UsuarioOut(BaseModel):
    """Usuario expuesto — nombres exactos a BD (español donde la BD es español)."""

    usu_id: str = Field(..., description="usuario.usu_id PK UUID")
    emp_id: str = Field(..., description="usuario.emp_id FK empresa.emp_id")
    usu_usuario: str = Field(..., description="usuario.usu_usuario")
    usu_email: EmailStr = Field(..., description="usuario.usu_email")
    rol_id: str | None = Field(None, description="usuario.rol_id FK roles.rol_id")
    rol_codigo: str | None = Field(None, description="roles.rol_codigo resuelto")
    rol_nombre: str | None = Field(None, description="roles.rol_nombre resuelto")
    usp_id: str | None = Field(None, description="usuario.usp_id FK compuesta")
    usp_nombres: str | None = Field(None, description="usuario_personal.usp_nombres resuelto")
    emp_nombre_comercial: str = Field(..., description="empresa.emp_nombre_comercial resuelto")
    emp_ruc: str | None = Field(None, description="empresa.emp_ruc")
    estado: int = Field(..., description="usuario.estado SMALLINT 1 activo")
    created_at: datetime | None = None

    model_config = {"from_attributes": True}


class TokenResponse(BaseModel):
    """Respuesta tras login/register — token JWT + usuario.

    Wrapper `user` es DTO (inglés permitido); el contenido `UsuarioOut` usa nombres exactos BD (español).
    """

    token: str = Field(..., description="JWT con claims {sub: usu_id, emp_id, rol_codigo}")
    user: UsuarioOut = Field(..., description="Usuario autenticado — alias inglés de usuario (DTO)")
    # Alias español para nuevo código
    @property
    def usuario(self) -> UsuarioOut:
        return self.user

    model_config = {"from_attributes": True, "populate_by_name": True}
