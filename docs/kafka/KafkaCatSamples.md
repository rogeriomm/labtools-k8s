```shell
user=""kafka-user-ide""
password=$(kubectl -n kafka-main-cluster get secret kafka-user-ide -o=jsonpath='{.data.password}' | base64 -d)
echo user=$user && echo password=$password
```

```shell
kafkacat -b main-kafka-bootstrap.kafka-main-cluster.svc.cluster2.xpt:9092 -X security.protocol=SASL_PLAINTEXT -X sasl.mechanisms=SCRAM-SHA-512 -X sasl.username=$user -X sasl.password=$password -t my-topic
```
```text
% Auto-selecting Consumer mode (use -P or -C to override)
% Reached end of topic my-topic [0] at offset 0
% Reached end of topic my-topic [1] at offset 0
```

