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

INSERT INTO PAISES (id, nombre, gentilicio, continente, ue) VALUES 
(52, 'México', 'mexicano', 'AMERICA', FALSE),
(55, 'Brasil', 'brasileño', 'AMERICA', FALSE),
(49, 'Alemania', 'alemán', 'EUROPA', TRUE),
(61, 'Australia', 'australiano', 'OCEANIA', FALSE);


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

INSERT INTO ESTADOS (id_pais, id, nombre) VALUES 
(52, 1, 'Ciudad de México'),
(52, 2, 'Nuevo León');
 
INSERT INTO ESTADOS (id_pais, id, nombre) VALUES 
(55, 1, 'São Paulo'),
(55, 2, 'Rio de Janeiro');

INSERT INTO ESTADOS (id_pais, id, nombre) VALUES 
(49, 1, 'Baviera'),
(49, 2, 'Berlín');

INSERT INTO ESTADOS (id_pais, id, nombre) VALUES 
(61, 1, 'Nueva Gales del Sur'),
(61, 2, 'Victoria');


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
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre) VALUES (507, 102, 1003, 'Colón');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre) VALUES (507, 103, 1004, 'David');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre) VALUES (507, 104, 1007, 'Soná');
INSERT INTO CIUDADES (id_pais, id_estado, id, nombre) VALUES (507, 105, 1010, 'Aguadulce');

INSERT INTO CIUDADES (id_pais, id_estado, id, nombre) VALUES 
(52, 1, 101, 'Ciudad de México'),
(52, 2, 101, 'Monterrey');

INSERT INTO CIUDADES (id_pais, id_estado, id, nombre) VALUES 
(55, 1, 101, 'São Paulo'),
(55, 2, 101, 'Rio de Janeiro');

INSERT INTO CIUDADES (id_pais, id_estado, id, nombre) VALUES 
(49, 1, 101, 'Múnich'),
(49, 2, 101, 'Berlín');

INSERT INTO CIUDADES (id_pais, id_estado, id, nombre) VALUES 
(61, 1, 101, 'Sídney'),
(61, 2, 101, 'Melbourne');


-- CLIENTES
INSERT INTO CLIENTES (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi, pasaporte, f_venc_pasap)
VALUES (1001, 'María', 'José', 'González', 'Pérez', TO_DATE('1990-05-12','YYYY-MM-DD'), 'V-12345678', 58, 'P1234567', TO_DATE('2030-05-12','YYYY-MM-DD'));

INSERT INTO CLIENTES (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi, pasaporte, f_venc_pasap)
VALUES (1002, 'Juan', 'Gabriel', 'Hernandez', 'Paredes', TO_DATE('2002-04-13','YYYY-MM-DD'), '65893214P', 43, NULL, NULL);

INSERT INTO CLIENTES (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi, pasaporte, f_venc_pasap)
VALUES (1003, 'Elsa', NULL, 'Kristensen', 'Dorgu', TO_DATE('1992-02-20','YYYY-MM-DD'), '200292-1235', 43, NULL, NULL);

INSERT INTO CLIENTES (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi, pasaporte, f_venc_pasap) VALUES 
(1004, 'Carlos', 'Antonio', 'López', 'García', TO_DATE('1985-11-03','YYYY-MM-DD'), 'MX12345678', 52, 'MEX789012', TO_DATE('2028-11-03','YYYY-MM-DD')),
(1005, 'Ana', 'Beatriz', 'Silva', 'Santos', TO_DATE('1998-07-22','YYYY-MM-DD'), '12345678901', 55, NULL, NULL),
(1006, 'Hans', NULL, 'Müller', 'Schmidt', TO_DATE('1975-09-15','YYYY-MM-DD'), '1234567890', 49, NULL, NULL),
(1007, 'Sarah', 'Jane', 'Wilson', 'Brown', TO_DATE('2005-03-10','YYYY-MM-DD'), 'AU123456789', 61, 'AUS456789', TO_DATE('2032-03-10','YYYY-MM-DD')),
(1008, 'Lucía', NULL, 'Martín', 'Gómez', TO_DATE('1994-12-28','YYYY-MM-DD'), '12345678Z', 34, NULL, NULL),
(1009, 'David', 'Eli', 'Cohen', 'Levy', TO_DATE('1988-01-17','YYYY-MM-DD'), '123456789', 972, 'ISR987654', TO_DATE('2029-01-17','YYYY-MM-DD'));


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
VALUES (506, 'LEGO Store Altaplaza', 'Altaplaza Mall, Vía Centenario, Ciudad de Panamá', 507, 101, 1001);

