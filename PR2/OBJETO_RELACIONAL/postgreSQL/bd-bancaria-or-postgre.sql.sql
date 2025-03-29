-- IMPLEMENTACION DE OBJETO/RELACIONAL EN GESTOR POSTGRESQL --

-- Eliminar tablas y tipos existentes


DROP TABLE IF EXISTS Titular CASCADE;
DROP TABLE IF EXISTS Transferencia CASCADE;
DROP TABLE IF EXISTS OperacionEfectiva CASCADE;
DROP TABLE IF EXISTS Operacion CASCADE;
DROP TABLE IF EXISTS CuentaAhorro CASCADE;
DROP TABLE IF EXISTS CuentaCorriente CASCADE;
DROP TABLE IF EXISTS Oficina CASCADE;
DROP TABLE IF EXISTS Cliente CASCADE;
DROP TABLE IF EXISTS Cuenta CASCADE;

DROP DOMAIN IF EXISTS DNI CASCADE;
DROP DOMAIN IF EXISTS TELEFONO CASCADE;
DROP TYPE IF EXISTS IBAN CASCADE;

SET search_path = 'public';
-- CREACION DE DOMINIOS y tipos estructurados --

CREATE DOMAIN DNI AS VARCHAR(20);
CREATE DOMAIN TELEFONO AS VARCHAR(16);

CREATE TYPE IBAN AS (
    prefijoIBAN VARCHAR(4),
    numeroCuenta VARCHAR(30)
);

-- CREACION DE TABLAS

CREATE TABLE Cliente (
    dni DNI PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(75) NOT NULL,
    fechaDeNacimiento DATE NOT NULL,
    telefono TELEFONO NOT NULL CHECK (telefono SIMILAR TO '\+\d+'),
    direccion VARCHAR(200) NOT NULL,
    email VARCHAR(250) CHECK (email SIMILAR TO '%@%.%')
);

CREATE TABLE Cuenta (
    iban IBAN PRIMARY KEY,
    fechaDeCreacion DATE NOT NULL,
    saldo DECIMAL(15,2) DEFAULT 0 CHECK (saldo >= 0)
);

CREATE TABLE Oficina (
    codigo DECIMAL(4,0) PRIMARY KEY,
    direccion VARCHAR(100) NOT NULL,
    telefono TELEFONO NOT NULL,
    CONSTRAINT telefono_valido CHECK (telefono SIMILAR TO '\+\d+')
);


CREATE TABLE CuentaCorriente (
    CONSTRAINT primary_key_cuenta_corriente PRIMARY KEY (iban),
    codigoOficina DECIMAL(4,0) NOT NULL,
    CONSTRAINT fk_oficina FOREIGN KEY (codigoOficina) REFERENCES Oficina(codigo) ON DELETE SET NULL
) INHERITS (Cuenta);

CREATE TABLE CuentaAhorro (
    CONSTRAINT primary_key_cuenta_ahorro PRIMARY KEY (iban),
    interes DECIMAL(5,2) NOT NULL CHECK (interes >= 0)
) INHERITS (Cuenta);


CREATE TABLE Operacion (
    codigo DECIMAL(10,0) PRIMARY KEY,
    IBAN_cuentaEmisora IBAN NOT NULL,
    fechaYHora TIMESTAMP NOT NULL,
    cuantia DECIMAL(15,2) NOT NULL,
    descripcion VARCHAR(200),
    CONSTRAINT fk_cuenta_emisora FOREIGN KEY (IBAN_cuentaEmisora) REFERENCES Cuenta(iban) ON DELETE CASCADE
);

CREATE TABLE OperacionEfectiva (
    CONSTRAINT primary_key_operacion_efectiva PRIMARY KEY (codigo),
    CONSTRAINT fk_cuenta_emisora FOREIGN KEY (IBAN_cuentaEmisora) REFERENCES Cuenta(iban) ON DELETE CASCADE,

    tipoOperacion VARCHAR(20) NOT NULL,
    CONSTRAINT tipoOperacion_valido CHECK (tipoOperacion IN ('INGRESO', 'RETIRADA')),
    codigo_Sucursal DECIMAL(4,0) NOT NULL,
    CONSTRAINT fk_sucursal FOREIGN KEY (codigo_Sucursal) REFERENCES Oficina(codigo) ON DELETE SET NULL
    
)INHERITS (Operacion);

