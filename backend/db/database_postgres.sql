-- ================================================================
-- DB_RegresaPE - Esquema base corregido y endurecido
-- Motor: MySQL 8.0+
-- Charset: utf8mb4
--
-- Principios:
--   * Multiempresa: toda entidad operativa lleva emp_id.
--   * Integridad referencial: FKs en relaciones críticas.
--   * UUID binario: UUID_TO_BIN(UUID(), 1) para mejor localidad de índice
--     con UUID v1. Para UUIDv7/ULID, la generación puede hacerse en la app.
--   * Predictivo: detalle de venta + features + modelos + predicciones.
--   * Recuperación automática: segmentos, reglas, estrategias, campañas,
--     conversiones, cupones y consentimiento por canal.
--   * Auditoría: catálogo de entidades/acciones + usuario responsable.
-- ================================================================

-- CREATE DATABASE IF NOT EXISTS DB_RegresaPE
    -- CHARACTER SET utf8mb4
    -- COLLATE utf8mb4_unicode_ci;

-- USE DB_RegresaPE;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ================================================================
-- 1. CATÁLOGOS BASE
-- ================================================================

CREATE TABLE departamento (
    dep_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(),1)),
    dep_nombre VARCHAR(100) NOT NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_departamento_nombre (dep_nombre)
) ENGINE=InnoDB;

CREATE TABLE provincia (
    prv_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    dep_id BINARY(16) NOT NULL,
    prv_nombre VARCHAR(100) NOT NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_provincia_dep_nombre (dep_id, prv_nombre),
    KEY idx_provincia_dep (dep_id),
    CONSTRAINT fk_provincia_departamento
        FOREIGN KEY (dep_id) REFERENCES departamento(dep_id)
) ENGINE=InnoDB;

CREATE TABLE distrito (
    dis_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    prv_id BINARY(16) NOT NULL,
    dis_nombre VARCHAR(100) NOT NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_distrito_prv_nombre (prv_id, dis_nombre),
    KEY idx_distrito_prv (prv_id),
    CONSTRAINT fk_distrito_provincia
        FOREIGN KEY (prv_id) REFERENCES provincia(prv_id)
) ENGINE=InnoDB;

CREATE TABLE documento (
    doc_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    doc_tipo VARCHAR(100) NOT NULL,
    doc_descripcion VARCHAR(100) NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_documento_tipo (doc_tipo)
) ENGINE=InnoDB;

CREATE TABLE metodos_pago (
    mtp_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    mtp_nombre VARCHAR(50) NOT NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_metodo_pago_nombre (mtp_nombre)
) ENGINE=InnoDB;

CREATE TABLE canales_marketing (
    can_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    can_codigo VARCHAR(30) NOT NULL,
    can_nombre VARCHAR(100) NOT NULL,
    requiere_consentimiento TINYINT(1) NOT NULL DEFAULT 1,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_canal_codigo (can_codigo),
    UNIQUE KEY uq_canal_nombre (can_nombre)
) ENGINE=InnoDB;

CREATE TABLE segmentos (
    seg_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    seg_codigo VARCHAR(50) NOT NULL,
    seg_nombre VARCHAR(100) NOT NULL,
    seg_descripcion VARCHAR(255) NULL,
    seg_tipo VARCHAR(50) NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_segmento_codigo (seg_codigo),
    UNIQUE KEY uq_segmento_nombre (seg_nombre)
) ENGINE=InnoDB;

CREATE TABLE roles (
    rol_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    rol_codigo VARCHAR(50) NOT NULL,
    rol_nombre VARCHAR(100) NOT NULL,
    rol_descripcion VARCHAR(255) NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_rol_codigo (rol_codigo),
    UNIQUE KEY uq_rol_nombre (rol_nombre)
) ENGINE=InnoDB;

CREATE TABLE auditoria_entidades (
    ade_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    ade_codigo VARCHAR(50) NOT NULL,
    ade_nombre VARCHAR(100) NOT NULL,
    ade_tabla VARCHAR(64) NOT NULL,
    ade_descripcion VARCHAR(255) NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_auditoria_entidad_codigo (ade_codigo),
    UNIQUE KEY uq_auditoria_entidad_tabla (ade_tabla)
) ENGINE=InnoDB;

CREATE TABLE auditoria_accion (
    ada_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    ada_accion VARCHAR(30) NOT NULL,
    ada_descripcion VARCHAR(255) NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_auditoria_accion (ada_accion)
) ENGINE=InnoDB;

-- ================================================================
-- 2. TENANCY / EMPRESA / USUARIOS
-- ================================================================

CREATE TABLE empresa (
    emp_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
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
    emp_logo LONGBLOB NULL,
    dep_id BINARY(16) NULL,
    prv_id BINARY(16) NULL,
    dis_id BINARY(16) NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_empresa_ruc (emp_ruc),
    KEY idx_empresa_dep (dep_id),
    KEY idx_empresa_prv (prv_id),
    KEY idx_empresa_dis (dis_id),
    CONSTRAINT fk_empresa_departamento
        FOREIGN KEY (dep_id) REFERENCES departamento(dep_id),
    CONSTRAINT fk_empresa_provincia
        FOREIGN KEY (prv_id) REFERENCES provincia(prv_id),
    CONSTRAINT fk_empresa_distrito
        FOREIGN KEY (dis_id) REFERENCES distrito(dis_id)
) ENGINE=InnoDB;

