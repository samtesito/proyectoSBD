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
    CONSTRAINT fk_cliente_pais FOREIGN KEY (id_pais_resi) REFERENCES PAISES(id)
);

CREATE TABLE TIENDAS_LEGO (
    id NUMBER(5) CONSTRAINT pk_tienda PRIMARY KEY, 
    nombre VARCHAR2(20) NOT NULL,       
    direccion VARCHAR2(150) NOT NULL,            
    id_pais NUMBER NOT NULL,
    id_estado NUMBER NOT NULL,
    id_ciudad NUMBER NOT NULL, 
    CONSTRAINT fk_tienda_ciudad FOREIGN KEY (id_pais, id_estado, id_ciudad) REFERENCES CIUDADES(id_pais, id_estado, id)
);

CREATE TABLE HORARIOS_ATENCION (
    id_tienda NUMBER(5) NOT NULL,          
    dia DATE NOT NULL,  
    hora_entr DATE NOT NULL,   
    hora_sal DATE NOT NULL,    
    CONSTRAINT fk_horario_tienda FOREIGN KEY (id_tienda) REFERENCES TIENDAS_LEGO(id),
    CONSTRAINT pk_horarios PRIMARY KEY (id_tienda, dia)
    ------- REVISAR
    --CONSTRAINT chk_horario_dia CHECK ("ELLA ES ESE SUEÑO QUE TUVE DESPIERTO, UN RECUERDO LEVE, DE ESTO QUE SIENTO; UNA SACUDIDA, A MIS SALIDAS, LA CIMA DE UN BESO EN UN BRINCO SUICIDA.")
);

--------------------  TABLAS DE DANIEL ----------------------

CREATE TABLE FACTURAS_TIENDA (
    nro_fact NUMBER(9) CONSTRAINT pk_fact PRIMARY KEY,
    id_cliente NUMBER(8) NOT NULL,
    id_tienda NUMBER(5) NOT NULL,
    f_emision DATE NOT NULL,
    total NUMBER(6, 2), 
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
    CONSTRAINT fk_visifan_clien FOREIGN KEY (id_repres) REFERENCES CLIENTES(id_lego)
    --FOREIGN KEY (id_representante) REFERENCES DET_INSCRITOS(id_lego) -- En esta parte, supuse que la info se sacaba de DET_INSCRITOS
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
    total NUMBER(6, 2) NOT NULL,
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
    total NUMBER(7,2) NOT NULL,
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
    nombre VARCHAR2(20) NOT NULL,
    descripcion VARCHAR2(150) NOT NULL,
    id_tema NUMBER(5) NOT NULL,
    rgo_edad VARCHAR2(3) NOT NULL,
    rgo_precio VARCHAR2(1) NOT NULL,
    tipo_lego VARCHAR2(1) NOT NULL,
    "set" BOOLEAN NOT NULL,
    instruc VARCHAR2(200),
    piezas NUMBER(6),
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
    codigo NUMBER(8) NOT NULL,
    id_tienda NUMBER(8) NOT NULL,
    nro_lote NUMBER(3) NOT NULL,
    f_adqui DATE NOT NULL,
    cant_prod NUMBER(3) NOT NULL,
    CONSTRAINT fk_lottienda_codjug FOREIGN KEY (codigo) REFERENCES JUGUETES(codigo),
    CONSTRAINT fk_lottienda_tnda FOREIGN KEY (id_tienda) REFERENCES TIENDAS_LEGO(id),
    CONSTRAINT pk_lotes PRIMARY KEY (codigo,id_tienda,nro_lote)
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
    CONSTRAINT fk_detfacttnda_lote FOREIGN KEY (codigo,id_tienda,nro_lote) REFERENCES LOTES_SET_TIENDA(codigo,id_tienda,nro_lote),
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
    CONSTRAINT fk_desc_lote FOREIGN KEY (codigo,id_tienda,nro_lote) REFERENCES LOTES_SET_TIENDA (codigo,id_tienda,nro_lote),
    CONSTRAINT pk_iddesc PRIMARY KEY(codigo,id_tienda,nro_lote,id_desc)
);
