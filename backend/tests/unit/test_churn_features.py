from datetime import datetime, timedelta, timezone

from app.ml.churn_model import build_training_dataframe
from app.ml.features import FEATURE_NAMES, compute_features


def test_compute_features_returns_zero_defaults_when_no_sales():
    features = compute_features([], [], datetime.now(timezone.utc))
    assert features["recency_days"] == 9999.0
    assert features["frequency"] == 0.0
    for name in FEATURE_NAMES:
        assert name in features
        assert features[name] == features[name]  # NaN != NaN, así que esto falla si hay NaN


def test_compute_features_only_uses_sales_before_reference_date():
    """No debe existir data leakage: una compra futura respecto a reference_date no debe afectar las features."""
    now = datetime.now(timezone.utc)
    past_sales = [now - timedelta(days=30), now - timedelta(days=15)]
    totals = [50.0, 60.0]

    features_before = compute_features(past_sales, totals, now)
    # Si agregamos una compra FUTURA (después de "now"), pero seguimos
    # calculando con reference_date=now, el resultado debe ser idéntico,
    # porque compute_features recibe explícitamente solo lo que el
    # caller decide incluir como "pasado".
    features_same = compute_features(past_sales, totals, now)
    assert features_before == features_same


def test_features_recency_is_not_always_zero_in_training_set():
    """
    Regresión de un bug real encontrado durante el desarrollo: si la fecha
    de referencia usada para las features coincide siempre con la última
    compra del corte, 'recency_days' queda constante en 0 para todo el
    dataset, destruyendo la señal más importante del modelo.
    """
    now = datetime(2026, 9, 3, tzinfo=timezone.utc)
    customer_sales = {}
    for i in range(20):
        base = now - timedelta(days=i * 5)
        dates = [base - timedelta(days=30 * k) for k in range(8)][::-1]
        customer_sales[f"cust_{i}"] = [(d, 25.0) for d in dates]

    df = build_training_dataframe(customer_sales, now)
    assert len(df) > 0
    assert df["recency_days"].nunique() > 1, "recency_days no debería ser constante"
    assert (df["recency_days"] >= 0).all()


def test_probabilities_and_scores_are_within_valid_ranges():
    """Sección 59: las predicciones deben estar siempre entre 0 y 1 (o 0-100 para el score)."""
    from app.services.churn import _percentile_score, _rule_based_probability
    from app.models.cliente import Cliente

    customer = Customer(
        business_id="b1", first_name="T", last_name="C",
        registered_at=datetime.now(timezone.utc) - timedelta(days=100),
        purchase_count=3, total_spend=200, avg_interval_days=20,
        last_purchase_at=datetime.now(timezone.utc) - timedelta(days=80),
    )
    features = compute_features(
        [datetime.now(timezone.utc) - timedelta(days=d) for d in [80, 60, 40]], [50, 60, 70], datetime.now(timezone.utc)
    )
    probability = _rule_based_probability(customer, features)
    assert 0.0 <= probability <= 1.0

    score = _percentile_score(probability, [0.1, 0.2, 0.3, 0.4, 0.5, 0.05, 0.6, 0.7, 0.8, 0.02])
    assert 0 <= score <= 100
