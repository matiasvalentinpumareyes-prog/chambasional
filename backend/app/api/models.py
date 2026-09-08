from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.deps import require_admin
from app.db.session import get_db
from app.models.ia import VersionModelo as ModelVersion
from app.models.empresa import Usuario
from app.schemas.misc import ModelMetricOut, ModelVersionOut
from app.services.churn import train_churn_model

router = APIRouter(prefix="/models", tags=["models"])


def _to_out(mv: ModelVersion) -> ModelVersionOut:
    metrics_dict = {m.name: m.value for m in mv.metrics}
    return ModelVersionOut(
        id=mv.id, model_name=mv.model_name, version=mv.version, training_date=mv.training_date,
        dataset_version=mv.dataset_version, features=mv.features, status=mv.status,
        metrics=ModelMetricOut(
            accuracy=metrics_dict.get("accuracy", 0), precision=metrics_dict.get("precision", 0),
            recall=metrics_dict.get("recall", 0), f1=metrics_dict.get("f1", 0),
            roc_auc=metrics_dict.get("roc_auc", 0), pr_auc=metrics_dict.get("pr_auc", 0),
        ),
    )


@router.get("", response_model=list[ModelVersionOut])
def list_models(db: Session = Depends(get_db), user: User = Depends(require_admin)):
    versions = list(
        db.scalars(select(ModelVersion).where(ModelVersion.business_id == user.business_id).order_by(ModelVersion.training_date.desc()))
    )
    return [_to_out(v) for v in versions]


@router.post("/churn/train", response_model=ModelVersionOut)
def trigger_training(db: Session = Depends(get_db), user: User = Depends(require_admin)):
    """
    Dispara manualmente el entrenamiento del modelo de churn (sección 25:
    en producción esto también corre como job periódico, no solo bajo
    demanda). Solo el administrador puede disparar reentrenamientos.
    """
    model_version = train_churn_model(db, user.business_id)
    return _to_out(model_version)
