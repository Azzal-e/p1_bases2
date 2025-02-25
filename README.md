# El directorio se estructura de manera que en cada subdirectorio se encuentran los scripts
  e instrucciones para cada gestor de datos; mientras que en el directorio principal se encuentra
  el fichero docker-compose.yml, que permite levantar todos los contenedores de forma conjunta o 
   separada.

# Pasos previos para poder levantar el docker-compose.yml (se ejecuta desde la máquina 
  virtualizada).

  1. Instalar Docker:
    # Actualizar paquetes para asegurar que el sistema esté actualizado.
    sudo apt update
    sudo apt upgrade -y
    
    #Instalar las dependencias necesarias para poder acceder a repositorios y descargar imagenes.
    sudo apt install ca-certificates curl gnupg lsb-release
    
    # Añadir clave GPG de Docker (para verificar autenticidad de paquetes)
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o     
    /usr/share/keyrings/docker-archive-keyring.gpg
    
    # Añadir repositorio oficial de Docker
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive- 
    keyring.gpg] https://download.docker.com/linux/debian \ $(lsb_release -cs) stable" | sudo tee 
     /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Instalar Docker Engine
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io
  
  2. Instalar Docker Compose:
       
    # Traer del repositorio oficial
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-
    $(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    
    # Dar permisos de ejecución
    sudo chmod +x /usr/local/bin/docker-compose

