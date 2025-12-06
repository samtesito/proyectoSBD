-- Factura
CREATE TABLE FACTURAS_TIENDA (
    nro_fact NUMBER PRIMARY KEY,
    id_cliente NUMBER NOT NULL,
    id_tienda NUMBER NOT NULL,
    fecha_emision DATE NOT NULL,
    total NUMBER(10, 2) NOT NULL, --Esto creo que debe calcularse en la tabla de detalle factura
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_lego),
    FOREIGN KEY (id_tienda) REFERENCES TIENDA_LEGO(id),
    CONSTRAINT chk_total_factura CHECK (total >= 0)
);

-- Visitantes_Fans
CREATE TABLE VISITANTES_FANS (
    id_lego NUMBER PRIMARY KEY,
    primer_nombre VARCHAR2(10) NOT NULL,
    primer_apellido VARCHAR2(10) NOT NULL,
    segundo_apellido VARCHAR2(10) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    dni NUMBER UNIQUE NOT NULL,
    id_pais NUMBER NOT NULL,
    id_representante NUMBER,
    segundo_nombre VARCHAR2(10),
    fecha_vencimiento_pasaporte DATE,
    pasaporte VARCHAR2(15) UNIQUE,
    FOREIGN KEY (id_pais) REFERENCES PAIS(id),
    FOREIGN KEY (id_representante) REFERENCES DET_INSCRITOS(id_lego) -- En esta parte, supuse que la info se sacaba de DET_INSCRITOS
);

-- TELEFONOS
CREATE TABLE TELEFONOS (
    cod_internacional NUMBER NOT NULL,
    cod_local NUMBER NOT NULL,
    numero NUMBER NOT NULL,
    tipo VARCHAR2(1) NOT NULL,
    id_cliente NUMBER,
    id_visitante NUMBER,
    id_tienda NUMBER,
    PRIMARY KEY (cod_internacional, cod_local, numero),
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_lego),
    FOREIGN KEY (id_visitante) REFERENCES VISITANTES_FANS(id_lego),
    FOREIGN KEY (id_tienda) REFERENCES TIENDA_LEGO(id),
    CONSTRAINT chk_arco_exclusivo CHECK (
        (id_cliente IS NOT NULL AND id_visitante IS NULL AND id_tienda IS NULL) OR
        (id_cliente IS NULL AND id_visitante IS NOT NULL AND id_tienda IS NULL) OR
        (id_cliente IS NULL AND id_visitante IS NULL AND id_tienda IS NOT NULL)
    ), -- Según lo que investigue, esto es lo de check de tablas
    CONSTRAINT chk_tipo_telefono CHECK (tipo IN ('F', 'M'))
);

-- Facturas_Online
CREATE TABLE FACTURAS_ONLINE (
    nro_fact NUMBER PRIMARY KEY,
    fecha_emision DATE NOT NULL,
    id_cliente NUMBER NOT NULL,
    ptos_generados NUMBER NOT NULL,
    total NUMBER(10, 2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_lego),
    CONSTRAINT chk_total_factura_online CHECK (total >= 0)
);

-- Fechas_Tour
CREATE TABLE FECHAS_TOUR(
    fecha_inicio DATE PRIMARY KEY,
    costo NUMBER(10,2) NOT NULL,
    cupos NUMBER NOT NULL
);

-- INSCRIPCIONES_TOUR
CREATE TABLE INSCRIPCIONES_TOUR (
    fecha_inicio DATE NOT NULL,
    nro_factura NUMBER NOT NULL,
    fecha_emision DATE NOT NULL,
    status VARCHAR2(10) NOT NULL,
    total NUMBER(10,2) NOT NULL,
    PRIMARY KEY (fecha_inicio, nro_factura),
    FOREIGN KEY (fecha_inicio) REFERENCES FECHAS_TOUR(fecha_inicio),
    CONSTRAINT chk_status_inscripcion CHECK (status IN ('PAGADO', 'PENDIENTE'))
);