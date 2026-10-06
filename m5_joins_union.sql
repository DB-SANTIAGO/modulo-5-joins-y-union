--PROYECTO INTEGRADOR
--CONSULTAS CON JOINS
--Autor: Santiago Gabriel Fraser

USE Ventas_Tech_DB;
GO

-- CONSULTA 1 - VISTA BASE DEL PROYECTO - INNER JOIN

SELECT
    v.fecha_venta AS fecha,
    c.id_cliente AS id_cliente,
    c.nombre AS cliente,
    c.email AS email_cliente,
    c.ciudad AS region,
    p.id_producto AS id_producto,
    p.nombre_producto AS producto,
    cat.nombre_categoria AS categoria,
    v.cantidad AS cantidad,
    v.precio_unitario AS precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;
GO

-- CONSULTA 2 - CLIENTES SIN VENTAS - LEFT JOIN

SELECT
    c.nombre AS nombre_cliente,
    c.email AS email,
    c.fecha_registro AS fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_cliente IS NULL
ORDER BY c.nombre;
GO

-- CONSULTA 3 - PRODUCTOS SIN VENTAS - LEFT JOIN

SELECT
    p.nombre_producto AS producto,
    cat.nombre_categoria AS categoria,
    p.precio AS precio
FROM productos AS p
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto
WHERE v.id_producto IS NULL
ORDER BY p.nombre_producto;
GO

-- CONSULTA 4 - CONSOLIDADO POR CANAL - UNION ALL

SELECT
    canal,
    SUM(total) AS total_canal
FROM
(
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Online' AS canal
    FROM ventas
    WHERE fecha_venta BETWEEN '2024-02-10' AND '2024-03-09'

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Presencial' AS canal
    FROM ventas
    WHERE fecha_venta BETWEEN '2024-03-10' AND '2024-04-09'
) AS consolidado
GROUP BY canal
ORDER BY total_canal DESC;
GO
