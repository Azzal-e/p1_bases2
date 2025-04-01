DROP VIEW IF EXISTS Tienda_global CASCADE;
DROP VIEW IF EXISTS Cliente_global CASCADE;
DROP VIEW IF EXISTS Empleado_global CASCADE;
DROP VIEW IF EXISTS Producto_global CASCADE;
DROP VIEW IF EXISTS Ventas_global CASCADE;
DROP VIEW IF EXISTS Compras_global CASCADE;
DROP EXTENSION IF EXISTS dblink CASCADE;

-- Creación de los dblink --
CREATE EXTENSION dblink;
SELECT dblink_connect('conexion_bbdd2_pr3_1', 'host=localhost port=5432 dbname=bbdd2_pr3_1 user=admin password=admin123');
SELECT dblink_connect('conexion_bbdd2_pr3_2', 'host=localhost port=5432 dbname=bbdd2_pr3_2 user=admin password=admin123');

-- Creación de vistas --
CREATE OR REPLACE VIEW Tienda_global AS 
    SELECT *
    FROM dblink('conexion_bbdd2_pr3_1', 'SELECT * FROM Tienda')
    AS t1(CIF VARCHAR(9), nombre VARCHAR(50), direccion VARCHAR(250))
    UNION 
    SELECT *
    FROM dblink('conexion_bbdd2_pr3_2', 'SELECT * FROM STORE') 
    AS t2(CIF VARCHAR(9), NAME VARCHAR(50), ADDRESS VARCHAR(250));

CREATE OR REPLACE VIEW Cliente_global AS
    SELECT * 
    FROM dblink('conexion_bbdd2_pr3_1', 'SELECT dni, (nombre || apellidos) as full_name, fecha_nacimiento as fecha_de_nacimiento, edad as age, email, genero as gender, telefono as phone, es_socio_especial as has_member_card FROM Cliente ')
    AS p1(dni VARCHAR(9), full_name VARCHAR(100), fecha_de_nacimiento DATE, age INTEGER, email VARCHAR(250), gender VARCHAR(10), phone VARCHAR(15), has_member_card BOOLEAN)
    UNION
    SELECT * 
    FROM dblink('conexion_bbdd2_pr3_2', 'SELECT p.DNI, p.FULL_NAME, p.FECHA_DE_NACIMIENTO, pa.AGE, p.EMAIL, p.GENDER, p.PHONE, p.HAS_MEMBER_CARD FROM PERSON p JOIN PERSON_AGE pa ON pa.DNI = p.DNI WHERE p.IS_CLIENT = TRUE')
    AS p2(DNI VARCHAR(9), FULL_NAME VARCHAR(100), FECHA_DE_NACIMIENTO DATE, AGE INTEGER, EMAIL VARCHAR(100), GENDER VARCHAR(10), PHONE VARCHAR(15), HAS_MEMBER_CARD BOOLEAN);

CREATE OR REPLACE VIEW Empleado_global AS
    SELECT * 
    FROM dblink('conexion_bbdd2_pr3_1', 'SELECT e.dni, (e.nombre || e.apellidos) as full_name, e.fecha_nacimiento as fecha_de_nacimiento, e.edad as age, e.email, e.genero as gender, e.telefono as phone, e.codigo_empleado as employee_number, e.CIF_tienda as cif_store, ve.num_ventas as NUMBER_OF_SALES FROM Empleado e JOIN Ventas_por_empleado ve ON e.codigo_empleado = ve.codigo_empleado')
    AS p1(dni VARCHAR(9), full_name VARCHAR(100), fecha_de_nacimiento DATE, age INTEGER, email VARCHAR(250), gender VARCHAR(10), phone VARCHAR(15), employee_number VARCHAR(9), cif_store VARCHAR(9), NUMBER_OF_SALES INTEGER)
    UNION
    SELECT *
    FROM dblink('conexion_bbdd2_pr3_2', 'SELECT p.DNI, p.FULL_NAME, p.FECHA_DE_NACIMIENTO, pa.AGE, p.EMAIL, p.GENDER, p.PHONE, p.EMPLOYEE_NUMBER, w.CIF_STORE, p.NUMBER_OF_SALES FROM PERSON p JOIN PERSON_AGE pa ON pa.DNI = p.DNI JOIN WORKS w ON w.DNI = p.DNI WHERE p.IS_EMPLOYEE = TRUE')
    AS p2(dni VARCHAR(9), full_name VARCHAR(100), fecha_de_nacimiento DATE, age INTEGER, email VARCHAR(250), gender VARCHAR(10), phone VARCHAR(15), employee_number VARCHAR(9), cif_store VARCHAR(9), NUMBER_OF_SALES INTEGER);

