/*
 * ============================================================
 * SUPERMERCADO - DATASET DEMO PARA dbForge / PostgreSQL
 * Archivo: 03_db_supermercado_DML_DATASET_DEMO.sql
 * ============================================================
 *
 * Objetivo:
 *   Ampliar la BD original con un volumen moderado y coherente
 *   para demos de:
 *     - PostgreSQL Debugger
 *     - Query Profiler / planes de ejecución
 *     - Optimización SQL
 *     - dbForge AI Assistant
 *
 * Prerrequisito:
 *   Ejecutar antes:
 *     01_db_supermercado_DDL.sql
 *     02_db_supermercado_DML_INSERTS.sql
 *
 * Volumen final aproximado:
 *   - 20 proveedores
 *   - 200 productos
 *   - 30 empleados
 *   - 1,000 clientes
 *   - 10,000 facturas
 *   - 10,000 detalles de factura
 *   - 10,000 ventas
 *   - ~40,000 líneas de venta
 *   - ~10,000 relaciones compra-cliente
 *
 * IMPORTANTE:
 *   El script es re-ejecutable. Primero elimina únicamente
 *   los datos generados por este archivo usando identificadores
 *   controlados (emails de prueba y códigos P/F/B/E).
 */

BEGIN;

-- ============================================================
-- 0. VALIDACIÓN BÁSICA
-- ============================================================

DO $$
BEGIN
    IF (SELECT COUNT(*) FROM proveedores) < 8
       OR (SELECT COUNT(*) FROM productos) < 20
       OR (SELECT COUNT(*) FROM empleados) < 8
       OR (SELECT COUNT(*) FROM clientes) < 3
       OR (SELECT COUNT(*) FROM facturas) < 3
    THEN
        RAISE EXCEPTION
        'La BD base no parece estar cargada. Ejecute primero 01_db_supermercado_DDL.sql y 02_db_supermercado_DML_INSERTS.sql.';
    END IF;
END $$;


-- ============================================================
-- 1. LIMPIEZA DE DATOS DEMO DE UNA EJECUCIÓN ANTERIOR
-- ============================================================

-- Eliminar primero facturas demo.
-- Por las FK ON DELETE CASCADE también se eliminan:
-- facturas_detalles -> ventas -> ventas_productos / compras_clientes.
DELETE FROM facturas
WHERE codigo LIKE 'DEMO-%'
   OR codigo ~ '^[FBE][0-9]{5}$';

DELETE FROM productos
WHERE codigo LIKE 'DEMO-P%'
   OR codigo ~ '^P[0-9]{5}$';

DELETE FROM proveedores
WHERE email LIKE 'demo.proveedor%@supermercado.local';

DELETE FROM empleados
WHERE email LIKE 'empleado.demo%@supermercado.local';

DELETE FROM clientes
WHERE email LIKE 'cliente.demo%@supermercado.local';


-- ============================================================
-- 2. SINCRONIZAR SECUENCIAS CON LOS DATOS QUE QUEDARON
-- ============================================================

SELECT setval('id_sec_provee',   COALESCE((SELECT MAX(id) FROM proveedores), 0) + 1, false);
SELECT setval('id_sec_produc',   COALESCE((SELECT MAX(id) FROM productos), 0) + 1, false);
SELECT setval('id_sec_empl',     COALESCE((SELECT MAX(id) FROM empleados), 0) + 1, false);
SELECT setval('id_sec_cli',      COALESCE((SELECT MAX(id) FROM clientes), 0) + 1, false);
SELECT setval('id_sec_fact',     COALESCE((SELECT MAX(id) FROM facturas), 0) + 1, false);
SELECT setval('id_sec_fact_det', COALESCE((SELECT MAX(id) FROM facturas_detalles), 0) + 1, false);
SELECT setval('id_sec_vent',     COALESCE((SELECT MAX(id) FROM ventas), 0) + 1, false);
SELECT setval('id_sec_vent_prod',COALESCE((SELECT MAX(id) FROM ventas_productos), 0) + 1, false);
SELECT setval('id_sec_compr_cli',COALESCE((SELECT MAX(id) FROM compras_clientes), 0) + 1, false);


