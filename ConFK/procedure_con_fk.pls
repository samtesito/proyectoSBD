--1.0 PROCEDIMIENTO PARA INSERTAR PRECIOS
CREATE OR REPLACE PROCEDURE insertar_nuevo_precio (
    p_cod_juguete  IN HISTORICO_PRECIOS_JUGUETES.cod_juguete%TYPE,
    p_f_inicio     IN HISTORICO_PRECIOS_JUGUETES.f_inicio%TYPE,
    p_precio       IN HISTORICO_PRECIOS_JUGUETES.precio%TYPE
) IS
BEGIN
    UPDATE HISTORICO_PRECIOS_JUGUETES
    SET f_fin = p_f_inicio
    WHERE cod_juguete = p_cod_juguete
    AND f_fin IS NULL;
    INSERT INTO HISTORICO_PRECIOS_JUGUETES (cod_juguete, f_inicio, precio, f_fin)
    VALUES (p_cod_juguete, p_f_inicio, p_precio, NULL);
END;
/



--1.1 PROCEDIMIENTO PARA GENERAR ENTRADAS

CREATE OR REPLACE PROCEDURE generar_entradas(
    p_f_tour IN DATE,   
    p_n_fact IN NUMBER  
) IS
    CURSOR c_inscritos IS 
        SELECT id_cliente, id_visit 
        FROM DETALLES_INSCRITOS 
        WHERE fecha_inicio = p_f_tour 
          AND nro_fact = p_n_fact;
          
    v_tipo_entrada CHAR(1);
BEGIN
    FOR r IN c_inscritos LOOP
        
        IF r.id_cliente IS NOT NULL THEN 
            v_tipo_entrada := 'A'; -- Cliente (Adulto)
        ELSE 
            v_tipo_entrada := 'M'; -- Visitante (Menor)
        END IF;

        INSERT INTO ENTRADAS(f_inicio, nro_fact, nro, tipo)
        VALUES(p_f_tour, p_n_fact, id_entrada.nextval, v_tipo_entrada);
        
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Entradas generadas con éxito.');
END generar_entradas;
/



--1.2 PROCEDIMIENTO PARA CALCULAR TOTAL FACTURA
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
        JOIN LOTES_SET_TIENDA l ON (d.cod_juguete, d.id_tienda, d.nro_lote) = (l.cod_juguete, l.id_tienda, l.nro_lote)
        JOIN HISTORICO_PRECIOS_JUGUETES h ON l.cod_juguete = h.cod_juguete AND h.f_fin IS NULL
        WHERE d.nro_fact = p_nro_fact;
        
    ELSIF p_tipo_factura = 'ONLINE' THEN
        SELECT NVL(SUM(d.cant_prod * h.precio), 0)
        INTO v_total
        FROM DETALLES_FACTURA_ONLINE d
        JOIN CATALOGOS_LEGO c ON (d.cod_juguete, d.id_pais) = (c.cod_juguete, c.id_pais)
        JOIN HISTORICO_PRECIOS_JUGUETES h ON c.cod_juguete = h.cod_juguete AND h.f_fin IS NULL
        WHERE d.nro_fact = p_nro_fact;
    
    ELSE
        RAISE_APPLICATION_ERROR(-20050, 'Tipo de factura invalido:' || p_tipo_factura);
    END IF;
    
    RETURN v_total;
END;
/




--- PROCEDIMIENTO PARA ACTUALIZAR LOTE INVENTARIO 
CREATE OR REPLACE PROCEDURE actualizar_cant_lote(
    p_cod_juguete LOTES_SET_TIENDA.cod_juguete%TYPE,
    p_id_tienda LOTES_SET_TIENDA.id_tienda%TYPE,
    p_nro_lote LOTES_SET_TIENDA.nro_lote%TYPE,
    p_cant_descuento NUMBER
)
IS
BEGIN
    UPDATE LOTES_SET_TIENDA
    SET cant_prod = (cant_prod - p_cant_descuento) 
    WHERE (cod_juguete = p_cod_juguete) 
        AND (id_tienda = p_id_tienda) 
        AND (nro_lote = p_nro_lote);
