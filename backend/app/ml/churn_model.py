import random
from dataclasses import dataclass
from datetime import datetime, timedelta

import numpy as np
import pandas as pd
from sklearn.calibration import CalibratedClassifierCV
from sklearn.ensemble import HistGradientBoostingClassifier, RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import (
    accuracy_score, average_precision_score, confusion_matrix, f1_score,
    precision_score, recall_score, roc_auc_score,
)
from sklearn.model_selection import StratifiedKFold
from sklearn.preprocessing import StandardScaler

from app.ml.features import FEATURE_NAMES, compute_features

MIN_PURCHASES_FOR_TRAINING_EXAMPLE = 5
MIN_TRAINING_EXAMPLES = 60  # por debajo de esto, se usa el fallback de reglas (sección 46)
CHURN_LABEL_RATIO_THRESHOLD = 1.5  # "tardó más de 1.5x su intervalo habitual" -> ejemplo positivo
MAX_CUTOFFS_PER_CUSTOMER = 3  # ventana deslizante: varios ejemplos por cliente, sin sobre-representar a los de historial largo

_rng = random.Random(20260101)  # semilla fija: dataset de entrenamiento reproducible


def build_training_dataframe(
    customer_sales: dict[str, list[tuple[datetime, float]]], reference_end: datetime
) -> pd.DataFrame:
    """
    Construye el dataset de entrenamiento sin data leakage: para cada
    cliente con suficiente historial, se generan varios puntos de corte
    (ventana deslizante) y las features se calculan SOLO con compras
    anteriores a ese corte. La etiqueta (¿churneó?) se calcula con lo que
    pasó DESPUÉS del corte, información que el modelo nunca ve como feature.

    IMPORTANTE (bug corregido): las features no se evalúan exactamente en
    la fecha de la última compra conocida (eso hacía que "recency_days"
    fuera siempre 0, destruyendo la señal más importante del modelo).
    En su lugar, se simula un punto de observación posterior — igual que
    en producción, donde siempre ha pasado algún tiempo desde la última
    compra al momento de predecir — sin nunca cruzar la fecha de la
    siguiente compra real (para no filtrar información del futuro).
    """
    rows = []
    for customer_id, sales in customer_sales.items():
        sales = sorted(sales, key=lambda s: s[0])
        n = len(sales)
        if n < MIN_PURCHASES_FOR_TRAINING_EXAMPLE:
            continue

        candidate_cutoffs = list(range(3, n - 1))
        if not candidate_cutoffs:
            continue
        chosen_cutoffs = candidate_cutoffs[-MAX_CUTOFFS_PER_CUSTOMER:]

        for cutoff_idx in chosen_cutoffs:
            before = sales[: cutoff_idx + 1]
            cutoff_date = before[-1][0]
            dates_before = [s[0] for s in before]
            totals_before = [s[1] for s in before]

            intervals = [
                (dates_before[i] - dates_before[i - 1]).days
                for i in range(1, len(dates_before))
                if (dates_before[i] - dates_before[i - 1]).days > 0
            ]
            avg_interval_before = sum(intervals) / len(intervals) if intervals else 0
            if avg_interval_before <= 0:
                continue

            after = sales[cutoff_idx + 1 :]
            if after:
                gap_days = (after[0][0] - cutoff_date).days
                max_offset = max(1, gap_days - 1)  # nunca observar en o después de la compra real siguiente
            else:
                gap_days = (reference_end - cutoff_date).days
                max_offset = max(1, gap_days)

            offset_days = min(max_offset, max(1, int(avg_interval_before * _rng.uniform(0.2, 1.5))))
            eval_date = cutoff_date + timedelta(days=offset_days)

            features = compute_features(dates_before, totals_before, eval_date)
            label = 1 if gap_days > avg_interval_before * CHURN_LABEL_RATIO_THRESHOLD else 0

            rows.append({**features, "label": label, "cutoff_date": eval_date, "customer_id": customer_id})

    return pd.DataFrame(rows)


@dataclass
class ModelResult:
    name: str
    model: object
    scaler: StandardScaler
    metrics: dict[str, float]
    threshold: float = 0.5


def _best_threshold_by_f1(y_true, y_prob) -> float:
    """
    Con clases desbalanceadas (churn suele ser minoritario), un umbral
    fijo de 0.5 rara vez es el mejor punto de corte. Se busca, SOLO sobre
    el set de entrenamiento (nunca sobre test, para no filtrar
    información), el umbral que maximiza F1.
    """
    if len(set(y_true)) < 2:
        return 0.5
    thresholds = np.linspace(0.05, 0.95, 19)
    best_t, best_f1 = 0.5, -1.0
    for t in thresholds:
        y_pred = (y_prob >= t).astype(int)
        f1 = f1_score(y_true, y_pred, zero_division=0)
        if f1 > best_f1:
            best_f1, best_t = f1, t
    return float(best_t)


