-- Eliminar tablas hijas primero
DROP TABLE IF EXISTS BANCO.Transferencia;
DROP TABLE IF EXISTS BANCO.OperacionEfectiva;
DROP TABLE IF EXISTS BANCO.CuentaAhorro;
DROP TABLE IF EXISTS BANCO.CuentaCorriente;

-- Eliminar tablas padres después
DROP TABLE IF EXISTS BANCO.Operacion;
DROP TABLE IF EXISTS BANCO.Cuenta;
DROP TABLE IF EXISTS BANCO.Oficina;
DROP TABLE IF EXISTS BANCO.Cliente;

-- Eliminar subtipos de Operacion
DROP TYPE BANCO.OperacionEfectivaUdt;
DROP TYPE BANCO.TransferenciaUdt;

-- Eliminar subtipos de Cuenta
DROP TYPE BANCO.CuentaCorrienteUdt;
DROP TYPE BANCO.CuentaAhorroUdt;

-- Eliminar tipos estructurados principales
DROP TYPE BANCO.OperacionUdt;
DROP TYPE BANCO.OficinaUdt;
DROP TYPE BANCO.CuentaUdt;
DROP TYPE BANCO.ClienteUdt;

-- Eliminar tipo IBAN (estructurado)
DROP TYPE BANCO.IBAN;

-- Eliminar tipos DISTINCT
DROP TYPE BANCO.TELEFONO;
DROP TYPE BANCO.DNI;

--Tipos DISTINCT: DNI y TELEFONO
CREATE DISTINCT TYPE BANCO.DNI AS VARCHAR(20);
CREATE DISTINCT TYPE BANCO.TELEFONO AS VARCHAR(16);

--Tipo IBAN
CREATE TYPE BANCO.IBAN AS (
	prefijoIBAN VARCHAR(4), 
	numeroCuenta VARCHAR(30)
) INSTANTIABLE NOT FINAL REF USING INTEGER MODE DB2SQL;

-- Tipo Cliente
CREATE TYPE BANCO.ClienteUdt AS (
    dni BANCO.DNI,
    nombre VARCHAR(50),
    apellidos VARCHAR(75),
    fechaDeNacimiento DATE,
    telefono BANCO.TELEFONO,
    direccion VARCHAR(200),
    email VARCHAR(250)
) INSTANTIABLE NOT FINAL REF USING INTEGER MODE DB2SQL;

-- Tipo Cuenta
CREATE TYPE BANCO.CuentaUdt AS (
    iban BANCO.IBAN,
    fechaDeCreacion DATE,
    saldo DECIMAL(15,2), 
    refTitular REF(BANCO.ClienteUdt)
) INSTANTIABLE NOT FINAL REF USING INTEGER MODE DB2SQL;

-- Tipo Oficina
CREATE TYPE BANCO.OficinaUdt AS (
    codigoOficina DECIMAL(4,0),
    direccion VARCHAR(100),
    telefono BANCO.TELEFONO
) INSTANTIABLE NOT FINAL REF USING INTEGER MODE DB2SQL;

-- Tipo Operación
CREATE TYPE BANCO.OperacionUdt AS (
    codigo DECIMAL(10,0),
    IBAN_cuentaEmisora BANCO.IBAN,
    fechaYHora TIMESTAMP,
    cuantia DECIMAL(15,2),
    descripcion VARCHAR(200),
    refCuenta_Emisora REF(BANCO.CuentaUdt)
) INSTANTIABLE NOT FINAL REF USING INTEGER MODE DB2SQL;

-- Subtipos de Cuenta
CREATE TYPE BANCO.CuentaCorrienteUdt UNDER BANCO.CuentaUdt AS (
    refOficina_Adscrito REF(BANCO.OficinaUdt) 
) INSTANTIABLE NOT FINAL MODE DB2SQL;

CREATE TYPE BANCO.CuentaAhorroUdt UNDER BANCO.CuentaUdt AS (
    interes DECIMAL(5,2)
) INSTANTIABLE NOT FINAL MODE DB2SQL;

