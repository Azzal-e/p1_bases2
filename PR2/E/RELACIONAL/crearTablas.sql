/*IMPLEMENTACIÓN EN ORACLE DE MODELO RELACIONAL*/

-- Eliminar si existe a base de datos y volverla a crear
DROP DATABASE IF EXISTS Banco;
CREATE DATABASE Banco;
USE Banco;

-- Eliminar si existen las tablas y volverlas a crear
DROP TABLE IF EXISTS Operacion CASCADE;
DROP TABLE IF EXISTS Titular CASCADE;
DROP TABLE IF EXISTS Cuenta CASCADE;
DROP TABLE IF EXISTS Oficina CASCADE;
DROP TABLE IF EXISTS Cliente CASCADE;

/*-- Crear dominios
DECLARE
    v_count NUMBER;
BEGIN
    FOR rec IN (SELECT type_name FROM user_types WHERE type_name IN (
        'TPDNI', 'TPNOMBRE', 'TPAPELLIDOS', 'TPDIRECCION', 'TPTELEFONO', 'TPEMAIL'
        'TPPREFIJO', 'TPNUMERODECUENTA', 'TPIBAN', 'TPCUANTIA', 'TPINTERES'
        'TPCODIGOOFICINA', 'TPCODIGOOPERACION', 'TPDESCRIPCION', 'TPOPERACION')) 
    LOOP
        EXECUTE IMMEDIATE 'DROP TYPE ' || rec.type_name || ' CASCADE';
    END LOOP;
END;
/
create or REPLACE TYPE tpDni as object (
    dni varchar2(20)
);

create or replace type tpNombre as object (
    nombre varchar2(50)
);

create or replace type tpApellidos as object (
    apellidos varchar2(75)
);

create or replace type tpDireccion as object (
    direccion varchar2(200)
);

create or replace type tpTelefono as object (
    telefono varchar2(16)
);

create or replace type tpEmail as object (
    email varchar2(100)
);

create or replace type tpPrefijo as object (
    prefijo varchar2(4)
);

create or replace type tpNumeroCuenta as object (
    numeroCuenta varchar2(30)
);

create or replace type tpIban as object (
    iban varchar2(34)
);

create or replace type tpCantidad as object (
    cantidad number(15,2) -- 15 digitos y 2 decimales
);

create or replace type tpInteres as object (
    interes number(5,2) -- 5 digitos y 2 decimales
);

create or replace type tpCodigoOficina as object (
    codigoOficina NUMBER(4) -- 4 digitos
);

create or replace type tpCodigoOperacion as object (
    codigoOperacion NUMBER -- Código numérico de la operación
);

create or replace type tpDescripcion as object (
    descripcion varchar2(200)
);

create or replace type tpOperacion as object ( -- SSe emula un ENUM
    valor VARCHAR2(15)
    MEMBER FUNCTION validar RETURN BOOLEAN
);
CREATE OR REPLACE TYPE BODY tpOperacion AS
    MEMBER FUNCTION validar RETURN BOOLEAN IS
    BEGIN
        RETURN valor IN ('INGRESO', 'RETIRADA', 'TRANSFERENCIA');
    END;
END;
/
*/
------------------------------CREAR TABLAS----------------------------------------- 

CREATE TABLE Clientes (
    DNI VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(75) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    telefono VARCHAR(16) NOT NULL CONSTRAINT chk_telefono CHECK (telefono LIKE '+%'),
    email VARCHAR(100) NOT NULL CONSTRAINT chk_email CHECK (email LIKE '%@%'),
    fechaNacimiento DATE NOT NULL CONSTRAINT chk_fechaNacimiento CHECK (fechaNacimiento < SYSDATE)
);

CREATE TABLE Oficinas (
    codigoOficina NUMBER(4) PRIMARY KEY,
    direccion VARCHAR(200) NOT NULL,
    telefono VARCHAR(16) NOT NULL CONSTRAINT chk_telefono CHECK (telefono LIKE '+%'),
);

CREATE TABLE Cuentas (
    prefijoIBAN VARCHAR(4) NOT NULL,
    numeroCuenta VARCHAR(30) NOT NULL,
    IBAN VARCHAR(34) NOT NULL UNIQUE,
    fechaCreacion DATE NOT NULL CONSTRAINT chk_fechaCreacion CHECK (fechaCreacion <= SYSDATE),
    saldo NUMBER(15,2) DEFAULT 0 NOT NULL CONSTRAINT chk_saldo CHECK (saldo >= 0),
    esCuentaCorriente BOOLEAN NOT NULL,
    interes NUMBER(5,2) CONSTRAINT chk_interes CHECK (interes >= 0 OR interes IS NULL),
    codigoOficina_Adscrita NUMBER(4),
    FOREIGN KEY (codigoOficina_Adscrita) REFERENCES Oficinas(codigoOficina),
    
    PRIMARY KEY (prefijoIBAN, numeroCuenta) -- Clave Primaria compuesta
    CONSTRAINT chk_IBAN CHECK (IBAN = prefijoIBAN || numeroCuenta) -- Comprobar IBAN = concat (prefijoIBAN, numeroCuenta)
    -- Se añade restricción para mantener la semántica de la especialización de las cuentas: Una cuenta de ahorro debe
    -- tener un tipo de interés y una cuenta corriente no. Además, una cuenta de ahorro no esta adscrita a ninguna oficina,
    -- mientras que una cuenta corriente si que debe estarlo.
    CONSTRAINT chk_especializacion CHECK (
        (esCuentaCorriente = (interes IS NULL)) AND
        (esCuentaCorriente = (codigoOficina_Adscrita IS NOT NULL))
    )
);


