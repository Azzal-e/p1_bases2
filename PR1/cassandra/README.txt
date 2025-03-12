# 1. Para levantar el contenedor, ejecutar desde el propio directorio
     en el que se encuentra el fichero docker-compose.yml
     docker compose up -d cassandra-db

# 2. Posteriormente, para levantar y parar el contenedor, ejecutar desde el propio directorio
     docker compose start cassandra-db
     docker compose stop cassandra-db

# 3. Se puede interactuar con el contenedor de las siguientes formas:

    # 3.1. ACCEDER A INTERFAZ INTERACTIVA
    docker exec -it cassandra-db cqlsh -u <usuario> -p <contraseña>

    # 3.2. EJECUTAR DIRECTAMENTE DESDE  FUERA
    docker exec -it cassandra-db cqlsh -u <usuario> -p <contraseña> "comando CQL"

    # 3.3. PROCEDIMIENTO PARA EJECUTAR SCRIPT
    docker cp <script.cql> cassandra-db:/<script.cql>
    docker exec -i cassandra-db cqlsh -u <usuario> -p <contraseña> -f /<script.cql>
    
# 4. Para activar autenticación y permisos, seguir los siguientes pasos:

    # 4.1. Copiar fuera del contenedor y abrir el fichero
    docker cp cassandra-db:/etc/cassandra/cassandra.yaml ./cassandra.yamlç
    nano cassandra.yaml

    # 4.2. MODIFICAR LAS LÍNEAS "authenticator" y "authorizer"
    authenticator: PasswordAuthenticator
    authorizer: CassandraAuthorizer

    # 4.3. Copiar el fichero modificado y reiniciar contenedor para aplicar cambios
    docker cp ./cassandra.yaml cassandra-db:/etc/cassandra/cassandra.yaml
    docker restart cassandra-db 
     
