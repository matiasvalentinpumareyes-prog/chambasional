# DATABASE.md — DB_RegresaPE (PostgreSQL)

Fuente de verdad: `db/database_postgres.sql:1` — PostgreSQL 16. 43 tablas, sin ORM ni Alembic. El backend se conecta vía `DATABASE_URL` y ejecuta este SQL directamente.

## Requisitos

- PostgreSQL 16+
- Extensión `uuid-ossp` (`backend/db/database_postgres.sql:6`): `CREATE EXTENSION IF NOT EXISTS "uuid-ossp"` — provee `uuid_generate_v1mc()` para todas las PKs `UUID DEFAULT (uuid_generate_v1mc())`. Requiere superuser en la primera ejecución. Alternativa moderna `pgcrypto` (`gen_random_uuid()`) no usada aquí.
- Cliente `psql`

## Uso

```bash
# crear y cargar (reemplaza $DATABASE_URL)
psql "$DATABASE_URL" -f backend/db/database_postgres.sql

# verificar
psql "$DATABASE_URL" -c "\dt" -c "SELECT count(*) FROM empresa; SELECT * FROM canales_marketing;"

# backup / restore
pg_dump -Fc -d "$DATABASE_URL" > backup_$(date +%Y%m%d).dump
pg_restore -d "$DATABASE_URL" backup_20260101.dump
```

El script no es idempotente (sin `IF NOT EXISTS`/`DROP`): rerun falla si las tablas ya existen. Para reset: `DROP SCHEMA public CASCADE; CREATE SCHEMA public;` y re-ejecutar.

## Diagrama de relaciones (simplificado)

```
# Catálogos base (globales, sin emp_id)
departamento ──< provincia ──< distrito
documento, metodos_pago, canales_marketing, segmentos, roles
auditoria_entidades, auditoria_accion, patrones_compra

# Tenancy
empresa ──< usuario_personal ──< usuario
empresa ──< categorias, producto_marca, cliente, cliente_consentimientos, ventas, etc.
empresa ──< tipos_direccion_explicacion  # único catálogo tenant (con emp_id)

# Comercial
empresa ──< categorias ──┐
empresa ──< producto_marca ─┤
              └─> producto ──< producto_precios
                         ──< producto_stock

# Clientes y consentimiento
empresa ──< cliente ──< cliente_consentimientos >── canales_marketing
        └─< cliente_segmento >── segmentos
        └─< cliente_segmento_historial
        └─< cliente_features >── categorias / producto (favoritos) + patrones_compra
        └─< cliente_estacionalidad (12 filas por cliente, mes 1..12)

# Ventas
empresa ──< cliente ──< ventas ──< venta_items >── producto
                    └─< metodos_pago, cupones (fk diferida ventas.cupon_id)

# Modelos e IA
empresa ──< version_modelo ──< model_metrics
        └─< predicciones >── cliente, version_modelo
                        └─< prediccion_explicaciones >── tipos_direccion_explicacion

# Motor reglas y recomendaciones
empresa ──< estrategias ──< rules
                      └─< recomendaciones >── cliente, predicciones, producto, cupones
                      └─< campaigns >── campaign_recipients >── cliente, canales, recomendaciones, ventas
                                   └─< communicaciones (log por envío)

# Cupones
empresa ──< cupones ──< cupon_canjes >── cliente, ventas, campaign_recipients

# Auditoría e imports
empresa ──< auditoria_logs >── usuario, auditoria_entidades, auditoria_accion
empresa ──< imports >── usuario
                └─< import_errors

```

## Catálogo de tablas (43)

### 1. Catálogos base — globales (`estado SMALLINT DEFAULT 1`)

