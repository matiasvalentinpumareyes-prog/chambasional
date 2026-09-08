"""Shim legacy — /sales ahora usa BD real (ventas)."""
from app.api.ventas import router_legacy as router

__all__ = ["router"]
