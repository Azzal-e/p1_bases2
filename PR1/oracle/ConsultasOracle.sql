    -- Conexión como usuario reader con su contraseña
    CONNECT reader/readerPass@localhost:1521/XEPDB1;
    
    -- Comprobación de existencia de la tabla 'medicos' antes de mostrar los datos
    DECLARE
        v_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_exists
        FROM all_tables
        WHERE table_name = 'MEDICOS' AND owner = 'WRITER';
    
        IF v_exists > 0 THEN
            EXECUTE IMMEDIATE 'SELECT * FROM WRITER.medicos';
        END IF;
    END;
    /
    
    -- Comprobación de existencia de la tabla 'pacientes' antes de mostrar los datos
    DECLARE
        v_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_exists
        FROM all_tables
        WHERE table_name = 'PACIENTES' AND owner = 'WRITER';
    
        IF v_exists > 0 THEN
            EXECUTE IMMEDIATE 'SELECT * FROM WRITER.pacientes';
        END IF;
    END;
    /
    
    -- Comprobación de existencia de la tabla 'pruebas' antes de mostrar los datos
    DECLARE
        v_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_exists
        FROM all_tables
        WHERE table_name = 'PRUEBAS' AND owner = 'WRITER';
    
        IF v_exists > 0 THEN
            EXECUTE IMMEDIATE 'SELECT * FROM WRITER.pruebas';
        END IF;
    END;
    /
    
    -- Comprobación de existencia de la tabla 'pacientes' antes de realizar la búsqueda
    DECLARE
        v_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_exists
        FROM all_tables
        WHERE table_name = 'PACIENTES' AND owner = 'WRITER';
    
        IF v_exists > 0 THEN
            EXECUTE IMMEDIATE 'SELECT * FROM WRITER.pacientes WHERE nombre LIKE ''%María%''';
        END IF;
    END;
    /
    
    -- Comprobación de existencia de la tabla 'pruebas' antes de realizar la consulta por fecha
    DECLARE
        v_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_exists
        FROM all_tables
        WHERE table_name = 'PRUEBAS' AND owner = 'WRITER';
    
        IF v_exists > 0 THEN
            EXECUTE IMMEDIATE 'SELECT * FROM WRITER.pruebas WHERE fecha = TO_DATE(''2024-02-15'', ''YYYY-MM-DD'')';
        END IF;
    END;
    /
    
    -- Comprobación de existencia de las tablas 'medicos', 'pacientes' y 'pruebas' antes de realizar la consulta detallada
    DECLARE
        v_exists_medicos NUMBER;
        v_exists_pacientes NUMBER;
        v_exists_pruebas NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_exists_medicos
        FROM all_tables
        WHERE table_name = 'MEDICOS' AND owner = 'WRITER';
    
        SELECT COUNT(*) INTO v_exists_pacientes
        FROM all_tables
        WHERE table_name = 'PACIENTES' AND owner = 'WRITER';
    
        SELECT COUNT(*) INTO v_exists_pruebas
        FROM all_tables
        WHERE table_name = 'PRUEBAS' AND owner = 'WRITER';
    
        IF v_exists_medicos > 0 AND v_exists_pacientes > 0 AND v_exists_pruebas > 0 THEN
            EXECUTE IMMEDIATE '
                SELECT m.nombre AS medico, p.nombre AS paciente, pr.tipo_prueba, pr.fecha, pr.resultado
                FROM WRITER.pruebas pr
                JOIN WRITER.medicos m ON pr.dni_medico = m.dni
                JOIN WRITER.pacientes p ON pr.dni_paciente = p.dni';
        END IF;
    END;
    /
