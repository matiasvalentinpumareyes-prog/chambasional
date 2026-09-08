-- ================================================================
-- db_regresape - Esquema PostgreSQL
-- Migración desde MySQL conservando la estructura, relaciones y nombres
-- ================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ================================================================
-- 1. CATÁLOGOS BASE
-- ================================================================

CREATE TABLE departamento (
dep_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    dep_nombre VARCHAR(100) NOT NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_departamento_nombre UNIQUE (dep_nombre)
);

CREATE TABLE provincia (
prv_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    dep_id UUID NOT NULL,
    prv_nombre VARCHAR(100) NOT NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_provincia_dep_nombre UNIQUE (dep_id, prv_nombre),
    CONSTRAINT fk_provincia_departamento
        FOREIGN KEY (dep_id) REFERENCES departamento(dep_id)
);

CREATE TABLE distrito (
dis_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    prv_id UUID NOT NULL,
    dis_nombre VARCHAR(100) NOT NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_distrito_prv_nombre UNIQUE (prv_id, dis_nombre),
    CONSTRAINT fk_distrito_provincia
        FOREIGN KEY (prv_id) REFERENCES provincia(prv_id)
);

CREATE TABLE documento (
doc_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    doc_tipo VARCHAR(100) NOT NULL,
    doc_descripcion VARCHAR(100) NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_documento_tipo UNIQUE (doc_tipo)
);

CREATE TABLE metodos_pago (
mtp_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    mtp_nombre VARCHAR(50) NOT NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_metodo_pago_nombre UNIQUE (mtp_nombre)
);

CREATE TABLE canales_marketing (
can_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    can_codigo VARCHAR(30) NOT NULL,
    can_nombre VARCHAR(100) NOT NULL,
    requiere_consentimiento SMALLINT NOT NULL DEFAULT 1,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_canal_codigo UNIQUE (can_codigo),
    CONSTRAINT uq_canal_nombre UNIQUE (can_nombre)
);

CREATE TABLE segmentos (
seg_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    seg_codigo VARCHAR(50) NOT NULL,
    seg_nombre VARCHAR(100) NOT NULL,
    seg_descripcion VARCHAR(255) NULL,
    seg_tipo VARCHAR(50) NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_segmento_codigo UNIQUE (seg_codigo),
    CONSTRAINT uq_segmento_nombre UNIQUE (seg_nombre)
);

CREATE TABLE roles (
rol_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    rol_codigo VARCHAR(50) NOT NULL,
    rol_nombre VARCHAR(100) NOT NULL,
    rol_descripcion VARCHAR(255) NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_rol_codigo UNIQUE (rol_codigo),
    CONSTRAINT uq_rol_nombre UNIQUE (rol_nombre)
);

CREATE TABLE auditoria_entidades (
ade_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    ade_codigo VARCHAR(50) NOT NULL,
    ade_nombre VARCHAR(100) NOT NULL,
    ade_tabla VARCHAR(64) NOT NULL,
    ade_descripcion VARCHAR(255) NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_auditoria_entidad_codigo UNIQUE (ade_codigo),
    CONSTRAINT uq_auditoria_entidad_tabla UNIQUE (ade_tabla)
);

CREATE TABLE auditoria_accion (
ada_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    ada_accion VARCHAR(30) NOT NULL,
    ada_descripcion VARCHAR(255) NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_auditoria_accion UNIQUE (ada_accion)
);

-- ================================================================
-- 2. TENANCY / EMPRESA / USUARIOS
-- ================================================================

CREATE TABLE empresa (
emp_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_ruc VARCHAR(11) NOT NULL,
    emp_razon_social VARCHAR(255) NOT NULL,
    emp_nombre_comercial VARCHAR(255) NOT NULL,
    emp_direccion VARCHAR(255) NULL,
    emp_lema VARCHAR(255) NULL,
    emp_email VARCHAR(150) NULL,
    emp_celular1 VARCHAR(20) NULL,
    emp_celular2 VARCHAR(20) NULL,
    emp_telefono1 VARCHAR(20) NULL,
    emp_telefono2 VARCHAR(20) NULL,
    emp_nro_cuenta1 VARCHAR(100) NULL,
    emp_nro_cuenta2 VARCHAR(100) NULL,
    emp_logo BYTEA NULL,
    dep_id UUID NULL,
    prv_id UUID NULL,
    dis_id UUID NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_empresa_ruc UNIQUE (emp_ruc),

    CONSTRAINT fk_empresa_departamento
        FOREIGN KEY (dep_id) REFERENCES departamento(dep_id),
    CONSTRAINT fk_empresa_provincia
        FOREIGN KEY (prv_id) REFERENCES provincia(prv_id),
    CONSTRAINT fk_empresa_distrito
        FOREIGN KEY (dis_id) REFERENCES distrito(dis_id)
);

CREATE TABLE usuario_personal (
usp_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    usp_dni VARCHAR(8) NULL,
    usp_nombres VARCHAR(255) NOT NULL,
    usp_celular VARCHAR(20) NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_usuario_personal_emp_dni UNIQUE (emp_id, usp_dni),
    CONSTRAINT uq_usuario_personal_emp_id UNIQUE (emp_id, usp_id),
    CONSTRAINT fk_usuario_personal_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id)
);

CREATE TABLE usuario (
usu_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    usu_usuario VARCHAR(100) NOT NULL,
    usu_password_hash VARCHAR(255) NOT NULL,
    usu_email VARCHAR(150) NOT NULL,
    rol_id UUID NULL,
    usp_id UUID NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_usuario_emp_usuario UNIQUE (emp_id, usu_usuario),
    CONSTRAINT uq_usuario_emp_email UNIQUE (emp_id, usu_email),
    CONSTRAINT uq_usuario_emp_usu UNIQUE (emp_id, usu_id),

    CONSTRAINT fk_usuario_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_usuario_rol
        FOREIGN KEY (rol_id) REFERENCES roles(rol_id),
    CONSTRAINT fk_usuario_personal
        FOREIGN KEY (emp_id, usp_id) REFERENCES usuario_personal(emp_id, usp_id)
);

