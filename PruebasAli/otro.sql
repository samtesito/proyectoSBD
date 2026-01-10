CREATE SEQUENCE SEQ_FACTURA_TIENDA START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_FACTURA_ONLINE START WITH 1 INCREMENT BY 1;
-- Secuencia para el ID de la inscripcion (Cabecera)
CREATE SEQUENCE SEQ_INSCRIPCION START WITH 1 INCREMENT BY 1;

-- Tipos para manejar listas de productos y cantidades
-- (Si ya existen en la BD, omite esta parte)
CREATE OR REPLACE TYPE t_lista_numeros AS TABLE OF NUMBER;
/



--------------------------------------------------------------------------------------------------------------------------------------
----TIENDA FISICA
--------------------------------------------------------------------------------------------------------------------------------------
--(Este cubre el requerimiento de "procesar_venta_fisica" y "registrar_venta_tienda" al mismo tiempo).
CREATE OR REPLACE PROCEDURE registrar_venta_tienda (
    p_id_tienda    IN NUMBER,
    p_id_cliente   IN NUMBER,
    p_lista_prods  IN t_lista_numeros, -- Lista de IDs de productos
    p_lista_cants  IN t_lista_numeros  -- Lista de cantidades respectivas
) IS
    v_nro_fact     NUMBER;
    v_nro_lote     NUMBER;
    v_tipo_cli     VARCHAR2(1);
    v_total        NUMBER;
    v_id_det       NUMBER := 1; -- Contador para id_det_fact
BEGIN
    -- 1. Obtener nuevo numero de factura
    v_nro_fact := SEQ_FACTURA_TIENDA.NEXTVAL;

    -- 2. Insertar Cabecera de Factura (Total temporal 0)
    INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total)
    VALUES (v_nro_fact, p_id_cliente, p_id_tienda, SYSDATE, 0);

    -- 3. Determinar tipo de cliente (M: Miembro/Menor, A: Adulto/Regular??)
    -- Ajusta 'A' segun tu logica de negocio real. Asumimos 'A' por defecto.
    v_tipo_cli := 'A'; 

    -- 4. Procesar cada producto de la lista
    FOR i IN 1 .. p_lista_prods.COUNT LOOP
        
        -- BUSCAR LOTE: Necesitamos saber de qué lote sacar el producto.
        -- Buscamos el primer lote en esa tienda con stock suficiente.
        BEGIN
            SELECT nro_lote
            INTO v_nro_lote
            FROM (
                SELECT nro_lote
                FROM LOTES_SET_TIENDA
                WHERE id_tienda = p_id_tienda
                  AND cod_juguete = p_lista_prods(i)
                  AND cant_prod >= p_lista_cants(i) -- Solo lotes con capacidad
                ORDER BY f_adqui ASC -- PEPS (Primero que entra, primero que sale)
            )
            WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20020, 'No hay stock suficiente en ningun lote para el producto ID: ' || p_lista_prods(i));
        END;

        -- INSERTAR DETALLE
        -- Nota: Tu trigger TRG_VALIDAR_STOCK_DIARIO validará el stock nuevamente al insertar
        INSERT INTO DETALLES_FACTURA_TIENDA (
            nro_fact, id_det_fact, cant_prod, tipo_cli, codigo, id_tienda, nro_lote
        ) VALUES (
            v_nro_fact, v_id_det, p_lista_cants(i), v_tipo_cli, p_lista_prods(i), p_id_tienda, v_nro_lote
        );

        v_id_det := v_id_det + 1;
    END LOOP;

    -- 5. Calcular y Actualizar el Total Final
    -- Usamos tu funcion existente que ya suma (precio * cantidad)
    v_total := FUNC_CALCULAR_TOTAL_TIENDA(v_nro_fact, 'TIENDA');

    UPDATE FACTURAS_TIENDA
    SET total = v_total
    WHERE nro_fact = v_nro_fact;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Venta Tienda registrada con exito. Factura Nro: ' || v_nro_fact || ' Total: ' || v_total);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20021, 'Error en venta tienda: ' || SQLERRM);
