-- 1.1. Validacion de Pasaporte para No-UE
-- Regla: Si el pais no es de la UE, el pasaporte es obligatorio.
CREATE OR REPLACE TRIGGER trg_validar_pasaporte_ue
BEFORE INSERT OR UPDATE ON CLIENTES
FOR EACH ROW
DECLARE
    v_es_ue NUMBER(1); --
BEGIN
    SELECT CASE WHEN ue = 'TRUE' THEN 1 ELSE 0 END 
    INTO v_es_ue
    FROM PAISES
    WHERE id = :NEW.id_pais_resi; 

    IF v_es_ue = 0 AND :NEW.pasaporte IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: Clientes de paises fuera de la UE requieren Pasaporte obligatorio.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL;
END;
/





-- 1.2. Validacion de Juguetes (Set vs Piezas)
-- Regla: Si es SET, piezas NULL. Si no es SET, piezas NOT NULL.
CREATE OR REPLACE TRIGGER trg_validar_tipo_juguete
BEFORE INSERT OR UPDATE ON JUGUETES
FOR EACH ROW
BEGIN
    -- Si "set" es verdadero
    IF :NEW."set" THEN 
        IF :NEW.piezas IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error: Un SET no debe tener cantidad de piezas definida.');
        END IF;
    END IF;

    -- Si "set" es falssso
    IF NOT :NEW."set" THEN
        IF :NEW.piezas IS NULL THEN
            RAISE_APPLICATION_ERROR(-20003, 'Error: Si el juguete no es un SET, debe especificar la cantidad de piezas.');
        END IF;
    END IF;
END;
/



-- 1.3. Validacion edad del visitante (Visitante y representante)
--Regla: Edad minima 12 años participantes.
CREATE OR REPLACE TRIGGER validar_edad_visitante 
BEFORE INSERT OR UPDATE ON VISITANTES_FANS
FOR EACH ROW
DECLARE
    visitante_menor_a_12 EXCEPTION;
    visitante_mayor_a_100 EXCEPTION;
    falta_representante EXCEPTION; 
    visit_mayor_con_rep EXCEPTION;
BEGIN
    --VALIDA DE EDAD MAXIMA
    IF edad(:NEW.f_nacim) > 100 THEN
        RAISE visitante_mayor_a_100;
    END IF;

    --VALIDA DE EDAD MINIMA
    IF edad(:NEW.f_nacim) < 12 THEN
        RAISE visitante_menor_a_12;
    END IF;

    --VALIDA DE REPRESENTANTE (12 a 17 años)
    -- Si la edad esta entre 12-17 y no tiene representante
    IF (edad(:NEW.f_nacim) BETWEEN 12 AND 17) AND (:NEW.id_repres IS NULL) THEN
        RAISE falta_representante;
    END IF;

    --VALIDA DE REPRESENTANTE (Mayores de 17)
    -- Si la edad es mayor a 17 Y tiene representante
    IF (edad(:NEW.f_nacim) > 17) AND (:NEW.id_repres IS NOT NULL) THEN
        RAISE visit_mayor_con_rep;
    END IF;

EXCEPTION 
    WHEN visitante_mayor_a_100 THEN
        RAISE_APPLICATION_ERROR(-20004,'No puede haber un visitante mayor a 100 años.');
    WHEN visitante_menor_a_12 THEN 
        RAISE_APPLICATION_ERROR(-20005,'No puede haber un visitante menor a 12 años.');
    WHEN falta_representante THEN
        RAISE_APPLICATION_ERROR(-20006,'No puede haber un visitante de 12 a 17 años sin representante.');
    WHEN visit_mayor_con_rep THEN
        RAISE_APPLICATION_ERROR(-20007,'Los visitantes mayores a 17 años no pueden tener representante.');
END;
/




-- 1.4. Validacion edad del cliente.
--Regla: Edad minima 21 años.
CREATE OR REPLACE TRIGGER validar_edad_cliente 
BEFORE INSERT OR UPDATE ON CLIENTES
FOR EACH ROW
DECLARE
    cliente_menor_de_edad EXCEPTION;
    cliente_mayor_a_100 EXCEPTION;
BEGIN
    --Valida de edad maxima
    IF edad(:NEW.f_nacim) > 100 THEN
        RAISE cliente_mayor_a_100;
    END IF;

    --Valida de edad minima
    IF edad(:NEW.f_nacim) < 21 THEN
        RAISE cliente_menor_de_edad;
    END IF;

EXCEPTION 
    WHEN cliente_mayor_a_100 THEN
        RAISE_APPLICATION_ERROR(-20008,'No puede haber un cliente mayor a 100 años.');
    WHEN cliente_menor_de_edad THEN 
        RAISE_APPLICATION_ERROR(-20009,'No puede haber un cliente menor a 21 años.');
END;
/