| Tabla | PK | Descripción | Uniques |
|-------|----|-------------|---------|
| `departamento:12` | `dep_id UUID` | Ubigeo nivel 1 | `uq_departamento_nombre(dep_nombre)` |
| `provincia:23` | `prv_id UUID` |  | `uq_provincia_dep_nombre(dep_id,prv_nombre)` |
| `distrito:37` | `dis_id UUID` |  | `uq_distrito_prv_nombre(prv_id,dis_nombre)` |
| `documento:51` | `doc_id UUID` | Tipos DNI/RUC/etc | `uq_documento_tipo(doc_tipo)` |
| `metodos_pago:63` | `mtp_id UUID` |  | `uq_metodo_pago_nombre(mtp_nombre)` |
| `canales_marketing:74` | `can_id UUID` | EMAIL/SMS/WHATSAPP/PUSH | `uq_canal_codigo`, `uq_canal_nombre` |
| `segmentos:88` | `seg_id UUID` | NUEVO/ACTIVO/EN_RIESGO/PERDIDO/RECUPERADO/LEAL | `uq_segmento_codigo`, `uq_segmento_nombre` |
| `roles:103` | `rol_id UUID` | SUPERADMIN/ADMIN_EMPRESA/MARKETING/OPERADOR/AUDITOR | `uq_rol_codigo`, `uq_rol_nombre` |
| `auditoria_entidades:117` | `ade_id UUID` | Catálogo tablas auditables | `uq_auditoria_entidad_codigo`, `uq_auditoria_entidad_tabla` |
| `auditoria_accion:132` | `ada_id UUID` | INSERT/UPDATE/DELETE/LOGIN/etc | `uq_auditoria_accion(ada_accion)` |
| `patrones_compra:954` | `pat_id UUID` | UNICA/CASUAL/RECURRENTE/ESTACIONAL/DESCONOCIDO | `uq_patron_codigo`, `uq_patron_nombre` |

Todos con `created_at/updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP`, `created_by/updated_by VARCHAR(100)`, `estado`.

### 2. Tenancy / empresa

| Tabla | PK | Tenant | Notas |
|-------|----|--------|-------|
| `empresa:148` | `emp_id UUID` | root | `uq_empresa_ruc`, `emp_logo BYTEA`, FKs opcionales a ubigeo |
| `usuario_personal:181` | `usp_id UUID` | `emp_id` | `uq_usuario_personal_emp_dni(emp_id,usp_dni)`, `uq_usuario_personal_emp_id(emp_id,usp_id)` — segunda es soporte para FK compuesta |
| `usuario:198` | `usu_id UUID` | `emp_id` | `uq_usuario_emp_usuario`, `uq_usuario_emp_email`, `uq_usuario_emp_usu(emp_id,usu_id)`, FK compuesta `(emp_id,usp_id) -> usuario_personal`, FK `rol_id` global |

### 3. Catálogo comercial (tenant)

| Tabla | PK | Uniques | FKs |
|-------|----|---------|-----|
| `categorias:227` | `cat_id` | `uq_categoria_emp_nombre(emp_id,cat_nombre)`, `uq_categoria_emp_id(emp_id,cat_id)` | `emp_id -> empresa` |
| `producto_marca:243` | `prd_marca_id` | `uq_marca_emp_nombre`, `uq_marca_emp_id` | `emp_id` |
| `producto:258` | `prd_id` | `uq_producto_emp_prd(emp_id,prd_id)`, `uq_producto_emp_sku`, `uq_producto_emp_codbarra` | `(emp_id,cat_id)->categorias`, `(emp_id,prd_marca_id)->producto_marca` |
| `producto_precios:284` | `prd_precios_id` | `uq_producto_precio_emp_id` | `(emp_id,prd_id)->producto` |
| `producto_stock:307` | `stock_id` | `uq_producto_stock_producto(emp_id,prd_id)`, `uq_producto_stock_id` | `(emp_id,prd_id)->producto` |

### 4. Clientes

| Tabla | PK | Uniques | Notas |
|-------|----|---------|-------|
| `cliente:329` | `cli_id` | `uq_cliente_emp_cli(emp_id,cli_id)`, `uq_cliente_emp_documento(emp_id,doc_id,cli_ndocumento)`, `uq_cliente_emp_email(emp_id,cli_email)` | FK `doc_id` global, ubigeo opcional |
| `cliente_consentimientos:364` | `cco_id` | `uq_consentimiento_cliente_canal(emp_id,cli_id,can_id)` | `(emp_id,cli_id)->cliente`, `can_id->canales_marketing` |

### 5. Ventas

| Tabla | PK | Notas |
|-------|----|-------|
| `ventas:392` | `venta_id` | `uq_venta_emp_id(emp_id,venta_id)`, `(emp_id,cli_id)->cliente`, `mtp_id->metodos_pago`, `cupon_id->cupones` (FK añadida diferida `backend/db/database_postgres.sql:665`) |
| `venta_items:416` | `ven_item_id` | `uq_venta_item_emp_id`, `(emp_id,venta_id)->ventas`, `(emp_id,prd_id)->producto`, `cantidad DECIMAL(12,3)`, `subtotal/costo DECIMAL(14,2)` |

### 6. Segmentación + features IA