END actualizar_cant_lote;
/



--- PROCEDIMIENTO PARA CERRAR LOTE INVENTARIO 
CREATE SEQUENCE desce
    increment by 1
    start with 1;

CREATE OR REPLACE PROCEDURE generar_desc_lote_por_fecha(
    p_fecha IN DATE DEFAULT SYSDATE--,
    --p_id_tienda IN NUMBER,
    --p_cod_juguete IN NUMBER,
    --p_nro_lote IN NUMBER
)
IS  
    CURSOR desc_por_lote IS
        (SELECT d.cod_juguete, d.id_tienda, d.nro_lote, sum(d.cant_prod) total_desc
            FROM DETALLES_FACTURA_TIENDA d 
            WHERE (d.nro_fact IN (SELECT nro_fact FROM FACTURAS_TIENDA WHERE f_emision = p_fecha)) 
            GROUP BY d.cod_juguete, d.id_tienda, d.nro_lote);
    --descuento desc_por_lote%ROWTYPE;
BEGIN
    FOR descuento IN desc_por_lote LOOP
        -- SE INSERTAN LOS DESCUENTOS
        INSERT INTO DESCUENTOS (id_desc, id_tienda, cod_juguete, nro_lote, fecha, cant)
        VALUES (desce.nextval, descuento.id_tienda, descuento.cod_juguete, descuento.nro_lote, p_fecha, descuento.total_desc);
        -- SE ACTUALIZAN LA CANTIDADES EN LOS LOTES RESPECTIVOS
        actualizar_cant_lote(descuento.cod_juguete, descuento.id_tienda, descuento.nro_lote, descuento.total_desc);
    END LOOP;
END generar_desc_lote_por_fecha;
/

BEGIN
generar_desc_lote_por_fecha(DATE '2025-12-13');
END;
/


---Procedimiento para generar inscripcion

CREATE OR REPLACE PROCEDURE agregarparticipante(
    finsc IN FECHAS_TOUR.f_inicio%TYPE,
    nrofactinsc IN INSCRIPCIONES_TOUR.nro_fact%TYPE,
    opcioninsc IN varchar2,
    id_inscrito IN CLIENTES.id_lego%TYPE
) IS
id_detinsc NUMBER;
BEGIN
    SELECT COUNT (*) into id_detinsc from DETALLES_INSCRITOS where fecha_inicio=finsc AND
    nro_fact=nrofactinsc;
    IF UPPER(opcioninsc) = 'C' THEN
        INSERT INTO DETALLES_INSCRITOS (fecha_inicio, nro_fact, id_det_insc, id_cliente, id_visit)
        VALUES (finsc, nrofactinsc, id_detinsc+1, id_inscrito, NULL);
    ELSIF UPPER(opcioninsc) = 'V' THEN 
        INSERT INTO DETALLES_INSCRITOS (fecha_inicio, nro_fact, id_det_insc, id_cliente, id_visit)
        VALUES (finsc, nrofactinsc, id_detinsc+1, NULL, id_inscrito);
    ELSE
        RAISE_APPLICATION_ERROR(-20020, 'Tipo inválido: debe ser C o V');
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE ACTUALIZARINSCRIPCION(
    finsc IN FECHAS_TOUR.f_inicio%TYPE,
    nrofactinsc IN INSCRIPCIONES_TOUR.nro_fact%TYPE
)IS
    totalfact NUMBER;
    preciotour NUMBER;
    cantinscritos NUMBER;
BEGIN
    SELECT COUNT(*) INTO cantinscritos FROM DETALLES_INSCRITOS WHERE
    fecha_inicio=finsc AND nro_fact=nrofactinsc;
    SELECT costo INTO preciotour FROM FECHAS_TOUR WHERE
    f_inicio=finsc;
    totalfact := cantinscritos * preciotour;
    UPDATE INSCRIPCIONES_TOUR SET
        estado='PAGADO',
        total=totalfact
    WHERE f_inicio=finsc AND nro_fact=nrofactinsc;
END;
/

