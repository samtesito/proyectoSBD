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

--------------------  TABLAS DE DANIEL ----------------------

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

--------------------  TABLAS DE SAMUEL ----------------------

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

CREATE TABLE HISTORICO_PRECIOS_JUGUETES (
    f_inicio DATE CONSTRAINT pk_f_inicio PRIMARY KEY,
    precio NUMBER(5,2),
    f_fin DATE
);

CREATE TABLE CATALOGOS_LEGO (
    limite NUMBER(5) NOT NULL
);

--------------------  TABLAS DE VIOLETA ----------------------

CREATE TABLE DETALLES_INSCRITOS(
    id_det_insc NUMBER(8) NOT NULL
);

CREATE TABLE DETALLES_FACTURA_ONLINE(
    id_det_fact NUMBER(8) NOT NULL,
    cant_prod NUMBER(3) NOT NULL,
    tipo_cli VARCHAR2(1) NOT NULL,
    CONSTRAINT tipo_clientefo CHECK (tipo_cli in('M','A'))
);

CREATE TABLE LOTES_SET_TIENDA(
    nro_lote NUMBER(3) NOT NULL,
    f_adqui DATE NOT NULL,
    cant_prod NUMBER(3) NOT NULL
);

CREATE TABLE DETALLES_FACTURA_TIENDA(
    id_det_fact NUMBER(8) NOT NULL,
    cant_prod NUMBER(3) NOT NULL,
    tipo_cli VARCHAR2(1) NOT NULL,
    CONSTRAINT tipo_clienteft CHECK (tipo_cli in('M','A'))
);

--M: MENOR, A:ADULTO

CREATE TABLE DESCUENTO(
    id_desc NUMBER(8) NOT NULL,
    fecha DATE NOT NULL,
    cant NUMBER(2) NOT NULL
);