/**
 * Diseño lógico empleando el modelo objeto/relacional
    empleando el estándar SQL:1999.
 */

-- Creacion de DISTINCT TYPES / ROWS

CREATE TYPE DNI AS VARCHAR(20)
CREATE TYPE IBAN AS (prefijoIBAN VARCHAR(4), numeroCuenta VARCHAR(30))
CREATE TYPE TELEFONO AS VARCHAR(16)



--------------------------------CREACIÓN DE TIPOS--------------------------------

CREATE TYPE ClienteUdt AS (
   dni DNI,
   nombre VARCHAR(50),
   apellidos VARCHAR(75),
   fechaDeNacimiento DATE,
   telefono TELEFONO,
   direccion VARCHAR(200),
   email VARCHAR(250),
   refCuenta ref(asignaturaUdt) array[50] scope Cuenta 
      references are checked on delete set null

) instanciable not final is system generated; 

CREATE METHOD getEdad RETURNS INTEGER FOR ClienteUdt;

CREATE TYPE CuentaUdt AS (
   iban IBAN,
   fechaDeCreacion DATE,
   saldo DECIMAL(15,2) DEFAULT 0,
   refTitular ref(ClienteUdt) array[6] scope Cliente 
      references are checked on delete set null
)instanciable not final is system generated; 

CREATE TYPE cuentaCorrienteUdt under cuentaUdt AS(
   refOficina_Adscrito ref(oficinaUdt) scope Oficiona 
      references are checked on delete set null
   
)instanciable not final; 

CREATE TYPE cuentaAhorroUdt under cuentaUdt AS(
   interes DECIMAL(5,2),
)instanciable not final;

CREATE TYPE oficinaUdt AS(
   codigoOficina DECIMAL(4,0),
   direccion VARCHAR(100),
   telefono TELEFONO,
   -- ASOCIACION CON CUENTA UNIDIRECCIONAL, AQUÍ  NO HAY REFERENCIAS
)instanciable not final is system generated; 

CREATE TYPE operacionUdt AS (
   codigo DECIMAL(10,0),
   IBAN_cuentaEmisora IBAN,
   fechaYHora TIMESTAMP,
   cuantia DECIMAL(15,2),
   descripcion VARCHAR(200),
   refCuenta_Emisora ref(cuentaUdt) scope Cuenta 
      references are checked on delete cascade
)instanciable not final is system generated; 

CREATE TYPE operacionEfectivaUdt under operacionUdt AS(
   tipoOperacion VARCHAR(20),
   refSucursal ref(oficinaUdt) scope Oficina 
      references are checked on delete cascade
)instanciable not final; 

CREATE TYPE  transferenciaUdt under operacionUdt AS (
   refCuenta_Receptora ref(cuentaUdt) scope Cuenta 
      references are checked on delete cascade
)instanciable not final; 

--------------------------------CREACIÓN DE TABLAS--------------------------------

CREATE TABLE Cliente of ClienteUdt (
   PRIMARY KEY (dni),
   CONSTRAINT nombre_obligatorio CHECK (nombre IS NOT NULL),
   CONSTRAINT apellidos_obligatorio CHECK (apellidos IS NOT NULL),
   CONSTRAINT fechaDeNacimiento_obligatorio CHECK (fechaDeNacimiento IS NOT NULL),
   CONSTRAINT telefono_obligatorio CHECK (telefono IS NOT NULL),
   CONSTRAINT direccion_obligatorio CHECK (direccion IS NOT NULL),
   CONSTRAINT telefono_valido CHECK (telefono LIKE '\+\d+'),
   CONSTRAINT email_valido CHECK (email LIKE '%@%.%')
   ref is clientID system generated
)
CREATE TABLE Cuenta of CuentaUdt (
   PRIMARY KEY (IBAN),
   CONSTRAINT fechaCreacion_obligatoria CHECK (fechaCreacion IS NOT NULL),
   CONSTRAINT saldo_obligatorio CHECK (saldo IS NOT NULL),
   CONSTRAINT saldo_positivo CHECK (saldo >= 0),


)