-- Subtipos de Operacion
CREATE TYPE BANCO.OperacionEfectivaUdt UNDER BANCO.OperacionUdt AS (
	tipoOperacion VARCHAR(20),
	refSucursal REF(BANCO.OficinaUdt)
) INSTANTIABLE NOT FINAL MODE DB2SQL;

CREATE TYPE BANCO.TransferenciaUdt UNDER BANCO.OperacionUdt AS (
	refCuenta_Receptora REF(BANCO.CuentaUdt)
) INSTANTIABLE NOT FINAL MODE DB2SQL;

CREATE TABLE BANCO.Cliente OF BANCO.ClienteUdt (
    REF IS oid USER GENERATED,
    PRIMARY KEY(dni),
    dni WITH OPTIONS NOT NULL CHECK (LENGTH(CAST(dni AS VARCHAR(20))) = 9),
    nombre WITH OPTIONS NOT NULL,
    apellidos WITH OPTIONS NOT NULL,
    fechaDeNacimiento WITH OPTIONS NOT NULL, 
    telefono WITH OPTIONS NOT NULL CHECK ((CAST(telefono AS VARCHAR(16))) LIKE '\+\d+'),
    direccion WITH OPTIONS NOT NULL,
    email WITH OPTIONS NOT NULL CHECK (email LIKE '%@%.%')
);

CREATE TABLE BANCO.Cuenta OF BANCO.CuentaUdt (
	REF IS oid USER GENERATED,
	iban WITH OPTIONS NOT NULL,
	fechaDeCreacion WITH OPTIONS NOT NULL,
	saldo WITH OPTIONS NOT NULL CHECK (saldo >= 0),
	refTitular WITH OPTIONS SCOPE BANCO.Cliente
);

CREATE TABLE BANCO.Oficina OF BANCO.OficinaUdt (
	REF IS oid USER GENERATED,
	PRIMARY KEY (codigoOficina),
	codigoOficina WITH OPTIONS NOT NULL,
	direccion WITH OPTIONS NOT NULL, 
    telefono WITH OPTIONS NOT NULL CHECK ((CAST(telefono AS VARCHAR(16))) LIKE '\+\d+')
);

CREATE TABLE BANCO.Operacion OF BANCO.OperacionUdt (
	REF IS oid USER GENERATED,
	PRIMARY KEY (codigo),
	codigo WITH OPTIONS NOT NULL, 
	IBAN_cuentaEmisora WITH OPTIONS NOT NULL,
	fechaYHora WITH OPTIONS NOT NULL,
	cuantia WITH OPTIONS NOT NULL,
	descripcion WITH OPTIONS NOT NULL,
	refCuenta_Emisora WITH OPTIONS SCOPE BANCO.Cuenta
);

CREATE TABLE BANCO.CuentaCorriente OF BANCO.CuentaCorrienteUdt UNDER BANCO.Cuenta INHERIT SELECT PRIVILEGES (
	refOficina_Adscrito WITH OPTIONS SCOPE BANCO.Oficina
);

CREATE TABLE BANCO.CuentaAhorro OF BANCO.CuentaAhorroUdt UNDER BANCO.Cuenta INHERIT SELECT PRIVILEGES (
	interes WITH OPTIONS NOT NULL CHECK (interes >= 0)
);

CREATE TABLE BANCO.OperacionEfectiva OF BANCO.OperacionEfectivaUdt UNDER BANCO.Operacion INHERIT SELECT PRIVILEGES (
	tipoOperacion WITH OPTIONS NOT NULL CHECK (tipoOperacion IN ('INGRESO', 'RETIRADA')),
	refSucursal WITH OPTIONS SCOPE BANCO.Oficina
);

CREATE TABLE BANCO.Transferencia OF BANCO.TransferenciaUdt UNDER BANCO.Operacion INHERIT SELECT PRIVILEGES (
	refCuenta_Receptora WITH OPTIONS SCOPE BANCO.Cuenta
);

