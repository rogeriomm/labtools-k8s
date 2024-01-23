
```shell
curl http://my-connect-connect-api.kafka-main-cluster.svc:8083 | jq
```
```text
{"version":"3.6.1","commit":"5e3c2b738d253ff5","kafka_cluster_id":"BW6TQurMQ7ad9AGIzX-2ZQ"}
```

```shell
kubectl -n kafka-main-cluster get kafkaconnectors  debezium-connector-postgres -o yaml | yq
```
```yaml
apiVersion: kafka.strimzi.io/v1beta2
kind: KafkaConnector
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"kafka.strimzi.io/v1beta2","kind":"KafkaConnector","metadata":{"annotations":{},"labels":{"strimzi.io/cluster":"main"},"name":"debezium-connector-postgres","namespace":"kafka-main-cluster"},"spec":{"class":"io.debezium.connector.postgresql.PostgresConnector","config":{"database.hostname":"postgres-postgresql.postgres.svc.cluster2.xpt","database.include.list":"inventory","database.password":"${secrets:debezium-example/debezium-secret:password}","database.port":5432,"database.server.id":184054,"database.user":"${secrets:debezium-example/debezium-secret:username}","schema.history.internal.kafka.bootstrap.servers":"main-kafka-bootstrap:9092","schema.history.internal.kafka.topic":"schema-changes.inventory","tasks.max":1,"topic.prefix":"postgres"},"tasksMax":1}}
  creationTimestamp: "2024-01-12T13:25:08Z"
  generation: 1
  labels:
    strimzi.io/cluster: main
  name: debezium-connector-postgres
  namespace: kafka-main-cluster
  resourceVersion: "5434"
  uid: 867bb405-027b-4376-bbe6-a8c336958f55
spec:
  class: io.debezium.connector.postgresql.PostgresConnector
  config:
    database.hostname: postgres-postgresql.postgres.svc.cluster2.xpt
    database.include.list: inventory
    database.password: ${secrets:debezium-example/debezium-secret:password}
    database.port: 5432
    database.server.id: 184054
    database.user: ${secrets:debezium-example/debezium-secret:username}
    schema.history.internal.kafka.bootstrap.servers: main-kafka-bootstrap:9092
    schema.history.internal.kafka.topic: schema-changes.inventory
    tasks.max: 1
    topic.prefix: postgres
  tasksMax: 1
status:
  conditions:
    - lastTransitionTime: "2024-01-12T13:25:08.652594155Z"
      message: KafkaConnect resource 'main' identified by label 'strimzi.io/cluster' does not exist in namespace kafka-main-cluster.
      reason: NoSuchResourceException
      status: "True"
      type: NotReady
  observedGeneration: 1
  tasksMax: 0
```

   * Postgres User/Password
```shell
kubectl -n kafka-main-cluster get secret postgres-user-debezium -o yaml | yq
```

```shell
host="my-connect-connect-api.kafka-main-cluster.svc:8083"
```

```shell
curl http://$host/connectors/debezium-connector-postgres/config | jq
```





# Print
```shell
kubectl get -n kafka-main-cluster kafkaconnectors debezium-connector-postgres | yq
```
```text
NAME                          CLUSTER      CONNECTOR CLASS                                      MAX TASKS   READY
debezium-connector-postgres   my-connect   io.debezium.connector.postgresql.PostgresConnector   1           
```

