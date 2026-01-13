------------------------------------------------------------
-- DATOS PARA REPORTE 5: VENTAS FÍSICAS (Top Productos)
------------------------------------------------------------

-- Autorizar productos en Venezuela (ID 58)
-- Nota: Usamos MERGE o INSERT con cuidado para evitar duplicados si ya existen
INSERT INTO CATALOGOS_LEGO (id_pais, cod_juguete, limite) 
SELECT 58, 409, 100 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM CATALOGOS_LEGO WHERE id_pais=58 AND cod_juguete=409);

INSERT INTO CATALOGOS_LEGO (id_pais, cod_juguete, limite) 
SELECT 58, 2011, 100 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM CATALOGOS_LEGO WHERE id_pais=58 AND cod_juguete=2011);

-- Autorizar productos en Chile (ID 56)
INSERT INTO CATALOGOS_LEGO (id_pais, cod_juguete, limite) 
SELECT 56, 2012, 100 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM CATALOGOS_LEGO WHERE id_pais=56 AND cod_juguete=2012);

INSERT INTO CATALOGOS_LEGO (id_pais, cod_juguete, limite) 
SELECT 56, 3012, 100 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM CATALOGOS_LEGO WHERE id_pais=56 AND cod_juguete=3012);

INSERT INTO CATALOGOS_LEGO (id_pais, cod_juguete, limite) 
SELECT 56, 408, 100 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM CATALOGOS_LEGO WHERE id_pais=56 AND cod_juguete=408);

COMMIT;



-- 1. Crear LOTES (Inventario) para poder vender en las tiendas
-- Tienda 10 (Venezuela), Tienda 21 (Chile), Tienda 12 (Israel), Tienda 49 (Alemania - debes crearla si no está en el script base, usaré la 10 y 21 que sé que están)

-- Lotes en Venezuela (Tienda 10)
INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui, cant_prod) VALUES (408, 10, 100, SYSDATE-400, 500); -- Spiderman
INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui, cant_prod) VALUES (409, 10, 100, SYSDATE-400, 500); -- Groot
INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui, cant_prod) VALUES (2011, 10, 100, SYSDATE-400, 500); -- Batman Keychain

-- Lotes en Chile (Tienda 21)
INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui, cant_prod) VALUES (2012, 21, 100, SYSDATE-400, 500); -- Batman Mech
INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui, cant_prod) VALUES (3012, 21, 100, SYSDATE-400, 500); -- LOVE Art
INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui, cant_prod) VALUES (408, 21, 100, SYSDATE-400, 500); -- Spiderman

COMMIT;

-- 2. FACTURAS Y DETALLES (Simulación de Ventas)

-- VENEZUELA 2024 (Para que Spiderman sea el Top 1)
INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total) 
VALUES (600001, 1001, 10, TO_DATE('15/06/2024','DD/MM/YYYY'), 500);
-- Vendemos 10 Spiderman
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_tienda, nro_lote)
VALUES (600001, 1, 10, 'A', 408, 10, 100);
-- Vendemos 5 Groot
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_tienda, nro_lote)
VALUES (600001, 2, 5, 'A', 409, 10, 100);

-- VENEZUELA 2025 (Para ver la diferencia anual)
INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total) 
VALUES (600002, 1001, 10, TO_DATE('20/08/2025','DD/MM/YYYY'), 200);
-- Vendemos 20 Groot (Ahora Groot es Top 1 en 2025)
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_tienda, nro_lote)
VALUES (600002, 1, 20, 'A', 409, 10, 100);

-- CHILE 2024 (Para tener datos de otro país en América)
INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total) 
VALUES (600003, 1005, 21, TO_DATE('10/02/2024','DD/MM/YYYY'), 800);
-- Vendemos 15 Batman Mech
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_tienda, nro_lote)
VALUES (600003, 1, 15, 'A', 2012, 21, 100);

COMMIT;







---------------------------------------------------------------------
-- PAQUETE DE EXPANSIÓN PARA REPORTE 5 (Top 3 Anual)
-- Incluye: Precios Históricos, Nuevas Tiendas y Ventas 2024-2025
---------------------------------------------------------------------

-- =================================================================
-- 1. PRECIOS HISTÓRICOS (CRÍTICO: SIN ESTO NO HAY DINERO EN 2024)
-- =================================================================
-- Definimos precios para 2024 y 2025 para que el cálculo monetario funcione



-- =================================================================
-- 2. INFRAESTRUCTURA (MÉXICO Y ESPAÑA)
-- =================================================================

-- 2.1 Tienda en MÉXICO (ID 5201)
MERGE INTO TIENDAS_LEGO t USING (SELECT 5201 id, 'LEGO Santa Fe' n, 'CDMX' d, 52 ip, 1 ie, 101 ic FROM DUAL) s
ON (t.id = s.id) WHEN NOT MATCHED THEN INSERT (id, nombre, direccion, id_pais, id_estado, id_ciudad) VALUES (s.id, s.n, s.d, s.ip, s.ie, s.ic);

