-- =============================================
-- 1. INDICES PARA FOREIGN KEYS (Mejora Joins)
-- =============================================

-- Acelera la búsqueda de facturas por cliente
CREATE INDEX idx_fact_online_cliente ON FACTURAS_ONLINE(id_cliente);
CREATE INDEX idx_fact_tienda_cliente ON FACTURAS_TIENDA(id_cliente);

-- Acelera la búsqueda de productos en los detalles (Vital para tus triggers de stock)
CREATE INDEX idx_det_tienda_prod ON DETALLES_FACTURA_TIENDA(codigo);
CREATE INDEX idx_det_online_prod ON DETALLES_FACTURA_ONLINE(codigo);

-- Acelera filtros por país (usado en tus validaciones de catálogo y envío)
CREATE INDEX idx_cli_pais ON CLIENTES(id_pais_resi);

-- Acelera la validación de inscripciones por fecha
CREATE INDEX idx_det_insc_fecha ON DETALLES_INSCRITOS(fecha_inicio);

-- =============================================
-- 2. INDICES DE BUSQUEDA (Mejora Consultas WHERE)
-- =============================================

-- Índice basado en función para buscar clientes por APELLIDO sin importar mayúsculas/minúsculas
-- Ejemplo de uso: WHERE UPPER(prim_apell) LIKE '%PEREZ%'
CREATE INDEX idx_cliente_apell_upper ON CLIENTES(UPPER(prim_apell));

-- Índice para buscar Facturas por Fecha (Reportes de ventas)
CREATE INDEX idx_fact_online_fecha ON FACTURAS_ONLINE(f_emision);
CREATE INDEX idx_fact_tienda_fecha ON FACTURAS_TIENDA(f_emision);

-- Índice para buscar precios activos rápidamente (f_fin IS NULL)
CREATE INDEX idx_hist_precio_activo ON HISTORICO_PRECIOS_JUGUETES(cod_juguete, f_fin);