END;
/
















--------------------------------------------------------------------------------------------------------------------------------------
------TIENDA ONLINE
--------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE p_realizar_venta_online (
    p_id_cliente   IN NUMBER,
    p_lista_prods  IN t_lista_numeros,
    p_lista_cants  IN t_lista_numeros
) IS
    v_nro_fact      NUMBER;
    v_id_pais       NUMBER;
    v_tipo_cli      VARCHAR2(1) := 'A'; -- Asumido
    v_total_final   NUMBER;
    v_puntos        NUMBER;         -- Puntos finales a acreditar
    v_puntos_calc   NUMBER;         -- Puntos calculados por la compra (sin tope)
    v_puntos_hist   NUMBER;         -- Puntos que ya tenia antes
    v_id_det        NUMBER := 1;
    v_existe_catalogo NUMBER;
BEGIN
    -- 1. Obtener Pais del Cliente (Para validar Catalogo y Recargo)
    SELECT id_pais_resi INTO v_id_pais
    FROM CLIENTES
    WHERE id_lego = p_id_cliente;

    -- 2. Generar numero de factura
    v_nro_fact := SEQ_FACTURA_ONLINE.NEXTVAL;

    -- 3. Insertar Cabecera (Inicialmente en 0)
    INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total)
    VALUES (v_nro_fact, SYSDATE, p_id_cliente, 0, 0);

    -- 4. Procesar Productos
    FOR i IN 1 .. p_lista_prods.COUNT LOOP
        
        -- VALIDAR CATALOGO: ¿Este producto se vende en el pais del cliente?
        SELECT COUNT(*) INTO v_existe_catalogo
        FROM CATALOGOS_LEGO
        WHERE id_pais = v_id_pais 
          AND cod_juguete = p_lista_prods(i);

        IF v_existe_catalogo = 0 THEN
            RAISE_APPLICATION_ERROR(-20030, 'El producto ' || p_lista_prods(i) || ' no esta disponible en el catalogo para el pais ID: ' || v_id_pais);
        END IF;

        -- Insertar Detalle
        INSERT INTO DETALLES_FACTURA_ONLINE (
            nro_fact, id_det_fact, cant_prod, tipo_cli, codigo, id_pais
        ) VALUES (
            v_nro_fact, v_id_det, p_lista_cants(i), v_tipo_cli, p_lista_prods(i), v_id_pais
        );

        v_id_det := v_id_det + 1;
    END LOOP;

    -- 5. Calcular Totales usando TUS funciones
    v_total_final := FUNC_CALCULAR_TOTAL_ONLINE(v_nro_fact, 'ONLINE', v_id_pais);
    
    -- === LOGICA DE TOPE HISTORICO (500 PUNTOS) ===
    
    -- A) Calculamos cuantos puntos daria esta compra normalmente
    v_puntos_calc := FUNC_CALCULAR_PUNTOS(v_total_final);
    
    -- B) Buscamos cuantos tiene el cliente HOY (Antes de esta compra)
    v_puntos_hist := func_puntos_totales_cliente(p_id_cliente);
    
    -- C) Aplicamos la regla del vaso lleno
    IF (v_puntos_hist + v_puntos_calc) > 500 THEN
        -- Si se pasa, solo le damos lo que falta para llegar a 500
        v_puntos := 500 - v_puntos_hist;
        -- Seguridad por si ya tenia mas de 500 (negativo)
        IF v_puntos < 0 THEN v_puntos := 0; END IF;
    ELSE
        -- Si no se pasa, le damos todo lo calculado
        v_puntos := v_puntos_calc;
    END IF;

    -- 6. Actualizar Factura con el total y los puntos YA VALIDADOS
    UPDATE FACTURAS_ONLINE
    SET total = v_total_final,
        ptos_generados = v_puntos
    WHERE nro_fact = v_nro_fact;

    -- === NUEVO: MOSTRAR ACUMULADO (MISMO FORMATO) ===
    DECLARE
        v_acumulado_total NUMBER;
    BEGIN
        -- Consultamos el total nuevo (que ahora sera maximo 500)
        v_acumulado_total := func_puntos_totales_cliente(p_id_cliente);
        
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        DBMS_OUTPUT.PUT_LINE('FACTURA NRO: ' || v_nro_fact);
        DBMS_OUTPUT.PUT_LINE('Monto Total: ' || v_total_final || ' USD');
        DBMS_OUTPUT.PUT_LINE('Puntos ganados en esta compra: ' || v_puntos); -- Muestra los puntos reales asignados
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        DBMS_OUTPUT.PUT_LINE('>> PUNTOS TOTALES ACUMULADOS (Historico): ' || v_acumulado_total);
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
    END;

    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20031, 'Cliente no encontrado o error de datos.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20032, 'Error en venta online: ' || SQLERRM);
