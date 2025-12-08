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





-- 1.2. Validación de Juguetes (Set vs Piezas)
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
--Regla: Edad mínima 12 años participantes.
CREATE OR REPLACE TRIGGER validar_edad_visitante 
BEFORE INSERT OR UPDATE ON VISITANTES_FANS
FOR EACH ROW
DECLARE
    visitante_menor_a_12 EXCEPTION;
    falta_representante EXCEPTION; 
    visit_mayor_con_rep EXCEPTION;
BEGIN
    IF edad(:NEW.f_nacim)< 12 THEN
        RAISE visitante_menor_a_12;
    END IF;
    IF (11 < edad(:NEW.f_nacim)) AND (edad(:NEW.f_nacim) < 18) AND (:NEW.id_repres IS NULL) THEN
        RAISE falta_representante;
    END IF;
    IF (edad(:NEW.f_nacim) > 17) AND (:NEW.id_repres IS NOT NULL) THEN
        RAISE visit_mayor_con_rep;
    END IF;
EXCEPTION 
    WHEN visitante_menor_a_12 THEN 
        RAISE_APPLICATION_ERROR(-20004,'No puede haber un visitante menor a 12 años.');
    WHEN falta_representante THEN
        RAISE_APPLICATION_ERROR(-20005,'No puede haber un visitante de 12 a 17 años sin representante.');
    WHEN visit_mayor_con_rep THEN
        RAISE_APPLICATION_ERROR(-20006,'Los visitantes mayores a 17 años no pueden tener representante.');
END;
/



-- 1.4. Validacion edad del cliente
--Regla: Edad minima 21 años.
CREATE OR REPLACE TRIGGER validar_edad_cliente 
BEFORE INSERT OR UPDATE ON CLIENTES
FOR EACH ROW
DECLARE
    cliente_menor_de_edad EXCEPTION;
BEGIN
    IF edad(:NEW.f_nacim)< 21 THEN
        RAISE cliente_menor_de_edad;
    END IF;
EXCEPTION 
    WHEN cliente_menor_de_edad THEN 
        RAISE_APPLICATION_ERROR(-20007,'No puede haber un cliente menor a 21 años.');
END;
/





-- TRIGGER fecha_inicio<=fecha_fin

CREATE OR REPLACE TRIGGER trg_historial_precios
BEFORE INSERT OR UPDATE ON HISTORICO_PRECIOS_JUGUETES
FOR EACH ROW
BEGIN
    IF :NEW.f_fin IS NOT NULL AND :NEW.f_fin < :NEW.f_inicio THEN
    RAISE_APPLICATION_ERROR(-20008, 'Error: La fecha fin no puede ser menor que la fecha inicio.');
    END IF;
END;
/



-- Trigger SIMPLE (solo marca f_fin) ESTE SIIII DEFINITIVOOOO
CREATE OR REPLACE TRIGGER trg_historial_precios_auto
BEFORE UPDATE OF precio ON HISTORICO_PRECIOS_JUGUETES
FOR EACH ROW
BEGIN
:NEW.f_fin := SYSDATE;
END;
/

-- TRIGGER cant cupos disponibles
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
    RAISE_APPLICATION_ERROR(-20009, 
        'Error: Exceso de cupos para la fecha ' || TO_CHAR(fecha_insc, 'DD-MON-YYYY') || 
        '- Cupos Máximos: ' || capacidad_tour || 
        '- Inscritos Actuales: ' || cant_insc_en_fecha);
    END IF;
END;
/



-- TRIGGER limite catálogo online

CREATE OR REPLACE TRIGGER trg_limite_catalogo_online
BEFORE INSERT ON DETALLES_FACTURA_ONLINE
FOR EACH ROW
DECLARE
    v_limite NUMBER(5);
    v_cant_actual NUMBER(3) := 0;
    v_total_cant NUMBER(3);
BEGIN
    -- Obtener límite del catálogo para este país/juguete
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
    
    -- Validar límite
    IF v_total_cant > v_limite THEN
        RAISE_APPLICATION_ERROR(-20010, 
            'Excede límite catálogo: ' || v_total_cant || ' > ' || v_limite || 
            ' para código ' || :NEW.codigo || ' en país ' || :NEW.id_pais);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20011, 'Producto no disponible en catálogo para país ' || :NEW.id_pais);
END;
/







--- TRIGGER validar lote pertenece a catálogo

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
        RAISE_APPLICATION_ERROR(-20012, 'El lote que se quiere registrar pertenece a un juguete/set que no está disponible en el país de la tienda.');
    END IF;
END;
/

-- ALTERRRRRRRR----------------------------------------------------------------------

ALTER TABLE CLIENTES
ADD CONSTRAINT chk_cliente_pasaporte
CHECK (pasaporte IS NULL OR f_venc_pasap IS NOT NULL);

ALTER TABLE VISITANTES_FANS 
ADD CONSTRAINT chk_visitante_pasaporte 
CHECK (pasaporte IS NULL OR f_venc_pasap IS NOT NULL);