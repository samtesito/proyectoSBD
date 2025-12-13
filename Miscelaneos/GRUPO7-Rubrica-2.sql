--Grupo 7, Rubrica 2

--CREATES

---------------- CONFIGURACIONES NECESARIAS ---------------

SET SERVEROUTPUT ON;

--------------------  TABLAS DE ALI  ----------------------

CREATE TABLE PAISES (
    id NUMBER(3) CONSTRAINT pk_paises PRIMARY KEY,                   
    nombre VARCHAR2(30) NOT NULL,            
    gentilicio VARCHAR2(15) NOT NULL,        
    continente VARCHAR2(7) NOT NULL,         
    ue BOOLEAN NOT NULL,                     
    CONSTRAINT chk_pais_continente CHECK (continente IN('AFRICA', 'AMERICA', 'ASIA', 'EUROPA', 'OCEANIA'))
);

CREATE TABLE ESTADOS (
    id_pais NUMBER(3) NOT NULL,             
    id NUMBER(5) NOT NULL,                  
    nombre VARCHAR2(35) NOT NULL,        
    CONSTRAINT fk_estado_pais FOREIGN KEY (id_pais) REFERENCES PAISES(id),
    CONSTRAINT pk_estado PRIMARY KEY (id_pais,id)
);

CREATE TABLE CIUDADES (
    id_pais NUMBER(3) NOT NULL,  
    id_estado NUMBER(5) NOT NULL,
    id NUMBER(8) NOT NULL,           
    nombre VARCHAR2(35) NOT NULL,    
    CONSTRAINT fk_ciudad_est FOREIGN KEY (id_pais, id_estado) REFERENCES ESTADOS(id_pais,id),
    CONSTRAINT pk_ciudad PRIMARY KEY (id_pais, id_estado, id) 
);

CREATE TABLE CLIENTES (
    id_lego NUMBER(8) CONSTRAINT pk_clientes PRIMARY KEY,              
    prim_nom VARCHAR2(10) NOT NULL,       
    prim_ape VARCHAR2(10) NOT NULL,      
    seg_ape VARCHAR2(10) NOT NULL,     
    f_nacim DATE NOT NULL,           
    dni VARCHAR2(20) NOT NULL,
    id_pais_resi NUMBER(3) NOT NULL,         
    seg_nom VARCHAR2(10),               
    pasaporte VARCHAR2(20),
    f_venc_pasap DATE,                     
    CONSTRAINT fk_cliente_pais FOREIGN KEY (id_pais_resi) REFERENCES PAISES(id),
    CONSTRAINT chk_cliente_pasaporte CHECK (pasaporte IS NULL OR f_venc_pasap IS NOT NULL)
);

CREATE TABLE TIENDAS_LEGO (
    id NUMBER(5) CONSTRAINT pk_tienda PRIMARY KEY, 
    nombre VARCHAR2(30) NOT NULL,       
    direccion VARCHAR2(150) NOT NULL,            
    id_pais NUMBER NOT NULL,
    id_estado NUMBER NOT NULL,
    id_ciudad NUMBER NOT NULL, 
    CONSTRAINT fk_tienda_ciudad FOREIGN KEY (id_pais, id_estado, id_ciudad) REFERENCES CIUDADES(id_pais, id_estado, id)
);

CREATE TABLE HORARIOS_ATENCION (
    id_tienda NUMBER(5) NOT NULL,          
    dia VARCHAR2(3) NOT NULL,  
    hora_entr DATE NOT NULL,   
    hora_sal DATE NOT NULL,    
    CONSTRAINT fk_horario_tienda FOREIGN KEY (id_tienda) REFERENCES TIENDAS_LEGO(id),
    CONSTRAINT pk_horarios PRIMARY KEY (id_tienda, dia),
    CONSTRAINT chk_dia CHECK(dia IN ('LUN','MAR','MIE','JUE','VIE','SAB','DOM'))
);

--------------------  TABLAS DE DANIEL ----------------------

CREATE TABLE FACTURAS_TIENDA (
    nro_fact NUMBER(9) CONSTRAINT pk_fact PRIMARY KEY,
    id_cliente NUMBER(8) NOT NULL,
    id_tienda NUMBER(5) NOT NULL,
    f_emision DATE NOT NULL,
    total NUMBER(8, 2), 
    CONSTRAINT fk_facttnda_clien FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_lego),
    CONSTRAINT fk_facttnd_tnda FOREIGN KEY (id_tienda) REFERENCES TIENDAS_LEGO(id)
);
------VALIDAR EL TOTAL

CREATE TABLE VISITANTES_FANS (
    id_lego NUMBER(8) CONSTRAINT pk_visitante PRIMARY KEY,
    prim_nom VARCHAR2(10) NOT NULL,
    prim_ape VARCHAR2(10) NOT NULL,
    seg_ape VARCHAR2(10) NOT NULL,
    f_nacim DATE NOT NULL,
    dni NUMBER(10) NOT NULL,
    id_pais NUMBER(3) NOT NULL,
    id_repres NUMBER(8),
    seg_nom VARCHAR2(10),
    f_venc_pasap DATE,
    pasaporte VARCHAR2(15),
    CONSTRAINT fk_visifan_pais FOREIGN KEY (id_pais) REFERENCES PAISES(id),
    CONSTRAINT fk_visifan_clien FOREIGN KEY (id_repres) REFERENCES CLIENTES(id_lego),
    CONSTRAINT chk_visitante_pasaporte CHECK (pasaporte IS NULL OR f_venc_pasap IS NOT NULL)
);

CREATE TABLE TELEFONOS (
    cod_inter NUMBER(3) NOT NULL,
    cod_local NUMBER(4) NOT NULL,
    numero NUMBER(10) NOT NULL,
    tipo VARCHAR2(1) NOT NULL,
    id_cliente NUMBER(8),
    id_visitante NUMBER(8),
    id_tienda NUMBER(5),
    CONSTRAINT pk_tlf PRIMARY KEY (cod_inter, cod_local, numero),
    CONSTRAINT fk_tlf_clien FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_lego),
    CONSTRAINT fk_tlf_visi FOREIGN KEY (id_visitante) REFERENCES VISITANTES_FANS(id_lego),
    CONSTRAINT fk_tlf_tnda FOREIGN KEY (id_tienda) REFERENCES TIENDAS_LEGO(id),
    CONSTRAINT chk_arco_exclusivo CHECK (
        (id_cliente IS NOT NULL AND id_visitante IS NULL AND id_tienda IS NULL) OR
        (id_cliente IS NULL AND id_visitante IS NOT NULL AND id_tienda IS NULL) OR
        (id_cliente IS NULL AND id_visitante IS NULL AND id_tienda IS NOT NULL)
    ), 
    CONSTRAINT chk_tipo_telefono CHECK (tipo IN ('F', 'M'))
);

