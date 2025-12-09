------------------------------------------------------------
-- SCRIPT DE INSERCIÓN DE DATOS DE PRUEBA (Contexto: Venezuela)
------------------------------------------------------------

-- =======================
-- TABLAS DE ALI
-- =======================

-- PAISES
INSERT INTO PAISES (id, nombre, gentilicio, continente, ue)
VALUES (58, 'Venezuela', 'venezolano', 'AMERICA', FALSE);

INSERT INTO PAISES (id, nombre, gentilicio, continente, ue)
VALUES (43, 'Dinamarca', 'danes', 'EUROPA', TRUE);

INSERT INTO PAISES (id, nombre, gentilicio, continente, ue)
VALUES (34, 'Espana', 'espanol', 'EUROPA', TRUE);

INSERT INTO PAISES (id, nombre, gentilicio, continente, ue)
VALUES (972, 'ISRAEL', 'israelí', 'ASIA', FALSE);

INSERT INTO PAISES (id, nombre, gentilicio, continente, ue)
VALUES (56, 'CHILE', 'chileno', 'AMERICA', FALSE);

INSERT INTO PAISES (id, nombre, gentilicio, continente, ue) 
VALUES (507, 'Panamá', 'panameño', 'AMERICA', FALSE);

-- ESTADOS
INSERT INTO ESTADOS (id_pais, id, nombre)
VALUES (58, 1, 'Distrito Capital');
INSERT INTO ESTADOS (id_pais, id, nombre)
VALUES (58, 2, 'Carabobo');

INSERT INTO ESTADOS (id_pais, id, nombre)
VALUES (43, 1, 'Region Capital');
INSERT INTO ESTADOS (id_pais, id, nombre)
VALUES (43, 2, 'Selandia');

INSERT INTO ESTADOS (id_pais, id, nombre)
VALUES (34, 1, 'Comunidad de Madrid');
INSERT INTO ESTADOS (id_pais, id, nombre)
VALUES (34, 2, 'Cataluna');

INSERT INTO ESTADOS (id_pais, id, nombre)
VALUES (972, 1, 'Distrito Central');
INSERT INTO ESTADOS (id_pais, id, nombre)
VALUES (972, 2, 'Distrito Tel Aviv');
INSERT INTO ESTADOS (id_pais, id, nombre)
VALUES (972, 3, 'Distrito Sur');

INSERT INTO ESTADOS (id_pais, id, nombre)
VALUES (56, 1, 'Coquimbo Region');
INSERT INTO ESTADOS (id_pais, id, nombre)
VALUES (56, 2, 'Region Metropolitana de Santiago');

INSERT INTO ESTADOS (id_pais, id, nombre) 
VALUES (507, 101, 'Panamá');
INSERT INTO ESTADOS (id_pais, id, nombre) 
VALUES (507, 102, 'Colón');
INSERT INTO ESTADOS (id_pais, id, nombre) 
VALUES (507, 103, 'Chiriquí');
INSERT INTO ESTADOS (id_pais, id, nombre) 
VALUES (507, 104, 'Veraguas');
INSERT INTO ESTADOS (id_pais, id, nombre) 
VALUES (507, 105, 'Coclé');

-- CIUDADES
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre)
VALUES (58, 1, 101, 'Caracas');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre)
VALUES (58, 2, 102, 'Valencia');

INSERT INTO CIUDADES (id_pais, id_estado, id, nombre)
VALUES (43, 1, 101, 'Copenhague');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre)
VALUES (43, 2, 102, 'Rosklide');

INSERT INTO CIUDADES (id_pais, id_estado, id, nombre)
VALUES (34, 1, 101, 'Madrid');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre)
VALUES (34, 2, 102, 'Barcelona');

INSERT INTO CIUDADES (id_pais, id_estado, id, nombre)
VALUES (972, 1, 1, 'Rishon Lezion');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre)
VALUES (972, 2, 1, 'Tel Aviv');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre)
VALUES (972, 3, 1, 'Eilat');

INSERT INTO CIUDADES (id_pais, id_estado, id, nombre)
VALUES (56, 1, 1, 'Coquimbo');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre)
VALUES (56, 2, 1, 'Las Condes');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre)
VALUES (56, 2, 2, 'La Reina');