CREATE TABLE usuario_personal (
    usp_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    usp_dni VARCHAR(8) NULL,
    usp_nombres VARCHAR(255) NOT NULL,
    usp_celular VARCHAR(20) NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_usuario_personal_emp_dni (emp_id, usp_dni),
    UNIQUE KEY uq_usuario_personal_emp_id (emp_id, usp_id),
    KEY idx_usuario_personal_emp (emp_id),
    CONSTRAINT fk_usuario_personal_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id)
) ENGINE=InnoDB;

CREATE TABLE usuario (
    usu_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    usu_usuario VARCHAR(100) NOT NULL,
    usu_password_hash VARCHAR(255) NOT NULL,
    usu_email VARCHAR(150) NOT NULL,
    rol_id BINARY(16) NULL,
    usp_id BINARY(16) NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_usuario_emp_usuario (emp_id, usu_usuario),
    UNIQUE KEY uq_usuario_emp_email (emp_id, usu_email),
    UNIQUE KEY uq_usuario_emp_usu (emp_id, usu_id),
    KEY idx_usuario_emp (emp_id),
    KEY idx_usuario_rol (rol_id),
    KEY idx_usuario_personal (emp_id, usp_id),
    CONSTRAINT fk_usuario_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_usuario_rol
        FOREIGN KEY (rol_id) REFERENCES roles(rol_id),
    CONSTRAINT fk_usuario_personal
        FOREIGN KEY (emp_id, usp_id) REFERENCES usuario_personal(emp_id, usp_id)
) ENGINE=InnoDB;

-- ================================================================
-- 3. CATÁLOGO COMERCIAL
-- ================================================================

CREATE TABLE categorias (
    cat_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    cat_nombre VARCHAR(100) NOT NULL,
    cat_descripcion TEXT NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_categoria_emp_nombre (emp_id, cat_nombre),
    UNIQUE KEY uq_categoria_emp_id (emp_id, cat_id),
    KEY idx_categoria_emp (emp_id),
    CONSTRAINT fk_categoria_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id)
) ENGINE=InnoDB;

CREATE TABLE producto_marca (
    prd_marca_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    prd_marca_nombre VARCHAR(100) NOT NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_marca_emp_nombre (emp_id, prd_marca_nombre),
    UNIQUE KEY uq_marca_emp_id (emp_id, prd_marca_id),
    KEY idx_marca_emp (emp_id),
    CONSTRAINT fk_marca_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id)
) ENGINE=InnoDB;

CREATE TABLE producto (
    prd_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    cat_id BINARY(16) NULL,
    prd_marca_id BINARY(16) NULL,
    prd_sku VARCHAR(100) NULL,
    prd_codbarra VARCHAR(100) NULL,
    prd_nombre VARCHAR(150) NOT NULL,
    prd_descripcion TEXT NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_producto_emp_prd (emp_id, prd_id),
    UNIQUE KEY uq_producto_emp_sku (emp_id, prd_sku),
    UNIQUE KEY uq_producto_emp_codbarra (emp_id, prd_codbarra),
    KEY idx_producto_emp (emp_id),
    KEY idx_producto_categoria (emp_id, cat_id),
    KEY idx_producto_marca (emp_id, prd_marca_id),
    CONSTRAINT fk_producto_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_producto_categoria
        FOREIGN KEY (emp_id, cat_id) REFERENCES categorias(emp_id, cat_id),
    CONSTRAINT fk_producto_marca
        FOREIGN KEY (emp_id, prd_marca_id) REFERENCES producto_marca(emp_id, prd_marca_id)
) ENGINE=InnoDB;

CREATE TABLE producto_precios (
    prd_precios_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    prd_id BINARY(16) NOT NULL,
    prd_precios DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    prd_precios_undmedida CHAR(3) NULL,
    prd_precios_undproducto VARCHAR(20) NULL,
    prd_precios_ganancia DECIMAL(10,2) NULL,
    prd_precios_lista DECIMAL(10,2) NULL,
    prd_precios_costo DECIMAL(10,2) NULL,
    fecha_inicio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_fin DATETIME NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_producto_precio_emp_id (emp_id, prd_precios_id),
    KEY idx_producto_precio_producto (emp_id, prd_id),
    KEY idx_producto_precio_vigencia (emp_id, prd_id, fecha_inicio, fecha_fin),
    CONSTRAINT fk_producto_precio_producto
        FOREIGN KEY (emp_id, prd_id) REFERENCES producto(emp_id, prd_id)
) ENGINE=InnoDB;