CREATE TABLE FACTURAS_ONLINE (
    nro_fact NUMBER(8) CONSTRAINT pk_fact_onl PRIMARY KEY,
    f_emision DATE NOT NULL,
    id_cliente NUMBER(8) NOT NULL,
    ptos_generados NUMBER(3) NOT NULL,
    total NUMBER(8, 2),
    CONSTRAINT fk_factonl_clien FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_lego)
);

CREATE TABLE FECHAS_TOUR(
    f_inicio DATE CONSTRAINT pk_fecha_tour PRIMARY KEY,
    costo NUMBER(8,2) NOT NULL,
    cupos NUMBER(3) NOT NULL ---- REVISAAAAAAR
);

CREATE TABLE INSCRIPCIONES_TOUR (
    f_inicio DATE NOT NULL,
    nro_fact NUMBER(8) NOT NULL,
    f_emision DATE NOT NULL,
    estado VARCHAR2(10) NOT NULL,
    total NUMBER(8,2),
    CONSTRAINT fk_insctour_ftour FOREIGN KEY (f_inicio) REFERENCES FECHAS_TOUR(f_inicio),
    CONSTRAINT pk_inscripciones PRIMARY KEY (f_inicio, nro_fact),
    CONSTRAINT chk_statusinsc CHECK (estado IN ('PAGADO', 'PENDIENTE'))
);

--------------------  TABLAS DE SAMUEL ----------------------

CREATE TABLE ENTRADAS (
    f_inicio DATE NOT NULL,
    nro_fact NUMBER(8) NOT NULL,
    nro NUMBER(8) NOT NULL,
    tipo VARCHAR2(1) NOT NULL,
    CONSTRAINT fk_entrada_inscripcion FOREIGN KEY (f_inicio, nro_fact) REFERENCES INSCRIPCIONES_TOUR(f_inicio, nro_fact),
    CONSTRAINT pk_entrada PRIMARY KEY (f_inicio, nro_fact, nro),
    CONSTRAINT check_tipo_entradas CHECK(tipo IN ('M','A'))
);

CREATE TABLE TEMAS(
    id NUMBER(5) CONSTRAINT pk_temas PRIMARY KEY,
    nombre VARCHAR2(20) NOT NULL,
    tipo VARCHAR2(1) NOT NULL CHECK(tipo IN ('L','O')),
    descripcion VARCHAR2(150) NOT NULL,
    id_tema_padre NUMBER(5),
    CONSTRAINT fk_tema_temapadr FOREIGN KEY (id_tema_padre) REFERENCES TEMAS(id)
);

CREATE TABLE JUGUETES (
    codigo NUMBER(5) CONSTRAINT pk_juguetes PRIMARY KEY,
    nombre VARCHAR2(30) NOT NULL,
    descripcion VARCHAR2(150) NOT NULL,
    id_tema NUMBER(5) NOT NULL,
    rgo_edad VARCHAR2(7) NOT NULL,
    rgo_precio VARCHAR2(1) NOT NULL,
    tipo_lego VARCHAR2(1) NOT NULL,
    "set" BOOLEAN NOT NULL,
    id_setpadre NUMBER(5),
    instruc VARCHAR2(200),
    piezas NUMBER(6),
    CONSTRAINT fk_detalleset FOREIGN KEY (id_setpadre) REFERENCES JUGUETES(codigo),
    CONSTRAINT fk_juguete_tema FOREIGN KEY (id_tema) REFERENCES TEMAS(id),
    CONSTRAINT check_rgo_edad CHECK(rgo_edad IN ('0A2','3A4','5A6','7A8','9A11','12+','ADULTOS')),
    CONSTRAINT check_rgo_precio CHECK(rgo_precio IN ('A','B','C','D')),
    CONSTRAINT check_tipo_lego CHECK(tipo_lego IN ('O','L'))
);
----VALIDAR SI HAY PIEZAS O NO 

CREATE TABLE PRODUCTOS_RELACIONADOS (
    id_producto NUMBER(5), 
    id_prod_relaci NUMBER(5),
    CONSTRAINT fk_prodrela_producto FOREIGN KEY (id_producto) REFERENCES JUGUETES(codigo),
    CONSTRAINT fk_prodrela_productorelacion FOREIGN KEY (id_prod_relaci) REFERENCES JUGUETES(codigo),
    CONSTRAINT pk_productos_relacionados PRIMARY KEY (id_producto, id_prod_relaci)
);

CREATE TABLE HISTORICO_PRECIOS_JUGUETES (
    cod_juguete NUMBER(5) NOT NULL,
    f_inicio DATE NOT NULL,
    precio NUMBER(5,2) NOT NULL,
    f_fin DATE,
    CONSTRAINT fk_histprecio_juguete FOREIGN KEY (cod_juguete) REFERENCES JUGUETES(codigo),
    CONSTRAINT pk_histprecio PRIMARY KEY (cod_juguete,f_inicio)
);

CREATE TABLE CATALOGOS_LEGO (
    id_pais NUMBER(3) NOT NULL,
    cod_juguete NUMBER(5) NOT NULL,
    limite NUMBER(5) NOT NULL,
    CONSTRAINT fk_catalogo_pais FOREIGN KEY (id_pais) REFERENCES PAISES(id),
    CONSTRAINT fk_catalogo_juguete FOREIGN KEY (cod_juguete) REFERENCES JUGUETES(codigo),
    CONSTRAINT pk_catalogo PRIMARY KEY (id_pais, cod_juguete)
);

--------------------  TABLAS DE VIOLETA ----------------------