# Versions
   * https://kafka.apache.org/downloads
     * Kafka releases
   * https://debezium.io/releases/: Debezium tested versions Java/Kafka Connect/Postgres
      * https://github.com/rogeriomm/labtools-k8s/blob/master/install/kafka/connectors/Dockerfile#L12
   * https://strimzi.io/downloads/
      * Supported versions: operator version, Kafka versions, Kubernetes versions
      * https://github.com/rogeriomm/labtools-k8s/blob/master/k8s/cluster2/helm/kafka/values.yaml#L9\
   * https://debezium.io/documentation/reference/stable/configuration/avro.html
     * "Beginning with Debezium 2.0.0, Confluent Schema Registry support is not included in the Debezium containers"
       * https://packages.confluent.io/maven/io/confluent/kafka-connect-avro-converter/ https://mvnrepository.com/artifact/io.confluent/kafka-connect-avro-converter
         * Version ?
         * https://github.com/rogeriomm/labtools-k8s/blob/master/install/kafka/connectors/dependencies/pom.xml
   * Debezium plugins
     * https://github.com/rogeriomm/labtools-k8s/blob/master/install/kafka/connectors/build.sh#L20
   

# Which is better, decoderbufs or pgoutput, and why?
"Decoderbufs" and "pgoutput" are both logical decoding output plugins for PostgreSQL. 
They are used to stream changes in database tables to external systems. 
The choice between them depends on your specific requirements and setup.
Let's compare them based on some key aspects:

Decoderbufs
Format: Decoderbufs outputs changes in a Protobuf (Protocol Buffers) format. Protobuf is a language-neutral, platform-neutral, extensible way of serializing structured data.
Efficiency: It's generally more efficient in terms of CPU usage and bandwidth because Protobuf is a binary format and is more compact compared to text-based formats.
Compatibility: Being a binary format, it requires compatible Protobuf schema on the client side. This means extra effort in maintaining the schema and ensuring compatibility between producer and consumer.
Use Case: Best suited for high-performance, cross-language applications, especially where bandwidth and efficiency are critical.

pgoutput
Format: pgoutput outputs changes in a text-based format. It's the default output plugin for PostgreSQL's logical replication.
Ease of Use: Since it uses a text-based format, it’s generally easier to debug and understand, especially if you are directly inspecting the replication stream.
Compatibility: Being a default plugin, it tends to have better support and compatibility with various PostgreSQL versions and replication tools.
Use Case: Ideal for standard logical replication needs, especially when using PostgreSQL's built-in replication functionalities or when simplicity and compatibility are prioritized.

Conclusion
Choose Decoderbufs if you need high efficiency in terms of bandwidth and CPU usage, are working in a multi-language environment, and are prepared to handle the complexity of maintaining Protobuf schemas.
Choose pgoutput if you are looking for ease of use, better compatibility with various PostgreSQL tools and versions, and do not have stringent efficiency requirements.
In summary, the "better" option really depends on your specific use case, your team's familiarity with the technologies involved, and your performance requirements.


# Troubleshooting
   * Find config errors
```shell
curl -H "Accept:application/json" http://my-connect-connect-api.kafka-main-cluster.svc:8083/connector-plugins/source/config/validate  | jq
```

  * Get errors from kafkaconnectors Strimzi api 

```shell
kubectl get -n kafka-main-cluster kafkaconnectors debezium-connector-postgres
```

```shell
kubectl get -n kafka-main-cluster kafkaconnectors debezium-connector-postgres -o yaml | yq
```
   * Success output
