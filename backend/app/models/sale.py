"""Shim compatibilidad — `from app.models.sale import Sale` tras migración."""
from enum import Enum

from app.models.ventas import Venta as Sale
from app.models.ventas import VentaItem as SaleItem

class PaymentMethod(str, Enum):
    cash = "Efectivo"
    card = "Tarjeta"
    digital_wallet = "Digital"
    other = "Otro"

__all__ = ["Sale", "SaleItem", "PaymentMethod"]
