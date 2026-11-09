/*
DEMO 2 / DEMO 3 - Optimized reference query

In the video, dbForge AI Assistant is asked to propose an optimized
query before this reference file is shown.

Optimization pattern:
  - join once
  - aggregate once per customer
  - filter aggregated totals with HAVING
*/

SELECT
    c.id,
    c.nombre,
    c.apellido,
    COUNT(cc.id) AS cantidad_compras,
    ROUND(SUM(f.importe_total), 2) AS total_compras
FROM clientes c
INNER JOIN compras_clientes cc
    ON cc.id_cliente = c.id
INNER JOIN ventas v
    ON v.id = cc.id_venta
INNER JOIN facturas f
    ON f.id = v.id_factura
GROUP BY
    c.id,
    c.nombre,
    c.apellido
HAVING SUM(f.importe_total) > 30000
ORDER BY total_compras DESC;
