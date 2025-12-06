--Intento de archivo final
--Integracion de claves foraneas en las tablas

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

CREATE TABLE TIENDA_LEGO (
    id NUMBER(5) CONSTRAINT pk_tienda PRIMARY KEY, 
    nombre VARCHAR2(20) NOT NULL,       
    direccion VARCHAR2(150) NOT NULL,            
    id_pais NUMBER NOT NULL,
    id_estado NUMBER NOT NULL,
    id_ciudad NUMBER NOT NULL, 
    
    CONSTRAINT fk_tienda_ciudad FOREIGN KEY (id_pais, id_estado, id_ciudad) 
        REFERENCES CIUDAD(id_pais, id_estado, id)
);

CREATE TABLE HORARIO_ATENCION (
    id_tienda NUMBER(5) NOT NULL,          
    dia DATE NOT NULL,  
    hora_entr DATE NOT NULL,   
    hora_sal DATE NOT NULL,    

    CONSTRAINT fk_horario_tienda FOREIGN KEY (id_tienda) REFERENCES TIENDA_LEGO(id),
    CONSTRAINT pk_horarios PRIMARY KEY (id_tienda, dia),
    ------- re
    --CONSTRAINT chk_horario_dia CHECK ("ELLA ES ESE SUEÑO QUE TUVE DESPIERTO, UN RECUERDO LEVE, DE ESTO QUE SIENTO; UNA SACUDIDA, A MIS SALIDAS, LA CIMA DE UN BESO EN UN BRINCO SUICIDA.")
);

