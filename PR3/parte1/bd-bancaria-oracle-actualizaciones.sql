CREATE OR REPLACE TRIGGER TitularesGlobales_Insert
INSTEAD OF INSERT ON TitularesGlobales
FOR EACH ROW
BEGIN
    INSERT INTO CLIENTES (
        DNI, 
        NOMBRE, 
        APELLIDOS, 
        DIRECCION, 
        TELEFONO, 
        FECHANACIMIENTO,
        EMAIL
    ) VALUES (
        :NEW.DNI,
        :NEW.Nombre,
        :NEW.Apellido1 || ' ' || :NEW.Apellido2,
        :NEW.Direccion,
        :NEW.Telefono,
        :NEW.FechaNacimiento,
        :NEW.EMAIL
    );
END;
/

CREATE OR REPLACE TRIGGER TitularesGlobales_Update
INSTEAD OF UPDATE ON TitularesGlobales
FOR EACH ROW
DECLARE
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_exists FROM CLIENTES WHERE DNI = :OLD.DNI;
    
    IF v_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20030, 'No se puede actualizar: El titular no existe en la base local');
    ELSE
        UPDATE CLIENTES SET
            NOMBRE = :NEW.Nombre,
            APELLIDOS = :NEW.Apellido1 || ' ' || :NEW.Apellido2,
            DIRECCION = :NEW.Direccion,
            TELEFONO = :NEW.Telefono,
            FECHANACIMIENTO = :NEW.FechaNacimiento,
            EMAIL = :NEW.Email
        WHERE DNI = :OLD.DNI;
    END IF;
END;
/

-----------------

CREATE OR REPLACE TRIGGER CuentasGlobales_Insert
INSTEAD OF INSERT ON CuentasGlobales
FOR EACH ROW
DECLARE
    v_prefijoIBAN  VARCHAR2(4);
    v_numeroCuenta VARCHAR2(30);
BEGIN
    IF LENGTH(:NEW.iban) < 4 THEN
        RAISE_APPLICATION_ERROR(-20001, 'IBAN inválido: longitud mínima no alcanzada');
    END IF;

    v_prefijoIBAN  := SUBSTR(:NEW.iban, 1, 4);
    v_numeroCuenta := SUBSTR(:NEW.iban, 5);

    INSERT INTO Cuentas (
        PrefijoIBAN,
        NumeroCuenta,
        FechaCreacion,
        Saldo,
        EsCuentaCorriente,
        Interes,
        CodigoOficina_Adscrita
    ) VALUES (
        v_prefijoIBAN,
        v_numeroCuenta,
        :NEW.FechaCreacion,
        :NEW.Saldo,
        CASE WHEN UPPER(:NEW.TipoCuenta) = 'CORRIENTE' THEN 1 ELSE 0 END,
        :NEW.Interes,
        TO_NUMBER(:NEW.CodigoOficina)
    );
END;
/

CREATE OR REPLACE TRIGGER CuentasGlobales_Update
INSTEAD OF UPDATE ON CuentasGlobales
FOR EACH ROW
DECLARE
    v_prefijoIBAN VARCHAR2(4);
    v_numeroCuenta VARCHAR2(30);
    v_exists NUMBER;
    v_esCorriente NUMBER;
    v_interes NUMBER;
    v_codigoOficina NUMBER;
BEGIN
    v_prefijoIBAN := SUBSTR(:OLD.IBAN, 1, 4);
    v_numeroCuenta := SUBSTR(:OLD.IBAN, 5);
    
    SELECT COUNT(*) INTO v_exists FROM CUENTAS 
    WHERE PrefijoIBAN = v_prefijoIBAN AND NumeroCuenta = v_numeroCuenta;
    
    IF v_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20031, 'No se puede actualizar: La cuenta no existe en la base local');
    ELSE
        IF UPPER(:NEW.TipoCuenta) = 'CORRIENTE' THEN
            v_esCorriente := 1;
            v_interes := NULL;
            v_codigoOficina := TO_NUMBER(:NEW.CodigoOficina);
        ELSE -- Ahorro
            v_esCorriente := 0;
            v_interes := :NEW.Interes;
            v_codigoOficina := NULL;
        END IF;
        
        IF v_esCorriente = 0 AND v_interes IS NULL THEN
            RAISE_APPLICATION_ERROR(-20035, 'Cuentas de ahorro deben tener interés');
        ELSIF v_esCorriente = 1 AND v_codigoOficina IS NULL THEN
            RAISE_APPLICATION_ERROR(-20036, 'Cuentas corrientes deben tener oficina asignada');
        END IF;
        
        UPDATE CUENTAS SET
            PrefijoIBAN = SUBSTR(:NEW.IBAN, 1, 4),
            NumeroCuenta = SUBSTR(:NEW.IBAN, 5),
            FechaCreacion = :NEW.FechaCreacion,
            Saldo = :NEW.Saldo,
            esCuentaCorriente = v_esCorriente,
            interes = v_interes,
            codigoOficina_Adscrita = v_codigoOficina
        WHERE PrefijoIBAN = v_prefijoIBAN
        AND NumeroCuenta = v_numeroCuenta;
    END IF;
END;
/

---------------------------

CREATE OR REPLACE TRIGGER TitularesCuentasGlobal_Insert
INSTEAD OF INSERT ON TitularesCuentasGlobal
FOR EACH ROW
DECLARE
    v_prefijoIBAN  VARCHAR2(4);
    v_numeroCuenta VARCHAR2(30);
