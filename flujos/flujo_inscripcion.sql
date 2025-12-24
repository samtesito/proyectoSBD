select * from V_FTOURDISPONIBLES;
VARIABLE f_touringresada VARCHAR2(20);
ACCEPT fecha_tour CHAR PROMPT 'Inserte fecha en la que quiere inscribir: '
EXEC :f_touringresada:= '&fecha_tour';
INSERT INTO INSCRIPCIONES_TOUR (f_inicio,nro_fact,f_emision,estado) VALUES(TO_DATE(:f_touringresada, 'DD/MM/YYYY'),nfacturatour.nextval,sysdate,'PENDIENTE');