CREATE TABLE Transferencia (
    CONSTRAINT primary_key_transferencia PRIMARY KEY (codigo),
    CONSTRAINT fk_cuenta_emisora FOREIGN KEY (IBAN_cuentaEmisora) REFERENCES Cuenta(iban) ON DELETE CASCADE,

    IBAN_cuentaReceptora IBAN NOT NULL,
    CONSTRAINT fk_cuenta_receptora FOREIGN KEY (IBAN_cuentaReceptora) REFERENCES Cuenta(iban) ON DELETE CASCADE,
    CONSTRAINT emisora_distinta_receptora CHECK ((IBAN_cuentaEmisora).prefijoIBAN <> (IBAN_cuentaReceptora).prefijoIBAN
                                                OR (IBAN_cuentaEmisora).numeroCuenta <> (IBAN_cuentaReceptora).numeroCuenta)
)INHERITS (Operacion);


CREATE TABLE Titular (
    dni_Titular DNI NOT NULL,
    iban_cuenta IBAN NOT NULL,
    PRIMARY KEY (dni_Titular, iban_cuenta),
    CONSTRAINT fk_cliente FOREIGN KEY (dni_Titular) REFERENCES Cliente(dni) ON DELETE CASCADE,
    CONSTRAINT fk_cuenta FOREIGN KEY (iban_cuenta) REFERENCES Cuenta(iban) ON DELETE CASCADE
);

-- Método para oobtener la edad de un cliente
CREATE FUNCTION get_edad(dni_cliente DNI) RETURNS INTEGER AS $$
DECLARE
    edad INTEGER;
BEGIN
    SELECT EXTRACT(YEAR FROM AGE(CURRENT_DATE, fechaDeNacimiento)) INTO edad
    FROM Cliente WHERE dni = dni_cliente;
    
    RETURN edad;
END;
$$ LANGUAGE plpgsql;
-- IMPLEMENTACION DE RESTRICCIONES ADICIONALES --

-- 1. Trigger para asegurar que para toda ocurrencia de IBAN en la tabla cuenta,
--    debe existir al menos una instancia de Titular done iban_cuenta = IBAN.
-- NOTA: EXISTE PROBLEMAS DE DEPENDECIAS ENTRE TABLAS, POR LO QUE HABRÁ QUE DEFERIR LA CLAVE
--       FORÁNEA O DESACTIVAR EL TRIGGER.
-- Crear función para validar que una cuenta tenga al menos un titular
CREATE OR REPLACE FUNCTION validar_cuenta_con_titular()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar si la cuenta tiene al menos un titular en la tabla Titular
    IF NOT EXISTS (SELECT 1 FROM Titular WHERE iban_cuenta = NEW.iban) THEN
        RAISE EXCEPTION 'Error: La cuenta debe tener al menos un titular asociado.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear trigger en la tabla Cuenta para asegurarse de que no existan cuentas sin titulares
CREATE OR REPLACE TRIGGER trigger_cuenta_con_titular
AFTER INSERT OR UPDATE ON Cuenta
FOR EACH ROW
EXECUTE FUNCTION validar_cuenta_con_titular();

CREATE OR REPLACE TRIGGER trigger_cuenta_corriente_con_titular
AFTER INSERT OR UPDATE ON CuentaCorriente
FOR EACH ROW
EXECUTE FUNCTION validar_cuenta_con_titular();

CREATE OR REPLACE TRIGGER trigger_cuenta_ahorro_con_titular
AFTER INSERT OR UPDATE ON CuentaAhorro
FOR EACH ROW
EXECUTE FUNCTION validar_cuenta_con_titular();

