from pydantic import BaseModel, Field


class DashboardMetricsOut(BaseModel):
    """Métricas agregadas del dashboard (sección 6.1). Coincide con DashboardMetrics en frontend/src/types."""

    total_sales: float = Field(..., ge=0, description="Suma de ventas (ventas.ven_total / sales.total)")
    total_customers: int = Field(..., ge=0)
    active_customers: int = Field(..., ge=0, description="activity_status == active")
    inactive_customers: int = Field(..., ge=0, description="status == inactive")
    at_risk_customers: int = Field(..., ge=0, description="activity_status == at_risk")
    lost_customers: int = Field(..., ge=0)
    critical_customers: int = Field(..., ge=0, description="risk_level == critical")
    estimated_churn_rate: float = Field(..., ge=0, le=1, description="Clientes high+critical / total con predicción")
    recoverable_customers: int = Field(..., ge=0, description="at_risk/dormant con consentimiento")
    total_customer_value: float = Field(..., ge=0, description="Suma de total_spend")
    avg_ticket: float = Field(..., ge=0)
    avg_purchase_frequency_days: float = Field(..., ge=0)
    recovered_revenue: float = Field(..., ge=0, description="Revenue recuperado vía campañas (si aplica)")
    active_campaigns: int = Field(..., ge=0)
    finished_campaigns: int = Field(..., ge=0)
    conversion_rate: float = Field(..., ge=0, le=1)
    campaign_roi: float | None = Field(None, description="ROI global o None si no hay campañas enviadas")
    data_quality_score: float = Field(..., ge=0, le=100, description="Score 0-100 (sección 73)")
    currency: str = Field(..., description="Moneda del negocio (PEN por defecto)")

    model_config = {"from_attributes": True}


class SeriesPoint(BaseModel):
    """Punto de serie para gráficos."""

    label: str = Field(..., description="Etiqueta eje X (fecha, producto, segmento)")
    value: float = Field(..., description="Valor numérico")

    model_config = {"from_attributes": True}


class DashboardSeriesOut(BaseModel):
    """Series temporales y distribuciones del dashboard (DashboardSeries en frontend/src/types)."""

    sales_by_day: list[SeriesPoint] = Field(default_factory=list, description="Ventas últimos 30 días por día (MM-DD)")
    sales_by_month: list[SeriesPoint] = Field(default_factory=list, description="Ventas por mes (YYYY-MM)")
    new_customers_by_month: list[SeriesPoint] = Field(default_factory=list, description="Altas por mes")
    lost_customers_by_month: list[SeriesPoint] | None = Field(None, description="Opcional: churn mensual si se calcula")
    recovered_customers_by_month: list[SeriesPoint] | None = Field(None, description="Opcional")
    churn_evolution: list[SeriesPoint] | None = Field(None, description="Opcional: evolución tasa churn")
    top_products: list[SeriesPoint] = Field(default_factory=list, description="Top productos por cantidad vendida")
    segment_distribution: list[SeriesPoint] = Field(default_factory=list, description="Clientes por segmento")
    revenue_by_segment: list[SeriesPoint] = Field(default_factory=list, description="Revenue por segmento ordenado desc")

    model_config = {"from_attributes": True}


# Mantener alias por typo histórico (DashboardMetraicsOut) para compatibilidad con imports existentes
DashboardMetraicsOut = DashboardMetricsOut