CREATE OR REPLACE PROCEDURE CONFIRMACIONINSCRIPCION(
    finsc IN FECHAS_TOUR.f_inicio%TYPE,
    nrofactinsc IN INSCRIPCIONES_TOUR.nro_fact%TYPE,
    opcion IN varchar2
) IS
BEGIN
    IF UPPER(opcion) = 'S' THEN
        ACTUALIZARINSCRIPCION(finsc,nrofactinsc);
        generar_entradas(finsc,nrofactinsc);
    ELSIF UPPER(opcion) = 'N' THEN 
        DBMS_OUTPUT.PUT_LINE('Se ha registrado la inscripcion como PENDIENTE.');
    ELSE
        RAISE_APPLICATION_ERROR(-20020, 'Tipo inválido: debe ser S o N');
    END IF;
END;
/

--Procedimiento para validar disponibilidad de producto en venta online
CREATE OR REPLACE PROCEDURE VALIDARLIMITEONLINE(
    p_cod_juguete IN NUMBER, -- Código del juguete
    p_id_pais     IN NUMBER, -- ID del país
    p_cantidad_n  IN NUMBER  -- Cantidad a comprar
) IS
    v_limite NUMBER; -- Se supone que es el stock disponible para el país
BEGIN
    SELECT limite INTO v_limite 
    FROM CATALOGOS_LEGO 
    WHERE cod_juguete = p_cod_juguete AND id_pais = p_id_pais;

    IF p_cantidad_n > v_limite THEN
        RAISE_APPLICATION_ERROR(-20060, 'Solicitud supera el limite disponible ' || (v_limite));
    END IF;
END;
/


--Procedimiento "Carrito de Compras" venta online
CREATE OR REPLACE PROCEDURE CARGARPRODUCTOSONLINE(
    p_nro_fact    IN NUMBER,
    p_cod_juguete IN NUMBER,
    p_cantidad    IN NUMBER
) IS
    v_id_pais NUMBER;
    v_next_det NUMBER;
BEGIN
    SELECT c.id_pais_resi INTO v_id_pais
    FROM CLIENTES c, FACTURAS_ONLINE f
    WHERE c.id_lego = f.id_cliente
    AND f.nro_fact = p_nro_fact;
    VALIDARLIMITEONLINE(p_cod_juguete, v_id_pais, p_cantidad);
    SELECT NVL(MAX(id_det_fact), 0) + 1 INTO v_next_det
    FROM DETALLES_FACTURA_ONLINE 
    WHERE nro_fact = p_nro_fact;
    INSERT INTO DETALLES_FACTURA_ONLINE (
        nro_fact, 
        id_det_fact, 
        cant_prod, 
        tipo_cli, 
        cod_juguete, 
        id_pais
    )
    VALUES (
        p_nro_fact, 
        v_next_det, 
        p_cantidad, 
        'A', 
        p_cod_juguete, 
        v_id_pais
    );
END;
/

--Procedimiento para "Cierre de caja" en venta Online
CREATE OR REPLACE PROCEDURE FINALIZARVENTAONLINE(p_nro_fact IN NUMBER) IS
    v_total NUMBER(10,2);
    v_puntos NUMBER(5);
    v_id_pais NUMBER;
BEGIN
    SELECT id_pais 
    INTO v_id_pais 
    FROM DETALLES_FACTURA_ONLINE 
    WHERE nro_fact = p_nro_fact 
    AND ROWNUM = 1; 
    v_total := calcular_total_con_puntos(p_nro_fact, 'ONLINE', v_id_pais);
    IF v_total > 0 THEN
        v_puntos := FUNC_CALCULAR_PUNTOS(v_total); --No recuerdo bien si esta función calculaba bien los puntos, hay que chequearlo
    ELSE
        v_puntos := 0;
    END IF;
    UPDATE FACTURAS_ONLINE 
    SET total = v_total, 
        ptos_generados = v_puntos
    WHERE nro_fact = p_nro_fact;
    --COMMIT;
    DBMS_OUTPUT.PUT_LINE('Venta finalizada con éxito.');
END;
/