CREATE TABLE producto_stock (
    stock_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    prd_id BINARY(16) NOT NULL,
    stk_cantidad DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    stk_min INT NOT NULL DEFAULT 0,
    stk_max INT NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_producto_stock_producto (emp_id, prd_id),
    UNIQUE KEY uq_producto_stock_id (emp_id, stock_id),
    CONSTRAINT fk_producto_stock_producto
        FOREIGN KEY (emp_id, prd_id) REFERENCES producto(emp_id, prd_id)
) ENGINE=InnoDB;

-- ================================================================
-- 4. CLIENTES Y PRIVACIDAD / CONSENTIMIENTO
-- ================================================================

CREATE TABLE cliente (
    cli_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    doc_id BINARY(16) NOT NULL,
    cli_ndocumento VARCHAR(15) NULL,
    cli_nombre_razon_social VARCHAR(255) NOT NULL,
    cli_direccion VARCHAR(255) NULL,
    cli_email VARCHAR(150) NULL,
    cli_celular VARCHAR(30) NULL,
    cli_birthday DATE NULL,
    cli_genero TINYINT NULL,
    dep_id BINARY(16) NULL,
    prv_id BINARY(16) NULL,
    dis_id BINARY(16) NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_cliente_emp_cli (emp_id, cli_id),
    UNIQUE KEY uq_cliente_emp_documento (emp_id, doc_id, cli_ndocumento),
    UNIQUE KEY uq_cliente_emp_email (emp_id, cli_email),
    KEY idx_cliente_emp (emp_id),
    KEY idx_cliente_doc (emp_id, doc_id, cli_ndocumento),
    KEY idx_cliente_ubicacion (dep_id, prv_id, dis_id),
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
) ENGINE=InnoDB;

CREATE TABLE cliente_consentimientos (
    cco_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    cli_id BINARY(16) NOT NULL,
    can_id BINARY(16) NOT NULL,
    consentimiento TINYINT(1) NOT NULL DEFAULT 0,
    fecha_otorgado DATETIME NULL,
    fecha_revocado DATETIME NULL,
    fuente VARCHAR(100) NULL,
    evidencia VARCHAR(255) NULL,
    version_politica VARCHAR(50) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_consentimiento_cliente_canal (emp_id, cli_id, can_id),
    KEY idx_consentimiento_canal (can_id),
    CONSTRAINT fk_consentimiento_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_consentimiento_cliente
        FOREIGN KEY (emp_id, cli_id) REFERENCES cliente(emp_id, cli_id),
    CONSTRAINT fk_consentimiento_canal
        FOREIGN KEY (can_id) REFERENCES canales_marketing(can_id)
) ENGINE=InnoDB;

-- ================================================================
-- 5. VENTAS / DETALLE LINEA A LINEA
-- ================================================================

CREATE TABLE ventas (
    venta_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    cli_id BINARY(16) NOT NULL,
    ven_descuento DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    ven_total DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    mtp_id BINARY(16) NULL,
    cupon_id BINARY(16) NULL,
    venta_origen VARCHAR(50) NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_venta_emp_id (emp_id, venta_id),
    KEY idx_ventas_cliente_fecha (emp_id, cli_id, created_at),
    KEY idx_ventas_fecha (emp_id, created_at),
    KEY idx_ventas_mtp (mtp_id),
    CONSTRAINT fk_ventas_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_ventas_cliente
        FOREIGN KEY (emp_id, cli_id) REFERENCES cliente(emp_id, cli_id),
    CONSTRAINT fk_ventas_metodo_pago
        FOREIGN KEY (mtp_id) REFERENCES metodos_pago(mtp_id)
) ENGINE=InnoDB;

CREATE TABLE venta_items (
    ven_item_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    venta_id BINARY(16) NOT NULL,
    prd_id BINARY(16) NOT NULL,
    cantidad DECIMAL(12,3) NOT NULL DEFAULT 1.000,
    precio_unitario DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    descuento DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    subtotal DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    costo_unitario DECIMAL(14,2) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_venta_item_emp_id (emp_id, ven_item_id),
    KEY idx_venta_item_venta (emp_id, venta_id),
    KEY idx_venta_item_producto (emp_id, prd_id),
    CONSTRAINT fk_venta_item_venta
        FOREIGN KEY (emp_id, venta_id) REFERENCES ventas(emp_id, venta_id),
    CONSTRAINT fk_venta_item_producto
        FOREIGN KEY (emp_id, prd_id) REFERENCES producto(emp_id, prd_id)
) ENGINE=InnoDB;

-- ================================================================
-- 6. SEGMENTACIÓN + FEATURES PARA IA
-- ================================================================

CREATE TABLE cliente_segmento (
    cli_segmento_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    cli_id BINARY(16) NOT NULL,
    seg_id BINARY(16) NOT NULL,
    puntuacion DECIMAL(8,5) NULL,
    fecha_asignacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_cliente_segmento_actual (emp_id, cli_id),
    KEY idx_cliente_segmento_seg (seg_id),
    CONSTRAINT fk_cliente_segmento_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_cliente_segmento_cliente
        FOREIGN KEY (emp_id, cli_id) REFERENCES cliente(emp_id, cli_id),
    CONSTRAINT fk_cliente_segmento_catalogo
        FOREIGN KEY (seg_id) REFERENCES segmentos(seg_id)
) ENGINE=InnoDB;

