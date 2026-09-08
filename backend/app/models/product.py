"""Shim compatibilidad — `from app.models.product import Product` tras migración."""
from enum import Enum

from app.models.comercio import Producto as Product
from app.models.comercio import Categoria as Category
from app.models.comercio import ProductoMarca, ProductoPrecio, ProductoStock  # noqa: F401

class ProductStatus(str, Enum):
    """Estado producto dinámico (producto.estado SMALLINT)"""
    @classmethod
    def _missing_(cls, value):
        if isinstance(value, (str, int)):
            v = str(value)
            obj = str.__new__(cls, v)
            obj._name_ = v
            obj._value_ = v
            return obj
        return None

try:
    Product.business_id = property(lambda self: self.emp_id)
    Product.id = property(lambda self: self.prd_id)
    Product.sku = property(lambda self: self.prd_sku)
    Product.name = property(lambda self: self.prd_nombre)
    Product.description = property(lambda self: self.prd_descripcion)
    Product.category_id = property(lambda self: self.cat_id)
    Product.price = property(lambda self: self.prd_precios if hasattr(self, 'prd_precios') else 0)
    Product.cost = property(lambda self: getattr(self, 'prd_precios_costo', None))
    Product.stock = property(lambda self: 0)
    Product.status = property(lambda self: ProductStatus.active if self.estado == 1 else ProductStatus.inactive)
    Category.business_id = property(lambda self: self.emp_id)
    Category.id = property(lambda self: self.cat_id)
    Category.name = property(lambda self: self.cat_nombre)
except Exception:
    pass

__all__ = ["Product", "Category", "ProductStatus", "ProductoMarca", "ProductoPrecio", "ProductoStock"]
