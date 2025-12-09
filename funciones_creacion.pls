---calcular edad---
CREATE OR REPLACE FUNCTION edad (fec_nac DATE) RETURN NUMBER IS
BEGIN 
    RETURN(ROUND(((sysdate-fec_nac)/365),0));
END;
/

<<<<<<< Updated upstream
CREATE OR REPLACE FUNCTION calcular_subtotal_factura(
    p_nro_fact IN NUMBER,
    p_tipo_factura IN VARCHAR2  -- 'TIENDA' o 'ONLINE'
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
=======


>>>>>>> Stashed changes
---calcular recargo de envio---
CREATE OR REPLACE FUNCTION FUNC_CALCULAR_RECARGO(p_id_pais IN NUMBER) 
RETURN NUMBER IS
    v_es_ue PAISES.ue%TYPE; 
    v_recargo NUMBER(5,2);
BEGIN
    -- 1. Buscamos si el pais pertenece a la UE
    SELECT ue 
    INTO v_es_ue 
    FROM PAISES 
    WHERE id = p_id_pais;
    
    IF v_es_ue THEN 
        v_recargo := 0.05; -- 5% para Union Europea
    ELSE
        v_recargo := 0.15; -- 15% para el resto del mundo
    END IF;

    RETURN v_recargo;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Si el ID del pais no existe en la tabla PAISES
        RAISE_APPLICATION_ERROR(-20101, 'Error: El ID de pais proporcionado no existe.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20102, 'Error inesperado al calcular recargo: ' || SQLERRM);
END;
/

<<<<<<< Updated upstream
CREATE OR REPLACE FUNCTION FUNC_CALCULAR_TOTAL_ONLINE(
    p_nro_fact IN NUMBER,
    p_tipo_factura IN VARCHAR2,
    p_id_pais IN NUMBER  -- Para recargo
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
=======


---calcular total de la factura online---
CREATE OR REPLACE FUNCTION FUNC_CALCULAR_TOTAL(
    p_subtotal IN NUMBER, 
    p_id_pais IN NUMBER
) RETURN NUMBER IS
    v_porcentaje_recargo NUMBER;
    v_total NUMBER(10, 3);
BEGIN
    -- 1. Obtenemos el porcentaje de recargo usando la funcion que creamos antes
    -- Si el pais es de la UE devuelve 0.05, si no, 0.15 
    v_porcentaje_recargo := FUNC_CALCULAR_RECARGO(p_id_pais);

    -- 2. Realizamos el calculo matematico: Subtotal + (Subtotal * Porcentaje)
    v_total := p_subtotal + (p_subtotal * v_porcentaje_recargo);

    -- 3. Retornamos el total redondeado a 3 decimales
    RETURN ROUND(v_total, 3);

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20103, 'Error al calcular el total: ' || SQLERRM);
END;
/




---calcular total de la factura fisica---
CREATE OR REPLACE FUNCTION FUNC_CALCULAR_TOTAL_TIENDA(
    p_subtotal IN NUMBER
>>>>>>> Stashed changes
) RETURN NUMBER IS
    v_total NUMBER(10, 2);
BEGIN
    -- A diferencia de la venta online, en tienda fisica no hay recargo por envio.
    -- El documento indica que los precios son fijos y no varian, y no menciona impuestos adicionales.
    
<<<<<<< Updated upstream
    v_total := calcular_subtotal_factura(p_nro_fact, p_tipo_factura);
=======
    v_total := p_subtotal;
>>>>>>> Stashed changes

    -- Retornamos el total redondeado a 2 decimales para coincidir con la tabla FACTURAS_TIENDA
    RETURN ROUND(v_total, 2);

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20104, 'Error al calcular el total en tienda: ' || SQLERRM);
END;
/
<<<<<<< Updated upstream
=======







---calcular total de puntos---
CREATE OR REPLACE FUNCTION FUNC_CALCULAR_PUNTOS(p_total IN NUMBER) 
RETURN NUMBER IS
    v_puntos NUMBER(3); -- NUMBER(3) coincide con la definicion en FACTURAS_ONLINE
BEGIN    
    -- Rango A: Menos de 10.00 -> 5 puntos
    IF p_total < 10 THEN
        v_puntos := 5;
        
    -- Rango B: De 10.00 a 70.00 -> 20 puntos
    ELSIF p_total >= 10 AND p_total <= 70 THEN
        v_puntos := 20;
        
    -- Rango C: Mas de 70.00 hasta 200.00 -> 50 puntos
    ELSIF p_total > 70 AND p_total <= 200 THEN
        v_puntos := 50;
        
    -- Rango D: Mas de 200.00 -> 200 puntos
    ELSIF p_total > 200 THEN
        v_puntos := 200;
        
    ELSE
        -- Por seguridad, si el total es negativo o nulo
        v_puntos := 0;
    END IF;

    RETURN v_puntos;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20013, 'Error al calcular puntos de lealtad: ' || SQLERRM);
END;
/
>>>>>>> Stashed changes
