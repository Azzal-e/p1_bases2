README.txt - Instalación y Configuración de HBase en Docker

Este documento describe la instalación de HBase en Docker, configuración de seguridad sin Kerberos, y operaciones básicas con datos.

--------------------------------------------------
1. Requisitos Previos
--------------------------------------------------
- Docker instalado
- Docker Compose
- Acceso a terminal Linux

--------------------------------------------------
2. Iniciar Contenedor HBase
--------------------------------------------------
Archivos: `docker-compose.yml`
          `Dockerfile`
Pasos:

1. Iniciar el contenedor:
     docker-compose up -d hbase-db

2. Verificar estado:
     docker ps | grep hbase-db

3. Configuración sin Kerberos

     Archivos clave modificados:
        hbase-site.xml: Configura autenticación simple
        hbase-env.sh: Ajustes de entorno
        regionservers: Lista de nodos
        
     Pasos post-instalación:
        
        Copiar configuración al contenedor:
           docker cp hbase-site.xml hbase-db:/opt/hbase/conf/

        Reiniciar servicio:
           docker restart hbase-db
  
4. Creación de Namespace

     Archivo: CreacionEspacioHBase.sh

     Ejecución (crea el namespace 'espacioHBase' si no existe):
        ./CreacionEspacioHBase.sh

5. Gestión de Usuarios y Permisos
     Archivo: CreacionUsuariosHBase.sh

     Roles creados:
        admin: Permisos completos (RWXCA)
        escritor: Lectura/Escritura (RW)
        lector: Solo lectura (R)

     Ejecución:
        ./CreacionUsuariosHBase.sh

6. Creación de Tablas
     Archivo: CreacionTablasHBase.hbase

     Tablas creadas:
        medicos
        pacientes
        pruebas

     Ejecución:
        cat CreacionTablasHBase.hbase | docker exec -i hbase-db hbase shell

7. Inserción de Datos
     Archivo: InsercionTablasHBase.sh

     Ejecución (inserta datos de ejemplo verificando previamente la existencia de tablas):
        chmod +x InsercionTablasHBase.sh
        ./InsercionTablasHBase.sh

8. Realizar Consultas
     Archivo: ConsultasHBase.sh

     Consultas incluidas:
        Listado completo de registros
        Búsquedas específicas por paciente/fecha
        Join lógico entre tablas

     Ejecución:
        chmod +x ConsultasHBase.sh
        ./ConsultasHBase.sh

9. Archivos Clave
     Configuración principal:
        hbase-site.xml: Parámetros de autenticación y seguridad
        zoo.cfg: Configuración de ZooKeeper
        core-site.xml: Integración con HDFS

     Scripts de operación:
        CreacionEspacioHBase.sh
        CreacionUsuariosHBase.sh
        CreacionTablasHBase.hbase
        InsercionTablasHBase.sh
        ConsultasHBase.sh


Notas Importantes
   La configuración usa seguridad básica con hbase:acl

   Todos los scripts verifican existencia previa de objetos

   Para reiniciar desde cero: Eliminar contenedor y volúmenes

   Se omitió Kerberos por problemas de compatibilidad

   Verifique siempre los permisos con:
      docker exec -it hbase-db hbase shell scan 'hbase:acl'