CREATE TABLE Titular(
    DNI_Titular VARCHAR(20),
    prefijoIBAN VARCHAR(4),
    numeroCuenta VARCHAR(30),

    PRIMARY KEY (DNI_Titular, prefijoIBAN, numeroCuenta),
    FOREIGN KEY (DNI_Titular) REFERENCES Clientes(DNI) ON DELETE CASCADE,
    FOREIGN KEY (prefijoIBAN, numeroCuenta) REFERENCES Cuentas(prefijoIBAN, numeroCuenta) ON DELETE CASCADE
);

CREATE TABLE Operacion(
    codigo INT CHECK (codigo > 0),
    prefijoIBAN_cuentaEmisora VARCHAR(4),
    numeroCuenta_cuentaEmisora VARCHAR(30),
    fechaOperacion DATE NOT NULL CONSTRAINT chk_fechaOperacion CHECK (fechaOperacion <= SYSDATE),
    descripcion VARCHAR(200),
    cuantia NUMBER(15,2) NOT NULL CHECK (cuantia > 0),
    tipoOperacion VARCHAR(15) NOT NULL CONSTRAINT chk_tipoOperacion CHECK (tipoOperacion IN ('INGRESO', 'RETIRADA', 'TRANSFERENCIA')),
    prefijoIBAN_cuentaReceptora VARCHAR(4),
    numeroCuenta_cuentaReceptora VARCHAR(30),
    codigo_Sucursal VARCHAR(4),

    PRIMARY KEY (codigo, prefijoIBAN_cuentaEmisora, numeroCuenta_cuentaEmisora),

    FOREIGN KEY (prefijoIBAN_cuentaEmisora, numeroCuenta_cuentaEmisora) 
        REFERENCES Cuentas(prefijoIBAN, numeroCuenta) ON DELETE CASCADE,

    FOREIGN KEY (prefijoIBAN_cuentaReceptora, numeroCuenta_cuentaReceptora)
        REFERENCES Cuentas(prefijoIBAN, numeroCuenta) ON DELETE SET NULL,

    FOREIGN KEY (codigo_Sucursal) REFERENCES Oficinas(codigoOficina) ON DELETE SET NULL,

    -- Restriccion de que una cuenta emisora no puede actuar además como receptora en una operacion.
    CONSTRAINT chk_cuenta_emisora_no_receptora CHECK (
        prefijoIBAN_cuentaEmisora <> prefijoIBAN_cuentaReceptora OR
        numeroCuenta_cuentaEmisora <> numeroCuenta_cuentaReceptora
    ),

    -- Añadir restricción debido a la pérdida de semántica de la espacialización de una
    -- operación en sus subtipos.
    CONSTRAINT chk_operacion_subtipo CHECK (
       ((tipoOperacion = 'INGRESO' or tipoOperacion = 'RETIRADA') AND prefijoIBAN_cuentaReceptora IS NULL AND
       numeroCuenta_cuentaReceptora IS NULL AND codigo_Sucursal IS NOT  NULL) OR
       (tipoOperacion='TRANSFERENCIA' AND prefijoIBAN_cuentaReceptora IS NOT NULL AND
       numeroCuenta_cuentaReceptora IS NOT NULL AND codigo_Sucursal IS NULL),
    )
);

-- Creación de triggers para cubrir todas las restricciones no gestionables
-- a nivel de tablas

-- Funcion/Trigger para incrementar el codigo de la operacion por cuenta.
CREATE OR REPLACE FUNCTION incrementar_codigo_operacion
RETURN NUMBER IS
    max_codigo INT;
BEGIN
    SELECT COALESCE(MAX(codigo), 0) + 1 INTO max_codigo
    FROM Operacion
    WHERE prefijoIBAN_cuentaEmisora = :NEW.prefijoIBAN_cuentaEmisora
    AND numeroCuenta_cuentaEmisora = :NEW.numeroCuenta_cuentaEmisora;

    RETURN max_codigo;
END;
/

CREATE OR REPLACE TRIGGER trigger_incrementar_codigo
BEFORE INSERT ON Operacion
FOR EACH ROW
BEGIN
    :NEW.codigo := incrementar_codigo_operacion();
END;
/

-- Trigger para verificar que toda ocurrencia de (prefijoIBAN, numeroCuenta) en Cuentas exista
-- al menos una ocurrencia en Titular.
CREATE OR REPLACE TRIGGER trigger_verificar_titular
BEFORE INSERT ON Cuentas AND UPDATE ON Titular
FOR EACH ROW
DECLARE
    v_existe_titular BOOLEAN;
BEGIN
    SELECT COUNT(*) INTO v_existe_titular
    FROM Titular
    WHERE prefijoIBAN = :NEW.prefijoIBAN
    AND numeroCuenta = :NEW.numeroCuenta;

    IF v_existe_titular = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No existe un titular para la cuenta ' || :NEW.prefijoIBAN || ' ' || :NEW.numeroCuenta);
    END IF;
END;
/


