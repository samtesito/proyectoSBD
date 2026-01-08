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







  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "ALI123"."V_REPORTE_5" ("CONTINENTE", "PAIS", "ANIO", "NOMBRE_JUGUETE", "TOTAL_UNIDADES", "TOTAL_MONETARIO", "MONEDA", "NUMERO_RANKING", "ETIQUETA_RANKING") AS 
  SELECT 
    p.continente,
    p.nombre AS pais,
    EXTRACT(YEAR FROM f.f_emision) AS anio,
    j.nombre AS nombre_juguete,
    
    -- 1. Métricas Numéricas (Estas SÍ se suman bien)
    SUM(d.cant_prod) AS total_unidades,
    SUM(d.cant_prod * h.precio) AS total_monetario,
    
    -- 2. Columna SOLO para el Símbolo (Texto)
    CASE 
        WHEN p.ue = 1 THEN '€' 
        ELSE '$' 
    END AS moneda,
    
    -- 3. Ranking Inteligente (Para el Top 3 con empates)
    DENSE_RANK() OVER (
        PARTITION BY p.nombre, EXTRACT(YEAR FROM f.f_emision) 
        ORDER BY SUM(d.cant_prod * h.precio) DESC
    ) AS numero_ranking,
    
    -- 4. Etiqueta visual
    'Top ' || DENSE_RANK() OVER (
        PARTITION BY p.nombre, EXTRACT(YEAR FROM f.f_emision) 
        ORDER BY SUM(d.cant_prod * h.precio) DESC
    ) AS etiqueta_ranking

FROM DETALLES_FACTURA_TIENDA d
JOIN FACTURAS_TIENDA f ON d.nro_fact = f.nro_fact
JOIN TIENDAS_LEGO t ON f.id_tienda = t.id
JOIN PAISES p ON t.id_pais = p.id
JOIN JUGUETES j ON d.cod_juguete = j.codigo
JOIN HISTORICO_PRECIOS_JUGUETES h ON d.cod_juguete = h.cod_juguete
WHERE f.f_emision >= h.f_inicio 
  AND (f.f_emision <= h.f_fin OR h.f_fin IS NULL)
GROUP BY 
    p.continente, 
    p.nombre, 
    p.ue,
    EXTRACT(YEAR FROM f.f_emision), 
    j.nombre;















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