-- ============================================================
-- 3. PROVEEDORES
--    8 originales + 12 demo = 20 aprox.
-- ============================================================

INSERT INTO proveedores
    (empresa, tipo_producto, direccion, nro_tel_princ, nro_tel_sec, email)
VALUES
('Distribuidora Andina',       'Almacén y Bebidas',               'Av. Central 1200',        '+54 11 4100-1001', '-', 'demo.proveedor01@supermercado.local'),
('Alimentos del Sur',          'Almacén',                         'Calle Moreno 845',         '+54 11 4100-1002', '-', 'demo.proveedor02@supermercado.local'),
('Mercado Fresco',             'Frutas y Verduras',               'Av. Belgrano 2120',       '+54 11 4100-1003', '-', 'demo.proveedor03@supermercado.local'),
('Lácteos del Valle',          'Lácteos y Productos Frescos',     'Calle Mitre 490',         '+54 11 4100-1004', '-', 'demo.proveedor04@supermercado.local'),
('Congelados Patagónicos',     'Congelados',                      'Ruta 8 Km 42',            '+54 11 4100-1005', '-', 'demo.proveedor05@supermercado.local'),
('Carnes Premium',             'Carnes y Pescados',               'Av. Rivadavia 5510',      '+54 11 4100-1006', '-', 'demo.proveedor06@supermercado.local'),
('Higiene Total',              'Limpieza e Higiene',              'Calle Córdoba 930',       '+54 11 4100-1007', '-', 'demo.proveedor07@supermercado.local'),
('Dulces y Snacks',            'Golosinas y Snacks',              'Av. San Martín 1870',     '+54 11 4100-1008', '-', 'demo.proveedor08@supermercado.local'),
('Panificados Centro',         'Panificados',                      'Calle Tucumán 670',       '+54 11 4100-1009', '-', 'demo.proveedor09@supermercado.local'),
('Conservas del Plata',        'Conservas',                        'Av. Independencia 3100',  '+54 11 4100-1010', '-', 'demo.proveedor10@supermercado.local'),
('Bebidas Metropolitanas',     'Bebidas',                          'Calle Salta 745',         '+54 11 4100-1011', '-', 'demo.proveedor11@supermercado.local'),
('Productos Selectos',         'Almacén y Productos Frescos',      'Av. Corrientes 4200',     '+54 11 4100-1012', '-', 'demo.proveedor12@supermercado.local');


-- ============================================================
-- 4. PRODUCTOS
--    20 originales + 180 demo = 200 aprox.
-- ============================================================

