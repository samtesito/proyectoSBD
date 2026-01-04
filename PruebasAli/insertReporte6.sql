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
