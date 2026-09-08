"""Shim legacy — `from app.schemas.product import ProductOut` tras migración.
Usar en código nuevo: `from app.schemas.comercio import ProductoOut` (prd_id, prd_sku).
"""
from app.schemas.comercio import ProductoOut, ProductoCreate, ProductoUpdate, CategoriaOut  # noqa: F401

# Alias inglés para compatibilidad
ProductOut = ProductoOut
ProductCreate = ProductoCreate
ProductUpdate = ProductoUpdate

__all__ = ["ProductOut", "ProductCreate", "ProductUpdate", "CategoriaOut"]
