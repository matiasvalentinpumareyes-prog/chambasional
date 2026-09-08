"""bd real 43 tablas — db_regresape PostgreSQL 16

Revision ID: 0001_bd_real_43_tablas
Revises: 
Create Date: 2026-09-18
Fuente: backend/db/database_postgres.sql:1 ( CREATE EXTENSION uuid-ossp + 43 tablas + 33 triggers + seeds )

Esta migración refleja EXACTAMENTE la BD real: nombres en español/inglés tal cual,
estado SMALLINT, PK UUID DEFAULT uuid_generate_v1mc(), FKs compuestas, CHECK mes 1..12.
Usa Base.metadata.create_all para garantizar 1:1 con app/models (Fase 1).
"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = '0001_bd_real_43_tablas'
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Crea extensión y tablas directamente desde los modelos (43 tablas)
    # El DDL exacto coincide con database_postgres.sql; se delega a SQLAlchemy metadata
    # para evitar duplicar 1300 líneas de op.create_table manual.
    from app.models.base import Base
    import app.models  # noqa: F401 ensure registration
    bind = op.get_bind()
    # Crear extensión uuid-ossp requerida por defaults uuid_generate_v1mc()
    bind.execute(sa.text('CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'))
    Base.metadata.create_all(bind=bind)

    # Crear función y triggers set_updated_at (equivalente a database_postgres.sql:1121)
    bind.execute(sa.text("""
    CREATE OR REPLACE FUNCTION set_updated_at()
    RETURNS TRIGGER AS $$
    BEGIN
        NEW.updated_at = CURRENT_TIMESTAMP;
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
    """))
    # Triggers para todas las tablas con updated_at (33 triggers en SQL original)
    tablas_con_updated_at = [
        "departamento","provincia","distrito","documento","metodos_pago","canales_marketing",
        "segmentos","roles","auditoria_entidades","auditoria_accion","empresa","usuario_personal",
        "usuario","categorias","producto_marca","producto","producto_precios","producto_stock",
        "cliente","cliente_consentimientos","ventas","venta_items","cliente_segmento",
        "cliente_segmento_historial","cliente_features","version_modelo","model_metrics",
        "predicciones","estrategias","rules","cupones","recomendaciones","campaigns",
        "campaign_recipients","communicaciones","cupon_canjes","auditoria_logs","imports",
        "import_errors","patrones_compra","cliente_estacionalidad","prediccion_explicaciones"
    ]
    for tabla in tablas_con_updated_at:
        # tipos_direccion_explicacion no tiene updated_at, se excluye a propósito
        bind.execute(sa.text(f'DROP TRIGGER IF EXISTS trg_{tabla}_updated_at ON {tabla}'))
        bind.execute(sa.text(f"""
        CREATE TRIGGER trg_{tabla}_updated_at
        BEFORE UPDATE ON {tabla}
        FOR EACH ROW
        EXECUTE FUNCTION set_updated_at();
        """))

    # Seeds idempotentes (canales_marketing, segmentos, roles, auditoria_accion, patrones_compra)
    # Se ejecutan igual que en database_postgres.sql:915-979 con ON CONFLICT DO NOTHING ya manejado por PK
    bind.execute(sa.text("""
    INSERT INTO canales_marketing (can_id, can_codigo, can_nombre, requiere_consentimiento, estado) VALUES
        (uuid_generate_v1mc(), 'EMAIL', 'Correo electrónico', 1, 1),
        (uuid_generate_v1mc(), 'SMS', 'SMS', 1, 1),
        (uuid_generate_v1mc(), 'WHATSAPP', 'WhatsApp', 1, 1),
        (uuid_generate_v1mc(), 'PUSH', 'Notificación push', 1, 1)
    ON CONFLICT DO NOTHING;
    """))
    bind.execute(sa.text("""
    INSERT INTO segmentos (seg_id, seg_codigo, seg_nombre, seg_descripcion, seg_tipo, estado) VALUES
        (uuid_generate_v1mc(), 'NUEVO', 'Nuevo', 'Cliente con pocas o ninguna compra histórica.', 'CICLO_VIDA', 1),
        (uuid_generate_v1mc(), 'ACTIVO', 'Activo', 'Cliente con actividad reciente.', 'CICLO_VIDA', 1),
        (uuid_generate_v1mc(), 'EN_RIESGO', 'En riesgo', 'Cliente con señales de pérdida de actividad.', 'CHURN', 1),
        (uuid_generate_v1mc(), 'PERDIDO', 'Perdido', 'Cliente sin compras durante un periodo definido.', 'CHURN', 1),
        (uuid_generate_v1mc(), 'RECUPERADO', 'Recuperado', 'Cliente que volvió a comprar después de una señal de riesgo o pérdida.', 'RECUPERACION', 1),
        (uuid_generate_v1mc(), 'LEAL', 'Leal', 'Cliente de alta recurrencia o valor.', 'VALOR', 1)
    ON CONFLICT DO NOTHING;
    """))
    bind.execute(sa.text("""
    INSERT INTO roles (rol_id, rol_codigo, rol_nombre, rol_descripcion, estado) VALUES
        (uuid_generate_v1mc(), 'SUPERADMIN', 'Super administrador', 'Administración técnica global.', 1),
        (uuid_generate_v1mc(), 'ADMIN_EMPRESA', 'Administrador de empresa', 'Administración de una empresa/tenant.', 1),
        (uuid_generate_v1mc(), 'MARKETING', 'Marketing', 'Gestión de campañas, segmentos y recuperación.', 1),
        (uuid_generate_v1mc(), 'OPERADOR', 'Operador', 'Operación comercial y consultas.', 1),
        (uuid_generate_v1mc(), 'AUDITOR', 'Auditor', 'Consulta de trazabilidad y auditoría.', 1)
    ON CONFLICT DO NOTHING;
    """))
    bind.execute(sa.text("""
    INSERT INTO auditoria_accion (ada_id, ada_accion, ada_descripcion, estado) VALUES
        (uuid_generate_v1mc(), 'INSERT', 'Creación de registro.', 1),
        (uuid_generate_v1mc(), 'UPDATE', 'Actualización de registro.', 1),
        (uuid_generate_v1mc(), 'DELETE', 'Eliminación de registro.', 1),
        (uuid_generate_v1mc(), 'LOGIN', 'Inicio de sesión.', 1),
        (uuid_generate_v1mc(), 'LOGOUT', 'Cierre de sesión.', 1),
        (uuid_generate_v1mc(), 'EXPORT', 'Exportación de información.', 1),
        (uuid_generate_v1mc(), 'IMPORT', 'Importación de información.', 1),
        (uuid_generate_v1mc(), 'CAMPAIGN_SEND', 'Ejecución de campaña.', 1),
        (uuid_generate_v1mc(), 'COUPON_REDEEM', 'Canje de cupón.', 1)
    ON CONFLICT DO NOTHING;
    """))
    bind.execute(sa.text("""
    INSERT INTO patrones_compra (pat_id, pat_codigo, pat_nombre, pat_descripcion, estado) VALUES
        (uuid_generate_v1mc(), 'UNICA', 'Compra única', 'Cliente con una sola compra histórica aún sin patrón definido.', 1),
        (uuid_generate_v1mc(), 'CASUAL', 'Casual', 'Compras irregulares, sin intervalo predecible entre ellas (CV alto).', 1),
        (uuid_generate_v1mc(), 'RECURRENTE', 'Recurrente', 'Compras frecuentes con intervalo regular y predecible (CV bajo).', 1),
        (uuid_generate_v1mc(), 'ESTACIONAL', 'Estacional', 'Compras concentradas en los mismos meses del año, repetidas en distintos años.', 1),
        (uuid_generate_v1mc(), 'DESCONOCIDO', 'Desconocido', 'Historial insuficiente para determinar un patrón (menos de 2-3 compras).', 1)
    ON CONFLICT DO NOTHING;
    """))


def downgrade() -> None:
    from app.models.base import Base
    import app.models  # noqa: F401
    bind = op.get_bind()
    Base.metadata.drop_all(bind=bind)
    bind.execute(sa.text('DROP FUNCTION IF EXISTS set_updated_at() CASCADE'))