WITH base AS (
    SELECT
        g,
        1 + ((g - 1) % 20) AS id_proveedor,
        'P' || LPAD(g::text, 5, '0') AS codigo,
        (ARRAY[
            'Andina','Del Sur','Buen Día','Valle','Patagonia','Selecta',
            'Natural','Clásica','Familiar','Premium','Mercado','Central'
        ])[1 + ((g - 1) % 12)] AS marca,
        CASE ((g - 1) % 12)
            WHEN 0  THEN 'Agua mineral sin gas 1.5L'
            WHEN 1  THEN 'Gaseosa cola 2.25L'
            WHEN 2  THEN 'Leche entera larga vida 1L'
            WHEN 3  THEN 'Yogur bebible natural 1L'
            WHEN 4  THEN 'Arroz largo fino 1kg'
            WHEN 5  THEN 'Fideos spaghetti 500g'
            WHEN 6  THEN 'Aceite de girasol 900ml'
            WHEN 7  THEN 'Galletas clásicas 300g'
            WHEN 8  THEN 'Atún al natural 170g'
            WHEN 9  THEN 'Helado familiar 1L'
            WHEN 10 THEN 'Manzana roja x kg'
            ELSE         'Pechuga de pollo x kg'
        END AS nombre_base,
        CASE ((g - 1) % 12)
            WHEN 0  THEN 'Bebidas'
            WHEN 1  THEN 'Bebidas'
            WHEN 2  THEN 'Lácteos y Productos Frescos'
            WHEN 3  THEN 'Lácteos y Productos Frescos'
            WHEN 4  THEN 'Almacén'
            WHEN 5  THEN 'Almacén'
            WHEN 6  THEN 'Almacén'
            WHEN 7  THEN 'Golosinas y Snacks'
            WHEN 8  THEN 'Conservas'
            WHEN 9  THEN 'Congelados'
            WHEN 10 THEN 'Frutas y Verduras'
            ELSE         'Carnes y Pescados'
        END AS tipo,
        CASE ((g - 1) % 12)
            WHEN 0  THEN 'Agua'
            WHEN 1  THEN 'Gaseosas'
            WHEN 2  THEN 'Leches'
            WHEN 3  THEN 'Yogures'
            WHEN 4  THEN 'Arroz'
            WHEN 5  THEN 'Pastas'
            WHEN 6  THEN 'Aceites'
            WHEN 7  THEN 'Galletas'
            WHEN 8  THEN 'Pescados en conserva'
            WHEN 9  THEN 'Helados'
            WHEN 10 THEN 'Frutas'
            ELSE         'Pollo y Granja'
        END AS grupo,
        CASE ((g - 1) % 12)
            WHEN 0 THEN 1.500
            WHEN 1 THEN 2.250
            WHEN 2 THEN 1.000
            WHEN 3 THEN 1.000
            WHEN 4 THEN 1.000
            WHEN 5 THEN 0.500
            WHEN 6 THEN 0.900
            WHEN 7 THEN 0.300
            WHEN 8 THEN 0.170
            WHEN 9 THEN 1.000
            ELSE 1.000
        END::numeric(8,3) AS peso
    FROM generate_series(1, 180) AS g
)
INSERT INTO productos
    (id_proveedor, codigo, imagen, nombre, marca, tipo, grupo, peso, precio_unidad, stock)
SELECT
    id_proveedor,
    codigo,
    NULL,
    nombre_base || ' - ' || marca,
    marca,
    tipo,
    grupo,
    peso,
    (40 + ((g * 71) % 9000) / 10.0)::numeric(8,3) AS precio_unidad,
    (50 + ((g * 29) % 951))::smallint AS stock
FROM base;


-- ============================================================
-- 5. EMPLEADOS
--    8 originales + 22 demo = 30 aprox.
--    Los primeros 10 nuevos empleados son cajeros/as.
-- ============================================================

WITH e AS (
    SELECT
        g,
        (ARRAY[
            'Lucía','Mateo','Valentina','Santiago','Camila','Nicolás',
            'Martina','Joaquín','Paula','Tomás','Agustina','Bruno',
            'Carolina','Diego','Elena','Federico','Gabriela','Hernán',
            'Isabel','Leonardo','Mariana','Pablo'
        ])[g] AS nombre,
        (ARRAY[
            'Romero','Navarro','Molina','Suárez','Rojas','Castillo',
            'Vega','Herrera','Silva','Medina','Cabrera','Ortiz',
            'Sosa','Peralta','Acosta','Ibarra','Campos','Benítez',
            'Ponce','Ferrer','Quiroga','Méndez'
        ])[g] AS apellido,
        22 + ((g * 3) % 30) AS edad
    FROM generate_series(1, 22) AS g
)
INSERT INTO empleados
    (nombre, apellido, edad, fecha_nac, tipo_doc, nro_doc, cuil, direccion,
     nro_tel_princ, nro_tel_sec, email, cargo, antiguedad, fecha_ingreso, salario_anual)