| Tabla | PK | Notas |
|-------|----|-------|
| `cliente_segmento:442` | `cli_segmento_id` | Estado actual 1:1 por cliente `uq_cliente_segmento_actual(emp_id,cli_id)`, `seg_id->segmentos` |
| `cliente_segmento_historial:463` | `csh_id` | Auditoría cambios `seg_anterior_id/nuevo_id -> segmentos`, `changed_at` |
| `cliente_features:488` + `ALTER 981` | `cft_id` | Snapshot por `uq_features_cliente_snapshot(emp_id,cli_id,fecha_snapshot)`. Columnas base `recencia/frecuencia_30/90/365d`, `ticket_promedio/gasto_*`, `score_churn`, `metadata JSON`. Columnas añadidas por `ALTER`: `total_compras_historicas, intervalo_promedio/desviacion/cv, pat_id->patrones_compra, ratio_riesgo_actual` |
| `cliente_estacionalidad:992` | `ces_id` | `uq_estacionalidad_cliente_mes(emp_id,cli_id,mes)` + `CHECK mes 1..12:1006`, 12 filas por cliente |
| `tipos_direccion_explicacion:1013` | `tde_id` | **Tenant** `emp_id`, `uq_tipo_direccion_empresa_id(emp_id,tde_id)` para FK compuesta, `uq_tipo_direccion_codigo(emp_id,codigo)`. **Sin `created_at/updated_at`** (única tabla sin timestamps) |
| `prediccion_explicaciones:1028` | `pex_id` | `uq_explicacion_pdc_feature(emp_id,pdc_id,feature_nombre)`, `(emp_id,pdc_id)->predicciones`, `(emp_id,tde_id)->tipos_direccion` |

### 7. Modelos y predicciones

| Tabla | PK | Notas |
|-------|----|-------|
| `version_modelo:529` | `vrm_id` | `uq_modelo_emp_version(emp_id,vrm_name,vrm_version)`, `uq_modelo_emp_id(emp_id,vrm_id)`, `metadata JSON` |
| `model_metrics:548` | `mdm_id` | `(emp_id,vrm_id)->version_modelo`, `mdm_metric_value DECIMAL(12,6)` |
| `predicciones:566` | `pdc_id` | `uq_prediccion_emp_id(emp_id,pdc_id)`, `(emp_id,cli_id)->cliente`, `(emp_id,vrm_id)->version_modelo` nullable |

### 8. Motor reglas

| Tabla | PK | Notas |
|-------|----|-------|
| `estrategias:595` | `est_id` | `uq_estrategia_emp_nombre`, `uq_estrategia_emp_id(emp_id,est_id)`, `configuracion JSON` |
| `rules:614` | `rle_id` | `uq_rule_emp_nombre`, `rle_condiciones JSON NOT NULL`, `rle_acciones JSON`, `(emp_id,est_id)->estrategias` nullable |

### 9. Cupones / recomendaciones

| Tabla | PK | Notas |
|-------|----|-------|
| `cupones:640` | `cup_id` | `uq_cupon_emp_codigo`, `uq_cupon_emp_id`, vigencia `fecha_inicio/fin` |
| `recomendaciones:669` | `rec_id` | `uq_recomendacion_emp_id`, `(emp_id,cli_id)->cliente`, `(emp_id,est_id)->estrategias`, `(emp_id,pdc_id)->predicciones`, `(emp_id,prd_id)->producto` nullable, `(emp_id,cup_id)->cupones` nullable |

### 10. Campañas

| Tabla | PK | Notas |
|-------|----|-------|
| `campaigns:708` | `cpg_id` | `uq_campaign_emp_id`, `uq_campaign_emp_nombre`, `(emp_id,est_id)->estrategias` nullable, `can_id->canales_marketing`, `estado DEFAULT 3` |
| `campaign_recipients:735` | `cpg_recipient_id` | `uq_campaign_recipient_emp_id`, `uq_campaign_recipient_cliente(emp_id,cpg_id,cli_id)`, `(emp_id,cpg_id)->campaigns`, `(emp_id,cli_id)->cliente`, `(emp_id,rec_id)->recomendaciones` nullable, `(emp_id,venta_id)->ventas` nullable, `estado DEFAULT 2` |
| `communicaciones:771` | `com_id` | Log por envío, `(emp_id,cli_id)->cliente`, `(emp_id,cpg_recipient_id)->campaign_recipients` nullable, `can_id->canales_marketing`, `(emp_id,venta_id)->ventas` nullable |
| `cupon_canjes:808` | `ccn_id` | `uq_cupon_canje_cliente_venta(emp_id,cup_id,cli_id,venta_id)`, `(emp_id,cup_id)->cupones`, `(emp_id,cpg_recipient_id)->campaign_recipients` nullable |

