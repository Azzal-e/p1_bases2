-- DESACTIVAR TRIGGER
ALTER TABLE Operacion DISABLE TRIGGER trigger_bloquear_insercion_operacion;

-- REACTIVAR TRIGGER
ALTER TABLE Operacion ENABLE TRIGGER trigger_bloquear_insercion_operacion;
