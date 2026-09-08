# Sistema de Marketing Predictivo y Recuperación Automática de Clientes

Plataforma para pequeños negocios que analiza ventas y clientes para
responder: ¿quién está dejando de comprar?, ¿qué debería ofrecérsele?,
¿cuándo?, y ¿cuánto se recuperó gracias a esa acción?

## Stack

- **Frontend:** React 18 + TypeScript + Vite + Tailwind CSS
- **Backend:** FastAPI + SQLAlchemy 2.0 + Alembic + scikit-learn
- **Base de datos:** **PostgreSQL 16 — `db_regresape`** (`backend/db/database_postgres.sql:1`, `backend/DATABASE.md:1`)
- **Infra:** Docker Compose (Postgres + Redis + Backend + Frontend)

---

## Base de datos PostgreSQL — `db_regresape`

> Nombre real de la base de datos: **`db_regresape`** (antes `marketing_predictivo` / `DB_RegresaPE`). Todas las `DATABASE_URL` y `POSTGRES_DB` del proyecto apuntan ahora a este nombre. Documentación completa del esquema en [`backend/DATABASE.md`](./backend/DATABASE.md) y fuente SQL en [`backend/db/database_postgres.sql`](./backend/db/database_postgres.sql).

### Requisitos

- PostgreSQL **16+** (`docker-compose.yml:5` `postgres:16-alpine`, `backend/DATABASE.md:7`)
- Extensión `uuid-ossp` (`backend/db/database_postgres.sql:6`): `CREATE EXTENSION IF NOT EXISTS "uuid-ossp"` — provee `uuid_generate_v1mc()` para todas las PKs `UUID DEFAULT (uuid_generate_v1mc())`. Requiere superuser en la primera ejecución. Alternativa moderna `pgcrypto` (`gen_random_uuid()`) no usada.
- Driver `psycopg2-binary==2.9.9` (`backend/requirements.txt:5`) + `libpq-dev` en `backend/Dockerfile:5`
- Cliente `psql` para carga directa del SQL

### Servicio Docker (`docker-compose.yml:3`)

| Concepto | Valor | Ubicación |
|---|---|---|
| Imagen | `postgres:16-alpine` | `docker-compose.yml:5` |
| Usuario / Password / DB | `postgres` / `postgres` / `db_regresape` | `docker-compose.yml:7-9` |
| Puerto | `5432:5432` | `docker-compose.yml:12-13` |
| Volume | `postgres_data:/var/lib/postgresql/data` | `docker-compose.yml:10-11`, `docker-compose.yml:54` |
| Healthcheck | `pg_isready -U postgres` `interval 5s` `retries 10` | `docker-compose.yml:14-18` |
| Dependencia backend | `depends_on: postgres: condition: service_healthy` | `docker-compose.yml:32-34` |
| `DATABASE_URL` en compose | `postgresql+psycopg2://postgres:postgres@postgres:5432/db_regresape` | `docker-compose.yml:30` |
| Comando backend | `sh -c "python -m alembic upgrade head && uvicorn app.main:app --host 0.0.0.0 --port 8000"` | `docker-compose.yml:39-41` |

Redis declarado como `redis:7-alpine` (`docker-compose.yml:21`) para futuro Celery; el MVP usa script standalone (`backend/README.md:114`).

### Variables de entorno `DATABASE_URL`

| Contexto | `DATABASE_URL` | Host | Archivo |
|---|---|---|---|
| **Docker** (compose override) | `postgresql+psycopg2://postgres:postgres@postgres:5432/db_regresape` | `postgres` (nombre servicio) | `docker-compose.yml:30` |
| **Local** (dev) | `postgresql+psycopg2://postgres:postgres@localhost:5432/db_regresape` | `localhost` | `backend/.env.example:3`, `backend/app/core/config.py:18` |
| **Tests** | `postgresql+psycopg2://postgres:postgres@localhost:5432/db_regresape_test` | `localhost` | `backend/tests/conftest.py:4` |

`backend/app/db/session.py:8` crea el engine con `pool_pre_ping=True` y `backend/alembic/env.py:11` sincroniza `sqlalchemy.url` desde `settings.DATABASE_URL`. `alembic.ini:4` deja `sqlalchemy.url` vacío a propósito — viene de `env.py`.

> **Docker vs local:** `.env` con `@postgres` solo funciona dentro de Docker. Para desarrollo sin Docker usa `@localhost`. `backend/.env.example` trae `localhost` y `docker-compose.yml` hace override a `postgres` automáticamente.

### Esquemas: 43 tablas SQL (legado completo) vs 19 tablas ORM (vigente)