CREATE TABLE DETALLES_INSCRITOS(
    fecha_inicio DATE NOT NULL,
    nro_fact NUMBER(6) NOT NULL,
    id_det_insc NUMBER(8) NOT NULL,
    id_cliente NUMBER(8),
    id_visit NUMBER(8),
    CONSTRAINT fk_detinsc_inscripcion FOREIGN KEY (fecha_inicio, nro_fact) REFERENCES INSCRIPCIONES_TOUR(f_inicio,nro_fact),
    CONSTRAINT pk_detinscritos PRIMARY KEY (fecha_inicio,nro_fact,id_det_insc),
    CONSTRAINT fk_detinsc_clien FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_lego),
    CONSTRAINT fk_detinsc_visi FOREIGN KEY (id_visit) REFERENCES VISITANTES_FANS(id_lego),
    CONSTRAINT chk_arcexcldetinsc CHECK (
        (id_cliente IS NOT NULL AND id_visit IS NULL) OR
        (id_cliente IS NULL AND id_visit IS NOT NULL))
);

CREATE TABLE DETALLES_FACTURA_ONLINE(
    nro_fact NUMBER(6) NOT NULL,
    id_det_fact NUMBER(8) NOT NULL,
    cant_prod NUMBER(3) NOT NULL,
    tipo_cli VARCHAR2(1) NOT NULL,
    codigo NUMBER(8) NOT NULL,
    id_pais NUMBER(3) NOT NULL, 
    CONSTRAINT fk_detfactonl_factonl FOREIGN KEY (nro_fact) REFERENCES FACTURAS_ONLINE (nro_fact),
    CONSTRAINT pk_detfactonl PRIMARY KEY (nro_fact,id_det_fact),
    CONSTRAINT fk_detfactonl_catalogo FOREIGN KEY (codigo,id_pais) REFERENCES CATALOGOS_LEGO(cod_juguete,id_pais),
    CONSTRAINT tipo_clientefo CHECK (tipo_cli in('M','A'))
);

CREATE TABLE LOTES_SET_TIENDA(
    cod_juguete NUMBER(8) NOT NULL,
    id_tienda NUMBER(8) NOT NULL,
    nro_lote NUMBER(3) NOT NULL,
    f_adqui DATE NOT NULL,
    cant_prod NUMBER(3) NOT NULL,
    CONSTRAINT fk_lottienda_codjug FOREIGN KEY (cod_juguete) REFERENCES JUGUETES(codigo),
    CONSTRAINT fk_lottienda_tnda FOREIGN KEY (id_tienda) REFERENCES TIENDAS_LEGO(id),
    CONSTRAINT pk_lotes PRIMARY KEY (cod_juguete,id_tienda,nro_lote)
);

CREATE TABLE DETALLES_FACTURA_TIENDA(
    nro_fact NUMBER(6) NOT NULL,
    id_det_fact NUMBER(8) NOT NULL,
    cant_prod NUMBER(3) NOT NULL,
    tipo_cli VARCHAR2(1) NOT NULL,
    codigo NUMBER(8) NOT NULL,
    id_tienda NUMBER(8) NOT NULL,
    nro_lote NUMBER(3) NOT NULL,
    CONSTRAINT fk_detfacttnda_facttnda FOREIGN KEY (nro_fact) REFERENCES FACTURAS_TIENDA (nro_fact),
    CONSTRAINT pk_detfacttnda PRIMARY KEY (nro_fact,id_det_fact),
    CONSTRAINT fk_detfacttnda_lote FOREIGN KEY (codigo,id_tienda,nro_lote) REFERENCES LOTES_SET_TIENDA(cod_juguete,id_tienda,nro_lote),
    CONSTRAINT tipo_clienteft CHECK (tipo_cli in('M','A'))
);

--M: MENOR, A:ADULTO

CREATE TABLE DESCUENTOS(
    codigo NUMBER(8) NOT NULL,
    id_tienda NUMBER(8) NOT NULL,
    nro_lote NUMBER(3) NOT NULL,
    id_desc NUMBER(8) NOT NULL,
    fecha DATE NOT NULL,
    cant NUMBER(2) NOT NULL,
    CONSTRAINT fk_desc_lote FOREIGN KEY (codigo,id_tienda,nro_lote) REFERENCES LOTES_SET_TIENDA (cod_juguete,id_tienda,nro_lote),
    CONSTRAINT pk_iddesc PRIMARY KEY(codigo,id_tienda,nro_lote,id_desc)
);


--INSERTS

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
VALUES (TO_DATE('2026-02-20','YYYY-MM-DD'), 250, 900001, 'A'); -- Adulto
INSERT INTO ENTRADAS (f_inicio, nro_fact, nro, tipo) VALUES 
(TO_DATE('2026-02-20','YYYY-MM-DD'), 250, 900002, 'M');  -- Menor


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
INSERT INTO HISTORICO_PRECIOS_JUGUETES (cod_juguete, f_inicio, precio, f_fin) VALUES 
(408, TO_DATE('2025-01-01','YYYY-MM-DD'), 45.99, TO_DATE('2025-06-30','YYYY-MM-DD')),
(409, TO_DATE('2025-02-15','YYYY-MM-DD'), 29.99, TO_DATE('2025-08-20','YYYY-MM-DD')), 
(2012, TO_DATE('2025-03-01','YYYY-MM-DD'), 19.99, NULL),                             
(3012, TO_DATE('2025-04-10','YYYY-MM-DD'), 79.99, TO_DATE('2025-10-15','YYYY-MM-DD')),
(412, TO_DATE('2025-05-01','YYYY-MM-DD'), 9.99, NULL),                                 
(414, TO_DATE('2025-01-15','YYYY-MM-DD'), 9.99, TO_DATE('2025-07-01','YYYY-MM-DD')),   
(2011, TO_DATE('2025-06-01','YYYY-MM-DD'), 4.99, NULL);                               


-- CATALOGOS_LEGO
INSERT INTO CATALOGOS_LEGO (id_pais, cod_juguete, limite) VALUES 
(52, 408, 50), 
(55, 409, 75), 
(49, 2012, 30),
(61, 412, 100), 
(34, 414, 60),
(972, 2011, 40),
(43, 3012, 25);

INSERT INTO CATALOGOS_LEGO (id_pais, cod_juguete, limite) VALUES (58, 408, 100);