CREATE TABLE cliente_segmento_historial (
    csh_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    cli_id BINARY(16) NOT NULL,
    seg_anterior_id BINARY(16) NULL,
    seg_nuevo_id BINARY(16) NOT NULL,
    puntuacion_anterior DECIMAL(8,5) NULL,
    puntuacion_nueva DECIMAL(8,5) NULL,
    motivo VARCHAR(150) NULL,
    changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    KEY idx_segmento_hist_cliente_fecha (emp_id, cli_id, changed_at),
    KEY idx_segmento_hist_nuevo (seg_nuevo_id),
    CONSTRAINT fk_segmento_hist_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_segmento_hist_cliente
        FOREIGN KEY (emp_id, cli_id) REFERENCES cliente(emp_id, cli_id),
    CONSTRAINT fk_segmento_hist_anterior
        FOREIGN KEY (seg_anterior_id) REFERENCES segmentos(seg_id),
    CONSTRAINT fk_segmento_hist_nuevo
        FOREIGN KEY (seg_nuevo_id) REFERENCES segmentos(seg_id)
) ENGINE=InnoDB;

CREATE TABLE cliente_features (
    cft_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    cli_id BINARY(16) NOT NULL,
    fecha_snapshot DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    recencia_dias INT NULL,
    frecuencia_30d INT NOT NULL DEFAULT 0,
    frecuencia_90d INT NOT NULL DEFAULT 0,
    frecuencia_365d INT NOT NULL DEFAULT 0,
    ticket_promedio DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    gasto_total_30d DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    gasto_total_90d DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    gasto_total_365d DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    dias_desde_ultima_compra INT NULL,
    categoria_favorita_id BINARY(16) NULL,
    producto_favorito_id BINARY(16) NULL,
    margen_estimado_90d DECIMAL(14,2) NULL,
    descuento_promedio_90d DECIMAL(14,2) NULL,
    valor_vida_estimado DECIMAL(14,2) NULL,
    score_churn DECIMAL(8,5) NULL,
    metadata JSON NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_features_cliente_snapshot (emp_id, cli_id, fecha_snapshot),
    KEY idx_features_cliente_fecha (emp_id, cli_id, fecha_snapshot),
    KEY idx_features_churn (emp_id, score_churn),
    CONSTRAINT fk_features_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_features_cliente
        FOREIGN KEY (emp_id, cli_id) REFERENCES cliente(emp_id, cli_id),
    CONSTRAINT fk_features_categoria
        FOREIGN KEY (emp_id, categoria_favorita_id) REFERENCES categorias(emp_id, cat_id),
    CONSTRAINT fk_features_producto
        FOREIGN KEY (emp_id, producto_favorito_id) REFERENCES producto(emp_id, prd_id)
) ENGINE=InnoDB;

-- ================================================================
-- 7. MODELOS Y PREDICCIONES
-- ================================================================

CREATE TABLE version_modelo (
    vrm_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    vrm_name VARCHAR(100) NOT NULL,
    vrm_version VARCHAR(50) NOT NULL,
    vrm_algorithm VARCHAR(100) NULL,
    trained_at TIMESTAMP NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    metadata JSON NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_modelo_emp_version (emp_id, vrm_name, vrm_version),
    UNIQUE KEY uq_modelo_emp_id (emp_id, vrm_id),
    CONSTRAINT fk_modelo_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id)
) ENGINE=InnoDB;

CREATE TABLE model_metrics (
    mdm_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    vrm_id BINARY(16) NOT NULL,
    mdm_metric_name VARCHAR(100) NOT NULL,
    mdm_metric_value DECIMAL(12,6) NOT NULL,
    evaluation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    metadata JSON NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    KEY idx_model_metrics_model_date (emp_id, vrm_id, evaluation_date),
    CONSTRAINT fk_model_metrics_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_model_metrics_modelo
        FOREIGN KEY (emp_id, vrm_id) REFERENCES version_modelo(emp_id, vrm_id)
) ENGINE=InnoDB;

CREATE TABLE predicciones (
    pdc_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    cli_id BINARY(16) NOT NULL,
    vrm_id BINARY(16) NULL,
    pdc_tipo_prediccion VARCHAR(50) NOT NULL,
    pdc_prob_abandono DECIMAL(8,5) NULL,
    pdc_valor DECIMAL(14,2) NULL,
    pdc_fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NULL,
    metadata JSON NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_prediccion_emp_id (emp_id, pdc_id),
    KEY idx_predicciones_cliente_fecha (emp_id, cli_id, pdc_fecha),
    KEY idx_predicciones_tipo (emp_id, pdc_tipo_prediccion, pdc_fecha),
    KEY idx_predicciones_modelo (emp_id, vrm_id),
    CONSTRAINT fk_predicciones_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_predicciones_cliente
        FOREIGN KEY (emp_id, cli_id) REFERENCES cliente(emp_id, cli_id),
    CONSTRAINT fk_predicciones_modelo
        FOREIGN KEY (emp_id, vrm_id) REFERENCES version_modelo(emp_id, vrm_id)
) ENGINE=InnoDB;

