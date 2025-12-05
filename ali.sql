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