SELECT
    nombre,
    apellido,
    edad,
    CURRENT_DATE - ((edad * 365) + ((g * 13) % 300)),
    'DNI',
    (50000000 + g)::text,
    '20-' || (50000000 + g)::text || '-' || (g % 10)::text,
    'Calle Demo ' || (100 + g),
    '+54911' || LPAD((60000000 + g)::text, 8, '0'),
    '-',
    'empleado.demo' || LPAD(g::text, 2, '0') || '@supermercado.local',
    CASE
        WHEN g <= 10 THEN CASE WHEN g % 2 = 0 THEN 'Cajera' ELSE 'Cajero' END
        WHEN g <= 16 THEN 'Repositor'
        WHEN g <= 19 THEN 'Supervisor'
        WHEN g = 20 THEN 'Analista de Datos'
        WHEN g = 21 THEN 'Soporte Técnico'
        ELSE 'Gerente'
    END,
    'Demo',
    CURRENT_DATE - (200 + ((g * 97) % 2500)),
    (36000 + ((g * 4300) % 85000))::numeric(10,2)
FROM e;


-- ============================================================
-- 6. CLIENTES
--    3 originales + 997 demo = 1,000 aprox.
--    Nombre y apellidos varían fila a fila.
--    Se conserva UNIQUE(nombre, apellido).
-- ============================================================

WITH base_clientes AS (
    SELECT
        g,
        (((g - 1) * 37 + 17) % 1024) AS k
    FROM generate_series(1, 997) AS g
),
c AS (
    SELECT
        g,

        (ARRAY[
            'Ana','Luis','María','Carlos','Andrea','Miguel','Daniela','José',
            'Fernanda','Jorge','Patricia','Ricardo','Claudia','Fernando','Rosa','Alberto',
            'Natalia','Marco','Verónica','Raúl','Alejandra','Gustavo','Lorena','Víctor',
            'Mónica','Eduardo','Diana','Roberto','Silvia','Óscar','Teresa','Manuel'
        ])[1 + (k % 32)] AS nombre,

        (ARRAY[
            'García','Pérez','Rodríguez','Sánchez','Torres','Ramírez','Flores','Rivera',
            'Gómez','Díaz','Vargas','Ramos','Mendoza','Castro','Ortiz','Silva',
            'Reyes','Morales','Gutiérrez','Herrera','Medina','Rojas','Navarro','Cabrera',
            'Acosta','Ponce','Vega','Soto','Campos','Benítez','Peralta','Ferrer'
        ])[1 + ((k / 32) % 32)] AS apellido1,

        (ARRAY[
            'López','Torres','Díaz','Ruiz','Vega','Soto','Castro','Mendoza',
            'Herrera','Romero','Medina','Castillo','Silva','Rojas','Navarro','Molina',
            'Cabrera','Acosta','Ponce','Ibarra','Campos','Benítez','Peralta','Ferrer',
            'Quiroga','Méndez','Salazar','Espinoza','Valdez','Núñez','Chávez','Lozano'
        ])[1 + ((k * 19 + 7) % 32)] AS apellido2

    FROM base_clientes
)
INSERT INTO clientes
    (nombre, apellido, tipo_doc, nro_doc, nro_tel_princ, nro_tel_sec, email)
SELECT
    nombre,
    apellido1 || ' ' || apellido2,
    'DNI',
    (70000000 + g)::text,
    '+519' || LPAD((10000000 + g)::text, 8, '0'),
    '-',
    'cliente.demo' || LPAD(g::text, 4, '0') || '@supermercado.local'
FROM c;


-- ============================================================
-- 7. FACTURAS
--    3 originales + 9,997 generadas = 10,000 aprox.
--    Fechas distribuidas desde 2024-01-01 hasta hoy.
--
--    Códigos más naturales:
--      F00001, B00001, E00001,
--      F00002, B00002, E00002, ...
--
--    Se usa una tabla temporal para identificar exactamente
--    las facturas creadas en esta ejecución.
-- ============================================================

CREATE TEMP TABLE tmp_facturas_dataset_demo (
    id int PRIMARY KEY
) ON COMMIT DROP;

