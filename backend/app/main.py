import logging

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.core.config import settings
from app.core.errors import AppError

# Routers esenciales (auth/health/clientes/catalogos) - import directo
from app.api import auth, catalogs, health
from app.api import clientes
from app.api.usuarios import router as usuarios_router, roles_router

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
# Catálogos dinámicos (no hardcodeados) — metodos_pago, canales, segmentos, documentos
app.include_router(catalogs.router, prefix=settings.API_V1_PREFIX)
app.include_router(usuarios_router, prefix=settings.API_V1_PREFIX)
app.include_router(roles_router, prefix=settings.API_V1_PREFIX)
# Clientes: nuevo /clientes + legacy /customers (via clientes.router_legacy)
app.include_router(clientes.router, prefix=settings.API_V1_PREFIX)
app.include_router(clientes.router_legacy, prefix=settings.API_V1_PREFIX)
# Routers no críticos para login — se intentan cargar pero no bloquean si fallan
for _mod_name, _prefix in [
    ("productos", settings.API_V1_PREFIX),
    ("products", settings.API_V1_PREFIX),
    ("stock", settings.API_V1_PREFIX),
    ("ventas", settings.API_V1_PREFIX),
    ("dashboard", settings.API_V1_PREFIX),
    ("predictions", settings.API_V1_PREFIX),
    ("campaigns", settings.API_V1_PREFIX),
    ("imports", settings.API_V1_PREFIX),
    ("models", settings.API_V1_PREFIX),
    ("settings", settings.API_V1_PREFIX),
    ("subcategorias", settings.API_V1_PREFIX),
]:
    try:
        _mod = __import__(f"app.api.{_mod_name}", fromlist=["router"])
        _router = getattr(_mod, "router", None)
        if _router is not None:
            app.include_router(_router, prefix=_prefix)
        # también legacy ventas
        if _mod_name == "ventas" and hasattr(_mod, "router_legacy"):
            app.include_router(_mod.router_legacy, prefix=_prefix)
    except Exception as e:
        logger.warning(f"Router {_mod_name} no cargado (no bloquea login): {e}")


@app.get("/")
def root():
    return {"name": settings.PROJECT_NAME, "docs": "/docs"}
