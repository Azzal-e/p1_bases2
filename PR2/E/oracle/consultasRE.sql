--------------------
-- INSERCIONES
--------------------
INSERT INTO Clientes (DNI, nombre, apellidos, direccion, telefono, email, fechaNacimiento)
VALUES ('12345678A', 'Juan', 'Pérez', 'Calle Falsa 123', '+34123456789', 'juan@example.com', TO_DATE('1990-01-01', 'YYYY-MM-DD'));

INSERT INTO Clientes (DNI, nombre, apellidos, direccion, telefono, email, fechaNacimiento)
VALUES ('87654321B', 'Ana', 'Gómez', 'Avenida Real 456', '+34987654321', 'ana@example.com', TO_DATE('1985-05-15', 'YYYY-MM-DD'));

INSERT INTO Oficinas (codigoOficina, direccion, telefono)
VALUES (1001, 'Plaza Mayor 1', '+34911222333');

INSERT INTO Oficinas (codigoOficina, direccion, telefono)
VALUES (1002, 'Calle Gran Vía 2', '+34944555666');

ALTER TRIGGER trg_verificar_titular DISABLE;

INSERT INTO Cuentas (prefijoIBAN, numeroCuenta, esCuentaCorriente, codigoOficina_Adscrita)
VALUES ('ES', '1234567890123456789012', 1, 1001);

INSERT INTO Cuentas (prefijoIBAN, numeroCuenta, esCuentaCorriente, interes)
VALUES ('ES', '9876543210987654321098', 0, 2.5);

INSERT INTO Titular (DNI_Titular, prefijoIBAN, numeroCuenta)
VALUES ('12345678A', 'ES', '1234567890123456789012');

INSERT INTO Titular (DNI_Titular, prefijoIBAN, numeroCuenta)
VALUES ('87654321B', 'ES', '9876543210987654321098');

ALTER TRIGGER trg_verificar_titular ENABLE;

INSERT INTO Operacion (prefijoIBAN_cuentaEmisora, numeroCuenta_cuentaEmisora, descripcion, cuantia, tipoOperacion, codigo_Sucursal)
VALUES ('ES', '1234567890123456789012', 'Ingreso inicial', 1000.00, 'INGRESO', 1001);

INSERT INTO Operacion (prefijoIBAN_cuentaEmisora, numeroCuenta_cuentaEmisora, prefijoIBAN_cuentaReceptora, numeroCuenta_cuentaReceptora, descripcion, cuantia, tipoOperacion)
VALUES ('ES', '1234567890123456789012', 'ES', '9876543210987654321098', 'Transferencia a ahorros', 500.00, 'TRANSFERENCIA');

--------------------
-- CONSULTAS
--------------------

SELECT * FROM Clientes;


SELECT * FROM Oficinas;


SELECT prefijoIBAN, numeroCuenta, IBAN, saldo, esCuentaCorriente, interes, codigoOficina_Adscrita
FROM Cuentas;


SELECT c.DNI, c.nombre, c.apellidos
FROM Titular t
JOIN Clientes c ON t.DNI_Titular = c.DNI
WHERE t.prefijoIBAN = 'ES' AND t.numeroCuenta = '1234567890123456789012';


SELECT codigo, fechaOperacion, descripcion, cuantia, tipoOperacion, prefijoIBAN_cuentaReceptora, numeroCuenta_cuentaReceptora, codigo_Sucursal
FROM Operacion
WHERE prefijoIBAN_cuentaEmisora = 'ES' AND numeroCuenta_cuentaEmisora = '1234567890123456789012';


SELECT saldo
FROM Cuentas
WHERE prefijoIBAN = 'ES' AND numeroCuenta = '1234567890123456789012';


SELECT *
FROM Operacion
WHERE tipoOperacion = 'TRANSFERENCIA';


SELECT *
FROM Cuentas
WHERE esCuentaCorriente = 0;


SELECT *
FROM Cuentas
WHERE esCuentaCorriente = 1;


SELECT o.codigo, o.fechaOperacion, o.descripcion, o.cuantia, o.tipoOperacion
FROM Operacion o
WHERE o.codigo_Sucursal = 1001;