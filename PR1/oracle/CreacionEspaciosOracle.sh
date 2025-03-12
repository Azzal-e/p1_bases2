#!/bin/bash

CONTAINER_NAME="oracle-xe"
SYSDBA_USER="sys"
SYSDBA_PASS="oracle123"
DB_NAME="XEPDB1"

# Función para ejecutar SQL
run_sql() {
    local sql_command=$1
    docker exec -i "$CONTAINER_NAME" bash -c "echo \"$sql_command\" | sqlplus -S $SYSDBA_USER/$SYSDBA_PASS@\"$DB_NAME\" AS SYSDBA"
}

# Verificar si el tablespace existe
check_tablespace_exists() {
    local tablespace=$1
    local sql_query="
SET HEADING OFF
SET FEEDBACK OFF
SELECT COUNT(*) FROM dba_tablespaces WHERE tablespace_name = UPPER('$tablespace');
EXIT;
"
    local result=$(run_sql "$sql_query" | tr -d ' \n\r')
    [ "$result" -eq 1 ] 2>/dev/null
}

# Verificar si el datafile existe en la base de datos
check_datafile_exists() {
    local datafile=$1
    local sql_query="
SET HEADING OFF
SET FEEDBACK OFF
SELECT COUNT(*) FROM dba_data_files WHERE file_name LIKE '%$datafile%';
EXIT;
"
    local result=$(run_sql "$sql_query" | tr -d ' \n\r')
    [ "$result" -gt 0 ] 2>/dev/null
}

# Crear tablespace con nombre de archivo único
create_tablespace() {
    local tablespace=$1
    local datafile="${tablespace}1.dbf"
    local counter=1

    # Verificar si el tablespace ya existe
    if check_tablespace_exists "$tablespace"; then
        echo "El tablespace '$tablespace' YA EXISTE. No se realiza ninguna acción."
        return 0
    fi

    # Generar nombre de datafile único
    while check_datafile_exists "$datafile"; do
        datafile="${tablespace}${counter}.dbf"
        ((counter++))
    done

    echo "Creando tablespace '$tablespace' con datafile: $datafile"
    run_sql "CREATE TABLESPACE $tablespace DATAFILE '$datafile' SIZE 100M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED;"

    if check_tablespace_exists "$tablespace"; then
        echo "Tablespace '$tablespace' creado exitosamente."
    else
        echo "Error al crear el tablespace '$tablespace' (posible conflicto de datafile)." >&2
        return 1
    fi
}

# --- Ejecutar creación ---
create_tablespace "myworkspace"
