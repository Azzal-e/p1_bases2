-- Datos de ejemplo para la tabla Store
INSERT INTO STORE (CIF, NAME, ADDRESS)
VALUES 
('555555555', 'Tienda de deportes extremos', 'Calle Aventura 123, Ciudad 5'),
('666666666', 'Tienda de ciclismo', 'Avenida Bicicleta 456, Ciudad 6');

-- Datos de ejemplo para la tabla Person
INSERT INTO PERSON (DNI, FULL_NAME, FECHA_DE_NACIMIENTO, PHONE, EMAIL, GENDER, IS_EMPLOYEE, IS_CLIENT, HAS_MEMBER_CARD, EMPLOYEE_NUMBER, NUMBER_OF_SALES)
VALUES 
('11111111Z', 'Andrés López', '1985-01-15', '600111111', 'andres.lopez@example.com', 'HOMBRE', TRUE, FALSE, NULL, 101, 5),
('22222222Y', 'Beatriz Torres', '1990-03-20', '600222222', 'beatriz.torres@example.com', 'MUJER', TRUE, FALSE, NULL, 102, 3),
('33333333X', 'Carlos Díaz', '1982-07-10', '600333333', 'carlos.diaz@example.com', 'HOMBRE', TRUE, FALSE, NULL, 103, 7),
('44444444W', 'Diana Gómez', '1995-11-25', '600444444', 'diana.gomez@example.com', 'MUJER', TRUE, FALSE, NULL, 104, 2),
('55555555V', 'Eduardo Pérez', '1988-06-05', '600555555', 'eduardo.perez@example.com', 'HOMBRE', TRUE, FALSE, NULL, 105, 4),
('66666666U', 'Fernanda Ruiz', '1992-09-15', '600666666', 'fernanda.ruiz@example.com', 'MUJER', FALSE, TRUE, TRUE, NULL, NULL),
('77777777T', 'Gabriel Castro', '1980-12-30', '600777777', 'gabriel.castro@example.com', 'HOMBRE', FALSE, TRUE, FALSE, NULL, NULL),
('88888888S', 'Helena Vega', '1997-04-18', '600888888', 'helena.vega@example.com', 'MUJER', FALSE, TRUE, TRUE, NULL, NULL),
('99999999R', 'Iván Morales', '1983-08-22', '600999999', 'ivan.morales@example.com', 'HOMBRE', FALSE, TRUE, FALSE, NULL, NULL),
('00000000Q', 'Julia Romero', '1990-10-10', '600000000', 'julia.romero@example.com', 'MUJER', FALSE, TRUE, TRUE, NULL, NULL);

-- Datos de ejemplo para la tabla Works -- 
INSERT INTO WORKS (DNI, CIF_STORE)
VALUES 
('11111111Z', '555555555'), -- Andrés trabaja en Tienda de deportes extremos
('22222222Y', '666666666'), -- Beatriz trabaja en Tienda de ciclismo
('33333333X', '555555555'), -- Carlos trabaja en Tienda de deportes extremos
('44444444W', '666666666'), -- Diana trabaja en Tienda de ciclismo
('55555555V', '555555555'); -- Eduardo trabaja en Tienda de deportes extremos

-- Datos de ejemplo para la tabla Product --
INSERT INTO PRODUCT (NAME, PRICE, CIF_STORE, DESCRIPTION, DNI_SELLER, DNI_BUYER)
VALUES 
('Cuerda de escalada', 50.00, '555555555', 'Cuerda de 30 metros para escalada', '11111111Z', '66666666U'),
('Casco de ciclismo', 80.00, '666666666', 'Casco ligero y resistente', '22222222Y', '77777777T'),
('Arnés de seguridad', 120.00, '555555555', 'Arnés para escalada profesional', '33333333X', '88888888S'),
('Bicicleta de montaña', 500.00, '666666666', 'Bicicleta para terrenos difíciles', '44444444W', '99999999R'),
('Mochila de hidratación', 40.00, '555555555', 'Mochila con bolsa de agua de 2L', '55555555V', '00000000Q'),
('Luces para bicicleta', 25.00, '555555555', 'Luces LED para bicicleta', '11111111Z', '66666666U'),
('Mosquetón de escalada', 15.00, '666666666', 'Mosquetón de alta resistencia', '22222222Y', '77777777T'),
('Guantes de ciclismo', 30.00, '555555555', 'Guantes acolchados para ciclismo', '33333333X', '88888888S'),
('Zapatos de escalada', 70.00, '666666666', 'Zapatos con suela adherente', '44444444W', '99999999R'),
('Kit de reparación de bicicleta', 20.00, '555555555', 'Kit básico para reparaciones', '55555555V', '00000000Q');
