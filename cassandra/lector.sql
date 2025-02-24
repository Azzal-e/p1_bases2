SELECT * FROM pruebas;
SELECT * FROM pruebas WHERE dni_medico = '12345678A';



INSERT INTO pruebas (id, dni_medico,  dni_paciente,  tipo_prueba, fecha, resultado) 
VALUES (uuid(), '99999999E',  '77777777F', 'Test', toTimestamp(now()), 'Pendiente');
