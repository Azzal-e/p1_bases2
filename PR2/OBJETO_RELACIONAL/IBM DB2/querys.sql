-- Cuenta el número de oficinas creadas
SELECT COUNT(*)
FROM banco.OFICINA;

-- Devuelve toda la información de las cuentas sabiendo que hace referencia al cliente 1
SELECT c.*
FROM BANCO.CUENTA c
WHERE CAST(c.REFTITULAR AS integer) = 1;

-- Devuelve toda la información de las cuentas sabiendo el nombre de un cliente ordenando los datos por el saldo en descenso.
SELECT c.*
FROM banco.CLIENTE cli
JOIN banco.cuenta c ON CAST(c.reftitular AS integer) = CAST(cli.oid AS integer)
WHERE CAST(cli.nombre AS varchar(20)) LIKE 'Kally'
ORDER BY C.SALDO DESC;