-- ================================================================
-- 8. MOTOR DE REGLAS + ESTRATEGIAS DE MARKETING
-- ================================================================

CREATE TABLE estrategias (
    est_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    est_nombre VARCHAR(150) NOT NULL,
    est_descripcion TEXT NULL,
    est_objetivo VARCHAR(100) NULL,
    est_action_type VARCHAR(50) NULL,
    configuracion JSON NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_estrategia_emp_nombre (emp_id, est_nombre),
    UNIQUE KEY uq_estrategia_emp_id (emp_id, est_id),
    CONSTRAINT fk_estrategia_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id)
) ENGINE=InnoDB;

CREATE TABLE rules (
    rle_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    est_id BINARY(16) NULL,
    rle_nombre VARCHAR(150) NOT NULL,
    rle_descripcion TEXT NULL,
    rle_rule_type VARCHAR(50) NOT NULL,
    rle_condiciones JSON NOT NULL,
    rle_acciones JSON NULL,
    rle_prioridad INT NOT NULL DEFAULT 1,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_rule_emp_nombre (emp_id, rle_nombre),
    KEY idx_rule_emp_prioridad (emp_id, estado, rle_prioridad),
    CONSTRAINT fk_rule_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_rule_estrategia
        FOREIGN KEY (emp_id, est_id) REFERENCES estrategias(emp_id, est_id)
) ENGINE=InnoDB;

-- ================================================================
-- 9. CUPONES / OFERTAS / RECOMENDACIONES
-- ================================================================

CREATE TABLE cupones (
    cup_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    cup_codigo VARCHAR(80) NOT NULL,
    cup_nombre VARCHAR(150) NOT NULL,
    cup_tipo VARCHAR(20) NOT NULL,
    cup_valor DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    cup_min_compra DECIMAL(14,2) NULL,
    cup_max_descuento DECIMAL(14,2) NULL,
    cup_limite_uso_total INT NULL,
    cup_limite_uso_cliente INT NULL DEFAULT 1,
    cup_usos_actuales INT NOT NULL DEFAULT 0,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_cupon_emp_codigo (emp_id, cup_codigo),
    UNIQUE KEY uq_cupon_emp_id (emp_id, cup_id),
    KEY idx_cupon_vigencia (emp_id, estado, fecha_inicio, fecha_fin),
    CONSTRAINT fk_cupon_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id)
) ENGINE=InnoDB;

ALTER TABLE ventas
    ADD CONSTRAINT fk_ventas_cupon
        FOREIGN KEY (emp_id, cupon_id) REFERENCES cupones(emp_id, cup_id);

CREATE TABLE recomendaciones (
    rec_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    cli_id BINARY(16) NOT NULL,
    est_id BINARY(16) NOT NULL,
    pdc_id BINARY(16) NOT NULL,
    prd_id BINARY(16) NULL,
    cup_id BINARY(16) NULL,
    rec_titulo VARCHAR(200) NOT NULL,
    rec_descripcion TEXT NULL,
    prioridad INT NOT NULL DEFAULT 1,
    rec_accion_recomendada TEXT NULL,
    recommended_offer DECIMAL(14,2) NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    expires_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_recomendacion_emp_id (emp_id, rec_id),
    KEY idx_recomendaciones_cliente_estado (emp_id, cli_id, estado, expires_at),
    KEY idx_recomendaciones_producto (emp_id, prd_id),
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
) ENGINE=InnoDB;

-- ================================================================
-- 10. CAMPAÑAS / DESTINATARIOS / CONVERSIÓN
-- ================================================================

CREATE TABLE campaigns (
    cpg_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    est_id BINARY(16) NULL,
    can_id BINARY(16) NOT NULL,
    cpg_name VARCHAR(150) NOT NULL,
    cpg_description TEXT NULL,
    cpg_subject VARCHAR(200) NULL,
    cpg_content TEXT NULL,
    cpg_budget DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    start_date DATETIME NULL,
    end_date DATETIME NULL,
    estado TINYINT NOT NULL DEFAULT 3,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_campaign_emp_id (emp_id, cpg_id),
    UNIQUE KEY uq_campaign_emp_nombre (emp_id, cpg_name),
    KEY idx_campaign_estado_fecha (emp_id, estado, start_date, end_date),
    CONSTRAINT fk_campaign_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_campaign_estrategia
        FOREIGN KEY (emp_id, est_id) REFERENCES estrategias(emp_id, est_id),
    CONSTRAINT fk_campaign_canal
        FOREIGN KEY (can_id) REFERENCES canales_marketing(can_id)
) ENGINE=InnoDB;