```yaml
apiVersion: kafka.strimzi.io/v1beta2
kind: KafkaConnector
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"kafka.strimzi.io/v1beta2","kind":"KafkaConnector","metadata":{"annotations":{},"labels":{"strimzi.io/cluster":"my-connect"},"name":"debezium-connector-postgres","namespace":"kafka-main-cluster"},"spec":{"class":"io.debezium.connector.postgresql.PostgresConnector","config":{"database.dbname":"airflow","database.hostname":"postgres-postgresql.postgres.svc.cluster2.xpt","database.password":"debezium","database.port":5432,"database.user":"debezium","plugin.name":"decoderbufs","schema.history.internal.kafka.bootstrap.servers":"main-kafka-bootstrap:9092","schema.history.internal.kafka.topic":"schema-changes.inventory","tasks.max":1,"topic.prefix":"postgres-airflow"},"tasksMax":1}}
  creationTimestamp: "2024-01-22T13:17:22Z"
  generation: 1
  labels:
    strimzi.io/cluster: my-connect
  name: debezium-connector-postgres
  namespace: kafka-main-cluster
  resourceVersion: "106490"
  uid: 89584980-54c6-4c46-b578-84c7c16dc9fc
spec:
  class: io.debezium.connector.postgresql.PostgresConnector
  config:
    database.dbname: airflow
    database.hostname: postgres-postgresql.postgres.svc.cluster2.xpt
    database.password: debezium
    database.port: 5432
    database.user: debezium
    plugin.name: decoderbufs
    schema.history.internal.kafka.bootstrap.servers: main-kafka-bootstrap:9092
    schema.history.internal.kafka.topic: schema-changes.inventory
    tasks.max: 1
    topic.prefix: postgres-airflow
  tasksMax: 1
status:
  conditions:
    - lastTransitionTime: "2024-01-22T14:11:40.091724795Z"
      status: "True"
      type: Ready
  connectorStatus:
    connector:
      state: RUNNING
      worker_id: my-connect-connect-0.my-connect-connect.kafka-main-cluster.svc:8083
    name: debezium-connector-postgres
    tasks:
      - id: 0
        state: RUNNING
        worker_id: my-connect-connect-0.my-connect-connect.kafka-main-cluster.svc:8083
    type: source
  observedGeneration: 1
  tasksMax: 1
  topics:
    - postgres-airflow.public.ab_permission
    - postgres-airflow.public.ab_permission_view
    - postgres-airflow.public.ab_permission_view_role
    - postgres-airflow.public.ab_role
    - postgres-airflow.public.ab_user
    - postgres-airflow.public.ab_user_role
    - postgres-airflow.public.ab_view_menu
    - postgres-airflow.public.alembic_version
    - postgres-airflow.public.connection
    - postgres-airflow.public.job
    - postgres-airflow.public.log
    - postgres-airflow.public.log_template
    - postgres-airflow.public.session
    - postgres-airflow.public.slot_pool
    - postgres-airflow.public.variable
```


See status.conditions fail messages samples:

```yaml
apiVersion: kafka.strimzi.io/v1beta2
kind: KafkaConnector
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"kafka.strimzi.io/v1beta2","kind":"KafkaConnector","metadata":{"annotations":{},"labels":{"strimzi.io/cluster":"main"},"name":"debezium-connector-postgres","namespace":"kafka-main-cluster"},"spec":{"class":"io.debezium.connector.postgresql.PostgresConnector","config":{"database.hostname":"postgres-postgresql.postgres.svc.cluster2.xpt","database.include.list":"inventory","database.password":"${secrets:kafka-main-cluster/postgres-user-debezium:password}","database.port":5432,"database.server.id":184054,"database.user":"${secrets:kafka-main-cluster/postgres-user-debezium:username}","schema.history.internal.kafka.bootstrap.servers":"main-kafka-bootstrap:9092","schema.history.internal.kafka.topic":"schema-changes.inventory","tasks.max":1,"topic.prefix":"postgres"},"tasksMax":1}}
  creationTimestamp: "2024-01-12T13:25:08Z"
  generation: 3
  labels:
    strimzi.io/cluster: main
  name: debezium-connector-postgres
  namespace: kafka-main-cluster
  resourceVersion: "279930"
  uid: 867bb405-027b-4376-bbe6-a8c336958f55
spec:
  class: io.debezium.connector.postgresql.PostgresConnector
  config:
    database.hostname: postgres-postgresql.postgres.svc.cluster2.xpt
    database.include.list: inventory
    database.password: ${secrets:kafka-main-cluster/postgres-user-debezium:password}
    database.port: 5432
    database.server.id: 184054
    database.user: ${secrets:kafka-main-cluster/postgres-user-debezium:username}
    schema.history.internal.kafka.bootstrap.servers: main-kafka-bootstrap:9092
    schema.history.internal.kafka.topic: schema-changes.inventory
    tasks.max: 1
    topic.prefix: postgres
  tasksMax: 1
status:
  conditions:
    - lastTransitionTime: "2024-01-15T16:46:25.834861793Z"
      message: KafkaConnect resource 'main' identified by label 'strimzi.io/cluster' does not exist in namespace kafka-main-cluster.
      reason: NoSuchResourceException
      status: "True"
      type: NotReady
  observedGeneration: 3
  tasksMax: 0
```

