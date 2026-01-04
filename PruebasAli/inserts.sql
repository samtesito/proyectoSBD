
------------TIENDA LEGO---------------
INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (10, 'LEGO Caracas', 'Av. Libertador, C.C. Sambil', 58, 1, 101);

INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (11, 'LEGO Store Rishon Lezion', 'G Cinema City Mall', 972, 1, 1);

INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (12, 'LEGO Store Tel Aviv', 'Dizengoff Center', 972, 2, 1);

INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (13, 'LEGO Store Eilat', 'BIG CENTER Eilat', 972, 3, 1);

INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (21, 'LEGO Store Egana', 'Av. Larrain 5862', 56, 2, 2); -- Chile

INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (22, 'LEGO Store Manquehue', 'Av. Manquehue Nte.', 56, 2, 1); -- Chile

-- Tienda para España (necesaria para reporte 6)
-- Asumo que tienes Ciudad 101 en Pais 34 (Madrid) creado en tus ciudades
INSERT INTO TIENDAS_LEGO (id, nombre, direccion, id_pais, id_estado, id_ciudad)
VALUES (34, 'LEGO Store Madrid', 'Calle Serrano', 34, 1, 101); 

COMMIT;




------------CLIENTES---------------------
-- Nota: Aquí especificamos (col1, col2...) para que Oracle sepa dónde va cada dato
-- sin importar el desorden de la tabla original.

-- Venezuela (1001)
INSERT INTO CLIENTES (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi, pasaporte, f_venc_pasap)
VALUES (1001, 'María', 'José', 'González', 'Pérez', TO_DATE('1990-05-12','YYYY-MM-DD'), 'V-12345678', 58, 'P1234567', TO_DATE('2030-05-12','YYYY-MM-DD'));

-- Dinamarca (1002, 1003)
INSERT INTO CLIENTES (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi, pasaporte, f_venc_pasap)
VALUES (1002, 'Juan', 'Gabriel', 'Hernandez', 'Paredes', TO_DATE('2002-04-13','YYYY-MM-DD'), '65893214P', 43, NULL, NULL);

INSERT INTO CLIENTES (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi, pasaporte, f_venc_pasap)
VALUES (1003, 'Elsa', NULL, 'Kristensen', 'Dorgu', TO_DATE('1992-02-20','YYYY-MM-DD'), '200292-1235', 43, NULL, NULL);

-- Mexico (1004)
INSERT INTO CLIENTES (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi, pasaporte, f_venc_pasap)
VALUES (1004, 'Carlos', 'Antonio', 'López', 'García', TO_DATE('1985-11-03','YYYY-MM-DD'), 'MX12345678', 52, 'MEX789012', TO_DATE('2028-11-03','YYYY-MM-DD'));

-- Brasil (1005) - Se agregó pasaporte ficticio para cumplir regla NO-UE
INSERT INTO CLIENTES (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi, pasaporte, f_venc_pasap)
VALUES (1005, 'Ana', 'Beatriz', 'Silva', 'Santos', TO_DATE('1998-07-22','YYYY-MM-DD'), '12345678901', 55, 'BRA998877', TO_DATE('2029-07-22','YYYY-MM-DD'));

-- Alemania (1006)
INSERT INTO CLIENTES (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi, pasaporte, f_venc_pasap)
VALUES (1006, 'Hans', NULL, 'Müller', 'Schmidt', TO_DATE('1975-09-15','YYYY-MM-DD'), '1234567890', 49, NULL, NULL);

-- Australia (1007) - Se agregó pasaporte ficticio para cumplir regla NO-UE
INSERT INTO CLIENTES (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi, pasaporte, f_venc_pasap)
VALUES (1007, 'Sarah', 'Jane', 'Wilson', 'Brown', TO_DATE('2005-03-10','YYYY-MM-DD'), 'AU123456789', 61, 'AUS456789', TO_DATE('2032-03-10','YYYY-MM-DD'));