CREATE TABLE campaign_recipients (
    cpg_recipient_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    cpg_id BINARY(16) NOT NULL,
    cli_id BINARY(16) NOT NULL,
    can_id BINARY(16) NOT NULL,
    rec_id BINARY(16) NULL,
    estado TINYINT NOT NULL DEFAULT 2,
    sent_at TIMESTAMP NULL,
    delivered_at TIMESTAMP NULL,
    opened_at TIMESTAMP NULL,
    clicked_at TIMESTAMP NULL,
    converted_at TIMESTAMP NULL,
    venta_id BINARY(16) NULL,
    conversion_value DECIMAL(14,2) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_campaign_recipient_emp_id (emp_id, cpg_recipient_id),
    UNIQUE KEY uq_campaign_recipient_cliente (emp_id, cpg_id, cli_id),
    KEY idx_campaign_recipient_cliente (emp_id, cli_id, created_at),
    KEY idx_campaign_recipient_conversion (emp_id, converted_at, venta_id),
    KEY idx_campaign_recipient_canal (can_id),
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
) ENGINE=InnoDB;

CREATE TABLE communicaciones (
    com_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    cli_id BINARY(16) NOT NULL,
    cpg_recipient_id BINARY(16) NULL,
    can_id BINARY(16) NOT NULL,
    com_asunto VARCHAR(200) NULL,
    com_contenido TEXT NOT NULL,
    provider_message_id VARCHAR(150) NULL,
    estado TINYINT NOT NULL DEFAULT 2,
    sent_at TIMESTAMP NULL,
    delivered_at TIMESTAMP NULL,
    opened_at TIMESTAMP NULL,
    clicked_at TIMESTAMP NULL,
    converted_at TIMESTAMP NULL,
    venta_id BINARY(16) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    KEY idx_comunicacion_cliente_fecha (emp_id, cli_id, created_at),
    KEY idx_comunicacion_recipient (cpg_recipient_id),
    KEY idx_comunicacion_provider (provider_message_id),
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
) ENGINE=InnoDB;

-- ================================================================
-- 11. CANJES DE CUPONES
-- ================================================================

CREATE TABLE cupon_canjes (
    ccn_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    cup_id BINARY(16) NOT NULL,
    cli_id BINARY(16) NOT NULL,
    venta_id BINARY(16) NULL,
    cpg_recipient_id BINARY(16) NULL,
    fecha_canjes DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    importe_descuento DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_cupon_canje_cliente_venta (emp_id, cup_id, cli_id, venta_id),
    KEY idx_cupon_canjes_cupon_fecha (emp_id, cup_id, fecha_canjes),
    KEY idx_cupon_canjes_cliente (emp_id, cli_id, fecha_canjes),
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
) ENGINE=InnoDB;

-- ================================================================
-- 12. AUDITORÍA + IMPORTACIONES
-- ================================================================

CREATE TABLE auditoria_logs (
    adl_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    usu_id BINARY(16) NOT NULL,
    ade_id BINARY(16) NOT NULL,
    ada_id BINARY(16) NOT NULL,
    adl_tabla VARCHAR(64) NOT NULL,
    adl_registro_id VARCHAR(100) NOT NULL,
    adl_usuario VARCHAR(100) NOT NULL,
    adl_fecha_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    adl_valor_anterior JSON NULL,
    adl_valor_nuevo JSON NULL,
    ip_address VARCHAR(45) NULL,
    user_agent TEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY idx_auditoria_empresa_fecha (emp_id, adl_fecha_hora),
    KEY idx_auditoria_usuario_fecha (emp_id, usu_id, adl_fecha_hora),
    KEY idx_auditoria_entidad_registro (ade_id, adl_registro_id),
    CONSTRAINT fk_auditoria_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_auditoria_usuario
        FOREIGN KEY (emp_id, usu_id) REFERENCES usuario(emp_id, usu_id),
    CONSTRAINT fk_auditoria_entidad
        FOREIGN KEY (ade_id) REFERENCES auditoria_entidades(ade_id),
    CONSTRAINT fk_auditoria_accion
        FOREIGN KEY (ada_id) REFERENCES auditoria_accion(ada_id)
) ENGINE=InnoDB;

CREATE TABLE imports (
    imp_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    usu_id BINARY(16) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_type VARCHAR(50) NULL,
    total_rows INT NOT NULL DEFAULT 0,
    successful_rows INT NOT NULL DEFAULT 0,
    failed_rows INT NOT NULL DEFAULT 0,
    estado TINYINT NOT NULL DEFAULT 2,
    started_at TIMESTAMP NULL,
    completed_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    KEY idx_imports_empresa_fecha (emp_id, created_at),
    CONSTRAINT fk_import_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_import_usuario
        FOREIGN KEY (emp_id, usu_id) REFERENCES usuario(emp_id, usu_id)
) ENGINE=InnoDB;

CREATE TABLE import_errors (
    imp_error_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    imp_id BINARY(16) NOT NULL,
    imp_error_row_number INT NULL,
    imp_error_field_name VARCHAR(100) NULL,
    error_type VARCHAR(100) NULL,
    error_message TEXT NOT NULL,
    raw_data JSON NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    KEY idx_import_error_import (emp_id, imp_id),
    CONSTRAINT fk_import_error_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
	CONSTRAINT fk_import_error_import
    FOREIGN KEY (imp_id)
    REFERENCES imports(imp_id)
) ENGINE=InnoDB;

