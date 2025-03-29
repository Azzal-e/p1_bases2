------------------------------------------------------------------------------
-- TIPOS
------------------------------------------------------------------------------
BEGIN
  FOR obj IN (
    SELECT object_name, object_type
    FROM user_objects
    WHERE object_type = 'TYPE'
      AND object_name IN (
        'OPERACIONEFECTIVAUDT',
        'TRANSFERENCIAUDT',
        'OPERACIONUDT',
        'CUENTACORRIENTEUDT',
        'CUENTAAHORROUDT',
        'CUENTAUDT',
        'CLIENTEUDT',
        'OFICINAUDT',
        'IBAN',
        'TELEFONO',
        'DNI',
        'CLIENTE_REFS'
      )
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'DROP TYPE ' || obj.object_name || ' FORCE';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END LOOP;
END;
/

-- Tipos básicos
-- CREATE OR REPLACE TYPE DNI AS OBJECT (
--   VALOR VARCHAR2(20)
-- ) FINAL;
-- /

-- CREATE OR REPLACE TYPE TELEFONO AS OBJECT (
--   VALOR VARCHAR2(50)
-- ) FINAL;
-- /

-- CREATE OR REPLACE TYPE IBAN AS OBJECT (
--   PREFIJOIBAN VARCHAR2(4),
--   NUMEROCUENTA VARCHAR2(30)
-- ) FINAL;
-- /

-- Tipos principales
CREATE OR REPLACE TYPE OFICINAUDT AS OBJECT (
  CODIGOOFICINA NUMBER(4),
  DIRECCION VARCHAR2(200),
  TEL VARCHAR2(50)
) INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE CLIENTEUDT AS OBJECT (
  DNI_VAL VARCHAR2(20),
  NOMBRE VARCHAR2(50),
  APELLIDOS VARCHAR2(75),
  FECHADENACIMIENTO DATE,
  TEL VARCHAR2(50),
  DIRECCION VARCHAR2(200),
  EMAIL VARCHAR2(250),
  MEMBER FUNCTION CALCULAR_EDAD RETURN NUMBER
) INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY CLIENTEUDT AS
    MEMBER FUNCTION CALCULAR_EDAD RETURN NUMBER IS
    BEGIN
        RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, self.FECHADENACIMIENTO) / 12);
    END CALCULAR_EDAD;
END;
/


CREATE OR REPLACE TYPE CLIENTE_REFS AS VARRAY(50) of REF ClienteUDT;
/

CREATE OR REPLACE TYPE CUENTAUDT AS OBJECT (
  PREFIJOIBAN VARCHAR2(4),
  NUMEROCUENTA VARCHAR2(30),
  FECHACREACION DATE,
  SALDO NUMBER(15,2),
  REF_TITULAR CLIENTE_REFS 
) INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE CUENTACORRIENTEUDT UNDER CUENTAUDT (
  REF_OFICINA REF OFICINAUDT
);
/

CREATE OR REPLACE TYPE CUENTAAHORROUDT UNDER CUENTAUDT (
  INTERES NUMBER(5,2)
);
/ 

CREATE OR REPLACE TYPE OPERACIONUDT AS OBJECT (
  CODIGO NUMBER(10),
  FECHAYHORA TIMESTAMP,
  CUANTIA NUMBER(15,2),
  DESCRIPCION VARCHAR2(4000),
  REF_CUENTAEMISORA REF CUENTAUDT
) INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE OPERACIONEFECTIVAUDT UNDER OPERACIONUDT (
  TIPOOPERACION VARCHAR2(20),
  REF_SUCURSAL REF OFICINAUDT
) INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE TRANSFERENCIAUDT UNDER OPERACIONUDT (
  REF_CUENTARECEPTORA REF CUENTAUDT
) INSTANTIABLE NOT FINAL;
/



