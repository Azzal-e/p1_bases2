@echo off
rem Compilando las clases Java
javac -cp .\LIB\db4o-8.0.249.16098-all-java5.jar -d CLASSES .\SRC\*.java

rem Ejecutando el programa Main
java --add-opens java.base/java.lang=ALL-UNNAMED -cp .\CLASSES;.\LIB\db4o-8.0.249.16098-all-java5.jar Main


rem Pausa para ver la salida
pause
