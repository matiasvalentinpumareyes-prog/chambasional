import uuid
from datetime import datetime

from sqlalchemy import String, Text, SmallInteger, LargeBinary, ForeignKey, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base, TimestampMixin


def gen_uuid() -> str:
    return str(uuid.uuid4())


class Empresa(Base, TimestampMixin):
    __tablename__ = "empresa"
    __table_args__ = (UniqueConstraint("emp_ruc", name="uq_empresa_ruc"),)

    emp_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_ruc: Mapped[str] = mapped_column(String(11), nullable=False)
    emp_razon_social: Mapped[str] = mapped_column(String(255), nullable=False)
    emp_nombre_comercial: Mapped[str] = mapped_column(String(255), nullable=False)
    emp_direccion: Mapped[str | None] = mapped_column(String(255), nullable=True)
    emp_lema: Mapped[str | None] = mapped_column(String(255), nullable=True)
    emp_email: Mapped[str | None] = mapped_column(String(150), nullable=True)
    emp_celular1: Mapped[str | None] = mapped_column(String(20), nullable=True)
    emp_celular2: Mapped[str | None] = mapped_column(String(20), nullable=True)
    emp_telefono1: Mapped[str | None] = mapped_column(String(20), nullable=True)
    emp_telefono2: Mapped[str | None] = mapped_column(String(20), nullable=True)
    emp_nro_cuenta1: Mapped[str | None] = mapped_column(String(100), nullable=True)
    emp_nro_cuenta2: Mapped[str | None] = mapped_column(String(100), nullable=True)
    emp_logo: Mapped[bytes | None] = mapped_column(LargeBinary, nullable=True)
    dep_id: Mapped[str | None] = mapped_column(ForeignKey("departamento.dep_id"), nullable=True)
    prv_id: Mapped[str | None] = mapped_column(ForeignKey("provincia.prv_id"), nullable=True)
    dis_id: Mapped[str | None] = mapped_column(ForeignKey("distrito.dis_id"), nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    departamento: Mapped["app.models.catalogs.Departamento | None"] = relationship()
    provincia: Mapped["app.models.catalogs.Provincia | None"] = relationship()
    distrito: Mapped["app.models.catalogs.Distrito | None"] = relationship()


class UsuarioPersonal(Base, TimestampMixin):
    __tablename__ = "usuario_personal"
    __table_args__ = (
        UniqueConstraint("emp_id", "usp_dni", name="uq_usuario_personal_emp_dni"),
        UniqueConstraint("emp_id", "usp_id", name="uq_usuario_personal_emp_id"),
    )

    usp_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    usp_dni: Mapped[str | None] = mapped_column(String(8), nullable=True)
    usp_nombres: Mapped[str] = mapped_column(String(255), nullable=False)
    usp_celular: Mapped[str | None] = mapped_column(String(20), nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    empresa: Mapped["Empresa"] = relationship()


class Usuario(Base, TimestampMixin):
    __tablename__ = "usuario"
    __table_args__ = (
        UniqueConstraint("emp_id", "usu_usuario", name="uq_usuario_emp_usuario"),
        UniqueConstraint("emp_id", "usu_email", name="uq_usuario_emp_email"),
        UniqueConstraint("emp_id", "usu_id", name="uq_usuario_emp_usu"),
        # FK compuesta a usuario_personal
        # definida abajo via ForeignKeyConstraint
    )

    usu_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    usu_usuario: Mapped[str] = mapped_column(String(100), nullable=False)
    usu_password_hash: Mapped[str] = mapped_column(String(255), nullable=False)
    usu_email: Mapped[str] = mapped_column(String(150), nullable=False)
    rol_id: Mapped[str | None] = mapped_column(ForeignKey("roles.rol_id"), nullable=True)
    usp_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    empresa: Mapped["Empresa"] = relationship()
    rol: Mapped["app.models.catalogs.Rol | None"] = relationship()

    # Nota: FK compuesta (emp_id, usp_id) -> usuario_personal(emp_id, usp_id)
    # SQLAlchemy la valida vía UniqueConstraint uq_usuario_personal_emp_id; se define como ForeignKeyConstraint
    # pero para mantener nombres exactos BD, se deja como constraint en migración Alembic.
