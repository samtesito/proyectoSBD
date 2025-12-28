------------------------------------------------------------
-- 1. Poblar FACTURAS_TIENDA con 10 facturas de distintas fechas
------------------------------------------------------------
INSERT INTO FACTURAS_TIENDA (nro_fact, f_emision, id_tienda) VALUES (1001, DATE '2025-12-13', 1);
INSERT INTO FACTURAS_TIENDA (nro_fact, f_emision, id_tienda) VALUES (1002, DATE '2025-12-13', 1);
INSERT INTO FACTURAS_TIENDA (nro_fact, f_emision, id_tienda) VALUES (1003, DATE '2025-12-13', 1);
INSERT INTO FACTURAS_TIENDA (nro_fact, f_emision, id_tienda) VALUES (1004, DATE '2025-12-13', 1);
INSERT INTO FACTURAS_TIENDA (nro_fact, f_emision, id_tienda) VALUES (1005, DATE '2025-12-13', 1);
INSERT INTO FACTURAS_TIENDA (nro_fact, f_emision, id_tienda) VALUES (1006, DATE '2025-12-14', 1);
INSERT INTO FACTURAS_TIENDA (nro_fact, f_emision, id_tienda) VALUES (1007, DATE '2025-12-14', 1);
INSERT INTO FACTURAS_TIENDA (nro_fact, f_emision, id_tienda) VALUES (1008, DATE '2025-12-15', 2);
INSERT INTO FACTURAS_TIENDA (nro_fact, f_emision, id_tienda) VALUES (1009, DATE '2025-12-15', 2);
INSERT INTO FACTURAS_TIENDA (nro_fact, f_emision, id_tienda) VALUES (1010, DATE '2025-12-16', 2);

------------------------------------------------------------
-- 2. Poblar DETALLES_FACTURA_TIENDA con 10 registros
-- Cada detalle vincula una factura con un juguete, lote y cantidad
------------------------------------------------------------
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, cod_juguete, id_tienda, nro_lote, cant_prod, codigo)
VALUES (1001, 501, 1, 2001, 5, 501);
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, cod_juguete, id_tienda, nro_lote, cant_prod, codigo)
VALUES (1002, 501, 1, 2001, 3, 501);
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, cod_juguete, id_tienda, nro_lote, cant_prod, codigo)
VALUES (1003, 502, 1, 2002, 4, 502);
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, cod_juguete, id_tienda, nro_lote, cant_prod, codigo)
VALUES (1004, 502, 1, 2002, 6, 502);
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, cod_juguete, id_tienda, nro_lote, cant_prod, codigo)
VALUES (1005, 503, 1, 2003, 2, 503);
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, cod_juguete, id_tienda, nro_lote, cant_prod, codigo)
VALUES (1006, 503, 1, 2003, 7, 503);
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, cod_juguete, id_tienda, nro_lote, cant_prod, codigo)
VALUES (1007, 504, 1, 2004, 8, 504);
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, cod_juguete, id_tienda, nro_lote, cant_prod, codigo)
VALUES (1008, 504, 2, 2004, 5, 504);
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, cod_juguete, id_tienda, nro_lote, cant_prod, codigo)
VALUES (1009, 505, 2, 2005, 9, 505);
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, cod_juguete, id_tienda, nro_lote, cant_prod, codigo)
VALUES (1010, 505, 2, 2005, 4, 505);

------------------------------------------------------------
-- 3. Poblar DESCUENTOS con 10 registros iniciales
-- Estos sirven como base para verificar que el procedimiento inserta nuevos descuentos
------------------------------------------------------------
INSERT INTO DESCUENTOS (id_desc, id_tienda, cod_juguete, nro_lote, fecha, cant)
VALUES (desce.NEXTVAL, 1, 501, 2001, DATE '2025-12-13', 2);
INSERT INTO DESCUENTOS (id_desc, id_tienda, cod_juguete, nro_lote, fecha, cant)
VALUES (desce.NEXTVAL, 1, 502, 2002, DATE '2025-12-13', 1);
INSERT INTO DESCUENTOS (id_desc, id_tienda, cod_juguete, nro_lote, fecha, cant)
VALUES (desce.NEXTVAL, 1, 503, 2003, DATE '2025-12-14', 3);
INSERT INTO DESCUENTOS (id_desc, id_tienda, cod_juguete, nro_lote, fecha, cant)
VALUES (desce.NEXTVAL, 1, 504, 2004, DATE '2025-12-14', 2);
INSERT INTO DESCUENTOS (id_desc, id_tienda, cod_juguete, nro_lote, fecha, cant)
VALUES (desce.NEXTVAL, 2, 504, 2004, DATE '2025-12-15', 4);
INSERT INTO DESCUENTOS (id_desc, id_tienda, cod_juguete, nro_lote, fecha, cant)
VALUES (desce.NEXTVAL, 2, 505, 2005, DATE '2025-12-15', 5);
INSERT INTO DESCUENTOS (id_desc, id_tienda, cod_juguete, nro_lote, fecha, cant)
VALUES (desce.NEXTVAL, 2, 505, 2005, DATE '2025-12-16', 2);
INSERT INTO DESCUENTOS (id_desc, id_tienda, cod_juguete, nro_lote, fecha, cant)
VALUES (desce.NEXTVAL, 1, 501, 2001, DATE '2025-12-13', 1);
INSERT INTO DESCUENTOS (id_desc, id_tienda, cod_juguete, nro_lote, fecha, cant)
VALUES (desce.NEXTVAL, 1, 502, 2002, DATE '2025-12-13', 2);
INSERT INTO DESCUENTOS (id_desc, id_tienda, cod_juguete, nro_lote, fecha, cant)
VALUES (desce.NEXTVAL, 1, 503, 2003, DATE '2025-12-14', 1);

------------------------------------------------------------
-- Con este set de datos puedes ejecutar el procedimiento
-- y verificar que se inserten nuevos descuentos agregados
-- según las facturas y detalles de la fecha indicada.
------------------------------------------------------------
