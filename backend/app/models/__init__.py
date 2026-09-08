"""
Modelos BD real db_regresape — 43 tablas.
Nombres exactos a database_postgres.sql (español/inglés según BD).
"""

from app.models.base import Base
from app.models.catalogs import (
    Departamento, Provincia, Distrito, Documento, MetodoPago,
    CanalMarketing, Segmento, Rol, AuditoriaEntidad, AuditoriaAccion, PatronCompra,
)
from app.models.empresa import Empresa, UsuarioPersonal, Usuario
from app.models.comercio import Categoria, ProductoMarca, Producto, ProductoPrecio, ProductoStock
from app.models.cliente import (
    Cliente, ClienteConsentimiento, ClienteSegmento, ClienteSegmentoHistorial,
    ClienteFeatures, ClienteEstacionalidad, TipoDireccionExplicacion, PrediccionExplicacion,
)
from app.models.ventas import Venta, VentaItem
from app.models.ia import VersionModelo, ModelMetric, Prediccion
from app.models.marketing import Estrategia, Rule, Cupon, Recomendacion, CuponCanje
from app.models.campanas import Campaign, CampaignRecipient, Comunicacion
from app.models.auditoria import AuditoriaLog, Import, ImportError

__all__ = [
    "Base",
    # catalogos
    "Departamento", "Provincia", "Distrito", "Documento", "MetodoPago",
    "CanalMarketing", "Segmento", "Rol", "AuditoriaEntidad", "AuditoriaAccion", "PatronCompra",
    # empresa
    "Empresa", "UsuarioPersonal", "Usuario",
    # comercio
    "Categoria", "ProductoMarca", "Producto", "ProductoPrecio", "ProductoStock",
    # cliente
    "Cliente", "ClienteConsentimiento", "ClienteSegmento", "ClienteSegmentoHistorial",
    "ClienteFeatures", "ClienteEstacionalidad", "TipoDireccionExplicacion", "PrediccionExplicacion",
    # ventas
    "Venta", "VentaItem",
    # ia
    "VersionModelo", "ModelMetric", "Prediccion",
    # marketing
    "Estrategia", "Rule", "Cupon", "Recomendacion", "CuponCanje",
    # campanas
    "Campaign", "CampaignRecipient", "Comunicacion",
    # auditoria
    "AuditoriaLog", "Import", "ImportError",
]
