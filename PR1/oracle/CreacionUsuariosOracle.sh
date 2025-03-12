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

# Función para verificar existencia de usuario
user_exists() {
    local username=$1
    local sql_query="SET HEADING OFF; 
SET FEEDBACK OFF; 
SELECT username FROM dba_users WHERE username = UPPER('$username');"

    local result=$(run_sql "$sql_query" | tr -d '[:space:]')
    
    [ -n "$result" ] && return 0 || return 1
}

# Crear usuario solo si no existe
create_user() {
    local user=$1
    local pass=$2
    local privileges=$3

    if ! user_exists "$user"; then
        echo "Creando usuario $user..."
        run_sql "CREATE USER $user IDENTIFIED BY $pass DEFAULT TABLESPACE myworkspace1;"
        run_sql "$privileges"
        echo "Usuario $user creado exitosamente"
    else
        echo "El usuario $user YA EXISTE. No se realiza ninguna acción."
    fi
}

# --- Ejecución principal ---
create_user "writer" "writerPass" "
GRANT CREATE SESSION, CREATE TABLE TO writer;
GRANT ALTER ANY TABLE, CREATE SEQUENCE, CREATE VIEW, CREATE SYNONYM TO writer;
"

create_user "reader" "readerPass" "
GRANT CREATE SESSION TO readerjuju;
"
