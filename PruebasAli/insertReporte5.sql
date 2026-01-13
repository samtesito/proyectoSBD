SET SERVEROUTPUT ON;

DECLARE
    -- Variables de Configuración
    v_cliente_id     NUMBER := 1001; 
    v_fecha_venta    DATE := TO_DATE('15/06/2024', 'DD/MM/YYYY');
    v_fecha_lote     DATE := TO_DATE('01/01/2024', 'DD/MM/YYYY');
    
    -- Variables de IDs
    v_tienda_id      NUMBER;
    v_factura_id     NUMBER;
    
    -- Variables Temporales
    v_ciudad_id      NUMBER;
    v_estado_id      NUMBER;
    v_precio_hist    NUMBER;
    v_lote_counter   NUMBER; 
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== FASE 1: LIMPIEZA DE DATOS PREVIOS (REPORTE 5) ===');

    -- Limpiamos datos hijos primero
    DELETE FROM DETALLES_FACTURA_TIENDA WHERE id_tienda IN (SELECT id FROM TIENDAS_LEGO WHERE nombre LIKE 'LEGO Store%');
    DELETE FROM FACTURAS_TIENDA WHERE id_tienda IN (SELECT id FROM TIENDAS_LEGO WHERE nombre LIKE 'LEGO Store%');
    DELETE FROM LOTES_SET_TIENDA WHERE id_tienda IN (SELECT id FROM TIENDAS_LEGO WHERE nombre LIKE 'LEGO Store%');
    DELETE FROM TIENDAS_LEGO WHERE nombre LIKE 'LEGO Store%';
    
    -- Nota: No borramos CATALOGOS_LEGO porque podría afectar otros datos, solo agregaremos lo que falte.

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('-> Limpieza completada.');

    
    DBMS_OUTPUT.PUT_LINE('=== FASE 2: GENERACIÓN DE NUEVOS DATOS ===');

    -- Inicializamos IDs
    SELECT NVL(MAX(id), 0) INTO v_tienda_id FROM TIENDAS_LEGO;
    SELECT NVL(MAX(nro_fact), 0) INTO v_factura_id FROM FACTURAS_TIENDA;

    -- Recorremos todos los países
    FOR r_pais IN (SELECT id, nombre FROM PAISES) LOOP
        
        BEGIN
            -- A. Buscamos una ciudad válida
            SELECT id, id_estado INTO v_ciudad_id, v_estado_id
            FROM CIUDADES 
            WHERE id_pais = r_pais.id 
            FETCH FIRST 1 ROW ONLY;

            -- B. Creamos la Tienda
            v_tienda_id := v_tienda_id + 1;
            
            INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
            VALUES (v_tienda_id, 'LEGO Store ' || r_pais.nombre, 'Av. Principal 2024', r_pais.id, v_estado_id, v_ciudad_id);

            DBMS_OUTPUT.PUT_LINE('-> Tienda creada en: ' || r_pais.nombre);

            v_lote_counter := 0; 

            -- Recorremos 3 juguetes al azar
            FOR r_toy IN (SELECT codigo FROM JUGUETES ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 3 ROWS ONLY) LOOP
                
                v_lote_counter := v_lote_counter + 1;

                -- C. [NUEVO] AUTORIZAR EN CATALOGO (Para evitar error del Trigger)
                -- Insertamos solo si no existe ya para ese país
                INSERT INTO CATALOGOS_LEGO (id_pais, cod_juguete, limite)
                SELECT r_pais.id, r_toy.codigo, 1000 FROM DUAL
                WHERE NOT EXISTS (
                    SELECT 1 FROM CATALOGOS_LEGO 
                    WHERE id_pais = r_pais.id AND cod_juguete = r_toy.codigo
                );

                -- D. Buscamos precio histórico 2024
                BEGIN
                    SELECT precio INTO v_precio_hist
                    FROM HISTORICO_PRECIOS_JUGUETES
                    WHERE cod_juguete = r_toy.codigo 
                      AND v_fecha_venta >= f_inicio
                      AND (f_fin IS NULL OR v_fecha_venta <= f_fin)
                    FETCH FIRST 1 ROW ONLY;
                EXCEPTION 
                    WHEN NO_DATA_FOUND THEN v_precio_hist := 50; 
                END;

                -- E. Insertamos Lote (Ahora el Trigger lo permitirá porque está en el catálogo)
                INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui, cant_prod)
                VALUES (r_toy.codigo, v_tienda_id, v_lote_counter, v_fecha_lote, 500);

                -- F. Insertamos Factura
                v_factura_id := v_factura_id + 1;
                
                INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total)
                VALUES (v_factura_id, v_cliente_id, v_tienda_id, v_fecha_venta, v_precio_hist);

                -- G. Insertamos Detalle
                INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_tienda, nro_lote)
                VALUES (v_factura_id, 1, 1, 'M', r_toy.codigo, v_tienda_id, v_lote_counter);
                
            END LOOP;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL; 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('   Error en ' || r_pais.nombre || ': ' || SQLERRM);
        END;
        
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('>>> PROCESO COMPLETADO EXITOSAMENTE <<<');
END;
/
