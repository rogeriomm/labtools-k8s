FROM maven:3.6-jdk-11 as builder

RUN apt-get update && apt-get install -y vim
ADD ./dependencies /workspace/dependencies
WORKDIR /workspace/dependencies
RUN mvn clean install dependency:copy-dependencies -Dconfluent_version=6.2.12 -Dapache_version=7.5.1-ce
RUN find /workspace/dependencies/target/dependency/

# https://github.com/robcowart/cp-kafka-connect-custom
#   https://docs.confluent.io/platform/current/connect/confluent-hub/client.html
FROM confluentinc/cp-kafka-connect-base:7.5.3 as confluent

# https://github.com/robcowart/cp-kafka-connect-custom/blob/master/confluent.Dockerfile
RUN confluent-hub install --no-prompt confluentinc/connect-transforms:latest && \
    confluent-hub install --no-prompt confluentinc/kafka-connect-avro-converter:latest && \
    confluent-hub install --no-prompt confluentinc/kafka-connect-elasticsearch:latest && \
    confluent-hub install --no-prompt confluentinc/kafka-connect-s3:latest && \
    confluent-hub install --no-prompt debezium/debezium-connector-mongodb:latest && \
    confluent-hub install --no-prompt debezium/debezium-connector-mysql:latest && \
    confluent-hub install --no-prompt debezium/debezium-connector-postgresql:latest && \
    confluent-hub install --no-prompt jcustenborder/kafka-connect-json-schema:latest && \
    confluent-hub install --no-prompt jcustenborder/kafka-connect-redis:latest && \
    confluent-hub install --no-prompt jcustenborder/kafka-connect-transform-common:latest && \
    confluent-hub install --no-prompt jcustenborder/kafka-connect-twitter:latest && \
    confluent-hub install --no-prompt mongodb/kafka-connect-mongodb:latest && \
    confluent-hub install --no-prompt neo4j/kafka-connect-neo4j:latest && \
    confluent-hub install --no-prompt splunk/kafka-connect-splunk:latest && \
    confluent-hub install --no-prompt confluentinc/kafka-connect-cassandra:latest && \
    confluent-hub install --no-prompt confluentinc/kafka-connect-http:latest && \
    confluent-hub install --no-prompt confluentinc/kafka-connect-influxdb:latest && \
    confluent-hub install --no-prompt confluentinc/kafka-connect-mqtt:latest && \
    confluent-hub install --no-prompt confluentinc/kafka-connect-rabbitmq:latest && \
    confluent-hub install --no-prompt confluentinc/kafka-connect-replicator:latest && \
    confluent-hub install --no-prompt confluentinc/kafka-connect-s3-source:latest && \
    confluent-hub install --no-prompt confluentinc/kafka-connect-sftp:latest


# https://github.com/robcowart/cp-kafka-connect-custom/blob/master/community.Dockerfile
FROM confluentinc/cp-kafka-connect-base:7.5.3 as comunity