-- Función que valida las fechas para Cliente, Cuenta, Operación, y otras tablas
-- Función para validar la fecha de nacimiento de Cliente
CREATE OR REPLACE FUNCTION validar_fechas_cliente() RETURNS TRIGGER AS $$
BEGIN
    -- Validar fecha de nacimiento en Cliente
    IF NEW.fechaDeNacimiento >= CURRENT_DATE THEN
        RAISE EXCEPTION 'Error: La fecha de nacimiento debe ser anterior a la fecha actual.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para Cliente
CREATE TRIGGER trigger_validar_fechas_cliente
BEFORE INSERT OR UPDATE ON Cliente
FOR EACH ROW EXECUTE FUNCTION validar_fechas_cliente();
-- Función para validar la fecha de creación de Cuenta
CREATE OR REPLACE FUNCTION validar_fechas_cuenta() RETURNS TRIGGER AS $$
BEGIN
    -- Validar fecha de creación en Cuenta
    IF NEW.fechaDeCreacion >= CURRENT_DATE THEN
        RAISE EXCEPTION 'Error: La fecha de creación de la cuenta debe ser anterior a la fecha actual.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para Cuenta
CREATE TRIGGER trigger_validar_fechas_cuenta
BEFORE INSERT OR UPDATE ON Cuenta
FOR EACH ROW EXECUTE FUNCTION validar_fechas_cuenta();
-- Función para validar la fecha de creación de CuentaCorriente
CREATE OR REPLACE FUNCTION validar_fechas_cuenta_corriente() RETURNS TRIGGER AS $$
BEGIN
    -- Validar fecha de creación en CuentaCorriente
    IF NEW.fechaDeCreacion >= CURRENT_DATE THEN
        RAISE EXCEPTION 'Error: La fecha de creación de la cuenta corriente debe ser anterior a la fecha actual.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para CuentaCorriente
CREATE TRIGGER trigger_validar_fechas_cuenta_corriente
BEFORE INSERT OR UPDATE ON CuentaCorriente
FOR EACH ROW EXECUTE FUNCTION validar_fechas_cuenta_corriente();
-- Función para validar la fecha de creación de CuentaAhorro
CREATE OR REPLACE FUNCTION validar_fechas_cuenta_ahorro() RETURNS TRIGGER AS $$
BEGIN
    -- Validar fecha de creación en CuentaAhorro
    IF NEW.fechaDeCreacion >= CURRENT_DATE THEN
        RAISE EXCEPTION 'Error: La fecha de creación de la cuenta de ahorro debe ser anterior a la fecha actual.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para CuentaAhorro
CREATE TRIGGER trigger_validar_fechas_cuenta_ahorro
BEFORE INSERT OR UPDATE ON CuentaAhorro
FOR EACH ROW EXECUTE FUNCTION validar_fechas_cuenta_ahorro();

-- Función para validar la fecha y hora de la operación
CREATE OR REPLACE FUNCTION validar_fechas_operacion() RETURNS TRIGGER AS $$
BEGIN
    -- Validar fecha y hora en Operacion
    IF NEW.fechaYHora >= NOW() THEN
        RAISE EXCEPTION 'Error: La fecha y hora de la operación debe ser anterior a la fecha actual.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para Operacion
CREATE TRIGGER trigger_validar_fechas_operacion
BEFORE INSERT OR UPDATE ON Operacion
FOR EACH ROW EXECUTE FUNCTION validar_fechas_operacion();
-- Función para validar la fecha y hora de la operación efectiva
CREATE OR REPLACE FUNCTION validar_fechas_operacion_efectiva() RETURNS TRIGGER AS $$
BEGIN
    -- Validar fecha y hora en OperacionEfectiva
    IF NEW.fechaYHora >= NOW() THEN
        RAISE EXCEPTION 'Error: La fecha y hora de la operación efectiva debe ser anterior a la fecha actual.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para OperacionEfectiva
