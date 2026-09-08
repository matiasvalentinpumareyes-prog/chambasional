# FASES — Alineación total a BD `database_postgres.sql` (44 tablas)

> **Regla:** Todo archivo, variable y columna usa el nombre exacto de la BD. Español donde la BD es español (`emp_id`, `cat_id`, `subcat_id`, `prd_id`, `stk_cantidad`), inglés donde es inglés (`metadata`, `provider_message_id`). No traducir.

Estado actual verificado `git diff HEAD -- database_postgres.sql`:
- Nueva tabla `subcategorias:243` (`subcat_id`, `emp_id`, `cat_id`, `subcat_nombre`, `subcat_descripcion`, `UNIQUE(cat_id,subcat_nombre)`, `FK(emp_id,cat_id)->categorias`)
- `producto:278` ahora `subcat_id UUID NULL` + `FK(emp_id,cat_id,subcat_id)->subcategorias` + `CHECK(subcat_id IS NULL OR cat_id IS NOT NULL)`
- Índices: eliminado `idx_producto_categoria (emp_id,cat_id)`, cambiado `idx_producto_subcategoria` a `(emp_id, subcat_id)` (antes `(emp_id,cat_id,subcat_id)`)

Total tablas: 44 (43 + `subcategorias`). Todo lo ya migrado (producto/stock separados) se mantiene, solo falta alinear `subcategorias`.

---

## Fase 1 — Models (commit `feat: models subcategoria + producto.subcat_id`)
**Archivos:**
- `backend/app/models/subcategoria.py` **NUEVO** — `Subcategoria` con `subcat_id`, `emp_id`, `cat_id`, `subcat_nombre`, `subcat_descripcion`, `estado`, `UNIQUE(cat_id,subcat_nombre)`, `FK(emp_id,cat_id)`.
- `backend/app/models/producto.py:47` — añadir `subcat_id: Mapped[str|None]=mapped_column(String(36), nullable=True)` + `ForeignKeyConstraint` y `CheckConstraint` exactos a `database_postgres.sql:302`.
- `backend/app/models/__init__.py:12` — exportar `Subcategoria`.

**Criterio done:** `Base.metadata.tables` contiene `subcategorias` y `producto` tiene `subcat_id`.

## Fase 2 — Schemas (commit `feat: schemas subcategoria + producto.subcat_id`)
**Archivos:**
- `backend/app/schemas/subcategoria.py` **NUEVO** o dentro de `producto.py` — `SubcategoriaBase/Create/Out` con `subcat_id`, `emp_id`, `cat_id`, `subcat_nombre` (nombres exactos).
- `backend/app/schemas/producto.py:90` — extender `ProductoBase/Create/Update/Out` con `subcat_id: str|None` y `subcategoria_nombre` resuelto.
- `backend/app/schemas/stock.py` sin cambio (ya expone `stk_cantidad` exacto).

**Criterio done:** `grep subcat_id app/schemas` >10, `grep business_id` =0.

## Fase 3 — Repositories / API (commit `feat: repos/api subcategoria`)
**Archivos:**
- `backend/app/repositories/producto_repo.py:6` — añadir `get_or_create_subcategoria(emp_id, cat_id, subcat_nombre)`, `list(..., cat_id, subcat_id)`, validar `subcat_id` requiere `cat_id`.
- `backend/app/api/productos.py:11` — aceptar `subcat_id` en create/update, resolver `subcat_nombre` → `subcat_id` via repo.
- `backend/app/api/catalogs.py:1` — añadir `GET /catalogos/subcategorias?cat_id=` y `POST /catalogos/subcategorias` (dinámico, sin hardcode).
- `backend/app/services/*` sin cambio.

**Criterio done:** `POST /catalogos/subcategorias` crea sin deploy y `GET /productos?subcat_id=` filtra.

## Fase 4 — Alembic (commit `chore: alembic subcategorias + indices`)
**Archivo:** `backend/alembic/versions/0002_subcategoria_indices.py` (`revision 0002`, `down_revision 0001_bd_real_43_tablas`)
- `op.create_table('subcategorias', ...)` exacta a `database_postgres.sql:243`
- `op.add_column('producto', sa.Column('subcat_id', sa.String(36), nullable=True))` + `create_foreign_key` + `create_check_constraint`
- `op.drop_index('idx_producto_categoria', table_name='producto')` (si existe) y `op.create_index('idx_producto_subcategoria', 'producto', ['emp_id','subcat_id'])` para alinear con tu último `git diff`.

**Criterio done:** `alembic upgrade head` crea 44 tablas y `SELECT * FROM subcategorias` OK.

## Fase 5 — Verificación (commit `chore: verificacion 44 tablas`)
- `python -c "from app.models.base import Base; assert len(Base.metadata.tables)==44"`
- `Select-String emp_id` >130, `business_id` =0, `stk_cantidad` presente, `subcat_id` presente.
- `alembic current` == `0002`.

**Commits:** 5 commits, mensajes cortos `feat: ...` / `chore: ...`, sin push.
