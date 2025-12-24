--1) Vista de Tours Disponibles
CREATE VIEW V_FTOURDISPONIBLES(fecha_inicio, precio_entrada) 
AS SELECT f.f_inicio, f.costo FROM FECHAS_TOUR f 
WHERE f.f_inicio >= SYSDATE;