--Tablas Violeta
--CREACION
CREATE TABLE DETALLES_INSCRITOS(
    id_det_insc NUMBER(8) NOT NULL
);

CREATE TABLE DETALLES_FACTURA_ONLINE(
    id_det_fact NUMBER(8) NOT NULL,
    cant_prod NUMBER(3) NOT NULL,
    tipo_cli VARCHAR2(1) NOT NULL,
    codigo NUMBER(8) NOT NULL,
    id_pais NUMBER(3) NOT NULL, 
    CONSTRAINT tipo_cliente CHECK (tipo_cli in('M','A'))
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
    codigo NUMBER(8) NOT NULL,
    id_tienda NUMBER(8) NOT NULL,
    nro_lote NUMBER(3) NOT NULL,
    CONSTRAINT tipo_cliente CHECK (tipo_cli in('M','A'))
);

--M: MENOR, A:ADULTO

CREATE TABLE DESCUENTO(
    id_desc NUMBER(8) NOT NULL,
    fecha DATE NOT NULL,
    cant NUMBER(2) NOT NULL
);

--ALTERACIONES CON CLAVES FORANEAS
ALTER TABLE DETALLES_INSCRITOS add(
    fecha_inicio DATE NOT NULL,
    nro_factura NUMBER(6) NOT NULL,
    CONSTRAINT fk_finicio FOREIGN KEY (fecha_inicio) 
    REFERENCES FECHAS_TOUR (fecha_inicio),
    CONSTRAINT fk_nrofactura FOREIGN KEY (nro_factura)
    REFERENCES INSCRIPCIONES_TOUR (nro_factura),
    CONSTRAINT pk_detinscritos PRIMARY KEY (fecha_inicio,nro_factura,id_det_inscritos)
);

ALTER TABLE DETALLES_FACTURA_ONLINE add(
    nro_fact NUMBER(6) NOT NULL,
    CONSTRAINT fk_nfact FOREIGN KEY (nro_fact)
    REFERENCES FACTURAS_ONLINE (nro_fact)
    CONSTRAINT pk_detfactonl PRIMARY KEY (nro_fact,id_det_fact)
);

ALTER TABLE LOTES_SET_TIENDA add(
    codigo NUMBER(8) NOT NULL,
    id_tienda NUMBER(8) NOT NULL,
    CONSTRAINT fk_codjug FOREIGN KEY (codigo)
    REFERENCES JUGUETES(codigo)
    CONSTRAINT fk_idtnda FOREIGN KEY (id_tienda)
    REFERENCES TIENDAS_LEGO(id)
    CONSTRAINT pk_lotes(codigo,id_tienda,nrolote)
);

ALTER TABLE DETALLES_FACTURA_TIENDA add(
    nro_fact NUMBER(6) NOT NULL,
    CONSTRAINT fk_nfact FOREIGN KEY (nro_fact)
    REFERENCES FACTURAS_TIENDA (nro_fact)
    CONSTRAINT pk_detfacttnda PRIMARY KEY (nro_fact,id_det_fact)
);

ALTER TABLE DESCUENTO add(
    codigo NUMBER(8) NOT NULL,
    id_tienda NUMBER(8) NOT NULL,
    nro_lote NUMBER(3) NOT NULL,
    CONSTRAINT fk_codigo FOREIGN KEY (codigo)
    REFERENCES JUGUETES(codigo)
    CONSTRAINT fk_idtnda FOREIGN KEY (id_tienda)
    REFERENCES TIENDAS_LEGO(id)
    CONSTRAINT fk_codigo FOREIGN KEY (nro_lote)
    REFERENCES LOTES_SET_TIENDA(nro_lote)
    CONSTRAINT pk_iddesc PRIMARY KEY(codigo,id_tienda,nro_lote,id_desc)
);


