"""
Job de recálculo diario (sección 25 del brief técnico).

Decisión: en lugar de Celery + Redis completo, el MVP usa un script
standalone invocable por cron (o manualmente), tal como el propio brief
permite explícitamente ("una alternativa sencilla si consideras que
Celery es excesivo para MVP"). Esto evita la complejidad operativa de un
broker de colas para un negocio pequeño de uso diario, sin sacrificar el
requisito central: los procesos pesados NUNCA corren dentro del ciclo de
una petición HTTP.

La arquitectura permite migrar esto a un worker de Celery más adelante
sin cambiar la lógica de negocio: bastaría con envolver `run_daily_job`
en una tarea de Celery programada.

Uso:
    python -m app.jobs.daily_recalculation
    # o vía cron, por ejemplo todos los días a las 3 AM:
    # 0 3 * * *  cd /app && venv/bin/python -m app.jobs.daily_recalculation
"""
import logging
from datetime import datetime, timezone

from sqlalchemy import select

from app.db.session import SessionLocal
from app.models.empresa import Empresa
from app.models.cliente import Cliente
from app.services.churn import predict_churn_batch, train_churn_model
from app.services.rfm import recalculate_customer_aggregates

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("daily_job")


def run_daily_job(reference_date: datetime | None = None) -> None:
    """
    Tareas diarias (sección 25): recalcular RFM/segmentos y detectar
    clientes en riesgo/perdidos para todos los negocios activos.
    """
    reference_date = reference_date or datetime.now(timezone.utc)
    db = SessionLocal()
    try:
        businesses = list(db.scalars(select(Business).where(Business.is_active == True)))  # noqa: E712
        for business in businesses:
            logger.info("Recalculando negocio %s (%s)", business.name, business.id)
            customers = list(db.scalars(select(Customer).where(Customer.business_id == business.id)))

            for customer in customers:
                recalculate_customer_aggregates(db, customer, reference_date=reference_date)

            predictions = predict_churn_batch(db, business, customers, reference_date=reference_date)
            logger.info("  %d clientes recalculados, %d predicciones generadas", len(customers), len(predictions))
    finally:
        db.close()


def run_weekly_job(reference_date: datetime | None = None) -> None:
    """
    Tareas semanales (sección 25): reentrenar el modelo de churn si hay
    suficiente información nueva. train_churn_model ya decide
    internamente si hay datos suficientes y si el nuevo modelo debe
    promoverse (sección 47: nunca reemplazar por uno peor).
    """
    reference_date = reference_date or datetime.now(timezone.utc)
    db = SessionLocal()
    try:
        businesses = list(db.scalars(select(Business).where(Business.is_active == True)))  # noqa: E712
        for business in businesses:
            model_version = train_churn_model(db, business.id, reference_date=reference_date)
            logger.info(
                "Negocio %s: modelo %s v%s (status=%s)",
                business.name, model_version.model_name, model_version.version, model_version.status.value,
            )
    finally:
        db.close()


if __name__ == "__main__":
    run_daily_job()
    run_weekly_job()