-- HORARIOS_ATENCION
INSERT INTO HORARIOS_ATENCION (id_tienda, dia, hora_entr, hora_sal) VALUES 
(10, 'LUN', TO_DATE('09:00','HH24:MI'), TO_DATE('17:00','HH24:MI')),
(10, 'MAR', TO_DATE('09:00','HH24:MI'), TO_DATE('20:00','HH24:MI')),
(10, 'MIE', TO_DATE('10:00','HH24:MI'), TO_DATE('17:00','HH24:MI')),
(10, 'JUE', TO_DATE('09:00','HH24:MI'), TO_DATE('19:00','HH24:MI')),
(10, 'VIE', TO_DATE('09:00','HH24:MI'), TO_DATE('17:00','HH24:MI')),
(10, 'SAB', TO_DATE('10:00','HH24:MI'), TO_DATE('16:00','HH24:MI')),
(10, 'DOM', TO_DATE('09:00','HH24:MI'), TO_DATE('17:00','HH24:MI'));



-- =======================
-- TABLAS DE DANIEL
-- =======================

-- FACTURAS_TIENDA
INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total)
VALUES (500001, 1001, 10, TO_DATE('2025-12-01','YYYY-MM-DD'), 150.50);
INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total) VALUES 
(500002, 1002, 11, TO_DATE('2025-12-03','YYYY-MM-DD'), 245.99), 
(500003, 1004, 10, TO_DATE('2025-12-04','YYYY-MM-DD'), 89.50),
(500004, 1005, 21, TO_DATE('2025-12-05','YYYY-MM-DD'), 178.20),
(500005, 1006, 12, TO_DATE('2025-12-06','YYYY-MM-DD'), 320.75), 
(500006, 1008, 13, TO_DATE('2025-12-07','YYYY-MM-DD'), 156.00),
(500007, 1009, 22, TO_DATE('2025-12-08','YYYY-MM-DD'), 210.30);


-- VISITANTES_FANS
INSERT INTO VISITANTES_FANS (id_lego, prim_nom, prim_ape, seg_ape, f_nacim, dni, id_pais, seg_nom, pasaporte, f_venc_pasap)
VALUES (2001, 'José', 'Ramírez', 'Torres', TO_DATE('1985-03-20','YYYY-MM-DD'), 987654321, 58, 'Luis', 'VZL12345', TO_DATE('2029-03-20','YYYY-MM-DD'));
INSERT INTO VISITANTES_FANS (id_lego, prim_nom, prim_ape, seg_ape, f_nacim, dni, id_pais, seg_nom, pasaporte, f_venc_pasap) VALUES 
(2002, 'Pedro', 'Guzmán', 'López', TO_DATE('1995-08-10','YYYY-MM-DD'), 123456789, 52, NULL, NULL, NULL),     -- México
(2003, 'Luisa', 'Fernández', 'Roa', TO_DATE('2000-12-05','YYYY-MM-DD'), 9876543210, 55, 'Maria', NULL, NULL), -- Brasil
(2004, 'Klaus', 'Weber', 'Klein', TO_DATE('1980-06-22','YYYY-MM-DD'), 876543210, 49, NULL, 'DEU123456', TO_DATE('2028-06-22','YYYY-MM-DD')),  -- Alemania
(2005, 'Emma', 'Davis', 'Lee', TO_DATE('2008-02-14','YYYY-MM-DD'), 456789123, 61, NULL, NULL, NULL),         -- Australia
(2006, 'Miguel', 'Sánchez', 'Ríos', TO_DATE('1997-09-30','YYYY-MM-DD'), 321654987, 34, NULL, NULL, NULL),    -- España
(2007, 'Rachel', 'Goldberg', 'Weiss', TO_DATE('1990-04-18','YYYY-MM-DD'), 147258369, 972, NULL, NULL, NULL); -- Israel

