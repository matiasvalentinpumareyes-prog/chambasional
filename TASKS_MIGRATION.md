# TASKS_MIGRATION — Migración a BD real db_regresape (43 tablas)

> **Regla de oro:** La BD es la fuente de verdad (`backend/db/database_postgres.sql:1`). Todo nombre de variable/columna/tabla respeta exactamente el idioma de la BD (español o inglés según esté definido). Se elimina por completo el ORM legado de 19 tablas (`businesses`/`customers`/`products` con `business_id`).

## Fases y entregables

### Fase 0 — Inventario y guardado legacy (commit 1)
- [ ] Guardar `backend/app/models/` legado en `backend/app/models_legacy/` (rollback).
- [ ] Crear `backend/MIGRATION_MAP.md` con mapeo `businesses.id→empresa.emp_id`, `customers.id→cliente.cli_id`, etc.
- [ ] Verificar `git status` limpio antes de borrar ORM.
- **Criterio done:** Tag `legacy-orm-backup` y commit `chore: guardar ORM legado`.

### Fase 1 — Models a 43 tablas (commit 2) — NOMBRES EXACTOS BD
- [ ] Borrar `business.py`, `customer.py`, `product.py`, `sale.py`, `campaign.py`, `prediction.py`, `audit.py` legados.
- [ ] Crear `base.py` (`Base`, `TimestampMixin`, `gen_uuid`).
- [ ] Crear `catalogs.py`: `Departamento(dep_id)`, `Provincia(prv_id)`, `Distrito(dis_id)`, `Documento(doc_id)`, `MetodoPago(mtp_id)`, `CanalMarketing(can_id)`, `Segmento(seg_id)`, `Rol(rol_id)`, `AuditoriaEntidad(ade_id)`, `AuditoriaAccion(ada_id)`, `PatronCompra(pat_id)`.
- [ ] Crear `empresa.py`: `Empresa(emp_id, emp_ruc, emp_razon_social, emp_nombre_comercial, emp_logo BYTEA, dep_id/prv_id/dis_id)`, `UsuarioPersonal(usp_id, emp_id, usp_dni, usp_nombres)`, `Usuario(usu_id, emp_id, usu_usuario, usu_password_hash, usu_email, rol_id, usp_id)`.
- [ ] Crear `comercio.py`: `Categoria(cat_id, emp_id, cat_nombre)`, `ProductoMarca(prd_marca_id)`, `Producto(prd_id, prd_sku, prd_codbarra, prd_nombre)`, `ProductoPrecio(prd_precios_id, prd_precios, prd_precios_costo, fecha_inicio/fin)`, `ProductoStock(stock_id, stk_cantidad, stk_min, stk_max)` con CheckConstraint.
- [ ] Crear `cliente.py`: `Cliente(cli_id, emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_email, cli_celular, cli_birthday, cli_genero)`, `ClienteConsentimiento(cco_id, can_id, consentimiento)`, `ClienteSegmento`, `ClienteSegmentoHistorial`, `ClienteFeatures(cft_id, fecha_snapshot, recencia_dias, frecuencia_30d/90d/365d, ticket_promedio, score_churn, pat_id, ratio_riesgo_actual, metadata JSON)`, `ClienteEstacionalidad(ces_id, mes 1..12 CHECK)`, `TipoDireccionExplicacion(tde_id, activo)`, `PrediccionExplicacion(pex_id, impacto)`.
- [ ] Crear `ventas.py`: `Venta(venta_id, emp_id, cli_id, ven_descuento, ven_total, mtp_id, cupon_id, venta_origen)`, `VentaItem(ven_item_id, cantidad Numeric(12,3), precio_unitario, descuento, subtotal, costo_unitario)`.
- [ ] Crear `ia.py`: `VersionModelo(vrm_id, vrm_name, vrm_version, vrm_algorithm, trained_at)`, `ModelMetric(mdm_id, mdm_metric_name, mdm_metric_value Numeric(12,6))`, `Prediccion(pdc_id, pdc_tipo_prediccion, pdc_prob_abandono, pdc_valor, pdc_fecha, expires_at)`.
- [ ] Crear `marketing.py`: `Estrategia(est_id, est_nombre, est_objetivo, configuracion JSON)`, `Rule(rle_id, rle_nombre, rle_rule_type, rle_condiciones JSON NOT NULL, rle_acciones JSON)`, `Cupon(cup_id, cup_codigo, cup_tipo, cup_valor, cup_usos_actuales, fecha_inicio/fin)`, `Recomendacion(rec_id, rec_titulo, recommended_offer)`, `CuponCanje(ccn_id, importe_descuento)`.
- [ ] Crear `campanas.py`: `Campaign(cpg_id, can_id, cpg_name, cpg_budget, estado DEFAULT 3)`, `CampaignRecipient(cpg_recipient_id, estado DEFAULT 2, sent_at/delivered_at/opened_at/clicked_at/converted_at, conversion_value)`, `Comunicacion(com_id, com_asunto, com_contenido, provider_message_id, estado DEFAULT 2)`.
- [ ] Crear `auditoria.py`: `AuditoriaLog(adl_id, adl_tabla, adl_registro_id, adl_valor_anterior/nuevo JSON)`, `Import(imp_id, file_name, file_type, total_rows/successful_rows/failed_rows)`, `ImportError(imp_error_id, imp_error_row_number, error_message, raw_data JSON)`.
- [ ] Actualizar `models/__init__.py` exports.
- **Done:** `python -c "from app.models import *"` sin import de `businesses`.