-- ================================================================
-- 3. CATÁLOGO COMERCIAL
-- ================================================================

CREATE TABLE categorias (
cat_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    cat_nombre VARCHAR(100) NOT NULL,
    cat_descripcion TEXT NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_categoria_emp_nombre UNIQUE (emp_id, cat_nombre),
    CONSTRAINT uq_categoria_emp_id UNIQUE (emp_id, cat_id),
    CONSTRAINT fk_categoria_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id)
);

CREATE TABLE subcategorias (
subcat_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    cat_id UUID NOT NULL,
    subcat_nombre VARCHAR(100) NOT NULL,
    subcat_descripcion TEXT NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_subcategoria_cat_nombre UNIQUE (cat_id, subcat_nombre),
    CONSTRAINT uq_subcategoria_emp_id UNIQUE (emp_id, subcat_id),
    CONSTRAINT uq_subcategoria_emp_cat_id UNIQUE (emp_id, cat_id, subcat_id),
    CONSTRAINT fk_subcategoria_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_subcategoria_categoria
        FOREIGN KEY (emp_id, cat_id) REFERENCES categorias(emp_id, cat_id)
	
);

CREATE TABLE producto_marca (
prd_marca_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    prd_marca_nombre VARCHAR(100) NOT NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_marca_emp_nombre UNIQUE (emp_id, prd_marca_nombre),
    CONSTRAINT uq_marca_emp_id UNIQUE (emp_id, prd_marca_id),
    CONSTRAINT fk_marca_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id)
);

CREATE TABLE producto (
    prd_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    subcat_id UUID NULL,
    prd_marca_id UUID NULL,
    prd_sku VARCHAR(100) NULL,
    prd_codbarra VARCHAR(100) NULL,
    prd_nombre VARCHAR(150) NOT NULL,
    prd_descripcion TEXT NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,

    CONSTRAINT uq_producto_emp_prd
        UNIQUE (emp_id, prd_id),

    CONSTRAINT uq_producto_emp_sku
        UNIQUE (emp_id, prd_sku),

    CONSTRAINT uq_producto_emp_codbarra
        UNIQUE (emp_id, prd_codbarra),

    CONSTRAINT fk_producto_empresa
        FOREIGN KEY (emp_id)
        REFERENCES empresa(emp_id),

    CONSTRAINT fk_producto_subcategoria
        FOREIGN KEY (emp_id, subcat_id)
        REFERENCES subcategorias(emp_id, subcat_id),

    CONSTRAINT fk_producto_marca
        FOREIGN KEY (emp_id, prd_marca_id)
        REFERENCES producto_marca(emp_id, prd_marca_id)
);

CREATE TABLE producto_precios (
prd_precios_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    prd_id UUID NOT NULL,
    prd_precios DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    prd_precios_undmedida CHAR(3) NULL,
    prd_precios_undproducto VARCHAR(20) NULL,
    prd_precios_ganancia DECIMAL(10,2) NULL,
    prd_precios_lista DECIMAL(10,2) NULL,
    prd_precios_costo DECIMAL(10,2) NULL,
    fecha_inicio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_fin TIMESTAMP NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_producto_precio_emp_id UNIQUE (emp_id, prd_precios_id),

    CONSTRAINT fk_producto_precio_producto
        FOREIGN KEY (emp_id, prd_id) REFERENCES producto(emp_id, prd_id)
);

CREATE TABLE producto_stock (
stock_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    prd_id UUID NOT NULL,
    stk_cantidad DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    stk_min INT NOT NULL DEFAULT 0,
    stk_max INT NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_producto_stock_producto UNIQUE (emp_id, prd_id),
    CONSTRAINT uq_producto_stock_id UNIQUE (emp_id, stock_id),
    CONSTRAINT fk_producto_stock_producto
        FOREIGN KEY (emp_id, prd_id) REFERENCES producto(emp_id, prd_id)
);

-- ================================================================
-- 4. CLIENTES Y PRIVACIDAD / CONSENTIMIENTO
-- ================================================================

CREATE TABLE cliente (
cli_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    doc_id UUID NOT NULL,
    cli_ndocumento VARCHAR(15) NULL,
    cli_nombre_razon_social VARCHAR(255) NOT NULL,
    cli_direccion VARCHAR(255) NULL,
    cli_email VARCHAR(150) NULL,
    cli_celular VARCHAR(30) NULL,
    cli_birthday DATE NULL,
    cli_genero SMALLINT NULL,
    dep_id UUID NULL,
    prv_id UUID NULL,
    dis_id UUID NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_cliente_emp_cli UNIQUE (emp_id, cli_id),
    CONSTRAINT uq_cliente_emp_documento UNIQUE (emp_id, doc_id, cli_ndocumento),
    CONSTRAINT uq_cliente_emp_email UNIQUE (emp_id, cli_email),

    CONSTRAINT fk_cliente_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_cliente_documento
        FOREIGN KEY (doc_id) REFERENCES documento(doc_id),
    CONSTRAINT fk_cliente_departamento
        FOREIGN KEY (dep_id) REFERENCES departamento(dep_id),
    CONSTRAINT fk_cliente_provincia
        FOREIGN KEY (prv_id) REFERENCES provincia(prv_id),
    CONSTRAINT fk_cliente_distrito
        FOREIGN KEY (dis_id) REFERENCES distrito(dis_id)
);

CREATE TABLE cliente_consentimientos (
cco_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    cli_id UUID NOT NULL,
    can_id UUID NOT NULL,
    consentimiento SMALLINT NOT NULL DEFAULT 0,
    fecha_otorgado TIMESTAMP NULL,
    fecha_revocado TIMESTAMP NULL,
    fuente VARCHAR(100) NULL,
    evidencia VARCHAR(255) NULL,
    version_politica VARCHAR(50) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_consentimiento_cliente_canal UNIQUE (emp_id, cli_id, can_id),
    CONSTRAINT fk_consentimiento_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_consentimiento_cliente
        FOREIGN KEY (emp_id, cli_id) REFERENCES cliente(emp_id, cli_id),
    CONSTRAINT fk_consentimiento_canal
        FOREIGN KEY (can_id) REFERENCES canales_marketing(can_id)
);

