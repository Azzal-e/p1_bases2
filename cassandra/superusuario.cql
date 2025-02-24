CREATE ROLE superadmin WITH PASSWORD = 'supercassandra' AND LOGIN = true AND SUPERUSER = true;

CREATE KEYSPACE practicas_ks 
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

DESCRIBE KEYSPACES;

USE practicas_ks;