-- TELEFONOS
INSERT INTO TELEFONOS (cod_inter, cod_local, numero, tipo, id_cliente)
VALUES (58, 212, 5551234, 'F', 1001); -- Teléfono fijo Caracas
INSERT INTO TELEFONOS (cod_inter, cod_local, numero, tipo, id_visitante)
VALUES (58, 414, 7894561, 'M', 2001); -- Teléfono móvil Movilnet
INSERT INTO TELEFONOS (cod_inter, cod_local, numero, tipo, id_cliente) VALUES 
(52, 55, 1234567, 'F', 1004),  -- México fijo
(55, 11, 9876543, 'M', 1005),  -- Brasil móvil
(49, 30, 4567890, 'F', 1006),  -- Alemania fijo
(61, 2, 7890123, 'M', 1007),   -- Australia móvil
(34, 91, 2345678, 'F', 1008),  -- España fijo Madrid
(972, 3, 4567890, 'M', 1009);  -- Israel móvil

-- FACTURAS_ONLINE
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total)
VALUES (700001, TO_DATE('2025-11-25','YYYY-MM-DD'), 1001, 25, 80.75);
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total) VALUES 
(700002, TO_DATE('2025-11-28','YYYY-MM-DD'), 1002, 15, 120.25),
(700003, TO_DATE('2025-11-29','YYYY-MM-DD'), 1004, 30, 89.99),
(700004, TO_DATE('2025-11-30','YYYY-MM-DD'), 1005, 22, 175.80),
(700005, TO_DATE('2025-12-01','YYYY-MM-DD'), 1006, 45, 299.50),
(700006, TO_DATE('2025-12-02','YYYY-MM-DD'), 1007, 12, 65.75),
(700007, TO_DATE('2025-12-03','YYYY-MM-DD'), 1008, 18, 142.00);

-- FECHAS_TOUR
INSERT INTO FECHAS_TOUR (f_inicio, costo, cupos) VALUES 
(TO_DATE('2026-02-20','YYYY-MM-DD'), 95.00, 30),    -- Tour económico
(TO_DATE('2026-03-10','YYYY-MM-DD'), 180.00, 25),   -- Tour premium
(TO_DATE('2026-04-05','YYYY-MM-DD'), 135.00, 40),   -- Tour primavera
(TO_DATE('2026-05-15','YYYY-MM-DD'), 110.00, 35),   -- Tour mayo
(TO_DATE('2026-06-25','YYYY-MM-DD'), 155.00, 20),   -- Tour vacaciones
(TO_DATE('2026-07-12','YYYY-MM-DD'), 140.00, 28);   -- Tour julio

-- INSCRIPCIONES_TOUR
INSERT INTO INSCRIPCIONES_TOUR (f_inicio, nro_fact, f_emision, estado, total) 
VALUES (TO_DATE('2026-02-20','YYYY-MM-DD'), 250, TO_DATE('2025-12-08','YYYY-MM-DD'), 'PENDIENTE', 20.00);


-- =======================
-- TABLAS DE SAMUEL
-- =======================

-- ENTRADAS
INSERT INTO ENTRADAS (f_inicio, nro_fact, nro, tipo)
VALUES (TO_DATE('2026-01-15','YYYY-MM-DD'), 800001, 900001, 'A'); -- Adulto
INSERT INTO ENTRADAS (f_inicio, nro_fact, nro, tipo) VALUES 
(TO_DATE('2026-01-15','YYYY-MM-DD'), 800001, 900002, 'M'),  -- Menor
(TO_DATE('2026-01-15','YYYY-MM-DD'), 800001, 900003, 'A'),  -- Adulto
(TO_DATE('2026-02-20','YYYY-MM-DD'), 800002, 900004, 'A'),
(TO_DATE('2026-03-10','YYYY-MM-DD'), 800003, 900005, 'M'),
(TO_DATE('2026-04-05','YYYY-MM-DD'), 800004, 900006, 'A'),
(TO_DATE('2026-05-15','YYYY-MM-DD'), 800005, 900007, 'M');