CREATE TRIGGER trigger_validar_fechas_operacion_efectiva
BEFORE INSERT OR UPDATE ON OperacionEfectiva
FOR EACH ROW EXECUTE FUNCTION validar_fechas_operacion_efectiva();
-- Función para validar la fecha y hora de la transferencia
CREATE OR REPLACE FUNCTION validar_fechas_transferencia() RETURNS TRIGGER AS $$
BEGIN
    -- Validar fecha y hora en Transferencia
    IF NEW.fechaYHora >= NOW() THEN
        RAISE EXCEPTION 'Error: La fecha y hora de la transferencia debe ser anterior a la fecha actual.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para Transferencia
CREATE TRIGGER trigger_validar_fechas_transferencia
BEFORE INSERT OR UPDATE ON Transferencia
FOR EACH ROW EXECUTE FUNCTION validar_fechas_transferencia();


-- 3. La fecha de una operacion deber ser posterior a la fecha de creacion de una cuenta emisora.
CREATE OR REPLACE FUNCTION validar_fecha_operacion_emisora() RETURNS TRIGGER AS $$
DECLARE
    v_fecha_creacion TIMESTAMP;
BEGIN
    -- Obtener la fecha de creación de la cuenta emisora
    SELECT fechaDeCreacion::TIMESTAMP INTO v_fecha_creacion -- TODO: Modificar a TIMESTAMP para comparación precisa fechayHora.
    FROM Cuenta WHERE iban = NEW.IBAN_cuentaEmisora;

    -- Verificar si la fecha de la operación es anterior a la fecha de creación de la cuenta emisora
    IF NEW.fechaYHora < v_fecha_creacion THEN
        RAISE EXCEPTION 'Error: La fecha de la operación debe ser posterior a la fecha de creación de la cuenta emisora.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar el trigger en la tabla Operacion
CREATE TRIGGER trigger_validar_fecha_operacion_emisora
BEFORE INSERT OR UPDATE ON Operacion
FOR EACH ROW EXECUTE FUNCTION validar_fecha_operacion_emisora();

CREATE TRIGGER trigger_validar_fecha_operacion_emisora_efectiva
BEFORE INSERT OR UPDATE ON OperacionEfectiva
FOR EACH ROW EXECUTE FUNCTION validar_fecha_operacion_emisora();

CREATE TRIGGER trigger_validar_fecha_operacion_emisora_transferencia
BEFORE INSERT OR UPDATE ON Transferencia
FOR EACH ROW EXECUTE FUNCTION validar_fecha_operacion_emisora();

-- 4. La fecha de una transferencia debe ser posterior a la fecha de creacion de la cuenta receptora.
CREATE OR REPLACE FUNCTION validar_fecha_transferencia() RETURNS TRIGGER AS $$
DECLARE
    v_fecha_creacion TIMESTAMP;
BEGIN
    -- Obtener la fecha de creación de la cuenta receptora y convertirla a TIMESTAMP
    SELECT fechaDeCreacion::TIMESTAMP INTO v_fecha_creacion
    FROM Cuenta WHERE iban = NEW.IBAN_cuentaReceptora;

    -- Verificar si la fecha de la transferencia es anterior a la fecha de creación de la cuenta receptora
    IF NEW.fechaYHora < v_fecha_creacion THEN
        RAISE EXCEPTION 'Error: La fecha de la transferencia debe ser posterior a la fecha de creación de la cuenta receptora.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar el trigger en la tabla Transferencia
CREATE TRIGGER trigger_validar_fecha_transferencia
BEFORE INSERT OR UPDATE ON Transferencia
FOR EACH ROW EXECUTE FUNCTION validar_fecha_transferencia();


-- 5. Asegurar especializacion obligatoria de cuentas y operaciones.
-- Para ello, se evita crear directamente en la tabla cuenta u operacion, de manera
-- que al crear una tabla hija, se debe crear tambien una instancia de la tabla padre.

CREATE OR REPLACE FUNCTION bloquear_insercion_cuenta() RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Error: No se puede insertar directamente en Cuenta. Use CuentaCorriente o CuentaAhorro.';
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_bloquear_insercion_cuenta
BEFORE INSERT ON Cuenta
FOR EACH ROW EXECUTE FUNCTION bloquear_insercion_cuenta();

