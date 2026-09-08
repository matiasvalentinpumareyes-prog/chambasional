import uuid
from datetime import date, datetime
from sqlalchemy import String, Text, SmallInteger, Integer, Numeric, Date, ForeignKey, UniqueConstraint, ForeignKeyConstraint, CheckConstraint, JSON
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.models.base import Base, TimestampMixin

def gen_uuid() -> str:
    return str(uuid.uuid4())

class Cliente(Base, TimestampMixin):
    __tablename__ = "cliente"
    __table_args__ = (
        UniqueConstraint("emp_id", "cli_id", name="uq_cliente_emp_cli"),
        UniqueConstraint("emp_id", "doc_id", "cli_ndocumento", name="uq_cliente_emp_documento"),
        UniqueConstraint("emp_id", "cli_email", name="uq_cliente_emp_email"),
    )

    cli_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    doc_id: Mapped[str] = mapped_column(ForeignKey("documento.doc_id"), nullable=False)
    cli_ndocumento: Mapped[str | None] = mapped_column(String(15), nullable=True)
    cli_nombre_razon_social: Mapped[str] = mapped_column(String(255), nullable=False)
    cli_direccion: Mapped[str | None] = mapped_column(String(255), nullable=True)
    cli_email: Mapped[str | None] = mapped_column(String(150), nullable=True)
    cli_celular: Mapped[str | None] = mapped_column(String(30), nullable=True)
    cli_birthday: Mapped[date | None] = mapped_column(Date, nullable=True)
    cli_genero: Mapped[int | None] = mapped_column(SmallInteger, nullable=True)
    dep_id: Mapped[str | None] = mapped_column(ForeignKey("departamento.dep_id"), nullable=True)
    prv_id: Mapped[str | None] = mapped_column(ForeignKey("provincia.prv_id"), nullable=True)
    dis_id: Mapped[str | None] = mapped_column(ForeignKey("distrito.dis_id"), nullable=True)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)

    empresa: Mapped["app.models.empresa.Empresa"] = relationship()
    documento: Mapped["app.models.catalogs.Documento"] = relationship()


class ClienteConsentimiento(Base, TimestampMixin):
    __tablename__ = "cliente_consentimientos"
    __table_args__ = (
        UniqueConstraint("emp_id", "cli_id", "can_id", name="uq_consentimiento_cliente_canal"),
        ForeignKeyConstraint(["emp_id", "cli_id"], ["cliente.emp_id", "cliente.cli_id"], name="fk_consentimiento_cliente"),
    )

    cco_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    cli_id: Mapped[str] = mapped_column(String(36), nullable=False)
    can_id: Mapped[str] = mapped_column(ForeignKey("canales_marketing.can_id"), nullable=False)
    consentimiento: Mapped[int] = mapped_column(SmallInteger, default=0, nullable=False)
    fecha_otorgado: Mapped[datetime | None] = mapped_column(nullable=True)
    fecha_revocado: Mapped[datetime | None] = mapped_column(nullable=True)
    fuente: Mapped[str | None] = mapped_column(String(100), nullable=True)
    evidencia: Mapped[str | None] = mapped_column(String(255), nullable=True)
    version_politica: Mapped[str | None] = mapped_column(String(50), nullable=True)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)


class ClienteSegmento(Base, TimestampMixin):
    __tablename__ = "cliente_segmento"
    __table_args__ = (
        UniqueConstraint("emp_id", "cli_id", name="uq_cliente_segmento_actual"),
        ForeignKeyConstraint(["emp_id", "cli_id"], ["cliente.emp_id", "cliente.cli_id"], name="fk_cliente_segmento_cliente"),
    )

    cli_segmento_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    cli_id: Mapped[str] = mapped_column(String(36), nullable=False)
    seg_id: Mapped[str] = mapped_column(ForeignKey("segmentos.seg_id"), nullable=False)
    puntuacion: Mapped[float | None] = mapped_column(Numeric(8, 5), nullable=True)
    fecha_asignacion: Mapped[datetime] = mapped_column(nullable=False)
    estado: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)


class ClienteSegmentoHistorial(Base, TimestampMixin):
    __tablename__ = "cliente_segmento_historial"
    __table_args__ = (
        ForeignKeyConstraint(["emp_id", "cli_id"], ["cliente.emp_id", "cliente.cli_id"], name="fk_segmento_hist_cliente"),
    )

    csh_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    cli_id: Mapped[str] = mapped_column(String(36), nullable=False)
    seg_anterior_id: Mapped[str | None] = mapped_column(ForeignKey("segmentos.seg_id"), nullable=True)
    seg_nuevo_id: Mapped[str] = mapped_column(ForeignKey("segmentos.seg_id"), nullable=False)
    puntuacion_anterior: Mapped[float | None] = mapped_column(Numeric(8, 5), nullable=True)
    puntuacion_nueva: Mapped[float | None] = mapped_column(Numeric(8, 5), nullable=True)
    motivo: Mapped[str | None] = mapped_column(String(150), nullable=True)
    changed_at: Mapped[datetime] = mapped_column(nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)