END;
/

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

DECLARE
    v_max_id NUMBER;
BEGIN
    -- 1. Buscar cual es el ID mas alto que existe actualmente
    SELECT NVL(MAX(nro_fact), 0) INTO v_max_id FROM FACTURAS_ONLINE;
    
    -- 2. Borrar la secuencia vieja que esta "atrasada"
    BEGIN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_FACTURA_ONLINE';
    EXCEPTION
        WHEN OTHERS THEN NULL; -- Si no existe, no pasa nada
    END;
    
    -- 3. Crear la secuencia nueva empezando desde el Maximo + 1
    EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_FACTURA_ONLINE START WITH ' || (v_max_id + 1) || ' INCREMENT BY 1';
    
    DBMS_OUTPUT.PUT_LINE('Secuencia corregida. Proximo ID sera: ' || (v_max_id + 1));
END;
/

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

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















--------------------------------------------------------------------------------------------------------------------------------------
----INSCRIPCIONES TOUR
--------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE inscribir_participantes (
    p_f_tour       IN DATE,            -- Corresponde a FECHAS_TOUR.f_inicio
    p_id_respon    IN NUMBER,          -- El responsable (Se usa para validar, aunque no se guarda en cabecera segun tu tabla)
    p_lista_part   IN t_lista_numeros  -- Lista de IDs de los clientes (participantes)
) IS
    v_nro_fact      NUMBER;
    v_cupo_total    NUMBER;
    v_costo_base    NUMBER;
    v_inscritos     NUMBER;
    v_total_pagar   NUMBER := 0;
    v_id_det        NUMBER := 1;       -- Contador para id_det_insc
    
    -- Variables para validacion de menores
    v_edad_part     NUMBER;
    v_f_nac         DATE;
    v_tiene_menor   BOOLEAN := FALSE;
    v_tiene_adulto  BOOLEAN := FALSE;
    
    e_sin_cupo      EXCEPTION;