El repositorio contiene **dos definiciones** — el SQL es la fuente histórica completa, el ORM es lo que realmente ejecuta la API.

**1) SQL crudo — 43 tablas — `backend/db/database_postgres.sql:1` (fuente de verdad histórica, `backend/DATABASE.md:3`):**

```
# Catálogos base (globales, sin emp_id)
departamento ──< provincia ──< distrito
documento, metodos_pago, canales_marketing, segmentos, roles
auditoria_entidades, auditoria_accion, patrones_compra  # backend/db/database_postgres.sql:12-142, 954

# Tenancy
empresa ──< usuario_personal ──< usuario  # backend/db/database_postgres.sql:148-221

# Comercial
empresa ──< categorias ──┐
empresa ──< producto_marca ─┤
              └─> producto ──< producto_precios / producto_stock  # 227-323

# Clientes y consentimiento
empresa ──< cliente ──< cliente_consentimientos >── canales_marketing  # 329-386
        └─< cliente_segmento / cliente_features / cliente_estacionalidad  # 442-1011

# Ventas
empresa ──< cliente ──< ventas ──< venta_items >── producto  # 392-436

# Modelos e IA
empresa ──< version_modelo ──< model_metrics  # 529-564
        └─< predicciones >── cliente, version_modelo  # 566-589
                        └─< prediccion_explicaciones >── tipos_direccion_explicacion  # 1013-1053

# Motor reglas y recomendaciones
empresa ──< estrategias ──< rules  # 595-634
                      └─< recomendaciones >── cliente, predicciones, producto, cupones  # 669-702
                      └─< campaigns >── campaign_recipients >── cliente, canales, ventas  # 708-769
                                   └─< communicaciones  # 771-802

# Cupones / Auditoría
empresa ──< cupones ──< cupon_canjes  # 640-833
empresa ──< auditoria_logs >── usuario, auditoria_entidades, auditoria_accion  # 839-864
empresa ──< imports >── import_errors  # 866-906
```

Catálogo resumido (ver `backend/DATABASE.md:78` para detalle columna por columna):

| Grupo | Tablas |
|---|---|
| Catálogos globales | `departamento:12`, `provincia:23`, `distrito:37`, `documento:51`, `metodos_pago:63`, `canales_marketing:74`, `segmentos:88`, `roles:103`, `auditoria_entidades:117`, `auditoria_accion:132`, `patrones_compra:954` |
| Tenancy | `empresa:148` (`emp_logo BYTEA:162`), `usuario_personal:181`, `usuario:198` (FK compuesta `emp_id,usp_id` `219`) |
| Comercial | `categorias:227`, `producto_marca:243`, `producto:258` (FKs compuestas `emp_id,cat_id` `278`), `producto_precios:284`, `producto_stock:307` |
| Clientes | `cliente:329` (`uq_cliente_emp_documento:349`), `cliente_consentimientos:364`, `cliente_segmento:442`, `cliente_segmento_historial:463`, `cliente_features:488` (+ `ALTER 981` `total_compras_historicas, intervalo_cv, pat_id, ratio_riesgo_actual`), `cliente_estacionalidad:992` (`CHECK mes 1..12:1006`, 12 filas/cliente), `tipos_direccion_explicacion:1013` (sin timestamps), `prediccion_explicaciones:1028` |
| Ventas | `ventas:392` (`cupon_id` FK diferida `665`), `venta_items:416` (`cantidad DECIMAL(12,3):421`) |
| Modelos | `version_modelo:529`, `model_metrics:548` (`DECIMAL(12,6):553`), `predicciones:566` |
| Reglas/Estrategias | `estrategias:595` (`configuracion JSON:602`), `rules:614` (`rle_condiciones JSON NOT NULL:621`) |
| Cupones/Recs | `cupones:640`, `recomendaciones:669`, `campaigns:708`, `campaign_recipients:735`, `communicaciones:771`, `cupon_canjes:808` |
| Auditoría | `auditoria_logs:839` (`adl_valor_anterior/nuevo JSON:849`), `imports:866`, `import_errors:888` |

Seeds `backend/db/database_postgres.sql:915-949` + `968-979`: `canales_marketing` (4), `segmentos` (6), `roles` (5), `auditoria_accion` (9), `patrones_compra` (5) vía `INSERT ... ON CONFLICT DO NOTHING`.

**2) ORM/Alembic — 19 tablas — `backend/alembic/versions/31d35468f06c_initial_schema.py:19` (lo que realmente migra la API):**