---------------------------------------------------------------------------
-- TABLAS
--------------------------------------------------------------------------
BEGIN
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE transferencia CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE operacionefectiva CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE operacion CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE cuentacorriente CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE cuentaahorro CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE cuenta CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE cliente CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN EXECUTE IMMEDIATE 'DROP TABLE oficina CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
END;
/

-- Oficina
CREATE TABLE oficina OF OFICINAUDT (
  CODIGOOFICINA PRIMARY KEY,
  DIRECCION NOT NULL,
  TEL NOT NULL
);

-- Cliente
CREATE TABLE cliente OF CLIENTEUDT (
  DNI_VAL PRIMARY KEY,
  NOMBRE NOT NULL,
  APELLIDOS NOT NULL,
  FECHADENACIMIENTO NOT NULL,
  TEL NOT NULL,
  DIRECCION NOT NULL,
  EMAIL NOT NULL
);

-- Cuenta
CREATE TABLE cuenta OF CUENTAUDT (
  PRIMARY KEY (PREFIJOIBAN, NUMEROCUENTA),
  FECHACREACION NOT NULL,
  SALDO NOT NULL,
  REF_TITULAR NOT NULL
); 

-- Cuenta Corriente
CREATE TABLE cuentacorriente OF CUENTACORRIENTEUDT (
  REF_OFICINA SCOPE IS oficina
); 

-- Cuenta Ahorro
CREATE TABLE cuentaahorro OF CUENTAAHORROUDT (
  INTERES NOT NULL
);

-- Operacion
CREATE TABLE operacion OF OPERACIONUDT (
  CODIGO PRIMARY KEY,
  FECHAYHORA NOT NULL,
  CUANTIA NOT NULL,
  DESCRIPCION NOT NULL,
  REF_CUENTAEMISORA REFERENCES cuenta
);

-- Operacion Efectiva
CREATE TABLE operacionefectiva OF OPERACIONEFECTIVAUDT (
  TIPOOPERACION NOT NULL,
  REF_SUCURSAL REFERENCES oficina
);

-- Transferencia
CREATE TABLE transferencia OF TRANSFERENCIAUDT (
  REF_CUENTARECEPTORA REFERENCES cuenta
);

---------------------------------------------------------------------------
-- TRIGGERS
---------------------------------------------------------------------------
-----------------------------------------
-- 1. Fechas válidas en cliente, cuenta, operación
-----------------------------------------
CREATE OR REPLACE TRIGGER trg_fecha_nacimiento_valida
BEFORE INSERT OR UPDATE ON cliente
FOR EACH ROW
BEGIN
  IF :NEW.fechaDeNacimiento >= SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20010, 'La fecha de nacimiento debe ser anterior a la fecha actual');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_fecha_creacion_valida_cuenta
BEFORE INSERT OR UPDATE ON cuenta
FOR EACH ROW
BEGIN
  IF :NEW.fechaCreacion >= SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20011, 'La fecha de creacion de la cuenta debe ser anterior a la fecha actual');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_fecha_valida_operacion
BEFORE INSERT OR UPDATE ON operacion
FOR EACH ROW
BEGIN
  IF :NEW.fechaYHora >= SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20012, 'La fecha y hora de la operacion debe ser anterior a la fecha actual');
  END IF;
END;
/

-----------------------------------------
-- 2. CUENTAS 
--      - no se permite insertar directamente en cuenta
--      - cuando se crea subclase, se crea clase padre también
-----------------------------------------
CREATE OR REPLACE TRIGGER trg_prevent_insert_cuenta
BEFORE INSERT ON cuenta
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20001, 'No se permite la insercion directa en la tabla CUENTA. Use CUENTACORRIENTE o CUENTAAHORRO.');
END;
/

CREATE OR REPLACE TRIGGER trg_insert_cuentacorriente
BEFORE INSERT ON cuentacorriente
FOR EACH ROW
BEGIN
    INSERT INTO cuenta (
        PREFIJOIBAN,
        NUMEROCUENTA,
        FECHACREACION,
        SALDO,
        REF_TITULAR
    ) VALUES (
        :NEW.PREFIJOIBAN,
        :NEW.NUMEROCUENTA,
        :NEW.FECHACREACION,
        :NEW.SALDO,
        :NEW.REF_TITULAR
    );