BEGIN
    -- 1. Obtener datos del Tour (Tabla FECHAS_TOUR)
    BEGIN
        SELECT cupos, costo
        INTO v_cupo_total, v_costo_base
        FROM FECHAS_TOUR
        WHERE f_inicio = p_f_tour;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20040, 'No existe un tour programado para la fecha: ' || p_f_tour);
    END;

    -- 2. Validar Disponibilidad
    -- Contamos usando DETALLES_INSCRITOS filtrando por la fecha del tour
    SELECT COUNT(*)
    INTO v_inscritos
    FROM DETALLES_INSCRITOS
    WHERE fecha_inicio = p_f_tour;

    IF (v_inscritos + p_lista_part.COUNT) > v_cupo_total THEN
        RAISE e_sin_cupo;
    END IF;

    -- 3. Generar ID y Crear Cabecera (Tabla INSCRIPCIONES_TOUR)
    v_nro_fact := SEQ_INSCRIPCION_FACT.NEXTVAL;
    
    -- Nota: Tu tabla INSCRIPCIONES_TOUR no tiene columna id_cliente/responsable.
    -- Solo insertamos las columnas que definiste en el CREATE TABLE.
    INSERT INTO INSCRIPCIONES_TOUR (f_inicio, nro_fact, f_emision, estado, total)
    VALUES (p_f_tour, v_nro_fact, SYSDATE, 'PENDIENTE', 0);

    -- 4. Procesar Participantes (Tabla DETALLES_INSCRITOS)
    FOR i IN 1 .. p_lista_part.COUNT LOOP
        
        -- Insertar detalle
        -- Tu PK es (fecha_inicio, nro_fact, id_det_insc)
        INSERT INTO DETALLES_INSCRITOS (fecha_inicio, nro_fact, id_det_insc, id_cliente, id_visit)
        VALUES (p_f_tour, v_nro_fact, v_id_det, p_lista_part(i), NULL); 
        -- Asumimos que la lista son CLIENTES (id_cliente). Si fueran visitantes, irian en id_visit.

        -- Validar Edad (Tabla CLIENTES campo f_nacim)
        BEGIN
            SELECT f_nacim INTO v_f_nac 
            FROM CLIENTES 
            WHERE id_lego = p_lista_part(i);
            
            -- Calculo de edad directo o con tu funcion
            v_edad_part := FLOOR(MONTHS_BETWEEN(SYSDATE, v_f_nac) / 12);
            
            IF v_edad_part < 18 THEN
                v_tiene_menor := TRUE;
            ELSE
                v_tiene_adulto := TRUE;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20042, 'Cliente ID '|| p_lista_part(i) ||' no encontrado.');
        END;

        v_total_pagar := v_total_pagar + v_costo_base;
        v_id_det := v_id_det + 1;
        
    END LOOP;

    -- 5. Validacion: Menores sin Adulto
    -- (Verificamos tambien si el RESPONSABLE p_id_respon es el adulto acompañante si no hay uno en la lista)
    IF v_tiene_menor AND NOT v_tiene_adulto THEN
        -- Opcional: Verificar si p_id_respon es adulto, pero como no se inscribe, 
        -- la regla estricta suele ser que el adulto debe ser un participante (acompañante).
        RAISE_APPLICATION_ERROR(-20043, 'No se puede inscribir menores sin un adulto participante en el grupo.');
    END IF;

    -- 6. Actualizar Total
    UPDATE INSCRIPCIONES_TOUR
    SET total = v_total_pagar
    WHERE f_inicio = p_f_tour AND nro_fact = v_nro_fact;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Inscripcion creada. Fecha: ' || p_f_tour || ' Factura: ' || v_nro_fact || ' Total: ' || v_total_pagar);

EXCEPTION
    WHEN e_sin_cupo THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20041, 'Cupos insuficientes. Restantes: ' || (v_cupo_total - v_inscritos));
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20044, 'Error al inscribir: ' || SQLERRM);
END;
/


--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE PROCEDURE procesar_pago_inscripcion (
    p_f_tour    IN DATE,
    p_nro_fact  IN NUMBER,
    p_monto     IN NUMBER
) IS
    v_total_real   NUMBER;
    v_estado       VARCHAR2(20);
BEGIN
    -- 1. Verificar que la inscripcion existe y traer datos
    SELECT total, estado
    INTO v_total_real, v_estado
    FROM INSCRIPCIONES_TOUR
    WHERE f_inicio = p_f_tour 
      AND nro_fact = p_nro_fact;

    -- 2. Validaciones de Negocio
    IF v_estado = 'PAGADO' THEN
        RAISE_APPLICATION_ERROR(-20050, 'Error: Esta inscripcion ya está pagada.');
    END IF;

    IF p_monto < v_total_real THEN
        RAISE_APPLICATION_ERROR(-20051, 'Error: Monto insuficiente. El total es: ' || v_total_real);
    END IF;

    -- 3. Actualizar estado a PAGADO
    UPDATE INSCRIPCIONES_TOUR
    SET estado = 'PAGADO'
    WHERE f_inicio = p_f_tour 
      AND nro_fact = p_nro_fact;

    -- 4. Generar las Entradas Fisicas (Llamada a tu otro proceso)
    -- Esto crea los tickets en la tabla ENTRADAS
    generar_entradas(p_f_tour, p_nro_fact);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pago procesado con éxito. Estado actualizado a PAGADO y Entradas generadas.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20052, 'Inscripcion no encontrada.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20053, 'Error al procesar pago: ' || SQLERRM);
