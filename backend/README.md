# Backend — Sistema de Marketing Predictivo

API REST en **FastAPI + PostgreSQL + SQLAlchemy + Alembic**, con el motor
de Machine Learning de churn en **scikit-learn**. Esta es la Fase 2-3 y 7
del roadmap del proyecto (base de datos, backend y Machine Learning).

## 1. Qué hace

Implementa de punta a punta la lógica de negocio descrita en el brief:
autenticación con JWT, multi-tenancy real (aislamiento por `emp_id`
verificado en cada consulta, nunca solo en el frontend), CRUD de
clientes/productos/ventas con transacciones atómicas, cálculo de RFM y
detección de actividad usando el intervalo individual de cada cliente (no
un umbral fijo), un pipeline real de entrenamiento de churn con
comparación de 3 modelos y versionado, motor de recomendaciones híbrido,
generador de estrategias de recuperación con Recovery Priority Score,
campañas con control previo y modo simulación, e importación de CSV con
validación real antes de escribir cualquier dato.

## 2. Arquitectura

```
app/
├── api/            Routers HTTP (una responsabilidad por archivo)
├── core/           Config, seguridad (JWT/hash), errores, dependencias
├── models/         Modelos SQLAlchemy (19 tablas del brief)
├── schemas/        Contratos Pydantic (idénticos a los tipos del frontend)
├── repositories/   Acceso a datos con aislamiento multi-tenant OBLIGATORIO
├── services/       Lógica de negocio: RFM, churn, recomendaciones, estrategias, campañas, importación, dashboard
├── ml/             Feature engineering y pipeline de entrenamiento (scikit-learn)
├── jobs/           Recálculo diario/semanal fuera del ciclo HTTP
└── main.py         Ensamblado de la app, CORS, manejo global de errores
```

Cada capa tiene una sola responsabilidad: los routers nunca acceden a la
base de datos directamente (usan repositorios), y los repositorios nunca
contienen lógica de negocio (eso vive en `services/`).

## 3. Requisitos

- Python 3.12+
- PostgreSQL 14+
- (Opcional) Docker y Docker Compose

## 4. Instalación local (sin Docker)

```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

cp .env.example .env

# Crear la base de datos
createdb DB_RegresaPE

# Aplicar migraciones
alembic upgrade head

# Cargar datos de demostración (1200 clientes, 37 productos, ~11,500 ventas)
python seed_database.py
```

Esto crea un usuario administrador de prueba:

```
email: admin@demo.com
password: 12345
```

## 5. Ejecutar el servidor

```bash
uvicorn app.main:app --reload --port 8000
```

Documentación interactiva (Swagger): `http://localhost:8000/docs`
Health checks: `GET /api/health` y `GET /api/ready`

## 6. Ejecutar los tests

```bash
createdb marketing_predictivo_test
pytest tests/ -v
```

35 tests (unitarios + integración), incluyendo un bloque específico de
**aislamiento multi-tenant** (`tests/integration/test_multitenancy.py`)
que verifica que un negocio nunca puede leer ni modificar datos de otro,
ni siquiera conociendo IDs exactos.

## 7. Entrenar / reentrenar el modelo de churn manualmente

```bash
python -c "
from app.db.session import SessionLocal
from app.services.churn import train_churn_model
from app.models.business import Business
db = SessionLocal()
business = db.query(Business).first()
train_churn_model(db, business.id)
"
```

O vía API: `POST /api/models/churn/train` (requiere rol administrador).

## 8. Job de recálculo diario/semanal

```bash
python -m app.jobs.daily_recalculation
```

**Decisión técnica:** se usa un script standalone invocable por cron en
lugar de Celery + Redis completo, tal como el brief permite
explícitamente para el MVP ("una alternativa sencilla si consideras que
Celery es excesivo"). Esto cumple el requisito central — los procesos
pesados nunca corren dentro de una petición HTTP — sin la complejidad
operativa de un broker de colas. Redis queda declarado en
`docker-compose.yml` y en la configuración para cuando el proyecto migre
a Celery si el crecimiento lo justifica.

## 9. Ejecutar con Docker

Ver `docker-compose.yml` en la raíz del proyecto (incluye Postgres,
Redis, backend y frontend). Desde la raíz:

```bash
docker compose up --build
```

El backend corre las migraciones automáticamente al iniciar
(`alembic upgrade head`) antes de levantar Uvicorn.

> Nota: el `docker-compose.yml` fue validado sintácticamente (YAML válido,
> servicios correctamente referenciados), pero no pudo probarse un build
> real en este entorno de desarrollo por no contar con un daemon Docker
> disponible. Se recomienda verificar `docker compose up --build` en tu
> máquina antes de considerar esta fase cerrada.

## 10. Decisiones técnicas relevantes

- **Multi-tenancy**: cada repositorio recibe `emp_id` como parámetro
  obligatorio y lo aplica en el `WHERE` de cada consulta. Verificado con
  tests de integración específicos.
- **Dinero**: todos los campos monetarios usan `NUMERIC(12,2)` en
  PostgreSQL, nunca `float`.
- **Churn score vs. probabilidad**: `` es la probabilidad
  calibrada real (útil para explicar "X% de probabilidad" al usuario);
  `` (0-100, el que alimenta los niveles bajo/medio/alto/crítico)
  es un **percentil relativo** dentro de la base de clientes del negocio.
  Esto se documenta en detalle en `ML.md` porque fue un hallazgo importante
  durante el desarrollo (ver sección de auditoría).
- **Fallback de reglas**: si un negocio no tiene suficientes datos para
  entrenar (`MIN_TRAINING_EXAMPLES = 60`), el sistema usa un motor de
  reglas transparente (`rules-v1-fallback`) en vez de fallar o inventar
  una predicción.

## 11. Auditoría y bugs corregidos durante el desarrollo

Ver `ML.md` para el detalle completo de 4 bugs reales encontrados y
corregidos durante la construcción del pipeline de churn (colisión de
nombres con `ImportError`, sombreado del built-in `list`, fórmula de
riesgo que penalizaba a clientes recién comprados, y descalibración de
probabilidades por `class_weight="balanced"`). Ningún bug fue ignorado ni
dejado para "después".
