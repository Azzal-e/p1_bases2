-- Conectar a la base de datos GESTION
CONNECT TO GESTION;

-- Consultar y listar médicos si hay registros
SELECT * FROM MEDICA.MEDICOS
WHERE (SELECT COUNT(*) FROM MEDICA.MEDICOS) > 0;

-- Consultar y listar pacientes si hay registros
SELECT * FROM MEDICA.PACIENTES
WHERE (SELECT COUNT(*) FROM MEDICA.PACIENTES) > 0;

-- Consultar y listar pruebas si hay registros
SELECT * FROM MEDICA.PRUEBAS
WHERE (SELECT COUNT(*) FROM MEDICA.PRUEBAS) > 0;

-- Desconectar de la base de datos
CONNECT RESET;

