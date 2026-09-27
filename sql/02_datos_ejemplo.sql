-- ============================================================
-- DATOS DE EJEMPLO - Sistema Empresarial
-- ============================================================

-- ─── Departamentos ────────────────────────────────────────────────────────────
INSERT INTO departamentos (nombre, ubicacion) VALUES
    ('Ventas',          'Piso 1 - Edificio A'),
    ('Tecnología',      'Piso 3 - Edificio B'),
    ('Recursos Humanos','Piso 2 - Edificio A'),
    ('Finanzas',        'Piso 4 - Edificio A'),
    ('Logística',       'Bodega Central');

-- ─── Empleados ────────────────────────────────────────────────────────────────
INSERT INTO empleados (nombre, apellido, email, cargo, salario, departamento_id) VALUES
    ('Ana',      'García',    'ana.garcia@empresa.com',    'Gerente de Ventas',   55000.00, 1),
    ('Luis',     'Martínez',  'luis.martinez@empresa.com', 'Desarrollador Senior',68000.00, 2),
    ('María',    'López',     'maria.lopez@empresa.com',   'Analista RRHH',       42000.00, 3),
    ('Carlos',   'Hernández', 'carlos.h@empresa.com',      'Contador',            47000.00, 4),
    ('Sofía',    'Ramírez',   'sofia.r@empresa.com',       'Vendedora',           35000.00, 1),
    ('Diego',    'Torres',    'diego.t@empresa.com',       'DevOps Engineer',     72000.00, 2),
    ('Valeria',  'Flores',    'valeria.f@empresa.com',     'Jefa de Logística',   50000.00, 5);

-- ─── Clientes ─────────────────────────────────────────────────────────────────
INSERT INTO clientes (nombre, apellido, email, telefono, empresa, ciudad, pais) VALUES
    ('Roberto',   'Sánchez',  'roberto.s@gmail.com',     '555-1234', 'TechSolutions SA',       'Ciudad de México', 'México'),
    ('Elena',     'Morales',  'elena.m@hotmail.com',     '555-5678', 'Distribuidora Norte',    'Monterrey',        'México'),
    ('Pablo',     'Jiménez',  'pablo.j@outlook.com',     '555-9012', 'Grupo Industrial PJ',    'Guadalajara',      'México'),
    ('Lucía',     'Vargas',   'lucia.v@empresa.mx',      '555-3456', 'Importaciones LV',       'Puebla',           'México'),
    ('Fernando',  'Castro',   'fernando.c@gmail.com',    '555-7890', 'Comercial FC',           'Tijuana',          'México'),
    ('Isabella',  'Medina',   'isabella.m@corp.com',     '555-2345', 'MedinaGroup Corp',       'Bogotá',           'Colombia'),
    ('Andrés',    'Ruiz',     'andres.r@negocios.com',   '555-6789', NULL,                     'Lima',             'Perú');

-- ─── Categorías ───────────────────────────────────────────────────────────────
INSERT INTO categorias (nombre, descripcion) VALUES
    ('Electrónica',     'Dispositivos electrónicos, gadgets y accesorios tecnológicos'),
    ('Oficina',         'Mobiliario, papelería y suministros para oficina'),
    ('Software',        'Licencias de software y aplicaciones empresariales'),
    ('Servicios',       'Servicios de consultoría, soporte y mantenimiento'),
    ('Telecomunicaciones', 'Equipos y servicios de comunicación');

