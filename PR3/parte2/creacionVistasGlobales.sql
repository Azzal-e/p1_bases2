-- Integración de ambas tablas con db-link

CREATE EXTENSION IF NOT EXISTS dblink;

SELECT dblink_connect('dbname=tienda user=admin password=admin host=localhost port=5432');