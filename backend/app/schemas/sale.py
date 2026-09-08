"""Shim legacy — `from app.schemas.sale import SaleOut` tras migración.
Usar en código nuevo: `from app.schemas.ventas import VentaCompletaOut` (venta_id, cli_id).
"""
from app.schemas.ventas import VentaCompletaOut as SaleOut
from app.schemas.ventas import VentaItemOut as SaleItemOut
from app.schemas.ventas import VentaCreate as SaleCreate

__all__ = ["SaleOut", "SaleItemOut", "SaleCreate"]
