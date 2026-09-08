# DEPLOYMENT.md — Despliegue

## Opción recomendada para el MVP: VPS con Docker Compose

1. Aprovisionar un VPS (2 vCPU / 4GB RAM es suficiente para un negocio
   pequeño-mediano).
2. Instalar Docker y Docker Compose.
3. Clonar el repositorio.
4. Copiar `.env.example` a `backend/.env` y completar `SECRET_KEY` con un
   valor aleatorio real (`openssl rand -hex 32`). `DATABASE_URL` ya apunta a `db_regresape`:
   - Docker: `postgresql+psycopg2://postgres:postgres@postgres:5432/db_regresape` (`docker-compose.yml:30`)
   - Local: `postgresql+psycopg2://postgres:postgres@localhost:5432/db_regresape` (`backend/.env.example:3`, `app/core/config.py:18`)
   - Tests: `postgresql+psycopg2://postgres:postgres@localhost:5432/db_regresape_test` (`tests/conftest.py:4`)
   Si usas BD gestionada externa, reemplaza `DATABASE_URL` por la de producción.
5. `docker compose up --build -d`  # crea `db_regresape` vía `POSTGRES_DB` (`docker-compose.yml:9`) y migra con `alembic upgrade head`
6. Configurar un proxy inverso (Nginx o Caddy) delante para TLS/HTTPS.

## Alternativas sin gestionar infraestructura

- **Railway / Render**: desplegar `backend/` como servicio web (usa el
  `Dockerfile` incluido) y `frontend/` como sitio estático (build de
  Vite). Provisionar PostgreSQL gestionado desde el mismo panel.
- **AWS / Azure / GCP**: el backend es un contenedor estándar
  (Fargate/App Service/Cloud Run); no depende de ningún servicio
  propietario del proveedor.

El proyecto no depende de ningún proveedor específico (sección 90 del
brief): toda la configuración de infraestructura vive en variables de
entorno.

## PostgreSQL — db_regresape

- **Motor:** PostgreSQL 16 (`postgres:16-alpine` en `docker-compose.yml:5`, requiere `uuid-ossp` — `db/database_postgres.sql:6`)
- **Esquemas:** 43 tablas SQL histórico (`db/database_postgres.sql:1`, detallado en `DATABASE.md`) vs 19 tablas ORM vigente (`alembic/versions/31d35468f06c:19`, `app/models/`). Ambos apuntan a `db_regresape`.
- **Carga SQL directo (43 tablas):** `psql "$DATABASE_URL" -f backend/db/database_postgres.sql` + `psql "$DATABASE_URL" -c "\dt"` (`DATABASE.md:15-18`)
- **Reset SQL:** `psql "$DATABASE_URL" -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"` y re-ejecutar (no idempotente — `DATABASE.md:25`)

## Migraciones en producción

**Nunca** confiar en `Base.metadata.create_all()` en producción. Siempre:

```bash
# En db_regresape (19 tablas ORM)
alembic upgrade head
# Verificar: psql "$DATABASE_URL" -c "\dt"
```

Esto ya está automatizado en el `command` del servicio `backend` en
`docker-compose.yml:39-41`.

## Variables de entorno obligatorias en producción

| Variable | Notas |
|---|---|
| `SECRET_KEY` | Generar con `openssl rand -hex 32`, nunca reusar el de desarrollo |
| `DATABASE_URL` | `postgresql+psycopg2://postgres:postgres@<host>:5432/db_regresape` — Docker `@postgres`, local/test `@localhost` (ej. `db_regresape_test`) |
| `CORS_ORIGINS` | Dominio real del frontend, no `localhost` |

## Costos (sección 91 del brief)

El sistema funciona completamente sin credenciales de terceros de pago:
los canales de comunicación (email/WhatsApp/SMS) usan un `MockProvider`
mientras no se configuren `EMAIL_API_KEY`/`WHATSAPP_API_KEY` reales. El
LLM (si se integra IA generativa en una fase posterior) es opcional
(`OPENAI_API_KEY`).
