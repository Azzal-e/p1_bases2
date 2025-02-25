    -- Conexión como usuario writer y con su contraseña
    CONNECT writer/writerPass@localhost:1521/XEPDB1;
    
    SET SERVEROUTPUT ON;
    
    -- Comprobación de existencia de la tabla 'medicos' antes de insertar
    BEGIN
        -- Intentar acceder a la tabla 'medicos' en el esquema 'WRITER' con EXECUTE IMMEDIATE
        BEGIN
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM WRITER.medicos';
            DBMS_OUTPUT.PUT_LINE('La tabla MEDICOS existe en el esquema WRITER.');
    
            -- Insertar en la tabla 'medicos'
            EXECUTE IMMEDIATE 'INSERT INTO WRITER.medicos (dni, numLicencia, nombre, especialidad, telefono)
                               SELECT ''12345678A'', 98765, ''Dr. Juan Pérez'', ''Cardiología'', ''600123456''
                               FROM dual
                               WHERE NOT EXISTS (SELECT 1 FROM WRITER.medicos WHERE dni = ''12345678A'')';
    
            EXECUTE IMMEDIATE 'INSERT INTO WRITER.medicos (dni, numLicencia, nombre, especialidad, telefono)
                               SELECT ''87654321B'', 12366, ''Dra. Ana Gómez'', ''Neurología'', ''611987654''
                               FROM dual
                               WHERE NOT EXISTS (SELECT 1 FROM WRITER.medicos WHERE dni = ''87654321B'')';
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('La tabla MEDICOS no existe en el esquema WRITER. No se realizarán inserciones.');
        END;
    END;
    /
    
    -- Comprobación de existencia de la tabla 'pacientes' antes de insertar
    BEGIN
        -- Intentar acceder a la tabla 'pacientes' en el esquema 'WRITER' con EXECUTE IMMEDIATE
        BEGIN
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM WRITER.pacientes';
            DBMS_OUTPUT.PUT_LINE('La tabla PACIENTES existe en el esquema WRITER.');
    
            -- Insertar en la tabla 'pacientes'
            EXECUTE IMMEDIATE 'INSERT INTO WRITER.pacientes (dni, nss, nombre, telefono)
                               SELECT ''11111111A'', 1000001, ''Carlos López'', ''654123987''
                               FROM dual
                               WHERE NOT EXISTS (SELECT 1 FROM WRITER.pacientes WHERE dni = ''11111111A'')';
    
            EXECUTE IMMEDIATE 'INSERT INTO WRITER.pacientes (dni, nss, nombre, telefono)
                               SELECT ''22222222B'', 1000002, ''María Fernández'', ''623987654''
                               FROM dual
                               WHERE NOT EXISTS (SELECT 1 FROM WRITER.pacientes WHERE dni = ''22222222B'')';
    
            EXECUTE IMMEDIATE 'INSERT INTO WRITER.pacientes (dni, nss, nombre, telefono)
                               SELECT ''33333333C'', 1000003, ''Pedro Sánchez'', ''698741236''
                               FROM dual
                               WHERE NOT EXISTS (SELECT 1 FROM WRITER.pacientes WHERE dni = ''33333333C'')';
    
            EXECUTE IMMEDIATE 'INSERT INTO WRITER.pacientes (dni, nss, nombre, telefono)
                               SELECT ''44444444D'', 1000004, ''Lucía Rodríguez'', ''677852963''
                               FROM dual
                               WHERE NOT EXISTS (SELECT 1 FROM WRITER.pacientes WHERE dni = ''44444444D'')';
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('La tabla PACIENTES no existe en el esquema WRITER. No se realizarán inserciones.');
        END;
    END;
    /
    
    -- Comprobación de existencia de la tabla 'pruebas' antes de insertar
    BEGIN
        -- Intentar acceder a la tabla 'pruebas' en el esquema 'WRITER' con EXECUTE IMMEDIATE
        BEGIN
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM WRITER.pruebas';
            DBMS_OUTPUT.PUT_LINE('La tabla PRUEBAS existe en el esquema WRITER.');
    
            -- Insertar en la tabla 'pruebas'
            EXECUTE IMMEDIATE 'INSERT INTO WRITER.pruebas (dni_medico, dni_paciente, tipo_prueba, fecha, resultado)
                               SELECT ''12345678A'', ''11111111A'', ''Electrocardiograma'', TO_DATE(''2024-02-15'', ''YYYY-MM-DD''), ''Normal''
                               FROM dual
                               WHERE NOT EXISTS (SELECT 1 FROM WRITER.pruebas WHERE dni_medico = ''12345678A'' AND dni_paciente = ''11111111A'' AND tipo_prueba = ''Electrocardiograma'' AND fecha = TO_DATE(''2024-02-15'', ''YYYY-MM-DD''))';
    
            EXECUTE IMMEDIATE 'INSERT INTO WRITER.pruebas (dni_medico, dni_paciente, tipo_prueba, fecha, resultado)
                               SELECT ''12345678A'', ''22222222B'', ''Ecografía'', TO_DATE(''2024-02-10'', ''YYYY-MM-DD''), ''Sin anomalías''
                               FROM dual
                               WHERE NOT EXISTS (SELECT 1 FROM WRITER.pruebas WHERE dni_medico = ''12345678A'' AND dni_paciente = ''22222222B'' AND tipo_prueba = ''Ecografía'' AND fecha = TO_DATE(''2024-02-10'', ''YYYY-MM-DD''))';
    
            EXECUTE IMMEDIATE 'INSERT INTO WRITER.pruebas (dni_medico, dni_paciente, tipo_prueba, fecha, resultado)
                               SELECT ''87654321B'', ''33333333C'', ''Resonancia magnética'', TO_DATE(''2024-02-18'', ''YYYY-MM-DD''), ''Lesión detectada en L3-L4''
                               FROM dual
                               WHERE NOT EXISTS (SELECT 1 FROM WRITER.pruebas WHERE dni_medico = ''87654321B'' AND dni_paciente = ''33333333C'' AND tipo_prueba = ''Resonancia magnética'' AND fecha = TO_DATE(''2024-02-18'', ''YYYY-MM-DD''))';
    
            EXECUTE IMMEDIATE 'INSERT INTO WRITER.pruebas (dni_medico, dni_paciente, tipo_prueba, fecha, resultado)
                               SELECT ''87654321B'', ''44444444D'', ''Análisis de sangre'', TO_DATE(''2024-02-20'', ''YYYY-MM-DD''), ''Niveles normales''
                               FROM dual
                               WHERE NOT EXISTS (SELECT 1 FROM WRITER.pruebas WHERE dni_medico = ''87654321B'' AND dni_paciente = ''44444444D'' AND tipo_prueba = ''Análisis de sangre'' AND fecha = TO_DATE(''2024-02-20'', ''YYYY-MM-DD''))';
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('La tabla PRUEBAS no existe en el esquema WRITER. No se realizarán inserciones.');
        END;
    END;
    /
