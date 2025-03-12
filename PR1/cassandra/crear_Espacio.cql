DROP KEYSPACE IF EXISTS practicas_ks;

-- Crear nuevo keyspace con un solo nodo y sin copia de datos
CREATE KEYSPACE practicas_ks WITH replication = {
  'class': 'SimpleStrategy',
  'replication_factor': 1
};