END;
/

CREATE OR REPLACE TRIGGER trg_insert_cuentaahorro
BEFORE INSERT ON cuentaahorro
FOR EACH ROW
BEGIN
    INSERT INTO cuenta (
        PREFIJOIBAN,
        NUMEROCUENTA,
        FECHACREACION,
        SALDO,
        REF_TITULAR
    ) VALUES (
        :NEW.PREFIJOIBAN,
        :NEW.NUMEROCUENTA,
        :NEW.FECHACREACION,
        :NEW.SALDO,
        :NEW.REF_TITULAR
    );
END;
/

-----------------------------------------
-- 3. Exclusividad entre subtipos de cuenta
-----------------------------------------
CREATE OR REPLACE TRIGGER trg_exclusividad_corriente
BEFORE INSERT OR UPDATE ON cuentacorriente
FOR EACH ROW
DECLARE
  total_ahorro NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO total_ahorro
  FROM cuentaahorro
  WHERE PREFIJOIBAN = :NEW.PREFIJOIBAN
    AND NUMEROCUENTA = :NEW.NUMEROCUENTA;

  IF total_ahorro > 0 THEN
    RAISE_APPLICATION_ERROR(-20014, 'Una cuenta no puede ser a la vez CORRIENTE y AHORRO');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_exclusividad_ahorro
BEFORE INSERT OR UPDATE ON cuentaahorro
FOR EACH ROW
DECLARE
  total_corriente NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO total_corriente
  FROM cuentacorriente
  WHERE PREFIJOIBAN = :NEW.PREFIJOIBAN
    AND NUMEROCUENTA = :NEW.NUMEROCUENTA;

  IF total_corriente > 0 THEN
    RAISE_APPLICATION_ERROR(-20015, 'Una cuenta no puede ser a la vez AHORRO y CORRIENTE');
  END IF;
END;
/

-----------------------------------------
-- 4. OPERACIONES 
--      - no se permite insertar directamente en operaciones
--      - cuando se crea subclase, se crea clase padre también
-----------------------------------------
CREATE OR REPLACE TRIGGER trg_prevent_insert_operacion
BEFORE INSERT ON operacion
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20002, 'No se permite la insercion directa en la tabla OPERACION. Use OPERACIONEFECTIVA o TRANSFERENCIA.');
END;
/

CREATE OR REPLACE TRIGGER trg_insert_operacionefectiva
BEFORE INSERT ON operacionefectiva
FOR EACH ROW
BEGIN
    -- Insertar en la tabla padre (operacion)
    INSERT INTO operacion (
        CODIGO,
        FECHAYHORA,
        CUANTIA,
        DESCRIPCION,
        REF_CUENTAEMISORA
    ) VALUES (
        :NEW.CODIGO,
        :NEW.FECHAYHORA,
        :NEW.CUANTIA,
        :NEW.DESCRIPCION,
        :NEW.REF_CUENTAEMISORA
    );
END;
/

CREATE OR REPLACE TRIGGER trg_insert_transferencia
BEFORE INSERT ON transferencia
FOR EACH ROW
BEGIN
    -- Insertar en la tabla padre (operacion)
    INSERT INTO operacion (
        CODIGO,
        FECHAYHORA,
        CUANTIA,
        DESCRIPCION,
        REF_CUENTAEMISORA
    ) VALUES (
        :NEW.CODIGO,
        :NEW.FECHAYHORA,
        :NEW.CUANTIA,
        :NEW.DESCRIPCION,
        :NEW.REF_CUENTAEMISORA
    );
END;
/

