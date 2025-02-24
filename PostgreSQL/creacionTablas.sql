\connect practicas_bd

-- Limpiar claramente objetos anteriores (si existen) para evitar conflictos
DROP TABLE IF EXISTS pruebas CASCADE;
DROP TABLE IF EXISTS pacientes CASCADE;
DROP TABLE IF EXISTS medicos CASCADE;

-- Tabla de médicos
CREATE TABLE medicos (
    dni VARCHAR(9) PRIMARY KEY,
    numLicencia INTEGER NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100) NOT NULL,
    telefono VARCHAR(15)
);

-- Tabla de pacientes
CREATE TABLE pacientes (
    dni VARCHAR(9) PRIMARY KEY,
    nss INTEGER NOT NULL UNIQUE,
    nombre VARCHAR(100),
    telefono VARCHAR(15)
);

-- Tabla de pruebas médicas
CREATE TABLE pruebas (
    id SERIAL PRIMARY KEY,
    dni_medico VARCHAR(9) NOT NULL REFERENCES medicos(dni),
    dni_paciente VARCHAR(9) NOT NULL REFERENCES pacientes(dni),
    tipo_prueba VARCHAR(100),
    fecha DATE,
    resultado VARCHAR(200)
);