-- ================================================================
-- 5. VENTAS / DETALLE LINEA A LINEA
-- ================================================================

CREATE TABLE ventas (
venta_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    cli_id UUID NOT NULL,
    ven_descuento DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    ven_total DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    mtp_id UUID NULL,
    cupon_id UUID NULL,
    venta_origen VARCHAR(50) NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_venta_emp_id UNIQUE (emp_id, venta_id),

    CONSTRAINT fk_ventas_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_ventas_cliente
        FOREIGN KEY (emp_id, cli_id) REFERENCES cliente(emp_id, cli_id),
    CONSTRAINT fk_ventas_metodo_pago
        FOREIGN KEY (mtp_id) REFERENCES metodos_pago(mtp_id)
);

CREATE TABLE venta_items (
ven_item_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    venta_id UUID NOT NULL,
    prd_id UUID NOT NULL,
    cantidad DECIMAL(12,3) NOT NULL DEFAULT 1.000,
    precio_unitario DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    descuento DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    subtotal DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    costo_unitario DECIMAL(14,2) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_venta_item_emp_id UNIQUE (emp_id, ven_item_id),

    CONSTRAINT fk_venta_item_venta
        FOREIGN KEY (emp_id, venta_id) REFERENCES ventas(emp_id, venta_id),
    CONSTRAINT fk_venta_item_producto
        FOREIGN KEY (emp_id, prd_id) REFERENCES producto(emp_id, prd_id)
);

-- ================================================================
-- 6. SEGMENTACIÓN + FEATURES PARA IA
-- ================================================================

CREATE TABLE cliente_segmento (
cli_segmento_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    cli_id UUID NOT NULL,
    seg_id UUID NOT NULL,
    puntuacion DECIMAL(8,5) NULL,
    fecha_asignacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_cliente_segmento_actual UNIQUE (emp_id, cli_id),
    CONSTRAINT fk_cliente_segmento_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_cliente_segmento_cliente
        FOREIGN KEY (emp_id, cli_id) REFERENCES cliente(emp_id, cli_id),
    CONSTRAINT fk_cliente_segmento_catalogo
        FOREIGN KEY (seg_id) REFERENCES segmentos(seg_id)
);

CREATE TABLE cliente_segmento_historial (
csh_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    cli_id UUID NOT NULL,
    seg_anterior_id UUID NULL,
    seg_nuevo_id UUID NOT NULL,
    puntuacion_anterior DECIMAL(8,5) NULL,
    puntuacion_nueva DECIMAL(8,5) NULL,
    motivo VARCHAR(150) NULL,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,

    CONSTRAINT fk_segmento_hist_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_segmento_hist_cliente
        FOREIGN KEY (emp_id, cli_id) REFERENCES cliente(emp_id, cli_id),
    CONSTRAINT fk_segmento_hist_anterior
        FOREIGN KEY (seg_anterior_id) REFERENCES segmentos(seg_id),
    CONSTRAINT fk_segmento_hist_nuevo
        FOREIGN KEY (seg_nuevo_id) REFERENCES segmentos(seg_id)
);

CREATE TABLE cliente_features (
cft_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    cli_id UUID NOT NULL,
    fecha_snapshot TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recencia_dias INT NULL,
    frecuencia_30d INT NOT NULL DEFAULT 0,
    frecuencia_90d INT NOT NULL DEFAULT 0,
    frecuencia_365d INT NOT NULL DEFAULT 0,
    ticket_promedio DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    gasto_total_30d DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    gasto_total_90d DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    gasto_total_365d DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    dias_desde_ultima_compra INT NULL,
    categoria_favorita_id UUID NULL,
    producto_favorito_id UUID NULL,
    margen_estimado_90d DECIMAL(14,2) NULL,
    descuento_promedio_90d DECIMAL(14,2) NULL,
    valor_vida_estimado DECIMAL(14,2) NULL,
    score_churn DECIMAL(8,5) NULL,
    metadata JSON NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_features_cliente_snapshot UNIQUE (emp_id, cli_id, fecha_snapshot),

    CONSTRAINT fk_features_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_features_cliente
        FOREIGN KEY (emp_id, cli_id) REFERENCES cliente(emp_id, cli_id),
    CONSTRAINT fk_features_categoria
        FOREIGN KEY (emp_id, categoria_favorita_id) REFERENCES categorias(emp_id, cat_id),
    CONSTRAINT fk_features_producto
        FOREIGN KEY (emp_id, producto_favorito_id) REFERENCES producto(emp_id, prd_id)
);

-- ================================================================
-- 7. MODELOS Y PREDICCIONES
-- ================================================================

CREATE TABLE version_modelo (
vrm_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    vrm_name VARCHAR(100) NOT NULL,
    vrm_version VARCHAR(50) NOT NULL,
    vrm_algorithm VARCHAR(100) NULL,
    trained_at TIMESTAMP NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    metadata JSON NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_modelo_emp_version UNIQUE (emp_id, vrm_name, vrm_version),
    CONSTRAINT uq_modelo_emp_id UNIQUE (emp_id, vrm_id),
    CONSTRAINT fk_modelo_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id)
);

CREATE TABLE model_metrics (
mdm_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    vrm_id UUID NOT NULL,
    mdm_metric_name VARCHAR(100) NOT NULL,
    mdm_metric_value DECIMAL(12,6) NOT NULL,
    evaluation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    metadata JSON NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT fk_model_metrics_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_model_metrics_modelo
        FOREIGN KEY (emp_id, vrm_id) REFERENCES version_modelo(emp_id, vrm_id)
);

