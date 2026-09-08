"""Shim compatibilidad — `from app.models.sale import Sale` tras migración."""
from enum import Enum

from app.models.ventas import Venta as Sale
from app.models.ventas import VentaItem as SaleItem

class PaymentMethod(str, Enum):
    """Métodos de pago dinámicos vía tabla metodos_pago (mtp_id/mtp_nombre).
    Listar disponibles: GET /catalogos/metodos-pago
    """

    @classmethod
    def _missing_(cls, value):
        if isinstance(value, str):
            obj = str.__new__(cls, value)
            obj._name_ = value.upper().replace(" ", "_").replace("-", "_")
            obj._value_ = value
            return obj
        return None

try:
    Sale.business_id = property(lambda self: self.emp_id)
    Sale.id = property(lambda self: self.venta_id)
    Sale.customer_id = property(lambda self: self.cli_id)
    Sale.date = property(lambda self: self.created_at)
    Sale.discount_total = property(lambda self: self.ven_descuento)
    Sale.total = property(lambda self: self.ven_total)
    Sale.channel = property(lambda self: self.venta_origen)
    SaleItem.sale_id = property(lambda self: self.venta_id)
    SaleItem.product_id = property(lambda self: self.prd_id)
    SaleItem.quantity = property(lambda self: self.cantidad)
    SaleItem.unit_price = property(lambda self: self.precio_unitario)
    SaleItem.discount = property(lambda self: self.descuento)
    SaleItem.subtotal = property(lambda self: self.subtotal)
except Exception:
    pass

__all__ = ["Sale", "SaleItem", "PaymentMethod"]
