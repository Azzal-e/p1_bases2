-- =============================================
-- TitularesGlobales
-- =============================================

SELECT * FROM TitularesGlobales;

-- dni 11111111B
SELECT * FROM TitularesGlobales WHERE DNI = '11111111B';

-- apellido "Doble":
SELECT * FROM TitularesGlobales WHERE apellido1 = 'Doble' OR apellido2 = 'Doble';

-- dirección "Zaragoza"
SELECT COUNT(*) AS Total_Titulares_Zaragoza 
FROM TitularesGlobales 
WHERE direccion LIKE '%Zaragoza%';




-- =============================================
-- CuentasGlobales
-- =============================================

-- saldo > 5000
SELECT * FROM CuentasGlobales WHERE saldo > 5000;

-- ver total de cada tipo
SELECT tipoCuenta, COUNT(*) AS Total 
FROM CuentasGlobales 
GROUP BY tipoCuenta;

-- año 2000
SELECT * FROM CuentasGlobales 
WHERE EXTRACT(YEAR FROM fechaCreacion) = 2000;


-- interés > 1
SELECT iban, interes 
FROM CuentasGlobales 
WHERE interes > 1;




-- =============================================
-- OficinasGlobales
-- =============================================

SELECT codigoOficina, telefono FROM OficinasGlobales;

-- oficinas de zaragoza
SELECT * FROM OficinasGlobales 
WHERE direccion LIKE '%Zaragoza%';




-- =============================================
-- TitularesCuentasGlobal
-- =============================================

SELECT * FROM TitularesCuentasGlobal;

-- dni = 11111111B
SELECT COUNT(*) AS Total_Cuentas 
FROM TitularesCuentasGlobal 
WHERE dni = '11111111B';

SELECT * FROM TitularesCuentasGlobal 
WHERE iban = 'ES9876543210987654321098';




-- =============================================
-- OperacionesGlobales
-- =============================================

SELECT * FROM OperacionesGlobales;

SELECT * FROM OperacionesGlobales
WHERE tipoOperacion = 'TRANSFERENCIA';

SELECT * FROM OperacionesGlobales
WHERE tipoOperacion = 'INGRESO';

-- cantidad de dinero total por sucursal
SELECT sucursal, SUM(cantidad) AS Total 
FROM OperacionesGlobales 
GROUP BY sucursal;

-- ver cuentas sin cuenta receptora
SELECT * FROM OperacionesGlobales 
WHERE cuentaReceptora = 'N/A';