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
 
## MacOS host
```commandline
brew install go pyenv minio awscli
```

```commandline
pyenv global  3.10.1
pip install -r requirements.txt
```
   * Update all pip modules
```commandline
pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U
```

   * Get current pip modules
```commandline
pip freeze > /tmp/requirements.txt
```

   * Install AWS CLI at directory "/opt/s3cmd"
      * https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

### Z shell
```commandline
export SPARK_HOME=/opt/spark-3.1.2-bin-custom-spark
export HADOOP_HOME=/opt/hadoop-3.3.1
export HADOOP_VERSION=3.3.1

export PATH="$HOME/.jenv/bin:$HOME/.pyenv/shims:$PATH"
eval "$(jenv init -)" > /dev/null
eval "$(pyenv init -)" > /dev/null

[[ ! -f $MINIKUBE_HOME/docker-env ]] || source $MINIKUBE_HOME/docker-env

export MAVEN_OPTS="-Xmx2g -XX:ReservedCodeCacheSize=2g"

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export GOPATH="$HOME/go"
export PATH=$PATH:"$GOPATH/bin"

export PATH=$PATH:/opt/s3cmd

export AIRFLOW_HOME=$HOME/airflow
export AWS_CA_BUNDLE=$MINIKUBE_HOME/ca.crt
```

# Apache Spark

# Apache Airflow
   * http://flower.worldl.xpt/
   * http://airflow.worldl.xpt/
      * User: admin, Password: admin 

# MINIO
   * https://minio.worldl.xpt/

# Apache Zeppelin
   * https://zeppelin.worldl.xpt/
      * http://zeppelin-server.zeppelin.svc.cluster.local/
      * http://4040-spark-mcdgtt.zeppelin.worldl.xpt/jobs/job/?id=0: Spark job sample url
     
# Kafka
   * https://strimzi.io/ 
      * https://strimzi.io/quickstarts/: Starting Minikube

# Apache Superset
   * https://superset.worldl.xpt/
      * User: admin
      * Password: admin

# Links
   * https://spark.apache.org/docs/3.1.2/sql-data-sources-parquet.html
   * https://www.kaggle.com/
   * http://go-colly.org/: Fast and Elegant Scraping Framework for Gophers
