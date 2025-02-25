README.txt - Instalación y Configuración de Oracle en Docker

Este documento guía en la instalación y configuración de Oracle Database utilizando Docker, creación de usuarios, tablespaces, tablas, inserciones de datos y consultas.

--------------------------------------------------
1. Requisitos Previos
--------------------------------------------------
- Docker instalado en el sistema.
- Acceso a línea de comandos (bash o similar).
- DBeaver Enterprise (opcional, para gestión gráfica).

--------------------------------------------------
2. Iniciar Contenedor Oracle
--------------------------------------------------
Archivo: `docker-compose.yml`

Pasos:
1. Iniciar el contenedor:
      docker-compose up -d oracle-xe

2. Verificar estado:
      docker ps | grep oracle-xe

3. Configurar Cliente Oracle Instant
      Archivos: Scripts de instalación de Instant Client y SQL*Plus.

      Pasos:
        Instalar dependencias:
           sudo apt update && sudo apt install alien libaio1 wget
        Descargar y configurar Oracle Instant Client 23.7.

      Añadir variables al .bashrc:
        export ORACLE_HOME=$HOME/instantclient_23_7
        export LD_LIBRARY_PATH=$ORACLE_HOME
        export PATH=$PATH:$ORACLE_HOME

      Creación de Usuarios y Tablespaces
        Archivos:
           CreacionUsuariosOracle.sh: Crea usuarios 'writer' y 'reader'.
           CreacionEspaciosOracle.sh: Crea el tablespace 'myworkspace'.

        Ejecución: 
           ./CreacionEspaciosOracle.sh
           ./CreacionUsuariosOracle.sh

      Creación de Tablas
        Archivo: CreacionTablasOracle.sql

        Ejecución:
           - Copiar al contenedor:
                docker cp CreacionTablasOracle.sql oracle-xe:/opt/oracle/
           - Ejecutar como 'writer':
                docker exec -it oracle-xe sqlplus writer/writerPass@localhost:1521/XEPDB1 @/opt/oracle/CreacionTablasOracle.sql

      Insertar Datos
        Archivo: InsercionTablasOracle.sql

        Ejecución:
           - Copiar al contenedor:
                docker cp InsercionTablasOracle.sql oracle-xe:/opt/oracle/
           - Ejecutar como 'writer':
                docker exec -it oracle-xe sqlplus writer/writerPass@localhost:1521/XEPDB1 @/opt/oracle/InsercionTablasOracle.sql

      Realizar Consultas
        Archivo: ConsultasOracle.sql

        Ejecución:
           - Copiar al contenedor:
               docker cp ConsultasOracle.sql oracle-xe:/opt/oracle/
           - Ejecutar como 'reader':
               docker exec -it oracle-xe sqlplus reader/readerPass@localhost:1521/XEPDB1 @/opt/oracle/ConsultasOracle.sql

      Conexión con DBeaver Enterprise
        Configuración:
           Tipo de base de datos: Oracle
           Host: localhost
           Puerto: 1521
           SID/Servicio: XEPDB1
           Usuario/Contraseña: Usar credenciales de 'writer' o 'reader'.
 
           (Ver imagen de referencia: configuracion_ajustes_conexion_oracle.png)

      Archivos Clave
        docker-compose.yml: Define el servicio Oracle en Docker.
        CreacionUsuariosOracle.sh: Script para crear usuarios con privilegios.
        CreacionEspaciosOracle.sh: Script idempotente para tablespaces.
        CreacionTablasOracle.sql: Define estructura de tablas.
        InsercionTablasOracle.sql: Pobla tablas con datos iniciales.
        ConsultasOracle.sql: Ejemplos de consultas para el usuario 'reader'.

Notas Importantes
  Todos los scripts verifican la existencia previa de objetos para evitar errores.

  El tablespace 'myworkspace' se configura con autoextensión ilimitada.

  Para reiniciar desde cero: Eliminar contenedor y volúmenes asociados.