WITH datos_factura AS (
    SELECT
        g,
        CASE ((g - 1) % 3)
            WHEN 0 THEN 'F'
            WHEN 1 THEN 'B'
            ELSE        'E'
        END AS prefijo,
        1 + ((g - 1) / 3) AS correlativo
    FROM generate_series(1, 9997) AS g
),
insertadas AS (
    INSERT INTO facturas
        (numero, codigo, fecha, hora, importe_total)
    SELECT
        LPAD((58 + g)::text, 6, '0'),
        prefijo || LPAD(correlativo::text, 5, '0'),
        DATE '2024-01-01'
            + ((g * 37) % (CURRENT_DATE - DATE '2024-01-01' + 1)),
        TIME '08:00'
            + (((g * 17) % 720) * INTERVAL '1 minute'),
        1.00
    FROM datos_factura
    RETURNING id
)
INSERT INTO tmp_facturas_dataset_demo(id)
SELECT id
FROM insertadas;


-- ============================================================
-- 8. DETALLE DE FACTURAS
--    Un detalle por factura, respetando UNIQUE(id_factura).
-- ============================================================

INSERT INTO facturas_detalles
    (id_factura, tipo, descr_factura, costo_asoc, iva, medio_de_pago, descr_pago)
SELECT
    f.id,
    CASE
        WHEN f.id % 10 = 0 THEN 'A'::tipo_factura_enum
        ELSE 'B'::tipo_factura_enum
    END,
    CASE
        WHEN f.id % 10 = 0 THEN 'Responsable Inscripto'
        ELSE 'Consumidor Final'
    END,
    (5 + (f.id % 25))::numeric(8,2),
    18.00::numeric(10,2),
    CASE (f.id % 4)
        WHEN 0 THEN 'EFECTIVO'::tipo_pago_enum
        WHEN 1 THEN 'TARJETA CREDITO'::tipo_pago_enum
        WHEN 2 THEN 'TARJETA DEBITO'::tipo_pago_enum
        ELSE        'CHEQUE'::tipo_pago_enum
    END,
    CASE
        WHEN f.id % 4 IN (1,2) THEN 'Un solo pago'
        ELSE 'Pago al contado'
    END
FROM facturas f
INNER JOIN tmp_facturas_dataset_demo tfd
    ON tfd.id = f.id;


-- ============================================================
-- 9. VENTAS
--    Una venta por factura.
--    Se distribuyen entre cajeros originales y cajeros demo.
-- ============================================================

INSERT INTO ventas
    (id_empleado, id_factura)
SELECT
    (ARRAY[1,2,9,10,11,12,13,14,15,16,17,18])
        [1 + ((f.id - 1) % 12)] AS id_empleado,
    f.id
FROM facturas f
INNER JOIN tmp_facturas_dataset_demo tfd
    ON tfd.id = f.id;


-- ============================================================
-- 10. VENTAS_PRODUCTOS
--     4 productos por cada venta demo => ~40,000 líneas.
--     La fórmula evita repetir el mismo producto dentro de una
--     misma venta y genera cantidades entre 1 y 5.
-- ============================================================

INSERT INTO ventas_productos
    (id_venta, id_producto, cantidad)
SELECT
    v.id,
    1 + ((v.id * 17 + item_no * 23) % 200) AS id_producto,
    1 + ((v.id + item_no * 2) % 5) AS cantidad
FROM ventas v
CROSS JOIN generate_series(1, 4) AS item_no
INNER JOIN tmp_facturas_dataset_demo tfd
    ON tfd.id = v.id_factura;


-- ============================================================
-- 11. COMPRAS_CLIENTES
--     Una relación cliente-venta para cada venta demo.
-- ============================================================

INSERT INTO compras_clientes
    (id_venta, id_cliente)
SELECT
    v.id,
    1 + ((v.id * 13) % 1000) AS id_cliente
FROM ventas v
INNER JOIN tmp_facturas_dataset_demo tfd
    ON tfd.id = v.id_factura;


-- ============================================================
-- 12. RECALCULAR IMPORTE TOTAL DE LAS FACTURAS GENERADAS
--     Basado en precio x cantidad de los productos vendidos.
-- ============================================================

