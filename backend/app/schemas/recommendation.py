from datetime import datetime
from enum import Enum

from pydantic import BaseModel, Field


class CanalCodigo(str, Enum):
    """Valores exactos de canales_marketing.can_codigo (BD)."""
    EMAIL = "EMAIL"
    SMS = "SMS"
    WHATSAPP = "WHATSAPP"
    PUSH = "PUSH"


class RecommendationMethod(str, Enum):
    """Método generación recomendación — valores de recomendaciones rec_titulo/prioridad o reglas."""
    rules = "rules"
    collaborative_filtering = "collaborative_filtering"
    frequency = "frequency"
    cold_start = "cold_start"


class CustomerValue(str, Enum):
    low = "low"
    medium = "medium"
    high = "high"


class RecommendationOut(BaseModel):
    """Recomendación de producto computada (no fila DB) — sección 18-19.

    Para fila DB ver cupones.py:RecomendacionOut (recomendaciones.rec_id, emp_id, cli_id...).
    Esta es la recomendación calculada al vuelo para el frontend (ProductRecommendation).
    Nombres inglés permitidos por ser DTO computado, no columna DB directa; los IDs internos
    siguen siendo cli_id/prd_id en la BD.
    """

    customer_id: str = Field(..., description="UUID cliente (cliente.cli_id)")
    product_id: str = Field(..., description="UUID producto (producto.prd_id)")
    product_name: str = Field(..., description="producto.prd_nombre resuelto")
    score: int = Field(..., ge=0, le=100, description="Score 0-100")
    reasons: list[str] = Field(..., description="Razones explicables")
    confidence: float = Field(..., ge=0, le=1)
    method: RecommendationMethod = Field(..., description="rules | collaborative_filtering | frequency | cold_start")
    generated_at: datetime = Field(..., description="Fecha generación")
    model_version: str = Field(..., description="Versión modelo (VersionModelo.vrm_version o rules-v1-fallback)")

    # Alias español para código nuevo que usa BD exacto
    @property
    def cli_id(self) -> str:
        return self.customer_id

    @property
    def prd_id(self) -> str:
        return self.product_id

    model_config = {"from_attributes": True, "protected_namespaces": ()}


class StrategyOut(BaseModel):
    """Estrategia recuperación — pantalla '¿A quién contactar hoy?' (20,21,26,27).

    Computada, no fila DB. Usa cliente.cli_id y canales_marketing.can_codigo.
    """

    customer_id: str = Field(..., description="cliente.cli_id")
    customer_name: str = Field(..., description="cliente.cli_nombre_razon_social")
    priority_score: int = Field(..., ge=0, le=100, description="Recovery Priority Score 0-100")
    churn_probability: float = Field(..., ge=0, le=1, description="predicciones.pdc_prob_abandono")
    recovery_probability: float = Field(..., ge=0, le=1)
    customer_value: CustomerValue = Field(..., description="low|medium|high derivado de cliente_features")
    recommended_product: RecommendationOut | None = Field(None, description="Producto principal recomendado")
    recommended_action: CanalCodigo | str = Field(..., description="Canal recomendado — canales_marketing.can_codigo (EMAIL/SMS/WHATSAPP/PUSH) o email/whatsapp lowercase legacy")
    recommended_offer: str = Field(..., description="Oferta textual ej '10% de descuento' (cupones.cup_codigo)")
    recommended_timing: str = Field(..., description="now|today|in_2_days|in_5_days")
    reason: str = Field(..., description="Texto agregado razones")
    message: str = Field(..., description="Mensaje plantilla (no alucina productos)")
    cooldown_ok: bool = Field(..., description="Respeta campaña cooldown")
    has_consent: bool = Field(..., description="cliente_consentimientos.consentimiento == 1")

    model_config = {"from_attributes": True, "protected_namespaces": ()}
