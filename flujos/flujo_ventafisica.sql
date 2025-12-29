--Script Venta en Tienda Fisica

--Muestra Tiendas para seleccionar donde se realiza la compra
SELECT * FROM V_TIENDAS;

--Selecciona id de la tienda
VARIABLE id_tienda_v NUMBER;
ACCEPT tienda_id NUMBER PROMPT 'Ingrese el ID de la tienda: '
EXEC :id_tienda_v := &tienda_id;

BEGIN
    validarsitiendaabierta(:id_tienda_v, SYSDATE);
END;



--Muestra Clientes para seleccionar uno por su ID
SELECT id_cliente, nombrecliente, apellidocliente FROM V_CLIENTES, CLIENTES c 
WHERE id_cliente=c.id_lego AND c.id_pais_resi=(SELECT id_pais FROM TIENDAS_LEGO where id=:id_tienda_v);
VARIABLE id_cliente_v NUMBER;

ACCEPT cliente_id_t NUMBER PROMPT 'Ingrese el ID del cliente: '
EXEC :id_cliente_v := &cliente_id_t;

--Generar Factura
VARIABLE nro_fact_t NUMBER;
EXEC :nro_fact_t := nrofacturavenfs.NEXTVAL;
INSERT INTO FACTURAS_TIENDA (nro_fact, id_cliente, id_tienda, f_emision, total)
VALUES (:nro_fact_t, :id_cliente_v, :id_tienda_v, SYSDATE, 0);

--Muestra Productos con stock en esta tienda
SELECT DISTINCT j.codigo, j.nombre, h.precio
FROM JUGUETES j, LOTES_SET_TIENDA l, HISTORICO_PRECIOS_JUGUETES h
WHERE j.codigo = l.cod_juguete 
AND j.codigo = h.cod_juguete
AND l.id_tienda = :id_tienda_v
AND l.cant_prod > 0
AND h.f_fin IS NULL;

--Selecciona Productos
ACCEPT producto_id_t NUMBER PROMPT 'Ingrese el ID del producto: '
ACCEPT cantidad_t NUMBER PROMPT 'Cantidad a comprar: '
BEGIN
    CARGAR_PRODUCTO_TIENDA(:nro_fact_t, :id_tienda_v, &producto_id_t, &cantidad_t);
    COMMIT;
END;
/

ACCEPT producto_id_t NUMBER PROMPT 'Ingrese el ID del producto: '
ACCEPT cantidad_t NUMBER PROMPT 'Cantidad a comprar: '
BEGIN
    CARGAR_PRODUCTO_TIENDA(:nro_fact_t, :id_tienda_v, &producto_id_t, &cantidad_t);
    COMMIT;
END;
/

-- Muestra factura final
SELECT * FROM FACTURAS_TIENDA WHERE nro_fact = :nro_fact_t;
