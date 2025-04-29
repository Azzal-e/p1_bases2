# Compila los archivos usando Java versión 8 (Eclipse Adoptium JDK 8)
# Genera los .class en la carpeta bin\
& "C:\Program Files\Eclipse Adoptium\jdk-8.0.452.9-hotspot\bin\javac.exe" -cp "lib/*" -d bin src/uni/*.java   

# Copia los archivos de configuración META-INF\ necesarios para la ejecución
Copy-Item -Recurse -Force src\META-INF\ -Destination bin\
