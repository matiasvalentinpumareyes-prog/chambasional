"""Shim compatibilidad — `from app.models.product import Product` tras migración."""
from enum import Enum

from app.models.comercio import Producto as Product
from app.models.comercio import Categoria as Category
from app.models.comercio import ProductoMarca, ProductoPrecio, ProductoStock  # noqa: F401

class ProductStatus(str, Enum):
    active = "1"
    inactive = "0"

__all__ = ["Product", "Category", "ProductStatus", "ProductoMarca", "ProductoPrecio", "ProductoStock"]
