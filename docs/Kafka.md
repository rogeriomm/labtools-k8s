   * Kubernetes services
````shell
kubectl -n kafka get svc
kubectl get kafka lab-cluster -o=jsonpath='{.status.listeners[?(@.type=="tls")].bootstrapServers}{"\n"}'
````

   * Kafka TLS listener DNS name
```shell
dig lab-cluster-kafka-bootstrap.kafka.svc.cluster1.xpt
```

   * Kafka TLS listener test
```shell
nc lab-cluster-kafka-bootstrap.kafka.svc.cluster.local 9093
```

   * ???
```shell
kubectl get kafka lab-cluster -o=jsonpath='{.status.listeners[?(@.type=="external")].bootstrapServers}{"\n"}'
```

   * Jetbrains Big Data Tools configuration
      * https://www.jetbrains.com/help/idea/big-data-tools-kafka.html