   * https://aws.amazon.com/premiumsupport/knowledge-center/postgresql-hive-metastore-emr/
   * https://github.com/arempter/hive-metastore-docker


```shell
nc -v hive-metastore.hive.svc.cluster2.xpt 9083
```


```shell
kubectl -n hive create configmap ca-pemstore --from-file=$MINIKUBE_HOME/ca.crt
```

```shell
kubectl get -n hive configmap ca-pemstore -o yaml | yq
```



   * https://spark.apache.org/docs/latest/sql-data-sources-hive-tables.html
      * spark.sql.hive.metastore.version, spark.sql.hive.metastore.jars.path 