--Script Inscripcion del Tour

--Muestra fecha para seleccionar una
Select * from V_FTOURDISPONIBLES;
VARIABLE f_touringresada VARCHAR2(20);
ACCEPT fecha_tour CHAR PROMPT 'Inserte fecha en la que quiere inscribir: '
EXEC :f_touringresada:= '&fecha_tour';
VARIABLE nrofactinsc NUMBER;
EXEC :nrofactinsc := nfacturatour.nextval;

--crea inscripcion pendiente
INSERT INTO INSCRIPCIONES_TOUR (f_inicio,nro_fact,f_emision,estado) VALUES(TO_DATE(:f_touringresada, 'DD/MM/YYYY'),:nrofactinsc,sysdate,'PENDIENTE');

--Muestra Clientes
PROMPT CLIENTES Y SUS REPRESENTADOS(SI LOS TIENEN):;
select * from V_VISITANTESCLIENTES;
PROMPT VISITANTES SIN REPRESENTANTE(JOVENES ADULTOS);
select * from V_VISITANTESSINREPRESE;


--Agrega Clientes a inscripcion
VARIABLE op VARCHAR2(2);
VARIABLE participante NUMBER;

ACCEPT opcion CHAR PROMPT 'Opción (C/V): '
EXEC :op := '&opcion';
ACCEPT id_participante NUMBER PROMPT 'Ingrese el ID del inscrito elegido: '
EXEC :participante := &id_participante;
BEGIN
    agregarparticipante(TO_DATE(:f_touringresada, 'DD/MM/YYYY'),:nrofactinsc,:op,:participante);
END;
/

ACCEPT opcion CHAR PROMPT 'Opción (C/V): '
EXEC :op := '&opcion';
ACCEPT id_participante NUMBER PROMPT 'Ingrese el ID del inscrito elegido: '
EXEC :participante := &id_participante;
BEGIN
    agregarparticipante(TO_DATE(:f_touringresada, 'DD/MM/YYYY'),:nrofactinsc,:op,:participante);
END;
/

--Para la confirmacion de la inscripcion
ACCEPT opcion CHAR PROMPT 'Confirmar Inscripcion? (S-SI/N-NO): '
EXEC :op := '&opcion';

BEGIN
    confirmacioninscripcion(TO_DATE(:f_touringresada, 'DD/MM/YYYY'),:nrofactinsc,:op);
END;
/