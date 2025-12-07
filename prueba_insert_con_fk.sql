------------------------------------------------------------
-- SCRIPT DE INSERCIÓN DE DATOS DE PRUEBA (Contexto: Venezuela)
------------------------------------------------------------

-- =======================
-- TABLAS DE ALI
-- =======================

-- PAISES
INSERT INTO PAISES (id, nombre, gentilicio, continente, ue)
VALUES (58, 'Venezuela', 'venezolano', 'AMERICA', FALSE);

-- ESTADOS
INSERT INTO ESTADOS (id_pais, id, nombre)
VALUES (58, 1, 'Distrito Capital');
INSERT INTO ESTADOS (id_pais, id, nombre)
VALUES (58, 2, 'Carabobo');

-- CIUDADES
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre)
VALUES (58, 1, 101, 'Caracas');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre)
VALUES (58, 2, 102, 'Valencia');

-- CLIENTES
INSERT INTO CLIENTES (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi, pasaporte, f_venc_pasap)
VALUES (1001, 'María', 'José', 'González', 'Pérez', TO_DATE('1990-05-12','YYYY-MM-DD'), 'V-12345678', 58, 'P1234567', TO_DATE('2030-05-12','YYYY-MM-DD'));

-- TIENDAS_LEGO
INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (10, 'LEGO Caracas', 'Av. Libertador, C.C. Sambil', 58, 1, 101);

-- HORARIOS_ATENCION
INSERT INTO HORARIOS_ATENCION (id_tienda, dia, hora_entr, hora_sal)
VALUES (10, TO_DATE('2025-12-06','YYYY-MM-DD'), TO_DATE('09:00','HH24:MI'), TO_DATE('17:00','HH24:MI'));

-- =======================
-- TABLAS DE DANIEL
-- =======================

-- FACTURAS_TIENDA
INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total)
VALUES (500001, 1001, 10, TO_DATE('2025-12-01','YYYY-MM-DD'), 150.50);

-- VISITANTES_FANS
INSERT INTO VISITANTES_FANS (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, id_pais, seg_nom, pasaporte, f_venc_pasap)
VALUES (2001, 'José', 'Luis', 'Ramírez', 'Torres', TO_DATE('1985-03-20','YYYY-MM-DD'), 987654321, 58, 'Luis', 'VZL12345', TO_DATE('2029-03-20','YYYY-MM-DD'));

-- TELEFONOS
INSERT INTO TELEFONOS (cod_inter, cod_local, numero, tipo, id_cliente)
VALUES (58, 212, 5551234, 'F', 1001); -- Teléfono fijo Caracas
INSERT INTO TELEFONOS (cod_inter, cod_local, numero, tipo, id_visitante)
VALUES (58, 414, 7894561, 'M', 2001); -- Teléfono móvil Movilnet

-- FACTURAS_ONLINE
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total)
VALUES (700001, TO_DATE('2025-11-25','YYYY-MM-DD'), 1001, 25, 80.75);

-- FECHAS_TOUR
INSERT INTO FECHAS_TOUR (f_inicio, costo, cupos)
VALUES (TO_DATE('2026-01-15','YYYY-MM-DD'), 120.00, 50);

-- INSCRIPCIONES_TOUR
INSERT INTO INSCRIPCIONES_TOUR (f_inicio, nro_fact, f_emision, estado, total)
VALUES (TO_DATE('2026-01-15','YYYY-MM-DD'), 800001, TO_DATE('2025-12-02','YYYY-MM-DD'), 'PAGADO', 120.00);

-- =======================
-- TABLAS DE SAMUEL
-- =======================

-- ENTRADAS
INSERT INTO ENTRADAS (f_inicio, nro_fact, nro, tipo)
VALUES (TO_DATE('2026-01-15','YYYY-MM-DD'), 800001, 900001, 'A'); -- Adulto

-- TEMAS
INSERT INTO TEMAS (id, nombre, tipo, descripcion)
VALUES (301, 'Arquitectura', 'L', 'Sets inspirados en arquitectura venezolana como el Teatro Teresa Carreño');

-- JUGUETES
INSERT INTO JUGUETES (codigo, nombre, descripcion, id_tema, rgo_edad, rgo_precio, tipo_lego, "set", instruc, piezas)
VALUES (401, 'Arepa LEGO', 'Set temático inspirado en la gastronomía venezolana', 301, '5A6', 'B', 'L', TRUE, 'Incluye instrucciones ilustradas', 150);

-- PRODUCTOS_RELACIONADOS
INSERT INTO PRODUCTOS_RELACIONADOS (id_producto, id_prod_relaci)
VALUES (401, 301);

-- HISTORICO_PRECIOS_JUGUETES
INSERT INTO HISTORICO_PRECIOS_JUGUETES (cod_juguete, f_inicio, precio, f_fin)
VALUES (401, TO_DATE('2025-01-01','YYYY-MM-DD'), 20.00, TO_DATE('2025-06-30','YYYY-MM-DD'));

-- CATALOGOS_LEGO
INSERT INTO CATALOGOS_LEGO (id_pais, cod_juguete, limite)
VALUES (58, 401, 100);

-- =======================
-- TABLAS DE VIOLETA
-- =======================

-- DETALLES_INSCRITOS
INSERT INTO DETALLES_INSCRITOS (fecha_inicio, nro_factura, id_det_insc, id_cliente)
VALUES (TO_DATE('2026-01-15','YYYY-MM-DD'), 800001, 600001, 1001);

-- DETALLES_FACTURA_ONLINE
INSERT INTO DETALLES_FACTURA_ONLINE (nro_fact, id_det_fact, cant_prod, tipo_cli, codigo, id_pais)
VALUES (700001, 70001, 2, 'A', 401, 58);

-- LOTES_SET_TIENDA
INSERT INTO LOTES_SET_TIENDA (codigo, id_tienda, nro_lote, f_adqui, cant_prod)
VALUES (401, 10, 301, TO_DATE('2025-10-15','YYYY-MM-DD'), 30);

-- DETALLES_FACTURA_TIENDA
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod, tipo_cli, codigo, id_tienda, nro_lote)
VALUES (500001, 80001, 3, 'M', 401, 10, 301);

-- DESCUENTOS
INSERT INTO DESCUENTOS (codigo, id_tienda, nro_lote, id_desc, fecha, cant)
VALUES (401, 10, 301, 90001, TO_DATE('2025-12-05','YYYY-MM-DD'), 15);

------------------------------------------------------------
-- FIN DEL SCRIPT DE DATOS DE PRUEBA
------------------------------------------------------------
