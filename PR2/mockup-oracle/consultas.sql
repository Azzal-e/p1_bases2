--------------------
-- MOSTRAR DATOS INSERTADOS EN CADA TABLA
--------------------
SELECT * FROM oficina;
SELECT * FROM cliente;
SELECT * FROM cuenta;
SELECT * FROM cuentacorriente;
SELECT * FROM cuentaahorro;
SELECT * FROM operacion;
SELECT * FROM operacionefectiva;
SELECT * FROM transferencia;

--------------------
-- CLIENTES Y SUS CUENTAS
--------------------
SELECT cl.nombre, cl.apellidos, c.cuenta_iban.PREFIJOIBAN, c.cuenta_iban.NUMEROCUENTA, c.saldo 
FROM cliente cl, cuenta c 
WHERE c.ref_titular = REF(cl);

--------------------
-- CLIENTE SIN CUENTAS --> DEBE FALLAR POR TRIGGER
--------------------
INSERT INTO cliente VALUES (
  DNI('12345678X'), 'Cliente Prueba', 'Apellido Prueba', 
  TO_DATE('2000-01-01', 'YYYY-MM-DD'), 
  TELEFONO('+34678901234'), 'Calle Falsa 123', 'email@prueba.com'
);

-------------------
-- CUENTAS SIN ESPECIALIZACIÓN --> DEBE FALLAR POR TRIGGER 
-------------------
INSERT INTO cuenta VALUES (
  IBAN('ES99', '00000000000000000000'),
  SYSDATE - 10, 1000.00, 
  (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '12345678X')
);

