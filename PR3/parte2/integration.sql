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
    AS p1(dni VARCHAR(9), full_name VARCHAR(100), fecha_de_nacimiento DATE, age INTEGER, email VARCHAR(250), gender VARCHAR(10), phone VARCHAR(15), employee_number INTEGER, cif_store VARCHAR(9), NUMBER_OF_SALES INTEGER)
    UNION
    SELECT *
    FROM dblink('conexion_bbdd2_pr3_2', 'SELECT p.DNI, p.FULL_NAME, p.FECHA_DE_NACIMIENTO, pa.AGE, p.EMAIL, p.GENDER, p.PHONE, p.EMPLOYEE_NUMBER, w.CIF_STORE, p.NUMBER_OF_SALES FROM PERSON p JOIN PERSON_AGE pa ON pa.DNI = p.DNI JOIN WORKS w ON w.DNI = p.DNI WHERE p.IS_EMPLOYEE = TRUE')
    AS p2(dni VARCHAR(9), full_name VARCHAR(100), fecha_de_nacimiento DATE, age INTEGER, email VARCHAR(250), gender VARCHAR(10), phone VARCHAR(15), employee_number INTEGER, cif_store VARCHAR(9), NUMBER_OF_SALES INTEGER);

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