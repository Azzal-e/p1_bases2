    #!/bin/bash

    # Función para obtener la lista de tablas
    get_tables() {
      docker exec -i hbase-db hbase shell "list"
    }
    
    tables=$(get_tables)
       
    # Verificar si las tablas 'medicos', 'pacientes', y 'pruebas' existen antes de insertar
    if [[ "$tables" == *"medicos"* ]]; then
      echo "La tabla 'medicos' ya existe, insertando datos..."
      docker exec -i hbase-db hbase shell "put 'medicos', '12345678A', 'info:numLicencia', '98765'"
      docker exec -i hbase-db hbase shell "put 'medicos', '12345678A', 'info:nombre', 'Dr. Juan Pérez'"
      docker exec -i hbase-db hbase shell "put 'medicos', '12345678A', 'info:especialidad', 'Cardiología'"
      docker exec -i hbase-db hbase shell "put 'medicos', '12345678A', 'info:telefono', '600123456'"
    else
      echo "La tabla 'medicos' no existe, no se insertarán datos."
    fi
    
    # Verificar lo mismo para 'pacientes' y 'pruebas'
    if [[ "$tables" == *"pacientes"* ]]; then
      echo "La tabla 'pacientes' ya existe, insertando datos..."
      docker exec -i hbase-db hbase shell "put 'pacientes', '11111111A', 'info:nss', '1000001'"
    else
      echo "La tabla 'pacientes' no existe, no se insertarán datos."
    fi
    
    if [[ "$tables" == *"pruebas"* ]]; then
      echo "La tabla 'pruebas' ya existe, insertando datos..."
      docker exec -i hbase-db hbase shell "put 'pruebas', '1', 'info:dni_medico', '12345678A'"
    else
      echo "La tabla 'pruebas' no existe, no se insertarán datos."
    fi
