--Script Venta Online

--Muestra Clientes para seleccionar uno por su ID
SELECT * FROM V_CLIENTES;
VARIABLE id_cliente NUMBER(8);
ACCEPT cliente_id NUMBER PROMPT 'Ingrese el ID del cliente que realiza la compra: '
EXEC :id_cliente := &cliente_id;

--Muestra Productos disponibles para el pais del cliente
SELECT id_producto, nombre_producto, precio_local, stock_maximo
FROM V_CATALOGO_ONLINE
WHERE id_pais = (SELECT id_pais_resi FROM CLIENTES WHERE id_lego = :id_cliente);

VARIABLE id_producto NUMBER(8);

--Selecciona Productos
ACCEPT producto_id NUMBER PROMPT 'Ingrese el ID del producto que desea comprar: '
EXEC :id_producto := &producto_id;

ACCEPT cant_prod NUMBER PROMPT 'Ingrese la cantidad: '

--Confirma compra
VARIABLE nro_factura_act NUMBER;
BEGIN
    INSERT INTO FACTURAS_ONLINE (nro_fact, f_emision, id_cliente, ptos_generados, total)
    VALUES (nfacturatour.NEXTVAL, SYSDATE, :id_cliente, 0, 0)
    RETURNING nro_fact INTO :nro_factura_act;
    CARGARPRODUCTOSONLINE(:nro_factura_act, &producto_id, &cant_prod);
    FINALIZARVENTAONLINE(:nro_factura_act);
END;
/
--Muestra factura final
SELECT nro_fact, f_emision, total, ptos_generados 
FROM FACTURAS_ONLINE 
WHERE nro_fact = :nro_factura_act;

/*Creo que entiendo a que se referia Violeta con lo del problema con los loops.
Ahora mismo solo puedo comprar un producto por factura, pero voy a ver si logro cambiar eso*/