```yaml
apiVersion: kafka.strimzi.io/v1beta2
kind: KafkaConnector
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"kafka.strimzi.io/v1beta2","kind":"KafkaConnector","metadata":{"annotations":{},"labels":{"strimzi.io/cluster":"my-connect"},"name":"debezium-connector-postgres","namespace":"kafka-main-cluster"},"spec":{"class":"io.debezium.connector.postgresql.PostgresConnector","config":{"database.hostname":"postgres-postgresql.postgres.svc.cluster2.xpt","database.include.list":"inventory","database.password":"${secrets:kafka-main-cluster/postgres-user-debezium:password}","database.port":5432,"database.server.id":184054,"database.user":"${secrets:kafka-main-cluster/postgres-user-debezium:username}","schema.history.internal.kafka.bootstrap.servers":"main-kafka-bootstrap:9092","schema.history.internal.kafka.topic":"schema-changes.inventory","tasks.max":1,"topic.prefix":"postgres"},"tasksMax":1}}
  creationTimestamp: "2024-01-12T13:25:08Z"
  generation: 3
  labels:
    strimzi.io/cluster: my-connect
  name: debezium-connector-postgres
  namespace: kafka-main-cluster
  resourceVersion: "304421"
  uid: 867bb405-027b-4376-bbe6-a8c336958f55
spec:
  class: io.debezium.connector.postgresql.PostgresConnector
  config:
    database.hostname: postgres-postgresql.postgres.svc.cluster2.xpt
    database.include.list: inventory
    database.password: ${secrets:kafka-main-cluster/postgres-user-debezium:password}
    database.port: 5432
    database.server.id: 184054
    database.user: ${secrets:kafka-main-cluster/postgres-user-debezium:username}
    schema.history.internal.kafka.bootstrap.servers: main-kafka-bootstrap:9092
    schema.history.internal.kafka.topic: schema-changes.inventory
    tasks.max: 1
    topic.prefix: postgres
  tasksMax: 1
status:
  conditions:
  - lastTransitionTime: "2024-01-15T19:30:23.116011225Z"
    message: 'PUT /connectors/debezium-connector-postgres/config returned 500 (Internal
      Server Error): Failed to find any class that implements Connector and which
      name matches io.debezium.connector.postgresql.PostgresConnector, available connectors
      are: PluginDesc{klass=class org.apache.kafka.connect.mirror.MirrorCheckpointConnector,
      name=''org.apache.kafka.connect.mirror.MirrorCheckpointConnector'', version=''3.6.1'',
      encodedVersion=3.6.1, type=source, typeName=''source'', location=''classpath''},
      PluginDesc{klass=class org.apache.kafka.connect.mirror.MirrorHeartbeatConnector,
      name=''org.apache.kafka.connect.mirror.MirrorHeartbeatConnector'', version=''3.6.1'',
      encodedVersion=3.6.1, type=source, typeName=''source'', location=''classpath''},
      PluginDesc{klass=class org.apache.kafka.connect.mirror.MirrorSourceConnector,
      name=''org.apache.kafka.connect.mirror.MirrorSourceConnector'', version=''3.6.1'',
      encodedVersion=3.6.1, type=source, typeName=''source'', location=''classpath''}'
    reason: ConnectRestException
    status: "True"
    type: NotReady
  observedGeneration: 3
  tasksMax: 1
  topics: []
```

