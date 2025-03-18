-----------------------------------------
-- 1. Fechas válidas en cliente
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

-----------------------------------------
-- 2. Fecha válida en cuenta
-----------------------------------------
CREATE OR REPLACE TRIGGER trg_fecha_creacion_valida_cuenta
BEFORE INSERT OR UPDATE ON cuenta
FOR EACH ROW
BEGIN
  IF :NEW.fechaCreacion >= SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20011, 'La fecha de creación de la cuenta debe ser anterior a la fecha actual');
  END IF;
END;
/

-----------------------------------------
-- 3. Fecha válida en operación
-----------------------------------------
CREATE OR REPLACE TRIGGER trg_fecha_valida_operacion
BEFORE INSERT OR UPDATE ON operacion
FOR EACH ROW
BEGIN
  IF :NEW.fechaYHora >= SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20012, 'La fecha y hora de la operación debe ser anterior a la fecha actual');
  END IF;
END;
/

-----------------------------------------
-- 4. Especialización obligatoria de cuentas
-----------------------------------------
CREATE OR REPLACE TRIGGER trg_cuenta_especializacion_obligatoria
BEFORE INSERT OR UPDATE ON cuenta
FOR EACH ROW
DECLARE
  total_corriente NUMBER;
  total_ahorro NUMBER;
BEGIN
  SELECT COUNT(*) INTO total_corriente FROM cuentacorriente WHERE cuenta_iban = :NEW.cuenta_iban;
  SELECT COUNT(*) INTO total_ahorro FROM cuentaahorro WHERE cuenta_iban = :NEW.cuenta_iban;

  IF total_corriente + total_ahorro = 0 THEN
    RAISE_APPLICATION_ERROR(-20013, 'La cuenta debe ser especializada como CUENTA CORRIENTE o CUENTA AHORRO');
  END IF;
END;
/

-----------------------------------------
-- 5. Exclusividad entre subtipos
-----------------------------------------
CREATE OR REPLACE TRIGGER trg_exclusividad_corriente
BEFORE INSERT OR UPDATE ON cuentacorriente
FOR EACH ROW
DECLARE
  total_ahorro NUMBER;
BEGIN
  SELECT COUNT(*) INTO total_ahorro FROM cuentaahorro WHERE cuenta_iban = :NEW.cuenta_iban;
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
  SELECT COUNT(*) INTO total_corriente FROM cuentacorriente WHERE cuenta_iban = :NEW.cuenta_iban;
  IF total_corriente > 0 THEN
    RAISE_APPLICATION_ERROR(-20015, 'Una cuenta no puede ser a la vez AHORRO y CORRIENTE');
  END IF;
END;
/

-----------------------------------------
-- 6. Validación de existencia en transferencias
-----------------------------------------
CREATE OR REPLACE TRIGGER trg_validar_transferencia
BEFORE INSERT OR UPDATE ON transferencia
FOR EACH ROW
DECLARE
  v_emisor_prefijo VARCHAR2(4);
  v_emisor_numero VARCHAR2(30);
  v_receptor_prefijo VARCHAR2(4);
  v_receptor_numero VARCHAR2(30);
  v_emisor_count NUMBER;
  v_receptor_count NUMBER;
BEGIN
  -- Obtener IBAN de cuenta emisora
  SELECT DEREF(:NEW.ref_cuentaemisora).cuenta_iban.PREFIJOIBAN,
         DEREF(:NEW.ref_cuentaemisora).cuenta_iban.NUMEROCUENTA
  INTO v_emisor_prefijo, v_emisor_numero FROM DUAL;

  -- Obtener IBAN de cuenta receptora
  SELECT DEREF(:NEW.ref_cuentareceptora).cuenta_iban.PREFIJOIBAN,
         DEREF(:NEW.ref_cuentareceptora).cuenta_iban.NUMEROCUENTA
  INTO v_receptor_prefijo, v_receptor_numero FROM DUAL;

  -- Validar que la cuenta emisora exista
  SELECT COUNT(*) INTO v_emisor_count
  FROM cuenta c
  WHERE VALUE(c).cuenta_iban.PREFIJOIBAN = v_emisor_prefijo
    AND VALUE(c).cuenta_iban.NUMEROCUENTA = v_emisor_numero;

  IF v_emisor_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20022, 'La cuenta emisora no existe');
  END IF;

  -- Validar que la cuenta receptora exista
  SELECT COUNT(*) INTO v_receptor_count
  FROM cuenta c
  WHERE VALUE(c).cuenta_iban.PREFIJOIBAN = v_receptor_prefijo
    AND VALUE(c).cuenta_iban.NUMEROCUENTA = v_receptor_numero;

  IF v_receptor_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20023, 'La cuenta receptora no existe');
  END IF;

  -- Validar que no sean la misma cuenta
  IF v_emisor_prefijo = v_receptor_prefijo AND v_emisor_numero = v_receptor_numero THEN
    RAISE_APPLICATION_ERROR(-20024, 'La cuenta emisora y receptora no pueden ser la misma');
  END IF;