-- =======================
-- TABLAS DE VIOLETA
-- =======================

-- DETALLES_INSCRITOS
INSERT INTO DETALLES_INSCRITOS(fecha_inicio, nro_fact, id_det_insc, id_visit) 
VALUES (TO_DATE('2026-02-20','YYYY-MM-DD'), 250, 40, 2001),
       (TO_DATE('2026-02-20','YYYY-MM-DD'), 250, 98, 2003);

-- DETALLES_FACTURA_ONLINE
INSERT INTO DETALLES_FACTURA_ONLINE (nro_fact, id_det_fact, cant_prod, tipo_cli, codigo, id_pais)
VALUES (700001, 70001, 2, 'A', 408, 58);

-- LOTES_SET_TIENDA
INSERT INTO LOTES_SET_TIENDA (cod_juguete, id_tienda, nro_lote, f_adqui, cant_prod)
VALUES (408, 10, 301, TO_DATE('2025-10-15','YYYY-MM-DD'), 30);

-- DETALLES_FACTURA_TIENDA
INSERT INTO DETALLES_FACTURA_TIENDA (nro_fact, id_det_fact, cant_prod, tipo_cli, codigo, id_tienda, nro_lote)
VALUES (500001, 80001, 3, 'M', 408, 10, 301);

-- DESCUENTOS
INSERT INTO DESCUENTOS (codigo, id_tienda, nro_lote, id_desc, fecha, cant)
VALUES (408, 10, 301, 90001, TO_DATE('2025-12-05','YYYY-MM-DD'), 15);

/*
--INSERTS PROBADOS: CUPO
INSERT INTO FECHAS_TOUR VALUES('22-12-26',20,1);
INSERT INTO INSCRIPCIONES_TOUR VALUES('22-12-26',250,'08-12-25','PENDIENTE',0);
--DEBEN ESTAR LOS VISITANTES ANTES, ESTOS EN LA PRUEBA NO NECESITABAN REPRESENTANTE
INSERT INTO DETALLES_INSCRITOS(fecha_inicio,nro_fact, id_det_insc,id_visit) VALUES('22-12-26',250,40,2001);
INSERT INTO DETALLES_INSCRITOS(fecha_inicio,nro_fact, id_det_insc,id_visit) VALUES('22-12-26',250,98,2003);

------------------------------------------------------------
-- FIN DEL SCRIPT DE DATOS DE PRUEBA
------------------------------------------------------------
*/




--FUNCIONES

---calcular edad---
CREATE OR REPLACE FUNCTION edad (fec_nac DATE) RETURN NUMBER IS
BEGIN 
    RETURN(ROUND(((sysdate-fec_nac)/365),0));
END;
/




---calcular subtotal---
CREATE OR REPLACE FUNCTION calcular_subtotal_factura(
    p_nro_fact IN NUMBER,
    p_tipo_factura IN VARCHAR2  -- 'TIENDA' u 'ONLINE'
) RETURN NUMBER IS
    v_total NUMBER(10,2) := 0;
BEGIN
    IF p_tipo_factura = 'TIENDA' THEN
        SELECT NVL(SUM(d.cant_prod * h.precio), 0)
        INTO v_total
        FROM DETALLES_FACTURA_TIENDA d
        JOIN LOTES_SET_TIENDA l ON (d.codigo, d.id_tienda, d.nro_lote) = (l.cod_juguete, l.id_tienda, l.nro_lote)
        JOIN HISTORICO_PRECIOS_JUGUETES h ON l.cod_juguete = h.cod_juguete AND h.f_fin IS NULL
        WHERE d.nro_fact = p_nro_fact;
        
    ELSIF p_tipo_factura = 'ONLINE' THEN
        SELECT NVL(SUM(d.cant_prod * h.precio), 0)
        INTO v_total
        FROM DETALLES_FACTURA_ONLINE d
        JOIN CATALOGOS_LEGO c ON (d.codigo, d.id_pais) = (c.cod_juguete, c.id_pais)
        JOIN HISTORICO_PRECIOS_JUGUETES h ON c.cod_juguete = h.cod_juguete AND h.f_fin IS NULL
        WHERE d.nro_fact = p_nro_fact;
    ELSE
        RAISE_APPLICATION_ERROR(-20050, 'Tipo de factura invalido:' || p_tipo_factura);
    END IF;
    RETURN v_total;
END;
/





---calcular recargo de envio---
CREATE OR REPLACE FUNCTION FUNC_CALCULAR_RECARGO(p_id_pais IN NUMBER) 
RETURN NUMBER IS
    v_es_ue PAISES.ue%TYPE; 
    v_recargo NUMBER(5,2);
BEGIN
    SELECT ue 
    INTO v_es_ue 
    FROM PAISES 
    WHERE id = p_id_pais;
    if v_es_ue = TRUE THEN
        v_recargo := 0.05; -- 5% para Union Europea
    ELSE
        v_recargo := 0.15; -- 15% para el resto del mundo
    END IF;
    RETURN v_recargo;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20101, 'Error: El ID de pais proporcionado no existe.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20102, 'Error inesperado al calcular recargo: ' || SQLERRM);
END;
/

CREATE OR REPLACE FUNCTION FUNC_CALCULAR_TOTAL_ONLINE(
    p_nro_fact IN NUMBER,
    p_tipo_factura IN VARCHAR2,
    p_id_pais IN NUMBER
) RETURN NUMBER IS
    v_subtotal NUMBER(10,2);
    v_recargo  NUMBER;
BEGIN
    v_subtotal := calcuura(p_nro_fact, p_tipo_factura);
    v_recargo := FUNC_CALCULAR_RECARGO(p_id_pais);
    
    RETURN ROUND(v_subtotal + (v_subtotal * v_recargo), 2);
END;
/



---calcular total de la factura fisica---
CREATE OR REPLACE FUNCTION FUNC_CALCULAR_TOTAL_TIENDA(
    p_nro_fact IN NUMBER,
    p_tipo_factura IN VARCHAR2
) RETURN NUMBER IS
    v_total NUMBER(10, 2);
BEGIN
    v_total := calcular_subtotal_factura(p_nro_fact, p_tipo_factura);
    RETURN ROUND(v_total, 2);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20104, 'Error al calcular el total en tienda: ' || SQLERRM);
