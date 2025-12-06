--################################## VAINAS ALÍ ###################################

-- 1. Tabla PAIS
CREATE TABLE PAIS (
    id NUMBER PRIMARY KEY,                   -- #*id (NUMBER)
    nombre VARCHAR2(50) NOT NULL,            -- *nombre (VARCHAR2)
    gentilicio VARCHAR2(50) NOT NULL,        -- *gentilicio
    continente VARCHAR2(9) NOT NULL,         -- *continente
    ue CHAR(1) NOT NULL,                     -- *UE

    -- Restricción CHECK para los continentes válidos
    CONSTRAINT chk_pais_continente CHECK (
        continente IN (
            'Africa', 
            'America', 
            'Asia', 
            'Europa', 
            'Oceania', 
            'Antartida'
        )
    ),
    -- Restricción CHECK para simular el booleano 'ue' ('S'/'N')
    CONSTRAINT chk_pais_ue CHECK (ue IN ('S', 'N'))
);


-- 2. Tabla ESTADO
-- Depende de PAÍS.
CREATE TABLE ESTADO (
    id_pais NUMBER NOT NULL,             -- PK de PAIS (FK)
    id NUMBER NOT NULL,                  -- #*id (PK)
    nombre VARCHAR2(50) NOT NULL,        -- *nombre

    -- La clave primaria es compuesta: (id, id_pais)
    PRIMARY KEY (id, id_pais),

    -- FK que referencia a PAIS
    CONSTRAINT fk_estado_pais FOREIGN KEY (id_pais) REFERENCES PAIS(id)
);


-- 3. Tabla CIUDAD
-- Depende de ESTADO que a su vez depende de PAÍS.
CREATE TABLE CIUDAD (
    -- Componentes heredados del PK de ESTADO (FK)
    id_pais NUMBER NOT NULL,            -- PK de PAÍS
    id_estado NUMBER NOT NULL,          -- PK de ESTADO

    id NUMBER NOT NULL,                 -- #*id (PK de CIUDAD)
    nombre VARCHAR2(50) NOT NULL,       -- *nombre
    
    -- La clave primaria de Ciudad es compuesta: (id_pais, id_estado, id)
    PRIMARY KEY (id_pais, id_estado, id), 

    -- Clave Foránea que referencia a la clave compuesta de ESTADO
    CONSTRAINT fk_ciudad_estado FOREIGN KEY (id_pais, id_estado) 
        REFERENCES ESTADO(id_pais, id)
);


-- 4. Tabla CLIENTE
CREATE TABLE CLIENTE (
    id_lego NUMBER PRIMARY KEY,                 -- #*id lego
    primer_nombre VARCHAR2(50) NOT NULL,        -- *primer nombre
    primer_apellido VARCHAR2(50) NOT NULL,      -- *primer apellido
    segundo_apellido VARCHAR2(50) NOT NULL,     -- *segundo apellido
    fecha_nacimiento DATE NOT NULL,             -- *fecha de nacimiento
    dni VARCHAR2(20) NOT NULL UNIQUE,           -- *dni

    -- Componentes heredados del PK de Pais (Clave Foránea)
    id_pais_residencia NUMBER NOT NULL,         -- Relación "lugar de residencia"

    segundo_nombre VARCHAR2(50),                -- O segundo nombre (Opcional)
    f_venc_pasaporte DATE,                      -- O f. venc. de pasaporte (Opcional)
    pasaporte VARCHAR2(20),                     -- O pasaporte (Opcional)

    CONSTRAINT fk_cliente_pais FOREIGN KEY (id_pais_residencia) REFERENCES PAIS(id)
);


