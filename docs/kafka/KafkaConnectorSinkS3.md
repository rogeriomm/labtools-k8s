

# Troubleshooting
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


# Links
   * https://blog.min.io/kafka-schema-registry/