`businesses:21`, `categories:37`, `customers:48`, `model_versions:85`, `rules:102`, `users:116`, `audit_logs:131`, `imports:147`, `model_metrics:165`, `predictions:176`, `products:199`, `sales:218`, `campaigns:236`, `import_errors:257`, `recommendations:270`, `sale_items:291`, `strategies:307`, `campaign_recipients:334`, `communications:349` — definidas en `backend/app/models/__init__.py:1`.

> **Reconciliación:** `ARCHITECTURE.md:19` cita 19 tablas (ORM) mientras `backend/DATABASE.md:78` cita 43 (SQL). El SQL es el diseño completo heredado de MySQL con normalización `producto_marca/precio/stock`, `departamento/provincia/distrito`, `usuario_personal`, `cliente_features` y `cliente_estacionalidad`. El ORM simplifica a `String(36) uuid4` (`backend/app/models/business.py:11`) vs `UUID` nativo y colapsa `producto` en una sola tabla. `seed_database.py:5` solo puebla las 19 tablas ORM.

### Tipos, extensiones, índices y triggers

| Aspecto | SQL (`database_postgres.sql`) | ORM (`app/models/*.py`) | Notas |
|---|---|---|---|
| **PK** | `UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc())` todas las tablas (`database_postgres.sql:13`) | `String(36) default=uuid4` (`backend/app/models/business.py:11-12`) | `v1mc` da localidad de índice vs `uuid4` aleatorio (`backend/DATABASE.md:182`) |
| **Dinero** | `DECIMAL(14,2)` ventas/cupones (`392,640`), `DECIMAL(10,2)` precios (`284`) | `Numeric(12,2)` `Money` (`backend/app/models/common.py:8`) | Nunca `float` |
| **Métricas churn** | `DECIMAL(12,6)` `model_metrics:553`, `DECIMAL(8,5)` `score_churn:507` | `Float` `churn_probability` (`backend/app/models/prediction.py:33`) | ORM usa `Float` por simplicidad |
| **Timestamps** | `TIMESTAMP DEFAULT CURRENT_TIMESTAMP` 42/43 tablas | `DateTime(timezone=True)` `utcnow()` (`backend/app/models/common.py:18`) | SQL no usa `TIMESTAMPTZ` (`backend/DATABASE.md:186`) — deuda conocida |
| **Estados** | `SMALLINT DEFAULT 1` activo | `Boolean` / `Enum` | `1` activo, `0` inactivo, `2/3` campaña |
| **JSON** | `JSON` (no `JSONB`) `cliente_features.metadata:508`, `rules.rle_condiciones:621` | `JSON` `reasons`, `features` (`backend/app/models/prediction.py:37`) | Migrar a `JSONB + GIN` si filtras (`backend/DATABASE.md:187`) |
| **Binario** | `empresa.emp_logo BYTEA:162` | — | Solo SQL |
| **Índices** | 54 btree `database_postgres.sql:1058-1113` (`idx_ventas_cliente_fecha:1078`, `idx_features_churn:1087`, etc.) + `UNIQUE(emp_id,pk)` para FKs compuestas (`backend/DATABASE.md:184`) | ~30 `op.create_index` (`alembic:47,81,100`) | Sin parciales ni GIN |
| **Triggers** | 33 `set_updated_at()` `BEFORE UPDATE` `database_postgres.sql:1120-1336` | `onupdate=utcnow` en app (`backend/app/models/common.py:19`) | `tipos_direccion_explicacion:1013` es la única sin timestamps ni trigger |
| **FKs** | `NO ACTION` por defecto (`backend/DATABASE.md:191`) | `CASCADE`/`SET NULL`/`RESTRICT` (`alembic:43,77,97`) | Orden de borrado importa en SQL |
| **Multi-tenancy** | `emp_id UUID NOT NULL` en 30+ tablas operativas; 11 globales sin `emp_id` (`backend/DATABASE.md:183`) | `business_id` | Aislamiento vía `WHERE emp_id = :tenant`, no `ROW LEVEL SECURITY` |

---

## Estructura del repositorio

```
├── frontend/           React + TypeScript + Vite + Tailwind
├── backend/            FastAPI + PostgreSQL + SQLAlchemy + scikit-learn
│   ├── db/database_postgres.sql  Esquema PostgreSQL 16 completo (43 tablas, db_regresape)
│   ├── DATABASE.md     Catálogo de tablas y decisiones de esquema
│   ├── app/models/     Modelos ORM (19 tablas vigentes)
│   └── alembic/        Migraciones versionadas
├── docker-compose.yml  Levanta Postgres 16 + Redis + Backend + Frontend
├── ARCHITECTURE.md     Arquitectura y decisiones técnicas
└── DEPLOYMENT.md       Guía de despliegue
```