### 11. Auditoría e imports

| Tabla | PK | Notas |
|-------|----|-------|
| `auditoria_logs:839` | `adl_id` | `(emp_id,usu_id)->usuario` compuesta, `ade_id->auditoria_entidades`, `ada_id->auditoria_accion`, `adl_valor_anterior/nuevo JSON`, `ip_address VARCHAR(45)` |
| `imports:866` | `imp_id` | `(emp_id,usu_id)->usuario` |
| `import_errors:888` | `imp_error_id` | `(emp_id)->empresa`, `FK (imp_id)->imports(imp_id)` solo por `imp_id` (sin `emp_id` en FK) |

## Decisiones de esquema

- **UUID:** `UUID PRIMARY KEY DEFAULT (uuid_generate_v1mc())` en todas las tablas. v1mc da localidad de índice vs `uuid4` aleatorio. Requiere `uuid-ossp`.
- **Multi-tenancy:** `emp_id UUID NOT NULL` en toda entidad operativa (30+ tablas). Aislamiento vía `WHERE emp_id = :tenant` en queries. Tablas globales sin `emp_id`: `departamento`, `provincia`, `distrito`, `documento`, `metodos_pago`, `canales_marketing`, `segmentos`, `roles`, `auditoria_entidades/accion`, `patrones_compra`. Excepción: `tipos_direccion_explicacion` sí lleva `emp_id` (catálogo por empresa).
- **FKs compuestas:** `FOREIGN KEY (emp_id, cli_id) REFERENCES cliente(emp_id, cli_id)` exige `UNIQUE(emp_id, cli_id)` además de `PRIMARY KEY(cli_id)`. Por eso cada tabla tenant declara `UNIQUE(emp_id, pk)` (ej. `uq_cliente_emp_cli`, `uq_producto_emp_prd`). Duplica índice PK pero es requerido por Postgres para referenciar columnas no-PK.
- **Dinero:** `DECIMAL(14,2)` ventas/cupones/comunicaciones, `DECIMAL(10,2)` precios/stock. Nunca `float`.
- **Timestamps:** `TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP` + `updated_at` auto-actualizado vía `set_updated_at():1120` (`BEFORE UPDATE EXECUTE FUNCTION set_updated_at()`) — 33 triggers (`backend/db/database_postgres.sql:1128-1336`). No usa `TIMESTAMPTZ`/`now()`; si necesitas zona horaria usa `TIMESTAMPTZ` a futuro.
- **JSON:** `JSON` (no `JSONB`) en `cliente_features.metadata`, `version_modelo.metadata`, `predicciones.metadata`, `estrategias.configuracion`, `rules.rle_condiciones/acciones`, `auditoria_logs.adl_valor_*`, `import_errors.raw_data`. Migrar a `JSONB` + `GIN` si filtras por contenido.
- **Estados:** `SMALLINT` (`TINYINT` en MySQL) `DEFAULT 1` activo, `0` inactivo, `2/3` estados campaña/recipient.
- **Índices:** `backend/db/database_postgres.sql:1058-1113` — 50+ índices btree sobre `emp_id`, `cli_id`, `prd_id`, `created_at`, `fecha_snapshot`, `score_churn`, `ratio_riesgo`, etc. Sin índices parciales ni GIN.
- **Seeds:** `backend/db/database_postgres.sql:915-949` + `968-979` — `INSERT ... ON CONFLICT DO NOTHING` para `canales_marketing` (4), `segmentos` (6), `roles` (5), `auditoria_accion` (9), `patrones_compra` (5).
- **Sin `ON DELETE`:** todas las FKs son `NO ACTION` (default). Borrados deben hacerse en orden o añadir `ON DELETE CASCADE/SET NULL` según caso.
- **Orden:** el bloque `patrones_compra`/`ALTER cliente_features`/`cliente_estacionalidad`/`tipos_direccion`/`prediccion_explicaciones` está después del primer `FIN DEL ESQUEMA:952` por migración incremental (equivalente a `ALTER` post-seed).

## Qué no cubre este SQL

- Usuarios de aplicación / RLS: el aislamiento es por `emp_id` en queries, no por `ROW LEVEL SECURITY`.
- Backups automatizados: programar `pg_dump -Fc` + WAL archiving vía cron/proveedor.
- Migraciones incrementales: este archivo es dump completo; para cambios futuros usar `ALTER TABLE` versionado y documentar aquí.
