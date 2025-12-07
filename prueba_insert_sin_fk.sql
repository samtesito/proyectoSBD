------------------------------------------------------------
-- Datos de prueba para tablas del modelo LEGO en Venezuela
------------------------------------------------------------

-- Tabla: PAISES
INSERT INTO PAISES (id, nombre, gentilicio, continente, ue)
VALUES (58, 'Venezuela', 'venezolano', 'AMERICA', FALSE);

-- Tabla: ESTADOS
INSERT INTO ESTADOS (id, nombre)
VALUES (1, 'Distrito Capital');

INSERT INTO ESTADOS (id, nombre)
VALUES (2, 'Carabobo');

-- Tabla: CIUDADES
INSERT INTO CIUDADES (id, nombre)
VALUES (101, 'Caracas');

INSERT INTO CIUDADES (id, nombre)
VALUES (102, 'Valencia');

-- Tabla: CLIENTES
INSERT INTO CLIENTES (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, pasaporte, f_venc_pasap)
VALUES (1001, 'María', 'José', 'González', 'Pérez', TO_DATE('1990-05-12','YYYY-MM-DD'), 'V-12345678', 'P1234567', TO_DATE('2030-05-12','YYYY-MM-DD'));

-- Tabla: TIENDAS_LEGO
INSERT INTO TIENDAS_LEGO (id, nombre, direccion)
VALUES (10, 'LEGO Caracas', 'Av. Libertador, Centro Comercial Sambil, Caracas');

-- Tabla: HORARIOS_ATENCION
INSERT INTO HORARIOS_ATENCION (dia, hora_entr, hora_sal)
VALUES (TO_DATE('2025-12-06','YYYY-MM-DD'), TO_DATE('09:00','HH24:MI'), TO_DATE('17:00','HH24:MI'));

-- Tabla: FACTURAS_TIENDA
INSERT INTO FACTURAS_TIENDA (nro_fact, f_emision, total)
VALUES (500001, TO_DATE('2025-12-01','YYYY-MM-DD'), 150.50);

-- Tabla: VISITANTES_FANS
INSERT INTO VISITANTES_FANS (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, pasaporte, f_venc_pasap)
VALUES (2001, 'José', 'Luis', 'Ramírez', 'Torres', TO_DATE('1985-03-20','YYYY-MM-DD'), 987654321, 'VZL12345', TO_DATE('2029-03-20','YYYY-MM-DD'));

-- Tabla: TELEFONOS
INSERT INTO TELEFONOS (cod_inter, cod_local, numero, tipo)
VALUES (58, 212, 5551234, 'F'); -- Teléfono fijo Caracas

INSERT INTO TELEFONOS (cod_inter, cod_local, numero, tipo)
VALUES (58, 414, 7894561, 'M'); -- Teléfono móvil Movilnet

-- Tabla: FACTURAS_ONLINE
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, ptos_generados, total)
VALUES (700001, TO_DATE('2025-11-25','YYYY-MM-DD'), 25, 80.75);

-- Tabla: FECHAS_TOUR
INSERT INTO FECHAS_TOUR (f_inicio, costo, cupos)
VALUES (TO_DATE('2026-01-15','YYYY-MM-DD'), 120.00, 50);

-- Tabla: INSCRIPCIONES_TOUR
INSERT INTO INSCRIPCIONES_TOUR (nro_factura, f_emision, estado, total)
VALUES (800001, TO_DATE('2025-12-02','YYYY-MM-DD'), 'PAGADO', 120.00);

-- Tabla: ENTRADAS
INSERT INTO ENTRADAS (nro, tipo)
VALUES (900001, 'A'); -- Entrada adulto

INSERT INTO ENTRADAS (nro, tipo)
VALUES (900002, 'M'); -- Entrada menor

-- Tabla: TEMAS
INSERT INTO TEMAS (id, nombre, tipo, descripcion)
VALUES (301, 'Arquitectura', 'L', 'Sets inspirados en arquitectura venezolana como el Teatro Teresa Carreño');

-- Tabla: JUGUETES
INSERT INTO JUGUETES (codigo, nombre, descripcion, rgo_edad, rgo_precio, tipo_lego, "set", instruc, piezas)
VALUES (401, 'Arepa LEGO', 'Set temático inspirado en la gastronomía venezolana', '6-12', 25.00, 'A', TRUE, 'Incluye instrucciones ilustradas', 150);

-- Tabla: PRODUCTOS_RELACIONADOS
INSERT INTO PRODUCTOS_RELACIONADOS (id_producto, id_prod_relaci)
VALUES (401, 301);

-- Tabla: HISTORICO_PRECIOS_JUGUETES
INSERT INTO HISTORICO_PRECIOS_JUGUETES (f_inicio, precio, f_fin)
VALUES (TO_DATE('2025-01-01','YYYY-MM-DD'), 20.00, TO_DATE('2025-06-30','YYYY-MM-DD'));

-- Tabla: CATALOGOS_LEGO
INSERT INTO CATALOGOS_LEGO (limite)
VALUES (100);

-- Tabla: DETALLES_INSCRITOS
INSERT INTO DETALLES_INSCRITOS (id_det_insc)
VALUES (600001);

-- Tabla: DETALLES_FACTURA_ONLINE
INSERT INTO DETALLES_FACTURA_ONLINE (id_det_fact, cant_prod, tipo_cli)
VALUES (70001, 2, 'A');

-- Tabla: LOTES_SET_TIENDA
INSERT INTO LOTES_SET_TIENDA (nro_lote, f_adqui, cant_prod)
VALUES (301, TO_DATE('2025-10-15','YYYY-MM-DD'), 30);

-- Tabla: DETALLES_FACTURA_TIENDA
INSERT INTO DETALLES_FACTURA_TIENDA (id_det_fact, cant_prod, tipo_cli)
VALUES (80001, 3, 'M');

-- Tabla: DESCUENTO
INSERT INTO DESCUENTO (id_desc, fecha, cant)
VALUES (90001, TO_DATE('2025-12-05','YYYY-MM-DD'), 15);

------------------------------------------------------------
-- Fin del script de datos de prueba
------------------------------------------------------------