CREATE OR REPLACE FUNCTION bloquear_insercion_operacion() RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Error: No se puede insertar directamente en Operacion. Use OperacionEfectiva o Transferencia.';
    RETURN NULL;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_bloquear_insercion_operacion
BEFORE INSERT ON Operacion
FOR EACH ROW EXECUTE FUNCTION bloquear_insercion_operacion();

CREATE OR REPLACE FUNCTION insertar_en_cuenta() RETURNS TRIGGER AS $$
BEGIN
    -- Verificar que no estamos insertando directamente en Cuenta, sino en una tabla especializada
    IF TG_TABLE_NAME = 'CuentaCorriente' OR TG_TABLE_NAME = 'CuentaAhorro' THEN
        -- Insertar en la tabla Cuenta solo si no existe el IBAN en la tabla Cuenta
        IF NOT EXISTS (SELECT 1 FROM Cuenta WHERE iban = NEW.iban) THEN
            INSERT INTO Cuenta (iban, fechaDeCreacion, saldo)
            VALUES (NEW.iban, NEW.fechaDeCreacion, NEW.saldo);
        END IF;
    END IF;
    
    -- Retornar la nueva fila para que la inserción continúe normalmente en las tablas especializadas
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Crear triggers para insertar en Cuenta al añadir en las especializaciones
CREATE TRIGGER trigger_insertar_cuenta_corriente
BEFORE INSERT ON CuentaCorriente
FOR EACH ROW EXECUTE FUNCTION insertar_en_cuenta();

CREATE TRIGGER trigger_insertar_cuenta_ahorro
BEFORE INSERT ON CuentaAhorro
FOR EACH ROW EXECUTE FUNCTION insertar_en_cuenta();

CREATE OR REPLACE FUNCTION insertar_en_operacion() RETURNS TRIGGER AS $$
BEGIN
    -- Verificar si la operación ya existe en la tabla padre
    IF NOT EXISTS (SELECT 1 FROM Operacion WHERE codigo = NEW.codigo) THEN
        INSERT INTO Operacion (codigo, IBAN_cuentaEmisora, fechaYHora, cuantia, descripcion)
        VALUES (NEW.codigo, NEW.IBAN_cuentaEmisora, NEW.fechaYHora, NEW.cuantia, NEW.descripcion);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear triggers para insertar en Operacion al añadir en las especializaciones
CREATE TRIGGER trigger_insertar_operacion_efectiva
BEFORE INSERT ON OperacionEfectiva
FOR EACH ROW EXECUTE FUNCTION insertar_en_operacion();

CREATE TRIGGER trigger_insertar_transferencia
BEFORE INSERT ON Transferencia
FOR EACH ROW EXECUTE FUNCTION insertar_en_operacion();

-- 7. Asegurar exclusividad en clases especializadas de cuentas y operaciones.
-- Es decir, que una cuenta no sea tanto corriente como ahorro, ni una operacion efectiva como una transferencia.


CREATE OR REPLACE FUNCTION validar_exclusividad_cuenta() RETURNS TRIGGER AS $$
BEGIN
    -- Si la cuenta se está insertando en CuentaCorriente, verificar que no esté en CuentaAhorro
    IF TG_TABLE_NAME = 'cuentacorriente' AND EXISTS (
        SELECT 1 FROM CuentaAhorro WHERE iban = NEW.iban
    ) THEN
        RAISE EXCEPTION 'Error: La cuenta ya está registrada como CuentaAhorro y no puede ser CuentaCorriente.';
    
    -- Si la cuenta se está insertando en CuentaAhorro, verificar que no esté en CuentaCorriente
    ELSIF TG_TABLE_NAME = 'cuentaahorro' AND EXISTS (
        SELECT 1 FROM CuentaCorriente WHERE iban = NEW.iban
    ) THEN
        RAISE EXCEPTION 'Error: La cuenta ya está registrada como CuentaCorriente y no puede ser CuentaAhorro.';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar el trigger en CuentaCorriente y CuentaAhorro
CREATE TRIGGER trigger_exclusividad_cuenta_corriente
BEFORE INSERT ON CuentaCorriente
FOR EACH ROW EXECUTE FUNCTION validar_exclusividad_cuenta();

