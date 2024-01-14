```shell
kubectl -n kafka-main-cluster get secret kafka-user-ide -o=jsonpath='{.data.password}' | base64 -d
```
```text
Qix9BAu3sVYifqASpt97gTxwlrspoNe0
```


```shell
kafkacat -b main-kafka-bootstrap.kafka-main-cluster.svc.cluster2.xpt:9092 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username="kafka-user-ide" -X sasl.password="Qix9BAu3sVYifqASpt97gTxwlrspoNe0" -t my-topic
```
```text
% Auto-selecting Consumer mode (use -P or -C to override)
% Reached end of topic my-topic [0] at offset 0
% Reached end of topic my-topic [1] at offset 0
```

