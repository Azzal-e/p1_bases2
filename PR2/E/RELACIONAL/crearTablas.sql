/*IMPLEMENTACIÓN EN ORACLE DE MODELO RELACIONAL*/

/*-- Eliminar si existe a base de datos y volverla a crear
DROP TABLESPACE IF EXISTS Banco;
CREATE TABLESPACE Banco
DATAFILE 'Banco.dbf' SIZE 100M AUTOEXTEND ON;
ALTER USER admin DEFAULT TABLESPACE Banco;
-- Añadir permisos a usuario admin, escritor y lector de tablespace Banco
GRANT CREATE TABLE TO admin;
GRANT CREATE SEQUENCE TO admin;
GRANT CREATE PROCEDURE TO admin;
GRANT CREATE TRIGGER TO admin;
GRANT CREATE VIEW TO admin;

GRANT SELECT ON Banco TO lector;
GRANT SELECT, INSERT, UPDATE ON Banco TO escritor;
GRANT SELECT, INSERT, UPDATE, DELETE ON Banco TO admin;
*/

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


-- Trigger para verificar que ´la fecha de una operación debe ser posterior a la fecha de
-- de creación de la cuenta que actua como emisora, y como receptora (si la hay en este caso).
CREATE OR REPLACE TRIGGER trigger_verificar_fecha_operacion
BEFORE INSERT ON Operacion
FOR EACH ROW
DECLARE
    v_fecha_creacion_Emisora DATE;
    v_fecha_creacion_Receptora DATE;
BEGIN
    SELECT fechaCreacion INTO v_fecha_creacion_Emisora
    FROM Cuentas
    WHERE prefijoIBAN = :NEW.prefijoIBAN_cuentaEmisora
    AND numeroCuenta = :NEW.numeroCuenta_cuentaEmisora;

    IF :NEW.tipoOperacion = 'TRANSFERENCIA' THEN
        SELECT fechaCreacion INTO v_fecha_creacion_Receptora
        FROM Cuentas
        WHERE prefijoIBAN = :NEW.prefijoIBAN_cuentaReceptora
        AND numeroCuenta = :NEW.numeroCuenta_cuentaReceptora;
    END IF;

    IF :NEW.fechaOperacion <= v_fecha_creacion_Emisora OR :NEW.fechaOperacion <= v_fecha_creacion_Receptora THEN
        RAISE_APPLICATION_ERROR(-20002, 'La fecha de la operación no puede ser anterior a la fecha de creación de una cuenta.');
    END IF;
END;
/

--Trigger para verificar que la fecha de nacimiento de un cliente es anterior a la fecha de creacion de una cuente
-- de la que es titular.
CREATE OR REPLACE TRIGGER trigger_verificar_fecha_nacimiento
BEFORE INSERT ON Titular
FOR EACH ROW
DECLARE
    v_fecha_creacion_cuenta DATE;
BEGIN
    SELECT fechaCreacion INTO v_fecha_creacion_cuenta
    FROM Cuentas
    WHERE prefijoIBAN = :NEW.prefijoIBAN
    AND numeroCuenta = :NEW.numeroCuenta;

    IF :NEW.fechaNacimiento >= v_fecha_creacion_cuenta THEN 
        RAISE_APPLICATION_ERROR(-20003, 'La fecha de nacimiento del cliente no puede ser posterior a la fecha de creación de la cuenta.');
    END IF;
END;
/



-- Trigger para calcular el IBAN de una cuenta.
CREATE OR REPLACE TRIGGER trigger_calcular_IBAN
BEFORE INSERT OR UPDATE ON Cuentas
FOR EACH ROW
BEGIN
    IF :NEW.IBAN IS NULL THEN
        :NEW.IBAN := :NEW.prefijoIBAN || :NEW.numeroCuenta;
    END IF;
END;
/

--Trigger para verificar que en una operación, la cuenta emisora no pueda quedar en negativo.
CREATE OR REPLACE TRIGGER trigger_verificar_saldo_cuenta
BEFORE INSERT OR UPDATE ON Operacion
FOR EACH ROW
DECLARE
    v_saldo_cuenta_emisora NUMBER(15,2);
    v_saldo_cuenta_receptora NUMBER(15,2);
BEGIN  
    IF :NEW.tipoOperacion = 'RETIRADA' or :NEW.tipoOperacion = 'TRANSFERENCIA' THEN
        SELECT saldo INTO v_saldo_cuenta_emisora
        FROM Cuentas
        WHERE prefijoIBAN = :NEW.prefijoIBAN_cuentaEmisora
        AND numeroCuenta = :NEW.numeroCuenta_cuentaEmisora;
        IF v_saldo_cuenta_emisora < :NEW.cuantia THEN
            RAISE_APPLICATION_ERROR(-20008, 'La cuenta emisora no puede quedar en negativo.');
        END IF;
    END IF;
END;
/

