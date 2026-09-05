# DATABASE.md — Modelo de datos

PostgreSQL 16, gestionado con SQLAlchemy 2.0 + Alembic. 19 tablas (sección
32 del brief), todas con `created_at`/`updated_at`, y todas las entidades
de negocio con `business_id` (multi-tenancy, sección 33).

## Diagrama de relaciones (simplificado)

```
Business ──< User
Business ──< Customer ──< Sale ──< SaleItem >── Product ──> Category
Business ──< Product
Customer ──< Prediction
Customer ──< Recommendation >── Product
Customer ──< Strategy >── Recommendation, Prediction
Business ──< Campaign ──< CampaignRecipient >── Customer
Business ──< Communication >── Customer, Campaign
Business ──< ModelVersion ──< ModelMetric
Business ──< Rule
Business ──< AuditLog
Business ──< Import ──< ImportRowError
```

## Decisiones de esquema

- **Dinero**: `NUMERIC(12,2)` en todos los campos monetarios (precio,
  costo, totales, descuentos), nunca `float` (sección 72).
- **Multi-tenancy**: `business_id` con índice en cada tabla de negocio.
  El aislamiento se aplica en el backend (repositorios), nunca se confía
  en el frontend.
- **Soft delete de facto**: clientes y productos no se eliminan
  físicamente, se marcan `status = inactive` (sección 32: "soft delete
  cuando sea apropiado").
- **Índices**: `business_id`, `customer_id`, `product_id`, `sale_date`
  (`Sale.date`), `email`, `segment`, `activity_status`, `risk_level`,
  `campaign_id` — sobre los campos que efectivamente se filtran u ordenan
  en las consultas reales del código (sección 54: no crear índices
  innecesarios).
- **`ImportRowError` en vez de `ImportError`**: nombre elegido
  deliberadamente distinto al de la excepción built-in de Python
  `ImportError`, que de haberse usado habría colisionado silenciosamente
  con bloques `except ImportError` en cualquier módulo que importara el
  modelo (bug real encontrado y corregido durante el desarrollo).

## Migraciones

```bash
alembic revision --autogenerate -m "descripcion del cambio"
alembic upgrade head
```

La migración inicial (`31d35468f06c_initial_schema.py`) fue generada por
autogeneración y **aplicada y verificada contra una instancia real de
PostgreSQL** durante el desarrollo (no solo simulada).

## Backups

Para producción, se recomienda `pg_dump` programado (diario) más WAL
archiving si el proveedor lo soporta:

```bash
pg_dump -Fc marketing_predictivo > backup_$(date +%Y%m%d).dump
# Restaurar:
pg_restore -d marketing_predictivo backup_20260101.dump
```

No se implementó infraestructura de backup automatizada en este MVP
(el brief no lo exige para esta fase), pero el comando anterior es
funcional y debe programarse vía cron en el servidor de producción.
