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

CREATE SEQUENCE id_entrada
    INCREMENT BY 1
    START WITH 0;

CREATE OR REPLACE PROCEDURE generar_entradas(
    f_tour IN INSCRIPCIONES_TOUR.f_inicio%TYPE,
    n_fact IN INSCRIPCIONES_TOUR.f_inicio%TYPE
) IS
    CURSOR inscritos IS 
    SELECT id_cliente, id_visit 
    FROM DETALLES_INSCRITOS 
    WHERE (fecha_inicio = f_tour AND nro_fact = n_fact);
    v_inscrit inscritos%ROWTYPE;
BEGIN
    FOR v_inscrit IN inscritos LOOP
        IF EXISTS(v_inscrit.id_cliente) THEN 
            INSERT INTO ENTRADAS(f_inicio, nro_fact, nro, tipo)
            VALUES(f_tour, n_fact, id_entrada.nextval, 'A');
        ELSE 
            INSERT INTO ENTRADAS(f_inicio, nro_fact, nro, tipo)
            VALUES(f_tour, n_fact, id_entrada.nextval, 'M');
        END IF;
        COMMIT;
    END LOOP;
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




--- PROCEDIMIENTO PARA ACTUALIZAR LOTE INVENTARIO ---- PENDIENTE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
CREATE OR REPLACE PROCEDURE actualizar_cant_lote(
    p_cod_juguete LOTES_SET_TIENDA.cod_juguete%TYPE,
    p_id_tienda LOTES_SET_TIENDA.id_tienda%TYPE,
    p_nro_lote LOTES_SET_TIENDA.nro_lote%TYPE,
    p_cant_descuento NUMBER
)
IS
BEGIN
    UPDATE LOTES_SET_TIENDA
    SET cant_prod = (:OLD.cant_prod - p_cant_descuento) 
    WHERE (cod_juguete = p_cod_juguete) AND (id_tienda = p_id_tienda) AND (nro_lote = p_nro_lote);
END actualizar_cant_lote;

--- PROCEDIMIENTO PARA CERRAR LOTE INVENTARIO ---- PENDIENTE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!




--- PROCEDIMIENTO DE FLUJO DE INSCRIPCIÓN

CREATE OR REPLACE PROCEDURE flujo_de_inscripcion() IS
BEGIN 
    muestra_fechastour_disponibles;
    
    --- SELECCIÓN DE FECHA
    --- VALIDACIÓN DE FECHA INGRESADA
    --- INSCRIPCIÓN DE PERSONA
    --- CONSULTA SI VA A INSCRIBIR A OTRA (SE ABRE LOOP CON EL PASO ANTERIOR SI SÍ)
    --- SE TOTALIZA Y SE ACTUALIZA LA INSCRIPCIÓN
END flujo_de_inscripcion;

CREATE OR REPLACE PROCEDURE flujo_de_venta_online() IS 
DECLARE 
    cliente_no_encontrado EXCEPTION;
    producto_no_encontrado EXCEPTION;
BEGIN
    --- QUERY DE CLIENTES
    SELECT p.nombre "PAIS RESIDENCIA", 
        INITCAP(c.prim_nom) || ' ' || INITCAP(c.seg_nom) || ' ' || INITCAP(c.prim_ape) || ' ' || INITCAP(c.seg_ape) "NOMBRE DEL CLIENTE", 
        c.id_lego "ID DEL CLIENTE" 
        FROM CLIENTES c, PAISES p
        WHERE c.id_pais_resi = p.id
        ORDER BY p.nombre, c.prim_nom ASC;   
    --- SELECCIÓN DE CLIENTES
    DBMS_OUTPUT.PUT_LINE("\n En la parte superior se muestran los clientes registrados.");
    ACCEPT v_id NUMBER PROMPT 'Ingrese el ID del cliente a seleccionar: '
    --- VALIDACIÓN DE CLIENTE INGRESADO
    IF NOT EXISTS(SELECT prim_nom FROM CLIENTES WHERE id = v_id) THEN 
        RAISE cliente_no_encontrado;
    END IF;
    --- GENERA FACTURA
    generacion_factura();
    --- QUERY DE PRODUCTOS DISPONIBLES PARA SU PAÍS
    SELECT t.nombre "TEMA", 
        j.nombre "NOMBRE DEL JUGUETE", 
        j.piezas 
        j.codigo "ID DEL JUGUETE" 
        FROM JUGUETES j, TEMAS t
        WHERE j.id_tema = t.id
        ORDER BY t.nombre, j.nombre ASC;   
    --- INGRESA PRODUCTO A COMPRAR
    --- VALIDA EXISTENCIA DE PRODUCTO
    --- INGRESA CANTIDAD
    --- VALIDA NÚMERO
    --- CONSULTA SI VA A COMPRAR OTRO (ABRE LOOP CON EL PASO ANTERIOR SI SÍ)
    --- GENERA TOTAL Y ACTUALIZA FACTURA
