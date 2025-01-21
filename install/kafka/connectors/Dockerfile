FROM maven:3.6-jdk-11 as builder

RUN apt-get update && apt-get install -y vim
ADD ./dependencies /workspace/dependencies
WORKDIR /workspace/dependencies
RUN mvn clean install dependency:copy-dependencies -Dconfluent_version=6.2.12 -Dapache_version=7.5.1-ce

FROM quay.io/strimzi/kafka:0.39.0-kafka-3.6.1
USER root:root
COPY ./plugins/ /opt/kafka/plugins/

# Copy it to the libs directory instead, as copying to the plugin directory does not work, contrary to what the documentation suggests
# https://debezium.io/documentation/reference/stable/configuration/avro.html#deploying-confluent-schema-registry-with-debezium-containers
COPY --from=builder /workspace/dependencies/target/dependency/*.jar /opt/kafka/libs/
USER 1001