INSERT INTO CIUDADES (id_pais, id_estado, id, nombre) VALUES (507, 101, 1001, 'Ciudad de Panamá');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre) VALUES (507, 101, 1002, 'San Miguelito');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre) VALUES (507, 102, 1003, 'Colón');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre) VALUES (507, 103, 1004, 'David');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre) VALUES (507, 103, 1005, 'Boquete');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre) VALUES (507, 104, 1006, 'Santiago');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre) VALUES (507, 104, 1007, 'Soná');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre) VALUES (507, 105, 1008, 'Penonomé');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre) VALUES (507, 105, 1009, 'El Valle de Antón');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre) VALUES (507, 105, 1010, 'Aguadulce');

-- CLIENTES
INSERT INTO CLIENTES (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi, pasaporte, f_venc_pasap)
VALUES (1001, 'María', 'José', 'González', 'Pérez', TO_DATE('1990-05-12','YYYY-MM-DD'), 'V-12345678', 58, 'P1234567', TO_DATE('2030-05-12','YYYY-MM-DD'));

INSERT INTO CLIENTES (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi, pasaporte, f_venc_pasap)
VALUES (1002, 'Juan', 'Gabriel', 'Hernandez', 'Paredes', TO_DATE('2002-04-13','YYYY-MM-DD'), '65893214P', 43, NULL, NULL);

INSERT INTO CLIENTES (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi, pasaporte, f_venc_pasap)
VALUES (1003, 'Elsa', NULL, 'Kristensen', 'Dorgu', TO_DATE('1992-02-20','YYYY-MM-DD'), '200292-1235', 43, NULL, NULL);

-- TIENDAS_LEGO
INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (10, 'LEGO Caracas', 'Av. Libertador, C.C. Sambil', 58, 1, 101);

INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (11, 'LEGO Store Rishon Lezion', 'G Cinema City Mall, 3 Yaldey', 972, 1, 1);
INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (12, 'LEGO Store Tel Aviv', 'Dizengoff Center, Dizengoff St 50', 972, 2, 1);
INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (13, 'LEGO Store Eilat', 'BIG CENTER Eilat, 20 Hasatat St.', 972, 3, 1);

INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (21, 'LEGO Store Egana', 'Av. Larrain 5862, La Reina, Región Metropolitana, Chile', 56, 2, 2);
INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (22, 'LEGO Store Manquehue', 'Av. Manquehue Nte. 1255', 56, 2, 1);
INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (23, 'LEGO Store Calama', 'Av. Balmaceda 3242', 56, 1, 1);

INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (501, 'LEGO Store Multiplaza', 'Av. Balboa, Multiplaza Mall', 507, 101, 1001);
INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (502, 'LEGO Store San Miguelito', 'Centro Comercial Los Andes', 507, 101, 1002);
INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (503, 'LEGO Store Colón', 'Centro Comercial Cuatro Altos', 507, 102, 1003);
INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (504, 'LEGO Store David', 'Plaza Terronal, David', 507, 103, 1004);
INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (505, 'LEGO Store Santiago', 'Centro Comercial Santiago Mall', 507, 104, 1006);

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
INSERT INTO VISITANTES_FANS (id_lego, prim_nom, prim_ape, seg_ape, f_nacim, dni, id_pais, seg_nom, pasaporte, f_venc_pasap)
VALUES (2001, 'José', 'Ramírez', 'Torres', TO_DATE('1985-03-20','YYYY-MM-DD'), 987654321, 58, 'Luis', 'VZL12345', TO_DATE('2029-03-20','YYYY-MM-DD'));

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
INSERT INTO TEMAS (id, nombre, tipo, descripcion, id_tema_padre)
VALUES (101, 'Lego Batman', 'L', 'Sets inspirados en el universo de Batman', NULL);
INSERT INTO TEMAS (id, nombre, tipo, descripcion, id_tema_padre)
VALUES (102, 'LEGO Art', 'L', 'Sets de arte y decoración con piezas LEGO', NULL);

