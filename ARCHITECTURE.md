# ARCHITECTURE.md — Arquitectura general

## Visión general

```
Frontend (React + TS)
   |  fetch() / axios-like adapter (services/api.ts)
   v
API REST (FastAPI)
   |
   ├── core/         config, seguridad, errores, dependencias
   ├── api/          routers HTTP
   ├── repositories/ acceso a datos con aislamiento multi-tenant
   ├── services/     lógica de negocio (RFM, churn, recomendaciones, estrategias, campañas)
   ├── ml/           feature engineering + entrenamiento (scikit-learn)
   └── jobs/         recálculo periódico fuera del ciclo HTTP
   |
   v
PostgreSQL (19 tablas, sección 32)
```

Se eligió un **modular monolith** (sección 77 del brief), no
microservicios: para un negocio pequeño, separar en servicios
independientes agrega complejidad operativa sin beneficio real en esta
etapa. La separación de responsabilidades ya existe a nivel de código
(capas `api/`, `repositories/`, `services/`, `ml/`), lo que permitiría
extraer un servicio de ML independiente más adelante si el crecimiento lo
justifica, sin reescribir la lógica de negocio.

## Por qué este stack (sección 43)

| Decisión | Motivo |
|---|---|
| FastAPI sobre Flask/Django | Validación automática con Pydantic, documentación OpenAPI gratuita, y soporte nativo de tipado que reduce errores en un proyecto con muchos modelos de datos. |
| PostgreSQL sobre MySQL | Soporte robusto de `NUMERIC` para dinero, JSON nativo (usado en `reasons`, `features`, `conditions` de las reglas), y es el estándar de facto para este tipo de proyecto. |
| SQLAlchemy 2.0 + Alembic | ORM maduro con tipado moderno (`Mapped[]`), migraciones versionadas obligatorias en vez de `create_all()` en producción. |
| React + TypeScript + Vite | Stack más común y con mejor soporte de herramientas para SPAs de dashboard con muchos formularios y gráficos. |
| scikit-learn sobre un framework de deep learning | El problema (clasificación tabular con pocas variables) no se beneficia de redes neuronales; modelos clásicos son más explicables, más rápidos de entrenar con pocos datos, y más fáciles de auditar (requisito central del proyecto). |
| Script standalone en vez de Celery completo | Ver `backend/README.md` sección 8: decisión explícita para no sobre-ingenierizar el MVP (sección 77). |

## Flujo de datos: de una venta a una recomendación

```
POST /api/sales
   → SaleRepository.create_sale_with_items()   (transacción atómica)
   → recalculate_customer_aggregates()          (RFM actualizado al instante)
   → predict_churn()                             (predicción de churn actualizada)
   ↓
GET /api/strategies/today
   → CustomerRepository.list(only_at_risk_group=True)
   → recommendations_service.generate_recommendations()
   → strategies_service.build_strategy()
   → StrategyOut (prioridad, oferta, canal, mensaje)
```

## Integración frontend-backend

El frontend fue construido primero con una capa de datos mock
(`src/services/mockDb.ts` + `analyticsEngine.ts`) que replica exactamente
la forma de los tipos que expone el backend (`src/types/index.ts`
coincide con los schemas Pydantic). Cambiar `VITE_USE_MOCK=false` y
apuntar `VITE_API_URL` al backend real es, en el resto del código del
frontend, un cambio de una sola línea — ninguna página necesita
modificarse.

## Estado de verificación de esta entrega

| Componente | Verificado cómo |
|---|---|
| Frontend | `tsc -b --noEmit` (0 errores) + `vite build` (build de producción real) |
| Backend | Levantado contra PostgreSQL 16 real, flujo completo probado con curl (registro → venta → RFM/churn → dashboard) |
| Migraciones | `alembic upgrade head` aplicado y confirmado con `\dt` en psql |
| Modelo ML | Entrenado con datos sintéticos reales, 4 bugs encontrados y corregidos (ver `backend/ML.md`) |
| Tests | 36/36 pasando contra una base de datos Postgres de test real (no mocks de base de datos) |
| Docker | `docker-compose.yml` validado sintácticamente; **no se pudo ejecutar `docker compose up --build` real** por no contar con un daemon Docker en este entorno de desarrollo — pendiente de verificar en una máquina con Docker antes de considerar esta fase cerrada. |
