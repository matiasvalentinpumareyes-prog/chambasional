from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.deps import get_current_user
from app.db.session import get_db
from app.models.business import User
from app.schemas.dashboard import DashboardMetricsOut, DashboardSeriesOut
from app.services.dashboard import compute_dashboard_metrics, compute_dashboard_series

router = APIRouter(prefix="/dashboard", tags=["dashboard"])


@router.get("", response_model=DashboardMetricsOut)
def get_dashboard(db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    return compute_dashboard_metrics(db, user.business)


@router.get("/series", response_model=DashboardSeriesOut)
def get_dashboard_series(db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    return compute_dashboard_series(db, user.business)
