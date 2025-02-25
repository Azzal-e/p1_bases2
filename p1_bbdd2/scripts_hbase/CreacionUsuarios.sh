#!/bin/bash

# Función para verificar si un usuario existe
check_user_exists() {
  local user=$1
  # Escanear la tabla hbase:acl y buscar el usuario en la columna 'l'
  local result=$(docker exec -i hbase-db hbase shell <<EOF
scan 'hbase:acl', {COLUMNS => 'l'}
EOF
  )

  # Buscar el patrón "l:<usuario>" en la salida
  if echo "$result" | grep -q "l:$user"; then
    echo "El usuario '$user' ya existe."
    return 0  # Usuario encontrado
  else
    echo "El usuario '$user' no existe."
    return 1  # Usuario no encontrado
  fi
}

# Función para crear un usuario
create_user() {
  local user=$1
  local role=$2
  local namespace=$3

  # Comprobamos si el usuario ya existe
  if ! check_user_exists "$user"; then
    echo "Creando el usuario '$user' con el rol '$role' en el espacio de nombres '$namespace'..."

    # Crear el usuario
    docker exec -i hbase-db hbase shell <<EOF
grant '$user', '$role', '@$namespace'
EOF

    if [ $? -eq 0 ]; then
      echo "Usuario '$user' creado con éxito."
    else
      echo "Error al crear el usuario '$user'." >&2
      return 1
    fi
  fi
}

# Crear usuarios
create_user 'admin' 'RWXCA' 'espacioHBase'
create_user 'escritor' 'RW' 'espacioHBase'
create_user 'hiho' 'R' 'espacioHBase'