```yaml
apiVersion: kafka.strimzi.io/v1beta2
kind: KafkaConnector
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"kafka.strimzi.io/v1beta2","kind":"KafkaConnector","metadata":{"annotations":{},"labels":{"strimzi.io/cluster":"my-connect"},"name":"debezium-connector-postgres","namespace":"kafka-main-cluster"},"spec":{"class":"io.debezium.connector.postgresql.PostgresConnector","config":{"database.hostname":"postgres-postgresql.postgres.svc.cluster2.xpt","database.include.list":"inventory","database.password":"${secrets:kafka-main-cluster/postgres-user-debezium:password}","database.port":5432,"database.server.id":184054,"database.user":"${secrets:kafka-main-cluster/postgres-user-debezium:username}","schema.history.internal.kafka.bootstrap.servers":"main-kafka-bootstrap:9092","schema.history.internal.kafka.topic":"schema-changes.inventory","tasks.max":1,"topic.prefix":"postgres"},"tasksMax":1}}
  creationTimestamp: "2024-01-12T13:25:08Z"
  generation: 3
  labels:
    strimzi.io/cluster: my-connect
  name: debezium-connector-postgres
  namespace: kafka-main-cluster
  resourceVersion: "311676"
  uid: 867bb405-027b-4376-bbe6-a8c336958f55
spec:
  class: io.debezium.connector.postgresql.PostgresConnector
  config:
    database.hostname: postgres-postgresql.postgres.svc.cluster2.xpt
    database.include.list: inventory
    database.password: ${secrets:kafka-main-cluster/postgres-user-debezium:password}
    database.port: 5432
    database.server.id: 184054
    database.user: ${secrets:kafka-main-cluster/postgres-user-debezium:username}
    schema.history.internal.kafka.bootstrap.servers: main-kafka-bootstrap:9092
    schema.history.internal.kafka.topic: schema-changes.inventory
    tasks.max: 1
    topic.prefix: postgres
  tasksMax: 1
status:
  conditions:
    - lastTransitionTime: "2024-01-15T20:17:32.756105215Z"
      message: |-
        PUT /connectors/debezium-connector-postgres/config returned 400 (Bad Request): Connector configuration is invalid and contains the following 1 error(s):
        The 'database.dbname' value is invalid: A value is required
        You can also find the above list of errors at the endpoint `/connector-plugins/{connectorType}/config/validate`
      reason: ConnectRestException
      status: "True"
      type: NotReady
  observedGeneration: 3
  tasksMax: 1
  topics: []
```


Get tag version from oci://registry-1.docker.io/bitnamicharts/postgresql helm chart
```shell
skopeo list-tags docker://registry-1.docker.io/bitnamicharts/postgresql
```


# Checking
ChapGPT: "How to know if the decoderbufs PostgreSQL plugin was installed by running only SQL?"

```shell
SELECT * FROM pg_read_file('/var/log/dpkg.log', 0, 100000000);
```

   * https://github.com/bitnami/charts/issues/14142
```sql
show shared_preload_libraries;
```

```sql
SELECT current_setting('shared_preload_libraries');
```

# Bitnami Postgres
Checking decoderbufs binary compatibility
```shell
ldd /opt/bitnami/postgresql/bin/postgres
```
```shell
ldd /opt/bitnami/postgresql/lib/decoderbufs.so
```
```shell
cat /opt/bitnami/postgresql/share/extension/decoderbufs.control
```

# Build Postgres image
```shell
 minikube ssh -- "cd /Volumes/data/git/labtools-k8s/install/postgres/bitnami/15/debian-11/decoderbufs && ./build-postgres-decoderbufs.sh"
```


# Curl
   * config.json file
```yaml
{
     "name": "inventory-connector",
     "config": {
          "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
          "tasks.max": 1,
          "database.hostname": "postgres-postgresql.postgres.svc.cluster2.xpt",
          "database.port": 5432,
          "database.user": "debezium",
          "database.password": "debezium",
          "database.dbname": "airflow",
          "topic.prefix": "postgres",
          "database.include.list": "inventory",
          "schema.history.internal.kafka.bootstrap.servers": "main-kafka-bootstrap:9092",
          "schema.history.internal.kafka.topic": "schema-changes.inventory"
     }
}
```

