-- Script para insertar y modificar datos con el usuario escritor
\connect practicas_bd

-- Limpiar tablas antes de insertar datos
DELETE FROM pruebas;
DELETE FROM pacientes;
DELETE FROM medicos;

-- Insertar datos en la tabla medicos
INSERT INTO medicos (dni, numlicencia, nombre, especialidad, telefono)
VALUES ('12345678A', 12345, 'Dr. Izquierdo', 'M.Familia', '876000111');

-- Insertar datos en la tabla pacientes
INSERT INTO pacientes (dni, nss, nombre, telefono)
VALUES ('87654321B', 987654321, 'Ada Byron', '699654321');

-- Insertar datos en la tabla pacientes
INSERT INTO pacientes (dni, nss, nombre, telefono)
VALUES ('87654321X', 987654322, 'Nadie', '699654322');

-- Insertar datos en la tabla pruebas
INSERT INTO pruebas (id_medico, id_paciente, tipo_prueba, fecha, resultado)
VALUES ('12345678A', '87654321B', 'muestra de orina', '2025-02-17', 'DATO1 : X');

-- Modificar datos (cambiar número de teléfono del paciente)
UPDATE pacientes SET telefono = '655888999' WHERE dni = '87654321B';
