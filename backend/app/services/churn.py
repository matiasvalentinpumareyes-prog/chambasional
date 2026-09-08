import os
from datetime import datetime, timezone

import joblib
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.ml.churn_model import (
    MIN_TRAINING_EXAMPLES,
    ModelResult,
    build_training_dataframe,
    predict_proba_single,
    select_best_model,
    train_and_compare_models,
)
from app.ml.features import compute_features
from app.models.ia import VersionModelo, ModelMetric
from app.models.empresa import Empresa
from app.models.cliente import Cliente
from app.models.ia import Prediccion
from app.models.ventas import Venta

ARTIFACTS_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), "ml_artifacts")
os.makedirs(ARTIFACTS_DIR, exist_ok=True)

RULES_FALLBACK_VERSION = "rules-v1-fallback"
DATASET_VERSION = "sales-history-v1"


def _get_customer_sales_map(db: Session, business_id: str) -> dict[str, list[tuple[datetime, float]]]:
    stmt = select(Sale.customer_id, Sale.date, Sale.total).where(Sale.business_id == business_id)
    result: dict[str, list[tuple[datetime, float]]] = {}
    for customer_id, date, total in db.execute(stmt):
        result.setdefault(customer_id, []).append((date, float(total)))
    return result


def train_churn_model(db: Session, business_id: str, reference_date: datetime | None = None) -> ModelVersion:
    """
    Entrena el clasificador de churn para un negocio (sección 47: pipeline
    completo data validation -> feature engineering -> train -> validation
    -> metrics -> compare with baseline -> accept -> register).

    Si no hay suficientes datos para entrenar, registra explícitamente un
    ModelVersion de tipo fallback (reglas), para que siempre quede
    trazabilidad de qué generó cada predicción (sección 48).
    """
    reference_date = reference_date or datetime.now(timezone.utc)
    customer_sales = _get_customer_sales_map(db, business_id)
    df = build_training_dataframe(customer_sales, reference_date)

    current_production = _get_production_model(db, business_id)

    if len(df) < MIN_TRAINING_EXAMPLES:
        if current_production and current_production.model_name == "churn_classifier":
            return current_production  # ya existe un fallback registrado, no crear duplicados (idempotencia)
        return _register_fallback_model(db, business_id, reason="insufficient_training_data")

    results = train_and_compare_models(df)
    best = select_best_model(results)

    current_best_roc = 0.5
    if current_production:
        current_metric = next((m for m in current_production.metrics if m.name == "roc_auc"), None)
        if current_metric:
            current_best_roc = current_metric.value

    should_promote = best.metrics["roc_auc"] >= current_best_roc or current_production is None

    version_label = f"1.0.{_next_version_suffix(db, business_id)}"
    file_path = os.path.join(ARTIFACTS_DIR, f"{business_id}_{best.name}_{version_label}.joblib")
    joblib.dump({"model": best.model, "scaler": best.scaler}, file_path)

    if should_promote and current_production:
        current_production.status = ModelStatus.deprecated
        db.add(current_production)

    model_version = ModelVersion(
        business_id=business_id,
        model_name="churn_classifier",
        version=version_label,
        training_date=reference_date,
        dataset_version=DATASET_VERSION,
        features=list(compute_features([], [], reference_date).keys()),
        status=ModelStatus.production if should_promote else ModelStatus.candidate,
        file_path=file_path,
    )
    db.add(model_version)
    db.flush()

    for metric_name, value in best.metrics.items():
        if metric_name in {"accuracy", "precision", "recall", "f1", "roc_auc", "pr_auc"}:
            db.add(ModelMetric(model_version_id=model_version.id, name=metric_name, value=value))

    db.commit()
    db.refresh(model_version)
    return model_version


def _next_version_suffix(db: Session, business_id: str) -> int:
    existing = list(
        db.scalars(
            select(ModelVersion).where(ModelVersion.business_id == business_id, ModelVersion.model_name == "churn_classifier")
        )
    )
    return len(existing) + 1


def _register_fallback_model(db: Session, business_id: str, reason: str) -> ModelVersion:
    model_version = ModelVersion(
        business_id=business_id,
        model_name="churn_classifier",
        version="0.0.0-" + RULES_FALLBACK_VERSION,
        training_date=datetime.now(timezone.utc),
        dataset_version=reason,
        features=["recencia_relativa", "frecuencia_historica", "gasto_historico"],
        status=ModelStatus.production,
        file_path=None,
    )
    db.add(model_version)
    db.commit()
    db.refresh(model_version)
    return model_version


def _get_production_model(db: Session, business_id: str) -> ModelVersion | None:
    stmt = (
        select(ModelVersion)
        .where(
            ModelVersion.business_id == business_id,
            ModelVersion.model_name == "churn_classifier",
            ModelVersion.status == ModelStatus.production,
        )
        .order_by(ModelVersion.training_date.desc())
    )
    return db.scalar(stmt)


_loaded_artifacts_cache: dict[str, tuple] = {}


