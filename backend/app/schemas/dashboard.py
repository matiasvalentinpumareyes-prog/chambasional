from pydantic import BaseModel


class DashboardMetricsOut(BaseModel):
    total_sales: float
    total_customers: int
    active_customers: int
    inactive_customers: int
    at_risk_customers: int
    lost_customers: int
    critical_customers: int
    estimated_churn_rate: float
    recoverable_customers: int
    total_customer_value: float
    avg_ticket: float
    avg_purchase_frequency_days: float
    recovered_revenue: float
    active_campaigns: int
    finished_campaigns: int
    conversion_rate: float
    campaign_roi: float | None
    data_quality_score: float
    currency: str


class SeriesPoint(BaseModel):
    label: str
    value: float


class DashboardSeriesOut(BaseModel):
    sales_by_day: list[SeriesPoint]
    sales_by_month: list[SeriesPoint]
    new_customers_by_month: list[SeriesPoint]
    top_products: list[SeriesPoint]
    segment_distribution: list[SeriesPoint]
    revenue_by_segment: list[SeriesPoint]
