-- Creación de DOMAIN para datos primitivos
CREATE DOMAIN DNI AS VARCHAR(20);
CREATE DOMAIN TELEFONO AS VARCHAR(16);

-- Creación de un tipo compuesto para IBAN
CREATE TYPE IBAN AS (
    prefijoIBAN VARCHAR(4),
    numeroCuenta VARCHAR(30)
);

-- Creación de tipos UDT en PostgreSQL
CREATE TYPE ClienteUdt AS (
    dni DNI,
    nombre VARCHAR(50),
    apellidos VARCHAR(75),
    fechaDeNacimiento DATE,
    telefono TELEFONO,
    direccion VARCHAR(200),
    email VARCHAR(250)
);

CREATE TYPE CuentaUdt AS (
    iban IBAN,
    fechaDeCreacion DATE,
    saldo DECIMAL(15,2) DEFAULT 0
);

-- Creación de tablas con herencia en PostgreSQL
CREATE TABLE Cliente (
    dni DNI PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(75) NOT NULL,
    fechaDeNacimiento DATE NOT NULL CHECK (fechaDeNacimiento < CURRENT_DATE),
    telefono TELEFONO NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    email VARCHAR(250) NOT NULL CHECK (email LIKE '%@%.%')
);

CREATE TABLE Cuenta (
    iban IBAN PRIMARY KEY,
    fechaDeCreacion DATE NOT NULL,
    saldo DECIMAL(15,2) DEFAULT 0 CHECK (saldo >= 0),
    dni_cliente DNI NOT NULL,
    CONSTRAINT fk_cliente FOREIGN KEY (dni_cliente) REFERENCES Cliente(dni) ON DELETE CASCADE
);

-- Creación de subtipos con herencia
CREATE TABLE CuentaCorriente (
    refOficina VARCHAR(10) NOT NULL,
    CONSTRAINT fk_oficina FOREIGN KEY (refOficina) REFERENCES Oficina(codigoOficina) ON DELETE SET NULL
) INHERITS (Cuenta);

CREATE TABLE CuentaAhorro (
    interes DECIMAL(5,2) DEFAULT 0 CHECK (interes >= 0)
) INHERITS (Cuenta);

-- Creación de la tabla Oficina
CREATE TABLE Oficina (
    codigoOficina VARCHAR(10) PRIMARY KEY,
    direccion VARCHAR(100) NOT NULL,
    telefono TELEFONO NOT NULL
);

-- Creación de la tabla Operacion con referencia a Cuenta
CREATE TABLE Operacion (
    codigo SERIAL PRIMARY KEY,
    iban_cuentaEmisora IBAN NOT NULL,
    fechaYHora TIMESTAMP NOT NULL,
    cuantia DECIMAL(15,2) NOT NULL CHECK (cuantia > 0),
    descripcion VARCHAR(200) NOT NULL,
    CONSTRAINT fk_cuenta FOREIGN KEY (iban_cuentaEmisora) REFERENCES Cuenta(iban) ON DELETE CASCADE
);

-- Creación de subtipos de Operación
CREATE TABLE OperacionEfectiva (
    tipoOperacion VARCHAR(20) CHECK (tipoOperacion IN ('INGRESO', 'RETIRADA')),
    refSucursal VARCHAR(10) NOT NULL,
    CONSTRAINT fk_sucursal FOREIGN KEY (refSucursal) REFERENCES Oficina(codigoOficina) ON DELETE CASCADE
) INHERITS (Operacion);

CREATE TABLE Transferencia (
    refCuenta_Receptora IBAN NOT NULL,
    CONSTRAINT fk_cuenta_receptora FOREIGN KEY (refCuenta_Receptora) REFERENCES Cuenta(iban) ON DELETE CASCADE
) INHERITS (Operacion);

-- Trigger para validar que una cuenta no sea emisora y receptora al mismo tiempo
CREATE OR REPLACE FUNCTION validar_transferencia() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.iban_cuentaEmisora = NEW.refCuenta_Receptora THEN
        RAISE EXCEPTION 'Una cuenta no puede ser emisora y receptora en la misma transferencia';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_transferencia
BEFORE INSERT OR UPDATE ON Transferencia
FOR EACH ROW EXECUTE FUNCTION validar_transferencia();