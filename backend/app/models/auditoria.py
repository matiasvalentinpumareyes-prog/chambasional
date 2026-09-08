import uuid
from datetime import datetime

from sqlalchemy import String, Text, SmallInteger, Integer, ForeignKey, UniqueConstraint, ForeignKeyConstraint, JSON
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base, TimestampMixin


def gen_uuid() -> str:
    return str(uuid.uuid4())


class AuditoriaLog(Base, TimestampMixin):
    __tablename__ = "auditoria_logs"
    __table_args__ = (
        ForeignKeyConstraint(["emp_id", "usu_id"], ["usuario.emp_id", "usuario.usu_id"], name="fk_auditoria_usuario"),
    )

    adl_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    usu_id: Mapped[str] = mapped_column(String(36), nullable=False)
    ade_id: Mapped[str] = mapped_column(ForeignKey("auditoria_entidades.ade_id"), nullable=False)
    ada_id: Mapped[str] = mapped_column(ForeignKey("auditoria_accion.ada_id"), nullable=False)
    adl_tabla: Mapped[str] = mapped_column(String(64), nullable=False)
    adl_registro_id: Mapped[str] = mapped_column(String(100), nullable=False)
    adl_usuario: Mapped[str] = mapped_column(String(100), nullable=False)
    adl_fecha_hora: Mapped[datetime] = mapped_column(nullable=False)
    adl_valor_anterior: Mapped[dict | None] = mapped_column(JSON, nullable=True)
    adl_valor_nuevo: Mapped[dict | None] = mapped_column(JSON, nullable=True)
    ip_address: Mapped[str | None] = mapped_column(String(45), nullable=True)
    user_agent: Mapped[str | None] = mapped_column(Text, nullable=True)


class Import(Base, TimestampMixin):
    __tablename__ = "imports"
    __table_args__ = (
        ForeignKeyConstraint(["emp_id", "usu_id"], ["usuario.emp_id", "usuario.usu_id"], name="fk_import_usuario"),
    )

    imp_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    usu_id: Mapped[str] = mapped_column(String(36), nullable=False)
    file_name: Mapped[str] = mapped_column(String(255), nullable=False)
    file_type: Mapped[str | None] = mapped_column(String(50), nullable=True)
    total_rows: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    successful_rows: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    failed_rows: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    estado: Mapped[int] = mapped_column(SmallInteger, default=2, nullable=False)
    started_at: Mapped[datetime | None] = mapped_column(nullable=True)
    completed_at: Mapped[datetime | None] = mapped_column(nullable=True)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    usuario: Mapped["app.models.empresa.Usuario"] = relationship(foreign_keys="[Import.emp_id, Import.usu_id]")
    errors: Mapped[list["ImportError"]] = relationship(back_populates="import_", cascade="all, delete-orphan")


class ImportError(Base, TimestampMixin):
    __tablename__ = "import_errors"

    imp_error_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    imp_id: Mapped[str] = mapped_column(ForeignKey("imports.imp_id"), nullable=False)
    imp_error_row_number: Mapped[int | None] = mapped_column(Integer, nullable=True)
    imp_error_field_name: Mapped[str | None] = mapped_column(String(100), nullable=True)
    error_type: Mapped[str | None] = mapped_column(String(100), nullable=True)
    error_message: Mapped[str] = mapped_column(Text, nullable=False)
    raw_data: Mapped[dict | None] = mapped_column(JSON, nullable=True)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    import_: Mapped["Import"] = relationship(back_populates="errors")
