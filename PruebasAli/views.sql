CREATE OR REPLACE VIEW V_REPORTE_5_TOP_TIENDAS AS
SELECT 
    EXTRACT(YEAR FROM f.f_emision) AS ANIO,
    p.continente,
    p.nombre AS pais,
    j.nombre AS nombre_juguete,
    t.nombre AS nombre_tema, -- Agregado por si quieres filtrar por tema
    SUM(df.cant_prod) AS total_unidades_vendidas,
    SUM(df.cant_prod * h.precio) AS total_ingresos, -- Estimado usando precio actual
    -- La magia: Esto crea un ranking del 1 al N por cada Año y País
    DENSE_RANK() OVER (
        PARTITION BY EXTRACT(YEAR FROM f.f_emision), p.continente, p.nombre 
        ORDER BY SUM(df.cant_prod) DESC
    ) AS ranking_venta
FROM 
    FACTURAS_TIENDA f
    JOIN TIENDAS_LEGO tl ON f.id_tienda = tl.id
    JOIN PAISES p ON tl.id_pais = p.id
    JOIN DETALLES_FACTURA_TIENDA df ON f.nro_fact = df.nro_fact
    JOIN JUGUETES j ON df.cod_juguete = j.codigo
    JOIN TEMAS t ON j.id_tema = t.id
    LEFT JOIN HISTORICO_PRECIOS_JUGUETES h ON j.codigo = h.cod_juguete AND h.f_fin IS NULL
GROUP BY 
    EXTRACT(YEAR FROM f.f_emision),
    p.continente,
    p.nombre,
    j.nombre,





CREATE OR REPLACE VIEW V_REPORTE_6_ONLINE_SEMESTRAL AS
SELECT 
    EXTRACT(YEAR FROM fo.f_emision) AS ANIO,
    CASE 
        WHEN EXTRACT(MONTH FROM fo.f_emision) <= 6 THEN 'Semestre 1'
        ELSE 'Semestre 2'
    END AS SEMESTRE,
    p.nombre AS pais,
    p.continente,
    SUM(fo.total) AS total_venta_moneda_origen, -- Total tal cual viene en la factura
    COUNT(fo.nro_fact) AS cantidad_facturas
FROM 
    FACTURAS_ONLINE fo
    JOIN CLIENTES c ON fo.id_cliente = c.id_lego
    JOIN PAISES p ON c.id_pais_resi = p.id
GROUP BY 
    EXTRACT(YEAR FROM fo.f_emision),
    CASE 
        WHEN EXTRACT(MONTH FROM fo.f_emision) <= 6 THEN 'Semestre 1'
        ELSE 'Semestre 2'
    END,
    p.nombre,
    p.continente;
    t.nombre;