BEGIN
    v_prefijoIBAN  := SUBSTR(:NEW.iban, 1, 4);
    v_numeroCuenta := SUBSTR(:NEW.iban, 5);

    INSERT INTO Titular (
        PrefijoIBAN,
        NumeroCuenta,
        dni_titular
    ) VALUES (
        v_prefijoIBAN,
        v_numeroCuenta,
        :NEW.DNI
    );
END;
/

---------------------------

CREATE OR REPLACE TRIGGER OperacionesGlobales_Insert
INSTEAD OF INSERT ON OperacionesGlobales
FOR EACH ROW
DECLARE
    v_prefijoEmisor      VARCHAR2(4);
    v_numeroEmisor       VARCHAR2(30);
    v_prefijoReceptor    VARCHAR2(4);
    v_numeroReceptor     VARCHAR2(30);
BEGIN
    IF LENGTH(:NEW.cuentaEmisora) < 4 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Formato de cuenta emisora inválido');
    END IF;

    v_prefijoEmisor := SUBSTR(:NEW.cuentaEmisora, 1, 4);
    v_numeroEmisor := SUBSTR(:NEW.cuentaEmisora, 5);

    IF :NEW.cuentaReceptora IS NOT NULL THEN
        IF LENGTH(:NEW.cuentaReceptora) < 4 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Formato de cuenta receptora inválido');
        END IF;
        v_prefijoReceptor := SUBSTR(:NEW.cuentaReceptora, 1, 4);
        v_numeroReceptor := SUBSTR(:NEW.cuentaReceptora, 5);
    END IF;

    INSERT INTO Operacion (
        Codigo,
        PrefijoIBAN_CuentaEmisora,
        NumeroCuenta_CuentaEmisora,
        TipoOperacion,
        Descripcion,
        FechaOperacion,
        Cantidad,
        PrefijoIBAN_CuentaReceptora,
        NumeroCuenta_CuentaReceptora,
        Codigo_sucursal
    ) VALUES (
        TO_NUMBER(:NEW.numop),
        v_prefijoEmisor,
        v_numeroEmisor,
        UPPER(:NEW.tipoOperacion),
        :NEW.descripcion,
        :NEW.fechaOperacion, 
        TO_NUMBER(:NEW.cantidad),
        v_prefijoReceptor,
        v_numeroReceptor,
        TO_NUMBER(:NEW.sucursal)
    );
END;
/

CREATE OR REPLACE TRIGGER OperacionesGlobales_Update
INSTEAD OF UPDATE ON OperacionesGlobales
FOR EACH ROW
DECLARE
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_exists FROM OPERACION WHERE Codigo = :OLD.numop;
    
    IF v_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20033, 'No se puede actualizar: La operación no existe en la base local');
    ELSE
        UPDATE OPERACION SET
            Descripcion = :NEW.descripcion,
            FechaOperacion = :NEW.fechaOperacion,
            Cantidad = TO_NUMBER(:NEW.cantidad),
            TipoOperacion = UPPER(:NEW.tipoOperacion),
            Codigo_sucursal = TO_NUMBER(:NEW.sucursal)
        WHERE Codigo = :OLD.numop;
    END IF;
END;
/

----------------------------

CREATE OR REPLACE TRIGGER oficinasGlobales_Insert
INSTEAD OF INSERT ON oficinasGlobales
FOR EACH ROW
BEGIN
    IF :NEW.CODIGOOFICINA IS NULL THEN
        RAISE_APPLICATION_ERROR(-20010, 'Código de oficina no puede ser nulo');
    ELSIF :NEW.DIRECCION IS NULL THEN
        RAISE_APPLICATION_ERROR(-20011, 'Dirección no puede ser nula');
    ELSIF :NEW.TELEFONO IS NULL THEN
        RAISE_APPLICATION_ERROR(-20012, 'Teléfono no puede ser nulo');

    ELSIF LENGTH(:NEW.TELEFONO) != 9 THEN
        RAISE_APPLICATION_ERROR(-20013, 'El teléfono debe tener 9 dígitos');
    ELSIF NOT REGEXP_LIKE(:NEW.TELEFONO, '^9[0-9]{8}$') THEN
        RAISE_APPLICATION_ERROR(-20014, 'El teléfono debe empezar con 9 y tener 9 dígitos');
    END IF;

    INSERT INTO oficinas (
        CODIGOOFICINA,
        DIRECCION,
        TELEFONO
    ) VALUES (
        :NEW.CODIGOOFICINA,
        :NEW.DIRECCION,
        '+' || :NEW.TELEFONO  
    );
END;
/


CREATE OR REPLACE TRIGGER OficinasGlobales_Update
INSTEAD OF UPDATE ON OficinasGlobales
FOR EACH ROW
DECLARE
    v_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_exists FROM OFICINAS WHERE CODIGOOFICINA = :OLD.CODIGOOFICINA;
    
    IF v_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20034, 'No se puede actualizar: La oficina no existe en la base local');
    ELSE
        UPDATE OFICINAS SET
            DIRECCION = :NEW.DIRECCION,
            TELEFONO = '+' || :NEW.TELEFONO
        WHERE CODIGOOFICINA = :OLD.CODIGOOFICINA;
    END IF;
END;
/
