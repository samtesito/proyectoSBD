--Codigo de ali
--Creacion de tablas sin fk
CREATE TABLE PAISES (
    id NUMBER(3) CONSTRAINT pk_paises PRIMARY KEY,                   
    nombre VARCHAR2(30) NOT NULL,            
    gentilicio VARCHAR2(15) NOT NULL,        
    continente VARCHAR2(7) NOT NULL,         
    ue BOOLEAN NOT NULL,                     
    CONSTRAINT chk_pais_continente CHECK (continente IN('AFRICA', 'AMERICA', 'ASIA', 'EUROPA', 'OCEANIA'))
);

CREATE TABLE ESTADOS (            
    id NUMBER(5) NOT NULL,                  
    nombre VARCHAR2(35) NOT NULL     
);

CREATE TABLE CIUDADES (
    id NUMBER(8) NOT NULL,           
    nombre VARCHAR2(35) NOT NULL
);

CREATE TABLE CLIENTES (
    id_lego NUMBER(8) CONSTRAINT pk_clientes PRIMARY KEY,              
    prim_nom VARCHAR2(10) NOT NULL,       
    prim_ape VARCHAR2(10) NOT NULL,      
    seg_ape VARCHAR2(10) NOT NULL,     
    f_nacim DATE NOT NULL,           
    dni VARCHAR2(20) NOT NULL,       
    seg_nom VARCHAR2(10),               
    pasaporte VARCHAR2(20),
    f_venc_pasap DATE
);

CREATE TABLE TIENDAS_LEGO (
    id NUMBER(5) CONSTRAINT pk_tienda PRIMARY KEY, 
    nombre VARCHAR2(20) NOT NULL,       
    direccion VARCHAR2(150) NOT NULL
);

CREATE TABLE HORARIOS_ATENCION (        
    dia DATE NOT NULL,  
    hora_entr DATE NOT NULL,   
    hora_sal DATE NOT NULL
);

--Alteracion agregando fks

ALTER TABLE ESTADOS ADD(
    id_pais NUMBER(3) NOT NULL,                  
    CONSTRAINT fk_estado_pais FOREIGN KEY (id_pais) REFERENCES PAISES(id),
    CONSTRAINT pk_estado PRIMARY KEY (id_pais,id)
);

ALTER TABLE CIUDADES ADD(
    id_pais NUMBER(3) NOT NULL,  
    id_estado NUMBER(5) NOT NULL,             
    CONSTRAINT fk_ciudad_est FOREIGN KEY (id_pais, id_estado) REFERENCES ESTADOS(id_pais,id),
    CONSTRAINT pk_ciudad PRIMARY KEY (id_pais, id_estado, id) 
);

ALTER TABLE CLIENTES ADD(
    id_pais_resi NUMBER(3) NOT NULL,                           
    CONSTRAINT fk_cliente_pais FOREIGN KEY (id_pais_resi) REFERENCES PAISES(id)
);

ALTER TABLE TIENDAS_LEGO ADD(          
    id_pais NUMBER NOT NULL,
    id_estado NUMBER NOT NULL,
    id_ciudad NUMBER NOT NULL, 
    CONSTRAINT fk_tienda_ciudad FOREIGN KEY (id_pais, id_estado, id_ciudad) REFERENCES CIUDADES(id_pais, id_estado, id)
);

ALTER TABLE HORARIOS_ATENCION ADD(
    id_tienda NUMBER(5) NOT NULL,          
    CONSTRAINT fk_horario_tienda FOREIGN KEY (id_tienda) REFERENCES TIENDAS_LEGO(id),
    CONSTRAINT pk_horarios PRIMARY KEY (id_tienda, dia)
);


--Daniel
--Creacion de tablas

CREATE TABLE FACTURAS_TIENDA (
    nro_fact NUMBER(9) CONSTRAINT pk_fact PRIMARY KEY,
    f_emision DATE NOT NULL,
    total NUMBER(6, 2)
);
------VALIDAR EL TOTAL

CREATE TABLE VISITANTES_FANS (
    id_lego NUMBER(8) CONSTRAINT pk_visitante PRIMARY KEY,
    prim_nom VARCHAR2(10) NOT NULL,
    prim_ape VARCHAR2(10) NOT NULL,
    seg_ape VARCHAR2(10) NOT NULL,
    f_nacim DATE NOT NULL,
    dni NUMBER(10) NOT NULL,
    seg_nom VARCHAR2(10),
    f_venc_pasap DATE,
    pasaporte VARCHAR2(15)
);

CREATE TABLE TELEFONOS (
    cod_inter NUMBER(3) NOT NULL,
    cod_local NUMBER(4) NOT NULL,
    numero NUMBER(10) NOT NULL,
    tipo VARCHAR2(1) NOT NULL,
    CONSTRAINT pk_tlf PRIMARY KEY (cod_inter, cod_local, numero),
    CONSTRAINT chk_tipo_telefono CHECK (tipo IN ('F', 'M'))
);

