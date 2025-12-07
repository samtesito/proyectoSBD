--------------------  TABLAS DE ALI  ----------------------

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

--------------------  TABLAS DE DANIEL ----------------------

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

--------------------  TABLAS DE SAMUEL ----------------------

ALTER TABLE ENTRADAS ADD (
    f_inicio DATE NOT NULL,
    nro_fact NUMBER(8) NOT NULL,
    CONSTRAINT fk_entrada_inscripcion FOREIGN KEY (f_inicio, nro_fact) REFERENCES INSCRIPCIONES_TOUR(f_inicio, nro_factura),
    CONSTRAINT pk_entrada PRIMARY KEY (f_inicio, nro_fact, nro)
);

ALTER TABLE TEMAS ADD (
    id_tema_padre NUMBER(5),
    CONSTRAINT fk_tema_temapadr FOREIGN KEY (id_tema_padre) REFERENCES TEMAS(id)
);

ALTER TABLE JUGUETES ADD (
    id_tema NUMBER(5) NOT NULL,
    CONSTRAINT fk_juguete_tema FOREIGN KEY (id_tema) REFERENCES TEMAS(id),
);

ALTER TABLE PRODUCTOS_RELACIONADOS ADD (
    CONSTRAINT fk_prodrela_producto FOREIGN KEY (id_producto) REFERENCES JUGUETES(codigo),
    CONSTRAINT fk_prodrela_productorelacion FOREIGN KEY (id_prod_relaci) REFERENCES JUGUETES(codigo),
    CONSTRAINT pk_productos_relacionados PRIMARY KEY (id_producto, id_prod_relaci)
);

ALTER TABLE HISTORICO_PRECIOS_JUGUETES ADD (
    cod_juguete NUMBER(5) NOT NULL,
    CONSTRAINT fk_histprecio_juguete FOREIGN KEY (cod_juguete) REFERENCES JUGUETES(codigo)
);

ALTER TABLE CATALOGOS_LEGO ADD (
    id_pais NUMBER(3) NOT NULL,
    cod_juguete NUMBER(5) NOT NULL,
    CONSTRAINT fk_catalogo_pais FOREIGN KEY (id_pais) REFERENCES PAISES(id),
    CONSTRAINT fk_catalogo_juguete FOREIGN KEY (cod_juguete) REFERENCES JUGUETES(codigo),
    CONSTRAINT pk_catalogo PRIMARY KEY (id_pais, cod_juguete)
);

--------------------  TABLAS DE VIOLETA ----------------------

ALTER TABLE DETALLES_INSCRITOS add(
    fecha_inicio DATE NOT NULL,
    nro_factura NUMBER(6) NOT NULL,
    id_cliente NUMBER(8),
    id_visit NUMBER(8),
    CONSTRAINT fk_detinsc_inscripcion FOREIGN KEY (fecha_inicio, nro_factura) REFERENCES INSCRIPCIONES_TOUR(f_inicio,nro_factura),
    CONSTRAINT pk_detinscritos PRIMARY KEY (fecha_inicio,nro_factura,id_det_insc),
    CONSTRAINT fk_detinsc_clien FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_lego),
    CONSTRAINT fk_detinsc_visi FOREIGN KEY (id_visit) REFERENCES VISITANTES_FANS(id_lego),
    CONSTRAINT chk_arcexcldetinsc CHECK (
        (id_cliente IS NOT NULL AND id_visit IS NULL) OR
        (id_cliente IS NULL AND id_visit IS NOT NULL))
);

ALTER TABLE DETALLES_FACTURA_ONLINE add(
    nro_fact NUMBER(6) NOT NULL,
    codigo NUMBER(8) NOT NULL,
    id_pais NUMBER(3) NOT NULL, 
    CONSTRAINT fk_detfactonl_factonl FOREIGN KEY (nro_fact) REFERENCES FACTURAS_ONLINE (nro_fact),
    CONSTRAINT pk_detfactonl PRIMARY KEY (nro_fact,id_det_fact),
    CONSTRAINT fk_detfactonl_catalogo FOREIGN KEY (codigo,id_pais) REFERENCES CATALOGOS_LEGO(cod_juguete,id_pais)
);

ALTER TABLE LOTES_SET_TIENDA add(
    codigo NUMBER(8) NOT NULL,
    id_tienda NUMBER(8) NOT NULL,
    CONSTRAINT fk_lottienda_codjug FOREIGN KEY (codigo) REFERENCES JUGUETES(codigo),
    CONSTRAINT fk_lottienda_tnda FOREIGN KEY (id_tienda) REFERENCES TIENDAS_LEGO(id),
    CONSTRAINT pk_lotes PRIMARY KEY (codigo,id_tienda,nro_lote)
);

ALTER TABLE DETALLES_FACTURA_TIENDA add(
    nro_fact NUMBER(6) NOT NULL,
    codigo NUMBER(8) NOT NULL,
    id_tienda NUMBER(8) NOT NULL,
    nro_lote NUMBER(3) NOT NULL,
    CONSTRAINT fk_detfacttnda_facttnda FOREIGN KEY (nro_fact) REFERENCES FACTURAS_TIENDA (nro_fact),
    CONSTRAINT fk_detfacttnda_lote FOREIGN KEY (codigo,id_tienda,nro_lote) REFERENCES LOTES_SET_TIENDA(codigo,id_tienda,nro_lote),
    CONSTRAINT pk_detfacttnda PRIMARY KEY (nro_fact,id_det_fact)
);

ALTER TABLE DESCUENTO add(
    codigo NUMBER(8) NOT NULL,
    id_tienda NUMBER(8) NOT NULL,
    nro_lote NUMBER(3) NOT NULL,
    CONSTRAINT fk_desc_lote FOREIGN KEY (codigo,id_tienda,nro_lote) REFERENCES LOTES_SET_TIENDA (codigo,id_tienda,nro_lote),
    CONSTRAINT pk_iddesc PRIMARY KEY(codigo,id_tienda,nro_lote,id_desc)
);