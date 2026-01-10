------------------------------------------------------------
-- DATOS PARA REPORTE 6: VENTAS ONLINE (Semestrales)
------------------------------------------------------------

-- Aseguramos catalogo para Venezuela y España
INSERT INTO CATALOGOS_LEGO (id_pais, cod_juguete, limite) VALUES (58, 409, 100); -- Groot en Vzla
INSERT INTO CATALOGOS_LEGO (id_pais, cod_juguete, limite) VALUES (34, 408, 100); -- Spiderman en España

-- VENEZUELA: Venta Semestre 1, 2025
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total)
VALUES (800001, TO_DATE('15/03/2025','DD/MM/YYYY'), 1001, 50, 200.00); -- Marzo (Sem 1)

INSERT INTO DETALLES_FACTURA_ONLINE (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_pais)
VALUES (800001, 1, 5, 'A', 408, 58);

-- VENEZUELA: Venta Semestre 2, 2025
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total)
VALUES (800002, TO_DATE('10/09/2025','DD/MM/YYYY'), 1001, 20, 100.00); -- Septiembre (Sem 2)

INSERT INTO DETALLES_FACTURA_ONLINE (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_pais)
VALUES (800002, 1, 2, 'A', 409, 58);

-- ESPAÑA: Venta Semestre 1, 2025 (Debe salir ordenado según ventas totales)
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total)
VALUES (800003, TO_DATE('05/05/2025','DD/MM/YYYY'), 1008, 100, 500.00); -- Mayo (Sem 1)

INSERT INTO DETALLES_FACTURA_ONLINE (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_pais)
VALUES (800003, 1, 10, 'A', 408, 34);

COMMIT;




------------------------------------------------------------
-- DATOS EXTRA REPORTE 6: AÑOS 2024 y 2026 (Solo Semestre 1)
------------------------------------------------------------

-- ==========================================
-- AÑO 2024 - SEMESTRE 1 (Enero - Junio)
-- ==========================================

-- VENEZUELA (Zona Dólar) - Enero 2024
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total)
VALUES (800010, TO_DATE('15/01/2024','DD/MM/YYYY'), 1001, 30, 150.00); 

INSERT INTO DETALLES_FACTURA_ONLINE (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_pais)
VALUES (800010, 1, 3, 'A', 409, 58);

-- ESPAÑA (Zona Euro) - Abril 2024
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total)
VALUES (800011, TO_DATE('20/04/2024','DD/MM/YYYY'), 1008, 80, 420.50); 

INSERT INTO DETALLES_FACTURA_ONLINE (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_pais)
VALUES (800011, 1, 8, 'A', 408, 34);


-- ==========================================
-- AÑO 2026 - SEMESTRE 1 (Enero - Junio)
-- ==========================================

-- VENEZUELA (Zona Dólar) - Febrero 2026 (Venta grande para probar ordenamiento)
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total)
VALUES (800020, TO_DATE('14/02/2026','DD/MM/YYYY'), 1001, 150, 800.00); 

INSERT INTO DETALLES_FACTURA_ONLINE (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_pais)
VALUES (800020, 1, 10, 'A', 409, 58);

-- ESPAÑA (Zona Euro) - Marzo 2026 (Venta pequeña)
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total)
VALUES (800021, TO_DATE('10/03/2026','DD/MM/YYYY'), 1008, 10, 55.00); 

INSERT INTO DETALLES_FACTURA_ONLINE (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_pais)
VALUES (800021, 1, 1, 'A', 408, 34);

COMMIT;





-------------------------------------------------------------------------
-- DATOS DE RELLENO: SEMESTRE 2 (2024, 2026) Y REFUERZO SEMESTRE 1 (2025)
-------------------------------------------------------------------------

-- ===================================================
-- AÑO 2024 - SEMESTRE 2 (Julio - Diciembre)
-- ===================================================

-- VENEZUELA (Zona Dólar) - Agosto 2024
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total)
VALUES (800030, TO_DATE('15/08/2024','DD/MM/YYYY'), 1001, 40, 200.00); 

INSERT INTO DETALLES_FACTURA_ONLINE (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_pais)
VALUES (800030, 1, 4, 'A', 409, 58);

-- ESPAÑA (Zona Euro) - Noviembre 2024 (Navidad adelantada)
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total)
VALUES (800031, TO_DATE('20/11/2024','DD/MM/YYYY'), 1008, 120, 600.00); 

INSERT INTO DETALLES_FACTURA_ONLINE (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_pais)
VALUES (800031, 1, 10, 'A', 408, 34);


-- ===================================================
-- AÑO 2025 - SEMESTRE 1 (Refuerzo extra)
-- ===================================================
-- Nota: Ya tenías datos aquí, pero agregamos más para dar volumen.

-- VENEZUELA (Zona Dólar) - Febrero 2025
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total)
VALUES (800040, TO_DATE('14/02/2025','DD/MM/YYYY'), 1001, 25, 120.00); 

INSERT INTO DETALLES_FACTURA_ONLINE (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_pais)
VALUES (800040, 1, 2, 'A', 409, 58);

-- ESPAÑA (Zona Euro) - Junio 2025
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total)
VALUES (800041, TO_DATE('01/06/2025','DD/MM/YYYY'), 1008, 60, 300.00); 

INSERT INTO DETALLES_FACTURA_ONLINE (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_pais)
VALUES (800041, 1, 5, 'A', 408, 34);


-- ===================================================
-- AÑO 2026 - SEMESTRE 2 (Julio - Diciembre)
-- ===================================================

-- VENEZUELA (Zona Dólar) - Octubre 2026
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total)
VALUES (800050, TO_DATE('31/10/2026','DD/MM/YYYY'), 1001, 10, 50.00); 

INSERT INTO DETALLES_FACTURA_ONLINE (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_pais)
VALUES (800050, 1, 1, 'A', 409, 58);

-- ESPAÑA (Zona Euro) - Diciembre 2026 (Fin de año)
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total)
VALUES (800051, TO_DATE('24/12/2026','DD/MM/YYYY'), 1008, 200, 1000.00); 

INSERT INTO DETALLES_FACTURA_ONLINE (nro_fact, id_det_fact, cant_prod, tipo_cli, cod_juguete, id_pais)
VALUES (800051, 1, 20, 'A', 408, 34);

COMMIT;
