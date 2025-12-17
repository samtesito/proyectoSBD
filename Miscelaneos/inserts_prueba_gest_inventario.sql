cells:
  - kind: 2
    value: "------------------------------------------------------------\r

      -- 1. FACTURAS_TIENDA\r

      -- Facturas emitidas en distintas fechas y tiendas\r

      ------------------------------------------------------------\r

      INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision,
      total) VALUES (2001, 3001, 101, DATE '2025-12-13', 150.00);\r

      INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision,
      total) VALUES (2002, 3002, 101, DATE '2025-12-13', 200.00);\r

      INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision,
      total) VALUES (2003, 3003, 101, DATE '2025-12-13', 175.00);\r

      INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision,
      total) VALUES (2004, 3004, 101, DATE '2025-12-14', 220.00);\r

      INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision,
      total) VALUES (2005, 3005, 101, DATE '2025-12-14', 180.00);\r

      INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision,
      total) VALUES (2006, 3006, 102, DATE '2025-12-15', 250.00);\r

      INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision,
      total) VALUES (2007, 3007, 102, DATE '2025-12-15', 300.00);\r

      INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision,
      total) VALUES (2008, 3008, 102, DATE '2025-12-16', 190.00);\r

      INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision,
      total) VALUES (2009, 3009, 102, DATE '2025-12-16', 210.00);\r

      INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision,
      total) VALUES (2010, 3010, 103, DATE '2025-12-17', 260.00);\r

      \r

      ------------------------------------------------------------\r

      -- 2. LOTES_SET_TIENDA\r

      -- Lotes de juguetes disponibles en tiendas\r

      ------------------------------------------------------------\r

      INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui,
      cant_prod) VALUES (501, 101, 1, DATE '2025-11-01', 50);\r

      INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui,
      cant_prod) VALUES (502, 101, 2, DATE '2025-11-02', 40);\r

      INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui,
      cant_prod) VALUES (503, 101, 3, DATE '2025-11-03', 60);\r

      INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui,
      cant_prod) VALUES (504, 101, 4, DATE '2025-11-04', 70);\r

      INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui,
      cant_prod) VALUES (505, 102, 1, DATE '2025-11-05', 80);\r

      INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui,
      cant_prod) VALUES (506, 102, 2, DATE '2025-11-06', 90);\r

      INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui,
      cant_prod) VALUES (507, 102, 3, DATE '2025-11-07', 100);\r

      INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui,
      cant_prod) VALUES (508, 102, 4, DATE '2025-11-08', 110);\r

      INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui,
      cant_prod) VALUES (509, 103, 1, DATE '2025-11-09', 120);\r

      INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui,
      cant_prod) VALUES (510, 103, 2, DATE '2025-11-10', 130);\r

      \r

      ------------------------------------------------------------\r

      -- 3. DETALLES_FACTURA_TIENDA\r

      -- Detalles que vinculan facturas con juguetes y lotes\r

      ------------------------------------------------------------\r

      INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod,
      tipo_cli, cod_juguete, id_tienda, nro_lote) VALUES (2001, 1, 5, 'A', 501,
      101, 1);\r

      INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod,
      tipo_cli, cod_juguete, id_tienda, nro_lote) VALUES (2002, 2, 3, 'M', 502,
      101, 2);\r

      INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod,
      tipo_cli, cod_juguete, id_tienda, nro_lote) VALUES (2003, 3, 4, 'A', 503,
      101, 3);\r

      INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod,
      tipo_cli, cod_juguete, id_tienda, nro_lote) VALUES (2004, 4, 6, 'M', 504,
      101, 4);\r

      INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod,
      tipo_cli, cod_juguete, id_tienda, nro_lote) VALUES (2005, 5, 2, 'A', 501,
      101, 1);\r

      INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod,
      tipo_cli, cod_juguete, id_tienda, nro_lote) VALUES (2006, 6, 7, 'M', 505,
      102, 1);\r

      INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod,
      tipo_cli, cod_juguete, id_tienda, nro_lote) VALUES (2007, 7, 8, 'A', 506,
      102, 2);\r

      INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod,
      tipo_cli, cod_juguete, id_tienda, nro_lote) VALUES (2008, 8, 5, 'M', 507,
      102, 3);\r

      INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod,
      tipo_cli, cod_juguete, id_tienda, nro_lote) VALUES (2009, 9, 9, 'A', 508,
      102, 4);\r

      INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod,
      tipo_cli, cod_juguete, id_tienda, nro_lote) VALUES (2010, 10, 4, 'M', 509,
      103, 1);\r

      \r

      ------------------------------------------------------------\r

      -- 4. DESCUENTOS\r

      -- Registros iniciales para validar que el procedimiento inserta nuevos
      descuentos\r

      ------------------------------------------------------------\r

      INSERT INTO DESCUENTOS (cod_juguete, id_tienda, nro_lote, id_desc, fecha,
      cant) \r

      VALUES (501, 101, 1, 1, DATE '2025-12-13', 2);\r

      \r

      INSERT INTO DESCUENTOS (cod_juguete, id_tienda, nro_lote, id_desc, fecha,
      cant) \r

      VALUES (502, 101, 2, 2, DATE '2025-12-13', 1);\r

      \r

      INSERT INTO DESCUENTOS (cod_juguete, id_tienda, nro_lote, id_desc, fecha,
      cant) \r

      VALUES (503, 101, 3, 3, DATE '2025-12-13', 3);\r

      \r

      INSERT INTO DESCUENTOS (cod_juguete, id_tienda, nro_lote, id_desc, fecha,
      cant) \r

      VALUES (504, 101, 4, 4, DATE '2025-12-14', 2);\r

      \r

      INSERT INTO DESCUENTOS (cod_juguete, id_tienda, nro_lote, id_desc, fecha,
      cant) \r

      VALUES (505, 102, 1, 5, DATE '2025-12-15', 4);\r

      \r

      INSERT INTO DESCUENTOS (cod_juguete, id_tienda, nro_lote, id_desc, fecha,
      cant) \r

      VALUES (506, 102, 2, 6, DATE '2025-12-15', 5);\r

      \r

      INSERT INTO DESCUENTOS (cod_juguete, id_tienda, nro_lote, id_desc, fecha,
      cant) \r

      VALUES (507, 102, 3, 7, DATE '2025-12-16', 6);\r

      \r

      INSERT INTO DESCUENTOS (cod_juguete, id_tienda, nro_lote, id_desc, fecha,
      cant) \r

      VALUES (508, 102, 4, 8, DATE '2025-12-16', 7);\r

      \r

      INSERT INTO DESCUENTOS (cod_juguete, id_tienda, nro_lote, id_desc, fecha,
      cant) \r

      VALUES (509, 103, 1, 9, DATE '2025-12-17', 3);\r

      \r

      INSERT INTO DESCUENTOS (cod_juguete, id_tienda, nro_lote, id_desc, fecha,
      cant) \r

      VALUES (510, 103, 2, 10, DATE '2025-12-17', 2);\r\n"
    languageId: oracle-sql
