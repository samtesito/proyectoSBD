---calcular edad---
CREATE OR REPLACE FUNCTION edad (fec_nac DATE) RETURN NUMBER IS
BEGIN 
    RETURN(ROUND(((sysdate-fec_nac)/365),0));
END;
/




---calcular subtotal---
CREATE OR REPLACE FUNCTION calcular_subtotal_factura(
    p_nro_fact IN NUMBER,
    p_tipo_factura IN VARCHAR2  -- 'TIENDA' u 'ONLINE'
) RETURN NUMBER IS
    v_total NUMBER(10,2) := 0;
BEGIN
    IF p_tipo_factura = 'TIENDA' THEN
        SELECT NVL(SUM(d.cant_prod * h.precio), 0)
        INTO v_total
        FROM DETALLES_FACTURA_TIENDA d
        JOIN LOTES_SET_TIENDA l ON (d.codigo, d.id_tienda, d.nro_lote) = (l.cod_juguete, l.id_tienda, l.nro_lote)
        JOIN HISTORICO_PRECIOS_JUGUETES h ON l.cod_juguete = h.cod_juguete AND h.f_fin IS NULL
        WHERE d.nro_fact = p_nro_fact;
        
    ELSIF p_tipo_factura = 'ONLINE' THEN
        SELECT NVL(SUM(d.cant_prod * h.precio), 0)
        INTO v_total
        FROM DETALLES_FACTURA_ONLINE d
        JOIN CATALOGOS_LEGO c ON (d.codigo, d.id_pais) = (c.cod_juguete, c.id_pais)
        JOIN HISTORICO_PRECIOS_JUGUETES h ON c.cod_juguete = h.cod_juguete AND h.f_fin IS NULL
        WHERE d.nro_fact = p_nro_fact;
    ELSE
        RAISE_APPLICATION_ERROR(-20050, 'Tipo de factura invalido:' || p_tipo_factura);
    END IF;
    RETURN v_total;
END;
/





---calcular recargo de envio---
CREATE OR REPLACE FUNCTION FUNC_CALCULAR_RECARGO(p_id_pais IN NUMBER) 
RETURN NUMBER IS
    v_es_ue PAISES.ue%TYPE; 
    v_recargo NUMBER(5,2);
BEGIN
    SELECT ue 
    INTO v_es_ue 
    FROM PAISES 
    WHERE id = p_id_pais;
    if v_es_ue = TRUE THEN
        v_recargo := 0.05; -- 5% para Union Europea
    ELSE
        v_recargo := 0.15; -- 15% para el resto del mundo
    END IF;
    RETURN v_recargo;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20101, 'Error: El ID de pais proporcionado no existe.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20102, 'Error inesperado al calcular recargo: ' || SQLERRM);
END;
/

CREATE OR REPLACE FUNCTION FUNC_CALCULAR_TOTAL_ONLINE(
    p_nro_fact IN NUMBER,
    p_tipo_factura IN VARCHAR2,
    p_id_pais IN NUMBER
) RETURN NUMBER IS
    v_subtotal NUMBER(10,2);
    v_recargo  NUMBER;
BEGIN
    v_subtotal := calcular_subtotal_factura(p_nro_fact, p_tipo_factura);
    v_recargo := FUNC_CALCULAR_RECARGO(p_id_pais);
    
    RETURN ROUND(v_subtotal + (v_subtotal * v_recargo), 2);
END;
/



---calcular total de la factura fisica---
CREATE OR REPLACE FUNCTION FUNC_CALCULAR_TOTAL_TIENDA(
    p_nro_fact IN NUMBER,
    p_tipo_factura IN VARCHAR2
) RETURN NUMBER IS
    v_total NUMBER(10, 2);
BEGIN
    v_total := calcular_subtotal_factura(p_nro_fact, p_tipo_factura);
    RETURN ROUND(v_total, 2);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20104, 'Error al calcular el total en tienda: ' || SQLERRM);
END;
/





---calcular total de puntos---
CREATE OR REPLACE FUNCTION FUNC_CALCULAR_PUNTOS(p_total IN NUMBER) 
RETURN NUMBER IS
    v_puntos NUMBER(3);
BEGIN    
    -- Rango A: Menos de 10 -> 5 puntos
    IF p_total < 10 THEN
        v_puntos := 5;
        
    -- Rango B: De 10 a 70 -> 20 puntos
    ELSIF p_total >= 10 AND p_total <= 70 THEN
        v_puntos := 20;
        
    -- Rango C: Mas de 70 hasta 200 -> 50 puntos
    ELSIF p_total > 70 AND p_total <= 200 THEN
        v_puntos := 50;
        
    -- Rango D: Mas de 200 -> 200 puntos
    ELSIF p_total > 200 THEN
        v_puntos := 200;
        
    ELSE
        v_puntos := 0;
    END IF;

    RETURN v_puntos;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20013, 'Error al calcular puntos de lealtad: ' || SQLERRM);
