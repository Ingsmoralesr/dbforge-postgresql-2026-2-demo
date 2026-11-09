/*
DEMO 1 - PostgreSQL Debugger
INTENTIONAL LOGICAL BUG

Business rule:
  - total purchases < 90,000   -> 5% discount
  - total purchases >= 90,000 -> 10% discount

The 0.20 value below is intentionally incorrect for the debugger demo.
*/

CREATE OR REPLACE FUNCTION calcular_total_cliente(p_id_cliente INT)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_total NUMERIC := 0;
    v_descuento NUMERIC := 0;
BEGIN
    SELECT SUM(f.importe_total)
    INTO v_total
    FROM compras_clientes cc
    INNER JOIN ventas v
        ON cc.id_venta = v.id
    INNER JOIN facturas f
        ON v.id_factura = f.id
    WHERE cc.id_cliente = p_id_cliente;

    IF v_total >= 90000 THEN
        v_descuento := v_total * 0.20; -- INTENTIONAL ERROR
    ELSE
        v_descuento := v_total * 0.05;
    END IF;

    RETURN v_total - v_descuento;
END;
$$;

-- Customers used during video preparation.
SELECT '651' AS cliente, calcular_total_cliente(651) AS total_con_descuento;
SELECT '106' AS cliente, calcular_total_cliente(106) AS total_con_descuento;
