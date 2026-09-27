-- ============================================================
-- ESQUEMA DE BASE DE DATOS - Sistema Empresarial
-- Caso de uso: Empresa de ventas con clientes, productos y pedidos
-- ============================================================

-- Eliminar tablas si ya existen (para poder re-ejecutar el script)
DROP TABLE IF EXISTS detalle_pedidos CASCADE;
DROP TABLE IF EXISTS pedidos CASCADE;
DROP TABLE IF EXISTS productos CASCADE;
DROP TABLE IF EXISTS categorias CASCADE;
DROP TABLE IF EXISTS empleados CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;
DROP TABLE IF EXISTS departamentos CASCADE;

-- ─── Tabla: departamentos ──────────────────────────────────────────────────────
CREATE TABLE departamentos (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    ubicacion   VARCHAR(150),
    creado_en   TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE departamentos IS 'Departamentos de la empresa';

-- ─── Tabla: empleados ─────────────────────────────────────────────────────────
CREATE TABLE empleados (
    id               SERIAL PRIMARY KEY,
    nombre           VARCHAR(100) NOT NULL,
    apellido         VARCHAR(100) NOT NULL,
    email            VARCHAR(150) UNIQUE NOT NULL,
    cargo            VARCHAR(100),
    salario          NUMERIC(10, 2),
    departamento_id  INTEGER REFERENCES departamentos(id) ON DELETE SET NULL,
    activo           BOOLEAN DEFAULT TRUE,
    fecha_ingreso    DATE DEFAULT CURRENT_DATE,
    creado_en        TIMESTAMP DEFAULT NOW(),
    actualizado_en   TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE empleados IS 'Personal de la empresa';

-- ─── Tabla: clientes ──────────────────────────────────────────────────────────
CREATE TABLE clientes (
    id             SERIAL PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL,
    apellido       VARCHAR(100),
    email          VARCHAR(150) UNIQUE NOT NULL,
    telefono       VARCHAR(20),
    empresa        VARCHAR(150),
    ciudad         VARCHAR(100),
    pais           VARCHAR(100) DEFAULT 'México',
    activo         BOOLEAN DEFAULT TRUE,
    creado_en      TIMESTAMP DEFAULT NOW(),
    actualizado_en TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE clientes IS 'Clientes que realizan compras';

-- ─── Tabla: categorias ────────────────────────────────────────────────────────
CREATE TABLE categorias (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    creado_en   TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE categorias IS 'Categorías de productos';

-- ─── Tabla: productos ─────────────────────────────────────────────────────────
CREATE TABLE productos (
    id             SERIAL PRIMARY KEY,
    nombre         VARCHAR(200) NOT NULL,
    descripcion    TEXT,
    precio         NUMERIC(10, 2) NOT NULL CHECK (precio >= 0),
    stock          INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    categoria_id   INTEGER REFERENCES categorias(id) ON DELETE SET NULL,
    sku            VARCHAR(50) UNIQUE,
    activo         BOOLEAN DEFAULT TRUE,
    creado_en      TIMESTAMP DEFAULT NOW(),
    actualizado_en TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE productos IS 'Catálogo de productos disponibles';

-- ─── Tabla: pedidos ───────────────────────────────────────────────────────────
CREATE TABLE pedidos (
    id              SERIAL PRIMARY KEY,
    cliente_id      INTEGER NOT NULL REFERENCES clientes(id) ON DELETE RESTRICT,
    empleado_id     INTEGER REFERENCES empleados(id) ON DELETE SET NULL,
    estado          VARCHAR(50) DEFAULT 'pendiente'
                    CHECK (estado IN ('pendiente', 'procesando', 'enviado', 'entregado', 'cancelado')),
    total           NUMERIC(12, 2) DEFAULT 0,
    notas           TEXT,
    fecha_pedido    TIMESTAMP DEFAULT NOW(),
    fecha_entrega   TIMESTAMP,
    creado_en       TIMESTAMP DEFAULT NOW(),
    actualizado_en  TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE pedidos IS 'Órdenes de compra de los clientes';

-- ─── Tabla: detalle_pedidos ────────────────────────────────────────────────────
CREATE TABLE detalle_pedidos (
    id           SERIAL PRIMARY KEY,
    pedido_id    INTEGER NOT NULL REFERENCES pedidos(id) ON DELETE CASCADE,
    producto_id  INTEGER NOT NULL REFERENCES productos(id) ON DELETE RESTRICT,
    cantidad     INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unit  NUMERIC(10, 2) NOT NULL,
    subtotal     NUMERIC(12, 2) GENERATED ALWAYS AS (cantidad * precio_unit) STORED
);

COMMENT ON TABLE detalle_pedidos IS 'Productos incluidos en cada pedido';

-- ─── Índices para mejorar rendimiento ─────────────────────────────────────────
CREATE INDEX idx_empleados_departamento ON empleados(departamento_id);
CREATE INDEX idx_pedidos_cliente        ON pedidos(cliente_id);
CREATE INDEX idx_pedidos_estado         ON pedidos(estado);
CREATE INDEX idx_productos_categoria    ON productos(categoria_id);
CREATE INDEX idx_detalle_pedido         ON detalle_pedidos(pedido_id);