CREATE OR REPLACE VIEW Producto_global AS
    SELECT * 
    FROM dblink('conexion_bbdd2_pr3_1', 'SELECT id, CIF_tienda, nombre, descripcion, precio FROM Producto')
    AS p1(ID INTEGER, CIF_STORE VARCHAR(9), NAME VARCHAR(50), DESCRIPTION VARCHAR(250), PRICE DECIMAL(10, 2))
    UNION
    SELECT * 
    FROM dblink('conexion_bbdd2_pr3_2', 'SELECT ID, CIF_STORE, NAME, DESCRIPTION, PRICE FROM PRODUCT')
    AS p2(ID INTEGER, CIF_STORE VARCHAR(9), NAME VARCHAR(50), DESCRIPTION VARCHAR(200), PRICE DECIMAL(10, 2));

CREATE OR REPLACE VIEW Ventas_global AS
    SELECT * 
    FROM dblink('conexion_bbdd2_pr3_1', 'SELECT id_producto, cif_tienda_producto as cif_tienda, codigo_empleado FROM Ventas')
    AS p1(ID_PRODUCTO INTEGER, CIF_TIENDA VARCHAR(9), EMPLOYEE_NUMBER VARCHAR(9))
    UNION
    SELECT *
    FROM dblink('conexion_bbdd2_pr3_2', 'SELECT ID, CIF_STORE, DNI_SELLER FROM PRODUCT')
    AS p2(ID_PRODUCTO INTEGER, CIF_TIENDA VARCHAR(9), EMPLOYEE_NUMBER VARCHAR(9));

CREATE OR REPLACE VIEW Compras_global AS
    SELECT *
    FROM dblink('conexion_bbdd2_pr3_1', 'SELECT id_producto, cif_tienda_producto as cif_tienda, dni_cliente FROM Compras')
    AS p1(ID_PRODUCTO INTEGER, CIF_TIENDA VARCHAR(9), DNI_CLIENTE VARCHAR(9))   
    UNION
    SELECT *
    FROM dblink('conexion_bbdd2_pr3_2', 'SELECT ID, CIF_STORE, DNI_BUYER FROM PRODUCT')
    AS p2(ID_PRODUCTO INTEGER, CIF_TIENDA VARCHAR(9), DNI_CLIENTE VARCHAR(9));

-- Consultas --
-- 1. Obtener el número total de productos vendidos, en orden descendiente, por cada empleado en ambas bases de datos.
SELECT e.full_name, COUNT(v.ID_PRODUCTO) AS total_products_sold 
FROM Empleado_global e
JOIN Ventas_global v ON e.employee_number = v.EMPLOYEE_NUMBER
GROUP BY e.full_name
ORDER BY total_products_sold DESC;

-- 2. Obtener el número total de productos comprados, en orden descendiente, por cada cliente en ambas bases de datos.
SELECT c.full_name, COUNT(p.ID_PRODUCTO) AS total_products_purchased
FROM Cliente_global c
JOIN Compras_global p ON c.DNI = p.DNI_CLIENTE
GROUP BY c.full_name
ORDER BY total_products_purchased DESC;

-- 3. Obtener el número total de productos vendidos por cada tienda en ambas bases de datos.
SELECT t.CIF, COUNT(v.ID_PRODUCTO) AS total_products_sold
FROM Tienda_global t
JOIN Ventas_global v ON t.CIF = v.CIF_TIENDA
GROUP BY t.CIF;

-- 4. Obtener el número total de productos comprados por cada tienda en ambas bases de datos.
SELECT t.CIF, COUNT(p.ID_PRODUCTO) AS total_products_purchased
FROM Tienda_global t
JOIN Compras_global p ON t.CIF = p.CIF_TIENDA
GROUP BY t.CIF;

-- 5. Obtener el producto más caro de cada tienda en ambas bases de datos, ordenando el precio descendientemente.
SELECT t.CIF, p.NAME, p.PRICE AS highest_price
FROM Tienda_global t
JOIN Producto_global p ON t.CIF = p.CIF_STORE
WHERE p.PRICE = (
	SELECT MAX(p2.PRICE)
	FROM Producto_global p2
	WHERE p2.CIF_STORE = t.CIF
)
ORDER BY highest_price DESC;
