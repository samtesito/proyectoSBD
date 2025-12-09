-- 1.1. Validacion de Pasaporte para No-UE
-- Regla: Si el pais no es de la UE, el pasaporte es obligatorio.
CREATE OR REPLACE TRIGGER trg_validar_pasaporte_ue
BEFORE INSERT OR UPDATE ON CLIENTES
FOR EACH ROW
DECLARE
    v_es_ue NUMBER(1); -- Usamos NUMBER para manejar el booleano (1=True, 0=False)
BEGIN
    -- Verificamos si el pais de residencia es de la UE
    -- Nota: Ajusta '1'/'0' segun como guardes el booleano en tu tabla PAISES
    SELECT CASE WHEN ue = 'TRUE' THEN 1 ELSE 0 END 
    INTO v_es_ue
    FROM PAISES
    WHERE id = :NEW.id_pais_resi; 

    -- Si NO es UE y el pasaporte es nulo, error.
    IF v_es_ue = 0 AND :NEW.pasaporte IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: Clientes de paises fuera de la UE requieren Pasaporte obligatorio.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL; -- Si el pais no existe aun, lo dejara pasar (o lanzar error de FK)
END;
/





-- 1.2. Validacion de Juguetes (Set vs Piezas)
-- Regla: Si es SET, piezas NULL. Si no es SET, piezas NOT NULL.
CREATE OR REPLACE TRIGGER trg_validar_tipo_juguete
BEFORE INSERT OR UPDATE ON JUGUETES
FOR EACH ROW
BEGIN
    -- CASO A: Si "set" es VERDADERO
    IF :NEW."set" THEN 
        IF :NEW.piezas IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error: Un SET no debe tener cantidad de piezas definida.');
        END IF;
    END IF;

    -- CASO B: Si "set" es FALSO (usamos NOT)
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
    -- 1. VALIDACIoN DE EDAD MAXIMA
    IF edad(:NEW.f_nacim) > 100 THEN
        RAISE visitante_mayor_a_100;
    END IF;

    -- 2. VALIDACIoN DE EDAD MINIMA
    IF edad(:NEW.f_nacim) < 12 THEN
        RAISE visitante_menor_a_12;
    END IF;

    -- 3. VALIDACIoN DE REPRESENTANTE (12 a 17 años)
    -- Si la edad esta entre 12 y 17 (ambos inclusive) Y no tiene representante
    IF (edad(:NEW.f_nacim) BETWEEN 12 AND 17) AND (:NEW.id_repres IS NULL) THEN
        RAISE falta_representante;
    END IF;

    -- 4. VALIDACIoN DE REPRESENTANTE (Mayores de 17)
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
    cliente_mayor_a_100 EXCEPTION; -- Nueva excepcion declarada
BEGIN
    -- 1. VALIDACION DE EDAD MAXIMA
    IF edad(:NEW.f_nacim) > 100 THEN
        RAISE cliente_mayor_a_100;
    END IF;

    -- 2. VALIDACIoN DE EDAD MINIMA
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
    -- Obtener limite del catalogo para este pais/juguete
    SELECT limite INTO v_limite
    FROM CATALOGOS_LEGO
    WHERE id_pais = :NEW.id_pais AND cod_juguete = :NEW.codigo;
    
    -- Sumar cantidades existentes en esta factura para este producto
    SELECT COALESCE(SUM(cant_prod), 0) INTO v_cant_actual
    FROM DETALLES_FACTURA_ONLINE
    WHERE nro_fact = :NEW.nro_fact 
    AND codigo = :NEW.codigo 
    AND id_pais = :NEW.id_pais;
    
    -- Total proyectado
    v_total_cant := v_cant_actual + :NEW.cant_prod;
    
    -- Validar limite
    IF v_total_cant > v_limite THEN
        RAISE_APPLICATION_ERROR(-20012, 
            'Excede limite catalogo: ' || v_total_cant || ' > ' || v_limite || 
            ' para codigo ' || :NEW.codigo || ' en pais ' || :NEW.id_pais);
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
    -- Lanza un error de aplicacion (-20015) si se intenta actualizar f_inicio
    RAISE_APPLICATION_ERROR(-20015, 'Error: La fecha de inicio del tour no puede ser modificada.');
END;
/





-- 1.11. Validar que la fecha_inicio de fecha tour no pasada.
-- Regla: fecha_inicio debe ser actual o superior
CREATE OR REPLACE TRIGGER trg_no_insertar_fecha_pasada
BEFORE INSERT ON FECHAS_TOUR
FOR EACH ROW
BEGIN
    -- TRUNC(SYSDATE) elimina la parte de la hora de la fecha actual.
    -- Esto permite que se puedan insertar tours para el dia de hoy, 
    -- pero rechaza cualquier fecha anterior a hoy.
    IF :NEW.f_inicio < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20016, 'Error: La fecha de inicio del tour no puede ser anterior a la fecha actual.');
    END IF;
END;
/




-- 1.12. Validar que no se genere una entrada en una inscripcion que no esta confirmada
-- Regla: no se inserta fila en ENTRADAS si la status en inscripcion != PAGADO
CREATE OR REPLACE TRIGGER trg_entrada_solo_si_insc_conf
BEFORE INSERT ON ENTRADAS FOR EACH ROW
DECLARE
    status_insc INSCRIPCIONES_TOUR.status%TYPE;
BEGIN
    
END;
/