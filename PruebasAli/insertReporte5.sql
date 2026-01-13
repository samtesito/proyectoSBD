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


























SET SERVEROUTPUT ON;

DECLARE
    -- Variables de Configuración 2025
    v_cliente_id     NUMBER := 1001; 
    v_fecha_venta    DATE := TO_DATE('20/08/2025', 'DD/MM/YYYY'); -- Fecha en 2025
    v_fecha_lote     DATE := TO_DATE('01/02/2025', 'DD/MM/YYYY');
    
    -- Variables de IDs
    v_tienda_id      NUMBER;
    v_factura_id     NUMBER;
    
    -- Variables Temporales
    v_ciudad_id      NUMBER;
    v_estado_id      NUMBER;
    v_precio_hist    NUMBER;
    v_lote_num       NUMBER; -- Para calcular el siguiente lote disponible
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== GENERANDO VENTAS PARA EL AÑO 2025 ===');
    DBMS_OUTPUT.PUT_LINE('Nota: Se mantendran las tiendas existentes del 2024 para tener historial.');

    -- Inicializamos ID de Factura (El de tienda lo manejamos dentro del loop)
    SELECT NVL(MAX(nro_fact), 0) INTO v_factura_id FROM FACTURAS_TIENDA;

    -- Recorremos todos los países
    FOR r_pais IN (SELECT id, nombre FROM PAISES) LOOP
        
        BEGIN
            -- 1. GESTIÓN DE LA TIENDA
            -- Intentamos buscar si ya existe la tienda creada en el paso anterior
            BEGIN
                SELECT id INTO v_tienda_id
                FROM TIENDAS_LEGO
                WHERE nombre = 'LEGO Store ' || r_pais.nombre
                FETCH FIRST 1 ROW ONLY;
                
                DBMS_OUTPUT.PUT_LINE('-> Usando tienda existente en: ' || r_pais.nombre);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    -- Si no existe (por si borraste algo), la creamos de cero
                    SELECT NVL(MAX(id), 0) + 1 INTO v_tienda_id FROM TIENDAS_LEGO;
                    
                    SELECT id, id_estado INTO v_ciudad_id, v_estado_id
                    FROM CIUDADES WHERE id_pais = r_pais.id FETCH FIRST 1 ROW ONLY;

                    INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
                    VALUES (v_tienda_id, 'LEGO Store ' || r_pais.nombre, 'Av. Principal 2025', r_pais.id, v_estado_id, v_ciudad_id);
                    
                    DBMS_OUTPUT.PUT_LINE('-> Nueva tienda creada en: ' || r_pais.nombre);
            END;

            -- 2. SELECCIONAR PRODUCTOS (3 Juguetes nuevos al azar)
            FOR r_toy IN (
                SELECT codigo FROM JUGUETES 
                ORDER BY DBMS_RANDOM.VALUE 
                FETCH FIRST 3 ROWS ONLY
            ) LOOP
                
                -- A. AUTORIZAR EN CATALOGO (Trigger TGR_LOTE_EN_CATALOGO)
                -- Importante: Puede que el juguete sea nuevo para ese país en 2025
                INSERT INTO CATALOGOS_LEGO (id_pais, cod_juguete, limite)
                SELECT r_pais.id, r_toy.codigo, 1000 FROM DUAL
                WHERE NOT EXISTS (
                    SELECT 1 FROM CATALOGOS_LEGO 
                    WHERE id_pais = r_pais.id AND cod_juguete = r_toy.codigo
                );

                -- B. BUSCAR PRECIO (Fecha 2025)
                BEGIN
                    SELECT precio INTO v_precio_hist
                    FROM HISTORICO_PRECIOS_JUGUETES
                    WHERE cod_juguete = r_toy.codigo 
                      AND v_fecha_venta >= f_inicio
                      AND (f_fin IS NULL OR v_fecha_venta <= f_fin)
                    FETCH FIRST 1 ROW ONLY;
                EXCEPTION 
                    WHEN NO_DATA_FOUND THEN v_precio_hist := 65; -- Un poco más caro que en 2024 por inflación simulada
                END;

                -- C. CALCULAR NRO_LOTE (Para no chocar con los de 2024)
                -- Buscamos el lote más alto que tenga ese juguete en esa tienda y le sumamos 1
                SELECT NVL(MAX(nro_lote), 0) + 1 
                INTO v_lote_num
                FROM LOTES_SET_TIENDA
                WHERE cod_juguete = r_toy.codigo AND id_tienda = v_tienda_id;

                -- D. CREAR STOCK (LOTE 2025)
                INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui, cant_prod)
                VALUES (r_toy.codigo, v_tienda_id, v_lote_num, v_fecha_lote, 500);

                -- E. CREAR FACTURA
                v_factura_id := v_factura_id + 1;
                
                INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total)
                VALUES (v_factura_id, v_cliente_id, v_tienda_id, v_fecha_venta, v_precio_hist);

                -- F. CREAR DETALLE
                INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_tienda, nro_lote)
                VALUES (v_factura_id, 1, 1, 'M', r_toy.codigo, v_tienda_id, v_lote_num);
                
            END LOOP;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL; 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('   Error en ' || r_pais.nombre || ': ' || SQLERRM);
        END;
        
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('>>> DATOS 2025 GENERADOS CON ÉXITO <<<');
END;
/





















