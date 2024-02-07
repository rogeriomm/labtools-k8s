
# SASL configuration 
   * https://github.com/provectus/kafka-ui/blob/e72f6d6d5dd078df2d270cc48a4087588443f89a/documentation/compose/kafka-ui-sasl.yaml#L17


# Schema Registry
   * https://github.com/provectus/kafka-ui/discussions/3791

# kSQL
   * https://github.com/provectus/kafka-ui/discussions/3791

# Kafka-ui password FIXME
```shell
kubectl  get secrets kafka-user-ui -o=jsonpath='{.data.sasl\.jaas\.config}' | base64 -d
```


* https://docs.kafka-ui.provectus.io/configuration/helm-charts/quick-start

```shell
helm upgrade kafka-ui kafka-ui/kafka-ui --namespace kafka \                                                                                                                                                                                 ─╯
         --set yamlApplicationConfigConfigMap.name="kafka-ui-configmap",yamlApplicationConfigConfigMap.keyName="config.yml" \
         --values "$LABTOOLS_K8S/k8s/cluster2/helm/kafka-ui/values.yaml"
```

```shell
kubectl -n kafka-main-cluster get secrets kafka-user-ide -o=jsonpath='{.data.sasl\.jaas\.config}' | base64 -d
```
```text
org.apache.kafka.common.security.scram.ScramLoginModule required username="kafka-user-ide" password="Qix9BAu3sVYifqASpt97gTxwlrspoNe0";
```

# Links
* https://artifacthub.io/packages/helm/kafka-ui/kafka-ui
    * https://docs.kafka-ui.provectus.io/configuration/helm-charts/configuration/ssl-example
* https://gith