END flujo_de_venta_online;

CREATE OR REPLACE PROCEDURE flujo_de_venta_fisica() IS 
BEGIN
    --- QUERY DE CLIENTES
    --- SELECCIÓN DE CLIENTES
    --- VALIDACIÓN DE CLIENTE INGRESADO
    --- QUERY DE PRODUCTOS DISPONIBLES PARA SU PAÍS
    --- INGRESA PRODUCTO A COMPRAR Y CANTIDAD
    --- CONSULTA SI VA A COMPRAR OTRO (ABRE LOOP CON EL PASO ANTERIOR SI SÍ)
    --- GENERA TOTAL Y ACTUALIZA FACTURA
END flujo_de_venta_online;

---1.3 PROCEDIMIENTO PARA FORMATEAR LA FECHA
CREATE OR REPLACE PROCEDURE inserta_hr_tnda (
    id_tnda IN NUMBER,
    dia_char IN VARCHAR2,
    hr_ent VARCHAR2,
    hr_sal VARCHAR2
)
IS
BEGIN
    INSERT INTO HORARIOS_ATENCION (id_tienda,dia,hora_entr,hora_sal)
    VALUES (
        id_tnda,
        TO_DATE(dia_char, 'DY'),
        TO_DATE(hr_ent,'HH24:MI:SS'),
        TO_DATE(hr_sal,'HH24:MI:SS') 
    );
END;
/






--1.5 PROCEDIMIENTO DE CIERRE DE CAJA
CREATE OR REPLACE PROCEDURE PRO_CIERRE_DIARIO_STOCK(
    p_fecha IN DATE DEFAULT SYSDATE -- Si no pasas fecha, usa la de hoy
) IS
    -- Cursor para agrupar ventas por tienda, producto y lote
    CURSOR c_ventas_dia IS
        SELECT d.id_tienda, 
               d.codigo AS cod_juguete, 
               d.nro_lote, 
               SUM(d.cant_prod) AS total_vendido
        FROM DETALLES_FACTURA_TIENDA d
        JOIN FACTURAS_TIENDA f ON d.nro_fact = f.nro_fact
        WHERE TRUNC(f.f_emision) = TRUNC(p_fecha) -- Filtramos por la fecha indicada
        GROUP BY d.id_tienda, d.codigo, d.nro_lote;
        
    v_total_actualizados NUMBER := 0;
BEGIN
    -- Recorremos cada lote que tuvo movimiento hoy
    FOR r_venta IN c_ventas_dia LOOP
        
        -- Descontamos del inventario fisico
        UPDATE LOTES_SET_TIENDA
        SET cant_prod = cant_prod - r_venta.total_vendido
        WHERE cod_juguete = r_venta.cod_juguete
          AND id_tienda = r_venta.id_tienda
          AND nro_lote = r_venta.nro_lote;
          
        v_total_actualizados := v_total_actualizados + 1;
        
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Cierre completado. Lotes actualizados: ' || v_total_actualizados);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20130, 'Error en cierre diario: ' || SQLERRM);
END;
/


--1.6 Simulando Inscripcion TOur
--Muestra las fechas disponibles para inscribirse en tours
CREATE OR REPLACE PROCEDURE muestra_fechastour_disponibles
IS
    CURSOR cur_ftour IS SELECT f_inicio, costo, cupos 
    FROM FECHAS_TOUR WHERE f_inicio>SYSDATE;
    row_ftour FECHAS_TOUR%ROWTYPE;
BEGIN
    FOR row_ftour IN cur_ftour
    LOOP
        DBMS_OUTPUT.PUT_LINE('Fecha del Tour: ' || TO_CHAR(row_ftour.f_inicio, 'DD-MONTH-YYYY') || 
            ' | Costo: ' || row_ftour.costo || 
            ' | Cupos: ' || row_ftour.cupos
        );
    END LOOP;
END;
/

--1.7 Seleccion de Fecha
--Tras mostrar las fechas disp, usuario escoge una
CREATE OR REPLACE FUNCTION seleccion_fecha RETURN DATE IS
    
    f_elegida DATE;
    f_encontrada DATE;
BEGIN
    ACCEPT datousuario VARCHAR(20) PROMPT 'Ingrese valor de la fecha: ';
    f_elegida := TO_DATE(datousuario,'DD-MONTH-YYYY');
    DBMS_OUTPUT.PUT_LINE('Procesando inscripción para la fecha: ' || f_elegida || '..');
    SELECT f_inicio INTO f_encontrada 
    FROM FECHAS_TOUR WHERE f_inicio = f_elegida;
    return f_encontrada;
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('La fecha no existe en el registro.');
        RETURN NULL;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ingrese la fecha en el formato: DD-MONTH-YYYY' || SQLERRM);
        RETURN NULL;    
END;
/


--1.8 Generacion Facturas (ONLINE-TIENDA)
---CREATE OR REPLACE PROCEDURE generacion_factura(
    
---)IS

