def _evaluate(y_true, y_pred, y_prob) -> dict[str, float]:
    tn, fp, fn, tp = confusion_matrix(y_true, y_pred, labels=[0, 1]).ravel()
    return {
        "accuracy": round(float(accuracy_score(y_true, y_pred)), 4),
        "precision": round(float(precision_score(y_true, y_pred, zero_division=0)), 4),
        "recall": round(float(recall_score(y_true, y_pred, zero_division=0)), 4),
        "f1": round(float(f1_score(y_true, y_pred, zero_division=0)), 4),
        "roc_auc": round(float(roc_auc_score(y_true, y_prob)), 4) if len(set(y_true)) > 1 else 0.5,
        "pr_auc": round(float(average_precision_score(y_true, y_prob)), 4) if len(set(y_true)) > 1 else 0.0,
        "true_positive": int(tp), "true_negative": int(tn), "false_positive": int(fp), "false_negative": int(fn),
    }


def train_and_compare_models(df: pd.DataFrame) -> list[ModelResult]:
    """
    Entrena Regresión Logística, Random Forest y Gradient Boosting con
    partición TEMPORAL (no aleatoria): los ejemplos con cutoff_date más
    antiguo van a train, los más recientes a test (sección 15) — esto
    simula mejor cómo se usará el modelo en producción, prediciendo el
    futuro a partir del pasado.
    """
    df = df.sort_values("cutoff_date").reset_index(drop=True)
    split_idx = int(len(df) * 0.8)
    train_df, test_df = df.iloc[:split_idx], df.iloc[split_idx:]

    X_train, y_train = train_df[FEATURE_NAMES].values, train_df["label"].values
    X_test, y_test = test_df[FEATURE_NAMES].values, test_df["label"].values

    scaler = StandardScaler().fit(X_train)
    X_train_scaled = scaler.transform(X_train)
    X_test_scaled = scaler.transform(X_test)

    candidates = {
        "logistic_regression": LogisticRegression(max_iter=1000, class_weight="balanced"),
        "random_forest": RandomForestClassifier(n_estimators=200, max_depth=6, class_weight="balanced", random_state=42),
        "gradient_boosting": HistGradientBoostingClassifier(max_depth=4, random_state=42),
    }

    results: list[ModelResult] = []
    for name, base_model in candidates.items():
        # class_weight="balanced" ayuda a los modelos a separar mejor la
        # clase minoritaria (mejor ROC-AUC/recall), pero distorsiona
        # gravemente las probabilidades de salida (todo tiende a 1.0).
        # CalibratedClassifierCV corrige esto: reescala las probabilidades
        # para que reflejen la frecuencia real de churn observada, que es
        # justamente lo que se muestra al usuario como "% de riesgo".
        n_positive_train = int(y_train.sum())
        cv_folds = min(3, max(2, n_positive_train)) if n_positive_train >= 2 else 2
        model = CalibratedClassifierCV(base_model, method="sigmoid", cv=StratifiedKFold(n_splits=cv_folds))
        model.fit(X_train_scaled, y_train)

        train_prob = model.predict_proba(X_train_scaled)[:, 1]
        threshold = _best_threshold_by_f1(y_train, train_prob)

        if len(test_df) > 0:
            y_prob = model.predict_proba(X_test_scaled)[:, 1]
            y_pred = (y_prob >= threshold).astype(int)
            metrics = _evaluate(y_test, y_pred, y_prob)
        else:
            metrics = {"accuracy": 0, "precision": 0, "recall": 0, "f1": 0, "roc_auc": 0.5, "pr_auc": 0}

        results.append(ModelResult(name=name, model=model, scaler=scaler, metrics=metrics, threshold=threshold))

    return results


def select_best_model(results: list[ModelResult]) -> ModelResult:
    """
    Prioriza ROC-AUC y F1 sobre accuracy (sección 15 del brief: para
    churn, accuracy no es suficiente porque las clases suelen estar
    desbalanceadas y detectar al cliente recuperable importa más que
    acertar en los que ya son claramente activos).
    """
    return max(results, key=lambda r: (r.metrics["roc_auc"], r.metrics["f1"]))


def predict_proba_single(result: ModelResult, features: dict) -> float:
    x = np.array([[features[name] for name in FEATURE_NAMES]])
    x_scaled = result.scaler.transform(x)
    return float(result.model.predict_proba(x_scaled)[0, 1])
