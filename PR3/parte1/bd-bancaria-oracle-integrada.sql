------------------
-- CLIENTES
------------------
CREATE OR REPLACE VIEW TitularesGlobales AS
SELECT 
    DNI, 
    nombre, 
    COALESCE(SUBSTR(apellidos, 1, INSTR(apellidos, ' ') - 1), 'NULL') AS apellido1, 
    COALESCE(SUBSTR(apellidos, INSTR(apellidos, ' ') + 1), 'NULL') AS apellido2, 
    direccion, 
    telefono, 
    fechaNacimiento,
    email
FROM Clientes
UNION
SELECT 
    t.DNI, 
    t.NOMBRE, 
    t.APELLIDO1, 
    t.APELLIDO2,
    d.CALLE || ', ' || d.NUMERO || ' ' || d.PISO || ', ' || d.CIUDAD AS direccion,
    t.TELEFONO, 
    t.FECHA_NACIMIENTO,
    null as email
FROM TITULAR@SCHEMA2BD2 t
JOIN DIRECCION@SCHEMA2BD2 d ON t.DIRECCION = d.ID_DIRECCION;

--------------------
-- CUENTAS
--------------------
CREATE OR REPLACE VIEW CuentasGlobales AS
SELECT 
    prefijoIBAN || numeroCuenta AS iban,
    fechaCreacion,
    saldo,
    CASE 
        WHEN esCuentaCorriente = 1 THEN 'CORRIENTE'
        ELSE 'AHORRO'
    END AS tipoCuenta,
    CASE 
        WHEN esCuentaCorriente = 1 THEN NULL
        ELSE interes
    END AS interes,
    CASE 
        WHEN esCuentaCorriente = 1 THEN TO_CHAR(codigoOficina_Adscrita)
        ELSE NULL
    END AS codigoOficina
FROM Cuentas
UNION ALL
SELECT 
    C.CCC AS iban,
    C.FECHACREACION,
    C.SALDO,
    CASE 
        WHEN CC.CCC IS NOT NULL THEN 'CORRIENTE'
        ELSE 'AHORRO'
    END AS tipoCuenta,
    CASE 
        WHEN CC.CCC IS NOT NULL THEN NULL
        ELSE A.TIPOINTERES
    END AS interes,
    CASE 
        WHEN CC.CCC IS NOT NULL THEN TO_CHAR(CC.SUCURSAL_CODOFICINA)
        ELSE NULL
    END AS codigoOficina
FROM CUENTA@SCHEMA2BD2 C
LEFT JOIN CUENTACORRIENTE@SCHEMA2BD2 CC ON C.CCC = CC.CCC
LEFT JOIN CUENTAAHORRO@SCHEMA2BD2 A ON C.CCC = A.CCC;


---------------------
-- OFICINAS
---------------------
CREATE OR REPLACE VIEW OficinasGlobales AS
SELECT 
    codigoOficina,
    direccion,
    TO_CHAR(telefono) AS telefono
FROM Oficinas
UNION ALL
SELECT 
    CODOFICINA,
    DIR,
    TO_CHAR(TFNO)
FROM SUCURSAL@SCHEMA2BD2;


---------------------
-- CLIENTES-CUENTAS
---------------------
CREATE OR REPLACE VIEW TitularesCuentasGlobal AS
SELECT 
    DNI_Titular AS dni,
    prefijoIBAN || numeroCuenta AS iban
FROM Titular
UNION ALL  
SELECT 
    TITULAR AS dni,
    CCC AS iban
FROM CUENTA@SCHEMA2BD2;


---------------------
-- OPERACIONES
---------------------
CREATE OR REPLACE VIEW OperacionesGlobales AS
SELECT
    TO_CHAR(codigo) AS numop,             
    TRIM(descripcion) AS descripcion,     
    TO_CHAR(fechaOperacion, 'YYYY-MM-DD') AS fechaOperacion, 
    CAST(NULL AS VARCHAR2(5)) AS hora,   
    TO_CHAR(cuantia) AS cantidad,         
    UPPER(TRIM(tipoOperacion)) AS tipoOperacion, 
    TRIM(prefijoIBAN_cuentaEmisora) || TRIM(numeroCuenta_cuentaEmisora) AS cuentaEmisora, 
    TRIM(prefijoIBAN_cuentaReceptora) || TRIM(numeroCuenta_cuentaReceptora) AS cuentaReceptora, 
    TO_CHAR(codigo_Sucursal) AS sucursal   
FROM Operacion
UNION ALL
SELECT
    TO_CHAR(o.NUMOP),                      
    TRIM(o.DESCRIPCIONOP),                 
    TO_CHAR(o.FECHAOP, 'YYYY-MM-DD'),       
    TRIM(o.HORAOP),                       
    TO_CHAR(o.CANTIDADOP),                
    CASE
        WHEN e.TIPOOPEFECTIVO IS NOT NULL THEN UPPER(TRIM(e.TIPOOPEFECTIVO)) 
        WHEN t.CUENTADESTINO IS NOT NULL THEN 'TRANSFERENCIA'
        ELSE 'OTRO'
    END AS tipoOperacion,
    TRIM(o.CCC) AS cuentaEmisora,           
    NVL(TRIM(t.CUENTADESTINO), '') AS cuentaReceptora, 
    TO_CHAR(e.SUCURSAL_CODOFICINA) AS sucursal 
FROM OPERACION@SCHEMA2BD2 o
LEFT JOIN OPEFECTIVO@SCHEMA2BD2 e 
    ON TO_CHAR(o.NUMOP) = TO_CHAR(e.NUMOP)  
    AND TRIM(o.CCC) = TRIM(e.CCC)          
LEFT JOIN OPTRANSFERENCIA@SCHEMA2BD2 t 
    ON TO_CHAR(o.NUMOP) = TO_CHAR(t.NUMOP) 
    AND TRIM(o.CCC) = TRIM(t.CCC);