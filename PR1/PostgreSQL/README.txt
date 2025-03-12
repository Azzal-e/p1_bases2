# 1. Para levantar el contenedor, ejecutar desde el propio directorio
    docker compose up -d postgres

# 2. Posteriormente, para levantar y parar el contenedor, ejecutar desde el propio directorio
    docker compose start postgres
    docker compose stop postgres

# 3. Se puede interactuar con el contenedor de las siguientes formas:

    # 3.1. ACCEDER A INTERFAZ INTERACTIVA
    #   (ejemplo para entrar como administrador)
    docker exec -it postgres-db psql -U

    # 3.2. EJECUTAR DIRECTAMENTE DESDE  FUERA
    docker exec -it postgres-db psql -U admin -c "comando SQL"

    # 3.3. PROCEDIMIENTO PARA EJECUTAR SCRIPT
    # EJECUTANDO DESDE DENTRO DEL CONTENEDOR NO ES
    # NECESARIO AUTENTICAR
    docker cp <script.sql> postgres-db:/tmp/<script.sql>
    docker exec -it postgres-db psql -U <usuario> -d practicas_bd -f 
