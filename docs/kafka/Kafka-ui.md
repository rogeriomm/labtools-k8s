
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
