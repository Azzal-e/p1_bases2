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
-- CLIENTE SIN CUENTAS (NO FALLA PORQUE ES QUE SINO SE ENTRARÍA EN BUCLE)
-- la restricción de cliente está solo si se modifica el cliente
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

-------------------
-- CREAR UNA CUENTA CORRIENTE Y AHORRO PARA UN CLIENTE EXISTENTE
-------------------
INSERT INTO cuentacorriente VALUES (
  IBAN('ES56', '12345678901234567890'),
  SYSDATE - 10, 5000.00,
  (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '12345678X'),
  (SELECT REF(o) FROM oficina o WHERE o.codigoOficina = '0048')
);

SELECT cc.cuenta_iban.PREFIJOIBAN, cc.cuenta_iban.NUMEROCUENTA
FROM cuentacorriente cc
WHERE cc.cuenta_iban.PREFIJOIBAN = 'ES56'
  AND cc.cuenta_iban.NUMEROCUENTA = '12345678901234567890';

SELECT cc.cuenta_iban.PREFIJOIBAN, cc.cuenta_iban.NUMEROCUENTA
FROM cuenta cc
WHERE cc.cuenta_iban.PREFIJOIBAN = 'ES56'
  AND cc.cuenta_iban.NUMEROCUENTA = '12345678901234567890';

DELETE FROM cuentacorriente cc
WHERE cc.cuenta_iban.PREFIJOIBAN = 'ES56'
  AND cc.cuenta_iban.NUMEROCUENTA = '12345678901234567890';

DELETE FROM cuenta cc
WHERE cc.cuenta_iban.PREFIJOIBAN = 'ES56'
  AND cc.cuenta_iban.NUMEROCUENTA = '12345678901234567890';


INSERT INTO cuentaahorro VALUES (
  IBAN('ES56', '09876543210987654321'),  
  SYSDATE - 10,
  3000.00,                            
  (SELECT REF(c) FROM cliente c WHERE c.dni_val.VALOR = '12345678X'), 
  2.5                                   
);

-------------------
-- PROBAR QUE LA FECHA EN LA OPERACIÓN NO SEA FUTURA --> DEBE FALLAR POR TRIGGER
-------------------
INSERT INTO operacion VALUES (
  1001, TO_TIMESTAMP('2025-12-12 14:30:00', 'YYYY-MM-DD HH24:MI:SS'),
  200.00, 'Prueba operación futura',
  (SELECT REF(c) FROM cuenta c WHERE c.cuenta_iban.PREFIJOIBAN = 'ES56' AND c.cuenta_iban.NUMEROCUENTA = '12345678901234567890')
);


INSERT INTO oficina VALUES (
  OFICINAUDT(48, 'Calle Falsa 123, Ciudad Ficticia', TELEFONO('+34 123 456 789')) 
);

SELECT * 
FROM oficina 
WHERE codigoOficina = 0048;
