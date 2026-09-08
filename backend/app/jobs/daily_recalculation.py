"""
Job de recálculo diario/semanal — alineado a BD real 44 tablas (subcategorias + producto.subcat_id + stock separado).

Tablas principales: empresa (emp_id), cliente (cli_id), producto (prd_id, subcat_id), producto_stock (stock_id, stk_cantidad), cliente_features, predicciones, version_modelo.
Separado en módulos: producto.py (producto, categoria, subcategoria) y stock.py (producto_stock) para control independiente.

Uso:
  python -m app.jobs.daily_recalculation          # diario + semanal
  python -m app.jobs.daily_recalculation --only-daily
  cron: 0 3 * * * cd /app && venv/bin/python -m app.jobs.daily_recalculation
"""
import argparse
import logging
from datetime import datetime, timezone

from sqlalchemy import select

from app.db.session import SessionLocal
from app.models.empresa import Empresa
from app.models.cliente import Cliente
from app.models.producto import Producto
from app.models.stock import ProductoStock

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("daily_job")


def _active_empresas(db):
    # empresa.estado 1 = activa
    return list(db.scalars(select(Empresa).where(Empresa.estado == 1)))


def run_daily_job(reference_date: datetime | None = None) -> dict:
    """
    Diario (sección 25): RFM + cliente_features + cliente_segmento + predicciones.
    Por cada empresa activa, recalcula todos sus clientes (emp_id).
    """
    reference_date = reference_date or datetime.now(timezone.utc)
    db = SessionLocal()
    stats = {"empresas": 0, "clientes": 0, "predicciones": 0, "stock_alertas": 0}
    try:
        empresas = _active_empresas(db)
        stats["empresas"] = len(empresas)
        logger.info("Daily job: %d empresas activas", len(empresas))

        # Lazy import para evitar ciclo y permitir que services aún migren de Customer→Cliente
        try:
            from app.services.rfm import recalculate_customer_aggregates  # espera Cliente
            from app.services.churn import predict_churn_batch
            has_services = True
        except Exception as e:
            logger.warning("Services RFM/churn no disponibles aún (usando shim): %s", e)
            has_services = False

        for empresa in empresas:
            logger.info("Empresa %s (%s) — %s", empresa.emp_nombre_comercial, empresa.emp_id, empresa.emp_ruc)
            clientes = list(db.scalars(select(Cliente).where(Cliente.emp_id == empresa.emp_id, Cliente.estado == 1)))
            stats["clientes"] += len(clientes)
            logger.info("  %d clientes activos", len(clientes))

            # Recalcular RFM y features por cliente
            if has_services:
                for cliente in clientes:
                    try:
                        # recalculate_customer_aggregates ahora espera (db, cliente: Cliente, reference_date)
                        recalculate_customer_aggregates(db, cliente, reference_date=reference_date)
                    except TypeError:
                        # fallback firma antigua (db, customer, business, reference_date)
                        recalculate_customer_aggregates(db, cliente, empresa, reference_date=reference_date)  # type: ignore
                    except Exception as e:
                        logger.warning("    RFM fallo cli_id=%s: %s", cliente.cli_id, e)

                try:
                    preds = predict_churn_batch(db, empresa, clientes, reference_date=reference_date)  # type: ignore
                    stats["predicciones"] += len(preds) if preds else 0
                    logger.info("  %d predicciones generadas", len(preds) if preds else 0)
                except TypeError:
                    # firma nueva: predict_churn_batch(db, emp_id, clientes)
                    preds = predict_churn_batch(db, empresa.emp_id, clientes, reference_date=reference_date)  # type: ignore
                    stats["predicciones"] += len(preds) if preds else 0
                except Exception as e:
                    logger.warning("  churn batch fallo emp_id=%s: %s", empresa.emp_id, e)

            # Alertas stock: stk_cantidad < stk_min
            try:
                bajos = db.scalars(select(ProductoStock).where(ProductoStock.emp_id == empresa.emp_id, ProductoStock.stk_cantidad < ProductoStock.stk_min)).all()
                if bajos:
                    stats["stock_alertas"] += len(bajos)
                    for s in bajos[:5]:
                        prod = db.scalar(select(Producto).where(Producto.emp_id == s.emp_id, Producto.prd_id == s.prd_id))
                        nombre = prod.prd_nombre if prod else s.prd_id
                        logger.warning("  STOCK BAJO emp_id=%s prd_id=%s (%s) stk_cantidad=%s < stk_min=%s", s.emp_id, s.prd_id, nombre, s.stk_cantidad, s.stk_min)
            except Exception as e:
                logger.warning("  stock alertas fallo: %s", e)

        logger.info("Daily job done: %s", stats)
        return stats
    finally:
        db.close()


def run_weekly_job(reference_date: datetime | None = None) -> dict:
    """
    Semanal (sección 25): reentrenar version_modelo si hay datos suficientes.
    Usa cliente_features (44 tablas) y respeta que model no se promueve si es peor (sección 47).
    """
    reference_date = reference_date or datetime.now(timezone.utc)
    db = SessionLocal()
    stats = {"empresas": 0, "modelos": 0}
    try:
        try:
            from app.services.churn import train_churn_model
            has_train = True
        except Exception as e:
            logger.warning("train_churn_model no disponible: %s", e)
            return stats

        empresas = _active_empresas(db)
        stats["empresas"] = len(empresas)
        for empresa in empresas:
            try:
                # train_churn_model espera (db, emp_id, reference_date) en nueva API
                try:
                    mv = train_churn_model(db, empresa.emp_id, reference_date=reference_date)
                except TypeError:
                    mv = train_churn_model(db, empresa.emp_id)  # type: ignore
                stats["modelos"] += 1
                # version_modelo columnas exactas: vrm_id, vrm_name, vrm_version, estado
                logger.info("Empresa %s: modelo vrm_id=%s vrm_name=%s vrm_version=%s estado=%s", empresa.emp_nombre_comercial, getattr(mv, 'vrm_id', '?'), getattr(mv, 'vrm_name', '?'), getattr(mv, 'vrm_version', '?'), getattr(mv, 'estado', '?'))
            except Exception as e:
                logger.warning("  train fallo emp_id=%s: %s", empresa.emp_id, e)
        logger.info("Weekly job done: %s", stats)
        return stats
    finally:
        db.close()


def main():
    parser = argparse.ArgumentParser(description="Jobs diarios/semanales BD 44 tablas")
    parser.add_argument("--only-daily", action="store_true", help="Solo diario (sin semanal)")
    parser.add_argument("--only-weekly", action="store_true", help="Solo semanal")
    args = parser.parse_args()

    if args.only_weekly:
        run_weekly_job()
    elif args.only_daily:
        run_daily_job()
    else:
        run_daily_job()
        run_weekly_job()


if __name__ == "__main__":
    main()