def _load_artifact(file_path: str) -> tuple:
    if file_path not in _loaded_artifacts_cache:
        data = joblib.load(file_path)
        _loaded_artifacts_cache[file_path] = (data["model"], data["scaler"])
    return _loaded_artifacts_cache[file_path]


def _risk_level(score: int, business: Business) -> RiskLevel:
    if score >= business.churn_threshold_critical:
        return RiskLevel.critical
    if score >= business.churn_threshold_high:
        return RiskLevel.high
    if score >= business.churn_threshold_medium:
        return RiskLevel.medium
    return RiskLevel.low


def _build_reasons(customer: Customer, features: dict) -> list[str]:
    """Explicabilidad en lenguaje simple (sección 16), previa a SHAP."""
    reasons = []
    if customer.avg_interval_days:
        reasons.append(
            f"Normalmente compra cada {customer.avg_interval_days} días y lleva "
            f"{int(features['recency_days'])} días sin comprar."
        )
    else:
        reasons.append(f"Lleva {int(features['recency_days'])} días sin comprar, sin historial suficiente para estimar su frecuencia habitual.")
    if customer.avg_interval_days and features["recency_days"] > customer.avg_interval_days * 1.5:
        reasons.append("Su tiempo sin comprar supera claramente su comportamiento habitual.")
    if features["frequency"] <= 2:
        reasons.append("Tiene una frecuencia de compra históricamente baja.")
    if features["ticket_trend"] < -0.15:
        reasons.append("Su gasto por compra ha disminuido en el tiempo.")
    if features["purchases_last_90d"] == 0 and features["frequency"] > 0:
        reasons.append("No ha comprado en los últimos 90 días.")
    return reasons


def _percentile_score(probability: float, peer_probabilities: list[float]) -> int:
    """
    Convierte una probabilidad calibrada en un score de riesgo RELATIVO
    (0-100) frente a los demás clientes del negocio.

    Esto es una decisión de producto deliberada: una probabilidad bien
    calibrada de un evento poco frecuente (típicamente 1-10% de los
    clientes) casi nunca supera umbrales como 60 u 80 en una escala
    absoluta 0-100, lo que haría inútiles los niveles "alto"/"crítico"
    configurados en la sección 13 del brief. Lo que un pequeño negocio
    necesita no es la probabilidad estadística exacta, sino saber qué
    clientes están relativamente peor que el resto AHORA MISMO. Por eso
    el score que alimenta risk_level y la priorización es un percentil,
    mientras que churn_probability (el número que se explica al usuario
    como "X% de probabilidad") sigue siendo la probabilidad calibrada real.
    """
    if len(peer_probabilities) < 10:
        # Cold start de negocio (pocos clientes con predicción todavía):
        # no hay suficientes pares para un percentil confiable, se usa
        # una amplificación conservadora de la probabilidad cruda.
        return min(100, round(probability * 300))

    below_or_equal = sum(1 for p in peer_probabilities if p <= probability)
    return round(100 * below_or_equal / len(peer_probabilities))


def predict_churn_batch(db: Session, business: Business, customers: list[Customer], reference_date: datetime | None = None) -> list[Prediction]:
    """
    Genera predicciones de churn para un lote completo de clientes en una
    sola pasada, calculando el score percentil de forma consistente
    (todos comparados contra el mismo conjunto de pares). Se usa desde el
    job diario (sección 25) y desde el script de seed.
    """
    reference_date = reference_date or datetime.now(timezone.utc)
    production_model = _get_production_model(db, business.id)

    raw: list[tuple[Customer, dict, float, str, float]] = []  # (customer, features, probability, model_version, confidence)
    for customer in customers:
        if customer.purchase_count == 0:
            continue
        sales = list(db.scalars(select(Sale).where(Sale.customer_id == customer.id).order_by(Sale.date.asc())))
        dates = [s.date for s in sales]
        totals = [float(s.total) for s in sales]
        features = compute_features(dates, totals, reference_date)

        if production_model and production_model.file_path:
            model, scaler = _load_artifact(production_model.file_path)
            result = ModelResult(name=production_model.model_name, model=model, scaler=scaler, metrics={})
            probability = predict_proba_single(result, features)
            model_version_label = production_model.version
        else:
            probability = _rule_based_probability(customer, features)
            model_version_label = RULES_FALLBACK_VERSION

        confidence = 0.82 if customer.purchase_count >= 4 else 0.6 if customer.purchase_count >= 2 else 0.35
        raw.append((customer, features, probability, model_version_label, confidence))

    all_probabilities = [p for _, _, p, _, _ in raw]
    predictions: list[Prediction] = []

    for customer, features, probability, model_version_label, confidence in raw:
        peers = [p for p in all_probabilities if p is not probability] or all_probabilities
        score = _percentile_score(probability, peers)
        risk_level = _risk_level(score, business)
        reasons = _build_reasons(customer, features)
        next_purchase = _estimate_next_purchase(customer, features, reference_date)

        prediction = Prediction(
            business_id=business.id, customer_id=customer.id,
            churn_probability=round(probability, 4), churn_score=score, risk_level=risk_level,
            confidence=confidence, reasons=reasons,
            expected_next_purchase_date=next_purchase["expected_next_purchase_date"],
            days_until_expected_purchase=next_purchase["days_until_expected_purchase"],
            purchase_probability=next_purchase["purchase_probability"],
            prediction_date=reference_date, model_version=model_version_label,
        )
        db.add(prediction)
        predictions.append(prediction)

    db.commit()
    for p in predictions:
        db.refresh(p)
    return predictions