-- 5. Tabla TIENDA_LEGO
CREATE TABLE TIENDA_LEGO (
    id NUMBER PRIMARY KEY,              -- #*id
    nombre VARCHAR2(50) NOT NULL,       -- *nombre
    calle_av VARCHAR2(100) NOT NULL,    -- *calle/av
    
    -- Componentes heredados del PK de CIUDAD (Clave Foránea)
    id_ciudad NUMBER NOT NULL,          
    id_estado NUMBER NOT NULL,
    id_pais NUMBER NOT NULL,
    
    -- Referencia a la clave compuesta de CIUDAD.
    CONSTRAINT fk_tienda_ciudad FOREIGN KEY (id_pais, id_estado, id_ciudad) 
        REFERENCES CIUDAD(id_pais, id_estado, id)
);


-- 6. Tabla HORARIO_ATENCION
-- Depende de TIENDA_LEGO.
CREATE TABLE HORARIO_ATENCION (
    id_tienda NUMBER NOT NULL,          -- PK de TIENDA_LEGO (FK)
    dia_inicio VARCHAR2(10) NOT NULL,   -- #*dia inicio
    hora_entrada DATE NOT NULL,         -- *hora de entrada
    hora_salida DATE NOT NULL,          -- *hora de salida

    -- La clave primaria de HORARIO_ATENCION es compuesta: (id_tienda, dia_inicio)
    PRIMARY KEY (id_tienda, dia_inicio),

    -- FK que referencia a la PK de TIENDA_LEGO
    CONSTRAINT fk_horario_tienda FOREIGN KEY (id_tienda) REFERENCES TIENDA_LEGO(id),

    -- Restricción CHECK para los dias válidos
    CONSTRAINT chk_horario_dia CHECK (
        dia_inicio IN (
            'Lunes', 
            'Martes', 
            'Miercoles', 
            'Jueves', 
            'Viernes', 
            'Sabado', 
            'Domingo'
        )
    )
);





--################################# VAINAS DE SAMUEL #########################################

CREATE TABLE PAISES
    (id NUMBER(3) CONSTRAINT pk_paises PRIMARY KEY,
    nombre VARCHAR2(15) NOT NULL,
    gentilicio VARCHAR2(10) NOT NULL,
    continente VARCHAR2(7) NOT NULL CHECK('AMERICA', 'ASIA', 'AFRICA', 'OCEANIA', 'EUROPA'),
    ue BOOLEAN NOT NULL);

CREATE TABLE ESTADOS
    (id NUMBER(5) NOT NULL,
    nombre VARCHAR2(20) NOT NULL);

CREATE TABLE CIUDADES
    (id NUMBER(8) NOT NULL,
    nombre VARCHAR2(20) NOT NULL);

CREATE TABLE CLIENTES 
    (id_LEGO NUMBER(8) CONSTRAINT pk_clientes PRIMARY KEY,
    prim_nom VARCHAR2(10) NOT NULL,
    prim_ape VARCHAR2(10) NOT NULL,
    seg_ape VARCHAR2(10) NOT NULL,
    f_nacim DATE NOT NULL,
    dni NUMBER(10) NOT NULL,
    seg_nom VARCHAR2(10),
    f_vence_pasap DATE,
    pasaporte VARCHAR2(12));

CREATE TABLE TIENDAS_LEGO 
    (id NUMBER(8) CONSTRAINT pk_tiendas PRIMARY KEY,
    nombre VARCHAR2(15) NOT NULL,
    direccion VARCHAR2(150) NOT NULL);

CREATE TABLE HORARIOS_ATENCION
    (dia DATE CONSTRAINT pk_horarios PRIMARY KEY,
    hora_entr DATE NOT NULL,
    hora_sal DATE NOT NULL); 

CREATE TABLE FACTURAS_TIENDA
    (nro_fact NUMBER(9) CONSTRAINT pk_fact PRIMARY KEY,
    f_emision DATE NOT NULL,
    total NUMBER(10));

CREATE TABLE FACTURAS_ONLINE
    (nro_fact NUMBER(9) CONSTRAINT pk_fact PRIMARY KEY,
    f_emision DATE NOT NULL,
    pts_gener NUMBER(5),
    total NUMBER(10)); 
