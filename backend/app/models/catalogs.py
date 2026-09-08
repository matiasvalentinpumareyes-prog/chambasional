import uuid
from datetime import datetime

from sqlalchemy import String, Text, SmallInteger, UniqueConstraint, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base, TimestampMixin


def gen_uuid() -> str:
    return str(uuid.uuid4())

class Departamento(Base, TimestampMixin):
    __tablename__ = "departamento"
    __table_args__ = (UniqueConstraint("dep_nombre", name="uq_departamento_nombre"),)

    dep_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    dep_nombre: Mapped[str] = mapped_column(String(100), nullable=False)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    provincias: Mapped[list["Provincia"]] = relationship(back_populates="departamento")


class Provincia(Base, TimestampMixin):
    __tablename__ = "provincia"
    __table_args__ = (
        UniqueConstraint("dep_id", "prv_nombre", name="uq_provincia_dep_nombre"),
    )

    prv_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    dep_id: Mapped[str] = mapped_column(ForeignKey("departamento.dep_id"), nullable=False)
    prv_nombre: Mapped[str] = mapped_column(String(100), nullable=False)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    departamento: Mapped["Departamento"] = relationship(back_populates="provincias")
    distritos: Mapped[list["Distrito"]] = relationship(back_populates="provincia")


class Distrito(Base, TimestampMixin):
    __tablename__ = "distrito"
    __table_args__ = (
        UniqueConstraint("prv_id", "dis_nombre", name="uq_distrito_prv_nombre"),
    )

    dis_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    prv_id: Mapped[str] = mapped_column(ForeignKey("provincia.prv_id"), nullable=False)
    dis_nombre: Mapped[str] = mapped_column(String(100), nullable=False)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    provincia: Mapped["Provincia"] = relationship(back_populates="distritos")


class Documento(Base, TimestampMixin):
    __tablename__ = "documento"
    __table_args__ = (UniqueConstraint("doc_tipo", name="uq_documento_tipo"),)

    doc_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    doc_tipo: Mapped[str] = mapped_column(String(100), nullable=False)
    doc_descripcion: Mapped[str | None] = mapped_column(String(100), nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)


class MetodoPago(Base, TimestampMixin):
    __tablename__ = "metodos_pago"
    __table_args__ = (UniqueConstraint("mtp_nombre", name="uq_metodo_pago_nombre"),)

    mtp_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    mtp_nombre: Mapped[str] = mapped_column(String(50), nullable=False)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)


class CanalMarketing(Base, TimestampMixin):
    __tablename__ = "canales_marketing"
    __table_args__ = (
        UniqueConstraint("can_codigo", name="uq_canal_codigo"),
        UniqueConstraint("can_nombre", name="uq_canal_nombre"),
    )

    can_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    can_codigo: Mapped[str] = mapped_column(String(30), nullable=False)
    can_nombre: Mapped[str] = mapped_column(String(100), nullable=False)
    requiere_consentimiento: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)


class Segmento(Base, TimestampMixin):
    __tablename__ = "segmentos"
    __table_args__ = (
        UniqueConstraint("seg_codigo", name="uq_segmento_codigo"),
        UniqueConstraint("seg_nombre", name="uq_segmento_nombre"),
    )

    seg_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    seg_codigo: Mapped[str] = mapped_column(String(50), nullable=False)
    seg_nombre: Mapped[str] = mapped_column(String(100), nullable=False)
    seg_descripcion: Mapped[str | None] = mapped_column(String(255), nullable=True)
    seg_tipo: Mapped[str | None] = mapped_column(String(50), nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)


class Rol(Base, TimestampMixin):
    __tablename__ = "roles"
    __table_args__ = (
        UniqueConstraint("rol_codigo", name="uq_rol_codigo"),
        UniqueConstraint("rol_nombre", name="uq_rol_nombre"),
    )

    rol_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    rol_codigo: Mapped[str] = mapped_column(String(50), nullable=False)
    rol_nombre: Mapped[str] = mapped_column(String(100), nullable=False)
    rol_descripcion: Mapped[str | None] = mapped_column(String(255), nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)


class AuditoriaEntidad(Base, TimestampMixin):
    __tablename__ = "auditoria_entidades"
    __table_args__ = (
        UniqueConstraint("ade_codigo", name="uq_auditoria_entidad_codigo"),
        UniqueConstraint("ade_tabla", name="uq_auditoria_entidad_tabla"),
    )

    ade_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    ade_codigo: Mapped[str] = mapped_column(String(50), nullable=False)
    ade_nombre: Mapped[str] = mapped_column(String(100), nullable=False)
    ade_tabla: Mapped[str] = mapped_column(String(64), nullable=False)
    ade_descripcion: Mapped[str | None] = mapped_column(String(255), nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)


class AuditoriaAccion(Base, TimestampMixin):
    __tablename__ = "auditoria_accion"
    __table_args__ = (UniqueConstraint("ada_accion", name="uq_auditoria_accion"),)

    ada_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    ada_accion: Mapped[str] = mapped_column(String(30), nullable=False)
    ada_descripcion: Mapped[str | None] = mapped_column(String(255), nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)


class PatronCompra(Base, TimestampMixin):
    __tablename__ = "patrones_compra"
    __table_args__ = (
        UniqueConstraint("pat_codigo", name="uq_patron_codigo"),
        UniqueConstraint("pat_nombre", name="uq_patron_nombre"),
    )

    pat_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    pat_codigo: Mapped[str] = mapped_column(String(30), nullable=False)
    pat_nombre: Mapped[str] = mapped_column(String(100), nullable=False)
    pat_descripcion: Mapped[str | None] = mapped_column(String(255), nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