-- 2.2 Tienda en ESPAÑA (ID 3401) - Si no tenías la 34, usamos esta nueva
MERGE INTO TIENDAS_LEGO t USING (SELECT 3401 id, 'LEGO Gran Vía' n, 'Madrid' d, 34 ip, 1 ie, 101 ic FROM DUAL) s
ON (t.id = s.id) WHEN NOT MATCHED THEN INSERT (id, nombre, direccion, id_pais, id_estado, id_ciudad) VALUES (s.id, s.n, s.d, s.ip, s.ie, s.ic);

-- 2.3 Clientes Locales
-- Cliente Mexicano
MERGE INTO CLIENTES c USING (SELECT 1052 id, 'Luis' n, 'Miguel' a, 'X' sa, DATE '1970-04-19' fn, 'MX888' d, 52 ip, 'PAS-MX-01' p, DATE '2030-01-01' vp FROM DUAL) s
ON (c.id_lego = s.id) WHEN NOT MATCHED THEN INSERT (id_lego, prim_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi, pasaporte, f_venc_pasap) VALUES (s.id, s.n, s.a, s.sa, s.fn, s.d, s.ip, s.p, s.vp);

-- Cliente Español
MERGE INTO CLIENTES c USING (SELECT 1034 id, 'Ibai' n, 'Llanos' a, 'X' sa, DATE '1995-03-26' fn, 'ES777' d, 34 ip, NULL p, NULL vp FROM DUAL) s
ON (c.id_lego = s.id) WHEN NOT MATCHED THEN INSERT (id_lego, prim_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi, pasaporte, f_venc_pasap) VALUES (s.id, s.n, s.a, s.sa, s.fn, s.d, s.ip, s.p, s.vp);

COMMIT;

-- =================================================================
-- 3. INVENTARIO (CATÁLOGOS Y LOTES)
-- =================================================================

-- Autorizamos juguetes en Mexico (52) y España (34)
DECLARE
    TYPE num_list IS TABLE OF NUMBER;
    v_paises num_list := num_list(52, 34); 
    v_jugues num_list := num_list(411, 3013, 2012, 408, 409); -- Daily Bugle, Mona Lisa, Batman, Spider, Groot
    v_cnt NUMBER;
BEGIN
    FOR i IN 1..v_paises.COUNT LOOP
        FOR j IN 1..v_jugues.COUNT LOOP
            SELECT COUNT(*) INTO v_cnt FROM CATALOGOS_LEGO WHERE id_pais = v_paises(i) AND cod_juguete = v_jugues(j);
            IF v_cnt = 0 THEN INSERT INTO CATALOGOS_LEGO (id_pais, cod_juguete, limite) VALUES (v_paises(i), v_jugues(j), 50); END IF;
        END LOOP;
    END LOOP;
END;
/

-- Creamos Lotes (Stock) en Tienda Mexico (5201) y España (3401)
DECLARE
    TYPE num_list IS TABLE OF NUMBER;
    v_tiendas num_list := num_list(5201, 3401); 
    v_jugues num_list := num_list(411, 3013, 2012, 408, 409);
    v_cnt NUMBER;
BEGIN
    FOR i IN 1..v_tiendas.COUNT LOOP
        FOR j IN 1..v_jugues.COUNT LOOP
            SELECT COUNT(*) INTO v_cnt FROM LOTES_SET_TIENDA WHERE id_tienda = v_tiendas(i) AND cod_juguete = v_jugues(j) AND nro_lote = 10;
            IF v_cnt = 0 THEN 
                INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui, cant_prod) 
                VALUES (v_jugues(j), v_tiendas(i), 10, DATE '2023-01-01', 200); -- Lote 10 con 200 unidades
            END IF;
        END LOOP;
    END LOOP;
END;
/
COMMIT;

-- =================================================================
-- 4. VENTAS (AQUÍ ESTÁ LA MAGIA DEL REPORTE)
-- =================================================================

-- --- AÑO 2024 (Competencia AMÉRICA) ---
-- México vende el Daily Bugle (Juguete Caro -> $300 c/u)
-- Esto lo pondrá Top 1 en Dinero, aunque venda pocos.
INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total) VALUES (80001, 1052, 5201, DATE '2024-05-05', 0);
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_tienda, nro_lote) 
VALUES (80001, 1, 10, 'A', 411, 5201, 10); -- 10 Bugles * 300 = $3000

-- México también vende Batman barato (Volumen alto, poco dinero)
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_tienda, nro_lote) 
VALUES (80001, 2, 50, 'A', 2012, 5201, 10); -- 50 Batman * 18 = $900

-- --- AÑO 2024 (Competencia EUROPA) ---
-- España vende la Mona Lisa (Arte)
INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total) VALUES (80002, 1034, 3401, DATE '2024-07-07', 0);
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_tienda, nro_lote) 
VALUES (80002, 1, 40, 'A', 3013, 3401, 10); -- 40 Cuadros * 100 = $4000 (Ganador Europa)


