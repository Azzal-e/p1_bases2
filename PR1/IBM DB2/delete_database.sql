-- Conectar a la base de datos GESTION
CONNECT TO GESTION;

-- Eliminar tablas si existen
DROP TABLE MEDICA.MEDICOS IF EXISTS;
DROP TABLE MEDICA.PACIENTES IF EXISTS;
DROP TABLE MEDICA.PRUEBAS IF EXISTS;

-- Eliminar el esquema si existe
DROP SCHEMA MEDICA RESTRICT;

-- Desconectarse de la base de datos
CONNECT RESET;

-- Eliminar la base de datos GESTION
drop database GESTION;
