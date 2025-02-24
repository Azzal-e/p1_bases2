CREATE KEYSPACE practicas_ks 
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

CREATE ROLE escritor WITH PASSWORD = 'escritor123' AND LOGIN = true;
GRANT MODIFY ON KEYSPACE practicas_ks TO escritor;

LIST ROLES;