```shell
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" http://my-connect-connect-api.kafka-main-cluster.svc:8083/connectors/  -d @config.json
```
```json
[
  "debezium-connector-postgres"
]
```

```shell
curl -H "Accept:application/json" http://my-connect-connect-api.kafka-main-cluster.svc:8083/connector-plugins/ | jq
```
```json
[
  {
    "class": "io.debezium.connector.mongodb.MongoDbConnector",
    "type": "source",
    "version": "2.4.1.Final"
  },
  {
    "class": "io.debezium.connector.mysql.MySqlConnector",
    "type": "source",
    "version": "2.4.1.Final"
  },
  {
    "class": "io.debezium.connector.oracle.OracleConnector",
    "type": "source",
    "version": "2.4.1.Final"
  },
  {
    "class": "io.debezium.connector.postgresql.PostgresConnector",
    "type": "source",
    "version": "2.4.1.Final"
  },
  {
    "class": "io.debezium.connector.sqlserver.SqlServerConnector",
    "type": "source",
    "version": "2.5.0.Final"
  },
  {
    "class": "org.apache.kafka.connect.mirror.MirrorCheckpointConnector",
    "type": "source",
    "version": "3.6.1"
  },
  {
    "class": "org.apache.kafka.connect.mirror.MirrorHeartbeatConnector",
    "type": "source",
    "version": "3.6.1"
  },
  {
    "class": "org.apache.kafka.connect.mirror.MirrorSourceConnector",
    "type": "source",
    "version": "3.6.1"
  }
]
```

   * https://github.com/rogeriomm/labtools-k8s/blob/master/k8s/cluster2/base/kafka/main/connector-debezium.yaml
```shell
curl -H "Accept:application/json" http://my-connect-connect-api.kafka-main-cluster.svc:8083/connectors?expand=info | jq
```
```json
{
  "debezium-connector-postgres": {
    "info": {
      "name": "debezium-connector-postgres",
      "config": {
        "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
        "database.dbname": "airflow",
        "database.user": "debezium",
        "topic.prefix": "postgres",
        "schema.history.internal.kafka.topic": "schema-changes.inventory",
        "database.hostname": "postgres-postgresql.postgres.svc.cluster2.xpt",
        "tasks.max": "1",
        "database.password": "debezium",
        "name": "debezium-connector-postgres",
        "schema.history.internal.kafka.bootstrap.servers": "main-kafka-bootstrap:9092",
        "database.include.list": "inventory",
        "database.port": "5432"
      },
      "tasks": [
        {
          "connector": "debezium-connector-postgres",
          "task": 0
        }
      ],
      "type": "source"
    }
  }
}
```

# AVRO configuration
   * https://debezium.io/documentation/reference/stable/configuration/avro.html
     * " Beginning with Debezium 2.0.0, Confluent Schema Registry support is not included in the Debezium containers. To enable the Confluent Schema Registry for a Debezium container,... "


# Tested Versions
   * https://debezium.io/releases/


# Links
   * https://debezium.io/documentation/reference/stable/operations/kubernetes.html
      * https://debezium.io/documentation/reference/stable/connectors/postgresql.html
   * https://github.com/debezium/postgres-decoderbufs
   * https://github.com/bitnami/containers/issues/52319: [bitnami/postgresql-repmgr] How to make a temporary patched postgres image to bitnami/postgres image #52319
      * "I'm afraid we currently don't have the compilation recipes publicly available, however, I gathered the compilation instructions we perform internally"
   * https://github.com/debezium/container-images/blob/main/postgres/15/Dockerfile
   * https://docs.confluent.io/platform/current/connect/references/restapi.html: REST API