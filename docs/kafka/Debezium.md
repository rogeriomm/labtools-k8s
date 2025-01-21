
```shell
curl http://my-connect-connect-api.kafka-main-cluster.svc:8083
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
curl http://$host/connectors/debezium-connector-postgres/config
```





# Print
```shell
kubectl get -n kafka-main-cluster kafkaconnectors debezium-connector-postgres | yq
```
```text
NAME                          CLUSTER      CONNECTOR CLASS                                      MAX TASKS   READY
debezium-connector-postgres   my-connect   io.debezium.connector.postgresql.PostgresConnector   1           
```


# Troubleshooting
   * Find config errors
```shell
curl /connector-plugins/{connectorType}/config/validate
```

  * Get errors from kafkaconnectors Strimzi api

```shell
kubectl get -n kafka-main-cluster kafkaconnectors debezium-connector-postgres -o yaml | yq
```

See status.conditions samples:

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

# Links
   * https://debezium.io/documentation/reference/stable/operations/kubernetes.html
      * https://debezium.io/documentation/reference/stable/connectors/postgresql.html
