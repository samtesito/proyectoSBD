SET SERVEROUTPUT ON;

DECLARE
    -- Configuración
    v_years         SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST(2024, 2025, 2026); -- Años a generar
    
    -- Variables de trabajo
    v_factura_id    NUMBER;
    v_detalle_id    NUMBER;
    v_cliente_id    NUMBER;
    v_precio        NUMBER;
    v_fecha_venta   DATE;
    v_semestre      NUMBER;
    
    -- Contadores
    v_nuevos_cli    NUMBER := 0;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== INICIANDO GENERACIÓN DE VENTAS ONLINE (REPORTE 6) ===');
    
    -- 1. LIMPIEZA PREVIA (Opcional: borra ventas online anteriores para no duplicar reporte)
    -- DELETE FROM DETALLES_FACTURA_ONLINE;
    -- DELETE FROM FACTURAS_ONLINE;
    -- COMMIT;
    
    -- Inicializar IDs
    SELECT NVL(MAX(nro_fact), 700000) INTO v_factura_id FROM FACTURAS_ONLINE;

    -- ==============================================================================
    -- BUCLE PRINCIPAL: Recorrer PAISES -> AÑOS -> SEMESTRES
    -- ==============================================================================
    FOR r_pais IN (SELECT id, nombre, gentilicio FROM PAISES ORDER BY id) LOOP
        
        -- A. OBTENER O CREAR CLIENTE PARA ESTE PAÍS
        -- (Las ventas online dependen del país de residencia del cliente)
        BEGIN
            SELECT id_lego INTO v_cliente_id
            FROM CLIENTES 
            WHERE id_pais_resi = r_pais.id 
            FETCH FIRST 1 ROW ONLY;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- Si no hay cliente en este país, creamos uno dummy
                SELECT NVL(MAX(id_lego), 1000) + 1 INTO v_cliente_id FROM CLIENTES;
                
                INSERT INTO CLIENTES (id_lego, prim_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi)
                VALUES (v_cliente_id, 'Cliente', 'Online', r_pais.gentilicio, TO_DATE('1990-01-01','YYYY-MM-DD'), 'ONL-'||r_pais.id, r_pais.id);
                
                v_nuevos_cli := v_nuevos_cli + 1;
        END;

        -- B. RECORRER AÑOS (2024, 2025, 2026)
        FOR y IN 1..v_years.COUNT LOOP
            
            -- C. RECORRER SEMESTRES (1 y 2)
            FOR sem IN 1..2 LOOP
                
                -- Definir fecha según semestre
                IF sem = 1 THEN
                    -- Semestre 1: 15 de Marzo
                    v_fecha_venta := TO_DATE('15/03/' || v_years(y), 'DD/MM/YYYY');
                ELSE
                    -- Semestre 2: 20 de Octubre
                    v_fecha_venta := TO_DATE('20/10/' || v_years(y), 'DD/MM/YYYY');
                END IF;

                -- D. SELECCIONAR UN JUGUETE AL AZAR
                FOR r_toy IN (SELECT codigo FROM JUGUETES ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 1 ROW ONLY) LOOP
                    
                    -- 1. Asegurar que está en el catálogo (Regla de negocio online)
                    INSERT INTO CATALOGOS_LEGO (id_pais, cod_juguete, limite)
                    SELECT r_pais.id, r_toy.codigo, 1000 FROM DUAL
                    WHERE NOT EXISTS (
                        SELECT 1 FROM CATALOGOS_LEGO WHERE id_pais = r_pais.id AND cod_juguete = r_toy.codigo
                    );

                    -- 2. Buscar Precio Histórico
                    BEGIN
                        SELECT precio INTO v_precio
                        FROM HISTORICO_PRECIOS_JUGUETES
                        WHERE cod_juguete = r_toy.codigo 
                          AND v_fecha_venta >= f_inicio
                          AND (f_fin IS NULL OR v_fecha_venta <= f_fin)
                        FETCH FIRST 1 ROW ONLY;
                    EXCEPTION 
                        WHEN NO_DATA_FOUND THEN v_precio := 45; -- Precio default
                    END;

                    -- 3. Crear Factura Online
                    v_factura_id := v_factura_id + 1;
                    
                    -- Nota: Asumo que FACTURAS_ONLINE tiene campos similares a la de Tienda
                    -- Si tu tabla tiene columnas diferentes, ajústalas aquí.
                    INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, total, id_cliente)
                    VALUES (v_factura_id, v_fecha_venta, v_precio, v_cliente_id);

                    -- 4. Crear Detalle Online
                    -- Nota: En tu archivo inserts.sql vi que el detalle online lleva 'id_pais'
                    INSERT INTO DETALLES_FACTURA_ONLINE (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_pais)
                    VALUES (v_factura_id, 1, 1, 'A', r_toy.codigo, r_pais.id);

                END LOOP; -- Fin Juguete

            END LOOP; -- Fin Semestres
        END LOOP; -- Fin Años

    END LOOP; -- Fin Países

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('=== PROCESO FINALIZADO ===');
    DBMS_OUTPUT.PUT_LINE('Se crearon clientes nuevos: ' || v_nuevos_cli);
    DBMS_OUTPUT.PUT_LINE('Última factura generada: ' || v_factura_id);
END;
/
