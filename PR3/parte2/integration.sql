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
    FROM dblink('conexion_bbdd2_pr3_1', 'SELECT dni, (nombre || '','' || apellidos) as full_name, fecha_nacimiento as fecha_de_nacimiento, edad as age, email, genero as gender, telefono as phone, es_socio_especial as has_member_card FROM Cliente ')
    AS p1(dni VARCHAR(9), full_name VARCHAR(100), fecha_de_nacimiento DATE, age INTEGER, email VARCHAR(250), gender VARCHAR(10), phone VARCHAR(15), has_member_card BOOLEAN)
    UNION
    SELECT * 
    FROM dblink('conexion_bbdd2_pr3_2', 'SELECT p.DNI, p.FULL_NAME, p.FECHA_DE_NACIMIENTO, pa.AGE, p.EMAIL, p.GENDER, p.PHONE, p.HAS_MEMBER_CARD FROM PERSON p JOIN PERSON_AGE pa ON pa.DNI = p.DNI WHERE p.IS_CLIENT = TRUE')
    AS p2(DNI VARCHAR(9), FULL_NAME VARCHAR(100), FECHA_DE_NACIMIENTO DATE, AGE INTEGER, EMAIL VARCHAR(100), GENDER VARCHAR(10), PHONE VARCHAR(15), HAS_MEMBER_CARD BOOLEAN);

CREATE OR REPLACE VIEW Empleado_global AS
    SELECT * 
    FROM dblink('conexion_bbdd2_pr3_1', 'SELECT e.dni, (e.nombre || '','' || e.apellidos) as full_name, e.fecha_nacimiento as fecha_de_nacimiento, e.edad as age, e.email, e.genero as gender, e.telefono as phone, e.codigo_empleado as employee_number, e.CIF_tienda as cif_store, ve.num_ventas as NUMBER_OF_SALES FROM Empleado e JOIN Ventas_por_empleado ve ON e.codigo_empleado = ve.codigo_empleado')
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