END;
/





















CREATE OR REPLACE PROCEDURE SP_PROCESAR_COMPRA (
    p_anio        IN NUMBER,
    p_id_pais     IN NUMBER,
    p_id_tienda   IN NUMBER, -- Nuevo parámetro: La tienda elegida
    p_cod_juguete IN NUMBER,
    p_cantidad    IN NUMBER
) IS
    v_nombre_tienda  VARCHAR2(100);
    v_nombre_juguete VARCHAR2(100);
    v_precio         NUMBER(10,2);
    v_nro_lote       NUMBER;
    v_stock          NUMBER;
    v_nro_factura    NUMBER;
    v_total          NUMBER(10,2);
    v_cliente_def    NUMBER := 1001; 
    v_fecha_compra   DATE;
    v_check_tienda   NUMBER;
    
    -- Errores personalizados
    ex_tienda_error  EXCEPTION;
    ex_no_stock      EXCEPTION;
    ex_no_precio     EXCEPTION;

BEGIN
    -- 1. VALIDAR QUE LA TIENDA PERTENECE AL PAÍS
    SELECT COUNT(*) INTO v_check_tienda
    FROM TIENDAS_LEGO
    WHERE id = p_id_tienda AND id_pais = p_id_pais;

    IF v_check_tienda = 0 THEN RAISE ex_tienda_error; END IF;

    -- Obtener nombre de la tienda para el recibo
    SELECT nombre INTO v_nombre_tienda FROM TIENDAS_LEGO WHERE id = p_id_tienda;

    -- 2. CONFIGURAR FECHA
    v_fecha_compra := TO_DATE('15/06/' || p_anio, 'DD/MM/YYYY');

    -- 3. BUSCAR PRECIO HISTÓRICO
    BEGIN
        SELECT precio INTO v_precio
        FROM HISTORICO_PRECIOS_JUGUETES
        WHERE cod_juguete = p_cod_juguete
        AND v_fecha_compra >= f_inicio 
        AND (f_fin IS NULL OR v_fecha_compra <= f_fin)
        AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RAISE ex_no_precio;
    END;

    -- 4. OBTENER NOMBRE DEL JUGUETE
    SELECT nombre INTO v_nombre_juguete FROM JUGUETES WHERE codigo = p_cod_juguete;

    -- 5. VERIFICAR STOCK (EN LA TIENDA ESPECÍFICA)
    BEGIN
        SELECT nro_lote, cant_prod INTO v_nro_lote, v_stock
        FROM LOTES_SET_TIENDA
        WHERE id_tienda = p_id_tienda 
        AND cod_juguete = p_cod_juguete 
        AND cant_prod >= p_cantidad
        AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RAISE ex_no_stock;
    END;

    -- 6. GENERAR FACTURA
    v_total := v_precio * p_cantidad;
    SELECT NVL(MAX(nro_fact), 0) + 1 INTO v_nro_factura FROM FACTURAS_TIENDA;

    INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total)
    VALUES (v_nro_factura, v_cliente_def, p_id_tienda, v_fecha_compra, v_total);

    INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_tienda, nro_lote)
    VALUES (v_nro_factura, 1, p_cantidad, 'A', p_cod_juguete, p_id_tienda, v_nro_lote);

    -- 7. DESCONTAR INVENTARIO
    UPDATE LOTES_SET_TIENDA 
    SET cant_prod = cant_prod - p_cantidad
    WHERE id_tienda = p_id_tienda AND cod_juguete = p_cod_juguete AND nro_lote = v_nro_lote;

    COMMIT;

    -- 8. IMPRIMIR RECIBO
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('       FACTURA GENERADA NRO ' || v_nro_factura);
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('Tienda:   ' || v_nombre_tienda);
    DBMS_OUTPUT.PUT_LINE('Fecha:    ' || v_fecha_compra);
    DBMS_OUTPUT.PUT_LINE('Producto: ' || v_nombre_juguete);
    DBMS_OUTPUT.PUT_LINE('Cantidad: ' || p_cantidad || ' | Total: $' || v_total);
    DBMS_OUTPUT.PUT_LINE('========================================');

