import logging

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.api import auth, campaigns, catalogs, dashboard, health, imports, models, predictions, sales, settings as settings_router
from app.api import clientes, productos, stock, subcategorias, ventas
from app.core.config import settings
from app.core.errors import AppError

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("marketing_predictivo")

app = FastAPI(title=settings.PROJECT_NAME, version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.exception_handler(AppError)
async def app_error_handler(request: Request, exc: AppError):
    return JSONResponse(status_code=exc.status_code, content={"success": False, "error": {"code": exc.code, "message": exc.message}})


@app.exception_handler(Exception)
async def unhandled_exception_handler(request: Request, exc: Exception):
    logger.exception("Unhandled exception on %s %s", request.method, request.url)
    return JSONResponse(
        status_code=500,
        content={"success": False, "error": {"code": "INTERNAL_ERROR", "message": "Ocurrió un error inesperado. Intenta de nuevo."}},
    )


app.include_router(health.router, prefix=settings.API_V1_PREFIX)
app.include_router(auth.router, prefix=settings.API_V1_PREFIX)
# Catálogos dinámicos (no hardcodeados) — metodos_pago, canales, segmentos, subcategorias
app.include_router(catalogs.router, prefix=settings.API_V1_PREFIX)
app.include_router(subcategorias.router, prefix=settings.API_V1_PREFIX)
# Clientes: nuevo /clientes + legacy /customers (via clientes.router_legacy)
app.include_router(clientes.router, prefix=settings.API_V1_PREFIX)
app.include_router(clientes.router_legacy, prefix=settings.API_V1_PREFIX)
app.include_router(productos.router, prefix=settings.API_V1_PREFIX)
# Shim legacy /products -> productos
from app.api import products as products_shim
app.include_router(products_shim.router, prefix=settings.API_V1_PREFIX)
app.include_router(stock.router, prefix=settings.API_V1_PREFIX)
app.include_router(ventas.router, prefix=settings.API_V1_PREFIX)
app.include_router(ventas.router_legacy, prefix=settings.API_V1_PREFIX)
app.include_router(dashboard.router, prefix=settings.API_V1_PREFIX)
app.include_router(predictions.router, prefix=settings.API_V1_PREFIX)
app.include_router(campaigns.router, prefix=settings.API_V1_PREFIX)
app.include_router(imports.router, prefix=settings.API_V1_PREFIX)
app.include_router(models.router, prefix=settings.API_V1_PREFIX)
app.include_router(settings_router.router, prefix=settings.API_V1_PREFIX)


@app.get("/")
def root():
    return {"name": settings.PROJECT_NAME, "docs": "/docs"}
