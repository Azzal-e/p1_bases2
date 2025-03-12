-- Limpiar tablas previamente si ya existen 
DROP TABLE IF EXISTS practicas_ks.pruebas;
DROP TABLE IF EXISTS practicas_ks.medicos;
DROP TABLE IF EXISTS practicas_ks.pacientes;
USE practicas_ks;

-- Crear tabla 'medicos' 
CREATE TABLE medicos (
    dni TEXT PRIMARY KEY,
    numLicencia TEXT,
    nombre TEXT,
    especialidad TEXT,
    telefono TEXT
);

-- Crear tabla 'pacientes' 
CREATE TABLE pacientes (
    dni TEXT PRIMARY KEY,
    nss TEXT,
    nombre TEXT,
    telefono TEXT
);

-- Crear tabla 'pruebas' 
CREATE TABLE pruebas (
    id UUID PRIMARY KEY,
    dni_medico TEXT,
    nombre_medico TEXT,    -- Nombre médico desnormalizado
    dni_paciente TEXT,
    nombre_paciente TEXT,  -- Nombre paciente desnormalizado
    tipo_prueba TEXT,
    fecha TIMESTAMP,
    resultado TEXT
);

-- Verificar creación
DESCRIBE TABLES;