END;
/





---calcular total de puntos---
CREATE OR REPLACE FUNCTION FUNC_CALCULAR_PUNTOS(p_total IN NUMBER) 
RETURN NUMBER IS
    v_puntos NUMBER(3);
BEGIN    
    -- Rango A: Menos de 10 -> 5 puntos
    IF p_total < 10 THEN
        v_puntos := 5;
        
    -- Rango B: De 10 a 70 -> 20 puntos
    ELSIF p_total >= 10 AND p_total <= 70 THEN
        v_puntos := 20;
        
    -- Rango C: Mas de 70 hasta 200 -> 50 puntos
    ELSIF p_total > 70 AND p_total <= 200 THEN
        v_puntos := 50;
        
    -- Rango D: Mas de 200 -> 200 puntos
    ELSIF p_total > 200 THEN
        v_puntos := 200;
        
    ELSE
        v_puntos := 0;
    END IF;

    RETURN v_puntos;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20013, 'Error al calcular puntos de lealtad: ' || SQLERRM);
END;
/






-- Tasa fija (aprox. actual)
CREATE OR REPLACE FUNCTION func_puntos_totales_cliente (
    p_id_cliente IN NUMBER
) RETURN NUMBER IS
    v_total_puntos NUMBER := 0;
    v_ultima_factura_gratis NUMBER;
BEGIN
    SELECT MAX(fo.nro_fact)
    INTO v_ultima_factura_gratis
    FROM FACTURAS_ONLINE fo
    WHERE fo.id_cliente = p_id_cliente 
    AND fo.ptos_generados = 0
    AND fo.total = (
        FUNC_CALCULAR_TOTAL_ONLINE(fo.nro_fact, 'ONLINE', 
            (SELECT id_pais 
            FROM DETALLES_FACTURA_ONLINE 
            WHERE nro_fact = fo.nro_fact 
            FETCH FIRST 1 ROW ONLY
            )
        ) - calcular_subtotal_factura(fo.nro_fact, 'ONLINE')
    );

    IF v_ultima_factura_gratis IS NULL THEN
        SELECT NVL(SUM(ptos_generados), 0)
        INTO v_total_puntos
        FROM FACTURAS_ONLINE WHERE id_cliente = p_id_cliente;
    ELSE
        SELECT NVL(SUM(ptos_generados), 0)
        INTO v_total_puntos
        FROM FACTURAS_ONLINE 
        WHERE id_cliente = p_id_cliente 
        AND nro_fact > v_ultima_factura_gratis;
    END IF;
    
    RETURN v_total_puntos;
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN 0;
    WHEN OTHERS THEN RETURN 0;
END;
/

CREATE OR REPLACE FUNCTION es_gratuita(
    p_id_cliente IN NUMBER
) RETURN BOOLEAN IS 
BEGIN
    IF (func_puntos_totales_cliente(p_id_cliente)>=500) THEN
        RETURN TRUE;
    ELSE 
        RETURN FALSE;
    END IF;
END es_gratuita;
/

CREATE OR REPLACE FUNCTION-- 1 USD ≈ 6.42 DKK (Coronas Danesas - LEGO)


-- Funcion para mostrar el precio local segun el pais
CREATE OR REPLACE FUNCTION mostrar_precio_local(
    p_precio_usd IN NUMBER,
    p_id_pais IN NUMBER
) RETURN NUMBER IS
    v_es_ue BOOLEAN;
    v_es_dinamarca BOOLEAN := FALSE;
BEGIN

    SELECT ue INTO v_es_ue FROM PAISES WHERE id = p_id_pais;
    
    IF p_id_pais = 43 THEN
        v_es_dinamarca := TRUE;
    END IF;
    
    IF v_es_dinamarca THEN
        RETURN ROUND(p_precio_usd * 6.42, 2);
        
    ELSIF v_es_ue THEN
        RETURN ROUND(p_precio_usd * 0.86, 2);
        
    ELSE
        RETURN p_precio_usd;
        
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN p_precio_usd;
END;
/







--- Totaliza la canitdad de lotes comprados en el dia ---
CREATE OR REPLACE FUNCTION FUNC_TOTAL_VENTAS_LOTE_DIA(
    p_id_tienda IN NUMBER,
    p_codigo    IN NUMBER,
    p_nro_lote  IN NUMBER
) RETURN NUMBER IS
    v_total_vendido NUMBER;
BEGIN
    SELECT SUM(d.cant_prod)
    INTO v_total_vendido
    FROM DETALLES_FACTURA_TIENDA d
    JOIN FACTURAS_TIENDA f ON d.nro_fact = f.nro_fact
    WHERE d.id_tienda = p_id_tienda
      AND d.codigo = p_codigo
      AND d.nro_lote = p_nro_lote
      AND TRUNC(f.f_emision) = TRUNC(SYSDATE); -- Solo ventas de hoy
    RETURN NVL(v_total_vendido, 0);

EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END;
/

--PROCEDURES

--1.0 PROCEDIMIENTO PARA INSERTAR PRECIOS
CREATE OR REPLACE PROCEDURE insertar_nuevo_precio (
    p_cod_juguete  IN HISTORICO_PRECIOS_JUGUETES.cod_juguete%TYPE,
    p_f_inicio     IN HISTORICO_PRECIOS_JUGUETES.f_inicio%TYPE,
    p_precio       IN HISTORICO_PRECIOS_JUGUETES.precio%TYPE
) IS
BEGIN
    UPDATE HISTORICO_PRECIOS_JUGUETES
    SET f_fin = p_f_inicio
    WHERE cod_juguete = p_cod_juguete
    AND f_fin IS NULL;
    INSERT INTO HISTORICO_PRECIOS_JUGUETES (cod_juguete, f_inicio, precio, f_fin)
    VALUES (p_cod_juguete, p_f_inicio, p_precio, NULL);
END;
/



--1.1 PROCEDIMIENTO PARA GENERAR ENTRADAS
CREATE SEQUENCE id_entrada INCREMENT BY 1 START WITH 1;
CREATE OR REPLACE PROCEDURE generar_entradas(
    p_f_tour IN DATE,   
    p_n_fact IN NUMBER  
) IS
    CURSOR c_inscritos IS 
        SELECT id_cliente, id_visit 
        FROM DETALLES_INSCRITOS 
        WHERE fecha_inicio = p_f_tour 
          AND nro_fact = p_n_fact;
          
    v_tipo_entrada CHAR(1);