SET SERVEROUTPUT ON;

DECLARE
    -- Variables de Configuración 2026
    v_cliente_id     NUMBER := 1001; 
    v_fecha_venta    DATE := TO_DATE('15/10/2026', 'DD/MM/YYYY'); -- Fecha futura 2026
    v_fecha_lote     DATE := TO_DATE('01/03/2026', 'DD/MM/YYYY');
    
    -- Variables de IDs
    v_tienda_id      NUMBER;
    v_factura_id     NUMBER;
    
    -- Variables Temporales
    v_ciudad_id      NUMBER;
    v_estado_id      NUMBER;
    v_precio_hist    NUMBER;
    v_lote_num       NUMBER; 
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== GENERANDO VENTAS FUTURAS PARA EL AÑO 2026 ===');

    -- Inicializamos ID de Factura (seguimos la secuencia)
    SELECT NVL(MAX(nro_fact), 0) INTO v_factura_id FROM FACTURAS_TIENDA;

    -- Recorremos todos los países
    FOR r_pais IN (SELECT id, nombre FROM PAISES) LOOP
        
        BEGIN
            -- 1. GESTIÓN DE LA TIENDA (Reutilizar existente o crear si falta)
            BEGIN
                SELECT id INTO v_tienda_id
                FROM TIENDAS_LEGO
                WHERE nombre = 'LEGO Store ' || r_pais.nombre
                FETCH FIRST 1 ROW ONLY;
                
                DBMS_OUTPUT.PUT_LINE('-> Tienda encontrada en: ' || r_pais.nombre);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    -- Si por alguna razón no existe, la creamos
                    SELECT NVL(MAX(id), 0) + 1 INTO v_tienda_id FROM TIENDAS_LEGO;
                    SELECT id, id_estado INTO v_ciudad_id, v_estado_id
                    FROM CIUDADES WHERE id_pais = r_pais.id FETCH FIRST 1 ROW ONLY;

                    INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
                    VALUES (v_tienda_id, 'LEGO Store ' || r_pais.nombre, 'Av. Futuro 2026', r_pais.id, v_estado_id, v_ciudad_id);
            END;

            -- 2. SELECCIONAR PRODUCTOS (3 Juguetes al azar)
            FOR r_toy IN (
                SELECT codigo FROM JUGUETES 
                ORDER BY DBMS_RANDOM.VALUE 
                FETCH FIRST 3 ROWS ONLY
            ) LOOP
                
                -- A. AUTORIZAR EN CATALOGO (Si no estaba autorizado antes)
                INSERT INTO CATALOGOS_LEGO (id_pais, cod_juguete, limite)
                SELECT r_pais.id, r_toy.codigo, 1000 FROM DUAL
                WHERE NOT EXISTS (
                    SELECT 1 FROM CATALOGOS_LEGO 
                    WHERE id_pais = r_pais.id AND cod_juguete = r_toy.codigo
                );

                -- B. BUSCAR PRECIO (Si no hay histórico 2026, asumimos inflación a 75)
                BEGIN
                    SELECT precio INTO v_precio_hist
                    FROM HISTORICO_PRECIOS_JUGUETES
                    WHERE cod_juguete = r_toy.codigo 
                      AND v_fecha_venta >= f_inicio
                      AND (f_fin IS NULL OR v_fecha_venta <= f_fin)
                    FETCH FIRST 1 ROW ONLY;
                EXCEPTION 
                    WHEN NO_DATA_FOUND THEN v_precio_hist := 75; 
                END;

                -- C. CALCULAR SIGUIENTE LOTE DISPONIBLE
                -- Esto garantiza que no repitamos claves primarias (lote 1, 2, 3...)
                SELECT NVL(MAX(nro_lote), 0) + 1 
                INTO v_lote_num
                FROM LOTES_SET_TIENDA
                WHERE cod_juguete = r_toy.codigo AND id_tienda = v_tienda_id;

                -- D. CREAR STOCK (LOTE 2026)
                INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui, cant_prod)
                VALUES (r_toy.codigo, v_tienda_id, v_lote_num, v_fecha_lote, 500);

                -- E. CREAR FACTURA
                v_factura_id := v_factura_id + 1;
                
                INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total)
                VALUES (v_factura_id, v_cliente_id, v_tienda_id, v_fecha_venta, v_precio_hist);

                -- F. CREAR DETALLE
                INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_tienda, nro_lote)
                VALUES (v_factura_id, 1, 1, 'M', r_toy.codigo, v_tienda_id, v_lote_num);
                
            END LOOP;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL; 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('   Error en ' || r_pais.nombre || ': ' || SQLERRM);
        END;
        
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('>>> DATOS 2026 GENERADOS CON ÉXITO <<<');
END;
/