-----------------------------------------
-- 5. Validación de existencia en transferencias (comprobación de que existan cuenta emisora y receptora)
-----------------------------------------
CREATE OR REPLACE TRIGGER trg_validar_transferencia
BEFORE INSERT OR UPDATE ON transferencia
FOR EACH ROW
DECLARE
  v_emisor_count NUMBER;
  v_receptor_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_emisor_count
  FROM cuenta c
  WHERE REF(c) = :NEW.REF_CUENTAEMISORA; 

  IF v_emisor_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20022, 'La cuenta emisora no existe');
  END IF;

  SELECT COUNT(*) INTO v_receptor_count
  FROM cuenta c
  WHERE REF(c) = :NEW.REF_CUENTARECEPTORA; 

  IF v_receptor_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20023, 'La cuenta receptora no existe');
  END IF;

  IF :NEW.REF_CUENTAEMISORA = :NEW.REF_CUENTARECEPTORA THEN
    RAISE_APPLICATION_ERROR(-20024, 'La cuenta emisora y receptora no pueden ser la misma');
  END IF;
END;
/


-----------------------------------------
-- 6. Validación de cuenta emisora en operación efectiva (comprobación de que exista cuenta emisora y oficina)
-----------------------------------------
CREATE OR REPLACE TRIGGER trg_validar_operacion_efectiva
BEFORE INSERT OR UPDATE ON operacionefectiva
FOR EACH ROW
DECLARE
  v_cuenta_count NUMBER;
  v_oficina_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cuenta_count
  FROM cuenta c
  WHERE REF(c) = :NEW.REF_CUENTAEMISORA; -- Usar REF directamente

  IF v_cuenta_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20020, 'La cuenta emisora no existe');
  END IF;

  SELECT COUNT(*) INTO v_oficina_count
  FROM oficina o
  WHERE REF(o) = :NEW.REF_SUCURSAL; -- Usar REF directamente

  IF v_oficina_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20021, 'La oficina asociada no existe');
  END IF;
END;
/

-----------------------------------------
-- 7. Cliente debe tener al menos una cuenta ( !!! SOLO EN UPDATE, PORQUE SINO SE CREARÍA UN BUCLE ENTRE CLIENTE Y CUENTA)
-----------------------------------------
CREATE OR REPLACE TRIGGER trg_cliente_minimo_una_cuenta
AFTER UPDATE ON cliente
FOR EACH ROW
DECLARE
  total_cuentas_cliente NUMBER;
BEGIN
  SELECT COUNT(*) INTO total_cuentas_cliente
  FROM cuenta c
  WHERE EXISTS (
    SELECT 1
    FROM TABLE(c.REF_TITULAR) t
    WHERE DEREF(t.COLUMN_VALUE).DNI_VAL = :NEW.DNI_VAL
  );

  IF total_cuentas_cliente = 0 THEN
    RAISE_APPLICATION_ERROR(-20020, 'El cliente debe tener al menos una cuenta asociada');
  END IF;
END;
/

-----------------------------------------
-- 8. Cuenta debe tener cliente válido (SIEMPRE DEBE EXISTIR CLIENTE)
-----------------------------------------
CREATE OR REPLACE TRIGGER trg_cuenta_titular_existente
BEFORE INSERT OR UPDATE ON cuenta
FOR EACH ROW
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM TABLE(:NEW.REF_TITULAR) t
  WHERE t.COLUMN_VALUE IS NOT NULL;

  IF v_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20019, 'La cuenta debe tener al menos un titular');
  END IF;
END;
/

-----------------------------------------
-- 9. Cuenta debe mínimo 1 cliente en el array de clientes
-----------------------------------------
CREATE OR REPLACE TRIGGER trg_minimo_cliente
BEFORE INSERT OR UPDATE ON cuenta
FOR EACH ROW
BEGIN
  IF :NEW.REF_TITULAR.COUNT = 0 THEN
    RAISE_APPLICATION_ERROR(-20016, 'La cuenta debe tener al menos 1 cliente asociado.');
  END IF;
