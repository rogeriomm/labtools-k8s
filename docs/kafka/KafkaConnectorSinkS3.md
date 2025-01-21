   * https://habr.com/en/articles/744790/: Apache Kafka and AWS S3: backup and restore
   * https://blog.min.io/stream-data-to-minio-using-kafka-kubernetes/
     * Search "AWS_ACCESS_KEY_ID"
     * Search "trustedCertificates"
   * https://itnext.io/kafka-on-kubernetes-the-strimzi-way-part-1-bdff3e451788

# Troubleshooting
https://forum.confluent.io/t/kafkaconnect-with-amazon-sink-s3-sink-connect-is-not-working/4601/6
## Unable to load AWS credentials from any provider in the chain
```shell
kubectl -n kafka-main-cluster get kafkaconnector s3-sink-cdc -o jsonpath='{.status.connectorStatus.tasks[0].trace}'
```
```text
org.apache.kafka.connect.errors.ConnectException: com.amazonaws.SdkClientException: Unable to load AWS credentials from any provider in the chain: [EnvironmentVariableCredentialsProvider: Unable to load AWS credentials from environment variables (AWS_ACCESS_KEY_ID (or AWS_ACCESS_KEY) and AWS_SECRET_KEY (or AWS_SECRET_ACCESS_KEY)), SystemPropertiesCredentialsProvider: Unable to load AWS credentials from Java system properties (aws.accessKeyId and aws.secretKey), WebIdentityTokenCredentialsProvider: You must specify a value for roleArn and roleSessionName, com.amazonaws.auth.profile.ProfileCredentialsProvider@74caeea6: profile file cannot be null, com.amazonaws.auth.EC2ContainerCredentialsProviderWrapper@540d67f2: Failed to connect to service endpoint: ]
	at io.confluent.connect.s3.S3SinkTask.start(S3SinkTask.java:142)
	at org.apache.kafka.connect.runtime.WorkerSinkTask.initializeAndStart(WorkerSinkTask.java:329)
	at org.apache.kafka.connect.runtime.WorkerTask.doRun(WorkerTask.java:202)
	at org.apache.kafka.connect.runtime.WorkerTask.run(WorkerTask.java:259)
	at org.apache.kafka.connect.runtime.isolation.Plugins.lambda$withClassLoader$1(Plugins.java:236)
	at java.base/java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:539)
	at java.base/java.util.concurrent.FutureTask.run(FutureTask.java:264)
	at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1136)
	at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:635)
	at java.base/java.lang.Thread.run(Thread.java:840)
Caused by: com.amazonaws.SdkClientException: Unable to load AWS credentials from any provider in the chain: [EnvironmentVariableCredentialsProvider: Unable to load AWS credentials from environment variables (AWS_ACCESS_KEY_ID (or AWS_ACCESS_KEY) and AWS_SECRET_KEY (or AWS_SECRET_ACCESS_KEY)), SystemPropertiesCredentialsProvider: Unable to load AWS credentials from Java system properties (aws.accessKeyId and aws.secretKey), WebIdentityTokenCredentialsProvider: You must specify a value for roleArn and roleSessionName, com.amazonaws.auth.profile.ProfileCredentialsProvider@74caeea6: profile file cannot be null, com.amazonaws.auth.EC2ContainerCredentialsProviderWrapper@540d67f2: Failed to connect to service endpoint: ]
	at com.amazonaws.auth.AWSCredentialsProviderChain.getCredentials(AWSCredentialsProviderChain.java:142)
	at com.amazonaws.http.AmazonHttpClient$RequestExecutor.getCredentialsFromContext(AmazonHttpClient.java:1269)
	at com.amazonaws.http.AmazonHttpClient$RequestExecutor.runBeforeRequestHandlers(AmazonHttpClient.java:845)
	at com.amazonaws.http.AmazonHttpClient$RequestExecutor.doExecute(AmazonHttpClient.java:794)
	at com.amazonaws.http.AmazonHttpClient$RequestExecutor.executeWithTimer(AmazonHttpClient.java:781)
	at com.amazonaws.http.AmazonHttpClient$RequestExecutor.execute(AmazonHttpClient.java:755)
	at com.amazonaws.http.AmazonHttpClient$RequestExecutor.access$500(AmazonHttpClient.java:715)
	at com.amazonaws.http.AmazonHttpClient$RequestExecutionBuilderImpl.execute(AmazonHttpClient.java:697)
	at com.amazonaws.http.AmazonHttpClient.execute(AmazonHttpClient.java:561)
	at com.amazonaws.http.AmazonHttpClient.execute(AmazonHttpClient.java:541)
	at com.amazonaws.services.s3.AmazonS3Client.invoke(AmazonS3Client.java:5520)
	at com.amazonaws.services.s3.AmazonS3Client.invoke(AmazonS3Client.java:5467)
	at com.amazonaws.services.s3.AmazonS3Client.getAcl(AmazonS3Client.java:4113)
	at com.amazonaws.services.s3.AmazonS3Client.getBucketAcl(AmazonS3Client.java:1308)
	at com.amazonaws.services.s3.AmazonS3Client.getBucketAcl(AmazonS3Client.java:1298)
	at com.amazonaws.services.s3.AmazonS3Client.doesBucketExistV2(AmazonS3Client.java:1436)
	at io.confluent.connect.s3.storage.S3Storage.bucketExists(S3Storage.java:186)
	at io.confluent.connect.s3.S3SinkTask.start(S3SinkTask.java:114)
	... 9 more
```
   * https://blog.min.io/kafka-schema-registry/
     * https://github.com/minio/blog-assets/blob/main/kafka/kafka-schema-registry-minio.md?ref=blog.min.io#deploy-kafka-connect
        *  Search: "AWS_ACCESS_KEY_ID"
   * https://github.com/strimzi/strimzi-kafka-operator/issues/3027: S3 connector - where should I put minio accesskey and secretkey?
      * https://developers.redhat.com/blog/2020/02/14/using-secrets-in-apache-kafka-connect-configuration
     
