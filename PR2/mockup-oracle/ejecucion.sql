@/opt/oracle/borrarDatos.sql;

@/opt/oracle/types.sql;

@/opt/oracle/tables.sql;

@/opt/oracle/triggers.sql;

@/opt/oracle/oficina.sql;

ALTER TRIGGER TRG_CLIENTE_MINIMO_UNA_CUENTA DISABLE;

@/opt/oracle/cliente.sql;

ALTER TRIGGER TRG_CLIENTE_MINIMO_UNA_CUENTA ENABLE;

ALTER TRIGGER TRG_CUENTA_ESPECIALIZACION_OBLIGATORIA DISABLE;

@/opt/oracle/cuenta.sql

ALTER TRIGGER TRG_CUENTA_ESPECIALIZACION_OBLIGATORIA ENABLE;

@/opt/oracle/cuentaahorro.sql

@/opt/oracle/cuentacorriente.sql

@/opt/oracle/operacion.sql

@/opt/oracle/transferencia.sql

ALTER TRIGGER TRG_VALIDAR_OPERACION_EFECTIVA DISABLE;

@/opt/oracle/operacionefectiva.sql

ALTER TRIGGER TRG_VALIDAR_OPERACION_EFECTIVA ENABLE;

