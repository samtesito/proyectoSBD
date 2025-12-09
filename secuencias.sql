-- Secuencias para los IDs de facturas
CREATE SEQUENCE SEQ_FACTURA_TIENDA START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_FACTURA_ONLINE START WITH 1 INCREMENT BY 1;

-- Tipos para manejar listas de productos y cantidades
-- (Si ya existen en la BD, omite esta parte)
CREATE OR REPLACE TYPE t_lista_numeros AS TABLE OF NUMBER;
/

-- Secuencia para el ID de la inscripcion (Cabecera)
CREATE SEQUENCE SEQ_INSCRIPCION START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE SEQ_INSCRIPCION_FACT START WITH 1 INCREMENT BY 1;