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
