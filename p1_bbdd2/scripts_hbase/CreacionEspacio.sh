#!/bin/bash

# Función para verificar si un namespace existe
check_namespace_exists() {
  local namespace=$1
  local result=$(docker exec -i hbase-db hbase shell <<EOF
list_namespace
EOF
  )

  # Verificar si el namespace aparece en la lista
  if echo "$result" | grep -q "$namespace"; then
    echo "El namespace '$namespace' ya existe."
    return 0  # Namespace encontrado
  else
    echo "El namespace '$namespace' no existe."
    return 1  # Namespace no encontrado
  fi
}

# Función para crear un namespace
create_namespace() {
  local namespace=$1

  # Comprobamos si el namespace ya existe
  if ! check_namespace_exists "$namespace"; then
    echo "Creando el namespace '$namespace'..."

    # Crear el namespace
    docker exec -i hbase-db hbase shell <<EOF
create_namespace '$namespace'
EOF

    if [ $? -eq 0 ]; then
      echo "Namespace '$namespace' creado con éxito."
    else
      echo "Error al crear el namespace '$namespace'." >&2
      return 1
    fi
  fi
}

# Crear el namespace 'espacioHBase'
create_namespace 'espacioHBase'