-- Trigger para actualizar el saldo de una cuenta tras una insertar  una operación.
CREATE OR REPLACE TRIGGER trigger_actualizar_saldo
AFTER INSERT ON Operacion
FOR EACH ROW
BEGIN
    IF :NEW.tipoOperacion = 'INGRESO' THEN
        UPDATE Cuentas SET saldo = saldo + :NEW.cuantia WHERE prefijoIBAN = :NEW.prefijoIBAN_cuentaEmisora AND numeroCuenta = :NEW.numeroCuenta_cuentaEmisora;
    END IF;
    IF :NEW.tipoOperacion = 'RETIRADA'  THEN
        UPDATE Cuentas SET saldo = saldo - :NEW.cuantia WHERE prefijoIBAN = :NEW.prefijoIBAN_cuentaEmisora AND numeroCuenta = :NEW.numeroCuenta_cuentaEmisora;
    END IF;
    IF :NEW.tipoOperacion = 'TRANSFERENCIA' THEN
        UPDATE Cuentas SET saldo = saldo - :NEW.cuantia WHERE prefijoIBAN = :NEW.prefijoIBAN_cuentaEmisora AND numeroCuenta = :NEW.numeroCuenta_cuentaEmisora;
        UPDATE Cuentas SET saldo = saldo + :NEW.cuantia WHERE prefijoIBAN = :NEW.prefijoIBAN_cuentaReceptora AND numeroCuenta = :NEW.numeroCuenta_cuentaReceptora;
    END IF;
END;
/

-- Trigger para actualizar el saldo de una cuentra tras actualizar una operacion.
CREATE OR REPLACE TRIGGER trigger_actualizar_saldo_operacion
AFTER UPDATE ON Operacion
FOR EACH ROW
BEGIN
    IF :NEW.tipoOperacion = 'INGRESO' THEN
        UPDATE Cuentas SET saldo = saldo + :NEW.cuantia - :OLD.cuantia WHERE prefijoIBAN = :NEW.prefijoIBAN_cuentaEmisora AND numeroCuenta = :NEW.numeroCuenta_cuentaEmisora;
    END IF;
    IF :NEW.tipoOperacion = 'RETIRADA' THEN
        UPDATE Cuentas SET saldo = saldo - :NEW.cuantia + :OLD.cuantia WHERE prefijoIBAN = :NEW.prefijoIBAN_cuentaEmisora AND numeroCuenta = :NEW.numeroCuenta_cuentaEmisora;
    END IF;
    IF :NEW.tipoOperacion = 'TRANSFERENCIA' THEN
        UPDATE Cuentas SET saldo = saldo - :NEW.cuantia + :OLD.cuantia WHERE prefijoIBAN = :NEW.prefijoIBAN_cuentaEmisora AND numeroCuenta = :NEW.numeroCuenta_cuentaEmisora;
        UPDATE Cuentas SET saldo = saldo + :NEW.cuantia - :OLD.cuantia WHERE prefijoIBAN = :NEW.prefijoIBAN_cuentaReceptora AND numeroCuenta = :NEW.numeroCuenta_cuentaReceptora;
    END IF;
END;
/


-- Trigger para actualizar el saldo de una cuenta tras eliminar una operación.
CREATE OR REPLACE TRIGGER trigger_actualizar_saldo_operacion_delete
AFTER DELETE ON Operacion
FOR EACH ROW
BEGIN
    IF :OLD.tipoOperacion = 'INGRESO' THEN
        UPDATE Cuentas SET saldo = saldo - :OLD.cuantia WHERE prefijoIBAN = :OLD.prefijoIBAN_cuentaEmisora AND numeroCuenta = :OLD.numeroCuenta_cuentaEmisora;
    END IF;
    IF :OLD.tipoOperacion = 'RETIRADA' THEN
        UPDATE Cuentas SET saldo = saldo + :OLD.cuantia WHERE prefijoIBAN = :OLD.prefijoIBAN_cuentaEmisora AND numeroCuenta = :OLD.numeroCuenta_cuentaEmisora;
    END IF;
    IF :OLD.tipoOperacion = 'TRANSFERENCIA' THEN
        UPDATE Cuentas SET saldo = saldo - :OLD.cuantia WHERE prefijoIBAN = :OLD.prefijoIBAN_cuentaEmisora AND numeroCuenta = :OLD.numeroCuenta_cuentaEmisora;
        UPDATE Cuentas SET saldo = saldo - :OLD.cuantia WHERE prefijoIBAN = :OLD.prefijoIBAN_cuentaReceptora AND numeroCuenta = :OLD.numeroCuenta_cuentaReceptora;
    END IF;
END;
/

-- Crear el procedimiento para actualizar el saldo de las cuentas de ahorro
CREATE OR REPLACE PROCEDURE actualizar_saldo_ahorro IS
BEGIN
    UPDATE Cuentas
    SET saldo = saldo + (saldo * interes / 100)
    WHERE esCuentaCorriente = FALSE;
END;
/

-- Crear el job para ejecutar el procedimiento cada noche
BEGIN
    DBMS_SCHEDULER.create_job (
        job_name        => 'job_actualizar_saldo_ahorro',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN actualizar_saldo_ahorro; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=DAILY; BYHOUR=0; BYMINUTE=0; BYSECOND=0',
        enabled         => TRUE
    );
END;
/