### Fase 2 — DB/Session y Alembic (commit 3)
- [ ] Verificar `app/db/session.py:12 Base` apunta a `models/base.py`.
- [ ] Reemplazar `alembic/versions/31d35468f06c_initial_schema.py:19` por `0001_bd_real_43_tablas.py` autogenerada (incluye `uuid-ossp`, `set_updated_at()` triggers, índices `idx_*`, seeds `canales_marketing:915`).
- [ ] `alembic upgrade head` en `db_regresape_test`.
- **Done:** `psql \dt` muestra 43 tablas con nombres exactos.

### Fase 3 — Schemas 1:1 BD (commit 4)
- [ ] Borrar schemas legados contaminados: `customer.py`, `product.py`, `sale.py`, `campaign.py`, `auth.py` viejo, `commerce.py`/`predicciones.py`/`estrategias.py`/`cupones.py`/`ventas.py`/`campanas.py` duplicados mal alineados.
- [ ] Crear definitivos con nombres exactos: `catalogs.py`, `empresa.py`, `cliente.py`, `comercio.py` (con stock), `ventas.py`, `features.py`, `ia.py`, `marketing.py`, `campanas.py`, `cupones.py`, `auditoria.py`, `common.py`/`auth.py` rehacer con `usu_*`/`emp_*`.
- [ ] Cada schema con `Base/Create/Update/Out` y `Field(..., max_length=...)` idéntico a la BD.
- **Done:** `grep -r business_id app/schemas` == 0; `grep -r emp_id` >30.

### Fase 4 — Repositories y core/deps (commit 5)
- [ ] Reescribir `customer_repo.py→cliente_repo.py` con `emp_id` obligatorio (`where Cliente.emp_id==emp_id`), búsqueda por `cli_nombre_razon_social`; `product_repo.py→producto_repo.py` con `prd_sku unique(emp_id, prd_sku)`; crear `stock_repo.py` (`get_by_producto(emp_id, prd_id)`, `ajustar_stock(delta)`, `alertar_min`); `venta_repo.py`; `core/deps.py` → `get_current_usuario` con `usu_id/emp_id` JWT.
- **Done:** Ningún repo filtra por `business_id`.

### Fase 5 — API routers y services (commit 6) — STOCK COMPLETO
- [ ] `api/auth.py` → registra `empresa`+`usuario_personal`+`usuario` con `rol_id`.
- [ ] `api/productos.py` + `api/stock.py` nuevo: `GET /productos/{prd_id}/stock`, `PUT /productos/{prd_id}/stock`, `POST /stock/movimiento {emp_id, prd_id, delta, motivo}`, validación `stk_min/max`, auditoría.
- [ ] `api/ventas.py` → transacción `ventas`+`venta_items` y decremento `producto_stock.stk_cantidad`; `api/clientes.py`; `api/campanas.py`; `services/rfm.py`/`churn.py` leyendo `cliente_features`.
- **Done:** `POST /ventas` descuenta stock; `GET /stock` responde `stk_cantidad/stk_min/stk_max`.

### Fase 6 — Verificación (commit 7)
- [ ] `alembic upgrade head` + `psql -c "\dt" -c "SELECT count(*) FROM producto_stock"`.
- [ ] `pytest` con fixtures `emp_id/cli_id/prd_id`.
- [ ] `curl` register→producto→stock→venta→cliente.
- **Done:** Tests 36/36 y flujo completo sin referencias ORM.

## Reglas de nombres
- Español si la BD está en español (`emp_ruc`, `cli_nombre_razon_social`, `prd_sku`, `ven_total`, `cpg_name`, `com_contenido`), inglés si la BD está en inglés (`metadata`, `provider_message_id`).
- No traducir: `business_id`→`emp_id`, `sku`→`prd_sku`, `stock`→`stk_cantidad`.

## Commits
Un commit por fase completada, mensaje `feat: fase X - ...`, sin `git push`.

## Progreso
- Fase 0: completada (2026-09-18) — commit 2005912
- Fase 1: completada (2026-09-18) — commit 5a3febf — 43 tablas verificadas
- Fase 2: completada (2026-09-18) — commit 566bfa0 — Base unificada, alembic 0001_bd_real_43_tablas
- Fase 3: completada (2026-09-18) — commit ebb33ba — schemas 1:1 BD sin ORM (stock con stk_cantidad/min/max)
- Fase 4: completada (2026-09-18) — commit e11887b — repos emp_id + stock_repo + deps usu_id
- Fase 5: completada (2026-09-18) — commit 4025219 — apis auth/productos/stock/ventas/clientes con nombres exactos BD (stock completo)
- Fase 6: completada (2026-09-18) — verificación 43 tablas, 0 business_id en schemas, 126 emp_id, stock stk_cantidad/min/max OK
