// Se define el valor cassandraProperties: un diccionario
// con los datos para conectarse al keyspace laboratorio
// de la máquina cassandra
val cassandraProperties = Map("spark.cassandra.connection.host" -> "cassandra",
                        "spark.cassandra.connection.port" -> "9042",
                        "keyspace" -> "laboratorio")

// cargar la tabla hospital al valor laboratory_table
val laboratory_table =
    spark.read.format("org.apache.spark.sql.cassandra").
    options(cassandraProperties).
    option("table","hospital").
	load()

// muestra las 20 primeras filas de la tabla 
laboratory_table.show()


val pivotDF = laboratory_table.groupBy("person").pivot("std_observable_cd").sum("obs_value_nm")
pivotDF.show()
pivotDF.count

// Pregunta 9
val apartado1 = laboratory_table.filter("std_observable_cd = '3255-7'").select(avg("obs_value_nm")).show()
val apartado2 = laboratory_table.filter("person = 123498").select(avg("obs_value_nm")).show()
val apartado3 = laboratory_table.filter("obs_value_nm >= 100").show()

// Pregunta 11
val pregunta11 = laboratory_table.filter("std_observable_cd = '1742-6'").select(avg("obs_value_nm")).show()

// Crear vista en Spark dado el anterior dataframe
laboratory_table.createOrReplaceTempView("lab")

// Pregunta 12
val query1 = spark.sql("SELECT AVG(obs_value_nm) FROM lab WHERE std_observable_cd = '3255-7'").show()
val query2 = spark.sql("SELECT AVG(obs_value_nm) FROM lab WHERE person = 123498").show()
val query3 = spark.sql("SELECT * FROM lab WHERE obs_value_nm >= 100").show()
val query4 = spark.sql("SELECT AVG(obs_value_nm) FROM lab WHERE std_observable_cd = '1742-6'").show()

// Pregunta 13
val query5 = spark.sql("SELECT COUNT(*) FROM (SELECT DISTINCT std_observable_cd FROM lab)").show()
val query6 = spark.sql("SELECT * FROM lab WHERE obs_value_nm >= 100").show()