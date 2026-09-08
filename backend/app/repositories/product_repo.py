"""Wrapper legacy — `from app.repositories.product_repo import ProductRepository` tras migración."""
from app.repositories.producto_repo import ProductoRepository as ProductRepository

__all__ = ["ProductRepository", "ProductoRepository"]