CREATE TRIGGER trigger_exclusividad_cuenta_ahorro
BEFORE INSERT ON CuentaAhorro
FOR EACH ROW EXECUTE FUNCTION validar_exclusividad_cuenta();


CREATE OR REPLACE FUNCTION validar_exclusividad_operacion() RETURNS TRIGGER AS $$
BEGIN
    -- Si la operación se está insertando en OperacionEfectiva, verificar que no esté en Transferencia
    IF TG_TABLE_NAME = 'operacionefectiva' AND EXISTS (
        SELECT 1 FROM Transferencia WHERE codigo = NEW.codigo
    ) THEN
        RAISE EXCEPTION 'Error: La operación ya está registrada como Transferencia y no puede ser OperacionEfectiva.';
    
    -- Si la operación se está insertando en Transferencia, verificar que no esté en OperacionEfectiva  
    ELSIF TG_TABLE_NAME = 'transferencia' AND EXISTS (
        SELECT 1 FROM OperacionEfectiva WHERE codigo = NEW.codigo
    ) THEN
        RAISE EXCEPTION 'Error: La operación ya está registrada como OperacionEfectiva y no puede ser Transferencia.';
    END IF; 
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar el trigger en OperacionEfectiva y Transferencia
CREATE TRIGGER trigger_exclusividad_operacion_efectiva
BEFORE INSERT ON OperacionEfectiva
FOR EACH ROW EXECUTE FUNCTION validar_exclusividad_operacion();

CREATE TRIGGER trigger_exclusividad_operacion_transferencia
BEFORE INSERT ON Transferencia
FOR EACH ROW EXECUTE FUNCTION validar_exclusividad_operacion();

--8.El saldo de las cuentas de ahorro se debe actualizar cada noche
--   con el interes que tiene asignado.

CREATE OR REPLACE FUNCTION actualizar_saldo_cuenta_ahorro() RETURNS VOID AS $$
BEGIN
    UPDATE CuentaAhorro
    SET saldo = saldo + (saldo * interes / 100);
END;
$$ LANGUAGE plpgsql;

-- Descomentar para activar el cron job, si se está seguro de soportar la extension pg_cron.
--CREATE EXTENSION IF NOT EXISTS pg_cron;
--SELECT cron.schedule('actualizar_saldo_ahorro', '0 0 * * *', 'SELECT actualizar_saldo_cuenta_ahorro();');

--9. Actualizar saldo, que es atributo derivado, con las operaciones realizadas en la cuenta.