-- ================================================================
-- 13. FKs adicionales para referencias tardías por dependencia
-- ================================================================

SET FOREIGN_KEY_CHECKS = 1;


-- ================================================================
-- 14. DATOS BASE DE CATÁLOGOS GLOBALES
-- ================================================================

INSERT IGNORE INTO canales_marketing (can_id, can_codigo, can_nombre, requiere_consentimiento, estado)
VALUES
    (UUID_TO_BIN(UUID(), 1), 'EMAIL', 'Correo electrónico', 1, 1),
    (UUID_TO_BIN(UUID(), 1), 'SMS', 'SMS', 1, 1),
    (UUID_TO_BIN(UUID(), 1), 'WHATSAPP', 'WhatsApp', 1, 1),
    (UUID_TO_BIN(UUID(), 1), 'PUSH', 'Notificación push', 1, 1);

INSERT IGNORE INTO segmentos (seg_id, seg_codigo, seg_nombre, seg_descripcion, seg_tipo, estado)
VALUES
    (UUID_TO_BIN(UUID(), 1), 'NUEVO', 'Nuevo', 'Cliente con pocas o ninguna compra histórica.', 'CICLO_VIDA', 1),
    (UUID_TO_BIN(UUID(), 1), 'ACTIVO', 'Activo', 'Cliente con actividad reciente.', 'CICLO_VIDA', 1),
    (UUID_TO_BIN(UUID(), 1), 'EN_RIESGO', 'En riesgo', 'Cliente con señales de pérdida de actividad.', 'CHURN', 1),
    (UUID_TO_BIN(UUID(), 1), 'PERDIDO', 'Perdido', 'Cliente sin compras durante un periodo definido.', 'CHURN', 1),
    (UUID_TO_BIN(UUID(), 1), 'RECUPERADO', 'Recuperado', 'Cliente que volvió a comprar después de una señal de riesgo o pérdida.', 'RECUPERACION', 1),
    (UUID_TO_BIN(UUID(), 1), 'LEAL', 'Leal', 'Cliente de alta recurrencia o valor.', 'VALOR', 1);

INSERT IGNORE INTO roles (rol_id, rol_codigo, rol_nombre, rol_descripcion, estado)
VALUES
    (UUID_TO_BIN(UUID(), 1), 'SUPERADMIN', 'Super administrador', 'Administración técnica global.', 1),
    (UUID_TO_BIN(UUID(), 1), 'ADMIN_EMPRESA', 'Administrador de empresa', 'Administración de una empresa/tenant.', 1),
    (UUID_TO_BIN(UUID(), 1), 'MARKETING', 'Marketing', 'Gestión de campañas, segmentos y recuperación.', 1),
    (UUID_TO_BIN(UUID(), 1), 'OPERADOR', 'Operador', 'Operación comercial y consultas.', 1),
    (UUID_TO_BIN(UUID(), 1), 'AUDITOR', 'Auditor', 'Consulta de trazabilidad y auditoría.', 1);

INSERT IGNORE INTO auditoria_accion (ada_id, ada_accion, ada_descripcion, estado)
VALUES
    (UUID_TO_BIN(UUID(), 1), 'INSERT', 'Creación de registro.', 1),
    (UUID_TO_BIN(UUID(), 1), 'UPDATE', 'Actualización de registro.', 1),
    (UUID_TO_BIN(UUID(), 1), 'DELETE', 'Eliminación de registro.', 1),
    (UUID_TO_BIN(UUID(), 1), 'LOGIN', 'Inicio de sesión.', 1),
    (UUID_TO_BIN(UUID(), 1), 'LOGOUT', 'Cierre de sesión.', 1),
    (UUID_TO_BIN(UUID(), 1), 'EXPORT', 'Exportación de información.', 1),
    (UUID_TO_BIN(UUID(), 1), 'IMPORT', 'Importación de información.', 1),
    (UUID_TO_BIN(UUID(), 1), 'CAMPAIGN_SEND', 'Ejecución de campaña.', 1),
    (UUID_TO_BIN(UUID(), 1), 'COUPON_REDEEM', 'Canje de cupón.', 1);

-- ================================================================
-- FIN DEL ESQUEMA
-- ================================================================

SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE patrones_compra (
    pat_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    pat_codigo VARCHAR(30) NOT NULL,
    pat_nombre VARCHAR(100) NOT NULL,
    pat_descripcion VARCHAR(255) NULL,
    estado TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_patron_codigo (pat_codigo),
    UNIQUE KEY uq_patron_nombre (pat_nombre)
) ENGINE=InnoDB;