BEGIN
    FOR r IN c_inscritos LOOP
        
        IF r.id_cliente IS NOT NULL THEN 
            v_tipo_entrada := 'A'; -- Cliente (Adulto)
        ELSE 
            v_tipo_entrada := 'M'; -- Visitante (Menor)
        END IF;

        INSERT INTO ENTRADAS(f_inicio, nro_fact, nro, tipo)
        VALUES(p_f_tour, p_n_fact, id_entrada.nextval, v_tipo_entrada);
        
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Entradas generadas con éxito.');
END generar_entradas;
/



--1.2 PROCEDIMIENTO PARA CALCULAR TOTAL FACTURA
CREATE OR REPLACE FUNCTION calcular_subtotal_factura(
    p_nro_fact IN NUMBER,
    p_tipo_factura IN VARCHAR2  -- 'TIENDA' o 'ONLINE'
) RETURN NUMBER IS
    v_total NUMBER(10,2) := 0;
BEGIN
    IF p_tipo_factura = 'TIENDA' THEN
        SELECT NVL(SUM(d.cant_prod * h.precio), 0)
        INTO v_total
        FROM DETALLES_FACTURA_TIENDA d
        JOIN LOTES_SET_TIENDA l ON (d.codigo, d.id_tienda, d.nro_lote) = (l.cod_juguete, l.id_tienda, l.nro_lote)
        JOIN HISTORICO_PRECIOS_JUGUETES h ON l.cod_juguete = h.cod_juguete AND h.f_fin IS NULL
        WHERE d.nro_fact = p_nro_fact;
        
    ELSIF p_tipo_factura = 'ONLINE' THEN
        SELECT NVL(SUM(d.cant_prod * h.precio), 0)
        INTO v_total
        FROM DETALLES_FACTURA_ONLINE d
        JOIN CATALOGOS_LEGO c ON (d.codigo, d.id_pais) = (c.cod_juguete, c.id_pais)
        JOIN HISTORICO_PRECIOS_JUGUETES h ON c.cod_juguete = h.cod_juguete AND h.f_fin IS NULL
        WHERE d.nro_fact = p_nro_fact;
    
    ELSE
        RAISE_APPLICATION_ERROR(-20050, 'Tipo de factura invalido:' || p_tipo_factura);
    END IF;
    
    RETURN v_total;
END;
/




--- PROCEDIMIENTO PARA ACTUALIZAR LOTE INVENTARIO 
CREATE OR REPLACE PROCEDURE actualizar_cant_lote(
    p_cod_juguete LOTES_SET_TIENDA.cod_juguete%TYPE,
    p_id_tienda LOTES_SET_TIENDA.id_tienda%TYPE,
    p_nro_lote LOTES_SET_TIENDA.nro_lote%TYPE,
    p_cant_descuento NUMBER
)
IS
BEGIN
    UPDATE LOTES_SET_TIENDA
    SET cant_prod = (cant_prod - p_cant_descuento) 
    WHERE (cod_juguete = p_cod_juguete) AND (id_tienda = p_id_tienda) AND (nro_lote = p_nro_lote);
END actualizar_cant_lote;




--- PROCEDIMIENTO PARA CERRAR LOTE INVENTARIO 
CREATE SEQUENCE desce
    increment by 1
    start with 1;

CREATE OR REPLACE PROCEDURE generar_desc_lote_por_fecha(
    p_fecha IN DATE DEFAULT SYSDATE,
    p_id_tienda IN NUMBER,
    p_cod_juguete IN NUMBER,
    p_nro_lote IN NUMBER
)
IS  
    v_cant_a_descontar NUMBER;
BEGIN
    SELECT sum(d.cant_prod) 
    INTO v_cant_a_descontar 
    FROM FACTURAS_TIENDA f, DETALLES_FACTURA_TIENDA d 
    WHERE (f.f_emision = p_fecha) 
        AND (d.nro_lote = p_nro_lote) 
        AND (d.id_tienda = p_id_tienda) 
        AND (d.codigo = p_cod_juguete);
    -- SE INSERTAN EL DESCUENTO
    INSERT INTO DESCUENTOS (id_desc, id_tienda, codigo,nro_lote,fecha,cant)
    VALUES (desce.nextval,p_id_tienda,p_cod_juguete,p_nro_lote,p_fecha,v_cant_a_descontar);
    -- SE ACTUALIZA LA CANTIDAD EN LOTE
    actualizar_cant_lote(p_cod_juguete,p_id_tienda,p_nro_lote,v_cant_a_descontar);
END generar_desc_lote_por_fecha;





---- OTRO INTENTO TOUR 

--CREATE OR REPLACE PROCEDURE gener_des_lotes_fech_y_tiem(
  --  p_fecha IN DATE DEFAULT SYSDATE,
  --  p_id_tienda IN NUMBER
--)
--IS 
  --  CURSOR facts_fecha IS SELECT f.nro_fact
    --    FROM FACTURAS_TIENDA f
    --    WHERE (f.nro_fact = p_fecha) AND (f.id_tienda = p_id_tienda);
   -- factu facts_fecha%ROWTYPE;
--BEGIN
  --  FOR factu IN facts_fecha LOOP
    --    SELECT d.codigo, d.id_tienda, d.nro_lote, sum(d.cant_prod) 
      --  FROM DETALLES_FACTURA_TIENDA d 
        --WHERE (d.nro_fact = factu)
    --END LOOP;
--END gener_des_lotes_fech_y_tiem;



--TRIGGERS

-- 1.1. Validacion de Pasaporte para No-UE
-- Regla: Si el pais no es de la UE, el pasaporte es obligatorio.
CREATE OR REPLACE TRIGGER trg_validar_pasaporte_ue
BEFORE INSERT OR UPDATE ON CLIENTES
FOR EACH ROW
DECLARE
    v_es_ue NUMBER(1); --