-- JUGUETES
INSERT INTO JUGUETES (codigo, nombre, descripcion, id_tema, rgo_edad, rgo_precio, tipo_lego, "set", instruc, piezas)
VALUES (401, 'Arepa LEGO', 'Set temático inspirado en la gastronomía venezolana', 301, '5A6', 'B', 'L', TRUE, 'Incluye instrucciones ilustradas', 150);
INSERT INTO JUGUETES (codigo, nombre, descripcion, id_tema, rgo_edad, rgo_precio, tipo_lego, "set", instruc, piezas)
VALUES (402, 'Cachapa LEGO', 'Otro set tematico inspirado en la gastronomia venezolana', 301, '5A6', 'B', 'L', TRUE, 'Incluye instrucciones numeradas', 300);
INSERT INTO JUGUETES VALUES (2001, 'Batmobile', 'Batmobile clásico de Batman', 101, '9A11', 'B', 'L', TRUE, NULL, 'Manual incluido', 1200);
INSERT INTO JUGUETES VALUES (2002, 'Batcave', 'Base secreta de Batman', 101, '12+', 'C', 'L', TRUE, NULL, 'Manual detallado', 2500);
INSERT INTO JUGUETES VALUES (2003, 'Figura Joker', 'Figura LEGO del Joker', 101, '7A8', 'A', 'L', FALSE, NULL, NULL, 150);
INSERT INTO JUGUETES VALUES (2004, 'Batwing', 'Nave Batwing de Batman', 101, '12+', 'C', 'L', TRUE, NULL, 'Guía paso a paso', 2100);
INSERT INTO JUGUETES VALUES (2005, 'Robin Minifig', 'Figura LEGO de Robin', 101, '5A6', 'A', 'L', FALSE, NULL, NULL, 120);
INSERT INTO JUGUETES VALUES (2006, 'Gotham Police Car', 'Vehículo de la policía de Gotham', 101, '7A8', 'A', 'L', TRUE, NULL, 'Manual básico incluido', 350);
INSERT INTO JUGUETES VALUES (2007, 'Harley Quinn Minifig', 'Figura LEGO de Harley Quinn', 101, '5A6', 'A', 'L', FALSE, NULL, NULL, 120);
INSERT INTO JUGUETES VALUES (2008, 'Arkham Asylum', 'Prisión de Arkham con personajes', 101, '12+', 'D', 'L', TRUE, NULL, 'Manual detallado', 2800);
INSERT INTO JUGUETES VALUES (2009, 'Penguin Submarine', 'Submarino del Pingüino', 101, '9A11', 'B', 'L', TRUE, NULL, 'Guía paso a paso', 950);
INSERT INTO JUGUETES VALUES (2010, 'Catwoman Bike', 'Moto de Catwoman', 101, '7A8', 'B', 'L', TRUE, NULL, 'Manual incluido', 600);
INSERT INTO JUGUETES VALUES (2011, 'Batman Key Chain', 'Llavero oficial LEGO Batman 854235', 101, '5A6', 'A', 'L', FALSE, NULL, NULL, 1);
INSERT INTO JUGUETES VALUES (2012, 'Batman Mech Armor', 'Armadura mecánica de Batman 76270', 101, '7A8', 'B', 'L', TRUE, NULL, 'Manual incluido', 154);
INSERT INTO JUGUETES VALUES (2013, 'Batgirl Key Chain', 'Llavero oficial LEGO Batgirl 854320', 101, '5A6', 'A', 'L', FALSE, NULL, NULL, 1);
INSERT INTO JUGUETES VALUES (2014, 'Batman 8in1 Figure', 'Figura LEGO Batman 8 en 1 40748', 101, '9A11', 'C', 'L', TRUE, NULL, 'Guía paso a paso incluida', 340);
INSERT INTO JUGUETES VALUES (3001, 'Mosaico Marilyn Monroe', 'Set LEGO Art inspirado en Andy Warhol', 102, '12+', 'C', 'L', TRUE, NULL, 'Guía incluida', 3341);
INSERT INTO JUGUETES VALUES (3002, 'Star Wars Sith', 'Retrato LEGO Art de los Sith', 102, '12+', 'D', 'L', TRUE, NULL, 'Manual incluido', 3400);
INSERT INTO JUGUETES VALUES (3003, 'The Beatles', 'Retrato LEGO Art de los Beatles', 102, '12+', 'C', 'L', TRUE, NULL, 'Guía paso a paso', 2933);
INSERT INTO JUGUETES VALUES (3004, 'Iron Man Portrait', 'Retrato LEGO Art de Iron Man', 102, '12+', 'C', 'L', TRUE, NULL, 'Manual incluido', 3200);
INSERT INTO JUGUETES VALUES (3005, 'Harry Potter Crests', 'Escudos de Hogwarts en LEGO Art', 102, '12+', 'D', 'L', TRUE, NULL, 'Guía detallada', 4150); 
INSERT INTO JUGUETES VALUES (3006, 'Mickey Mouse Portrait', 'Retrato LEGO Art de Mickey Mouse', 102, '12+', 'C', 'L', TRUE, NULL, 'Guía incluida', 2800);
INSERT INTO JUGUETES VALUES (3007, 'Marvel Spiderman Portrait', 'Retrato LEGO Art de Spiderman', 102, '12+', 'C', 'L', TRUE, NULL, 'Manual incluido', 3100);
INSERT INTO JUGUETES VALUES (3008, 'Rolling Stones Logo', 'Logo LEGO Art de los Rolling Stones', 102, '12+', 'D', 'L', TRUE, NULL, 'Guía paso a paso', 1998);
INSERT INTO JUGUETES VALUES (3009, 'World Map', 'Mapa del mundo en LEGO Art', 102, '12+', 'D', 'L', TRUE, NULL, 'Manual detallado', 11695);
INSERT INTO JUGUETES VALUES (3010, 'Disney Princess Portraits', 'Retratos LEGO Art de princesas Disney', 102, '12+', 'C', 'L', TRUE, NULL, 'Guía incluida', 3500);
INSERT INTO JUGUETES VALUES (3011, 'The Milky Way Galaxy', 'LEGO Art La Vía Láctea 31212', 102, '12+', 'D', 'L', TRUE, NULL, 'Manual detallado', 3167);
INSERT INTO JUGUETES VALUES (3012, 'LOVE', 'LEGO Art LOVE 31214', 102, '12+', 'C', 'L', TRUE, NULL, 'Guía incluida', 559);
INSERT INTO JUGUETES VALUES (3013, 'Mona Lisa', 'LEGO Art Mona Lisa 31213', 102, '12+', 'C', 'L', TRUE, NULL, 'Guía paso a paso', 3110);
INSERT INTO JUGUETES VALUES (3014, 'The Fauna Collection - Tiger', 'LEGO Art Fauna: Tigre 31217', 102, '12+', 'C', 'L', TRUE, NULL, 'Manual incluido', 637);