EXCEPTION
    WHEN ex_tienda_error THEN RAISE_APPLICATION_ERROR(-20001, 'La tienda seleccionada no pertenece al país indicado.');
    WHEN ex_no_precio THEN RAISE_APPLICATION_ERROR(-20002, 'No hay precio histórico válido para la fecha.');
    WHEN ex_no_stock  THEN RAISE_APPLICATION_ERROR(-20003, 'Stock insuficiente en la tienda seleccionada.');
    WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20004, SQLERRM);
END;
/




























CREATE OR REPLACE PROCEDURE SP_ALTA_CATALOGO_Y_STOCK (
    p_id_pais     IN NUMBER,
    p_id_tienda   IN NUMBER,
    p_cod_juguete IN NUMBER,
    p_cantidad    IN NUMBER,
    p_limite_cat  IN NUMBER DEFAULT 50 -- Limite de compra por defecto
) IS
    v_existe_cat    NUMBER;
    v_check_pais    NUMBER;
    v_nombre_juguete JUGUETES.nombre%TYPE;
    v_nombre_tienda TIENDAS_LEGO.nombre%TYPE;
    v_nro_lote      NUMBER;
    
    ex_tienda_error EXCEPTION;
    ex_juguete_err  EXCEPTION;

BEGIN
    -- 1. VALIDAR QUE LA TIENDA PERTENECE AL PAÍS
    SELECT COUNT(*) INTO v_check_pais 
    FROM TIENDAS_LEGO 
    WHERE id = p_id_tienda AND id_pais = p_id_pais;
    
    IF v_check_pais = 0 THEN 
        RAISE ex_tienda_error; 
    END IF;

    -- Obtener nombres para el reporte final
    SELECT nombre INTO v_nombre_tienda FROM TIENDAS_LEGO WHERE id = p_id_tienda;
    BEGIN
        SELECT nombre INTO v_nombre_juguete FROM JUGUETES WHERE codigo = p_cod_juguete;
    EXCEPTION WHEN NO_DATA_FOUND THEN RAISE ex_juguete_err;
    END;

    -- 2. GESTIÓN DEL CATÁLOGO (SI NO EXISTE, LO CREA)
    SELECT COUNT(*) INTO v_existe_cat
    FROM CATALOGOS_LEGO
    WHERE id_pais = p_id_pais AND cod_juguete = p_cod_juguete;

    IF v_existe_cat = 0 THEN
        INSERT INTO CATALOGOS_LEGO (id_pais, cod_juguete, limite)
        VALUES (p_id_pais, p_cod_juguete, p_limite_cat);
        
        DBMS_OUTPUT.PUT_LINE('>> AVISO: El juguete no estaba en el catálogo de este país. Se ha agregado automáticamente.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('>> OK: El juguete ya existía en el catálogo.');
    END IF;

    -- 3. GESTIÓN DEL LOTE (STOCK)
    -- Calculamos el siguiente número de lote para esta tienda y juguete (para no duplicar PK)
    SELECT NVL(MAX(nro_lote), 0) + 1 
    INTO v_nro_lote
    FROM LOTES_SET_TIENDA
    WHERE id_tienda = p_id_tienda AND cod_juguete = p_cod_juguete;

    -- Insertamos el nuevo inventario
    INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui, cant_prod)
    VALUES (p_cod_juguete, p_id_tienda, v_nro_lote, SYSDATE, p_cantidad);

    COMMIT;

    -- 4. REPORTE FINAL
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('¡ABASTECIMIENTO EXITOSO!');
    DBMS_OUTPUT.PUT_LINE('Tienda:   ' || v_nombre_tienda || ' (ID ' || p_id_tienda || ')');
    DBMS_OUTPUT.PUT_LINE('Producto: ' || v_nombre_juguete || ' (ID ' || p_cod_juguete || ')');
    DBMS_OUTPUT.PUT_LINE('Acción:   Se ingresó el LOTE Nro ' || v_nro_lote);
    DBMS_OUTPUT.PUT_LINE('Cantidad: ' || p_cantidad || ' unidades disponibles.');
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');

