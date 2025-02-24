INSERT INTO medicos (dni, numLicencia, nombre, especialidad, telefono) 
VALUES ('12345678A', 'MED123', 'Dr. López', 'Cardiología', '600123456');

INSERT INTO medicos (dni, numLicencia, nombre, especialidad, telefono) 
VALUES ('87654321B', 'MED456', 'Dra. Martínez', 'Neurología', '699654321');

INSERT INTO pacientes (dni, nss, nombre, telefono) 
VALUES ('11111111C', 'NSS001', 'Ana Gómez', '655555555');

INSERT INTO pacientes (dni, nss, nombre, telefono) 
VALUES ('22222222D', 'NSS002', 'Carlos Pérez', '644444444');

INSERT INTO pruebas (id, dni_medico,  dni_paciente,  tipo_prueba, fecha, resultado) 
VALUES (uuid(), '12345678A', '11111111C',  'Electrocardiograma', toTimestamp(now()), 'Normal');

SELECT * FROM medicos;
SELECT * FROM pacientes;
SELECT * FROM pruebas;