-- España (1008)
INSERT INTO CLIENTES (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi, pasaporte, f_venc_pasap)
VALUES (1008, 'Lucía', NULL, 'Martín', 'Gómez', TO_DATE('1994-12-28','YYYY-MM-DD'), '12345678Z', 34, NULL, NULL);

-- Israel (1009)
INSERT INTO CLIENTES (id_lego, prim_nom, seg_nom, prim_ape, seg_ape, f_nacim, dni, id_pais_resi, pasaporte, f_venc_pasap)
VALUES (1009, 'David', 'Eli', 'Cohen', 'Levy', TO_DATE('1988-01-17','YYYY-MM-DD'), '123456789', 972, 'ISR987654', TO_DATE('2029-01-17','YYYY-MM-DD'));

COMMIT;



----------FACTURAS TIENDA----------------------------------
INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total) VALUES 
(500001, 1001, 10, TO_DATE('2025-12-01','YYYY-MM-DD'), 150.50);

INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total) VALUES 
(500002, 1002, 11, TO_DATE('2025-12-03','YYYY-MM-DD'), 245.99); 

INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total) VALUES
(500003, 1004, 10, TO_DATE('2025-12-04','YYYY-MM-DD'), 89.50);

INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total) VALUES
(500004, 1005, 21, TO_DATE('2025-12-05','YYYY-MM-DD'), 178.20);

INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total) VALUES
(500005, 1006, 12, TO_DATE('2025-12-06','YYYY-MM-DD'), 320.75); 

INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total) VALUES
(500006, 1008, 13, TO_DATE('2025-12-07','YYYY-MM-DD'), 156.00);

INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total) VALUES
(500007, 1009, 22, TO_DATE('2025-12-08','YYYY-MM-DD'), 210.30);
COMMIT;




------------TELEFONOS-------------------------------
INSERT INTO TELEFONOS (cod_inter, cod_local, numero, tipo, id_cliente) VALUES 
(58, 212, 5551234, 'F', 1001); 
INSERT INTO TELEFONOS (cod_inter, cod_local, numero, tipo, id_cliente) VALUES 
(52, 55, 1234567, 'F', 1004);
INSERT INTO TELEFONOS (cod_inter, cod_local, numero, tipo, id_cliente) VALUES 
(55, 11, 9876543, 'M', 1005);
INSERT INTO TELEFONOS (cod_inter, cod_local, numero, tipo, id_cliente) VALUES 
(49, 30, 4567890, 'F', 1006);
INSERT INTO TELEFONOS (cod_inter, cod_local, numero, tipo, id_cliente) VALUES 
(61, 2, 7890123, 'M', 1007);
INSERT INTO TELEFONOS (cod_inter, cod_local, numero, tipo, id_cliente) VALUES 
(34, 91, 2345678, 'F', 1008);
INSERT INTO TELEFONOS (cod_inter, cod_local, numero, tipo, id_cliente) VALUES 
(972, 3, 4567890, 'M', 1009);
COMMIT;



----------FACTURAS ONLINE----------------------------
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total) VALUES 
(700001, TO_DATE('2025-11-25','YYYY-MM-DD'), 1001, 25, 80.75);
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total) VALUES 
(700002, TO_DATE('2025-11-28','YYYY-MM-DD'), 1002, 15, 120.25);
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total) VALUES 
(700003, TO_DATE('2025-11-29','YYYY-MM-DD'), 1004, 30, 89.99);
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total) VALUES 
(700004, TO_DATE('2025-11-30','YYYY-MM-DD'), 1005, 22, 175.80);
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total) VALUES 
(700005, TO_DATE('2025-12-01','YYYY-MM-DD'), 1006, 45, 299.50);
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total) VALUES 
(700006, TO_DATE('2025-12-02','YYYY-MM-DD'), 1007, 12, 65.75);
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total) VALUES 
(700007, TO_DATE('2025-12-03','YYYY-MM-DD'), 1008, 18, 142.00);
COMMIT;
