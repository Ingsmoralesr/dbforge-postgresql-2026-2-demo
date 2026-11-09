/*
DEMO 2 - Query Profiler
INTENTIONALLY INEFFICIENT QUERY

Business request:
Return customers with more than 30,000 in purchases,
including purchase count and total purchases.

The query deliberately repeats correlated subqueries so the
Profiler can expose repeated work.
*/

SELECT
    c.id,
    c.nombre,
    c.apellido,
    (
        SELECT COUNT(*)
        FROM compras_clientes cc
        WHERE cc.id_cliente = c.id
    ) AS cantidad_compras,
    (
        SELECT ROUND(SUM(f.importe_total), 2)
        FROM compras_clientes cc
        INNER JOIN ventas v
            ON v.id = cc.id_venta
        INNER JOIN facturas f
            ON f.id = v.id_factura
        WHERE cc.id_cliente = c.id
    ) AS total_compras
FROM clientes c
WHERE
    (
        SELECT SUM(f.importe_total)
        FROM compras_clientes cc
        INNER JOIN ventas v
            ON v.id = cc.id_venta
        INNER JOIN facturas f
            ON f.id = v.id_factura
        WHERE cc.id_cliente = c.id
    ) > 30000
ORDER BY total_compras DESC;
