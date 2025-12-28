--Script Venta Online

--Muestra Clientes para seleccionar uno por su ID
SELECT * FROM V_CLIENTES;
VARIABLE id_cliente NUMBER;
ACCEPT cliente_id NUMBER PROMPT 'Ingrese el ID del cliente que realiza la compra: '
EXEC :id_cliente := &cliente_id;

VARIABLE nro_factura_act NUMBER;
EXEC :nro_factura_act:=nrofacturaVenOL.NEXTVAL;
INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente)
    VALUES (:nro_factura_act, SYSDATE, :id_cliente);

--Muestra Productos disponibles para el pais del cliente
SELECT id_tema, nombre_tema, decode(tipo_tema, 'L', 'LICENCIA', 'O', 'ORIGINAL') "TIPO", 
id_producto "CODIGO JUGUETE", nombre_producto "NOMBRE JUGUETE", edad_producto "EDAD", precio_local, cant_limite
FROM V_CATALOGO_ONLINE WHERE id_pais = (SELECT id_pais_resi FROM CLIENTES WHERE id_lego = :id_cliente);

VARIABLE id_producto NUMBER;

--Selecciona Productos
ACCEPT producto_id NUMBER PROMPT 'Ingrese el ID del producto que desea comprar: '
EXEC :id_producto := &producto_id;

ACCEPT cant_prod NUMBER PROMPT 'Ingrese la cantidad: '

--Confirma compra
BEGIN
    CARGARPRODUCTOSONLINE(:nro_factura_act, &producto_id, &cant_prod);
END;
/

ACCEPT producto_id NUMBER PROMPT 'Ingrese el ID del producto que desea comprar: '
EXEC :id_producto := &producto_id;

ACCEPT cant_prod NUMBER PROMPT 'Ingrese la cantidad: '

--Confirma compra
BEGIN
    CARGARPRODUCTOSONLINE(:nro_factura_act, &producto_id, &cant_prod);
    FINALIZARVENTAONLINE(:nro_factura_act);
END;
/

--Muestra factura final
SELECT nro_fact, f_emision, total, ptos_generados 
FROM FACTURAS_ONLINE 
WHERE nro_fact = :nro_factura_act;