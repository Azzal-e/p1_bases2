-- Crear la Base de Datos
CREATE DATABASE GESTION;
CONNECT TO GESTION;

-- Crear el Esquema
CREATE SCHEMA MEDICA;
SET CURRENT SCHEMA MEDICA;

-- Crear tabla de médicos
CREATE TABLE MEDICA.MEDICOS (
    dni VARCHAR(9) NOT NULL PRIMARY KEY,
    numLicencia INTEGER NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100) NOT NULL,
    telefono VARCHAR(15)
);

-- Crear tabla de pacientes
CREATE TABLE MEDICA.PACIENTES (
    dni VARCHAR(9) NOT NULL PRIMARY KEY,
    nss INTEGER NOT NULL UNIQUE,
    nombre VARCHAR(100),
    telefono VARCHAR(15)
);

-- Crear tabla de pruebas médicas
CREATE TABLE MEDICA.PRUEBAS (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dni_medico VARCHAR(9) NOT NULL,
    dni_paciente VARCHAR(9) NOT NULL,
    tipo_prueba VARCHAR(100),
    fecha DATE,
    resultado VARCHAR(200),
    FOREIGN KEY (dni_medico) REFERENCES MEDICA.MEDICOS(dni),
    FOREIGN KEY (dni_paciente) REFERENCES MEDICA.PACIENTES(dni)
);

-- Verificar las tablas creadas
LIST TABLES FOR SCHEMA MEDICA;

-- Confirmar la estructura de las tablas
DESCRIBE TABLE MEDICA.MEDICOS;
DESCRIBE TABLE MEDICA.PACIENTES;
DESCRIBE TABLE MEDICA.PRUEBAS;

-- Desconectar de la base de datos
CONNECT RESET;