Cada carpeta tiene su propio README: [`frontend/README.md`](./frontend/README.md) y [`backend/README.md`](./backend/README.md).

## Ejecución rápida con Docker (recomendado)

```bash
cp backend/.env.example backend/.env
# Editar backend/.env: como mínimo, cambiar SECRET_KEY
# DATABASE_URL ya apunta a db_regresape; no tocar si usas Docker

docker compose up --build
```

- Frontend: http://localhost:5173
- Backend (Swagger): http://localhost:8000/docs
- PostgreSQL: `postgres:5432` base `db_regresape` (`docker-compose.yml:7-9`)
- Verificación: `docker compose ps` y `docker compose logs postgres`

El backend corre `alembic upgrade head` automáticamente al iniciar (`docker-compose.yml:39-41`) y espera a que Postgres esté healthy (`docker-compose.yml:32-34`).

> **Nota:** el `docker-compose.yml` fue validado sintácticamente y probado contra PostgreSQL 16 real por piezas (backend con `psql`, frontend con `vite build`). Valida `docker compose up --build` completo en tu máquina como primer paso.

## Ejecución sin Docker (para desarrollo)

### Opción A — ORM/Alembic (flujo vigente de la API, 19 tablas)

```bash
cd backend && python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env  # DATABASE_URL=postgresql+psycopg2://postgres:postgres@localhost:5432/db_regresape

# Crear la base de datos
createdb db_regresape
# o: psql -U postgres -c "CREATE DATABASE db_regresape;"

# Aplicar migraciones (crea las 19 tablas ORM)
alembic upgrade head
# Verificar: psql "$DATABASE_URL" -c "\dt"

# Cargar datos de demostración (1200 clientes, 37 productos, ~11_500 ventas)
python seed_database.py

uvicorn app.main:app --reload --port 8000
# Docs: http://localhost:8000/docs  Health: GET /api/health  GET /api/ready
```

Login de prueba: `admin@demo.com` / `Demo12345` (`backend/README.md:66`, `seed_database.py:71`).

### Opción B — SQL crudo (esquema completo histórico, 43 tablas)

```bash
# Requiere PostgreSQL 16 + uuid-ossp
psql "postgresql://postgres:postgres@localhost:5432/db_regresape" -f backend/db/database_postgres.sql

# Verificar
psql "$DATABASE_URL" -c "\dt" -c "SELECT count(*) FROM empresa; SELECT * FROM canales_marketing;"
# Debe mostrar 43 tablas y 4 canales / 6 segmentos / 5 roles / 9 acciones

# Backup / Restore
pg_dump -Fc -d "$DATABASE_URL" > backup_$(date +%Y%m%d).dump
pg_restore -d "$DATABASE_URL" backup_20260101.dump

# Reset (el script no es idempotente, backend/DATABASE.md:25)
psql "$DATABASE_URL" -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
psql "$DATABASE_URL" -f backend/db/database_postgres.sql
```

> `seed_database.py` solo puebla las 19 tablas ORM, no las 43 del SQL. Si cargas el SQL y luego el seed, habrá tablas paralelas (`empresa` vs `businesses`) sin FK entre ellas.

### Frontend (en otra terminal)

```bash
cd frontend && npm install
cp .env.example .env
# Editar .env: VITE_USE_MOCK=false, VITE_API_URL=http://localhost:8000/api
npm run dev
```

### Tests (requiere `db_regresape_test`)

```bash
createdb db_regresape_test
pytest tests/ -v  # backend/tests/conftest.py:4 usa db_regresape_test con Base.metadata.create_all
```

## Verificación de la base de datos

```bash
# 1. Conexión
psql "$DATABASE_URL" -c "SELECT version();"

# 2. Tablas (según flujo elegido)
psql "$DATABASE_URL" -c "\dt"                          # 19 (Alembic) o 43 (SQL)
psql "$DATABASE_URL" -c "SELECT count(*) FROM information_schema.tables WHERE table_schema='public';"

# 3. Catálogos base (solo SQL 43)
psql "$DATABASE_URL" -c "SELECT * FROM canales_marketing;"  # 4 filas: EMAIL/SMS/WHATSAPP/PUSH
psql "$DATABASE_URL" -c "SELECT seg_codigo, seg_nombre FROM segmentos;"  # 6 filas

# 4. Migraciones
alembic current        # debe mostrar 31d35468f06c (head)
alembic history

# 5. Healthchecks de la API
curl http://localhost:8000/api/health
curl http://localhost:8000/api/ready
```

## Backup, restore y mantenimiento

