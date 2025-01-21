   * https://datahubproject.io/docs/metadata-integration/java/spark-lineage/

```shell
kubectl -n datahub get services
```
```text
NAME                               TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                         AGE
datahub-acryl-datahub-actions      ClusterIP      10.104.116.185   <none>        9093/TCP                        5m44s
datahub-datahub-frontend           LoadBalancer   10.105.29.182    <pending>     9002:30107/TCP,4318:31339/TCP   5m44s
datahub-datahub-gms                LoadBalancer   10.110.110.9     <pending>     8080:30476/TCP,4318:31446/TCP   5m44s
elasticsearch-master               ClusterIP      10.100.187.199   <none>        9200/TCP,9300/TCP               9m53s
elasticsearch-master-headless      ClusterIP      None             <none>        9200/TCP,9300/TCP               9m53s
prerequisites-kafka                ClusterIP      10.98.164.101    <none>        9092/TCP                        9m53s
prerequisites-kafka-headless       ClusterIP      None             <none>        9092/TCP,9094/TCP               9m53s
prerequisites-zookeeper            ClusterIP      10.111.130.0     <none>        2181/TCP,2888/TCP,3888/TCP      9m53s
prerequisites-zookeeper-headless   ClusterIP      None             <none>        2181/TCP,2888/TCP,3888/TCP      9m53s
```
FIXME Type: LoadBalancer

```shell
minikube tunnel --bind-address='127.0.0.1'
nv -v localhost 80
nv -v localhost 443
```

```shell
curl http://datahub-datahub-frontend.datahub.svc:9002
```

  * http://datahub-datahub-frontend.datahub.svc:9002/login


# Helm
   * https://github.com/acryldata/datahub-helm/blob/master/charts/prerequisites/values.yaml
   * https://github.com/acryldata/datahub-helm/blob/master/charts/datahub/values.yaml

   * Elastic search
      * https://github.com/elastic/helm-charts/blob/main/elasticsearch/values.yaml