# Unable to execute HTTP request: PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target
   * https://ververica.zendesk.com/hc/en-us/articles/4403499737106-Use-S3-behind-an-HTTPS-endpoint-with-a-self-signed-certificate-in-Ververica-Platform
     * Search Get your truststore ready
   * https://habr.com/en/articles/744790/: Apache Kafka and AWS S3: backup and restore
      * Search: "trustedCertificates"
      * Search: "certificateAndKey"
   * https://github.com/orgs/strimzi/discussions/4478: Using self signed certificates in KafkaConnect
      * "We have a similar setup where we use minio, with a self signed cert, as the sink. We use io.confluent.connect.s3.S3SinkConnector for the kafka connector. Would you mind share your experience? " 
   * https://forum.confluent.io/t/configure-ssl-for-sink-connectors-communicating-with-3rd-party-applications/2945
   * https://stackoverflow.com/questions/70922961/what-is-the-proper-way-of-adding-trust-certificates-to-confluent-kafka-connect-d
   * https://github.com/1ambda/docker-kafka-connect/blob/master/README.md#development
      * Search "CONNECT_CFG"
         * ${KAFKA_HOME}/config/connect-distributed.properties
   * https://strimzi.io/docs/operators/0.30.0/full/configuring#installing-your-own-ca-certificates-str: 9.1.2. Installing your own CA certificates
      * "This procedure describes how to install your own CA certificates and keys instead of using the CA certificates and private keys generated by the Cluster Operator"

---   
   * https://joelforjava.com/blog/2019/10/27/adding-ssl-encryption-to-kafka-connector.html: **Adding SSL Encryption Configuration to Kafka Connectors** :sunglasses:
      * "What I was unaware of at the time, is we needed to add properties that specifically targeted the connector. If you're using a Sink connector, you'll need to add the same ssl.* properties prefixed with consumer."
      * https://docs.confluent.io/platform/current/connect/security.html 
---

```shell
 echo | openssl s_client -servername s3.amazonaws.com -connect minio.minio-tenant-1.svc:443 | \
    sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > aws_s3_cert.pem
```

   * Kafka connect pod
```shell
cat /etc/pki/ca-trust/extracted/java/README
```
```text
This directory /etc/pki/ca-trust/extracted/java/ contains 
CA certificate bundle files which are automatically created
based on the information found in the
/usr/share/pki/ca-trust-source/ and /etc/pki/ca-trust/source/
directories.

All files are in the java keystore file format.

If your application isn't able to load the PKCS#11 module p11-kit-trust.so,
then you can use these files in your application to load a list of global
root CA certificates.

Please never manually edit the files stored in this directory,
because your changes will be lost and the files automatically overwritten,
each time the update-ca-trust command gets executed.

Please refer to the update-ca-trust(8) manual page for additional information.
```



   * head