CREATE TABLE predicciones (
pdc_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    cli_id UUID NOT NULL,
    vrm_id UUID NULL,
    pdc_tipo_prediccion VARCHAR(50) NOT NULL,
    pdc_prob_abandono DECIMAL(8,5) NULL,
    pdc_valor DECIMAL(14,2) NULL,
    pdc_fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NULL,
    metadata JSON NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_prediccion_emp_id UNIQUE (emp_id, pdc_id),

    CONSTRAINT fk_predicciones_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_predicciones_cliente
        FOREIGN KEY (emp_id, cli_id) REFERENCES cliente(emp_id, cli_id),
    CONSTRAINT fk_predicciones_modelo
        FOREIGN KEY (emp_id, vrm_id) REFERENCES version_modelo(emp_id, vrm_id)
);

-- ================================================================
-- 8. MOTOR DE REGLAS + ESTRATEGIAS DE MARKETING
-- ================================================================

CREATE TABLE estrategias (
est_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    est_nombre VARCHAR(150) NOT NULL,
    est_descripcion TEXT NULL,
    est_objetivo VARCHAR(100) NULL,
    est_action_type VARCHAR(50) NULL,
    configuracion JSON NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_estrategia_emp_nombre UNIQUE (emp_id, est_nombre),
    CONSTRAINT uq_estrategia_emp_id UNIQUE (emp_id, est_id),
    CONSTRAINT fk_estrategia_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id)
);

CREATE TABLE rules (
rle_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    est_id UUID NULL,
    rle_nombre VARCHAR(150) NOT NULL,
    rle_descripcion TEXT NULL,
    rle_rule_type VARCHAR(50) NOT NULL,
    rle_condiciones JSON NOT NULL,
    rle_acciones JSON NULL,
    rle_prioridad INT NOT NULL DEFAULT 1,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_rule_emp_nombre UNIQUE (emp_id, rle_nombre),
    CONSTRAINT fk_rule_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_rule_estrategia
        FOREIGN KEY (emp_id, est_id) REFERENCES estrategias(emp_id, est_id)
);

-- ================================================================
-- 9. CUPONES / OFERTAS / RECOMENDACIONES
-- ================================================================

CREATE TABLE cupones (
cup_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    cup_codigo VARCHAR(80) NOT NULL,
    cup_nombre VARCHAR(150) NOT NULL,
    cup_tipo VARCHAR(20) NOT NULL,
    cup_valor DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    cup_min_compra DECIMAL(14,2) NULL,
    cup_max_descuento DECIMAL(14,2) NULL,
    cup_limite_uso_total INT NULL,
    cup_limite_uso_cliente INT NULL DEFAULT 1,
    cup_usos_actuales INT NOT NULL DEFAULT 0,
    fecha_inicio TIMESTAMP NOT NULL,
    fecha_fin TIMESTAMP NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_cupon_emp_codigo UNIQUE (emp_id, cup_codigo),
    CONSTRAINT uq_cupon_emp_id UNIQUE (emp_id, cup_id),
    CONSTRAINT fk_cupon_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id)
);

ALTER TABLE ventas
    ADD CONSTRAINT fk_ventas_cupon
        FOREIGN KEY (emp_id, cupon_id) REFERENCES cupones(emp_id, cup_id);

CREATE TABLE recomendaciones (
rec_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    cli_id UUID NOT NULL,
    est_id UUID NOT NULL,
    pdc_id UUID NOT NULL,
    prd_id UUID NULL,
    cup_id UUID NULL,
    rec_titulo VARCHAR(200) NOT NULL,
    rec_descripcion TEXT NULL,
    prioridad INT NOT NULL DEFAULT 1,
    rec_accion_recomendada TEXT NULL,
    recommended_offer DECIMAL(14,2) NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    expires_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_recomendacion_emp_id UNIQUE (emp_id, rec_id),

    CONSTRAINT fk_recomendacion_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_recomendacion_cliente
        FOREIGN KEY (emp_id, cli_id) REFERENCES cliente(emp_id, cli_id),
    CONSTRAINT fk_recomendacion_estrategia
        FOREIGN KEY (emp_id, est_id) REFERENCES estrategias(emp_id, est_id),
    CONSTRAINT fk_recomendacion_prediccion
        FOREIGN KEY (emp_id, pdc_id) REFERENCES predicciones(emp_id, pdc_id),
    CONSTRAINT fk_recomendacion_producto
        FOREIGN KEY (emp_id, prd_id) REFERENCES producto(emp_id, prd_id),
    CONSTRAINT fk_recomendacion_cupon
        FOREIGN KEY (emp_id, cup_id) REFERENCES cupones(emp_id, cup_id)
);

-- ================================================================
-- 10. CAMPAÑAS / DESTINATARIOS / CONVERSIÓN
-- ================================================================

CREATE TABLE campaigns (
cpg_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    est_id UUID NULL,
    can_id UUID NOT NULL,
    cpg_name VARCHAR(150) NOT NULL,
    cpg_description TEXT NULL,
    cpg_subject VARCHAR(200) NULL,
    cpg_content TEXT NULL,
    cpg_budget DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    start_date TIMESTAMP NULL,
    end_date TIMESTAMP NULL,
    estado SMALLINT NOT NULL DEFAULT 3,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_campaign_emp_id UNIQUE (emp_id, cpg_id),
    CONSTRAINT uq_campaign_emp_nombre UNIQUE (emp_id, cpg_name),
    CONSTRAINT fk_campaign_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_campaign_estrategia
        FOREIGN KEY (emp_id, est_id) REFERENCES estrategias(emp_id, est_id),
    CONSTRAINT fk_campaign_canal
        FOREIGN KEY (can_id) REFERENCES canales_marketing(can_id)
);