def predict_churn(db: Session, customer: Customer, business: Business, reference_date: datetime | None = None) -> Prediction | None:
    """
    Genera y persiste la predicción de UN cliente (por ejemplo, justo
    después de registrar una venta nueva). El score percentil se calcula
    contra las predicciones más recientes ya existentes de los demás
    clientes del negocio (ver predict_churn_batch para el recálculo
    masivo, que es más preciso porque compara a todos entre sí en el
    mismo instante).
    """
    if customer.purchase_count == 0:
        return None

    reference_date = reference_date or datetime.now(timezone.utc)

    sales = list(db.scalars(select(Sale).where(Sale.customer_id == customer.id).order_by(Sale.date.asc())))
    dates = [s.date for s in sales]
    totals = [float(s.total) for s in sales]
    features = compute_features(dates, totals, reference_date)

    production_model = _get_production_model(db, business.id)

    if production_model and production_model.file_path:
        model, scaler = _load_artifact(production_model.file_path)
        result = ModelResult(name=production_model.model_name, model=model, scaler=scaler, metrics={})
        probability = predict_proba_single(result, features)
        model_version_label = production_model.version
    else:
        probability = _rule_based_probability(customer, features)
        model_version_label = RULES_FALLBACK_VERSION

    confidence = 0.82 if customer.purchase_count >= 4 else 0.6 if customer.purchase_count >= 2 else 0.35

    peer_rows = db.execute(
        select(Prediction.customer_id, Prediction.churn_probability)
        .where(Prediction.business_id == business.id)
        .order_by(Prediction.prediction_date.desc())
    )
    latest_by_customer: dict[str, float] = {}
    for cust_id, prob in peer_rows:
        if cust_id != customer.id and cust_id not in latest_by_customer:
            latest_by_customer[cust_id] = float(prob)
    score = _percentile_score(probability, list(latest_by_customer.values()))

    risk_level = _risk_level(score, business)
    reasons = _build_reasons(customer, features)
    next_purchase = _estimate_next_purchase(customer, features, reference_date)

    prediction = Prediction(
        business_id=business.id,
        customer_id=customer.id,
        churn_probability=round(probability, 4),
        churn_score=score,
        risk_level=risk_level,
        confidence=confidence,
        reasons=reasons,
        expected_next_purchase_date=next_purchase["expected_next_purchase_date"],
        days_until_expected_purchase=next_purchase["days_until_expected_purchase"],
        purchase_probability=next_purchase["purchase_probability"],
        prediction_date=reference_date,
        model_version=model_version_label,
    )
    db.add(prediction)
    db.commit()
    db.refresh(prediction)
    return prediction


def _rule_based_probability(customer: Customer, features: dict) -> float:
    avg_interval = customer.avg_interval_days or 30
    ratio = features["recency_days"] / avg_interval if avg_interval > 0 else 1.0

    # Factor de recencia (0-1): si el cliente compró hace muy poco en
    # relación a su ciclo esperado, los factores de baja frecuencia/gasto
    # no deben inflar el riesgo — un cliente que acaba de comprar no está
    # "en riesgo" solo por ser nuevo o gastar poco todavía.
    recency_factor = max(0.0, min(1.0, ratio))

    score = 0.0
    score += min(55.0, max(0.0, (ratio - 0.8) * 35))
    score += (15 if features["frequency"] <= 2 else 8 if features["frequency"] <= 3 else 0) * recency_factor
    score += (10 if features["total_spend"] <= 150 else 0) * recency_factor
    score += (10 if customer.purchase_count == 1 else 0) * recency_factor
    return max(0.0, min(100.0, score)) / 100


def _estimate_next_purchase(customer: Customer, features: dict, reference_date: datetime) -> dict:
    if customer.purchase_count < 2 or not customer.avg_interval_days:
        return {"expected_next_purchase_date": None, "days_until_expected_purchase": None, "purchase_probability": None}

    days_until = customer.avg_interval_days - int(features["recency_days"])
    expected_date = reference_date.fromtimestamp(reference_date.timestamp() + max(days_until, 0) * 86400)

    ratio = features["recency_days"] / customer.avg_interval_days
    probability = max(0.05, min(0.95, 1.2 - ratio * 0.5))

    return {
        "expected_next_purchase_date": expected_date,
        "days_until_expected_purchase": days_until,
        "purchase_probability": round(probability, 2),
    }


def get_active_model_version(db: Session, business_id: str) -> ModelVersion | None:
    return _get_production_model(db, business_id)