-- TEMAS
INSERT INTO TEMAS (id, nombre, tipo, descripcion, id_tema_padre)
VALUES (101, 'Lego Batman', 'L', 'Sets inspirados en el universo de Batman', NULL);
INSERT INTO TEMAS (id, nombre, tipo, descripcion, id_tema_padre)
VALUES (102, 'LEGO Art', 'L', 'Sets de arte y decoración con piezas LEGO', NULL);
INSERT INTO TEMAS (id, nombre, tipo, descripcion, id_tema_padre) VALUES 
(306, 'LEGO Marvel', 'L', 'Personajes y escenarios icónicos del universo Marvel', NULL),
(307, 'LEGO BrickHeadz', 'O', 'Figuras coleccionables estilo BrickHeadz de Disney y más', NULL);

-- JUGUETES
INSERT INTO JUGUETES VALUES (2011, 'Batman Key Chain', 'Llavero oficial LEGO Batman 854235', 101, '5A6', 'A', 'L', FALSE, NULL, NULL, 1);
INSERT INTO JUGUETES VALUES (2012, 'Batman Mech Armor', 'Armadura mecánica de Batman 76270', 101, '7A8', 'B', 'L', TRUE, NULL, 'Manual incluido', 154);
INSERT INTO JUGUETES VALUES (2013, 'Batgirl Key Chain', 'Llavero oficial LEGO Batgirl 854320', 101, '5A6', 'A', 'L', FALSE, NULL, NULL, 1);
INSERT INTO JUGUETES VALUES (2014, 'Batman 8in1 Figure', 'Figura LEGO Batman 8 en 1 40748', 101, '9A11', 'C', 'L', TRUE, NULL, 'Guía paso a paso incluida', 340);
INSERT INTO JUGUETES VALUES (3011, 'The Milky Way Galaxy', 'LEGO Art La Vía Láctea 31212', 102, '12+', 'D', 'L', TRUE, NULL, 'Manual detallado', 3167);
INSERT INTO JUGUETES VALUES (3012, 'LOVE', 'LEGO Art LOVE 31214', 102, '12+', 'C', 'L', TRUE, NULL, 'Guía incluida', 559);
INSERT INTO JUGUETES VALUES (3013, 'Mona Lisa', 'LEGO Art Mona Lisa 31213', 102, '12+', 'C', 'L', TRUE, NULL, 'Guía paso a paso', 3110);
INSERT INTO JUGUETES VALUES (3014, 'The Fauna Collection - Tiger', 'LEGO Art Fauna: Tigre 31217', 102, '12+', 'C', 'L', TRUE, NULL, 'Manual incluido', 637);
INSERT INTO JUGUETES (codigo, nombre, descripcion, id_tema, rgo_edad, rgo_precio, tipo_lego, "set", id_setpadre, instruc, piezas) VALUES 
(408, 'Iron Spider-Man', 'Figura de Spider-Man con armadura Iron Spider y alas mecánicas', 306, '9A11', 'C', 'L', TRUE, NULL, 'Instrucciones con detalles técnicos', 412),
(409, 'Dancing Groot', 'Groot bebé con funciones de baile y expresiones animadas', 306, '7A8', 'B', 'L', TRUE, NULL, 'Guía paso a paso interactiva', 298),
(410, 'Miles Morales Mask', 'Casco de Miles Morales con detalles luminosos y soporte', 306, '12+', 'C', 'L', TRUE, 408, 'Instrucciones avanzadas con LEDs', 156),
(411, 'Daily Bugle', 'Edificio icónico del Daily Bugle con oficinas y figuras', 306, 'ADULTOS', 'D', 'L', TRUE, NULL, 'Manual profesional 4D', 3724);