CREATE TABLE FACTURAS_ONLINE (
    nro_fact NUMBER(8) CONSTRAINT pk_fact_onl PRIMARY KEY,
    f_emision DATE NOT NULL,
    ptos_generados NUMBER(3) NOT NULL,
    total NUMBER(6, 2) NOT NULL
);

CREATE TABLE FECHAS_TOUR(
    f_inicio DATE CONSTRAINT pk_fecha_tour PRIMARY KEY,
    costo NUMBER(8,2) NOT NULL,
    cupos NUMBER(3) NOT NULL ---- REVISAAAAAAR
);

CREATE TABLE INSCRIPCIONES_TOUR (
    nro_factura NUMBER(8) NOT NULL,
    f_emision DATE NOT NULL,
    estado VARCHAR2(10) NOT NULL,
    total NUMBER(7,2) NOT NULL,
    CONSTRAINT chk_statusinsc CHECK (estado IN ('PAGADO', 'PENDIENTE'))
);

--Alteraciones con fk

ALTER TABLE FACTURAS_TIENDA ADD(
    id_cliente NUMBER(8) NOT NULL,
    id_tienda NUMBER(5) NOT NULL,
    CONSTRAINT fk_facttnda_clien FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_lego),
    CONSTRAINT fk_facttnd_tnda FOREIGN KEY (id_tienda) REFERENCES TIENDAS_LEGO(id)
);
------VALIDAR EL TOTAL

ALTER TABLE VISITANTES_FANS ADD(
    id_pais NUMBER(3) NOT NULL,
    id_repres NUMBER(8),
    CONSTRAINT fk_visifan_pais FOREIGN KEY (id_pais) REFERENCES PAISES(id),
    CONSTRAINT fk_visifan_clien FOREIGN KEY (id_repres) REFERENCES CLIENTES(id_lego)
    --FOREIGN KEY (id_representante) REFERENCES DET_INSCRITOS(id_lego) -- En esta parte, supuse que la info se sacaba de DET_INSCRITOS
);

ALTER TABLE TELEFONOS ADD(
    id_cliente NUMBER(8),
    id_visitante NUMBER(8),
    id_tienda NUMBER(5),
    CONSTRAINT fk_tlf_clien FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_lego),
    CONSTRAINT fk_tlf_visi FOREIGN KEY (id_visitante) REFERENCES VISITANTES_FANS(id_lego),
    CONSTRAINT fk_tlf_tnda FOREIGN KEY (id_tienda) REFERENCES TIENDAS_LEGO(id),
    CONSTRAINT chk_arco_exclusivo CHECK (
        (id_cliente IS NOT NULL AND id_visitante IS NULL AND id_tienda IS NULL) OR
        (id_cliente IS NULL AND id_visitante IS NOT NULL AND id_tienda IS NULL) OR
        (id_cliente IS NULL AND id_visitante IS NULL AND id_tienda IS NOT NULL)
    )
);

ALTER TABLE FACTURAS_ONLINE ADD(
    id_cliente NUMBER(8) NOT NULL,
    CONSTRAINT fk_factonl_clien FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_lego)
);

ALTER TABLE INSCRIPCIONES_TOUR ADD(
    f_inicio DATE NOT NULL,
    CONSTRAINT fk_insctour_ftour FOREIGN KEY (f_inicio) REFERENCES FECHAS_TOUR(f_inicio),
    PRIMARY KEY (f_inicio, nro_factura)
);


--SAMUEL
--Tablas creacion
CREATE TABLE ENTRADAS (
    nro NUMBER(8) NOT NULL CONSTRAINT pk_entradas PRIMARY KEY,
    tipo VARCHAR2(1) NOT NULL,
    CONSTRAINT chk_tipentradas CHECK(tipo IN('M','A'))
);

CREATE TABLE TEMAS(
    id NUMBER(5) CONSTRAINT pk_temas PRIMARY KEY,
    nombre VARCHAR2(20) NOT NULL,
    tipo VARCHAR2(1) NOT NULL,
    descripcion VARCHAR2(150) NOT NULL,
    CONSTRAINT chk_tipotemas CHECK(tipo in('L','O'))
);

CREATE TABLE JUGUETES (
    codigo NUMBER(5) CONSTRAINT pk_juguetes PRIMARY KEY,
    nombre VARCHAR2(20) NOT NULL,
    descripcion VARCHAR2(150) NOT NULL,
    rgo_edad NOT NULL CHECK('AAAAAAAAAAAAAAAAAA'),
    rgo_precio NOT NULL CHECK('BBBBBBBBBBBBBBBB'),
    tipo_lego NOT NULL CHECK('A','AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
    "set" BOOLEAN NOT NULL,
    instruc VARCHAR2(200),
    piezas NUMBER(6)
);

CREATE TABLE PRODUCTOS_RELACIONADOS (
    id_producto NUMBER(5) NOT NULL,
    id_prod_relaci NUMBER(5) NOT NULL
);

CREATE TABLE HISTORICO_PRECIO_SET_LEGO (
    f_inicio DATE CONSTRAINT pk_f_inicio PRIMARY KEY,
    precio NUMBER(5,2),
    f_fin DATE
);

CREATE TABLE CATALOGOS_LEGO (
    limite NUMBER(5) NOT NULL
);
