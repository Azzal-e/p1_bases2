-- Datos de ejemplo para la tabla Tienda --
INSERT INTO Tienda (CIF, nombre, direccion)
VALUES 
('111111111', 'Tienda de padel', 'Calle 1, Ciudad 1'),
('222222222', 'Tienda de productos para el gym', 'Calle 2, Ciudad 2');

-- Datos de ejemplo para la tabla Producto --
INSERT INTO Producto (id, CIF_tienda, nombre, descripcion, precio)
VALUES 
(1, '111111111', 'Pelotas de padel', 'Paquete con 3 bolas de padel', 10.00),
(2, '111111111', 'Raqueta de padel', 'Raqueta de padel', 80.00),
(3, '111111111', 'Red de padel', 'Red de padel para un campo reglamentario', 30.00),
(4, '222222222', 'Kit de mancuernas 20kg', 'El kit de 20kg de mancuernas perfecto para entrenar desde casa', 50.00),
(5, '222222222', 'Kit de mancuernas 10kg', 'El kit de 10kg de mancuernas perfecto para entrenar desde casa', 30.00),
(6, '222222222', 'Muñequeras flexibles', 'Las muñequeras perfectas por si tienes dolor en la muñeca en tus entrenamientos', 15.00);

-- Datos de ejemplo para la tabla Cliente --
INSERT INTO Cliente (dni, nombre, apellidos, fecha_nacimiento, edad, email, genero, telefono, es_socio_especial)
VALUES 
('12345678A', 'Juan', 'Pérez López', '1985-05-15', 39, 'juan.perez@example.com', 'HOMBRE', '600123456', TRUE),
('23456789B', 'María', 'Gómez Sánchez', '1990-08-20', 34, 'maria.gomez@example.com', 'MUJER', '600234567', FALSE),
('34567890C', 'Carlos', 'Martínez Ruiz', '1980-03-10', 45, 'carlos.martinez@example.com', 'HOMBRE', '600345678', TRUE),
('45678901D', 'Ana', 'López García', '1995-12-25', 29, 'ana.lopez@example.com', 'MUJER', '600456789', FALSE),
('56789012E', 'Luis', 'Hernández Fernández', '1975-07-30', 49, 'luis.hernandez@example.com', 'HOMBRE', '600567890', TRUE),
('67890123F', 'Laura', 'Torres Jiménez', '2000-01-05', 25, 'laura.torres@example.com', 'MUJER', '600678901', FALSE),
('78901234G', 'David', 'Ramírez Morales', '1988-09-18', 36, 'david.ramirez@example.com', 'HOMBRE', '600789012', TRUE),
('89012345H', 'Elena', 'Castro Díaz', '1992-11-11', 32, 'elena.castro@example.com', 'MUJER', '600890123', FALSE),
('90123456I', 'Javier', 'Ortega Pérez', '1983-04-22', 41, 'javier.ortega@example.com', 'HOMBRE', '600901234', TRUE),
('01234567J', 'Sofía', 'Navarro Romero', '1998-06-14', 26, 'sofia.navarro@example.com', 'MUJER', '600012345', FALSE);

-- Datos de ejemplo para la tabla Empleado --
INSERT INTO Empleado (dni, nombre, apellidos, fecha_nacimiento, edad, email, genero, telefono, codigo_empleado, CIF_tienda)
VALUES 
('11111111A', 'Pedro', 'García López', '1980-02-15', 45, 'pedro.garcia@example.com', 'HOMBRE', '600111111', 1, '111111111'),
('22222222B', 'Lucía', 'Martínez Sánchez', '1992-07-10', 32, 'lucia.martinez@example.com', 'MUJER', '600222222', 2, '111111111'),
('33333333C', 'Miguel', 'Hernández Ruiz', '1985-11-20', 39, 'miguel.hernandez@example.com', 'HOMBRE', '600333333', 3, '222222222'),
('44444444D', 'Laura', 'Gómez Fernández', '1990-05-05', 34, 'laura.gomez@example.com', 'MUJER', '600444444', 4, '222222222'),
('55555555E', 'Javier', 'Pérez Jiménez', '1978-03-25', 47, 'javier.perez@example.com', 'HOMBRE', '600555555', 5, '111111111'),
('66666666F', 'Ana', 'López Torres', '1995-09-15', 29, 'ana.lopez@example.com', 'MUJER', '600666666', 6, '222222222'),
('77777777G', 'Carlos', 'Ramírez Castro', '1983-01-30', 42, 'carlos.ramirez@example.com', 'HOMBRE', '600777777', 7, '111111111'),
('88888888H', 'Elena', 'Díaz Ortega', '1988-06-18', 36, 'elena.diaz@example.com', 'MUJER', '600888888', 8, '222222222'),
('99999999I', 'David', 'Morales Navarro', '1982-12-12', 42, 'david.morales@example.com', 'HOMBRE', '600999999', 9, '111111111'),
('00000000J', 'Sofía', 'Romero Vega', '1997-04-22', 27, 'sofia.romero@example.com', 'MUJER', '600000000', 10, '222222222');

-- Datos de ejemplo para la tabla Ventas --
INSERT INTO Ventas (id_producto, CIF_tienda_producto, codigo_empleado)
VALUES 
(1, '111111111', 1), -- Pelotas de padel vendidas por Pedro
(2, '111111111', 2), -- Raqueta de padel vendida por Lucía
(3, '111111111', 1), -- Red de padel vendida por Pedro
(4, '222222222', 3), -- Kit de mancuernas 20kg vendido por Miguel
(5, '222222222', 4), -- Kit de mancuernas 10kg vendido por Laura
(6, '222222222', 4); -- Muñequeras flexibles vendidas por Laura

-- Datos de ejemplo para la tabla Compras --
INSERT INTO Compras (id_producto, CIF_tienda_producto, dni_cliente)
VALUES 
(1, '111111111', '12345678A'), -- Juan compra Pelotas de padel
(2, '111111111', '23456789B'), -- María compra Raqueta de padel
(3, '111111111', '34567890C'), -- Carlos compra Red de padel
(4, '222222222', '45678901D'), -- Ana compra Kit de mancuernas 20kg
(5, '222222222', '56789012E'), -- Luis compra Kit de mancuernas 10kg
(6, '222222222', '67890123F'); -- Laura compra Muñequeras flexibles