```shell
kubeclt -n kafka-main-cluster logs my-connect-connect-0
```
```text
│ Preparing truststore                                                                                                                                                                                                                                                                                                         │
│ Certificate was added to keystore                                                                                                                                                                                                                                                                                            │
│ Preparing truststore is complete                                                                                                                                                                                                                                                                                             │
│ Preparing keystore                                                                                                                                                                                                                                                                                                           │
│ Preparing keystore is complete                                                                                                                                                                                                                                                                                               │
│ Starting Kafka Connect with configuration:                                                                                                                                                                                                                                                                                   │
│ # Bootstrap servers                                                                                                                                                                                                                                                                                                          │
│ bootstrap.servers=main-kafka-bootstrap:9093                                                                                                                                                                                                                                                                                  │
│ # REST Listeners                                                                                                                                                                                                                                                                                                             │
│ rest.port=8083                                                                                                                                                                                                                                                                                                               │
│ rest.advertised.host.name=my-connect-connect-0.my-connect-connect.kafka-main-cluster.svc                                                                                                                                                                                                                                     │
│ rest.advertised.port=8083                                                                                                                                                                                                                                                                                                    │
│ # Plugins                                                                                                                                                                                                                                                                                                                    │
│ plugin.path=/opt/kafka/plugins                                                                                                                                                                                                                                                                                               │
│ # Provided configuration                                                                                                                                                                                                                                                                                                     │
│ offset.storage.topic=connect-cluster-offsets                                                                                                                                                                                                                                                                                 │
│ value.converter=org.apache.kafka.connect.json.JsonConverter                                                                                                                                                                                                                                                                  │
│ config.storage.topic=connect-cluster-configs                                                                                                                                                                                                                                                                                 │
│ key.converter=org.apache.kafka.connect.json.JsonConverter                                                                                                                                                                                                                                                                    │
│ group.id=connect-cluster                                                                                                                                                                                                                                                                                                     │
│ status.storage.topic=connect-cluster-status                                                                                                                                                                                                                                                                                  │
│ config.providers=secrets,configmaps                                                                                                                                                                                                                                                                                          │
│ config.providers.configmaps.class=io.strimzi.kafka.KubernetesConfigMapConfigProvider                                                                                                                                                                                                                                         │
│ config.providers.secrets.class=io.strimzi.kafka.KubernetesSecretConfigProvider                                                                                                                                                                                                                                               │
│ config.storage.replication.factor=-1                                                                                                                                                                                                                                                                                         │
│ offset.storage.replication.factor=-1                                                                                                                                                                                                                                                                                         │
│ status.storage.replication.factor=-1                                                                                                                                                                                                                                                                                         │
│                                                                                                                                                                                                                                                                                                                              │
│                                                                                                                                                                                                                                                                                                                              │
│ security.protocol=SSL                                                                                                                                                                                                                                                                                                        │
│ producer.security.protocol=SSL                                                                                                                                                                                                                                                                                               │
│ consumer.security.protocol=SSL                                                                                                                                                                                                                                                                                               │
│ admin.security.protocol=SSL                                                                                                                                                                                                                                                                                                  │
│ # TLS / SSL                                                                                                                                                                                                                                                                                                                  │
│ ssl.truststore.location=/tmp/kafka/cluster.truststore.p12                                                                                                                                                                                                                                                                    │
│ ssl.truststore.password=[hidden]                                                                                                                                                                                                                                                                                             │
│ ssl.truststore.type=PKCS12                                                                                                                                                                                                                                                                                                   │
│                                                                                                                                                                                                                                                                                                                              │
│ producer.ssl.truststore.location=/tmp/kafka/cluster.truststore.p12                                                                                                                                                                                                                                                           │
│ producer.ssl.truststore.password=[hidden]                                                                                                                                                                                                                                                                                    │
│                                                                                                                                                                                                                                                                                                                              │
│ consumer.ssl.truststore.location=/tmp/kafka/cluster.truststore.p12                                                                                                                                                                                                                                                           │
│ consumer.ssl.truststore.password=[hidden]                                                                                                                                                                                                                                                                                    │
│                                                                                                                                                                                                                                                                                                                              │
│ admin.ssl.truststore.location=/tmp/kafka/cluster.truststore.p12                                                                                                                                                                                                                                                              │
│ admin.ssl.truststore.password=[hidden]                                                                                                                                                                                                                                                                                       │
│ ssl.keystore.location=/tmp/kafka/cluster.keystore.p12                                                                                                                                                                                                                                                                        │
│ ssl.keystore.password=[hidden]                                                                                                                                                                                                                                                                                               │
│ ssl.keystore.type=PKCS12                                                                                                                                                                                                                                                                                                     │
│                                                                                                                                                                                                                                                                                                                              │
│ producer.ssl.keystore.location=/tmp/kafka/cluster.keystore.p12                                                                                                                                                                                                                                                               │
│ producer.ssl.keystore.password=[hidden]                                                                                                                                                                                                                                                                                      │
│ producer.ssl.keystore.type=PKCS12                                                                                                                                                                                                                                                                                            │
│                                                                                                                                                                                                                                                                                                                              │
│ consumer.ssl.keystore.location=/tmp/kafka/cluster.keystore.p12                                                                                                                                                                                                                                                               │
│ consumer.ssl.keystore.password=[hidden]                                                                                                                                                                                                                                                                                      │
│ consumer.ssl.keystore.type=PKCS12                                                                                                                                                                                                                                                                                            │
│                                                                                                                                                                                                                                                                                                                              │
│ admin.ssl.keystore.location=/tmp/kafka/cluster.keystore.p12                                                                                                                                                                                                                                                                  │
│ admin.ssl.keystore.password=[hidden]                                                                                                                                                                                                                                                                                         │
│ admin.ssl.keystore.type=PKCS12                                                                                                                                                                                                                                                                                               │
│                                                                                                                                                                                                                                                                                                                              │
│                                                                                                                                                                                                                                                                                                                              │
│ # Additional configuration                                                                                                                                                                                                                                                                                                   │
│ consumer.client.rack=                                                                                                                                                                                                                                                                                                        │
│                                                                                                                                                                                                                                                                                                                              │
│ + exec /usr/bin/tini -w -e 143 -- /opt/kafka/bin/connect-distributed.sh /tmp/strimzi-connect.properties                                                                                                                                                                                                                      │
│ 2024-02-15 11:27:59,857 INFO Kafka Connect worker initializing ... (org.apache.kafka.connect.cli.AbstractConnectCli) [main
```