BEGIN
    SELECT CASE WHEN ue = 'TRUE' THEN 1 ELSE 0 END 
    INTO v_es_ue
    FROM PAISES
    WHERE id = :NEW.id_pais_resi; 

    IF v_es_ue = 0 AND :NEW.pasaporte IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: Clientes de paises fuera de la UE requieren Pasaporte obligatorio.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL;
END;
/





-- 1.2. Validacion de Juguetes (Set vs Piezas)
-- Regla: Si es SET, piezas NULL. Si no es SET, piezas NOT NULL.
CREATE OR REPLACE TRIGGER trg_validar_tipo_juguete
BEFORE INSERT OR UPDATE ON JUGUETES
FOR EACH ROW
BEGIN
    -- Si "set" es verdadero
    IF :NEW."set" THEN 
        IF :NEW.piezas IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error: Un SET no debe tener cantidad de piezas definida.');
        END IF;
    END IF;

    -- Si "set" es falssso
    IF NOT :NEW."set" THEN
        IF :NEW.piezas IS NULL THEN
            RAISE_APPLICATION_ERROR(-20003, 'Error: Si el juguete no es un SET, debe especificar la cantidad de piezas.');
        END IF;
    END IF;
END;
/



-- 1.3. Validacion edad del visitante (Visitante y representante)
--Regla: Edad minima 12 años participantes.
CREATE OR REPLACE TRIGGER validar_edad_visitante 
BEFORE INSERT OR UPDATE ON VISITANTES_FANS
FOR EACH ROW
DECLARE
    visitante_menor_a_12 EXCEPTION;
    visitante_mayor_a_100 EXCEPTION;
    falta_representante EXCEPTION; 
    visit_mayor_con_rep EXCEPTION;
BEGIN
    --VALIDA DE EDAD MAXIMA
    IF edad(:NEW.f_nacim) > 100 THEN
        RAISE visitante_mayor_a_100;
    END IF;

    --VALIDA DE EDAD MINIMA
    IF edad(:NEW.f_nacim) < 12 THEN
        RAISE visitante_menor_a_12;
    END IF;

    --VALIDA DE REPRESENTANTE (12 a 17 años)
    -- Si la edad esta entre 12-17 y no tiene representante
    IF (edad(:NEW.f_nacim) BETWEEN 12 AND 17) AND (:NEW.id_repres IS NULL) THEN
        RAISE falta_representante;
    END IF;

    --VALIDA DE REPRESENTANTE (Mayores de 17)
    -- Si la edad es mayor a 17 Y tiene representante
    IF (edad(:NEW.f_nacim) > 17) AND (:NEW.id_repres IS NOT NULL) THEN
        RAISE visit_mayor_con_rep;
    END IF;

EXCEPTION 
    WHEN visitante_mayor_a_100 THEN
        RAISE_APPLICATION_ERROR(-20004,'No puede haber un visitante mayor a 100 años.');
    WHEN visitante_menor_a_12 THEN 
        RAISE_APPLICATION_ERROR(-20005,'No puede haber un visitante menor a 12 años.');
    WHEN falta_representante THEN
        RAISE_APPLICATION_ERROR(-20006,'No puede haber un visitante de 12 a 17 años sin representante.');
    WHEN visit_mayor_con_rep THEN
        RAISE_APPLICATION_ERROR(-20007,'Los visitantes mayores a 17 años no pueden tener representante.');
END;
/




-- 1.4. Validacion edad del cliente.
--Regla: Edad minima 21 años.
CREATE OR REPLACE TRIGGER validar_edad_cliente 
BEFORE INSERT OR UPDATE ON CLIENTES
FOR EACH ROW
DECLARE
    cliente_menor_de_edad EXCEPTION;
    cliente_mayor_a_100 EXCEPTION;
BEGIN
    --Valida de edad maxima
    IF edad(:NEW.f_nacim) > 100 THEN
        RAISE cliente_mayor_a_100;
    END IF;

    --Valida de edad minima
    IF edad(:NEW.f_nacim) < 21 THEN
        RAISE cliente_menor_de_edad;
    END IF;

EXCEPTION 
    WHEN cliente_mayor_a_100 THEN
        RAISE_APPLICATION_ERROR(-20008,'No puede haber un cliente mayor a 100 años.');
    WHEN cliente_menor_de_edad THEN 
        RAISE_APPLICATION_ERROR(-20009,'No puede haber un cliente menor a 21 años.');
END;
/


-- 1.6. Validacion fechas historial precios
-- Regla: La fecha fin de historico precio no puede ser menor a la fecha inicio.
CREATE OR REPLACE TRIGGER trg_historial_precios
BEFORE INSERT OR UPDATE ON HISTORICO_PRECIOS_JUGUETES
FOR EACH ROW
BEGIN
    IF :NEW.f_fin IS NOT NULL AND :NEW.f_fin < :NEW.f_inicio THEN
    RAISE_APPLICATION_ERROR(-20010, 'Error: La fecha fin no puede ser menor que la fecha inicio.');
    END IF;
END;
/




-- 1.7. Validacion cupos disponibles tour.
-- Regla: Verificar que en la inscripcion no se excedan los cupos disponibles para la fecha del tour.
CREATE OR REPLACE TRIGGER trg_cupos_disponibles
BEFORE INSERT ON DETALLES_INSCRITOS
FOR EACH ROW
DECLARE
    cant_insc_en_fecha NUMBER;
    capacidad_tour NUMBER;
    cant_cupos_disp NUMBER;
    fecha_insc DETALLES_INSCRITOS.fecha_inicio%TYPE;
BEGIN
    fecha_insc := :NEW.fecha_inicio;
    SELECT COUNT(fecha_inicio) INTO cant_insc_en_fecha
    FROM DETALLES_INSCRITOS WHERE fecha_inicio=fecha_insc;
    SELECT cupos INTO capacidad_tour FROM FECHAS_TOUR 
    WHERE f_inicio=fecha_insc;
    cant_cupos_disp := capacidad_tour - cant_insc_en_fecha;
    IF cant_cupos_disp <= 0 THEN 
    RAISE_APPLICATION_ERROR(-20011, 
        'Error: Exceso de cupos para la fecha ' || TO_CHAR(fecha_insc, 'DD-MON-YYYY') || 
        '- Cupos Maximos: ' || capacidad_tour || 
        '- Inscritos Actuales: ' || cant_insc_en_fecha);
    END IF;
