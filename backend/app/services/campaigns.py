import random
from datetime import datetime, timezone

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.models.campanas import Campaign, CampaignRecipient, CampaignStatus, RecipientStatus
from app.models.cliente import Cliente
from app.services.notifications import send_and_record


def create_campaign_with_recipients(db: Session, business_id: str, data: dict) -> Campaign:
    """Crea una campaña en estado 'draft' y calcula sus destinatarios respetando el consentimiento (sección 31)."""
    customers = list(
        db.scalars(select(Customer).where(Customer.business_id == business_id, Customer.id.in_(data["target_customer_ids"])))
    )

    campaign = Campaign(
        business_id=business_id,
        name=data["name"],
        description=data.get("description", ""),
        segment=data.get("segment"),
        product_id=data.get("product_id"),
        offer=data["offer"],
        channel=data["channel"],
        start_date=data["start_date"],
        end_date=data.get("end_date"),
        message=data["message"],
        status=CampaignStatus.draft,
    )
    db.add(campaign)
    db.flush()

    recipients = []
    for customer in customers:
        status = RecipientStatus.pending if customer.consent else RecipientStatus.excluded_no_consent
        recipients.append(CampaignRecipient(campaign_id=campaign.id, customer_id=customer.id, status=status))
    db.add_all(recipients)
    db.commit()
    db.refresh(campaign)
    return campaign


def compute_campaign_metrics(db: Session, campaign: Campaign) -> dict:
    """Control previo al envío (sección 81): cuántos clientes objetivo, con/sin consentimiento, costo e ingreso potencial."""
    recipients = list(db.scalars(select(CampaignRecipient).where(CampaignRecipient.campaign_id == campaign.id)))
    targeted = len(recipients)
    with_consent = sum(1 for r in recipients if r.status != RecipientStatus.excluded_no_consent)
    without_consent = targeted - with_consent

    sent = sum(1 for r in recipients if r.status in (RecipientStatus.sent, RecipientStatus.opened, RecipientStatus.responded, RecipientStatus.converted))
    opened = sum(1 for r in recipients if r.status in (RecipientStatus.opened, RecipientStatus.responded, RecipientStatus.converted))
    responded = sum(1 for r in recipients if r.status in (RecipientStatus.responded, RecipientStatus.converted))
    converted = sum(1 for r in recipients if r.status == RecipientStatus.converted)
    recovered_revenue = round(sum(float(r.recovered_revenue) for r in recipients if r.recovered_revenue), 2)

    estimated_cost = round(targeted * 0.5, 2)
    potential_revenue = round(targeted * 30, 2)
    roi = round((recovered_revenue - estimated_cost) / estimated_cost, 2) if estimated_cost > 0 and sent > 0 else None

    return {
        "targeted": targeted,
        "with_consent": with_consent,
        "without_consent": without_consent,
        "estimated_cost": estimated_cost,
        "potential_revenue": potential_revenue,
        "sent": sent,
        "opened": opened,
        "responded": responded,
        "converted": converted,
        "recovered_customers": converted,
        "recovered_revenue": recovered_revenue,
        "roi": roi,
    }


def activate_campaign(db: Session, campaign: Campaign) -> Campaign:
    """
    Activa una campaña: envía (o simula, según el proveedor disponible)
    el mensaje a cada destinatario CON consentimiento, respetando el
    cooldown de comunicaciones (sección 30), y actualiza el estado de
    cada destinatario. Se llama al pasar una campaña a estado 'active'.
    """
    recipients = list(
        db.scalars(select(CampaignRecipient).where(CampaignRecipient.campaign_id == campaign.id))
    )
    for recipient in recipients:
        if recipient.status != RecipientStatus.pending:
            continue
        customer = db.get(Customer, recipient.customer_id)
        if not customer:
            continue
        message = campaign.message.replace("{{customer_name}}", customer.first_name)
        communication = send_and_record(
            db, business_id=campaign.business_id, customer=customer, channel=campaign.channel,
            message=message, campaign_id=campaign.id,
        )
        recipient.status = RecipientStatus.sent if communication.success else RecipientStatus.pending
        db.add(recipient)
    db.commit()
    db.refresh(campaign)
    return campaign


def simulate_campaign(db: Session, campaign: Campaign) -> dict:
    """
    Modo simulación (sección 82): estima el resultado SIN enviar ninguna
    comunicación real ni modificar el estado de los destinatarios. Se usa
    para pruebas y demostraciones; el resultado se marca explícitamente
    como is_simulation=True para que nunca se confunda con datos reales.
    """
    recipients = list(db.scalars(select(CampaignRecipient).where(CampaignRecipient.campaign_id == campaign.id)))
    targeted = max(len(recipients), 1)

    conversion_rate = round(random.uniform(0.12, 0.18), 3)
    estimated_converted = round(targeted * conversion_rate)
    estimated_revenue = estimated_converted * 32
    estimated_cost = round(targeted * 0.5, 2)
    estimated_roi = round((estimated_revenue - estimated_cost) / estimated_cost, 2) if estimated_cost > 0 else None

    return {
        "targeted": targeted,
        "estimated_conversion_rate": conversion_rate,
        "estimated_converted": estimated_converted,
        "estimated_recovered_revenue": estimated_revenue,
        "estimated_cost": estimated_cost,
        "estimated_roi": estimated_roi,
        "is_simulation": True,
    }