CREATE OR REPLACE FUNCTION gestionar_saldo_operaciones() RETURNS TRIGGER AS $$
BEGIN
    -- Caso DELETE (Revertir operación)
    IF TG_OP = 'DELETE' THEN
        IF OLD.tipoOperacion = 'INGRESO' THEN
            UPDATE Cuenta 
            SET saldo = GREATEST(saldo - OLD.cuantia, 0) -- Asegurar saldo >= 0
            WHERE iban = OLD.IBAN_cuentaEmisora;
        ELSIF OLD.tipoOperacion = 'RETIRADA' OR OLD.tipoOperacion = 'TRANSFERENCIA' THEN
            UPDATE Cuenta 
            SET saldo = saldo + OLD.cuantia 
            WHERE iban = OLD.IBAN_cuentaEmisora;
        END IF;
        
        -- Revertir transferencias en cuenta receptora
        IF OLD.tipoOperacion = 'TRANSFERENCIA' THEN
            UPDATE Cuenta 
            SET saldo = GREATEST(saldo - OLD.cuantia, 0) -- Asegurar saldo >= 0
            WHERE iban = OLD.IBAN_cuentaReceptora;
        END IF;
        RETURN OLD;
    END IF;

    -- Caso 2: UPDATE (Revertir la operación anterior antes de aplicar la nueva)
    IF TG_OP = 'UPDATE' THEN
        -- Revertir el saldo anterior
        IF OLD.tipoOperacion = 'INGRESO' THEN
            UPDATE Cuenta SET saldo = saldo - OLD.cuantia WHERE iban = OLD.IBAN_cuentaEmisora;
            UPDATE CuentaCorriente SET saldo = saldo - OLD.cuantia WHERE iban = OLD.IBAN_cuentaEmisora;
            UPDATE CuentaAhorro SET saldo = saldo - OLD.cuantia WHERE iban = OLD.IBAN_cuentaEmisora;
        ELSIF OLD.tipoOperacion = 'RETIRADA' OR OLD.tipoOperacion = 'TRANSFERENCIA' THEN
            UPDATE Cuenta SET saldo = saldo + OLD.cuantia WHERE iban = OLD.IBAN_cuentaEmisora;
            UPDATE CuentaCorriente SET saldo = saldo + OLD.cuantia WHERE iban = OLD.IBAN_cuentaEmisora;
            UPDATE CuentaAhorro SET saldo = saldo + OLD.cuantia WHERE iban = OLD.IBAN_cuentaEmisora;
        END IF;

        -- Si era una TRANSFERENCIA, revertir el saldo en la cuenta receptora
        IF OLD.tipoOperacion = 'TRANSFERENCIA' THEN
            UPDATE Cuenta SET saldo = saldo - OLD.cuantia WHERE iban = OLD.IBAN_cuentaReceptora;
            UPDATE CuentaCorriente SET saldo = saldo - OLD.cuantia WHERE iban = OLD.IBAN_cuentaReceptora;
            UPDATE CuentaAhorro SET saldo = saldo - OLD.cuantia WHERE iban = OLD.IBAN_cuentaReceptora;
        END IF;
    END IF;

    -- Aplicar el nuevo efecto de la operación (INSERT o después de UPDATE)
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        IF NEW.tipoOperacion = 'INGRESO' THEN
            UPDATE Cuenta SET saldo = saldo + NEW.cuantia WHERE iban = NEW.IBAN_cuentaEmisora;
            UPDATE CuentaCorriente SET saldo = saldo + NEW.cuantia WHERE iban = NEW.IBAN_cuentaEmisora;
            UPDATE CuentaAhorro SET saldo = saldo + NEW.cuantia WHERE iban = NEW.IBAN_cuentaEmisora;
        ELSIF NEW.tipoOperacion = 'RETIRADA' OR NEW.tipoOperacion = 'TRANSFERENCIA' THEN
            UPDATE Cuenta SET saldo = saldo - NEW.cuantia WHERE iban = NEW.IBAN_cuentaEmisora;
            UPDATE CuentaCorriente SET saldo = saldo - NEW.cuantia WHERE iban = NEW.IBAN_cuentaEmisora;
            UPDATE CuentaAhorro SET saldo = saldo - NEW.cuantia WHERE iban = NEW.IBAN_cuentaEmisora;
        END IF;

        -- Si es una TRANSFERENCIA, actualizar saldo de la cuenta receptora
        IF NEW.tipoOperacion = 'TRANSFERENCIA' THEN
            UPDATE Cuenta SET saldo = saldo + NEW.cuantia WHERE iban = NEW.IBAN_cuentaReceptora;
            UPDATE CuentaCorriente SET saldo = saldo + NEW.cuantia WHERE iban = NEW.IBAN_cuentaReceptora;
            UPDATE CuentaAhorro SET saldo = saldo + NEW.cuantia WHERE iban = NEW.IBAN_cuentaReceptora;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_gestionar_saldo_operaciones
AFTER INSERT OR UPDATE OR DELETE ON Operacion
FOR EACH ROW EXECUTE FUNCTION gestionar_saldo_operaciones();

CREATE TRIGGER trigger_gestionar_saldo_operaciones_efectiva
AFTER INSERT OR UPDATE OR DELETE ON OperacionEfectiva
FOR EACH ROW EXECUTE FUNCTION gestionar_saldo_operaciones();

CREATE TRIGGER trigger_gestionar_saldo_operaciones_transferencia
AFTER INSERT OR UPDATE OR DELETE ON Transferencia
FOR EACH ROW EXECUTE FUNCTION gestionar_saldo_operaciones();








