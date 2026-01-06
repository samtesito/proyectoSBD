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
    c.limite AS cant_limite
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

--7) Vista de Tiendas con Horarios de atencion
CREATE OR REPLACE VIEW V_TIENDASCONHORARIO (id_tienda, nombre_tienda, nombre_pais, dia_atencion, hra_entrada, 
hra_salida, direccion_tienda) AS SELECT t.id, t.nombre, p.nombre, h.dia, TO_CHAR(h.hora_entr, 'HH24:MI'),  
TO_CHAR(h.hora_sal, 'HH24:MI'),  t.direccion FROM TIENDAS_LEGO t, PAISES p, 
HORARIOS_ATENCION h WHERE t.id_pais = p.id AND t.id = h.id_tienda;

--8) Vista de Tiendas sin horario de atencion
CREATE OR REPLACE VIEW V_TIENDAS (id_tienda, nombre_tienda, nombre_pais, direccion) 
AS SELECT t.id, t.nombre, p.nombre, t.direccion FROM TIENDAS_LEGO t, PAISES p 
WHERE t.id_pais = p.id;

--9) Vista de la factura para los reportes
CREATE OR REPLACE VIEW V_FACTURA_COMPLETA AS
SELECT 
    f.nro_fact, f.f_emision,
    c.prim_nom || ' ' || c.prim_ape AS cliente_nombre,
    pt.nombre AS pais, t.nombre AS tienda,  -- ← pt = país TIENDA
    d.cod_juguete, j.nombre AS juguete, j.rgo_edad,
    DECODE(d.tipo_cli, 'M', 'MENOR', 'A', 'ADULTO') AS tipo_cliente,
    d.cant_prod,
    d.cant_prod * COALESCE(h.precio, 0) AS subtotal_linea,
    f.total AS total_factura,
    t.direccion AS direccion_tienda,
    t.id AS id_tienda
FROM FACTURAS_TIENDA f, CLIENTES c, PAISES pt, TIENDAS_LEGO t,
     DETALLES_FACTURA_TIENDA d, JUGUETES j, HISTORICO_PRECIOS_JUGUETES h
WHERE f.id_cliente = c.id_lego
  AND t.id_pais = pt.id
  AND f.id_tienda = t.id
  AND f.nro_fact = d.nro_fact
  AND d.cod_juguete = j.codigo
  AND j.codigo = h.cod_juguete 
  AND h.f_fin IS NULL
  AND f.f_emision >= h.f_inicio;

--10) Vista de la entrada para los reportes
CREATE OR REPLACE VIEW V_ENTRADA_TOUR AS
SELECT 
    e.f_inicio,
    e.nro_fact,
    e.nro AS nro_entrada,
    DECODE(e.tipo, 'M', 'MENOR', 'A', 'ADULTO') AS tipo_entrada,
    ft.costo,
    i.estado,
    i.total,
    NVL(c.prim_nom || ' ' || c.prim_ape, v.prim_nom || ' ' || v.prim_ape) AS nombre_comprador,
    DECODE(di.id_cliente, NULL, 'VISITANTE', 'CLIENTE') AS tipo_comprador,
    p.nombre AS pais_residencia
FROM ENTRADAS e, INSCRIPCIONES_TOUR i, FECHAS_TOUR ft, 
     DETALLES_INSCRITOS di, CLIENTES c, VISITANTES_FANS v, PAISES p
WHERE e.f_inicio = i.f_inicio 
  AND e.nro_fact = i.nro_fact
  AND e.f_inicio = ft.f_inicio
  AND e.f_inicio = di.fecha_inicio (+) 
  AND e.nro_fact = di.nro_fact (+)
  AND di.id_cliente = c.id_lego (+)
  AND di.id_visit = v.id_lego (+)
  AND NVL(c.id_pais_resi, v.id_pais) = p.id (+);