CREATE TABLE campaign_recipients (
cpg_recipient_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    cpg_id UUID NOT NULL,
    cli_id UUID NOT NULL,
    can_id UUID NOT NULL,
    rec_id UUID NULL,
    estado SMALLINT NOT NULL DEFAULT 2,
    sent_at TIMESTAMP NULL,
    delivered_at TIMESTAMP NULL,
    opened_at TIMESTAMP NULL,
    clicked_at TIMESTAMP NULL,
    converted_at TIMESTAMP NULL,
    venta_id UUID NULL,
    conversion_value DECIMAL(14,2) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_campaign_recipient_emp_id UNIQUE (emp_id, cpg_recipient_id),
    CONSTRAINT uq_campaign_recipient_cliente UNIQUE (emp_id, cpg_id, cli_id),

    CONSTRAINT fk_campaign_recipient_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_campaign_recipient_campaign
        FOREIGN KEY (emp_id, cpg_id) REFERENCES campaigns(emp_id, cpg_id),
    CONSTRAINT fk_campaign_recipient_cliente
        FOREIGN KEY (emp_id, cli_id) REFERENCES cliente(emp_id, cli_id),
    CONSTRAINT fk_campaign_recipient_canal
        FOREIGN KEY (can_id) REFERENCES canales_marketing(can_id),
    CONSTRAINT fk_campaign_recipient_recomendacion
        FOREIGN KEY (emp_id, rec_id) REFERENCES recomendaciones(emp_id, rec_id),
    CONSTRAINT fk_campaign_recipient_venta
        FOREIGN KEY (emp_id, venta_id) REFERENCES ventas(emp_id, venta_id)
);

CREATE TABLE communicaciones (
com_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    cli_id UUID NOT NULL,
    cpg_recipient_id UUID NULL,
    can_id UUID NOT NULL,
    com_asunto VARCHAR(200) NULL,
    com_contenido TEXT NOT NULL,
    provider_message_id VARCHAR(150) NULL,
    estado SMALLINT NOT NULL DEFAULT 2,
    sent_at TIMESTAMP NULL,
    delivered_at TIMESTAMP NULL,
    opened_at TIMESTAMP NULL,
    clicked_at TIMESTAMP NULL,
    converted_at TIMESTAMP NULL,
    venta_id UUID NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,

    CONSTRAINT fk_comunicacion_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_comunicacion_cliente
        FOREIGN KEY (emp_id, cli_id) REFERENCES cliente(emp_id, cli_id),
    CONSTRAINT fk_comunicacion_recipient
        FOREIGN KEY (emp_id, cpg_recipient_id) REFERENCES campaign_recipients(emp_id, cpg_recipient_id),
    CONSTRAINT fk_comunicacion_canal
        FOREIGN KEY (can_id) REFERENCES canales_marketing(can_id),
    CONSTRAINT fk_comunicacion_venta
        FOREIGN KEY (emp_id, venta_id) REFERENCES ventas(emp_id, venta_id)
);

-- ================================================================
-- 11. CANJES DE CUPONES
-- ================================================================

CREATE TABLE cupon_canjes (
ccn_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    cup_id UUID NOT NULL,
    cli_id UUID NOT NULL,
    venta_id UUID NULL,
    cpg_recipient_id UUID NULL,
    fecha_canjes TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    importe_descuento DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_cupon_canje_cliente_venta UNIQUE (emp_id, cup_id, cli_id, venta_id),

    CONSTRAINT fk_canje_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_canje_cupon
        FOREIGN KEY (emp_id, cup_id) REFERENCES cupones(emp_id, cup_id),
    CONSTRAINT fk_canje_cliente
        FOREIGN KEY (emp_id, cli_id) REFERENCES cliente(emp_id, cli_id),
    CONSTRAINT fk_canje_venta
        FOREIGN KEY (emp_id, venta_id) REFERENCES ventas(emp_id, venta_id),
    CONSTRAINT fk_canje_recipient
        FOREIGN KEY (emp_id, cpg_recipient_id) REFERENCES campaign_recipients(emp_id, cpg_recipient_id)
);

-- ================================================================
-- 12. AUDITORÍA + IMPORTACIONES
-- ================================================================

CREATE TABLE auditoria_logs (
adl_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    usu_id UUID NOT NULL,
    ade_id UUID NOT NULL,
    ada_id UUID NOT NULL,
    adl_tabla VARCHAR(64) NOT NULL,
    adl_registro_id VARCHAR(100) NOT NULL,
    adl_usuario VARCHAR(100) NOT NULL,
    adl_fecha_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    adl_valor_anterior JSON NULL,
    adl_valor_nuevo JSON NULL,
    ip_address VARCHAR(45) NULL,
    user_agent TEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_auditoria_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_auditoria_usuario
        FOREIGN KEY (emp_id, usu_id) REFERENCES usuario(emp_id, usu_id),
    CONSTRAINT fk_auditoria_entidad
        FOREIGN KEY (ade_id) REFERENCES auditoria_entidades(ade_id),
    CONSTRAINT fk_auditoria_accion
        FOREIGN KEY (ada_id) REFERENCES auditoria_accion(ada_id)
);

CREATE TABLE imports (
imp_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    usu_id UUID NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_type VARCHAR(50) NULL,
    total_rows INT NOT NULL DEFAULT 0,
    successful_rows INT NOT NULL DEFAULT 0,
    failed_rows INT NOT NULL DEFAULT 0,
    estado SMALLINT NOT NULL DEFAULT 2,
    started_at TIMESTAMP NULL,
    completed_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT fk_import_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_import_usuario
        FOREIGN KEY (emp_id, usu_id) REFERENCES usuario(emp_id, usu_id)
);

CREATE TABLE import_errors (
imp_error_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    imp_id UUID NOT NULL,
    imp_error_row_number INT NULL,
    imp_error_field_name VARCHAR(100) NULL,
    error_type VARCHAR(100) NULL,
    error_message TEXT NOT NULL,
    raw_data JSON NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT fk_import_error_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
	CONSTRAINT fk_import_error_import
    FOREIGN KEY (imp_id)
    REFERENCES imports(imp_id)
);