END;
/

------------------------------------------
-- 10. Codigo de oficina == 4 (en oficina, en operacionefectiva y en cuenta corriente)
------------------------------------------
CREATE OR REPLACE TRIGGER trg_codigo_oficina
BEFORE INSERT OR UPDATE ON oficina
FOR EACH ROW
BEGIN
  IF LENGTH(TO_CHAR(:NEW.CODIGOOFICINA)) > 4 THEN
    RAISE_APPLICATION_ERROR(-20001, 'El codigo de oficina no puede ser mayor a 4 caracteres.');
  END IF;

  IF LENGTH(TO_CHAR(:NEW.CODIGOOFICINA)) < 4 THEN
    :NEW.CODIGOOFICINA := TO_NUMBER(LPAD(TO_CHAR(:NEW.CODIGOOFICINA), 4, '0'));
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_codigo_oficina_rellenar
BEFORE INSERT OR UPDATE ON operacionefectiva
FOR EACH ROW
DECLARE
    v_codigo VARCHAR2(4);
BEGIN
    SELECT o.codigoOficina INTO v_codigo 
    FROM OFICINA o 
    WHERE REF(o) = :NEW.ref_sucursal;

    IF LENGTH(v_codigo) < 4 THEN
        v_codigo := LPAD(v_codigo, 4, '0');
        
        SELECT REF(o) INTO :NEW.ref_sucursal 
        FROM OFICINA o 
        WHERE o.codigoOficina = v_codigo;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_codigo_oficina_cuentacorriente
BEFORE INSERT OR UPDATE ON cuentacorriente
FOR EACH ROW
DECLARE
    v_codigo VARCHAR2(4);
BEGIN
    SELECT o.codigoOficina INTO v_codigo
    FROM oficina o
    WHERE REF(o) = :NEW.REF_OFICINA;

    IF LENGTH(v_codigo) > 4 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El codigo de oficina no puede ser mayor a 4 caracteres.');
    ELSIF LENGTH(v_codigo) < 4 THEN
        v_codigo := LPAD(v_codigo, 4, '0');

        SELECT REF(o) INTO :NEW.REF_OFICINA
        FROM oficina o
        WHERE o.codigoOficina = v_codigo;
    END IF;
END;
/

------------------------------------------
-- 11. Comprobar que exista esa oficina en operacionefectiva
------------------------------------------
CREATE OR REPLACE TRIGGER trg_verificar_codigo_oficina
BEFORE INSERT OR UPDATE ON operacionefectiva
FOR EACH ROW
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM oficina o
  WHERE o.codigoOficina = DEREF(:NEW.ref_sucursal).codigoOficina; 

  IF v_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'El codigo de oficina proporcionado no existe en la tabla oficina.');
  END IF;
END;
/

------------------------------------------
-- 12. Actualización del saldo de cuentas de ahorro cada noche, con el interés asignado
------------------------------------------
CREATE OR REPLACE PROCEDURE actualizar_saldo_cuenta_ahorro AS
BEGIN
    UPDATE cuentaahorro
    SET saldo = saldo + (saldo * interes / 100);
END;
/

BEGIN
    DBMS_SCHEDULER.CREATE_JOB(
        job_name        => 'JOB_ACTUALIZAR_SALDO_AHORRO',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN actualizar_saldo_cuenta_ahorro; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=DAILY; BYHOUR=0; BYMINUTE=0; BYSECOND=0',
        enabled         => TRUE
    );
END;
/

------------------------------------------
-- 13. Gestión del saldo de operaciones en efectivo, teniendo en cuenta INSERT, UPDATE o DELETE
------------------------------------------
CREATE OR REPLACE TRIGGER trg_gestionar_saldo_efectiva
AFTER INSERT OR UPDATE OR DELETE ON operacionefectiva
FOR EACH ROW
DECLARE
    v_cuenta_emisora REF CUENTAUDT;
    v_saldo_actual NUMBER; -- Variable faltante declarada
