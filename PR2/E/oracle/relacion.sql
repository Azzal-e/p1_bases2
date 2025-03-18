BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE clientRE CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE telefonRE CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE ibanRE CASCADE CONSTRAINTS'; -- Nombre exacto
EXCEPTION
  WHEN OTHERS THEN 
    IF SQLCODE != -942 THEN -- Ignorar error "table does not exist"
      RAISE;
    END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE oficinaRE CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE cuentaRE CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE cuentacorrienteRE CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE cuentaahorroRE CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE operacionRE CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE operacionefectivaRE CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE transferenciaRE CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE transferenciaudtRE CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE operacionudtRE CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

-- Crear las tablas nuevamente
CREATE TABLE clientRE (
  dni_val VARCHAR2(20) PRIMARY KEY,
  nombre VARCHAR2(50),
  apellidos VARCHAR2(75),
  fechaDeNacimiento DATE,
  telefono VARCHAR2(50),
  direccion VARCHAR2(200),
  email VARCHAR2(250)
);

CREATE TABLE telefonRE (
  valor VARCHAR2(50) PRIMARY KEY
);

CREATE TABLE ibanRE (
  prefijoiban VARCHAR2(4),
  numerocuenta VARCHAR2(30),
  PRIMARY KEY (prefijoiban, numerocuenta)
);

CREATE TABLE oficinaRE (
  codigoOficina NUMBER(4) PRIMARY KEY,
  direccion VARCHAR2(200),
  telefono VARCHAR2(50)
);

CREATE TABLE cuentaRE (
  cuenta_iban_prefijoiban VARCHAR2(4),
  cuenta_iban_numerocuenta VARCHAR2(30),
  fechaCreacion DATE,
  saldo NUMBER(15,2),
  ref_titular VARCHAR2(20), -- Clave foránea a clientRE
  PRIMARY KEY (cuenta_iban_prefijoiban, cuenta_iban_numerocuenta),
  FOREIGN KEY (ref_titular) REFERENCES clientRE(dni_val)
);

CREATE TABLE cuentacorrienteRE (
  cuenta_iban_prefijoiban VARCHAR2(4),
  cuenta_iban_numerocuenta VARCHAR2(30),
  ref_oficina NUMBER(4), -- Clave foránea a oficinaRE
  PRIMARY KEY (cuenta_iban_prefijoiban, cuenta_iban_numerocuenta),
  FOREIGN KEY (ref_oficina) REFERENCES oficinaRE(codigoOficina),
  FOREIGN KEY (cuenta_iban_prefijoiban, cuenta_iban_numerocuenta) REFERENCES cuentaRE(cuenta_iban_prefijoiban, cuenta_iban_numerocuenta)
);

CREATE TABLE cuentaahorroRE (
  cuenta_iban_prefijoiban VARCHAR2(4),
  cuenta_iban_numerocuenta VARCHAR2(30),
  interes NUMBER(5,2),
  PRIMARY KEY (cuenta_iban_prefijoiban, cuenta_iban_numerocuenta),
  FOREIGN KEY (cuenta_iban_prefijoiban, cuenta_iban_numerocuenta) REFERENCES cuentaRE(cuenta_iban_prefijoiban, cuenta_iban_numerocuenta)
);

CREATE TABLE operacionRE (
  codigo NUMBER(10) PRIMARY KEY,
  fechaYHora TIMESTAMP,
  cuantia NUMBER(15,2),
  descripcion VARCHAR2(4000),
  ref_cuentaemisora_prefijoiban VARCHAR2(4),
  ref_cuentaemisora_numerocuenta VARCHAR2(30),
  FOREIGN KEY (ref_cuentaemisora_prefijoiban, ref_cuentaemisora_numerocuenta) REFERENCES cuentaRE(cuenta_iban_prefijoiban, cuenta_iban_numerocuenta)
);

CREATE TABLE operacionefectivaRE (
  codigo NUMBER(10),
  tipooperacion VARCHAR2(20),
  ref_sucursal NUMBER(4), -- Clave foránea a oficinaRE
  PRIMARY KEY (codigo),
  FOREIGN KEY (codigo) REFERENCES operacionRE(codigo),
  FOREIGN KEY (ref_sucursal) REFERENCES oficinaRE(codigoOficina)
);

CREATE TABLE transferenciaRE (
  codigo NUMBER(10),
  ref_cuentareceptora_prefijoiban VARCHAR2(4),
  ref_cuentareceptora_numerocuenta VARCHAR2(30),
  PRIMARY KEY (codigo),
  FOREIGN KEY (codigo) REFERENCES operacionRE(codigo),
  FOREIGN KEY (ref_cuentareceptora_prefijoiban, ref_cuentareceptora_numerocuenta) REFERENCES cuentaRE(cuenta_iban_prefijoiban, cuenta_iban_numerocuenta)
);

CREATE TABLE transferenciaudtRE (
  codigo NUMBER(10),
  ref_cuentareceptora_prefijoiban VARCHAR2(4),
  ref_cuentareceptora_numerocuenta VARCHAR2(30),
  PRIMARY KEY (codigo),
  FOREIGN KEY (codigo) REFERENCES operacionRE(codigo),
  FOREIGN KEY (ref_cuentareceptora_prefijoiban, ref_cuentareceptora_numerocuenta) REFERENCES cuentaRE(cuenta_iban_prefijoiban, cuenta_iban_numerocuenta)
);

CREATE TABLE operacionudtRE (
  codigo NUMBER(10),
  fechaYHora TIMESTAMP,
  cuantia NUMBER(15,2),
  descripcion VARCHAR2(4000),
  ref_cuentaemisora_prefijoiban VARCHAR2(4),
  ref_cuentaemisora_numerocuenta VARCHAR2(30),
  PRIMARY KEY (codigo),
  FOREIGN KEY (ref_cuentaemisora_prefijoiban, ref_cuentaemisora_numerocuenta) REFERENCES cuentaRE(cuenta_iban_prefijoiban, cuenta_iban_numerocuenta)
);