-- ================================================================
-- 13. FKs adicionales para referencias tardías por dependencia
-- ================================================================
-- ================================================================
-- 14. DATOS BASE DE CATÁLOGOS GLOBALES
-- ================================================================

INSERT INTO canales_marketing (can_id, can_codigo, can_nombre, requiere_consentimiento, estado)
VALUES
    (uuid_generate_v1mc(), 'EMAIL', 'Correo electrónico', 1, 1),
    (uuid_generate_v1mc(), 'SMS', 'SMS', 1, 1),
    (uuid_generate_v1mc(), 'WHATSAPP', 'WhatsApp', 1, 1),
    (uuid_generate_v1mc(), 'PUSH', 'Notificación push', 1, 1) ON CONFLICT DO NOTHING;

INSERT INTO segmentos (seg_id, seg_codigo, seg_nombre, seg_descripcion, seg_tipo, estado)
VALUES
    (uuid_generate_v1mc(), 'NUEVO', 'Nuevo', 'Cliente con pocas o ninguna compra histórica.', 'CICLO_VIDA', 1),
    (uuid_generate_v1mc(), 'ACTIVO', 'Activo', 'Cliente con actividad reciente.', 'CICLO_VIDA', 1),
    (uuid_generate_v1mc(), 'EN_RIESGO', 'En riesgo', 'Cliente con señales de pérdida de actividad.', 'CHURN', 1),
    (uuid_generate_v1mc(), 'PERDIDO', 'Perdido', 'Cliente sin compras durante un periodo definido.', 'CHURN', 1),
    (uuid_generate_v1mc(), 'RECUPERADO', 'Recuperado', 'Cliente que volvió a comprar después de una señal de riesgo o pérdida.', 'RECUPERACION', 1),
    (uuid_generate_v1mc(), 'LEAL', 'Leal', 'Cliente de alta recurrencia o valor.', 'VALOR', 1) ON CONFLICT DO NOTHING;

INSERT INTO roles (rol_id, rol_codigo, rol_nombre, rol_descripcion, estado)
VALUES
    (uuid_generate_v1mc(), 'SUPERADMIN', 'Super administrador', 'Administración técnica global.', 1),
    (uuid_generate_v1mc(), 'ADMIN_EMPRESA', 'Administrador de empresa', 'Administración de una empresa/tenant.', 1),
    (uuid_generate_v1mc(), 'MARKETING', 'Marketing', 'Gestión de campañas, segmentos y recuperación.', 1),
    (uuid_generate_v1mc(), 'OPERADOR', 'Operador', 'Operación comercial y consultas.', 1),
    (uuid_generate_v1mc(), 'AUDITOR', 'Auditor', 'Consulta de trazabilidad y auditoría.', 1) ON CONFLICT DO NOTHING;

INSERT INTO auditoria_accion (ada_id, ada_accion, ada_descripcion, estado)
VALUES
    (uuid_generate_v1mc(), 'INSERT', 'Creación de registro.', 1),
    (uuid_generate_v1mc(), 'UPDATE', 'Actualización de registro.', 1),
    (uuid_generate_v1mc(), 'DELETE', 'Eliminación de registro.', 1),
    (uuid_generate_v1mc(), 'LOGIN', 'Inicio de sesión.', 1),
    (uuid_generate_v1mc(), 'LOGOUT', 'Cierre de sesión.', 1),
    (uuid_generate_v1mc(), 'EXPORT', 'Exportación de información.', 1),
    (uuid_generate_v1mc(), 'IMPORT', 'Importación de información.', 1),
    (uuid_generate_v1mc(), 'CAMPAIGN_SEND', 'Ejecución de campaña.', 1),
    (uuid_generate_v1mc(), 'COUPON_REDEEM', 'Canje de cupón.', 1) ON CONFLICT DO NOTHING;

-- ================================================================
-- FIN DEL ESQUEMA
-- ================================================================
CREATE TABLE patrones_compra (
pat_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    pat_codigo VARCHAR(30) NOT NULL,
    pat_nombre VARCHAR(100) NOT NULL,
    pat_descripcion VARCHAR(255) NULL,
    estado SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_patron_codigo UNIQUE (pat_codigo),
    CONSTRAINT uq_patron_nombre UNIQUE (pat_nombre)
);

INSERT INTO patrones_compra (pat_id, pat_codigo, pat_nombre, pat_descripcion, estado)
VALUES
    (uuid_generate_v1mc(), 'UNICA', 'Compra única',
        'Cliente con una sola compra histórica aún sin patrón definido.', 1),
    (uuid_generate_v1mc(), 'CASUAL', 'Casual',
        'Compras irregulares, sin intervalo predecible entre ellas (CV alto).', 1),
    (uuid_generate_v1mc(), 'RECURRENTE', 'Recurrente',
        'Compras frecuentes con intervalo regular y predecible (CV bajo).', 1),
    (uuid_generate_v1mc(), 'ESTACIONAL', 'Estacional',
        'Compras concentradas en los mismos meses del año, repetidas en distintos años.', 1),
    (uuid_generate_v1mc(), 'DESCONOCIDO', 'Desconocido',
        'Historial insuficiente para determinar un patrón (menos de 2-3 compras).', 1)
ON CONFLICT DO NOTHING;

ALTER TABLE cliente_features
    ADD COLUMN total_compras_historicas INT NOT NULL DEFAULT 0,
    ADD COLUMN intervalo_promedio_dias DECIMAL(8,2) NULL,
    ADD COLUMN intervalo_desviacion_dias DECIMAL(8,2) NULL,
    ADD COLUMN intervalo_cv DECIMAL(6,4) NULL,
    ADD COLUMN pat_id UUID NULL,
    ADD COLUMN ratio_riesgo_actual DECIMAL(8,4) NULL,
    ADD CONSTRAINT fk_features_patron
        FOREIGN KEY (pat_id) REFERENCES patrones_compra(pat_id);


