# DEPLOYMENT.md — Despliegue

## Opción recomendada para el MVP: VPS con Docker Compose

1. Aprovisionar un VPS (2 vCPU / 4GB RAM es suficiente para un negocio
   pequeño-mediano).
2. Instalar Docker y Docker Compose.
3. Clonar el repositorio.
4. Copiar `.env.example` a `backend/.env` y completar `SECRET_KEY` con un
   valor aleatorio real (`openssl rand -hex 32`), y `DATABASE_URL` si se
   usa una base de datos gestionada externa.
5. `docker compose up --build -d`
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

## Migraciones en producción

**Nunca** confiar en `Base.metadata.create_all()` en producción. Siempre:

```bash
alembic upgrade head
```

Esto ya está automatizado en el `command` del servicio `backend` en
`docker-compose.yml`.

## Variables de entorno obligatorias en producción

| Variable | Notas |
|---|---|
| `SECRET_KEY` | Generar con `openssl rand -hex 32`, nunca reusar el de desarrollo |
| `DATABASE_URL` | Apuntar a la base de datos de producción |
| `CORS_ORIGINS` | Dominio real del frontend, no `localhost` |

## Costos (sección 91 del brief)

El sistema funciona completamente sin credenciales de terceros de pago:
los canales de comunicación (email/WhatsApp/SMS) usan un `MockProvider`
mientras no se configuren `EMAIL_API_KEY`/`WHATSAPP_API_KEY` reales. El
LLM (si se integra IA generativa en una fase posterior) es opcional
(`OPENAI_API_KEY`).