-- ─── Productos ────────────────────────────────────────────────────────────────
INSERT INTO productos (nombre, descripcion, precio, stock, categoria_id, sku) VALUES
    ('Laptop Dell XPS 15',       'Laptop profesional 15" Intel i7, 32GB RAM, 1TB SSD', 28999.00,  15, 1, 'DELL-XPS15-001'),
    ('Monitor LG 27" 4K',        'Monitor UHD 4K con HDR y panel IPS',                  8500.00,  30, 1, 'LG-MON27-002'),
    ('Teclado Mecánico Logitech','Teclado mecánico inalámbrico para productividad',      2200.00,  50, 1, 'LOG-TEC-003'),
    ('Silla Ergonómica Herman',  'Silla de oficina ergonómica con soporte lumbar',       12500.00, 10, 2, 'HERM-SIL-004'),
    ('Escritorio Standing Desk', 'Escritorio regulable en altura eléctrico',             18900.00,  8, 2, 'DESK-STAND-005'),
    ('Licencia Microsoft 365',   'Suscripción anual Office 365 Business Premium',        3600.00, 999, 3, 'MS365-BUS-006'),
    ('Licencia Adobe CC',        'Creative Cloud todos los apps, plan anual',            9900.00, 999, 3, 'ADOBE-CC-007'),
    ('Consultoría IT (hora)',     'Servicio de consultoría tecnológica por hora',         1500.00, 999, 4, 'CONS-IT-008'),
    ('Soporte Técnico Mensual',  'Plan de soporte técnico mensual 24/7',                 4500.00, 999, 4, 'SOPT-MEN-009'),
    ('Router Cisco Business',    'Router empresarial con gestión avanzada',              5800.00,  20, 5, 'CISCO-ROU-010'),
    ('Switch 24 puertos TP-Link','Switch de red 24 puertos Gigabit',                    3200.00,  25, 5, 'TP-SW24-011'),
    ('Webcam Logitech 4K',       'Cámara web 4K para videoconferencias',                 2800.00,  40, 1, 'LOG-WEB-012');

-- ─── Pedidos ──────────────────────────────────────────────────────────────────
INSERT INTO pedidos (cliente_id, empleado_id, estado, notas, fecha_entrega) VALUES
    (1, 5, 'entregado',  'Cliente frecuente, entrega express',      '2026-09-10 10:00:00'),
    (2, 1, 'enviado',    'Pedido corporativo para nueva oficina',   '2026-09-28 14:00:00'),
    (3, 5, 'procesando', 'Requiere factura empresarial',            '2026-10-01 09:00:00'),
    (4, 1, 'pendiente',  NULL,                                      NULL),
    (1, 5, 'entregado',  'Segunda compra del cliente',              '2026-08-20 11:00:00'),
    (5, 1, 'cancelado',  'Cliente canceló por presupuesto',         NULL),
    (6, 5, 'procesando', 'Envío internacional Colombia',            '2026-10-05 15:00:00');

-- ─── Detalles de pedidos ───────────────────────────────────────────────────────
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unit) VALUES
    -- Pedido 1 (Roberto Sánchez - entregado)
    (1, 1,  2, 28999.00),  -- 2 Laptops Dell
    (1, 3,  2,  2200.00),  -- 2 Teclados Mecánicos
    -- Pedido 2 (Elena Morales - enviado)
    (2, 4,  5, 12500.00),  -- 5 Sillas Ergonómicas
    (2, 5,  3, 18900.00),  -- 3 Standing Desks
    (2, 2,  5,  8500.00),  -- 5 Monitores
    -- Pedido 3 (Pablo Jiménez - procesando)
    (3, 6, 10,  3600.00),  -- 10 Licencias Microsoft 365
    (3, 9,  2,  4500.00),  -- 2 Planes de soporte
    -- Pedido 4 (Lucía Vargas - pendiente)
    (4, 10, 1,  5800.00),  -- 1 Router Cisco
    (4, 11, 2,  3200.00),  -- 2 Switches TP-Link
    -- Pedido 5 (Roberto Sánchez - entregado, segunda compra)
    (5, 12, 3,  2800.00),  -- 3 Webcams
    (5, 6,  5,  3600.00),  -- 5 Licencias Microsoft
    -- Pedido 7 (Isabella Medina Colombia - procesando)
    (7, 7,  3,  9900.00),  -- 3 Licencias Adobe
    (7, 8, 10,  1500.00);  -- 10 horas consultoría

-- ─── Actualizar totales de pedidos ────────────────────────────────────────────
UPDATE pedidos p
SET total = (
    SELECT COALESCE(SUM(subtotal), 0)
    FROM detalle_pedidos dp
    WHERE dp.pedido_id = p.id
);