EXCEPTION
    WHEN ex_tienda_error THEN
        RAISE_APPLICATION_ERROR(-20010, 'Error: La tienda ID ' || p_id_tienda || ' no pertenece al país ID ' || p_id_pais);
    WHEN ex_juguete_err THEN
        RAISE_APPLICATION_ERROR(-20011, 'Error: El ID de juguete no existe en la base de datos maestra.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20012, 'Error inesperado: ' || SQLERRM);
END;
/





















CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_PRECIO (
    p_cod_juguete  IN NUMBER,
    p_nuevo_precio IN NUMBER,
    p_fecha_inicio IN DATE
) IS
    v_nombre_juguete VARCHAR2(100);
    v_precio_anterior NUMBER;
    v_existe         NUMBER;
    
    ex_no_existe     EXCEPTION;
    ex_fecha_invalida EXCEPTION;
BEGIN
    -- 1. Validar que el juguete existe
    BEGIN
        SELECT nombre INTO v_nombre_juguete FROM JUGUETES WHERE codigo = p_cod_juguete;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RAISE ex_no_existe;
    END;

    -- 2. "Cerrar" el precio anterior (Actualizar su fecha fin)
    -- Solo cerramos si la fecha nueva es posterior al inicio del precio actual
    UPDATE HISTORICO_PRECIOS_JUGUETES
    SET f_fin = p_fecha_inicio - 1
    WHERE cod_juguete = p_cod_juguete 
    AND f_fin IS NULL;

    -- (Opcional) Guardamos el precio viejo para el reporte, si existía
    BEGIN
        SELECT precio INTO v_precio_anterior 
        FROM HISTORICO_PRECIOS_JUGUETES 
        WHERE cod_juguete = p_cod_juguete AND f_fin = p_fecha_inicio - 1;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN v_precio_anterior := 0; 
    END;

    -- 3. Insertar el nuevo precio
    INSERT INTO HISTORICO_PRECIOS_JUGUETES (cod_juguete, f_inicio, precio, f_fin)
    VALUES (p_cod_juguete, p_fecha_inicio, p_nuevo_precio, NULL);

    COMMIT;

    -- 4. Mensaje de Confirmación
    DBMS_OUTPUT.PUT_LINE('==============================================');
    DBMS_OUTPUT.PUT_LINE(' PRECIO ACTUALIZADO CORRECTAMENTE');
    DBMS_OUTPUT.PUT_LINE('==============================================');
    DBMS_OUTPUT.PUT_LINE('Juguete: ' || v_nombre_juguete || ' (ID ' || p_cod_juguete || ')');
    DBMS_OUTPUT.PUT_LINE('Vigencia desde: ' || p_fecha_inicio);
    DBMS_OUTPUT.PUT_LINE('Precio Anterior: $' || v_precio_anterior);
    DBMS_OUTPUT.PUT_LINE('Precio Nuevo:    $' || p_nuevo_precio);
    DBMS_OUTPUT.PUT_LINE('==============================================');

EXCEPTION
    WHEN ex_no_existe THEN
        RAISE_APPLICATION_ERROR(-20001, 'El ID del juguete no existe.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, 'Error al actualizar precio: ' || SQLERRM);
END;
/