END;
/


-----------------------------------------
-- 7. Validación de cuenta emisora en operación efectiva
-----------------------------------------
CREATE OR REPLACE TRIGGER trg_validar_operacion_efectiva
BEFORE INSERT OR UPDATE ON operacionefectiva
FOR EACH ROW
DECLARE
  v_cuenta_count NUMBER;
  v_oficina_count NUMBER;
  v_prefijo VARCHAR2(4);
  v_numero VARCHAR2(30);
BEGIN
  -- Obtener IBAN de la cuenta emisora
  SELECT DEREF(:NEW.ref_cuentaemisora).cuenta_iban.PREFIJOIBAN,
         DEREF(:NEW.ref_cuentaemisora).cuenta_iban.NUMEROCUENTA
  INTO v_prefijo, v_numero FROM DUAL;

  -- Verificar existencia de la cuenta emisora
  SELECT COUNT(*) INTO v_cuenta_count
  FROM cuenta c
  WHERE VALUE(c).cuenta_iban.PREFIJOIBAN = v_prefijo
    AND VALUE(c).cuenta_iban.NUMEROCUENTA = v_numero;

  IF v_cuenta_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20020, 'La cuenta emisora no existe');
  END IF;

  -- Verificar existencia de la oficina
  SELECT COUNT(*) INTO v_oficina_count
  FROM oficina o
  WHERE VALUE(o).codigoOficina = DEREF(:NEW.ref_sucursal).codigoOficina;

  IF v_oficina_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20021, 'La oficina asociada no existe');
  END IF;
END;
/


-----------------------------------------
-- 8. Cliente debe tener al menos una cuenta
-----------------------------------------
CREATE OR REPLACE TRIGGER trg_cliente_minimo_una_cuenta
AFTER UPDATE ON cliente
FOR EACH ROW
DECLARE
  total_cuentas_cliente NUMBER;
BEGIN
  SELECT COUNT(*) INTO total_cuentas_cliente FROM cuenta WHERE DEREF(ref_titular).dni_val.VALOR = :NEW.dni_val.VALOR;
  IF total_cuentas_cliente = 0 THEN
    RAISE_APPLICATION_ERROR(-20020, 'El cliente debe tener al menos una cuenta asociada');
  END IF;
END;
/

-----------------------------------------
-- 9. Cuenta debe tener cliente válido
-----------------------------------------
CREATE OR REPLACE TRIGGER trg_cuenta_titular_existente
BEFORE INSERT OR UPDATE ON cuenta
FOR EACH ROW
DECLARE
  v_dni_cliente VARCHAR2(20);
  v_count NUMBER;
BEGIN
  SELECT DEREF(:NEW.ref_titular).dni_val.VALOR INTO v_dni_cliente FROM DUAL;

  SELECT COUNT(*) INTO v_count
  FROM cliente c
  WHERE c.dni_val.VALOR = v_dni_cliente;

  IF v_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20019, 'No se puede crear una cuenta sin un cliente titular válido');
  END IF;
END;
/

------------------------------------------
-- 10. Codigo de oficina == 4 (en oficina y en operacionefectiva)
------------------------------------------
CREATE OR REPLACE TRIGGER trg_codigo_oficina
BEFORE INSERT OR UPDATE ON oficina
FOR EACH ROW
BEGIN
  IF LENGTH(TO_CHAR(:NEW.CODIGOOFICINA)) > 4 THEN
    RAISE_APPLICATION_ERROR(-20001, 'El código de oficina no puede ser mayor a 4 caracteres.');
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

------------------------------------------
-- 11. Comprobar que exista esa oficina en operacionefectiva
------------------------------------------
CREATE OR REPLACE TRIGGER trg_verificar_codigo_oficina
BEFORE INSERT OR UPDATE ON operacionefectiva
FOR EACH ROW
DECLARE
  v_count NUMBER;
BEGIN
  -- Verificar si el código de oficina existe en la tabla oficina
  SELECT COUNT(*) INTO v_count
  FROM oficina o
  WHERE o.codigoOficina = DEREF(:NEW.ref_sucursal).codigoOficina;  -- Desreferenciar el REF

  -- Si no existe, generar un error
  IF v_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'El código de oficina proporcionado no existe en la tabla oficina.');
  END IF;
END;
/
