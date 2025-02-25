-- Conectar al usuario writer
CONNECT writer/writerPass@localhost:1521/XEPDB1;
SHOW USER;

-- Deshabilitar restricciones si existen
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE pruebas DROP CONSTRAINT fk_medico';
EXCEPTION
    WHEN OTHERS THEN
        NULL;  -- Si la restricción no existe, no hacemos nada
END;
/

BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE pruebas DROP CONSTRAINT fk_paciente';
EXCEPTION
    WHEN OTHERS THEN
        NULL;  -- Si la restricción no existe, no hacemos nada
END;
/

-- Eliminar las tablas en el orden correcto (primero las que tienen claves foráneas)
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE pruebas CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;  -- Si la tabla no existe, no hacemos nada
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE medicos CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;  -- Si la tabla no existe, no hacemos nada
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE pacientes CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL;  -- Si la tabla no existe, no hacemos nada
END;
/

-- Confirmar eliminación
COMMIT;