INSERT INTO JUGUETES (codigo, nombre, descripcion, id_tema, rgo_edad, rgo_precio, tipo_lego, "set", id_setpadre, instruc, piezas) VALUES 
(412, 'Eeyore BrickHeadz', 'Figurine BrickHeadz de Eeyore con orejas colgantes', 307, '5A6', 'A', 'O', TRUE, NULL, 'Instrucciones simples coloridas', 127),
(413, 'Wednesday y Enid', 'Duo BrickHeadz de Wednesday Addams y Enid Sinclair', 307, '9A11', 'B', 'O', TRUE, NULL, 'Guía dual con personalización', 251),
(414, 'Dumbo BrickHeadz', 'Figura BrickHeadz de Dumbo con orejas grandes', 307, '3A4', 'A', 'O', TRUE, NULL, 'Instrucciones básicas grandes', 189),
(415, 'Red Panda Mei', 'BrickHeadz de Mei como panda roja de Turning Red', 307, '7A8', 'B', 'O', TRUE, 412, 'Instrucciones con variaciones animales', 140);

-- PRODUCTOS_RELACIONADOS

INSERT INTO PRODUCTOS_RELACIONADOS (id_producto, id_prod_relaci) VALUES 
-- Marvel: Spider-Man familia + Daily Bugle escenario
(408, 410),
(410, 408),
(408, 411), 
(409, 411), 

(412, 414), 
(414, 412),
(415, 414);

--LEGO BATMAN SE RELACIONA
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (2011, 2013);
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (2011, 2012);
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (2012, 2014);
INSERT INTO PRODUCTOS_RELACIONADOS VALUES (2013, 2014);

-- HISTORICO_PRECIOS_JUGUETES
INSERT INTO HISTORICO_PRECIOS_JUGUETES (cod_juguete, f_inicio, precio, f_fin)
VALUES (401, TO_DATE('2025-01-01','YYYY-MM-DD'), 20.00, TO_DATE('2025-06-30','YYYY-MM-DD'));
INSERT INTO HISTORICO_PRECIOS_JUGUETES (cod_juguete, f_inicio, precio, f_fin) VALUES 
(408, TO_DATE('2025-01-01','YYYY-MM-DD'), 45.99, TO_DATE('2025-06-30','YYYY-MM-DD')),
(409, TO_DATE('2025-02-15','YYYY-MM-DD'), 29.99, TO_DATE('2025-08-20','YYYY-MM-DD')), 
(2012, TO_DATE('2025-03-01','YYYY-MM-DD'), 19.99, NULL),                             
(3012, TO_DATE('2025-04-10','YYYY-MM-DD'), 79.99, TO_DATE('2025-10-15','YYYY-MM-DD')),
(412, TO_DATE('2025-05-01','YYYY-MM-DD'), 9.99, NULL),                                 
(414, TO_DATE('2025-01-15','YYYY-MM-DD'), 9.99, TO_DATE('2025-07-01','YYYY-MM-DD')),   
(2011, TO_DATE('2025-06-01','YYYY-MM-DD'), 4.99, NULL);                               


-- CATALOGOS_LEGO
INSERT INTO CATALOGOS_LEGO (id_pais, cod_juguete, limite)
VALUES (58, 401, 100);
INSERT INTO CATALOGOS_LEGO (id_pais, cod_juguete, limite) VALUES 
(52, 408, 50), 
(55, 409, 75), 
(49, 2012, 30),
(61, 412, 100), 
(34, 414, 60),
(972, 2011, 40),
(43, 3012, 25); 


-- =======================
-- TABLAS DE VIOLETA
-- =======================

-- DETALLES_INSCRITOS
INSERT INTO DETALLES_INSCRITOS(fecha_inicio, nro_fact, id_det_insc, id_visit) 
VALUES (TO_DATE('2026-12-22','YYYY-MM-DD'), 250, 40, 2001),
       (TO_DATE('2026-12-22','YYYY-MM-DD'), 250, 98, 2003);

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
