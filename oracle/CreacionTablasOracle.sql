    -- Conectar al usuario writer con su contraseña
    CONNECT writer/writerPass@localhost:1521/XEPDB1;
    SHOW USER;
    
    -- Eliminar las tablas si ya existen, y si no, no se hace nada
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE pruebas CASCADE CONSTRAINTS';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;  
    END;
    /
    
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE pacientes CASCADE CONSTRAINTS';
    EXCEPTION
        WHEN OTHERS THEN
            NULL; 
    END;
    /
    
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE medicos CASCADE CONSTRAINTS';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;  
    END;
    /
    
    -- Crear la tabla de médicos
    CREATE TABLE medicos (
        dni VARCHAR2(9) PRIMARY KEY,
        numLicencia NUMBER NOT NULL UNIQUE,
        nombre VARCHAR2(100) NOT NULL,
        especialidad VARCHAR2(100) NOT NULL,
        telefono VARCHAR2(15)
    );
    
    -- Crear la tabla de pacientes
    CREATE TABLE pacientes (
        dni VARCHAR2(9) PRIMARY KEY,
        nss NUMBER NOT NULL UNIQUE,
        nombre VARCHAR2(100),
        telefono VARCHAR2(15)
    );
    
    -- Crear la tabla de pruebas médicas
    CREATE TABLE pruebas (
        id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        dni_medico VARCHAR2(9) NOT NULL,
        dni_paciente VARCHAR2(9) NOT NULL,
        tipo_prueba VARCHAR2(100),
        fecha DATE,
        resultado VARCHAR2(200),
        CONSTRAINT fk_medico FOREIGN KEY (dni_medico) REFERENCES medicos(dni),
        CONSTRAINT fk_paciente FOREIGN KEY (dni_paciente) REFERENCES pacientes(dni)
    );
