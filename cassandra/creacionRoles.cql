-- Limpiar previamente roles si existen 
DROP ROLE IF EXISTS admin;
DROP ROLE IF EXISTS lector;
DROP ROLE IF EXISTS escritor;

-- crear admin con todos los permisos
CREATE ROLE admin WITH PASSWORD = 'admin123' AND SUPERUSER = true AND LOGIN = true;

-- Crear lector con permisos de lectura
CREATE ROLE lector WITH PASSWORD = 'lector123' AND LOGIN = true;
GRANT SELECT ON KEYSPACE practicas_ks TO lector;

-- Crear rol escritor con permisos de modificación
CREATE ROLE escritor WITH PASSWORD = 'escritor123' AND LOGIN = true;
GRANT MODIFY ON KEYSPACE practicas_ks TO escritor;