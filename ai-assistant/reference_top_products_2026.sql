/*
DEMO 3 - Natural language to SQL
Reference implementation for the prompt in ai-assistant/prompts.md

The schema stores quantity in ventas_productos and unit price in productos.
Therefore, the product-level sales amount is calculated as:
    cantidad * precio_unidad
*/

SELECT
    p.codigo,
    p.nombre,
    p.marca,
    SUM(vp.cantidad) AS unidades_vendidas,
    ROUND(
        SUM(vp.cantidad * p.precio_unidad)::numeric,
        2
    ) AS monto_total_facturado
FROM productos p
INNER JOIN ventas_productos vp
    ON vp.id_producto = p.id
INNER JOIN ventas v
    ON v.id = vp.id_venta
INNER JOIN facturas f
    ON f.id = v.id_factura
WHERE f.fecha >= DATE '2026-01-01'
  AND f.fecha <  DATE '2027-01-01'
GROUP BY
    p.id,
    p.codigo,
    p.nombre,
    p.marca
ORDER BY unidades_vendidas DESC
LIMIT 10;
