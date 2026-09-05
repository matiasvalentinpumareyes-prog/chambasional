# Frontend — Sistema de Marketing Predictivo

Interfaz web del sistema de marketing predictivo y recuperación automática
de clientes. Construida en **React 18 + TypeScript + Vite + Tailwind CSS**,
según el stack definido en la sección 43 del brief técnico.

## Estado de esta entrega

Esta es la **Fase 4 (Frontend)** del roadmap del proyecto. Cubre íntegramente
las Prioridades 1 y 2 del MVP (sección 78 del brief) y deja la estructura
lista para las Prioridades 3-5:

- ✅ Autenticación (login/logout, rutas protegidas, roles).
- ✅ Dashboard completo con KPIs, alertas y 7 gráficos (sección 6.1, 66, 67).
- ✅ CRUD de Clientes, Productos y registro de Ventas.
- ✅ Importación de CSV con validación previa real, vista previa y reporte
  de errores descargable (sección 10) — no es un mock, valida de verdad.
- ✅ RFM, detección de actividad individual, riesgo de abandono con
  explicación en lenguaje simple, próxima compra estimada y recomendación
  de productos (secciones 11, 12, 16, 17, 18).
- ✅ Pantalla "¿A quién contactar hoy?" (sección 39), el elemento central
  del sistema.
- ✅ Campañas: creación, control previo al envío y **modo simulación**
  explícito (secciones 24, 81, 82) — nunca se "envía" nada real.
- ✅ Analítica con exportación a CSV (sección 68).
- ✅ Configuración del negocio (moneda, umbrales de riesgo, cooldown).
- ✅ Página de Modelos, preparada para el versionado real del backend.

### Importante: motor de reglas como fallback transparente

El pipeline de Machine Learning real (Regresión Logística / Random Forest /
Gradient Boosting) vive en el **backend** (Fase 7, a cargo del Programador 1
según el plan de roles Scrum). Mientras ese backend no esté conectado, este
frontend calcula RFM, churn, próxima compra y recomendaciones mediante un
**motor de reglas transparente** (`src/services/analyticsEngine.ts`),
aplicado sobre datos sintéticos reales (no inventados). Esto es exactamente
el "sistema de fallback" pedido en la sección 76 del brief, y se identifica
en toda la interfaz con la versión de modelo `rules-v1-fallback` para nunca
fingir que ya existe un modelo entrenado (regla 79).

## Arquitectura de datos: un solo punto de cambio

Toda la aplicación llama a la capa `src/services/api.ts`. Esa capa decide,
según la variable de entorno `VITE_USE_MOCK`, si responde con la base de
datos en memoria (`src/services/mockDb.ts`) o con `fetch()` real contra el
backend FastAPI. **El resto del código (páginas, componentes, hooks) no
sabe ni le importa cuál de los dos está activo** — los tipos de
`src/types/index.ts` son el contrato compartido.

```
VITE_USE_MOCK=true   (por defecto) → usa src/services/mockDb.ts
VITE_USE_MOCK=false                → usa fetch() contra VITE_API_URL
```

Cuando el equipo conecte el backend real, el cambio es: copiar `.env.example`
a `.env`, poner `VITE_USE_MOCK=false` y `VITE_API_URL` apuntando al backend.
No hace falta tocar ninguna página.

## Instalación y ejecución

```bash
cd frontend
npm install
cp .env.example .env
npm run dev
```

Abre `http://localhost:5173`. En modo demo, cualquier email/contraseña
funciona (el "backend" es la base de datos en memoria con 1200 clientes,
30+ productos y varios miles de ventas sintéticas, generados de forma
determinista en `src/services/seedData.ts`).

### Comandos disponibles

| Comando | Qué hace |
|---|---|
| `npm run dev` | Servidor de desarrollo con recarga en caliente |
| `npm run build` | Type-check (`tsc -b`) + build de producción (Vite/Rollup) |
| `npm run preview` | Sirve el build de producción localmente |
| `npm run typecheck` | Solo verifica tipos, sin generar archivos |

## Estructura de carpetas

```
frontend/
├── src/
│   ├── components/
│   │   ├── layout/       Sidebar, Topbar, AppLayout, ProtectedRoute
│   │   ├── ui/            Primitivas: Panel, Badge, Button, Modal, Input...
│   │   └── charts/        Wrappers de Recharts con la paleta del sistema
│   ├── hooks/
│   │   └── useAuth.tsx    Contexto de autenticación
│   ├── lib/
│   │   ├── format.ts      Formato de moneda, fechas, etiquetas
│   │   └── prng.ts        PRNG determinista para el dataset sintético
│   ├── pages/             Una carpeta/archivo por pantalla del sidebar
│   ├── services/
│   │   ├── api.ts             Adapter único (mock ↔ backend real)
│   │   ├── mockDb.ts          "Base de datos" en memoria (modo demo)
│   │   ├── seedData.ts        Generador del dataset sintético
│   │   ├── analyticsEngine.ts RFM, churn, recomendaciones, estrategias
│   │   └── dashboard.ts       Agregación de métricas para el Dashboard
│   └── types/index.ts     Tipos de dominio (contrato con el backend)
├── .env.example
├── tailwind.config.js
└── vite.config.ts
```

## Dirección de diseño

Paleta y tipografía elegidas específicamente para este producto (no el kit
genérico de tarjetas con sombra suave):

- **Color:** fondo `#F6F7F3`, marca `#1F6F5C` (verde-teal, "recuperación"),
  urgencia `#E7A33E`, riesgo crítico `#B5442E`, éxito `#3C8361`.
- **Tipografía:** `Space Grotesk` (títulos y KPIs) + `IBM Plex Sans` (UI).
- **Layout:** sidebar fijo, paneles con borde de 1px, radio de esquina bajo
  y consistente, sin la sombra gris genérica de las plantillas SaaS.

## Verificación realizada

- `npx tsc -b --noEmit` → **0 errores**.
- `npm run build` → build de producción generado correctamente.
- Accesibilidad básica: foco de teclado visible, `prefers-reduced-motion`
  respetado, contraste verificado en la paleta de badges de riesgo.
- Responsive: probado en anchos de escritorio, tablet (768px) y layout
  base preparado para móvil (sidebar colapsable pendiente para la
  siguiente iteración, ver TODO abajo).

## Pendiente para las siguientes fases (no forma parte de este entregable)

- Conectar `VITE_USE_MOCK=false` contra el backend FastAPI real (Fase 3
  y 7 del roadmap).
- Colapsar el sidebar en pantallas móviles (<640px) a un menú hamburguesa.
- Internacionalización real (es/en) extrayendo los textos a un diccionario
  (sección 70 del brief) — actualmente todo el texto está en español.
- Reemplazar `analyticsEngine.ts` por llamadas a `/api/predictions/churn`,
  `/api/recommendations` y `/api/strategies` una vez el backend entregue
  los modelos entrenados y versionados.