-- 1.6. Validacion fechas historial precios
-- Regla: La fecha fin de historico precio no puede ser menor a la fecha inicio.
CREATE OR REPLACE TRIGGER trg_historial_precios
BEFORE INSERT OR UPDATE ON HISTORICO_PRECIOS_JUGUETES
FOR EACH ROW
BEGIN
    IF :NEW.f_fin IS NOT NULL AND :NEW.f_fin < :NEW.f_inicio THEN
    RAISE_APPLICATION_ERROR(-20010, 'Error: La fecha fin no puede ser menor que la fecha inicio.');
    END IF;
END;
/




-- 1.7. Validacion cupos disponibles tour.
-- Regla: Verificar que en la inscripcion no se excedan los cupos disponibles para la fecha del tour.
CREATE OR REPLACE TRIGGER trg_cupos_disponibles
BEFORE INSERT ON DETALLES_INSCRITOS
FOR EACH ROW
DECLARE
    cant_insc_en_fecha NUMBER;
    capacidad_tour NUMBER;
    cant_cupos_disp NUMBER;
    fecha_insc DETALLES_INSCRITOS.fecha_inicio%TYPE;
BEGIN
    fecha_insc := :NEW.fecha_inicio;
    SELECT COUNT(fecha_inicio) INTO cant_insc_en_fecha
    FROM DETALLES_INSCRITOS WHERE fecha_inicio=fecha_insc;
    SELECT cupos INTO capacidad_tour FROM FECHAS_TOUR 
    WHERE f_inicio=fecha_insc;
    cant_cupos_disp := capacidad_tour - cant_insc_en_fecha;
    IF cant_cupos_disp <= 0 THEN 
    RAISE_APPLICATION_ERROR(-20011, 
        'Error: Exceso de cupos para la fecha ' || TO_CHAR(fecha_insc, 'DD-MON-YYYY') || 
        '- Cupos Maximos: ' || capacidad_tour || 
        '- Inscritos Actuales: ' || cant_insc_en_fecha);
    END IF;
END;
/


-- 1.8. Validacion limite catalogo online.
-- Regla: No exceder el limite de cantidad por catalogo online al insertar detalles de factura online.
CREATE OR REPLACE TRIGGER trg_limite_catalogo_online
BEFORE INSERT ON DETALLES_FACTURA_ONLINE
FOR EACH ROW
DECLARE
    v_limite NUMBER(5);
    v_cant_actual NUMBER(3) := 0;
    v_total_cant NUMBER(3);
BEGIN
    -- Obtiene limite del catalogo para este pais
    SELECT limite INTO v_limite
    FROM CATALOGOS_LEGO
    WHERE id_pais = :NEW.id_pais AND cod_juguete = :NEW.cod_juguete;
    
    -- Suma las cantidades existentes en esta factura para este juguete
    SELECT COALESCE(SUM(cant_prod), 0) INTO v_cant_actual
    FROM DETALLES_FACTURA_ONLINE
    WHERE nro_fact = :NEW.nro_fact 
    AND cod_juguete = :NEW.cod_juguete 
    AND id_pais = :NEW.id_pais;
    
    v_total_cant := v_cant_actual + :NEW.cant_prod;
    
    IF v_total_cant > v_limite THEN
        RAISE_APPLICATION_ERROR(-20012, 
            'Excede limite catalogo: ' || v_total_cant || ' > ' || v_limite || 
            ' para codigo ' || :NEW.cod_juguete || ' en pais ' || :NEW.id_pais);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20013, 'Producto no disponible en catalogo para pais ' || :NEW.id_pais);
END;
/


-- 1.9. Validacion lote en catalogo.
-- Regla: El lote que se quiere registrar pertenece a un juguete/set que esta disponible en el pais de la tienda.
CREATE OR REPLACE TRIGGER tgr_lote_en_catalogo 
BEFORE INSERT OR UPDATE OF cod_juguete ON LOTES_SET_TIENDA 
FOR EACH ROW 
DECLARE
    v_pais_tienda NUMBER(3);
    v_exist_catalogo BOOLEAN;
BEGIN  
    SELECT id_pais INTO v_pais_tienda FROM TIENDAS_LEGO WHERE id = :NEW.id_tienda;
    SELECT CASE WHEN EXISTS(
        SELECT * FROM CATALOGOS_LEGO 
        WHERE id_pais = v_pais_tienda AND cod_juguete = :NEW.cod_juguete) 
        THEN 0 ELSE 1 END
    INTO v_exist_catalogo;
    IF v_exist_catalogo THEN 
        RAISE_APPLICATION_ERROR(-20014, 'El lote que se quiere registrar pertenece a un juguete/set que no esta disponible en el pais de la tienda.');
    END IF;
END;
/






-- 1.10. Validar que la fecha_inicio de fecha tour no se pueda modificar.
-- Regla: fecha_inicio en FECHA_TOUR no puede cambiar
CREATE OR REPLACE TRIGGER trg_no_cambiar_f_inicio
BEFORE UPDATE OF f_inicio ON FECHAS_TOUR
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20015, 'Error: La fecha de inicio del tour no puede ser modificada.');
END;
/