class ClienteFeatures(Base, TimestampMixin):
    __tablename__ = "cliente_features"
    __table_args__ = (
        UniqueConstraint("emp_id", "cli_id", "fecha_snapshot", name="uq_features_cliente_snapshot"),
        ForeignKeyConstraint(["emp_id", "cli_id"], ["cliente.emp_id", "cliente.cli_id"], name="fk_features_cliente"),
        ForeignKeyConstraint(["emp_id", "categoria_favorita_id"], ["categorias.emp_id", "categorias.cat_id"], name="fk_features_categoria"),
        ForeignKeyConstraint(["emp_id", "producto_favorito_id"], ["producto.emp_id", "producto.prd_id"], name="fk_features_producto"),
    )

    cft_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    cli_id: Mapped[str] = mapped_column(String(36), nullable=False)
    fecha_snapshot: Mapped[datetime] = mapped_column(nullable=False)
    recencia_dias: Mapped[int | None] = mapped_column(Integer, nullable=True)
    frecuencia_30d: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    frecuencia_90d: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    frecuencia_365d: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    ticket_promedio: Mapped[float] = mapped_column(Numeric(14, 2), default=0, nullable=False)
    gasto_total_30d: Mapped[float] = mapped_column(Numeric(14, 2), default=0, nullable=False)
    gasto_total_90d: Mapped[float] = mapped_column(Numeric(14, 2), default=0, nullable=False)
    gasto_total_365d: Mapped[float] = mapped_column(Numeric(14, 2), default=0, nullable=False)
    dias_desde_ultima_compra: Mapped[int | None] = mapped_column(Integer, nullable=True)
    categoria_favorita_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    producto_favorito_id: Mapped[str | None] = mapped_column(String(36), nullable=True)
    margen_estimado_90d: Mapped[float | None] = mapped_column(Numeric(14, 2), nullable=True)
    descuento_promedio_90d: Mapped[float | None] = mapped_column(Numeric(14, 2), nullable=True)
    valor_vida_estimado: Mapped[float | None] = mapped_column(Numeric(14, 2), nullable=True)
    score_churn: Mapped[float | None] = mapped_column(Numeric(8, 5), nullable=True)
    metadata_json: Mapped[dict | None] = mapped_column("metadata", JSON, nullable=True)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    # ALTER 982
    total_compras_historicas: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    intervalo_promedio_dias: Mapped[float | None] = mapped_column(Numeric(8, 2), nullable=True)
    intervalo_desviacion_dias: Mapped[float | None] = mapped_column(Numeric(8, 2), nullable=True)
    intervalo_cv: Mapped[float | None] = mapped_column(Numeric(6, 4), nullable=True)
    pat_id: Mapped[str | None] = mapped_column(ForeignKey("patrones_compra.pat_id"), nullable=True)
    ratio_riesgo_actual: Mapped[float | None] = mapped_column(Numeric(8, 4), nullable=True)


class ClienteEstacionalidad(Base, TimestampMixin):
    __tablename__ = "cliente_estacionalidad"
    __table_args__ = (
        UniqueConstraint("emp_id", "cli_id", "mes", name="uq_estacionalidad_cliente_mes"),
        CheckConstraint("mes BETWEEN 1 AND 12", name="chk_estacionalidad_mes"),
        ForeignKeyConstraint(["emp_id", "cli_id"], ["cliente.emp_id", "cliente.cli_id"], name="fk_estacionalidad_cliente"),
    )

    ces_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    cli_id: Mapped[str] = mapped_column(String(36), nullable=False)
    mes: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    num_compras_historicas: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    gasto_total_mes: Mapped[float] = mapped_column(Numeric(14, 2), default=0, nullable=False)
    gasto_promedio_mes: Mapped[float] = mapped_column(Numeric(14, 2), default=0, nullable=False)
    ultima_actualizacion: Mapped[datetime] = mapped_column(nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)


class TipoDireccionExplicacion(Base):
    __tablename__ = "tipos_direccion_explicacion"
    __table_args__ = (
        UniqueConstraint("emp_id", "tde_id", name="uq_tipo_direccion_empresa_id"),
        UniqueConstraint("emp_id", "codigo", name="uq_tipo_direccion_codigo"),
    )

    tde_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(ForeignKey("empresa.emp_id"), nullable=False)
    codigo: Mapped[str] = mapped_column(String(50), nullable=False)
    nombre: Mapped[str] = mapped_column(String(100), nullable=False)
    descripcion: Mapped[str | None] = mapped_column(String(255), nullable=True)
    activo: Mapped[int] = mapped_column(SmallInteger, default=1, nullable=False)


class PrediccionExplicacion(Base, TimestampMixin):
    __tablename__ = "prediccion_explicaciones"
    __table_args__ = (
        UniqueConstraint("emp_id", "pdc_id", "feature_nombre", name="uq_explicacion_pdc_feature"),
        ForeignKeyConstraint(["emp_id", "pdc_id"], ["predicciones.emp_id", "predicciones.pdc_id"], name="fk_explicacion_prediccion"),
        ForeignKeyConstraint(["emp_id", "tde_id"], ["tipos_direccion_explicacion.emp_id", "tipos_direccion_explicacion.tde_id"], name="fk_explicacion_tipo_direccion"),
    )

    pex_id: Mapped[str] = mapped_column(String(36), primary_key=True, default=gen_uuid)
    emp_id: Mapped[str] = mapped_column(String(36), nullable=False)
    pdc_id: Mapped[str] = mapped_column(String(36), nullable=False)
    tde_id: Mapped[str] = mapped_column(String(36), nullable=False)
    feature_nombre: Mapped[str] = mapped_column(String(100), nullable=False)
    feature_valor: Mapped[str | None] = mapped_column(String(150), nullable=True)
    impacto: Mapped[float] = mapped_column(Numeric(10, 6), nullable=False)
    orden_importancia: Mapped[int] = mapped_column(Integer, default=1, nullable=False)
    created_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
    updated_by: Mapped[str | None] = mapped_column(String(100), nullable=True)
