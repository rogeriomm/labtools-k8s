```shell
helm repo add redpanda https://charts.redpanda.com
helm repo update redpanda
helm search repo redpanda
```
```text
NAME                    CHART VERSION   APP VERSION     DESCRIPTION                                       
redpanda/redpanda       5.7.23          v23.3.4         Redpanda is the real-time engine for modern apps. 
redpanda/connectors     0.1.9           v1.0.6          Redpanda managed Connectors helm chart            
redpanda/console        0.7.20          v2.4.3          Helm chart to deploy Redpanda Console.            
redpanda/kminion        0.12.5          v2.2.5          The most popular Open Source Kafka JMX to Prome...
redpanda/operator       0.4.19          v2.1.14-23.3.4  Redpanda operator helm chart   
```

# Links
   * https://github.com/redpanda-data/helm-charts/tree/main/charts/console
   * https://docs.redpanda.com/current/reference/k-helm-index/
      * https://docs.redpanda.com/current/deploy/deployment-option/self-hosted/kubernetes/k-production-deployment/