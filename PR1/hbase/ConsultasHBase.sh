    #!/bin/bash

    # Función para obtener la lista de tablas
    get_tables() {
      docker exec -i hbase-db hbase shell "list"
    }
    
    tables=$(get_tables)
    
    # Verificar si la tabla 'medicos' existe antes de hacer la consulta
    if [[ "$tables" == *"medicos"* ]]; then
      echo "La tabla 'medicos' existe, mostrando todas las filas..."
      docker exec -i hbase-db hbase shell "scan 'medicos'"
    else
      echo "La tabla 'medicos' no existe, no se puede realizar la consulta."
    fi
    
    # Verificar si la tabla 'pacientes' existe antes de hacer la consulta
    if [[ "$tables" == *"pacientes"* ]]; then
      echo "La tabla 'pacientes' existe, mostrando todas las filas..."
      docker exec -i hbase-db hbase shell "scan 'pacientes'"
    else
      echo "La tabla 'pacientes' no existe, no se puede realizar la consulta."
    fi
    
    # Verificar si la tabla 'pruebas' existe antes de hacer la consulta
    if [[ "$tables" == *"pruebas"* ]]; then
      echo "La tabla 'pruebas' existe, mostrando todas las filas..."
      docker exec -i hbase-db hbase shell "scan 'pruebas'"
    else
      echo "La tabla 'pruebas' no existe, no se puede realizar la consulta."
    fi
    
    # Consulta para buscar información de un paciente específico
    if [[ "$tables" == *"pacientes"* ]]; then
      echo "Buscando información de un paciente específico..."
      docker exec -i hbase-db hbase shell "scan 'pacientes', {FILTER => \"SingleColumnValueFilter('info', 'nombre', =, 'substring:María')\"}"
    else
      echo "La tabla 'pacientes' no existe, no se puede realizar la consulta."
    fi
    
    # Consulta para obtener las pruebas realizadas en una fecha específica
    if [[ "$tables" == *"pruebas"* ]]; then
      echo "Buscando pruebas realizadas en una fecha específica..."
      docker exec -i hbase-db hbase shell "scan 'pruebas', {FILTER => \"SingleColumnValueFilter('info', 'fecha', =, 'binary:2024-02-15')\"}"
    else
      echo "La tabla 'pruebas' no existe, no se puede realizar la consulta."
    fi
    
    # Consulta para obtener los detalles de las pruebas médicas
    if [[ "$tables" == *"pruebas"* ]]; then
      echo "Mostrando detalles de las pruebas médicas..."
      docker exec -i hbase-db hbase shell "scan 'pruebas'"
    else
      echo "La tabla 'pruebas' no existe, no se puede realizar la consulta."
    fi
    
