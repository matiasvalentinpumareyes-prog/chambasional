from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.api.pagination import PageParams
from app.core.deps import get_current_user
from app.core.errors import NotFoundError
from app.db.session import get_db
from app.models.empresa import Usuario
from app.schemas.campanas import CampaignDBOut, CampaignStatusUpdate, SimulationResult
from app.schemas.common import Paginated

router = APIRouter(prefix="/campaigns", tags=["campaigns"])


@router.get("", response_model=Paginated[CampaignDBOut])
def list_campaigns(page_params: PageParams = Depends(), db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    # Stub temporal — campañas aún no cableadas a modelo real (usa campaigns DB)
    # Retorna vacío para no bloquear /api/auth/login
    return Paginated(items=[], page=page_params.page, page_size=page_params.page_size, total=0)


@router.get("/{campaign_id}", response_model=CampaignDBOut)
def get_campaign(campaign_id: str, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    raise NotFoundError("CAMPAIGN_NOT_FOUND", "Campaña no encontrada (stub).")


@router.post("", response_model=CampaignDBOut, status_code=201)
def create_campaign(payload: dict, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    raise NotFoundError("CAMPAIGN_NOT_FOUND", "Creación de campañas en stub — usa flujo real de campanas.")


@router.patch("/{campaign_id}/status", response_model=CampaignDBOut)
def update_campaign_status(campaign_id: str, payload: CampaignStatusUpdate, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    raise NotFoundError("CAMPAIGN_NOT_FOUND", "Campaña no encontrada (stub).")


@router.post("/{campaign_id}/simulate", response_model=SimulationResult)
def simulate(campaign_id: str, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    return SimulationResult(targeted=0, estimated_conversion_rate=0, estimated_converted=0, estimated_recovered_revenue=0, estimated_cost=0, estimated_roi=None, is_simulation=True)
