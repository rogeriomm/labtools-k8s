# Install
## Prepare
```commandline
cd install
go build
``` 
```commandline
cd install
./labtools-k8s-install
``` 
 
## MacOS
```commandline
brew install go pyenv
```

```commandline
pyenv global  3.10.1
pip install -r requirements.txt
```

```commandline
pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U
```

```commandline
pip freeze > requirements.txt
```

# Apache Spark

# Apache Airflow
   * http://flower.worldl.xpt/
   * http://airflow.worldl.xpt/
      * User: admin, Password: admin 

# MINIO

# Zeppelin
   * http://zeppelin.worldl.xpt/
      * http://zeppelin-server.zeppelin.svc.cluster.local/
      * http://4040-spark-mcdgtt.zeppelin.worldl.xpt/jobs/job/?id=0: Spark job sample url
     
# Kafka
   * https://strimzi.io/ TODO
      * https://strimzi.io/quickstarts/: Starting Minikube

# Links
   * https://spark.apache.org/docs/3.1.2/sql-data-sources-parquet.html
   * https://www.kaggle.com/