-- Triggers --
CREATE OR REPLACE FUNCTION insertar_en_tiendas()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM dblink_exec('conexion_bbdd2_pr3_1', 'INSERT INTO Tienda (CIF, nombre, direccion) VALUES (' || quote_literal(NEW.CIF) || ', ' || quote_literal(NEW.nombre) || ', ' || quote_literal(NEW.direccion) || ')');
    PERFORM dblink_exec('conexion_bbdd2_pr3_2', 'INSERT INTO STORE (CIF, NAME, ADDRESS) VALUES (' || quote_literal(NEW.CIF) || ', ' || quote_literal(NEW.nombre) || ', ' || quote_literal(NEW.direccion) || ')');
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION modificar_en_tiendas()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM dblink_exec('conexion_bbdd2_pr3_1', 'UPDATE Tienda SET nombre = ' || quote_literal(NEW.nombre) || ', direccion = ' || quote_literal(NEW.direccion) || ' WHERE CIF = ' || quote_literal(OLD.CIF));
    PERFORM dblink_exec('conexion_bbdd2_pr3_2', 'UPDATE STORE SET NAME = ' || quote_literal(NEW.nombre) || ', ADDRESS = ' || quote_literal(NEW.direccion) || ' WHERE CIF = ' || quote_literal(OLD.CIF));
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- posible error debido a que hace falta subdividir full_name en nombre y apellidos para la bbdd2_pr3_1
CREATE OR REPLACE FUNCTION insertar_en_clientes()
RETURNS TRIGGER AS $$
BEGIN   
    PERFORM dblink_exec('conexion_bbdd2_pr3_1', 'INSERT INTO Cliente (dni, nombre, apellidos, fecha_nacimiento, edad, email, genero, telefono, es_socio_especial) VALUES (' || quote_literal(NEW.dni) || ', ' || quote_literal(split_part(NEW.full_name, ',', 1)) || ', ' || quote_literal(split_part(NEW.full_name, ',', 2)) || ', ' || quote_literal(NEW.fecha_de_nacimiento) || ', ' || quote_literal(NEW.age) || ', ' || quote_literal(NEW.email) || ', ' || quote_literal(NEW.gender) || ', ' || quote_literal(NEW.phone) || ', ' || quote_literal(NEW.has_member_card) || ')');
    PERFORM dblink_exec('conexion_bbdd2_pr3_2', 'INSERT INTO PERSON (dni, full_name, fecha_de_nacimiento, phone, email, gender, is_employee, is_client, has_member_card, employee_number, number_of_sales) VALUES (' || quote_literal(NEW.dni) || ', ' || quote_literal(NEW.full_name) || ', ' || quote_literal(NEW.fecha_de_nacimiento) || ', ' || quote_literal(NEW.phone) || ', ' || quote_literal(NEW.email) || ', ' || quote_literal(NEW.gender) || ', FALSE, TRUE, ' || quote_literal(NEW.has_member_card) || ', NULL, NULL)');
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- posible error debido a que hace falta subdividir full_name en nombre y apellidos para la bbdd2_pr3_1
CREATE OR REPLACE FUNCTION modificar_en_clientes()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM dblink_exec('conexion_bbdd2_pr3_1', 'UPDATE Cliente SET nombre = ' || quote_literal(split_part(NEW.full_name, ',', 1)) || ', apellidos = ' || quote_literal(split_part(NEW.full_name, ',', 2)) || ', fecha_nacimiento = ' || quote_literal(NEW.fecha_de_nacimiento) || ', edad = ' || quote_literal(NEW.age) || ', email = ' || quote_literal(NEW.email) || ', genero = ' || quote_literal(NEW.gender) || ', telefono = ' || quote_literal(NEW.phone) || ', es_socio_especial = ' || quote_literal(NEW.has_member_card) || ' WHERE dni = ' || quote_literal(OLD.dni));
    PERFORM dblink_exec('conexion_bbdd2_pr3_2', 'UPDATE PERSON SET full_name = ' || quote_literal(NEW.full_name) || ', fecha_de_nacimiento = ' || quote_literal(NEW.fecha_de_nacimiento) || ', phone = ' || quote_literal(NEW.phone) || ', email = ' || quote_literal(NEW.email) || ', gender = ' || quote_literal(NEW.gender) || ', is_employee = FALSE, is_client = TRUE, has_member_card = ' || quote_literal(NEW.has_member_card) || ' WHERE dni = ' || quote_literal(OLD.dni));
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insertar_en_empleados()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM dblink_exec('conexion_bbdd2_pr3_1', 'INSERT INTO Empleado (dni, nombre, apellidos, fecha_nacimiento, edad, email, genero, telefono, codigo_empleado, CIF_tienda) VALUES (' || quote_literal(NEW.dni) || ', ' || quote_literal(split_part(NEW.full_name, ',', 1)) || ', ' || quote_literal(split_part(NEW.full_name, ',', 2)) || ', ' || quote_literal(NEW.fecha_de_nacimiento) || ',' || quote_literal(NEW.age) || ', ' || quote_literal(NEW.email) || ', ' || quote_literal(NEW.gender) || ', ' || quote_literal(NEW.phone) || ', ' || quote_literal(NEW.employee_number) || ', ' || quote_literal(NEW.CIF_STORE) || ')');
    PERFORM dblink_exec('conexion_bbdd2_pr3_2', 'INSERT INTO PERSON (dni, full_name, fecha_de_nacimiento, phone, email, gender, is_employee, is_client, has_member_card, employee_number, number_of_sales) VALUES (' || quote_literal(NEW.dni) || ', ' || quote_literal(NEW.full_name) || ', ' || quote_literal(NEW.fecha_de_nacimiento) || ', ' || quote_literal(NEW.phone) || ', ' || quote_literal(NEW.email) || ', ' || quote_literal(NEW.gender) || ', TRUE, FALSE,FALSE, ' || quote_literal(NEW.employee_number) || ', ' || quote_literal(NEW.number_of_sales) ||')');
    PERFORM dblink_exec('conexion_bbdd2_pr3_2', 'INSERT INTO WORKS (DNI, CIF_STORE) VALUES (' || quote_literal(NEW.dni) || ', ' || quote_literal(NEW.CIF_STORE) || ')'); 
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION modificar_en_empleados()
RETURNS TRIGGER AS $$
BEGIN   
    PERFORM dblink_exec('conexion_bbdd2_pr3_1', 'UPDATE Empleado SET nombre = ' || quote_literal(split_part(NEW.full_name, ',', 1)) || ', apellidos = ' || quote_literal(split_part(NEW.full_name, ',', 2)) || ', fecha_nacimiento = ' || quote_literal(NEW.fecha_de_nacimiento) || ', edad = ' || quote_literal(NEW.age) || ', email = ' || quote_literal(NEW.email) || ', genero = ' || quote_literal(NEW.gender) || ', telefono = ' || quote_literal(NEW.phone) || ', codigo_empleado = ' || quote_literal(NEW.employee_number) || ', CIF_tienda = ' || quote_literal(NEW.CIF_STORE) || ' WHERE dni = ' || quote_literal(OLD.dni));
    PERFORM dblink_exec('conexion_bbdd2_pr3_2', 'UPDATE PERSON SET full_name = ' || quote_literal(NEW.full_name) || ', fecha_de_nacimiento = ' || quote_literal(NEW.fecha_de_nacimiento) || ', phone = ' || quote_literal(NEW.phone) || ', email = ' || quote_literal(NEW.email) || ', gender = ' || quote_literal(NEW.gender) || ', is_employee = TRUE, is_client = FALSE, has_member_card = FALSE, employee_number = ' || quote_literal(NEW.employee_number) || ', number_of_sales = ' || quote_literal(NEW.number_of_sales) || ' WHERE dni = ' || quote_literal(OLD.dni));
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insertar_en_productos()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM dblink_exec('conexion_bbdd2_pr3_1', 'INSERT INTO Producto (id, CIF_tienda, nombre, descripcion, precio) VALUES (' || quote_literal(NEW.id) || ', ' || quote_literal(NEW.CIF_STORE) || ', ' || quote_literal(NEW.name) || ', ' || quote_literal(NEW.description) || ', ' || quote_literal(NEW.price) || ')');
    PERFORM dblink_exec('conexion_bbdd2_pr3_2', 'INSERT INTO PRODUCT (ID, CIF_STORE, NAME, DESCRIPTION, PRICE) VALUES (' || quote_literal(NEW.id) || ', ' || quote_literal(NEW.CIF_STORE) || ', ' || quote_literal(NEW.name) || ', ' || quote_literal(NEW.description) || ', ' || quote_literal(NEW.price) || ')');
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION modificar_en_productos()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM dblink_exec('conexion_bbdd2_pr3_1', 'UPDATE Producto SET CIF_tienda = ' || quote_literal(NEW.CIF_STORE) || ', nombre = ' || quote_literal(NEW.name) || ', descripcion = ' || quote_literal(NEW.description) || ', precio = ' || quote_literal(NEW.price) || ' WHERE id = ' || quote_literal(OLD.id));
    PERFORM dblink_exec('conexion_bbdd2_pr3_2', 'UPDATE PRODUCT SET CIF_STORE = ' || quote_literal(NEW.CIF_STORE) || ', NAME = ' || quote_literal(NEW.name) || ', DESCRIPTION = ' || quote_literal(NEW.description) || ', PRICE = ' || quote_literal(NEW.price) || ' WHERE ID = ' || quote_literal(OLD.id));
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insertar_en_ventas()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM dblink_exec('conexion_bbdd2_pr3_1', 'INSERT INTO Ventas (id_producto, cif_tienda_producto, codigo_empleado) VALUES (' || quote_literal(NEW.id_producto) || ', ' || quote_literal(NEW.cif_tienda) || ', ' || quote_literal(NEW.employee_number) || ')');
    PERFORM dblink_exec('conexion_bbdd2_pr3_2', 'INSERT INTO PRODUCT (ID, CIF_STORE, DNI_SELLER) VALUES (' || quote_literal(NEW.id_producto) || ', ' || quote_literal(NEW.cif_tienda) || ', ' || quote_literal(NEW.employee_number) || ')');
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION modificar_en_ventas()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM dblink_exec('conexion_bbdd2_pr3_1', 'UPDATE Ventas SET cif_tienda_producto = ' || quote_literal(NEW.cif_tienda) || ', codigo_empleado = ' || quote_literal(NEW.employee_number) || ' WHERE id_producto = ' || quote_literal(OLD.id_producto));
    PERFORM dblink_exec('conexion_bbdd2_pr3_2', 'UPDATE PRODUCT SET CIF_STORE = ' || quote_literal(NEW.cif_tienda) || ', DNI_SELLER = ' || quote_literal(NEW.employee_number) || ' WHERE ID = ' || quote_literal(OLD.id_producto));
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insertar_en_compras()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM dblink_exec('conexion_bbdd2_pr3_1', 'INSERT INTO Compras (id_producto, cif_tienda_producto, dni_cliente) VALUES (' || quote_literal(NEW.id_producto) || ', ' || quote_literal(NEW.cif_tienda) || ', ' || quote_literal(NEW.dni_cliente) || ')');
    PERFORM dblink_exec('conexion_bbdd2_pr3_2', 'INSERT INTO PRODUCT (ID, CIF_STORE, DNI_BUYER) VALUES (' || quote_literal(NEW.id_producto) || ', ' || quote_literal(NEW.cif_tienda) || ', ' || quote_literal(NEW.dni_cliente) || ')');
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION modificar_en_compras()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM dblink_exec('conexion_bbdd2_pr3_1', 'UPDATE Compras SET cif_tienda_producto = ' || quote_literal(NEW.cif_tienda) || ', dni_cliente = ' || quote_literal(NEW.dni_cliente) || ' WHERE id_producto = ' || quote_literal(OLD.id_producto));
    PERFORM dblink_exec('conexion_bbdd2_pr3_2', 'UPDATE PRODUCT SET CIF_STORE = ' || quote_literal(NEW.cif_tienda) || ', DNI_BUYER = ' || quote_literal(NEW.dni_cliente) || ' WHERE ID = ' || quote_literal(OLD.id_producto));
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_insertar_tiendas
INSTEAD OF INSERT ON Tienda_global  
FOR EACH ROW
EXECUTE FUNCTION insertar_en_tiendas();