CREATE TABLE cliente_estacionalidad (
ces_id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    cli_id UUID NOT NULL,
    mes SMALLINT NOT NULL,
    num_compras_historicas INT NOT NULL DEFAULT 0,
    gasto_total_mes DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    gasto_promedio_mes DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    ultima_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_estacionalidad_cliente_mes UNIQUE (emp_id, cli_id, mes),
    CONSTRAINT chk_estacionalidad_mes CHECK (mes BETWEEN 1 AND 12),
    CONSTRAINT fk_estacionalidad_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_estacionalidad_cliente
        FOREIGN KEY (emp_id, cli_id) REFERENCES cliente(emp_id, cli_id)
);

CREATE TABLE tipos_direccion_explicacion (
tde_id UUID NOT NULL PRIMARY KEY
        DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    codigo VARCHAR(50) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NULL,
    activo SMALLINT NOT NULL DEFAULT 1,
    CONSTRAINT uq_tipo_direccion_empresa_id UNIQUE (emp_id, tde_id),
    CONSTRAINT uq_tipo_direccion_codigo UNIQUE (emp_id, codigo),
    CONSTRAINT fk_tipo_direccion_empresa
        FOREIGN KEY (emp_id)
        REFERENCES empresa(emp_id)
);

CREATE TABLE prediccion_explicaciones (
pex_id UUID NOT NULL PRIMARY KEY
        DEFAULT (uuid_generate_v1mc()),
    emp_id UUID NOT NULL,
    pdc_id UUID NOT NULL,
    tde_id UUID NOT NULL,
    feature_nombre VARCHAR(100) NOT NULL,
    feature_valor VARCHAR(150) NULL,
    impacto DECIMAL(10,6) NOT NULL,
    orden_importancia INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    CONSTRAINT uq_explicacion_pdc_feature UNIQUE (emp_id, pdc_id, feature_nombre),

    CONSTRAINT fk_explicacion_empresa
        FOREIGN KEY (emp_id)
        REFERENCES empresa(emp_id),
    CONSTRAINT fk_explicacion_prediccion
        FOREIGN KEY (emp_id, pdc_id)
        REFERENCES predicciones(emp_id, pdc_id),
    CONSTRAINT fk_explicacion_tipo_direccion
        FOREIGN KEY (emp_id, tde_id)
        REFERENCES tipos_direccion_explicacion(emp_id, tde_id)
);

-- ================================================================
-- ÍNDICES (equivalentes a KEY de MySQL)
-- ================================================================
CREATE INDEX idx_provincia_dep ON provincia (dep_id);
CREATE INDEX idx_distrito_prv ON distrito (prv_id);
CREATE INDEX idx_empresa_dep ON empresa (dep_id);
CREATE INDEX idx_empresa_prv ON empresa (prv_id);
CREATE INDEX idx_empresa_dis ON empresa (dis_id);
CREATE INDEX idx_usuario_personal_emp ON usuario_personal (emp_id);
CREATE INDEX idx_usuario_emp ON usuario (emp_id);
CREATE INDEX idx_usuario_rol ON usuario (rol_id);
CREATE INDEX idx_usuario_personal ON usuario (emp_id, usp_id);
CREATE INDEX idx_categoria_emp ON categorias (emp_id);
CREATE INDEX idx_subcategoria_emp ON subcategorias (emp_id);
CREATE INDEX idx_subcategoria_categoria ON subcategorias (emp_id, cat_id);
CREATE INDEX idx_marca_emp ON producto_marca (emp_id);
CREATE INDEX idx_producto_emp ON producto (emp_id);
CREATE INDEX idx_producto_subcategoria ON producto (emp_id, subcat_id);
CREATE INDEX idx_producto_marca ON producto (emp_id, prd_marca_id);
CREATE INDEX idx_producto_precio_producto ON producto_precios (emp_id, prd_id);
CREATE INDEX idx_producto_precio_vigencia ON producto_precios (emp_id, prd_id, fecha_inicio, fecha_fin);
CREATE INDEX idx_cliente_emp ON cliente (emp_id);
CREATE INDEX idx_cliente_doc ON cliente (emp_id, doc_id, cli_ndocumento);
CREATE INDEX idx_cliente_ubicacion ON cliente (dep_id, prv_id, dis_id);
CREATE INDEX idx_consentimiento_canal ON cliente_consentimientos (can_id);
CREATE INDEX idx_ventas_cliente_fecha ON ventas (emp_id, cli_id, created_at);
CREATE INDEX idx_ventas_fecha ON ventas (emp_id, created_at);
CREATE INDEX idx_ventas_mtp ON ventas (mtp_id);
CREATE INDEX idx_venta_item_venta ON venta_items (emp_id, venta_id);
CREATE INDEX idx_venta_item_producto ON venta_items (emp_id, prd_id);
CREATE INDEX idx_cliente_segmento_seg ON cliente_segmento (seg_id);
CREATE INDEX idx_segmento_hist_cliente_fecha ON cliente_segmento_historial (emp_id, cli_id, changed_at);
CREATE INDEX idx_segmento_hist_nuevo ON cliente_segmento_historial (seg_nuevo_id);
CREATE INDEX idx_features_cliente_fecha ON cliente_features (emp_id, cli_id, fecha_snapshot);
CREATE INDEX idx_features_churn ON cliente_features (emp_id, score_churn);
CREATE INDEX idx_model_metrics_model_date ON model_metrics (emp_id, vrm_id, evaluation_date);
CREATE INDEX idx_predicciones_cliente_fecha ON predicciones (emp_id, cli_id, pdc_fecha);
CREATE INDEX idx_predicciones_tipo ON predicciones (emp_id, pdc_tipo_prediccion, pdc_fecha);
CREATE INDEX idx_predicciones_modelo ON predicciones (emp_id, vrm_id);
CREATE INDEX idx_rule_emp_prioridad ON rules (emp_id, estado, rle_prioridad);
CREATE INDEX idx_cupon_vigencia ON cupones (emp_id, estado, fecha_inicio, fecha_fin);
CREATE INDEX idx_recomendaciones_cliente_estado ON recomendaciones (emp_id, cli_id, estado, expires_at);
CREATE INDEX idx_recomendaciones_producto ON recomendaciones (emp_id, prd_id);
CREATE INDEX idx_campaign_estado_fecha ON campaigns (emp_id, estado, start_date, end_date);
CREATE INDEX idx_campaign_recipient_cliente ON campaign_recipients (emp_id, cli_id, created_at);
CREATE INDEX idx_campaign_recipient_conversion ON campaign_recipients (emp_id, converted_at, venta_id);
CREATE INDEX idx_campaign_recipient_canal ON campaign_recipients (can_id);
CREATE INDEX idx_comunicacion_cliente_fecha ON communicaciones (emp_id, cli_id, created_at);
CREATE INDEX idx_comunicacion_recipient ON communicaciones (cpg_recipient_id);
CREATE INDEX idx_comunicacion_provider ON communicaciones (provider_message_id);
CREATE INDEX idx_cupon_canjes_cupon_fecha ON cupon_canjes (emp_id, cup_id, fecha_canjes);
CREATE INDEX idx_cupon_canjes_cliente ON cupon_canjes (emp_id, cli_id, fecha_canjes);
CREATE INDEX idx_auditoria_empresa_fecha ON auditoria_logs (emp_id, adl_fecha_hora);
CREATE INDEX idx_auditoria_usuario_fecha ON auditoria_logs (emp_id, usu_id, adl_fecha_hora);
CREATE INDEX idx_auditoria_entidad_registro ON auditoria_logs (ade_id, adl_registro_id);
CREATE INDEX idx_imports_empresa_fecha ON imports (emp_id, created_at);
CREATE INDEX idx_import_error_import ON import_errors (emp_id, imp_id);
CREATE INDEX idx_estacionalidad_cliente ON cliente_estacionalidad (emp_id, cli_id);
CREATE INDEX idx_explicacion_prediccion ON prediccion_explicaciones (emp_id, pdc_id, orden_importancia);
CREATE INDEX idx_features_patron ON cliente_features (emp_id, pat_id);
CREATE INDEX idx_features_ratio_riesgo ON cliente_features (emp_id, ratio_riesgo_actual);

