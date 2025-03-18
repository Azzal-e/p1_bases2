-- 1. Consultar TODAS las cuentas (incluyendo especializadas) usando ONLY
SELECT * FROM Cuenta; -- Incluye CuentaCorriente y CuentaAhorro
SELECT * FROM ONLY Cuenta; -- Solo la tabla base (vacía por diseño)

-- 2. Acceder a componentes del tipo IBAN
SELECT 
    (iban).prefijoIBAN AS prefijo, 
    (iban).numeroCuenta AS numero,
    saldo 
FROM CuentaCorriente
WHERE (iban).prefijoIBAN = 'ES12';

-- 3. Operaciones efectivas con ONLY y filtro por tipoOperacion
SELECT codigo, fechaYHora, tipoOperacion, descripcion 
FROM ONLY OperacionEfectiva 
WHERE tipoOperacion = 'INGRESO';

-- 4. Uso de la función get_edad con JOIN
SELECT 
    c.dni, 
    c.nombre, 
    get_edad(c.dni) AS edad,
    COUNT(t.iban_cuenta) AS cuentas_titular
FROM Cliente c
JOIN Titular t ON c.dni = t.dni_Titular
GROUP BY c.dni
HAVING get_edad(c.dni) > 40;

-- 5. Consulta entre tablas heredadas usando CAST
SELECT 
    o.codigo,
    CASE 
        WHEN o::OperacionEfectiva IS NOT NULL THEN 'EFECTIVA' 
        WHEN o::Transferencia IS NOT NULL THEN 'TRANSFERENCIA' 
    END AS tipo_operacion,
    o.cuantia
FROM Operacion o
WHERE o.fechaYHora BETWEEN '2024-01-01' AND '2024-12-31';

-- 6. Actualización usando componentes del IBAN
UPDATE CuentaAhorro 
SET saldo = saldo * 1.02 
WHERE (iban).prefijoIBAN = 'ES56';

-- 7. Consulta de exclusividad (debería devolver 0 filas)
SELECT cc.iban 
FROM CuentaCorriente cc
INNER JOIN CuentaAhorro ca ON cc.iban = ca.iban;

-- 8. Uso de WITH para operaciones complejas
WITH TopClientes AS (
    SELECT 
        t.dni_Titular,
        SUM(c.saldo) AS total_saldo
    FROM Titular t
    JOIN Cuenta c ON t.iban_cuenta = c.iban
    GROUP BY t.dni_Titular
    ORDER BY total_saldo DESC
    LIMIT 5
)
SELECT 
    c.dni,
    c.nombre,
    tc.total_saldo
FROM TopClientes tc
JOIN Cliente c ON tc.dni_Titular = c.dni;

-- 9. Consulta de herencia múltiple (OperacionEfectiva)
SELECT 
    oe.codigo,
    oe.tipoOperacion,
    o.descripcion,
    (oe.IBAN_cuentaEmisora).prefijoIBAN AS prefijo_emisor
FROM OperacionEfectiva oe
JOIN Operacion o ON oe.codigo = o.codigo
WHERE oe.codigo_Sucursal = 8999;

-- 10. Validación de saldo actualizado
SELECT 
    c.iban,
    c.saldo,
    (SELECT SUM(cuantia) 
     FROM Operacion 
     WHERE IBAN_cuentaEmisora = c.iban
    ) AS sum_operaciones
FROM Cuenta c
WHERE c.saldo < 0; -- Debería estar vacío por los triggers