-- Eliminar tablas en orden inverso de dependencias
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Operacion CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Titular CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Cuentas CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Oficinas CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Clientes CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

------------------------------ CREAR TABLAS -----------------------------------------
-- 1. Clientes (sin dependencias)
CREATE TABLE Clientes (
    DNI VARCHAR2(20) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    apellidos VARCHAR2(75) NOT NULL,
    direccion VARCHAR2(200) NOT NULL,
    telefono VARCHAR2(16) NOT NULL CHECK (telefono LIKE '+%'),
    email VARCHAR2(100) NOT NULL CHECK (email LIKE '%@%'),
    fechaNacimiento DATE NOT NULL
);

-- 2. Oficinas (sin dependencias)
CREATE TABLE Oficinas (
    codigoOficina NUMBER(4) PRIMARY KEY,
    direccion VARCHAR2(200) NOT NULL,
    telefono VARCHAR2(16) NOT NULL CHECK (telefono LIKE '+%')
);

-- 3. Cuentas (depende de Oficinas)
CREATE TABLE Cuentas (
    prefijoIBAN VARCHAR2(4) NOT NULL,
    numeroCuenta VARCHAR2(30) NOT NULL,
    IBAN VARCHAR2(34) GENERATED ALWAYS AS (prefijoIBAN || numeroCuenta) VIRTUAL,
    fechaCreacion DATE DEFAULT SYSDATE NOT NULL,
    saldo NUMBER(15,2) DEFAULT 0 NOT NULL,
    esCuentaCorriente NUMBER(1) NOT NULL CHECK (esCuentaCorriente IN (0,1)),
    interes NUMBER(5,2),
    codigoOficina_Adscrita NUMBER(4),
    PRIMARY KEY (prefijoIBAN, numeroCuenta),
    FOREIGN KEY (codigoOficina_Adscrita) REFERENCES Oficinas(codigoOficina),
    CONSTRAINT chk_saldo CHECK (saldo >= 0),
    CONSTRAINT chk_especializacion CHECK (
        (esCuentaCorriente = 1 AND interes IS NULL AND codigoOficina_Adscrita IS NOT NULL) OR
        (esCuentaCorriente = 0 AND interes IS NOT NULL AND codigoOficina_Adscrita IS NULL)
    )
);

-- 4. Titular (depende de Clientes y Cuentas)
CREATE TABLE Titular (
    DNI_Titular VARCHAR2(20),
    prefijoIBAN VARCHAR2(4),
    numeroCuenta VARCHAR2(30),
    PRIMARY KEY (DNI_Titular, prefijoIBAN, numeroCuenta),
    FOREIGN KEY (DNI_Titular) REFERENCES Clientes(DNI) ON DELETE CASCADE,
    FOREIGN KEY (prefijoIBAN, numeroCuenta) REFERENCES Cuentas(prefijoIBAN, numeroCuenta) ON DELETE CASCADE
);

-- 5. Operacion (depende de Cuentas y Oficinas)
CREATE TABLE Operacion (
    codigo INT,
    prefijoIBAN_cuentaEmisora VARCHAR2(4),
    numeroCuenta_cuentaEmisora VARCHAR2(30),
    fechaOperacion DATE DEFAULT SYSDATE NOT NULL,
    descripcion VARCHAR2(200),
    cuantia NUMBER(15,2) NOT NULL CHECK (cuantia > 0),
    tipoOperacion VARCHAR2(15) NOT NULL CHECK (tipoOperacion IN ('INGRESO', 'RETIRADA', 'TRANSFERENCIA')),
    prefijoIBAN_cuentaReceptora VARCHAR2(4),
    numeroCuenta_cuentaReceptora VARCHAR2(30),
    codigo_Sucursal NUMBER(4),  -- Cambiado a NUMBER(4) para coincidir con Oficinas.codigoOficina
    PRIMARY KEY (codigo, prefijoIBAN_cuentaEmisora, numeroCuenta_cuentaEmisora),
    FOREIGN KEY (prefijoIBAN_cuentaEmisora, numeroCuenta_cuentaEmisora) 
        REFERENCES Cuentas(prefijoIBAN, numeroCuenta) ON DELETE CASCADE,
    FOREIGN KEY (prefijoIBAN_cuentaReceptora, numeroCuenta_cuentaReceptora)
        REFERENCES Cuentas(prefijoIBAN, numeroCuenta) ON DELETE SET NULL,
    FOREIGN KEY (codigo_Sucursal) REFERENCES Oficinas(codigoOficina) ON DELETE SET NULL,
    CONSTRAINT chk_operacion_subtipo CHECK (
        (tipoOperacion IN ('INGRESO', 'RETIRADA') AND 
        prefijoIBAN_cuentaReceptora IS NULL AND 
        numeroCuenta_cuentaReceptora IS NULL AND 
        codigo_Sucursal IS NOT NULL)
        OR
        (tipoOperacion = 'TRANSFERENCIA' AND 
        prefijoIBAN_cuentaReceptora IS NOT NULL AND 
        numeroCuenta_cuentaReceptora IS NOT NULL AND 
        codigo_Sucursal IS NULL)
    )
);

------------------------------ TRIGGERS ----------------------------------
-- Trigger para código autoincremental por cuenta
CREATE OR REPLACE TRIGGER trigger_incrementar_codigo
BEFORE INSERT ON Operacion
FOR EACH ROW
DECLARE
    max_codigo NUMBER;
BEGIN
    SELECT COALESCE(MAX(codigo), 0) + 1 INTO max_codigo
    FROM Operacion
    WHERE prefijoIBAN_cuentaEmisora = :NEW.prefijoIBAN_cuentaEmisora
    AND numeroCuenta_cuentaEmisora = :NEW.numeroCuenta_cuentaEmisora;
    :NEW.codigo := max_codigo;
END;
/

-- Trigger para validar fecha de nacimiento
CREATE OR REPLACE TRIGGER trg_validar_fecha_nacimiento
BEFORE INSERT OR UPDATE ON Clientes
FOR EACH ROW
BEGIN
    IF :NEW.fechaNacimiento >= SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'La fecha de nacimiento no puede ser futura');
    END IF;
END;
/

-- Trigger para verificar titularidad mínima
CREATE OR REPLACE TRIGGER trg_verificar_titular
AFTER INSERT ON Cuentas
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM Titular 
    WHERE prefijoIBAN = :NEW.prefijoIBAN 
    AND numeroCuenta = :NEW.numeroCuenta;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Toda cuenta debe tener al menos un titular');
    END IF;
END;
/
