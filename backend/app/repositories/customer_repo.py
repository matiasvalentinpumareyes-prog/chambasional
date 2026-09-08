"""Wrapper legacy — mantiene `from app.repositories.customer_repo import CustomerRepository` tras migración.
Usar en código nuevo: `from app.repositories.cliente_repo import ClienteRepository` (emp_id).
"""
from app.repositories.cliente_repo import ClienteRepository as CustomerRepository

__all__ = ["CustomerRepository", "ClienteRepository"]

# Alias para imports directos
try:
    from app.repositories.cliente_repo import ClienteRepository
except ImportError:
    pass