-- PRODUCTOS_RELACIONADOS
INSERT INTO PRODUCTOS_RELACIONADOS (id_producto, id_prod_relaci)
VALUES (401, 301);

--LEGO BATMAN SE RELACIONA
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (2001, 2002); -- Batmobile con Batcave
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (2002, 2003); -- Batcave con Joker
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (2003, 2007); -- Joker con Harley Quinn
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (2004, 2010); -- Batwing con Catwoman Bike
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (2008, 2009); -- Arkham Asylum con Penguin Submarine
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (2011, 2013);
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (2011, 2012);
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (2012, 2014);
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (2013, 2014);

-- LEGO ART SE RELACIONA
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (3001, 3003); -- Marilyn con Beatles
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (3002, 3004); -- Sith con Iron Man
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (3005, 3010); -- Harry Potter Crests con Disney Princess Portraits
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (3006, 3007); -- Mickey con Spiderman
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (3008, 3009); -- Rolling Stones con World Map
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (3011, 3009);
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (3012, 3013);
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (3013, 3014);
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (3012, 3011);


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
INSERT INTO DETALLES_INSCRITOS (fecha_inicio, nro_fact, id_det_insc, id_cliente)
VALUES (TO_DATE('2026-01-15','YYYY-MM-DD'), 800001, 600001, 1001);

-- DETALLES_FACTURA_ONLINE
INSERT INTO DETALLES_FACTURA_ONLINE (nro_fact, id_det_fact, cant_prod, tipo_cli, codigo, id_pais)
VALUES (700001, 70001, 2, 'A', 401, 58);

-- LOTES_SET_TIENDA
INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui, cant_prod)
VALUES (401, 10, 301, TO_DATE('2025-10-15','YYYY-MM-DD'), 30);

-- DETALLES_FACTURA_TIENDA
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod, tipo_cli, codigo, id_tienda, nro_lote)
VALUES (500001, 80001, 3, 'M', 401, 10, 301);

-- DESCUENTOS
INSERT INTO DESCUENTOS (codigo, id_tienda, nro_lote, id_desc, fecha, cant)
VALUES (401, 10, 301, 90001, TO_DATE('2025-12-05','YYYY-MM-DD'), 15);


--INSERTS PROBADOS: CUPO
INSERT INTO FECHAS_TOUR VALUES('22-12-26',20,1);
INSERT INTO INSCRIPCIONES_TOUR VALUES('22-12-26',250,'08-12-25','PENDIENTE',0);
--DEBEN ESTAR LOS VISITANTES ANTES, ESTOS EN LA PRUEBA NO NECESITABAN REPRESENTANTE
INSERT INTO DETALLES_INSCRITOS(fecha_inicio,nro_fact, id_det_insc,id_visit) VALUES('22-12-26',250,40,2001);
INSERT INTO DETALLES_INSCRITOS(fecha_inicio,nro_fact, id_det_insc,id_visit) VALUES('22-12-26',250,98,2003);

------------------------------------------------------------
-- FIN DEL SCRIPT DE DATOS DE PRUEBA
------------------------------------------------------------