UPDATE facturas f
SET importe_total = x.total
FROM (
    SELECT
        v.id_factura,
        ROUND(SUM(vp.cantidad * p.precio_unidad)::numeric, 2) AS total
    FROM ventas v
    INNER JOIN ventas_productos vp
        ON vp.id_venta = v.id
    INNER JOIN productos p
        ON p.id = vp.id_producto
    INNER JOIN tmp_facturas_dataset_demo tfd
        ON tfd.id = v.id_factura
    GROUP BY v.id_factura
) x
WHERE f.id = x.id_factura;


-- ============================================================
-- 13. ACTUALIZAR ESTADÍSTICAS PARA EL OPTIMIZADOR
-- ============================================================

ANALYZE proveedores;
ANALYZE productos;
ANALYZE empleados;
ANALYZE clientes;
ANALYZE facturas;
ANALYZE facturas_detalles;
ANALYZE ventas;
ANALYZE ventas_productos;
ANALYZE compras_clientes;


COMMIT;


-- ============================================================
-- 14. VALIDACIÓN DEL DATASET
-- ============================================================

SELECT 'proveedores' AS tabla, COUNT(*) AS registros FROM proveedores
UNION ALL
SELECT 'productos', COUNT(*) FROM productos
UNION ALL
SELECT 'empleados', COUNT(*) FROM empleados
UNION ALL
SELECT 'clientes', COUNT(*) FROM clientes
UNION ALL
SELECT 'facturas', COUNT(*) FROM facturas
UNION ALL
SELECT 'facturas_detalles', COUNT(*) FROM facturas_detalles
UNION ALL
SELECT 'ventas', COUNT(*) FROM ventas
UNION ALL
SELECT 'ventas_productos', COUNT(*) FROM ventas_productos
UNION ALL
SELECT 'compras_clientes', COUNT(*) FROM compras_clientes
ORDER BY tabla;

-- Muestra rápida de los nuevos códigos de factura
SELECT
    id,
    numero,
    codigo,
    fecha,
    hora,
    importe_total
FROM facturas
WHERE codigo ~ '^[FBE][0-9]{5}$'
ORDER BY id
LIMIT 20;

-- Muestra rápida de los nuevos códigos de producto
SELECT
    id,
    codigo,
    nombre,
    marca,
    tipo,
    precio_unidad,
    stock
FROM productos
WHERE codigo ~ '^P[0-9]{5}$'
ORDER BY id
LIMIT 20;


/*
 * ============================================================
 * CONSULTAS RÁPIDAS PARA REVISAR LA DISTRIBUCIÓN
 * ============================================================
 */

-- Ventas por año
SELECT
    EXTRACT(YEAR FROM f.fecha)::int AS anio,
    COUNT(*) AS ventas,
    ROUND(SUM(f.importe_total)::numeric, 2) AS facturacion
FROM facturas f
GROUP BY EXTRACT(YEAR FROM f.fecha)
ORDER BY anio;


-- Top 10 productos por unidades vendidas
SELECT
    p.id,
    p.nombre,
    p.marca,
    SUM(vp.cantidad) AS unidades_vendidas
FROM ventas_productos vp
INNER JOIN productos p
    ON p.id = vp.id_producto
GROUP BY p.id, p.nombre, p.marca
ORDER BY unidades_vendidas DESC
LIMIT 10;


/*
 * ============================================================
 * PARA LA DEMO DE OPTIMIZACIÓN / PROFILER
 * ============================================================
 *
 * NO crear estos índices todavía si se desea demostrar primero
 * una consulta sin optimizar y luego comparar el plan.
 *
 * Ejemplos para utilizar posteriormente durante el video:
 *
 * CREATE INDEX idx_facturas_fecha
 *     ON facturas(fecha);
 *
 * CREATE INDEX idx_ventas_productos_id_producto
 *     ON ventas_productos(id_producto);
 *
 * CREATE INDEX idx_compras_clientes_id_cliente
 *     ON compras_clientes(id_cliente);
 *
 * Después de crear un índice:
 * ANALYZE;
 *
 * Esto permitirá comparar el plan de ejecución antes/después
 * usando PostgreSQL Profiler / Explain Analyze.
 * ============================================================
 */
