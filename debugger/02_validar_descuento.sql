/*
DEMO 1 - Validation query

Compares the expected business rule with the value returned by
calcular_total_cliente().
*/

WITH compras AS (
    SELECT
        c.id,
        c.nombre,
        c.apellido,
        ROUND(SUM(f.importe_total)::numeric, 2) AS total_compras
    FROM clientes c
    INNER JOIN compras_clientes cc
        ON cc.id_cliente = c.id
    INNER JOIN ventas v
        ON v.id = cc.id_venta
    INNER JOIN facturas f
        ON f.id = v.id_factura
    WHERE c.id IN (651, 106)
    GROUP BY
        c.id,
        c.nombre,
        c.apellido
),
esperado AS (
    SELECT
        *,
        CASE
            WHEN total_compras >= 90000 THEN 0.10
            ELSE 0.05
        END::numeric AS porcentaje_descuento_esperado
    FROM compras
),
comparacion AS (
    SELECT
        *,
        ROUND(total_compras * porcentaje_descuento_esperado, 2)
            AS descuento_esperado,
        ROUND(
            total_compras - (total_compras * porcentaje_descuento_esperado),
            2
        ) AS total_esperado,
        ROUND(calcular_total_cliente(id), 2) AS total_funcion
    FROM esperado
)
SELECT
    id,
    nombre,
    apellido,
    total_compras,
    porcentaje_descuento_esperado,
    descuento_esperado,
    total_esperado,
    total_funcion,
    ROUND(total_funcion - total_esperado, 2) AS diferencia,
    CASE
        WHEN ROUND(total_funcion, 2) = ROUND(total_esperado, 2)
            THEN 'OK'
        ELSE 'REVISAR'
    END AS estado
FROM comparacion
ORDER BY total_compras DESC;
