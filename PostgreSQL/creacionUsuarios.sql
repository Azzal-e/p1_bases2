-- Conectar a la base de datos específica
\connect practicas_bd

-- Eliminar usuarios y roles existentes si existen
DROP OWNED BY lector CASCADE;
DROP OWNED BY escritor CASCADE;
-- Revocar claramente permisos asignados a roles antes de eliminarlos
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM rol_lector CASCADE;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM rol_lector CASCADE;
REVOKE ALL PRIVILEGES ON SCHEMA public FROM rol_lector CASCADE;
REVOKE ALL PRIVILEGES ON DATABASE practicas_bd FROM rol_lector CASCADE;

REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM rol_escritor CASCADE;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM rol_escritor CASCADE;
REVOKE ALL PRIVILEGES ON SCHEMA public FROM rol_escritor CASCADE;
REVOKE ALL PRIVILEGES ON DATABASE practicas_bd FROM rol_escritor CASCADE;

-- Limpiar claramente default privileges asignados previamente por estos roles
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM rol_lector;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON SEQUENCES FROM rol_lector;

ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM rol_escritor;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON SEQUENCES FROM rol_escritor;

DROP ROLE IF EXISTS escritor;
DROP ROLE IF EXISTS lector;
DROP ROLE IF EXISTS rol_lector;
DROP ROLE IF EXISTS rol_escritor;

-- 1. Modificar contraseña del superusuario
ALTER USER admin WITH PASSWORD 'admin123';

-- 2. Crear rol lector, con  solo permisos de lectura
CREATE ROLE rol_lector;
GRANT CONNECT ON DATABASE practicas_bd TO rol_lector;
GRANT USAGE ON SCHEMA public TO rol_lector;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO rol_lector;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO rol_lector;
 
 --3.  Crear rol escritor, con permisos de lectura, escritura y modificación
CREATE ROLE rol_escritor;
GRANT CONNECT ON DATABASE practicas_bd TO rol_escritor;
GRANT USAGE ON SCHEMA public TO rol_escritor;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO rol_escritor;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE ON TABLES TO rol_escritor;

--4. Crear usuario lector con login y contraseña
CREATE USER lector WITH PASSWORD 'lector123';
GRANT rol_lector TO lector;

-- 5. Crear usuario escritor con login y contraseña
CREATE USER escritor WITH PASSWORD 'escritor123';
GRANT rol_escritor TO escritor;