END;
/



CREATE OR REPLACE FUNCTION calcular_costo_envio(
    p_subtotal NUMBER,
    p_id_pais IN NUMBER
) RETURN NUMBER IS
    v_recargo NUMBER(5,2);
    v_costo_envio NUMBER(10,2);
BEGIN
    v_recargo := FUNC_CALCULAR_RECARGO(p_id_pais);
    
    v_costo_envio := ROUND(p_subtotal * v_recargo, 2);
    
    RETURN v_costo_envio;
END;
/


-- Tasa fija (aprox. actual)
CREATE OR REPLACE FUNCTION func_puntos_totales_cliente (
    p_id_cliente IN NUMBER
) RETURN NUMBER IS
    v_total_puntos NUMBER := 0;
    v_ultima_factura_gratis NUMBER;
BEGIN
    SELECT MAX(fo.nro_fact)
    INTO v_ultima_factura_gratis
    FROM FACTURAS_ONLINE fo
    WHERE fo.id_cliente = p_id_cliente 
    AND fo.ptos_generados = 0
    AND fo.total = (
        FUNC_CALCULAR_TOTAL_ONLINE(fo.nro_fact, 'ONLINE', 
            (SELECT id_pais 
            FROM DETALLES_FACTURA_ONLINE 
            WHERE nro_fact = fo.nro_fact 
            FETCH FIRST 1 ROW ONLY
            )
        ) - calcular_subtotal_factura(fo.nro_fact, 'ONLINE')
    );

    IF v_ultima_factura_gratis IS NULL THEN
        SELECT NVL(SUM(ptos_generados), 0)
        INTO v_total_puntos
        FROM FACTURAS_ONLINE WHERE id_cliente = p_id_cliente;
    ELSE
        SELECT NVL(SUM(ptos_generados), 0)
        INTO v_total_puntos
        FROM FACTURAS_ONLINE 
        WHERE id_cliente = p_id_cliente 
        AND nro_fact > v_ultima_factura_gratis;
    END IF;
    
    RETURN v_total_puntos;
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN 0;
    WHEN OTHERS THEN RETURN 0;
END;
/

CREATE OR REPLACE FUNCTION es_gratuita(
    p_id_cliente IN NUMBER
) RETURN BOOLEAN IS 
BEGIN
    IF (func_puntos_totales_cliente(p_id_cliente)>=500) THEN
        RETURN TRUE;
    ELSE 
        RETURN FALSE;
    END IF;
END es_gratuita;
/



-- Funcion para mostrar el precio local segun el pais
CREATE OR REPLACE FUNCTION mostrar_precio_local(
    p_precio_usd IN NUMBER,
    p_id_pais IN NUMBER
) RETURN NUMBER IS
    v_es_ue BOOLEAN;
    v_es_dinamarca BOOLEAN := FALSE;
BEGIN

    SELECT ue INTO v_es_ue FROM PAISES WHERE id = p_id_pais;
    
    IF p_id_pais = 43 THEN
        v_es_dinamarca := TRUE;
    END IF;
    
    IF v_es_dinamarca THEN
        RETURN ROUND(p_precio_usd * 6.42, 2);
        
    ELSIF v_es_ue THEN
        RETURN ROUND(p_precio_usd * 0.86, 2);
        
    ELSE
        RETURN p_precio_usd;
        
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN p_precio_usd;
END;
/







--- Totaliza la canitdad de lotes comprados en el dia ---
CREATE OR REPLACE FUNCTION FUNC_TOTAL_VENTAS_LOTE_DIA(
    p_id_tienda IN NUMBER,
    p_codigo    IN NUMBER,
    p_nro_lote  IN NUMBER
) RETURN NUMBER IS
    v_total_vendido NUMBER;
BEGIN
    SELECT SUM(d.cant_prod)
    INTO v_total_vendido
    FROM DETALLES_FACTURA_TIENDA d
    JOIN FACTURAS_TIENDA f ON d.nro_fact = f.nro_fact
    WHERE d.id_tienda = p_id_tienda
      AND d.codigo = p_codigo
      AND d.nro_lote = p_nro_lote
      AND TRUNC(f.f_emision) = TRUNC(SYSDATE); -- Solo ventas de hoy
    RETURN NVL(v_total_vendido, 0);

EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END;
/