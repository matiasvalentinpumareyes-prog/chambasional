from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.api.pagination import PageParams
from app.core.audit import log_action
from app.core.deps import get_current_user
from app.core.errors import NotFoundError
from app.db.session import get_db
from app.models.business import User
from app.models.campaign import Campaign
from app.schemas.campaign import CampaignCreate, CampaignOut, CampaignStatusUpdate, SimulationResult
from app.schemas.common import Paginated
from app.services.campaigns import activate_campaign, compute_campaign_metrics, create_campaign_with_recipients, simulate_campaign

router = APIRouter(prefix="/campaigns", tags=["campaigns"])


def _to_out(db: Session, campaign: Campaign) -> CampaignOut:
    metrics = compute_campaign_metrics(db, campaign)
    recipient_ids = [r.customer_id for r in campaign.recipients]
    return CampaignOut(
        id=campaign.id, business_id=campaign.business_id, name=campaign.name, description=campaign.description,
        segment=campaign.segment, product_id=campaign.product_id, offer=campaign.offer, channel=campaign.channel,
        start_date=campaign.start_date, end_date=campaign.end_date, message=campaign.message, status=campaign.status,
        metrics=metrics, target_customer_ids=recipient_ids,
    )


@router.get("", response_model=Paginated[CampaignOut])
def list_campaigns(page_params: PageParams = Depends(), db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    from sqlalchemy import select
    stmt = select(Campaign).where(Campaign.business_id == user.business_id)
    total = len(list(db.scalars(stmt)))
    stmt = stmt.order_by(Campaign.created_at.desc()).offset((page_params.page - 1) * page_params.page_size).limit(page_params.page_size)
    items = list(db.scalars(stmt))
    return Paginated(items=[_to_out(db, c) for c in items], page=page_params.page, page_size=page_params.page_size, total=total)


@router.get("/{campaign_id}", response_model=CampaignOut)
def get_campaign(campaign_id: str, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    campaign = db.get(Campaign, campaign_id)
    if not campaign or campaign.business_id != user.business_id:
        raise NotFoundError("CAMPAIGN_NOT_FOUND", "Campaña no encontrada.")
    return _to_out(db, campaign)


@router.post("", response_model=CampaignOut, status_code=201)
def create_campaign(payload: CampaignCreate, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    campaign = create_campaign_with_recipients(db, user.business_id, payload.model_dump())
    log_action(db, business_id=user.business_id, user_id=user.id, action="CREATED_CAMPAIGN", entity="campaign", entity_id=campaign.id)
    return _to_out(db, campaign)


@router.patch("/{campaign_id}/status", response_model=CampaignOut)
def update_campaign_status(campaign_id: str, payload: CampaignStatusUpdate, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    campaign = db.get(Campaign, campaign_id)
    if not campaign or campaign.business_id != user.business_id:
        raise NotFoundError("CAMPAIGN_NOT_FOUND", "Campaña no encontrada.")
    campaign.status = payload.status
    db.commit()
    db.refresh(campaign)

    if payload.status.value == "active":
        campaign = activate_campaign(db, campaign)

    log_action(db, business_id=user.business_id, user_id=user.id, action="UPDATED_CAMPAIGN_STATUS", entity="campaign", entity_id=campaign.id, metadata={"status": payload.status.value})
    return _to_out(db, campaign)


@router.post("/{campaign_id}/simulate", response_model=SimulationResult)
def simulate(campaign_id: str, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    campaign = db.get(Campaign, campaign_id)
    if not campaign or campaign.business_id != user.business_id:
        raise NotFoundError("CAMPAIGN_NOT_FOUND", "Campaña no encontrada.")
    return simulate_campaign(db, campaign)
