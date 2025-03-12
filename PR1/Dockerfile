FROM dajobe/hbase

# Instala Java 8 (OpenJDK)
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get clean

# Configura la variable JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
