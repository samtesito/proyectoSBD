------------TIENDA FISICA----------------------------------
SET SERVEROUTPUT ON;
DECLARE
    -- Declaramos las listas vacías
    v_productos   t_lista_numeros := t_lista_numeros();
    v_cantidades  t_lista_numeros := t_lista_numeros();
BEGIN
    -- 1. Preparamos la lista para recibir 2 items DISTINTOS
    v_productos.EXTEND(2);   -- Reservamos 2 espacios en la lista de IDs
    v_cantidades.EXTEND(2);  -- Reservamos 2 espacios en la lista de Cantidades

    -- 2. Agregamos el PRIMER Juguete (Posición 1)
    v_productos(1)  := 401; -- ID del juguete A
    v_cantidades(1) := 2;    -- Lleva 2 unidades

    -- 3. Agregamos el SEGUNDO Juguete (Posición 2)
    v_productos(2)  := 402; -- ID del juguete B
    v_cantidades(2) := 1;    -- Lleva 1 unidad

    -- 4. Llamamos al procedimiento UNA SOLA VEZ
    -- El procedimiento generará 1 Factura y 2 Detalles automáticamente
    registrar_venta_tienda(
        p_id_tienda   => 10,    -- ID de la tienda
        p_id_cliente  => 1001,   -- ID del cliente
        p_lista_prods => v_productos,
        p_lista_cants => v_cantidades
    );
END;
/


















------------TIENDA ONLINE----------------------------------
SET SERVEROUTPUT ON;
DECLARE
    -- Declaramos las listas vacias
    v_productos   t_lista_numeros := t_lista_numeros();
    v_cantidades  t_lista_numeros := t_lista_numeros();
    
    -- ID del Cliente (Asegúrate que exista y tenga direccion/pais)
    v_cliente_id  NUMBER := 1001; 
BEGIN
    -- 1. Preparamos la lista para recibir 2 items
    v_productos.EXTEND(2);
    v_cantidades.EXTEND(2);

    -- 2. Llenamos el Carrito
    -- Item 1
    v_productos(1)  := 401; 
    v_cantidades(1) := 1;

    -- Item 2
    v_productos(2)  := 402;
    v_cantidades(2) := 3;

    -- 3. Llamamos al procedimiento
    -- El procedimiento calculará envios, puntos y validará catálogo automáticamente
    p_realizar_venta_online(
        p_id_cliente  => v_cliente_id,
        p_lista_prods => v_productos,
        p_lista_cants => v_cantidades
    );
END;
/












------------INSCRIPCION TOUR----------------------------------
SET SERVEROUTPUT ON;
DECLARE
    -- Declaramos la variable tipo lista (array)
    v_grupo_familiar t_lista_numeros := t_lista_numeros(); 
BEGIN
    -- 1. Preparamos la lista para recibir a 3 personas
    v_grupo_familiar.EXTEND(2); 

    -- 2. Llenamos los datos (IDs de la tabla CLIENTES)
    v_grupo_familiar(1) := 1001;  -- ID del Papá (Adulto)
    v_grupo_familiar(2) := 1002;  -- ID de la Mamá (Adulto)

    -- 3. Llamamos al procedimiento UNA SOLA VEZ
    -- Parametros: (Fecha Tour, ID Responsable, Lista de Participantes)
    inscribir_participantes(DATE '2026-08-20', 1001, v_grupo_familiar);
    
    -- Nota: El ID Responsable (10) suele ser uno de los adultos del grupo.
END;
/






SET SERVEROUTPUT ON;

-- 1. Verificamos una inscripcion pendiente (Usa los datos que creamos antes)
-- Supongamos Fecha: '20-08-2026' y Factura generada: 1 (revisa tu salida anterior)
DECLARE
    v_fecha DATE := DATE '2026-08-20';
    v_fact  NUMBER := 1; -- CAMBIA ESTO por el numero que te dio el script anterior
    v_monto NUMBER := 100; -- El monto que dio el script anterior
BEGIN
    procesar_pago_inscripcion(v_fecha, v_fact, v_monto);
END;
/

-- 2. Verificar que cambio el estado
SELECT f_inicio, nro_fact, estado 
FROM INSCRIPCIONES_TOUR;

-- 3. Verificar que se crearon las entradas (Tickets)
SELECT * FROM ENTRADAS;