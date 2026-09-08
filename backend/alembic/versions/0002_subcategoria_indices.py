"""subcategoria + indices producto — alinea a BD 44 tablas

Revision ID: 0002_subcategoria_indices
Revises: 0001_bd_real_43_tablas
Create Date: 2026-09-18
Añade tabla subcategorias:243, columna producto.subcat_id:282 y ajusta índices a database_postgres.sql actual (idx_producto_subcategoria en emp_id,subcat_id).
"""
from alembic import op
import sqlalchemy as sa

revision = '0002_subcategoria_indices'
down_revision = '0001_bd_real_43_tablas'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Crear tabla subcategorias si no existe (para BDs que ya tienen 0001 con 43 tablas)
    # Usamos Base.metadata para garantizar 1:1, pero creamos explícitamente para idempotencia
    try:
        op.create_table(
            'subcategorias',
            sa.Column('subcat_id', sa.String(length=36), nullable=False),
            sa.Column('emp_id', sa.String(length=36), nullable=False),
            sa.Column('cat_id', sa.String(length=36), nullable=False),
            sa.Column('subcat_nombre', sa.String(length=100), nullable=False),
            sa.Column('subcat_descripcion', sa.Text(), nullable=True),
            sa.Column('estado', sa.SmallInteger(), nullable=False, server_default='1'),
            sa.Column('created_at', sa.DateTime(timezone=True), nullable=False),
            sa.Column('updated_at', sa.DateTime(timezone=True), nullable=False),
            sa.Column('created_by', sa.String(length=100), nullable=True),
            sa.Column('updated_by', sa.String(length=100), nullable=True),
            sa.ForeignKeyConstraint(['emp_id'], ['empresa.emp_id'], name='fk_subcategoria_empresa'),
            sa.ForeignKeyConstraint(['emp_id', 'cat_id'], ['categorias.emp_id', 'categorias.cat_id'], name='fk_subcategoria_categoria'),
            sa.PrimaryKeyConstraint('subcat_id'),
            sa.UniqueConstraint('cat_id', 'subcat_nombre', name='uq_subcategoria_cat_nombre'),
            sa.UniqueConstraint('emp_id', 'subcat_id', name='uq_subcategoria_emp_id'),
            sa.UniqueConstraint('emp_id', 'cat_id', 'subcat_id', name='uq_subcategoria_emp_cat_id'),
        )
    except Exception:
        pass  # ya existe si 0001 se ejecutó con 44 tablas

    # Añadir columna subcat_id a producto si no existe
    try:
        op.add_column('producto', sa.Column('subcat_id', sa.String(length=36), nullable=True))
    except Exception:
        pass

    # Crear FK y CHECK para producto.subcat_id
    try:
        op.create_foreign_key('fk_producto_subcategoria', 'producto', 'subcategorias', ['emp_id', 'cat_id', 'subcat_id'], ['emp_id', 'cat_id', 'subcat_id'])
    except Exception:
        pass
    try:
        op.create_check_constraint('chk_producto_subcat_requiere_cat', 'producto', 'subcat_id IS NULL OR cat_id IS NOT NULL')
    except Exception:
        pass

    # Ajustar índices: eliminar idx_producto_categoria si existe, crear/actualizar idx_producto_subcategoria en (emp_id, subcat_id)
    try:
        op.drop_index('idx_producto_categoria', table_name='producto')
    except Exception:
        pass
    try:
        op.drop_index('idx_producto_subcategoria', table_name='producto')
    except Exception:
        pass
    try:
        op.create_index('idx_subcategoria_emp', 'subcategorias', ['emp_id'])
        op.create_index('idx_subcategoria_categoria', 'subcategorias', ['emp_id', 'cat_id'])
    except Exception:
        pass
    try:
        op.create_index('idx_producto_subcategoria', 'producto', ['emp_id', 'subcat_id'])
    except Exception:
        pass

    # Trigger para subcategorias
    bind = op.get_bind()
    try:
        bind.execute(sa.text("""
        CREATE TRIGGER trg_subcategorias_updated_at
        BEFORE UPDATE ON subcategorias
        FOR EACH ROW
        EXECUTE FUNCTION set_updated_at();
        """))
    except Exception:
        pass


def downgrade() -> None:
    try:
        op.drop_index('idx_producto_subcategoria', table_name='producto')
        op.create_index('idx_producto_categoria', 'producto', ['emp_id', 'cat_id'])
        op.create_index('idx_producto_subcategoria', 'producto', ['emp_id', 'cat_id', 'subcat_id'])
    except Exception:
        pass
    try:
        op.drop_constraint('chk_producto_subcat_requiere_cat', 'producto', type_='check')
        op.drop_constraint('fk_producto_subcategoria', 'producto', type_='foreignkey')
        op.drop_column('producto', 'subcat_id')
        op.drop_table('subcategorias')
    except Exception:
        pass