```shell
cat /tmp/strimzi-connect.properties
```
```text
# Bootstrap servers
bootstrap.servers=main-kafka-bootstrap:9093
# REST Listeners
rest.port=8083
rest.advertised.host.name=my-connect-connect-0.my-connect-connect.kafka-main-cluster.svc
rest.advertised.port=8083
# Plugins
plugin.path=/opt/kafka/plugins
# Provided configuration
offset.storage.topic=connect-cluster-offsets
value.converter=org.apache.kafka.connect.json.JsonConverter
config.storage.topic=connect-cluster-configs
key.converter=org.apache.kafka.connect.json.JsonConverter
group.id=connect-cluster
status.storage.topic=connect-cluster-status
config.providers=secrets,configmaps
config.providers.configmaps.class=io.strimzi.kafka.KubernetesConfigMapConfigProvider
config.providers.secrets.class=io.strimzi.kafka.KubernetesSecretConfigProvider
config.storage.replication.factor=-1
offset.storage.replication.factor=-1
status.storage.replication.factor=-1


security.protocol=SSL
producer.security.protocol=SSL
consumer.security.protocol=SSL
admin.security.protocol=SSL
# TLS / SSL
ssl.truststore.location=/tmp/kafka/cluster.truststore.p12
ssl.truststore.password=cLtH1HGW4r3mdN1K1puqvy3egLs8SUsA
ssl.truststore.type=PKCS12

producer.ssl.truststore.location=/tmp/kafka/cluster.truststore.p12
producer.ssl.truststore.password=cLtH1HGW4r3mdN1K1puqvy3egLs8SUsA

consumer.ssl.truststore.location=/tmp/kafka/cluster.truststore.p12
consumer.ssl.truststore.password=cLtH1HGW4r3mdN1K1puqvy3egLs8SUsA

admin.ssl.truststore.location=/tmp/kafka/cluster.truststore.p12
admin.ssl.truststore.password=cLtH1HGW4r3mdN1K1puqvy3egLs8SUsA
ssl.keystore.location=/tmp/kafka/cluster.keystore.p12
ssl.keystore.password=cLtH1HGW4r3mdN1K1puqvy3egLs8SUsA
ssl.keystore.type=PKCS12

producer.ssl.keystore.location=/tmp/kafka/cluster.keystore.p12
producer.ssl.keystore.password=cLtH1HGW4r3mdN1K1puqvy3egLs8SUsA
producer.ssl.keystore.type=PKCS12

consumer.ssl.keystore.location=/tmp/kafka/cluster.keystore.p12
consumer.ssl.keystore.password=cLtH1HGW4r3mdN1K1puqvy3egLs8SUsA
consumer.ssl.keystore.type=PKCS12

admin.ssl.keystore.location=/tmp/kafka/cluster.keystore.p12
admin.ssl.keystore.password=cLtH1HGW4r3mdN1K1puqvy3egLs8SUsA
admin.ssl.keystore.type=PKCS12


# Additional configuration
consumer.client.rack=
```

# Links
   * https://blog.min.io/kafka-schema-registry/