CREATE TABLE cuentaCorriente of cuentaCorrienteUdt under Cuenta (
   CONSTRAINT refOficina_Adscrito_obligatorio CHECK (refOficina_Adscrito IS NOT NULL),
)

CREATE TABLE cuentaAhorro of cuentaAhorroUdt under Cuenta (
   CONSTRAINT interes_obligatorio CHECK (interes IS NOT NULL),
   CONSTRAINT interes_positivo CHECK (interes >= 0),
)

CREATE TABLE Oficina of oficinaUdt (
   PRIMARY KEY (codigoOficina),
   CONSTRAINT direccion_obligatoria CHECK (direccion IS NOT NULL),
   CONSTRAINT telefono_obligatorio CHECK (telefono IS NOT NULL),
   CONSTRAINT telefono_valido CHECK (telefono LIKE '\+\d+'),
   ref is oficinaID system generated
)

CREATE TABLE Operacion of operacionUdt (
   PRIMARY KEY (codigo, IBAN_cuentaEmisora),
   CONSTRAINT fechaYHora_obligatoria CHECK (fechaYHora IS NOT NULL),
   CONSTRAINT cuantia_obligatoria CHECK (cuantia IS NOT NULL),
   CONSTRAINT refCuenta_Emisora_obligatorio CHECK (refCuenta_Emisora IS NOT NULL),
   CONSTRAINT descripcion_obligatoria CHECK (descripcion IS NOT NULL),
   FOREIGN KEY (IBAN_cuentaEmisora) REFERENCES Cuenta(IBAN) ON DELETE CASCADE,
   ref is operacionID system generated
)

CREATE TABLE OperacionEfectiva of operacionEfectivaUdt under Operacion (
   CONSTRAINT refSucursal_obligatorio CHECK (refSucursal IS NOT NULL),
   CONSTRAINT tipoOperacion_obligatorio CHECK (tipoOperacion IS NOT NULL),
   CONSTRAINT tipoOperacion_valido CHECK (tipoOperacion IN ('INGRESO', 'RETIRADA')),
)

CREATE TABLE Transferencia of transferenciaUdt under Operacion (
   CONSTRAINT refCuenta_Receptora_obligatorio CHECK (refCuenta_Receptora IS NOT NULL),
)


-- RESTRICCIONES ADICIONALES

1. Para toda ocurrencia de IBAN en la tabla cuenta,
   debe existir al menos una ocurrencia de un refCuenta en la tabla Cliente
   tal que DEREF(refCuenta).IBAN = IBAN.

2. Sea <<cliente>> una ocurrencia de la tabla Cliente con DNI = dni, para toda ocurrencia de refCuenta en <<cliente>>,
   debe existir al menos una ocurrencia de refTitular en la tabla cuenta tal que DEREF(refTitular).dni = dni.

3.La fecha de nacimiento de un cliente, de creacion de una cuenta y la fecha y hora de una operacion, 
   deben ser anteriores a la fecha actual.

4. La fecha de una operacion deber ser posterior a la fecha de creacion de una cuenta emisora.

5. La fecha de una transferencia debe ser posterior a la fecha de creacion de la cuenta receptora.

6. Asegurar especialización obligatoria de cuentas y operaciones.


7. Asegurar exclusividad en clases especializadas de cuentas y operaciones.


8. Los arrays de referencias de las tablas cliente y cuenta no pueden tener elementos repetidos.

9. Para toda ocurrencia de refCuenta_Emisora y de IBAN_cuentaEmisora en la tabla operacion, se debe
   verificar que DEREF(refCuenta_Emisora).IBAN = IBAN_cuentaEmisora.


10. Para toda ocurrencia de refCuenta_Emisora y de refCuenta_Receptora en la tabla transferencia, se debe
    verificar que DEREF(refCuenta_Emisora).IBAN != DEREF(refCuenta_Receptora).IBAN.


11 El saldo de las cuentas de ahorro se debe actualizar cada noche
   con el interes que tiene asignado.



12. El saldo de las cuentas debe ser la suma de las operaciones que se han realizado en la cuenta (y para 
    cuentas de ahorro, con el interes aplicado temporalmente). 
