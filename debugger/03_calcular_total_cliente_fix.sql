/*
DEMO 1 - Corrected function

Business rule:
  - total purchases < 90,000   -> 5% discount
  - total purchases >= 90,000 -> 10% discount
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
        v_descuento := v_total * 0.10;
    ELSE
        v_descuento := v_total * 0.05;
    END IF;

    RETURN v_total - v_descuento;
END;
$$;

-- Re-run debugger/02_validar_descuento.sql after applying the fix.
