   * https://trino.io/docs/current/installation/kubernetes.html

```text
NAME: trino-cluster
LAST DEPLOYED: Fri Apr 21 12:25:24 2023
NAMESPACE: trino
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace trino -l "app=trino,release=trino-cluster,component=coordinator" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl port-forward $POD_NAME 8080:8080
```

```shell
nc -v  trino.trino.svc 8080
```

   * https://trino.io/docs/current/client/cli.html
```shell
trino http://trino.trino.svc:8080/tpch/tiny
```

   * http://trino.trino.svc:8080


# Links
   * Connectors
      * https://trino.io/docs/current/connector/kafka.html
      * https://trino.io/docs/current/connector/delta-lake.html
      * https://trino.io/docs/current/connector/iceberg.html
      * https://trino.io/docs/current/connector/elasticsearch.html
      * https://trino.io/docs/current/connector/postgresql.html
      * https://trino.io/docs/current/connector/mongodb.html
      * https://trino.io/docs/current/connector/mysql.html
      * https://trino.io/docs/current/connector/hive.html
