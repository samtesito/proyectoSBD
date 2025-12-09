
-- Script de prueba para el procedimiento generar_entradas
SET SERVEROUTPUT ON;
DECLARE
    v_fecha_tour DATE := DATE '2026-08-20';
    v_factura    NUMBER := 949; 
BEGIN

    BEGIN
        INSERT INTO FECHAS_TOUR (f_inicio, costo, cupos)
        VALUES (v_fecha_tour, 100, 50);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN NULL;
    END;

    INSERT INTO INSCRIPCIONES_TOUR (f_inicio, nro_fact, f_emision, estado, total)
    VALUES (v_fecha_tour, v_factura, SYSDATE, 'PAGADO', 200);

 
    INSERT INTO DETALLES_INSCRITOS (fecha_inicio, nro_fact, id_det_insc, id_cliente, id_visit)
    VALUES (v_fecha_tour, v_factura, 1, 1001, NULL); 


    INSERT INTO DETALLES_INSCRITOS (fecha_inicio, nro_fact, id_det_insc, id_cliente, id_visit)
    VALUES (v_fecha_tour, v_factura, 2, NULL, 2001);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Datos de prueba (Familia completa) creados correctamente.');

    -- 5. EJECUTAR TU PROCEDIMIENTO
    generar_entradas(v_fecha_tour, v_factura);

    -- 6. VERIFICAR RESULTADOS
    DBMS_OUTPUT.PUT_LINE('--- RESULTADOS EN TABLA ENTRADAS ---');
    FOR r IN (SELECT * FROM ENTRADAS WHERE nro_fact = v_factura) LOOP
        DBMS_OUTPUT.PUT_LINE('Ticket Generado -> Nro: ' || r.nro || ' | Tipo: ' || r.tipo);
    END LOOP;
END;
/