CREATE TRIGGER trigger_modificar_tiendas
INSTEAD OF UPDATE ON Tienda_global
FOR EACH ROW
EXECUTE FUNCTION modificar_en_tiendas();

CREATE TRIGGER trigger_insertar_clientes
INSTEAD OF INSERT ON Cliente_global
FOR EACH ROW
EXECUTE FUNCTION insertar_en_clientes();

CREATE TRIGGER trigger_modificar_clientes
INSTEAD OF UPDATE ON Cliente_global
FOR EACH ROW
EXECUTE FUNCTION modificar_en_clientes();

CREATE TRIGGER trigger_insertar_empleados
INSTEAD OF INSERT ON Empleado_global
FOR EACH ROW
EXECUTE FUNCTION insertar_en_empleados();

CREATE TRIGGER trigger_modificar_empleados
INSTEAD OF UPDATE ON Empleado_global
FOR EACH ROW
EXECUTE FUNCTION modificar_en_empleados();

CREATE TRIGGER trigger_insertar_productos
INSTEAD OF INSERT ON Producto_global
FOR EACH ROW 
EXECUTE FUNCTION insertar_en_productos();

CREATE TRIGGER trigger_modificar_productos
INSTEAD OF UPDATE ON Producto_global
FOR EACH ROW
EXECUTE FUNCTION modificar_en_productos();

CREATE TRIGGER trigger_insertar_ventas
INSTEAD OF INSERT ON Ventas_global
FOR EACH ROW
EXECUTE FUNCTION insertar_en_ventas();

CREATE TRIGGER trigger_modificar_ventas
INSTEAD OF UPDATE ON Ventas_global
FOR EACH ROW
EXECUTE FUNCTION modificar_en_ventas();

CREATE TRIGGER trigger_insertar_compras
INSTEAD OF INSERT ON Compras_global
FOR EACH ROW
EXECUTE FUNCTION insertar_en_compras();

CREATE TRIGGER trigger_modificar_compras
INSTEAD OF UPDATE ON Compras_global
FOR EACH ROW
EXECUTE FUNCTION modificar_en_compras();


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

