# Sistema de Marketing Predictivo y Recuperación Automática de Clientes

Plataforma para pequeños negocios que analiza ventas y clientes para
responder: ¿quién está dejando de comprar?, ¿qué debería ofrecérsele?,
¿cuándo?, y ¿cuánto se recuperó gracias a esa acción?

## Estructura del repositorio

```
├── frontend/           React + TypeScript + Vite + Tailwind
├── backend/            FastAPI + PostgreSQL + SQLAlchemy + scikit-learn
├── docker-compose.yml  Levanta todo el stack con un comando
├── ARCHITECTURE.md     Arquitectura y decisiones técnicas
└── DEPLOYMENT.md       Guía de despliegue
```

Cada carpeta tiene su propio README con instrucciones detalladas:
[`frontend/README.md`](./frontend/README.md) y
[`backend/README.md`](./backend/README.md).

## Ejecución rápida con Docker

```bash
cp backend/.env.example backend/.env
# Editar backend/.env: como mínimo, cambiar SECRET_KEY

docker compose up --build
```

- Frontend: http://localhost:5173
- Backend (Swagger): http://localhost:8000/docs

> **Nota de transparencia:** el `docker-compose.yml` fue validado
> sintácticamente pero no se pudo ejecutar un `docker compose up --build`
> real en el entorno donde se desarrolló este proyecto (sin daemon Docker
> disponible). Cada pieza sí fue probada por separado y de verdad: el
> backend contra una instancia real de PostgreSQL, y el frontend con
> `vite build`. Se recomienda validar el `docker compose up` completo
> como primer paso antes de dar por cerrada esta fase.

## Ejecución sin Docker (para desarrollo)

Ver las instrucciones paso a paso en `backend/README.md` (secciones 4-6)
y `frontend/README.md`. En resumen:

```bash
# Backend
cd backend && python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env  # y ajustar DATABASE_URL
createdb marketing_predictivo
alembic upgrade head
python seed_database.py     # carga 1200 clientes, 37 productos, ~11,500 ventas
uvicorn app.main:app --reload

# Frontend (en otra terminal)
cd frontend && npm install
cp .env.example .env
# Editar .env: VITE_USE_MOCK=false, VITE_API_URL=http://localhost:8000/api
npm run dev
```

Login de prueba: `admin@demo.com` / `Demo12345`

## Qué está implementado (estado real, sección 93 del brief)

| # | Criterio del brief | Estado |
|---|---|---|
| 1-6 | Registrar negocio, login, crear clientes/productos, importar ventas, ver dashboard | ✅ Funcional, probado de punta a punta |
| 7-11 | Comportamiento de clientes, clientes en riesgo, RFM, churn, explicación | ✅ Funcional, con motor de reglas + pipeline ML real entrenado |
| 12-15 | Recomendaciones, próxima compra, estrategia, priorización | ✅ Funcional |
| 16-19 | Crear campaña, simular, medir resultados, ver recuperados | ✅ Funcional (simulación explícita, nunca confundida con datos reales) |
| 20 | Ejecutar tests | ✅ 36/36 pasando contra PostgreSQL real |
| 21 | Levantar con Docker | ⚠️ Configurado y validado sintácticamente; no probado con un daemon Docker real en este entorno (ver nota arriba) |

## Auditoría y bugs corregidos

Este proyecto documenta honestamente los problemas reales encontrados
durante el desarrollo, en vez de ocultarlos (como pide el brief):

- **3 bugs de código** corregidos en el backend (colisión de nombres con
  `ImportError`, sombreado del built-in `list`, fórmula de riesgo que
  penalizaba clientes recién comprados).
- **1 bug de calibración de Machine Learning** (probabilidades
  descalibradas por `class_weight="balanced"`) y **1 decisión de diseño
  de producto** (churn_score como percentil relativo, no probabilidad
  absoluta) documentados en detalle en `backend/ML.md`.

Ambos frontend y backend comparten la misma corrección donde aplicaba
(la fórmula de riesgo del frontend tenía el mismo bug que la del backend
y se corrigió en ambos lados).

## Roadmap del equipo (para referencia)

Este proyecto sigue el plan de roles Scrum acordado por el equipo
(documento aparte): Programador 1 (backend/ML), Programador 2
(frontend/DevOps), Marketing (reglas de negocio y mensajes), Administradora
Financiera (fórmulas de valor y ROI), Administrador de Empresas (backlog
y coordinación). Las fases 1-3 (arquitectura, base de datos, backend) y 4
(frontend) están cubiertas por este entregable.
