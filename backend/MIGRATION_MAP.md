# MIGRATION_MAP — ORM legado (19 tablas) → BD real (43 tablas)

> Generado Fase 0. La BD es fuente de verdad (`db/database_postgres.sql:1`).

| Legado ORM (`app/models/*.py`, `alembic 31d35468f06c`) | BD real (`database_postgres.sql`) | Notas |
|---|---|---|
| `businesses.id` | `empresa.emp_id UUID PK` | `Business` → `Empresa(emp_ruc, emp_razon_social, emp_nombre_comercial, emp_logo BYTEA, dep_id/prv_id/dis_id)` |
| `users.id`, `users.business_id` | `usuario.usu_id`, `usuario.emp_id` | `User` ahora separado en `usuario_personal(usp_id, usp_dni, usp_nombres)` + `usuario(usu_usuario, usu_password_hash, rol_id)` |
| `UserRole` enum `admin/business_user` | `roles(rol_id, rol_codigo)` | `SUPERADMIN/ADMIN_EMPRESA/MARKETING/OPERADOR/AUDITOR` (`roles:103`) |
| `customers.id`, `business_id, first_name/last_name/email` | `cliente.cli_id, emp_id, doc_id, cli_ndocumento, cli_nombre_razon_social, cli_email` | `Customer` → `Cliente` + `cliente_consentimientos(cco_id, can_id, consentimiento)` + `cliente_segmento` 1:1 |
| `categories.id, business_id, name` | `categorias.cat_id, emp_id, cat_nombre` | `Category` → `Categoria` |
| `products.id, business_id, sku, name, price, cost, stock, status` | `producto.prd_id, emp_id, prd_sku, prd_nombre, producto_precios.prd_precios, producto_stock.stk_cantidad/stk_min/stk_max` | `Product` se divide en 3 tablas: `producto` + `producto_precios` histórico + `producto_stock` 1:1 |
| `sales.id, business_id, customer_id, total` | `ventas.venta_id, emp_id, cli_id, ven_total, mtp_id, cupon_id` | `Sale` → `Venta` con `metodos_pago(mtp_id)` y `cupones(cup_id)` |
| `sale_items.sale_id, product_id, quantity` | `venta_items.ven_item_id, emp_id, venta_id, prd_id, cantidad Numeric(12,3)` | `SaleItem` → `VentaItem` con `costo_unitario` |
| `model_versions.id, business_id` | `version_modelo.vrm_id, emp_id, vrm_name, vrm_version, vrm_algorithm` | |
| `model_metrics.model_version_id` | `model_metrics.mdm_id, emp_id, vrm_id, mdm_metric_name` | |
| `predictions.customer_id, churn_probability` | `predicciones.pdc_id, emp_id, cli_id, pdc_prob_abandono, pdc_tipo_prediccion` | + `tipos_direccion_explicacion` + `prediccion_explicaciones` |
| `recommendations` / `strategies` | `recomendaciones(rec_id, recommended_offer)` / `estrategias(est_id, configuracion JSON)` + `rules(rle_id, rle_condiciones JSON)` | |
| `campaigns.business_id` | `campaigns.cpg_id, emp_id, can_id, cpg_budget` | `channel enum` → `canales_marketing(can_id)` |
| `campaign_recipients` / `communications` | `campaign_recipients(cpg_recipient_id, converted_at, conversion_value)` / `communicaciones(com_id, com_contenido)` | |
| `imports` / `import_errors` / `audit_logs` | `imports(imp_id, file_type)` / `import_errors(imp_error_id, error_message)` / `auditoria_logs(adl_id, adl_tabla)` | |
| `rules.business_id, name, conditions` | `rules.rle_id, emp_id, rle_nombre, rle_condiciones JSON NOT NULL` | |

**Columnas nuevas sin equivalente ORM:** `empresa.emp_logo`, `producto_marca`, `cliente_features` (recencia/frecuencia/score_churn/pat_id), `cliente_estacionalidad(mes 1..12)`, `patrones_compra`, `departamento/provincia/distrito`, `documento`, `canales_marketing`, `segmentos`, `cupones/cupon_canjes`.

**Columnas legacy eliminadas:** `customers.rfm_*`, `customers.segment/activity_status` (ahora viven en `cliente_segmento` + `cliente_features`), `products.stock` (ahora `producto_stock` separado), `Business.currency/timezone` extendido a `empresa` con ubigeo.
