-- BORRAR LAS TABLAS SI EXISTEN -- 
DROP TABLE IF EXISTS Cliente CASCADE;
DROP TABLE IF EXISTS Empleado CASCADE;
DROP TABLE IF EXISTS Producto CASCADE;
DROP TABLE IF EXISTS Tienda CASCADE;
DROP TABLE IF EXISTS Ventas CASCADE;
DROP TABLE IF EXISTS Compras CASCADE;

-- CREACIÓN DE LAS TABLAS --
CREATE TABLE Tienda (
    CIF VARCHAR(9) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    direccion VARCHAR(250) NOT NULL
);

CREATE TABLE Producto (
    id INTEGER,
    CIF_tienda VARCHAR(9) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(250) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL DEFAULT 0 CHECK (precio >= 0),

    CONSTRAINT CHECK_nombre CHECK (nombre <> ''),
    CONSTRAINT CHECK_CIFtienda CHECK (LENGTH(CIF_tienda) = 9),

    PRIMARY KEY (id, CIF_tienda),
    FOREIGN KEY (CIF_tienda) REFERENCES Tienda(CIF) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Cliente (
    dni VARCHAR(9) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    edad INTEGER NOT NULL,
    email VARCHAR(250) CHECK (email SIMILAR TO '%@%.%'),
    genero VARCHAR(6) CHECK (genero IN ('HOMBRE', 'MUJER', 'OTRO')),
    telefono VARCHAR(15) CHECK (telefono SIMILAR TO '^[0-9]{9}$'),

    es_socio_especial BOOLEAN NOT NULL DEFAULT FALSE,

    CONSTRAINT CHECK_dni_length CHECK (LENGTH(dni) = 9),
    CONSTRAINT CHECK_edad CHECK (edad >= 0)
);

CREATE TABLE Empleado (
    dni VARCHAR(9) NOT NULL UNIQUE,
    nombre VARCHAR(20) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    edad INTEGER NOT NULL,
    email VARCHAR(250) CHECK (email SIMILAR TO '%@%.%'),
    genero VARCHAR(10) NOT NULL CHECK (genero IN ('HOMBRE', 'MUJER', 'OTRO')),
    telefono VARCHAR(15) NOT NULL CHECK (telefono SIMILAR TO '^[0-9]{9}$'),

    codigo_empleado INTEGER PRIMARY KEY,
    CIF_tienda VARCHAR(9),

    CONSTRAINT CHECK_dni_length CHECK (LENGTH(dni) = 9),
    CONSTRAINT CHECK_edad CHECK (edad >= 0),
    CONSTRAINT CHECK_codigo_empleado CHECK (codigo_empleado >= 0),
    CONSTRAINT CHECK_CIF_tienda_length CHECK (LENGTH(CIF_tienda) = 9),

    FOREIGN KEY (CIF_tienda) REFERENCES Tienda(CIF) ON DELETE CASCADE
);

CREATE TABLE Ventas (
    id_producto INTEGER,
    CIF_tienda_producto VARCHAR(9) NOT NULL,
    codigo_empleado INTEGER,
    UNIQUE(id_producto, CIF_tienda_producto),
    PRIMARY KEY (id_producto, CIF_tienda_producto, codigo_empleado),
    FOREIGN KEY (id_producto, CIF_tienda_producto) REFERENCES Producto(id, CIF_tienda) ON DELETE CASCADE,
    FOREIGN KEY (codigo_empleado) REFERENCES Empleado(codigo_empleado) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Compras (
    id_producto INTEGER,
    CIF_tienda_producto VARCHAR(9) NOT NULL,
    dni_cliente VARCHAR(9),
    UNIQUE(id_producto, CIF_tienda_producto),
    PRIMARY KEY (id_producto, CIF_tienda_producto , dni_cliente),
    FOREIGN KEY (id_producto, CIF_tienda_producto) REFERENCES Producto(id, CIF_tienda) ON DELETE CASCADE,
    FOREIGN KEY (dni_cliente) REFERENCES Cliente(dni) ON DELETE CASCADE ON UPDATE CASCADE       
);

-- Vista para el número de ventas por empleado --
CREATE VIEW Ventas_por_empleado AS
SELECT e.codigo_empleado, e.nombre, e.apellidos, COUNT(v.id_producto) AS num_ventas
FROM Empleado e
JOIN Ventas v ON e.codigo_empleado = v.codigo_empleado
GROUP BY e.codigo_empleado, e.nombre, e.apellidos
ORDER BY num_ventas DESC;

-- Restricciones
-- Comprobar que vendedor del producto trabaja en la tienda en la que se encuentra el producto
-- Trigger: Producto_BEFORE_INSERT
-- Crear la función para el trigger
CREATE OR REPLACE FUNCTION check_vendedor_en_tienda()
RETURNS TRIGGER AS $$
BEGIN
    -- Comprobar si el empleado (vendedor) trabaja en la tienda del producto
    IF NOT EXISTS (
        SELECT 1
        FROM Empleado e
        WHERE e.codigo_empleado = NEW.codigo_empleado
          AND e.CIF_tienda = NEW.CIF_tienda_producto
    ) THEN
        -- Si no trabaja en la tienda, lanzar un error
        RAISE EXCEPTION 'El vendedor no trabaja en la tienda del producto';
    END IF;

    -- Si la comprobación pasa, devolver la nueva fila
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger que se ejecutará antes de insertar una venta
CREATE TRIGGER check_vendedor_en_tienda_trigger
BEFORE INSERT ON Ventas
FOR EACH ROW
EXECUTE FUNCTION check_vendedor_en_tienda();

-- Trigger para añadir edad
-- Crear la función para calcular la edad
CREATE OR REPLACE FUNCTION calcular_edad()
RETURNS TRIGGER AS $$
BEGIN
    -- Calcular la edad usando la fecha de nacimiento
    NEW.edad := EXTRACT(YEAR FROM AGE(NEW.fecha_nacimiento));

    -- Devolver la nueva fila con la edad calculada
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para la tabla Empleado
CREATE TRIGGER calcular_edad_empleado
BEFORE INSERT ON Empleado
FOR EACH ROW
EXECUTE FUNCTION calcular_edad();

-- Trigger para la tabla Cliente
CREATE TRIGGER calcular_edad_cliente
BEFORE INSERT ON Cliente
FOR EACH ROW
EXECUTE FUNCTION calcular_edad();


-- Comprobar la exclusividad de la especialización
-- Crear la función para verificar duplicados de dni
CREATE OR REPLACE FUNCTION verificar_dni_unico()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar si el dni ya existe en la tabla Cliente
    IF EXISTS (SELECT 1 FROM Cliente WHERE dni = NEW.dni) THEN
        RAISE EXCEPTION 'El DNI % ya está registrado como cliente.', NEW.dni;
    END IF;

    -- Verificar si el dni ya existe en la tabla Empleado
    IF EXISTS (SELECT 1 FROM Empleado WHERE dni = NEW.dni) THEN
        RAISE EXCEPTION 'El DNI % ya está registrado como empleado.', NEW.dni;
    END IF;

    -- Si no hay duplicados, devolver la nueva fila
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para la tabla Empleado
CREATE TRIGGER verificar_dni_empleado
BEFORE INSERT ON Empleado
FOR EACH ROW
EXECUTE FUNCTION verificar_dni_unico();

-- Trigger para la tabla Cliente
CREATE TRIGGER verificar_dni_cliente
BEFORE INSERT ON Cliente
FOR EACH ROW
EXECUTE FUNCTION verificar_dni_unico();