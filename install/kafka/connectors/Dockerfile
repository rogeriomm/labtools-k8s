

FROM maven:3.6-jdk-11 as builder

RUN apt-get update && apt-get install -y vim
ADD ./dependencies /workspace/dependencies
WORKDIR /workspace/dependencies
RUN mvn clean install dependency:copy-dependencies -Dconfluent_version=7.5.1
RUN java --version


FROM quay.io/strimzi/kafka:0.39.0-kafka-3.6.1
USER root:root
COPY ./plugins/ /opt/kafka/plugins/
COPY --from=builder /workspace/dependencies/target/dependency/*.jar /opt/kafka/libs/
USER 1001