INSERT IGNORE INTO patrones_compra (pat_id, pat_codigo, pat_nombre, pat_descripcion, estado)
VALUES
    (UUID_TO_BIN(UUID(), 1), 'UNICA', 'Compra única',
        'Cliente con una sola compra histórica; aún sin patrón definido.', 1),
    (UUID_TO_BIN(UUID(), 1), 'CASUAL', 'Casual',
        'Compras irregulares, sin intervalo predecible entre ellas (CV alto).', 1),
    (UUID_TO_BIN(UUID(), 1), 'RECURRENTE', 'Recurrente',
        'Compras frecuentes con intervalo regular y predecible (CV bajo).', 1),
    (UUID_TO_BIN(UUID(), 1), 'ESTACIONAL', 'Estacional',
        'Compras concentradas en los mismos meses del año, repetidas en distintos años.', 1),
    (UUID_TO_BIN(UUID(), 1), 'DESCONOCIDO', 'Desconocido',
        'Historial insuficiente para determinar un patrón (menos de 2-3 compras).', 1);

ALTER TABLE cliente_features
    ADD COLUMN total_compras_historicas INT NOT NULL DEFAULT 0
        AFTER frecuencia_365d,
    ADD COLUMN intervalo_promedio_dias DECIMAL(8,2) NULL
        AFTER total_compras_historicas,
    ADD COLUMN intervalo_desviacion_dias DECIMAL(8,2) NULL
        AFTER intervalo_promedio_dias,
    ADD COLUMN intervalo_cv DECIMAL(6,4) NULL
        COMMENT 'Coef. de variación = desviación / promedio. Bajo=regular, alto=errático'
        AFTER intervalo_desviacion_dias,
    ADD COLUMN pat_id BINARY(16) NULL
        AFTER intervalo_cv,
    ADD COLUMN ratio_riesgo_actual DECIMAL(8,4) NULL
        COMMENT 'dias_desde_ultima_compra / intervalo_promedio_dias del propio cliente'
        AFTER pat_id,
    ADD KEY idx_features_patron (emp_id, pat_id),
    ADD KEY idx_features_ratio_riesgo (emp_id, ratio_riesgo_actual),
    ADD CONSTRAINT fk_features_patron
        FOREIGN KEY (pat_id) REFERENCES patrones_compra(pat_id);


CREATE TABLE cliente_estacionalidad (
    ces_id BINARY(16) NOT NULL PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),
    emp_id BINARY(16) NOT NULL,
    cli_id BINARY(16) NOT NULL,
    mes TINYINT NOT NULL,
    num_compras_historicas INT NOT NULL DEFAULT 0,
    gasto_total_mes DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    gasto_promedio_mes DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    ultima_actualizacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,
    UNIQUE KEY uq_estacionalidad_cliente_mes (emp_id, cli_id, mes),
    KEY idx_estacionalidad_cliente (emp_id, cli_id),
    CONSTRAINT chk_estacionalidad_mes CHECK (mes BETWEEN 1 AND 12),
    CONSTRAINT fk_estacionalidad_empresa
        FOREIGN KEY (emp_id) REFERENCES empresa(emp_id),
    CONSTRAINT fk_estacionalidad_cliente
        FOREIGN KEY (emp_id, cli_id) REFERENCES cliente(emp_id, cli_id)
) ENGINE=InnoDB;

CREATE TABLE tipos_direccion_explicacion (
    tde_id BINARY(16) NOT NULL PRIMARY KEY
        DEFAULT (UUID_TO_BIN(UUID(), 1)),

    emp_id BINARY(16) NOT NULL,
    codigo VARCHAR(50) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1,

    UNIQUE KEY uq_tipo_direccion_empresa_id (
        emp_id,
        tde_id
    ),

    UNIQUE KEY uq_tipo_direccion_codigo (
        emp_id,
        codigo
    ),

    CONSTRAINT fk_tipo_direccion_empresa
        FOREIGN KEY (emp_id)
        REFERENCES empresa(emp_id)
) ENGINE=InnoDB;

CREATE TABLE prediccion_explicaciones (
    pex_id BINARY(16) NOT NULL PRIMARY KEY
        DEFAULT (UUID_TO_BIN(UUID(), 1)),

    emp_id BINARY(16) NOT NULL,
    pdc_id BINARY(16) NOT NULL,
    tde_id BINARY(16) NOT NULL,

    feature_nombre VARCHAR(100) NOT NULL,
    feature_valor VARCHAR(150) NULL,
    impacto DECIMAL(10,6) NOT NULL,
    orden_importancia INT NOT NULL DEFAULT 1,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    created_by VARCHAR(100) NULL,
    updated_by VARCHAR(100) NULL,

    UNIQUE KEY uq_explicacion_pdc_feature (
        emp_id,
        pdc_id,
        feature_nombre
    ),

    KEY idx_explicacion_prediccion (
        emp_id,
        pdc_id,
        orden_importancia
    ),

    CONSTRAINT fk_explicacion_empresa
        FOREIGN KEY (emp_id)
        REFERENCES empresa(emp_id),

    CONSTRAINT fk_explicacion_prediccion
        FOREIGN KEY (emp_id, pdc_id)
        REFERENCES predicciones(emp_id, pdc_id),

    CONSTRAINT fk_explicacion_tipo_direccion
        FOREIGN KEY (emp_id, tde_id)
        REFERENCES tipos_direccion_explicacion(emp_id, tde_id)

) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;