-- --- AÑO 2025 (Cambio de Líderes) ---
-- En 2025, México vende Iron Spider masivamente
INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total) VALUES (90001, 1052, 5201, DATE '2025-09-15', 0);
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_tienda, nro_lote) 
VALUES (90001, 1, 100, 'A', 408, 5201, 10); 

-- En 2025, Venezuela (Tienda 10) vende Groot Bailarín (Juguete 409)
INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total) VALUES (90002, 1001, 10, DATE '2025-06-20', 0);
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_tienda, nro_lote) 
VALUES (90002, 1, 80, 'A', 409, 10, 100);

COMMIT;


--------------------------------------------------------
-- CORRECCIÓN: PRECIO IRON SPIDER (SEMESTRE 2 - 2025)
--------------------------------------------------------
-- Insertamos el precio para la segunda mitad del año



---------------------------------------------------------------------
-- DATOS FUTUROS: MÉXICO 2026
---------------------------------------------------------------------

-- 1. ASEGURAR PRECIOS PARA 2026
-- Necesitamos que el producto tenga un precio válido en esa fecha.
-- El Daily Bugle (411) le pusimos precio infinito (NULL) en el script anterior, así que sirve.
-- Pero vamos a asegurarnos con el Iron Spider (408) también.


-- 2. VENTA EN MÉXICO (AÑO 2026)
-- Usamos el Cliente Mexicano (1052) y la Tienda Santa Fe (5201)

INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total) 
VALUES (99026, 1052, 5201, DATE '2026-03-20', 0);

-- Venta masiva de Iron Spider en 2026
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_tienda, nro_lote) 
VALUES (99026, 1, 150, 'A', 408, 5201, 10); 

COMMIT;


































-------------------------------------------------------------------------
-- 1. CREAR EL JUGUETE (Corregido el valor booleano)
-------------------------------------------------------------------------
-- Cambié 'false' por 0. Si tu columna es de texto, usa 'FALSE' o 'F'.
INSERT INTO JUGUETES (codigo, nombre, descripcion, id_tema, rgo_edad, rgo_precio, tipo_lego, "set", instruc, piezas) 
SELECT 7654, 'Pico Minecraft', 'Herramienta de diamante pixelada', 101, '12+', 'D', 'L', 0, 'Manual incluido', 6020 
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM JUGUETES WHERE codigo = 7654);

-------------------------------------------------------------------------
-- 2. ASEGURAR TIENDA EN MÉXICO (ID 99)
-------------------------------------------------------------------------
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM TIENDAS_LEGO WHERE id = 99;
  IF v_count = 0 THEN
    INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
    VALUES (99, 'LEGO Store Reforma', 'Paseo de la Reforma', 52, 1, 101);
  END IF;
END;
/

-------------------------------------------------------------------------
-- 3. AUTORIZAR EL JUGUETE EN EL CATÁLOGO
-------------------------------------------------------------------------
INSERT INTO CATALOGOS_LEGO (id_pais, cod_juguete, limite) 
SELECT 52, 7654, 50 FROM DUAL 
WHERE NOT EXISTS (SELECT 1 FROM CATALOGOS_LEGO WHERE id_pais=52 AND cod_juguete=7654);

-------------------------------------------------------------------------
-- 4. INSERTAR PRECIO HISTÓRICO (6298.88)
-------------------------------------------------------------------------
INSERT INTO HISTORICO_PRECIOS_JUGUETES (cod_juguete, f_inicio, precio, f_fin) 
SELECT 7654, TO_DATE('01/01/2024','DD/MM/YYYY'), 6298.88, NULL 
FROM DUAL 
WHERE NOT EXISTS (SELECT 1 FROM HISTORICO_PRECIOS_JUGUETES WHERE cod_juguete=7654);

-------------------------------------------------------------------------
-- 5. CREAR INVENTARIO (LOTE 701)
-------------------------------------------------------------------------
INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui, cant_prod) 
SELECT 7654, 99, 701, SYSDATE-150, 20 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM LOTES_SET_TIENDA WHERE cod_juguete=7654 AND id_tienda=99 AND nro_lote=701);

-------------------------------------------------------------------------
-- 6. REGISTRAR LA VENTA (FACTURA 9901)
-------------------------------------------------------------------------
-- Usamos un bloque anónimo para validar que la factura no exista y evitar errores únicos
DECLARE
  v_chk NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_chk FROM FACTURAS_TIENDA WHERE nro_fact = 9901;
  
  IF v_chk = 0 THEN
      INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total) 
      VALUES (
        9901, 
        1004,   -- Cliente Mexicano
        99,     -- Tienda México
        TO_DATE('20/06/2024','DD/MM/YYYY'), 
        6298.88
      );
  END IF;
END;
/

-------------------------------------------------------------------------
-- 7. INSERTAR DETALLE FACTURA (Donde te daba error)
-------------------------------------------------------------------------
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_tienda, nro_lote)
SELECT 9901, 1, 1, 'A', 7654, 99, 701 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM DETALLES_FACTURA_TIENDA WHERE nro_fact=9901 AND id_det_fact=1);

COMMIT;
