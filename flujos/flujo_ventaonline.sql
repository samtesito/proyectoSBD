--Script Venta Online

--Muestra Clientes para seleccionar uno por su ID
SELECT * FROM V_CLIENTES;
VARIABLE id_cliente NUMBER(8);
ACCEPT cliente_id NUMBER PROMPT 'Ingrese el ID del cliente que realiza la compra: '
EXEC :id_cliente := &cliente_id;


--Segun pais del cliente, se hace el catalogo para mostrar referente al pais


--Muestra Productos
--Selecciona Productos
--Confirma compra
--Generar Factura
