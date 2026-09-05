from datetime import datetime


def compute_features(sale_dates: list[datetime], sale_totals: list[float], reference_date: datetime) -> dict:
    """
    Calcula las variables de churn (sección 14) usando ÚNICAMENTE compras
    que ya ocurrieron antes de `reference_date`. Esto es lo que garantiza
    que no haya data leakage: tanto en entrenamiento (reference_date =
    fecha de corte histórica) como en inferencia (reference_date = ahora),
    la misma función solo mira "el pasado" relativo al punto de corte.
    """
    n = len(sale_dates)
    if n == 0:
        return {
            "recency_days": 9999.0, "frequency": 0.0, "total_spend": 0.0, "avg_ticket": 0.0,
            "avg_interval_days": 0.0, "interval_deviation": 0.0, "purchases_last_30d": 0.0,
            "purchases_last_90d": 0.0, "purchases_last_180d": 0.0, "ticket_trend": 0.0,
        }

    recency_days = (reference_date - sale_dates[-1]).days
    frequency = float(n)
    total_spend = sum(sale_totals)
    avg_ticket = total_spend / n

    intervals = [
        (sale_dates[i] - sale_dates[i - 1]).days for i in range(1, n) if (sale_dates[i] - sale_dates[i - 1]).days > 0
    ]
    avg_interval_days = sum(intervals) / len(intervals) if intervals else 0.0
    if len(intervals) > 1:
        mean_interval = avg_interval_days
        variance = sum((g - mean_interval) ** 2 for g in intervals) / len(intervals)
        interval_deviation = variance ** 0.5
    else:
        interval_deviation = 0.0

    purchases_last_30d = sum(1 for d in sale_dates if (reference_date - d).days <= 30)
    purchases_last_90d = sum(1 for d in sale_dates if (reference_date - d).days <= 90)
    purchases_last_180d = sum(1 for d in sale_dates if (reference_date - d).days <= 180)

    # Tendencia del ticket: compara el ticket promedio de la primera mitad vs la segunda mitad del historial.
    if n >= 4:
        mid = n // 2
        first_half_avg = sum(sale_totals[:mid]) / mid
        second_half_avg = sum(sale_totals[mid:]) / (n - mid)
        ticket_trend = (second_half_avg - first_half_avg) / first_half_avg if first_half_avg > 0 else 0.0
    else:
        ticket_trend = 0.0

    return {
        "recency_days": float(recency_days),
        "frequency": frequency,
        "total_spend": float(total_spend),
        "avg_ticket": float(avg_ticket),
        "avg_interval_days": float(avg_interval_days),
        "interval_deviation": float(interval_deviation),
        "purchases_last_30d": float(purchases_last_30d),
        "purchases_last_90d": float(purchases_last_90d),
        "purchases_last_180d": float(purchases_last_180d),
        "ticket_trend": float(ticket_trend),
    }


FEATURE_NAMES = [
    "recency_days", "frequency", "total_spend", "avg_ticket", "avg_interval_days",
    "interval_deviation", "purchases_last_30d", "purchases_last_90d", "purchases_last_180d", "ticket_trend",
]
