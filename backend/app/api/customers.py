"""Shim legacy — /customers ahora usa BD real (cliente)."""
from app.api.clientes import router_legacy as router

__all__ = ["router"]
