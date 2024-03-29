# https://strimzi.io/docs/operators/latest/deploying.html#creating-new-image-using-kafka-connect-build-str
# https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/
# https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/2.4.0.Final/

plug()
{
  connector="$1"
  version="$2"

  file="debezium-connector-${connector}-${version}-plugin.tar.gz"

  wget -c -P . \
    "https://repo1.maven.org/maven2/io/debezium/debezium-connector-${connector}/${version}/$file" \
    2> /dev/null
  cd plugins
  tar -zxf ../$file
  cd ..
}

# Debezium connectors
#plug "postgres"                "2.5.0.Final"
plug "sqlserver"               "2.5.0.Final"
#plug "mongodb"                 "2.5.0.Final"
#plug "mysql"                   "2.5.0.Final"
#plug "oracle"                  "2.5.0.Final"
#plug "jdbc"                    "2.5.0.Final"
#plug "cassandra-4"             "2.5.0.Final"
#plug "connect-rest-extension"  "2.5.0.Final" "https://github.com/debezium/debezium/tree/main/debezium-connect-rest-extension"

docker build . -t registry.minikube/debezium-connector-postgres:0.39.0-kafka-3.6.1 #--no-cache
