"""Wrapper legacy — `from app.repositories.sale_repo import SaleRepository` tras migración."""
from app.repositories.venta_repo import VentaRepository as SaleRepository

__all__ = ["SaleRepository", "VentaRepository"]
