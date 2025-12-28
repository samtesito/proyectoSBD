--1) Vista de Tours Disponibles
CREATE VIEW V_FTOURDISPONIBLES(fecha_inicio, precio_entrada) 
AS SELECT f.f_inicio, f.costo FROM FECHAS_TOUR f 
WHERE f.f_inicio >= SYSDATE;

--2) Vista de Clientes&visitantes 
CREATE VIEW V_VISITANTESCLIENTES(id_cliente,nombrecliente,apellidocliente, id_visitante,
nombrevisitante,apellidovisitante) AS SELECT c.id_lego, c.prim_nom, c.prim_ape, v.id_lego, 
v.prim_nom, v.prim_ape from CLIENTES c, VISITANTES_FANS v where c.id_lego = v.id_repres (+);

--3) Vista de visitantes sin representantes
CREATE VIEW V_VISITANTESSINREPRESE(id_visitante,
nombrevisitante,apellidovisitante) AS SELECT v.id_lego, v.prim_nom, v.prim_ape from 
VISITANTES_FANS v where v.id_repres is NULL;

--4) Vista de Productos con temas
CREATE VIEW V_PRODCONTEMA(id_tema, nombre_tema, tipo_tema, id_juguete, nom_juguete, 
edad_juguete, precio_juguete,clasfc_precio) AS SELECT t.id, t.nombre, t.tipo, 
j.codigo, j.nombre, j.rgo_edad, h.precio, j.rgo_precio from
TEMAS t, JUGUETES j, HISTORICO_PRECIOS_JUGUETES h WHERE t.id = j.id_tema AND 
j.codigo = h.cod_juguete AND h.f_fin IS NULL; 

--5) Vista de Clientes Exclusivamente
CREATE VIEW V_CLIENTES(id_cliente,nombrecliente,apellidocliente) 
AS SELECT c.id_lego, c.prim_nom, c.prim_ape from CLIENTES c;

--6) Vista de Productos por Pais
CREATE OR REPLACE VIEW V_CATALOGO_ONLINE AS
SELECT 
    c.id_pais,
    t.id as id_tema,
    t.nombre as nombre_tema,
    t.tipo as tipo_tema,
    j.codigo AS id_producto,
    j.nombre AS nombre_producto,
    j.rgo_edad as edad_producto,
    h.precio AS precio_usd,
    mostrar_precio_local(h.precio, c.id_pais) AS precio_local,
    c.limite AS stock_maximo
FROM 
    temas t,
    CATALOGOS_LEGO c, 
    JUGUETES j, 
    HISTORICO_PRECIOS_JUGUETES h
WHERE 
    c.cod_juguete = j.codigo
    AND t.id = j.id_tema
    AND j.codigo = h.cod_juguete
    AND h.f_fin IS NULL;