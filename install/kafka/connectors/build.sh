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

plug "postgres"  "2.4.1.Final"
plug "sqlserver" "2.5.0.Final"
plug "mongodb"   "2.4.1.Final"
plug "mysql"     "2.4.1.Final"
plug "oracle"    "2.4.1.Final"

#docker build . -t debezium-connector-postgres:0.39.0-kafka-3.6.1
docker build . -t debezium-connector-postgres:0.39.0-kafka-3.6.1 --no-cache