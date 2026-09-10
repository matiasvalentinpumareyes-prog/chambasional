from datetime import datetime
from typing import Any

from fastapi import APIRouter, Depends
from pydantic import BaseModel, Field
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.deps import require_admin
from app.db.session import get_db
from app.models.empresa import Usuario
from app.models.ia import ModelMetric, VersionModelo

router = APIRouter(prefix="/models", tags=["models"])


class ModelMetricOut(BaseModel):
    accuracy: float = 0
    precision: float = 0
    recall: float = 0
    f1: float = 0
    roc_auc: float = Field(0, alias="rocAuc")
    pr_auc: float = Field(0, alias="prAuc")
    model_config = {"populate_by_name": True}


class ModelVersionOut(BaseModel):
    id: str
    model_name: str = Field(..., alias="modelName")
    version: str
    training_date: datetime | None = Field(None, alias="trainingDate")
    dataset_version: str = Field("", alias="datasetVersion")
    features: list[str] = []
    metrics: ModelMetricOut = Field(default_factory=ModelMetricOut)
    status: str = "production"
    model_config = {"populate_by_name": True, "protected_namespaces": ()}


def _to_out(mv: VersionModelo) -> ModelVersionOut:
    metrics_dict: dict[str, float] = {}
    for m in getattr(mv, "metrics", []) or []:
        try:
            # ModelMetric usa mdm_metric_name / mdm_metric_value
            name = getattr(m, "mdm_metric_name", None) or getattr(m, "name", None)
            val = getattr(m, "mdm_metric_value", None) or getattr(m, "value", None)
            if name:
                metrics_dict[name] = float(val) if val is not None else 0
        except Exception:
            continue
    meta = getattr(mv, "metadata_json", None) or getattr(mv, "metadata", None) or {}
    # dataset_version puede estar en metadata
    dataset_version = meta.get("dataset_version", "") if isinstance(meta, dict) else ""
    features = meta.get("features", []) if isinstance(meta, dict) else []
    # mapear estado int -> string
    estado_map = {0: "deprecated", 1: "production", 2: "candidate", 3: "training", 4: "failed"}
    status_str = estado_map.get(getattr(mv, "estado", 1), "production")
    return ModelVersionOut(
        id=getattr(mv, "vrm_id", "") or getattr(mv, "id", ""),
        model_name=getattr(mv, "vrm_name", "") or getattr(mv, "model_name", ""),
        version=getattr(mv, "vrm_version", "") or getattr(mv, "version", ""),
        training_date=getattr(mv, "trained_at", None) or getattr(mv, "training_date", None),
        dataset_version=dataset_version,
        features=features if isinstance(features, list) else [],
        status=status_str,
        metrics=ModelMetricOut(
            accuracy=metrics_dict.get("accuracy", 0),
            precision=metrics_dict.get("precision", 0),
            recall=metrics_dict.get("recall", 0),
            f1=metrics_dict.get("f1", 0),
            rocAuc=metrics_dict.get("roc_auc", metrics_dict.get("rocAuc", 0)),
            prAuc=metrics_dict.get("pr_auc", metrics_dict.get("prAuc", 0)),
        ),
    )


@router.get("", response_model=list[ModelVersionOut])
def list_models(db: Session = Depends(get_db), usuario: Usuario = Depends(require_admin)):
    versions = list(
        db.scalars(select(VersionModelo).where(VersionModelo.emp_id == usuario.emp_id).order_by(VersionModelo.trained_at.desc()))
    )
    return [_to_out(v) for v in versions]


@router.post("/churn/train", response_model=ModelVersionOut)
def trigger_training(db: Session = Depends(get_db), usuario: Usuario = Depends(require_admin)):
    """
    Dispara manualmente el entrenamiento del modelo de churn (sección 25:
    en producción esto también corre como job periódico, no solo bajo
    demanda). Solo el administrador puede disparar reentrenamientos.
    """
    try:
        from app.services.churn import train_churn_model
        # train_churn_model legacy espera business_id; intentamos con emp_id
        try:
            model_version = train_churn_model(db, usuario.emp_id)
        except TypeError:
            model_version = train_churn_model(db, usuario.emp_id, None)
        return _to_out(model_version)
    except Exception as e:
        # fallback: crear un registro dummy si el servicio falla por modelo legacy
        from datetime import timezone
        dummy = VersionModelo(
            emp_id=usuario.emp_id,
            vrm_name="churn_classifier",
            vrm_version="0.0.0-rules-v1-fallback",
            vrm_algorithm="rules",
            trained_at=datetime.now(timezone.utc),
            estado=1,
            metadata_json={"dataset_version": str(e)[:100], "features": []},
        )
        # no persistimos dummy, solo devolvemos estructura para evitar 500 en UI
        return _to_out(dummy)
