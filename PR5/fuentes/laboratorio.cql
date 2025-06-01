CREATE KEYSPACE IF NOT EXISTS laboratorio WITH REPLICATION =
{ 'class': 'SimpleStrategy',
'replication_factor': '1'
};

CREATE TABLE laboratorio.hospital (
    std_observable_cd text,
    person int,
    std_observable_st text,
    obs_value_nm float,
    PRIMARY KEY ((std_observable_cd), person)
) WITH CLUSTERING ORDER BY (person ASC);


// carga de datos con COPY
COPY laboratorio.hospital (person, std_observable_cd, std_observable_st, obs_value_nm)
FROM '/data/dataset.csv'
WITH DELIMITER=';' AND HEADER=TRUE;

-- Pregunta 4
-- Obtener los códigos de prueba distintos realizados
SELECT DISTINCT std_observable_cd FROM laboratorio.hospital;

-- Pregunta 7 Apartado 1
-- Hallar la media de los valores numéricos observados (atributo obs_value_nm) para la prueba de código 3255-7
SELECT AVG(obs_value_nm) FROM laboratorio.hospital WHERE std_observable_cd = '3255-7';

-- Pregunta 7 Apartado 2
-- Hallar la media de los valores numéricos observados de todas las pruebas realizadas a la persona con identificador igual a 123498
SELECT AVG(obs_value_nm) FROM laboratorio.hospital WHERE person = 123498 ALLOW FILTERING;

-- Pregunta 7 Apartado 3
-- Hallar todas las pruebas con valor numérico observado mayor o igual a 100
SELECT * FROM laboratorio.hospital WHERE obs_value_nm >= 100 ALLOW FILTERING;