RUN #confluent-hub install --no-prompt apache/kafka-connect-geode:latest && \
    #confluent-hub install --no-prompt bkatwal/bkatwal-kafka-connect-solr-sink:latest && \
    #confluent-hub install --no-prompt batchsh/sink-connector:latest && \
    #confluent-hub install --no-prompt blueapron/kafka-connect-protobuf-converter:latest && \
    #confluent-hub install --no-prompt C0urante/kafka-connect-reddit:latest && \
    confluent-hub install --no-prompt camunda/kafka-connect-zeebe:latest && \
    #confluent-hub install --no-prompt castorm/kafka-connect-http:latest && \
    #confluent-hub install --no-prompt chaitalisagesh/kafka-connect-log-analytics:latest && \
    confluent-hub install --no-prompt cjmatta/kafka-connect-irc:latest && \
    confluent-hub install --no-prompt cjmatta/kafka-connect-sse:latest && \
    confluent-hub install --no-prompt confluentinc/connect-transforms:latest && \
    confluent-hub install --no-prompt confluentinc/kafka-connect-avro-converter:latest && \
    confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:latest && \
    confluent-hub install --no-prompt confluentinc/kafka-connect-elasticsearch:latest && \
    confluent-hub install --no-prompt confluentinc/kafka-connect-hdfs:latest && \
    confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:latest && \
    confluent-hub install --no-prompt confluentinc/kafka-connect-s3:latest && \
    confluent-hub install --no-prompt confluentinc/kafka-connect-vertica:latest && \
    confluent-hub install --no-prompt couchbase/kafka-connect-couchbase:latest && \
    confluent-hub install --no-prompt datadog/kafka-connect-logs:latest && \
    confluent-hub install --no-prompt datastax/kafka-connect-cassandra-sink:latest && \
    confluent-hub install --no-prompt debezium/debezium-connector-mongodb:latest && \
    confluent-hub install --no-prompt debezium/debezium-connector-mysql:latest && \
    confluent-hub install --no-prompt debezium/debezium-connector-postgresql:latest && \
    confluent-hub install --no-prompt debezium/debezium-connector-sqlserver:latest && \
    #confluent-hub install --no-prompt dhananjaypatkar/kafka-connect-phoenix:latest && \
    confluent-hub install --no-prompt f0xdx/kafka-connect-wrap-smt:latest && \
    #confluent-hub install --no-prompt fbascheper/kafka-connect-telegram:latest && \
    #confluent-hub install --no-prompt findinpath/kafka-connect-nested-set-jdbc-sink:latest && \
    #confluent-hub install --no-prompt hpgrahsl/kafka-connect-mongodb:latest && \
    #confluent-hub install --no-prompt humio/kafka-connect-hec-sink:latest && \
    confluent-hub install --no-prompt jaredpetersen/kafka-connect-arangodb:latest && \
    #confluent-hub install --no-prompt jcustenborder/kafka-connect-aerospike:latest && \
    #confluent-hub install --no-prompt jcustenborder/kafka-connect-email:latest && \
    #confluent-hub install --no-prompt jcustenborder/kafka-connect-flume-avro:latest && \
    #confluent-hub install --no-prompt jcustenborder/kafka-connect-json-schema:latest && \
    #confluent-hub install --no-prompt jcustenborder/kafka-connect-memcached:latest && \
    #confluent-hub install --no-prompt jcustenborder/kafka-connect-opentsdb:latest && \
    #confluent-hub install --no-prompt jcustenborder/kafka-connect-redis:latest && \
    #confluent-hub install --no-prompt jcustenborder/kafka-connect-simulator:latest && \
    #confluent-hub install --no-prompt jcustenborder/kafka-connect-solr:latest && \
    confluent-hub install --no-prompt jcustenborder/kafka-connect-spooldir:latest && \
    #confluent-hub install --no-prompt jcustenborder/kafka-connect-transform-cobol:latest && \
    confluent-hub install --no-prompt jcustenborder/kafka-connect-transform-common:latest && \
    #confluent-hub install --no-prompt jcustenborder/kafka-connect-transform-fix:latest && \
    #confluent-hub install --no-prompt jcustenborder/kafka-connect-transform-maxmind:latest && \
    #confluent-hub install --no-prompt jcustenborder/kafka-connect-transform-xml:latest && \
    confluent-hub install --no-prompt jcustenborder/kafka-connect-twitter:latest && \
    confluent-hub install --no-prompt juxt/kafka-connect-crux:latest && \
    confluent-hub install --no-prompt kaliy/kafka-connect-rss:latest && \
    confluent-hub install --no-prompt marklogic/kafka-marklogic-connector:latest && \
    #confluent-hub install --no-prompt mdrogalis/voluble:latest && \
    #confluent-hub install --no-prompt memsql/memsql-kafka-connector:latest && \
    confluent-hub install --no-prompt microsoft/kafka-connect-iothub:latest && \
    confluent-hub install --no-prompt microsoftcorporation/kafka-sink-azure-kusto:latest && \
    #confluent-hub install --no-prompt mmolimar/kafka-connect-fs:latest && \
    confluent-hub install --no-prompt mongodb/kafka-connect-mongodb:latest && \
    confluent-hub install --no-prompt neo4j/kafka-connect-neo4j:latest && \
    confluent-hub install --no-prompt newrelic/newrelic-kafka-connector:latest && \
    #confluent-hub install --no-prompt nishutayal/kafka-connect-hbase:latest && \
    #confluent-hub install --no-prompt norsktipping/kafka-connect-jdbc_flatten:latest && \
    confluent-hub install --no-prompt opencredo/kafka-connect-venafi:latest && \
    #confluent-hub install --no-prompt riferrei/kafka-connect-pulsar:latest && \
    confluent-hub install --no-prompt rockset/kafka-connect-rockset:latest && \
    confluent-hub install --no-prompt rudderstack/kafka-connect-rudderstack:latest && \
    #confluent-hub install --no-prompt sanjuthomas/kafka-connect-gcp-bigtable:latest && \
    #confluent-hub install --no-prompt sanjuthomas/kafka-connect-orientdb:latest && \
    #confluent-hub install --no-prompt ScyllaDB/kafka-connect-scylladb:latest && \
    confluent-hub install --no-prompt snowflakeinc/snowflake-kafka-connector:latest && \
    confluent-hub install --no-prompt splunk/kafka-connect-splunk:latest && \
    confluent-hub install --no-prompt spoudinc/spoud-agoora:latest && \
    confluent-hub install --no-prompt streamthoughts/kafka-connect-file-pulse:latest && \
    confluent-hub install --no-prompt thomaskwscott/kafka-connect-shell-sink:latest && \
    confluent-hub install --no-prompt thomaskwscott/kafka-connect-shell-source:latest && \
    confluent-hub install --no-prompt wepay/kafka-connect-bigquery:latest
    #confluent-hub install --no-prompt yugabyteinc/yb-kafka-connector:latest && \
    #confluent-hub install --no-prompt zeebe-io/kafka-connect-zeebe:latest

FROM quay.io/strimzi/kafka:0.39.0-kafka-3.6.1
USER root:root
COPY ./plugins/ /opt/kafka/plugins/

# https://debezium.io/documentation/reference/stable/configuration/avro.html#deploying-confluent-schema-registry-with-debezium-containers
#   "Beginning with Debezium 2.0.0, Confluent Schema Registry support is not included in the Debezium containers"
#COPY --from=builder /workspace/dependencies/target/dependency/*.jar /opt/kafka/libs/
COPY --from=confluent /usr/share/confluent-hub-components /opt/kafka/plugins/
COPY --from=comunity /usr/share/confluent-hub-components /opt/kafka/plugins/

USER 1001
