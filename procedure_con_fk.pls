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
    f_tour IN INSCRIPCIONES_TOUR.f_inicio%TYPE,
    n_fact IN INSCRIPCIONES_TOUR.f_inicio%TYPE
) IS
DECLARE
    cant_insc NUMBER;
    cont NUMBER;
    id_cli DETALLES_INSCRITOS.id_cliente%TYPE,
    id_vis DETALLES_INSCRITOS.id_visit%TYPE,
    tipoE ENTRADAS.tipo%TYPE
BEGIN
    SELECT COUNT(*) INTO cant_insc FROM DETALLES_INSCRITOS
    WHERE fecha_inicio=f_tour AND nro_fact=n_fact;
    FOR i IN 1..cant_insc
    LOOP
        SELECT id_cliente, id_visit INTO id_cli, id_vis 
        FROM DETALLES_INSCRITOS WHERE fecha_inicio=f_tour
        AND nro_fact=n_fact AND id_det_insc=i;
        IF id_cli IS NULL THEN
            tipoE := 'A';
            INSERT INTO ENTRADAS(fecha_inicio,nro_fact,i,tipo) VALUES(f_tour,nro_fact,i,tipoE);
        ELSIF id_vis IS NULL THEN
            tipoE := 'M';
            INSERT INTO ENTRADAS(fecha_inicio,nro_fact,i,tipo) VALUES(f_tour,nro_fact,i,i,tipoE);
        END IF
    END LOOP;
END;
/

-- INTENTO DE SAMUEL 

CREATE SEQUENCE id_entrada
    INCREMENT 1
    START WITH 0;

CREATE OR REPLACE PROCEDURE generar_entraditas(
    f_tour IN INSCRIPCIONES_TOUR.f_inicio%TYPE,
    n_fact IN INSCRIPCIONES_TOUR.f_inicio%TYPE,
) IS
DECLARE
    CURSOR inscritos IS SELECT id_cliente, id_visit 
    FROM DETALLES_INSCRITOS 
    WHERE (fecha_inicio = f_tour AND nro_fact = n_fact);
    inscrit inscritos%ROWTYPE;
BEGIN
    FOR inscrit IN inscritos LOOP
        IF EXISTS(inscrit.id_cliente) THEN 
            INSERT INTO ENTRADAS(f_inicio, nro_fact, nro, tipo)
            VALUES(f_tour, n_fact, id_entrada.nextval, 'A');
        ELSE 
            INSERT INTO ENTRADAS(f_inicio, nro_fact, nro, tipo)
            VALUES(f_tour, n_fact, id_entrada.nextval, 'M');
        END IF;
    END LOOP;
END generar_entraditas;
/

--1.3 PROCEDIMIENTO PARA INSERTAR DETALLES INSCRITOS
CREATE OR REPLACE PROCEDURE insertar_det_insc(
    f_tour IN FECHAS_TOUR.f_inicio%TYPE,
    nro_fact_insc IN INSCRIPCIONES_TOUR.nro_fact%TYPE,
    id_visitante IN DETALLES_INSCRITOS.id_visit%TYPE,
    id_repre IN DETALLES_INSCRITOS.id_cliente%TYPE DEFAULT NULL
) IS
DECLARE
    ult_inscrito NUMBER;
BEGIN
    SELECT nvl(MAX(id_det_insc),0)+1 INTO ult_inscrito
    FROM DETALLES_INSCRITOS WHERE fecha_inicio=f_tour AND
    nro_fact=nro_fact_insc;
    INSERT INTO DETALLES_INSCRITOS(fecha_inicio,nro_fact,id_det_insc,id_cliente,id_visit)
    VALUES(f_tour,nro_fact_insc,ult_inscrito,id_repre,id_visitante);
END;
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

---1.3 PROCEDIMIENTO PARA FORMATEAR LA FECHA