-- ================================================================
-- ACTUALIZACIÓN AUTOMÁTICA DE updated_at
-- Equivalente a ON UPDATE CURRENT_TIMESTAMP de MySQL
-- ================================================================

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_departamento_updated_at
BEFORE UPDATE ON departamento
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_provincia_updated_at
BEFORE UPDATE ON provincia
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_distrito_updated_at
BEFORE UPDATE ON distrito
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_documento_updated_at
BEFORE UPDATE ON documento
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_metodos_pago_updated_at
BEFORE UPDATE ON metodos_pago
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_canales_marketing_updated_at
BEFORE UPDATE ON canales_marketing
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_segmentos_updated_at
BEFORE UPDATE ON segmentos
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_roles_updated_at
BEFORE UPDATE ON roles
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_auditoria_entidades_updated_at
BEFORE UPDATE ON auditoria_entidades
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_auditoria_accion_updated_at
BEFORE UPDATE ON auditoria_accion
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_empresa_updated_at
BEFORE UPDATE ON empresa
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_usuario_personal_updated_at
BEFORE UPDATE ON usuario_personal
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_usuario_updated_at
BEFORE UPDATE ON usuario
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_categorias_updated_at
BEFORE UPDATE ON categorias
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_subcategorias_updated_at
BEFORE UPDATE ON subcategorias
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_producto_marca_updated_at
BEFORE UPDATE ON producto_marca
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_producto_updated_at
BEFORE UPDATE ON producto
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_producto_precios_updated_at
BEFORE UPDATE ON producto_precios
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_producto_stock_updated_at
BEFORE UPDATE ON producto_stock
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_cliente_updated_at
BEFORE UPDATE ON cliente
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_cliente_consentimientos_updated_at
BEFORE UPDATE ON cliente_consentimientos
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_ventas_updated_at
BEFORE UPDATE ON ventas
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_venta_items_updated_at
BEFORE UPDATE ON venta_items
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_cliente_segmento_updated_at
BEFORE UPDATE ON cliente_segmento
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_cliente_segmento_historial_updated_at
BEFORE UPDATE ON cliente_segmento_historial
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_cliente_features_updated_at
BEFORE UPDATE ON cliente_features
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_version_modelo_updated_at
BEFORE UPDATE ON version_modelo
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_model_metrics_updated_at
BEFORE UPDATE ON model_metrics
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_predicciones_updated_at
BEFORE UPDATE ON predicciones
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_estrategias_updated_at
BEFORE UPDATE ON estrategias
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_rules_updated_at
BEFORE UPDATE ON rules
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_cupones_updated_at
BEFORE UPDATE ON cupones
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_recomendaciones_updated_at
BEFORE UPDATE ON recomendaciones
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_campaigns_updated_at
BEFORE UPDATE ON campaigns
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_campaign_recipients_updated_at
BEFORE UPDATE ON campaign_recipients
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_communicaciones_updated_at
BEFORE UPDATE ON communicaciones
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_cupon_canjes_updated_at
BEFORE UPDATE ON cupon_canjes
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_auditoria_logs_updated_at
BEFORE UPDATE ON auditoria_logs
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_imports_updated_at
BEFORE UPDATE ON imports
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_import_errors_updated_at
BEFORE UPDATE ON import_errors
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_patrones_compra_updated_at
BEFORE UPDATE ON patrones_compra
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_cliente_estacionalidad_updated_at
BEFORE UPDATE ON cliente_estacionalidad
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_prediccion_explicaciones_updated_at
BEFORE UPDATE ON prediccion_explicaciones
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();


-- ================================================================
-- FIN DEL ESQUEMA
-- ================================================================