END;
/


-- 1.8. Validacion limite catalogo online.
-- Regla: No exceder el limite de cantidad por catalogo online al insertar detalles de factura online.
CREATE OR REPLACE TRIGGER trg_limite_catalogo_online
BEFORE INSERT ON DETALLES_FACTURA_ONLINE
FOR EACH ROW
DECLARE
    v_limite NUMBER(5);
    v_cant_actual NUMBER(3) := 0;
    v_total_cant NUMBER(3);
BEGIN
    -- Obtiene limite del catalogo para este pais
    SELECT limite INTO v_limite
    FROM CATALOGOS_LEGO
    WHERE id_pais = :NEW.id_pais AND cod_juguete = :NEW.codigo;
    
    -- Suma las cantidades existentes en esta factura para este juguete
    SELECT COALESCE(SUM(cant_prod), 0) INTO v_cant_actual
    FROM DETALLES_FACTURA_ONLINE
    WHERE nro_fact = :NEW.nro_fact 
    AND codigo = :NEW.codigo 
    AND id_pais = :NEW.id_pais;
    
    v_total_cant := v_cant_actual + :NEW.cant_prod;
    
    IF v_total_cant > v_limite THEN
        RAISE_APPLICATION_ERROR(-20012, 
            'Excede limite catalogo: ' || v_total_cant || ' > ' || v_limite || 
            ' para codigo ' || :NEW.codigo || ' en pais ' || :NEW.id_pais);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20013, 'Producto no disponible en catalogo para pais ' || :NEW.id_pais);
END;
/


-- 1.9. Validacion lote en catalogo.
-- Regla: El lote que se quiere registrar pertenece a un juguete/set que esta disponible en el pais de la tienda.
CREATE OR REPLACE TRIGGER tgr_lote_en_catalogo 
BEFORE INSERT OR UPDATE OF cod_juguete ON LOTES_SET_TIENDA 
FOR EACH ROW 
DECLARE
    v_pais_tienda NUMBER(3);
    v_exist_catalogo BOOLEAN;
BEGIN  
    SELECT id_pais INTO v_pais_tienda FROM TIENDAS_LEGO WHERE id = :NEW.id_tienda;
    SELECT CASE WHEN EXISTS(
        SELECT * FROM CATALOGOS_LEGO 
        WHERE id_pais = v_pais_tienda AND cod_juguete = :NEW.cod_juguete) 
        THEN 0 ELSE 1 END
    INTO v_exist_catalogo;
    IF v_exist_catalogo THEN 
        RAISE_APPLICATION_ERROR(-20014, 'El lote que se quiere registrar pertenece a un juguete/set que no esta disponible en el pais de la tienda.');
    END IF;
END;
/






-- 1.10. Validar que la fecha_inicio de fecha tour no se pueda modificar.
-- Regla: fecha_inicio en FECHA_TOUR no puede cambiar
CREATE OR REPLACE TRIGGER trg_no_cambiar_f_inicio
BEFORE UPDATE OF f_inicio ON FECHAS_TOUR
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20015, 'Error: La fecha de inicio del tour no puede ser modificada.');
END;
/





-- 1.11. Validar que la fecha_inicio de fecha tour no pasada.
-- Regla: fecha_inicio debe ser actual o superior
CREATE OR REPLACE TRIGGER trg_no_insertar_fecha_pasada
BEFORE INSERT ON FECHAS_TOUR
FOR EACH ROW
BEGIN
    IF :NEW.f_inicio < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20016, 'Error: La fecha de inicio del tour no puede ser anterior a la fecha actual.');
    END IF;
END;
/




-- 1.12. Validar que no se genere una entrada en una inscripcion que no esta confirmada --
-- Regla: no se inserta fila en ENTRADAS si la status en inscripcion != PAGADO
CREATE OR REPLACE TRIGGER trg_entrada_solo_si_insc_conf
BEFORE INSERT ON ENTRADAS FOR EACH ROW
DECLARE
    status_insc INSCRIPCIONES_TOUR.status%TYPE;
BEGIN
    
END;
/






-- 1.13. Verifica que haya stock virtual disponible al comprar
-- Regla: No se puede comprar mas productos de los que hay disponibles
CREATE OR REPLACE TRIGGER TRG_VALIDAR_STOCK_DIARIO
BEFORE INSERT ON DETALLES_FACTURA_TIENDA
FOR EACH ROW
DECLARE
    v_stock_fisico  NUMBER;
    v_vendido_hoy   NUMBER;
    v_disponible    NUMBER;
BEGIN
    --Obteniene el stock fisico que marca la tabla
    SELECT cant_prod
    INTO v_stock_fisico
    FROM LOTES_SET_TIENDA
    WHERE cod_juguete = :NEW.codigo
      AND id_tienda = :NEW.id_tienda
      AND nro_lote = :NEW.nro_lote;

    --Calcula cuanto se ha vendido durante el dia
    v_vendido_hoy := FUNC_TOTAL_VENTAS_LOTE_DIA(:NEW.id_tienda, :NEW.codigo, :NEW.nro_lote);

    --Calcula disponibilidad real
    v_disponible := v_stock_fisico - v_vendido_hoy;

    --Validar si hay espacio para la nueva venta
    IF v_disponible < :NEW.cant_prod THEN
        RAISE_APPLICATION_ERROR(-20017, 
            'Stock Insuficiente (Calculo Diario). ' ||
            'Stock Inicial: ' || v_stock_fisico || 
            ', Vendido Hoy: ' || v_vendido_hoy || 
            ', Restante: ' || v_disponible || 
            '. Intentas comprar: ' || :NEW.cant_prod);
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20018, 'El lote o producto no existe en el inventario.');
END;
/


--1.14 Facturas no se pueden eliminar
-- facturas físicas
CREATE OR REPLACE TRIGGER trg_no_delete_fact_tienda
BEFORE DELETE ON FACTURAS_TIENDA
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20501, 'Las facturas físicas no se pueden eliminar');
END;
/

-- facturas online
CREATE OR REPLACE TRIGGER trg_no_delete_fact_online
BEFORE DELETE ON FACTURAS_ONLINE
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20502, 'Las facturas online no se pueden eliminar');
END;
/




























