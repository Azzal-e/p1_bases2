CREATE TABLE medicos (
    dni TEXT PRIMARY KEY,
    numLicencia TEXT,
    nombre TEXT,
    especialidad TEXT,
    telefono TEXT
);

CREATE TABLE pacientes (
    dni TEXT PRIMARY KEY,
    nss TEXT,
    nombre TEXT,
    telefono TEXT
);

CREATE TABLE pruebas (
    id UUID PRIMARY KEY,
    dni_medico TEXT,
    dni_paciente TEXT,
    tipo_prueba TEXT,
    fecha TIMESTAMP,
    resultado TEXT
);

DESCRIBE TABLES;