BEGIN
    IF DELETING THEN
        v_cuenta_emisora := :OLD.REF_CUENTAEMISORA;

        IF :OLD.TIPOOPERACION = 'INGRESO' THEN
            UPDATE cuenta c
            SET c.saldo = c.saldo - :OLD.cuantia
            WHERE REF(c) = v_cuenta_emisora;
        ELSIF :OLD.TIPOOPERACION = 'RETIRADA' THEN
            UPDATE cuenta c
            SET c.saldo = c.saldo + :OLD.cuantia
            WHERE REF(c) = v_cuenta_emisora;
        END IF;
    END IF;

    IF INSERTING OR UPDATING THEN
        v_cuenta_emisora := :NEW.REF_CUENTAEMISORA;

        IF :NEW.TIPOOPERACION = 'INGRESO' THEN
            UPDATE cuenta c
            SET c.saldo = c.saldo + :NEW.cuantia
            WHERE REF(c) = v_cuenta_emisora;
        ELSIF :NEW.TIPOOPERACION = 'RETIRADA' THEN
            -- Validar saldo antes de retirar
            SELECT c.saldo INTO v_saldo_actual
            FROM cuenta c
            WHERE REF(c) = v_cuenta_emisora
            FOR UPDATE;

            IF v_saldo_actual < :NEW.cuantia THEN
                RAISE_APPLICATION_ERROR(-20002, 
                    'No se puede retirar ' || :NEW.cuantia || 
                    '. Saldo actual: ' || v_saldo_actual
                );
            END IF;

            -- Actualizar saldo
            UPDATE cuenta c
            SET c.saldo = c.saldo - :NEW.cuantia
            WHERE REF(c) = v_cuenta_emisora;
        END IF;
    END IF;
END;
/

------------------------------------------
-- 14. Gestión del saldo de operaciones de transferencia, teniendo en cuenta INSERT, UPDATE o DELETE
------------------------------------------
CREATE OR REPLACE TRIGGER trg_gestionar_saldo_transferencia
AFTER INSERT OR UPDATE OR DELETE ON transferencia
FOR EACH ROW
DECLARE
    v_cuenta_emisora REF CUENTAUDT;
    v_cuenta_receptora REF CUENTAUDT;
    v_saldo_emisor NUMBER; -- Variable faltante declarada
BEGIN
    IF DELETING THEN
        v_cuenta_emisora := :OLD.REF_CUENTAEMISORA;
        v_cuenta_receptora := :OLD.REF_CUENTARECEPTORA;

        UPDATE cuenta c
        SET c.saldo = c.saldo + :OLD.cuantia
        WHERE REF(c) = v_cuenta_emisora;

        UPDATE cuenta c
        SET c.saldo = c.saldo - :OLD.cuantia
        WHERE REF(c) = v_cuenta_receptora;
    END IF;

    IF INSERTING OR UPDATING THEN
        v_cuenta_emisora := :NEW.REF_CUENTAEMISORA;
        v_cuenta_receptora := :NEW.REF_CUENTARECEPTORA;

        -- Validar saldo del emisor
        SELECT c.saldo INTO v_saldo_emisor
        FROM cuenta c
        WHERE REF(c) = v_cuenta_emisora
        FOR UPDATE;

        IF v_saldo_emisor < :NEW.cuantia THEN
            RAISE_APPLICATION_ERROR(-20003, 
                'No se puede transferir ' || :NEW.cuantia || 
                '. Saldo actual: ' || v_saldo_emisor
            );
        END IF;

        -- Actualizar saldos
        UPDATE cuenta c
        SET c.saldo = c.saldo - :NEW.cuantia
        WHERE REF(c) = v_cuenta_emisora;

        UPDATE cuenta c
        SET c.saldo = c.saldo + :NEW.cuantia
        WHERE REF(c) = v_cuenta_receptora;
    END IF;
END;
/