-- 1.11. Validar que la fecha_inicio de fecha tour no pasada.
-- Regla: fecha_inicio debe ser actual o superior
CREATE OR REPLACE TRIGGER trg_no_insertar_fecha_pasada
BEFORE INSERT ON INSCRIPCIONES_TOUR
FOR EACH ROW
BEGIN
    IF :NEW.f_inicio < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20016, 'No se puede inscribir en un tour ya pasado.');
    END IF;
END;
/









/* 
-- 1.13. Verifica que haya stock virtual disponible al comprar
-- Regla: No se puede comprar mas productos de los que hay disponibles
CREATE OR REPLACE TRIGGER TRG_VALIDAR_STOCK_DIARIO
BEFORE INSERT ON DETALLES_FACTURA_TIENDA
FOR EACH ROW
DECLARE
    v_stock_fisico  NUMBER;
    v_vendido_hoy   NUMBER;
    v_disponible    NUMBER;
BEGIN
    --Obteniene el stock fisico que marca la tabla
    SELECT cant_prod
    INTO v_stock_fisico
    FROM LOTES_SET_TIENDA
    WHERE cod_juguete = codigo
        AND id_tienda = id_tienda
        AND nro_lote = nro_lote;

    --Calcula cuanto se ha vendido durante el dia
    v_vendido_hoy := FUNC_TOTAL_VENTAS_LOTE_DIA(id_tienda, codigo, nro_lote);

    --Calcula disponibilidad real
    v_disponible := v_stock_fisico - v_vendido_hoy;

    --Validar si hay espacio para la nueva venta
    IF v_disponible < cant_prod THEN
        RAISE_APPLICATION_ERROR(-20017, 
            'Stock Insuficiente (Calculo Diario). ' ||
            'Stock Inicial: ' || v_stock_fisico || 
            ', Vendido Hoy: ' || v_vendido_hoy || 
            ', Restante: ' || v_disponible || 
            '. Intentas comprar: ' || cant_prod);
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20018, 'El lote o producto no existe en el inventario.');
END;
/ */


--1.14 Facturas no se pueden eliminar
-- facturas físicas
CREATE OR REPLACE TRIGGER trg_no_delete_fact_tienda
BEFORE DELETE ON FACTURAS_TIENDA
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20501, 'Las facturas físicas no se pueden eliminar');
END;
/

-- facturas online
CREATE OR REPLACE TRIGGER trg_no_delete_fact_online
BEFORE DELETE ON FACTURAS_ONLINE
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20502, 'Las facturas online no se pueden eliminar');
END;
/

--1.15 Validacion de que el cliente no se inscriba dos veces
CREATE OR REPLACE TRIGGER trg_inscripcionduplicada
BEFORE INSERT ON DETALLES_INSCRITOS
FOR EACH ROW
DECLARE
    cont NUMBER;
BEGIN
    -- Validación para el cliente
    SELECT COUNT(*) INTO cont FROM DETALLES_INSCRITOS 
    WHERE fecha_inicio = :NEW.fecha_inicio 
    AND id_cliente = :NEW.id_cliente AND id_cliente IS NOT NULL;

    IF cont > 0 THEN
        RAISE_APPLICATION_ERROR(-20501, 'El cliente ya está inscrito en esta fecha.');
    END IF;

    -- Validación para el visitante 
    SELECT COUNT(*) INTO cont FROM DETALLES_INSCRITOS 
    WHERE fecha_inicio = :NEW.fecha_inicio 
    AND id_visit = :NEW.id_visit AND id_visit IS NOT NULL;

    IF cont > 0 THEN
        RAISE_APPLICATION_ERROR(-20501, 'El visitante ya está inscrito en esta fecha.');
    END IF;
END;
/

--1.16 Validacion de que no se meta en una factura venta online un producto duplicado
CREATE OR REPLACE TRIGGER trg_ventaonlineduplicada
BEFORE INSERT ON DETALLES_FACTURA_ONLINE
FOR EACH ROW
DECLARE
    cont NUMBER;
BEGIN
    -- Validación para el cliente
    SELECT COUNT(*) INTO cont FROM DETALLES_FACTURA_ONLINE
    WHERE nro_fact = :NEW.nro_fact 
    AND cod_juguete = :NEW.cod_juguete;

    IF cont > 0 THEN
        RAISE_APPLICATION_ERROR(-20501, 'Ya se registro el producto en esta factura.');
    END IF;
END;
/

--1.16 Validacion de que no se meta en una factura venta fisica un producto duplicado
CREATE OR REPLACE TRIGGER trg_ventafisicaduplicada
BEFORE INSERT ON DETALLES_FACTURA_TIENDA
FOR EACH ROW
DECLARE
    cont NUMBER;
BEGIN
    -- Validación para el cliente
    SELECT COUNT(*) INTO cont FROM DETALLES_FACTURA_TIENDA
    WHERE nro_fact = :NEW.nro_fact 
    AND cod_juguete = :NEW.cod_juguete;

    IF cont > 0 THEN
        RAISE_APPLICATION_ERROR(-20501, 'Ya se registro el producto en esta factura.');
    END IF;
END;
/