```bash
# Dump comprimido
pg_dump -Fc -d "$DATABASE_URL" > backup_$(date +%Y%m%d).dump  # backend/DATABASE.md:21

# Restore
pg_restore -d "$DATABASE_URL" backup_20260101.dump  # backend/DATABASE.md:22

# Solo esquema
pg_dump -s -d "$DATABASE_URL" > schema.sql

# Conexión GUI: DBeaver / pgAdmin / DataGrip
# Host: localhost  Port: 5432  Database: db_regresape  User: postgres  Password: postgres
```

Programar `pg_dump -Fc` + WAL archiving vía cron/proveedor para producción (`backend/DATABASE.md:197`). No usar `Base.metadata.create_all()` en producción — siempre `alembic upgrade head` (`DEPLOYMENT.md:30`).

## Troubleshooting PostgreSQL

| Síntoma | Causa | Solución |
|---|---|---|
| `extension "uuid-ossp" does not exist` | Falta `CREATE EXTENSION` | `psql -c 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";'` como superuser (`backend/db/database_postgres.sql:6`) |
| `database "db_regresape" does not exist` | No se creó la BD | `createdb db_regresape` o `psql -U postgres -c "CREATE DATABASE db_regresape;"` |
| `could not connect to server: Connection refused` en Docker | `DATABASE_URL` con `localhost` dentro del contenedor | Usa `@postgres:5432/db_regresape` (`docker-compose.yml:30`), no `@localhost` |
| `could not connect` en local | `DATABASE_URL` con `@postgres` sin Docker | Usa `@localhost:5432/db_regresape` (`backend/app/core/config.py:18`) |
| `relation "empresa" does not exist` tras `alembic upgrade head` | Flujo ORM crea `businesses`, no `empresa` | Normal — 19 vs 43 tablas. Usa `\dt` para ver qué esquema migraste |
| `duplicate key value violates unique constraint "uq_cupon_emp_codigo"` | Re-ejecutar `database_postgres.sql` sin reset | `DROP SCHEMA public CASCADE; CREATE SCHEMA public;` y re-cargar (`backend/DATABASE.md:25`) |
| `psql: FATAL: password authentication failed` | Credenciales | Verifica `POSTGRES_USER/PASSWORD` (`docker-compose.yml:7-8`) y `DATABASE_URL` |
| `alembic.ini sqlalchemy.url =` vacío | No es bug | URL viene de `settings.DATABASE_URL` (`backend/alembic/env.py:11`) |

Para `pool_pre_ping` y `NullPool` ver `backend/app/db/session.py:8` y `backend/alembic/env.py:31`.

## Qué está implementado (estado real, sección 93 del brief)

| # | Criterio del brief | Estado |
|---|---|---|
| 1-6 | Registrar negocio, login, crear clientes/productos, importar ventas, ver dashboard | ✅ Funcional, probado de punta a punta |
| 7-11 | Comportamiento de clientes, clientes en riesgo, RFM, churn, explicación | ✅ Funcional, con motor de reglas + pipeline ML real entrenado |
| 12-15 | Recomendaciones, próxima compra, estrategia, priorización | ✅ Funcional |
| 16-19 | Crear campaña, simular, medir resultados, ver recuperados | ✅ Funcional (simulación explícita, nunca confundida con datos reales) |
| 20 | Ejecutar tests | ✅ 36/36 pasando contra PostgreSQL real (`db_regresape_test`) |
| 21 | Levantar con Docker | ⚠️ Configurado y validado sintácticamente; verificar `docker compose up --build` en tu máquina |

## Auditoría y bugs corregidos

- **3 bugs de código** corregidos (colisión `ImportError`, sombreado `list`, fórmula de riesgo que penalizaba clientes recién comprados).
- **1 bug de calibración ML** (`class_weight="balanced"`) y **1 decisión de producto** (churn_score como percentil relativo) en `backend/ML.md`.

## Roadmap del equipo (para referencia)

Programador 1 (backend/ML), Programador 2 (frontend/DevOps), Marketing (reglas), Administradora Financiera (ROI), Administrador de Empresas (backlog). Fases 1-3 (arquitectura, base de datos `db_regresape`, backend) y 4 (frontend) cubiertas.

## Referencias

- Esquema completo SQL: `backend/db/database_postgres.sql:1` (43 tablas, `db_regresape`)
- Catálogo y decisiones: `backend/DATABASE.md:1`
- Modelos ORM: `backend/app/models/__init__.py:1`
- Migración inicial: `backend/alembic/versions/31d35468f06c_initial_schema.py:19`
- Sesión DB: `backend/app/db/session.py:8`
- Config: `backend/app/core/config.py:18`
- Compose: `docker-compose.yml:3`
- Deploy: `DEPLOYMENT.md:1`
