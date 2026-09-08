"""
Adapters de canales de notificación (sección 23 del brief).

Se define una interfaz común para que el resto del sistema (campañas,
estrategias) nunca dependa de un proveedor concreto. Mientras no existan
credenciales reales configuradas (EMAIL_API_KEY, WHATSAPP_API_KEY), se usa
MockProvider, que registra la comunicación en la tabla `communications`
pero no realiza ningún envío externo real — esto es exactamente lo que
pide la sección 91 ("el MVP debe poder funcionar localmente sin
credenciales") y la regla 79 (nunca fingir que algo se envió si no fue
así: MockProvider deja explícito `provider="mock"` en cada registro).
"""
from abc import ABC, abstractmethod
from datetime import datetime, timezone

from sqlalchemy.orm import Session

from app.core.config import settings
from app.models.campanas import Comunicacion
from app.models.cliente import Cliente


class NotificationProvider(ABC):
    channel: Channel

    @abstractmethod
    def send(self, customer: Customer, message: str) -> bool:
        """Devuelve True si el envío fue exitoso."""
        raise NotImplementedError


class MockProvider(NotificationProvider):
    """
    Proveedor simulado: no llama a ningún servicio externo. Se usa
    automáticamente cuando no hay credenciales configuradas para el canal.
    Deja constancia explícita de que es una simulación, nunca se presenta
    como un envío real (regla 79 del brief).
    """

    def __init__(self, channel: Channel):
        self.channel = channel

    def send(self, customer: Customer, message: str) -> bool:
        return True  # simulación: siempre "exitosa", pero no hay efecto externo real


class EmailProvider(NotificationProvider):
    """
    Adapter para un proveedor real de email (ej. SendGrid, Amazon SES).
    No implementado en este MVP: requiere EMAIL_API_KEY configurada.
    Lanzar NotImplementedError es preferible a fingir un envío exitoso.
    """

    channel = Channel.email

    def send(self, customer: Customer, message: str) -> bool:
        raise NotImplementedError(
            "EmailProvider real no está implementado. Configura EMAIL_API_KEY "
            "y reemplaza este método con la integración real, o usa MockProvider."
        )


class WhatsAppProvider(NotificationProvider):
    """Adapter para WhatsApp Business API. No implementado en este MVP (requiere WHATSAPP_API_KEY)."""

    channel = Channel.whatsapp

    def send(self, customer: Customer, message: str) -> bool:
        raise NotImplementedError(
            "WhatsAppProvider real no está implementado. Configura WHATSAPP_API_KEY, "
            "o usa MockProvider."
        )


class SMSProvider(NotificationProvider):
    """Adapter para un proveedor SMS (ej. Twilio). No implementado en este MVP."""

    channel = Channel.sms

    def send(self, customer: Customer, message: str) -> bool:
        raise NotImplementedError("SMSProvider real no está implementado. Usa MockProvider mientras tanto.")


def get_provider(channel: Channel) -> NotificationProvider:
    """
    Factory: decide qué proveedor usar según si hay credenciales
    configuradas. Con la configuración por defecto del .env.example
    (todas las claves vacías), siempre devuelve MockProvider.
    """
    has_real_credentials = {
        Channel.email: bool(settings.EMAIL_API_KEY),
        Channel.whatsapp: bool(settings.WHATSAPP_API_KEY),
        Channel.sms: bool(settings.SMS_API_KEY),
    }
    if channel == Channel.internal or not has_real_credentials.get(channel, False):
        return MockProvider(channel)

    return {
        Channel.email: EmailProvider(),
        Channel.whatsapp: WhatsAppProvider(),
        Channel.sms: SMSProvider(),
    }[channel]


def send_and_record(db: Session, business_id: str, customer: Customer, channel: Channel, message: str, campaign_id: str | None = None) -> Communication:
    """
    Envía (o simula) una comunicación y SIEMPRE la registra en
    `communications`, que es lo que alimenta el cálculo del cooldown
    (sección 30) — con MockProvider o con un proveedor real, el
    cooldown funciona igual porque depende del registro, no del proveedor.
    """
    provider = get_provider(channel)
    try:
        success = provider.send(customer, message)
        provider_name = "mock" if isinstance(provider, MockProvider) else channel.value
    except NotImplementedError:
        success = False
        provider_name = "not_implemented"

    communication = Communication(
        business_id=business_id, customer_id=customer.id, campaign_id=campaign_id,
        channel=channel, sent_at=datetime.now(timezone.utc), provider=provider_name, success=success,
    )
    db.add(communication)
    db.commit()
    db.refresh(communication)
    return communication
