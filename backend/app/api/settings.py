from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.deps import require_admin
from app.db.session import get_db
from app.models.empresa import Usuario
from app.models.catalogs import CanalMarketing
from app.schemas.misc import BusinessSettingsOut, BusinessSettingsUpdate

router = APIRouter(prefix="/settings", tags=["settings"])


def _to_out(business) -> BusinessSettingsOut:
    return BusinessSettingsOut(
        business_name=business.name, currency=business.currency, timezone=business.timezone,
        analysis_window_days=business.analysis_window_days,
        churn_threshold_medium=business.churn_threshold_medium, churn_threshold_high=business.churn_threshold_high,
        churn_threshold_critical=business.churn_threshold_critical, campaign_cooldown_days=business.campaign_cooldown_days,
        available_channels=list(Channel), language=business.language,
    )


@router.get("", response_model=BusinessSettingsOut)
def get_settings(db: Session = Depends(get_db), user: User = Depends(require_admin)):
    return _to_out(user.business)


@router.put("", response_model=BusinessSettingsOut)
def update_settings(payload: BusinessSettingsUpdate, db: Session = Depends(get_db), user: User = Depends(require_admin)):
    business = user.business
    patch = payload.model_dump(exclude_unset=True)
    if "business_name" in patch:
        business.name = patch.pop("business_name")
    for key, value in patch.items():
        setattr(business, key, value)
    db.commit()
    db.refresh(business)
    return _to_out(business)
