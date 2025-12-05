-- 1. Tabla PAIS
CREATE TABLE PAIS (
    id INT PRIMARY KEY,               -- #*id
    nombre VARCHAR(50) NOT NULL,      -- *nombre
    gentilicio VARCHAR(50) NOT NULL,  -- *gentilicio
    continente VARCHAR(9) NOT NULL,  -- *continente
    ue BOOLEAN NOT NULL,              -- *UE

    -- Restricción CHECK para los continentes válidos
    CONSTRAINT check_continente CHECK (
        continente IN (
            'Africa', 
            'America', 
            'Asia', 
            'Europa', 
            'Oceania', 
            'Antartida'
        )
    )
);




-- 2. Tabla ESTADO
-- Depende de PAÍS.
CREATE TABLE ESTADO (
    id_pais INT NOT NULL,             -- PK de PAIS (Clave Foránea)
    id INT NOT NULL,                  -- #*id (PK)
    nombre VARCHAR(50) NOT NULL,      -- *nombre

    -- La clave primaria es compuesta: (id, id_pais)
    PRIMARY KEY (id, id_pais),

    -- FK que referencia a PAIS
    CONSTRAINT fk_estado_pais FOREIGN KEY (id_pais) REFERENCES PAIS(id)
);




-- 3. Tabla CIUDAD
-- Depende de ESTADO que a su vez depende de PAÍS.
CREATE TABLE CIUDAD (
    -- Componentes heredados del PK de ESTADO (Clave Foránea)
    id_pais INT NOT NULL,            -- PK de PAÍS
    id_estado INT NOT NULL,          -- PK de ESTADO

    id INT NOT NULL,                 -- #*id (PK de CIUDAD)
    nombre VARCHAR(50) NOT NULL,     -- *nombre
    
    -- La clave primaria de Ciudad es compuesta: (id, id_pais, id_estado)
    PRIMARY KEY (id, id_pais, id_estado),

    -- Clave Foránea que referencia a la clave compuesta de ESTADO
    CONSTRAINT fk_ciudad_estado FOREIGN KEY (id_pais, id_estado) 
        REFERENCES ESTADO(id_pais, id)
);





-- 4. Tabla CLIENTE
CREATE TABLE CLIENTE (
    id_lego INT PRIMARY KEY,                  -- #*id lego
    primer_nombre VARCHAR(50) NOT NULL,       -- *primer nombre
    primer_apellido VARCHAR(50) NOT NULL,     -- *primer apellido
    segundo_apellido VARCHAR(50) NOT NULL,    -- *segundo apellido
    fecha_nacimiento DATE NOT NULL,           -- *fecha de nacimiento
    dni VARCHAR(20) NOT NULL UNIQUE,          -- *dni

    -- Componentes heredados del PK de Pais (Clave Foránea)
    id_pais_residencia INT NOT NULL,          -- Relación "lugar de residencia"

    segundo_nombre VARCHAR(50),               -- O segundo nombre (Opcional)
    f_venc_pasaporte DATE,                    -- O f. venc. de pasaporte (Opcional)
    pasaporte VARCHAR(20),                    -- O pasaporte (Opcional)

    CONSTRAINT fk_cliente_pais FOREIGN KEY (id_pais_residencia) REFERENCES PAIS(id)
);





-- 5. Tabla TIENDA_LEGO
CREATE TABLE TIENDA_LEGO (
    id INT PRIMARY KEY,              -- #*id
    nombre VARCHAR(50) NOT NULL,     -- *nombre
    calle_av VARCHAR(100) NOT NULL,  -- *calle/av
    
    -- Componentes heredados del PK de CIUDAD (Clave Foránea)
    id_ciudad INT NOT NULL,          -- Relación "se ubica" (toma la PK compuesta de CIUDAD)
    id_estado INT NOT NULL,
    id_pais INT NOT NULL,
    CONSTRAINT fk_tienda_ciudad FOREIGN KEY (id_pais, id_estado, id_ciudad) REFERENCES CIUDAD(id_pais, id_estado, id)
);







-- 6. Tabla HORARIO_ATENCION
-- Depende de TIENDA_LEGO.
CREATE TABLE HORARIO_ATENCION (
    id_tienda INT NOT NULL,          -- PK de TIENDA_LEGO (Clave Foránea)
    dia_inicio VARCHAR(10) NOT NULL, -- #*dia inicio
    hora_entrada DATE NOT NULL,      -- *hora de entrada
    hora_salida DATE NOT NULL,       -- *hora de salida

    -- La clave primaria de HORARIO_ATENCION es compuesta: (id_tienda, dia_inicio)
    PRIMARY KEY (id_tienda, dia_inicio),

    -- Clave Foránea que referencia a la clave compuesta de TIENDA_LEGO
    CONSTRAINT fk_horario_tienda FOREIGN KEY (id_tienda) REFERENCES TIENDA_LEGO(id)

    -- Restricción CHECK para los dias válidos
    CONSTRAINT check_dia_inicio CHECK (
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