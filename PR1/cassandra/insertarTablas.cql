-- Limpiar  datos de tablas
TRUNCATE TABLE practicas_ks.pruebas;
TRUNCATE TABLE practicas_ks.medicos;
TRUNCATE TABLE practicas_ks.pacientes;

-- Insertar datos en tabla 'medicos'
INSERT INTO practicas_ks.medicos (dni, numLicencia, nombre, especialidad, telefono) 
VALUES ('12345678A', 'MED123', 'Dr. López', 'Cardiología', '600123456');

INSERT INTO practicas_ks.medicos (dni, numLicencia, nombre, especialidad, telefono) 
VALUES ('87654321B', 'MED456', 'Dra. Martínez', 'Neurología', '699654321');

-- Insertar datos en tabla 'pacientes'
INSERT INTO practicas_ks.pacientes (dni, nss, nombre, telefono) 
VALUES ('11111111C', 'NSS001', 'Ana Gómez', '655555555');

INSERT INTO practicas_ks.pacientes (dni, nss, nombre, telefono) 
VALUES ('22222222D', 'NSS002', 'Carlos Pérez', '644444444');

-- Insertar datos en tabla 'pruebas'
INSERT INTO practicas_ks.pruebas (
    id, dni_medico, nombre_medico, dni_paciente, nombre_paciente, tipo_prueba, fecha, resultado
) VALUES (
    uuid(),
    '12345678A', 'Dr. López',
    '11111111C', 'Ana Gómez',
    'Electrocardiograma', toTimestamp(now()), 'Normal'
);
