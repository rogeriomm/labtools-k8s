#!/usr/bin/env zsh

nfs_fix()
{
  set +e &&  pid=$(pgrep -n nfsd) &&  set -e
  args=""

  if [ "$pid" != "" ] ; then
    args="$(ps -o args  "$pid" | awk '/nfsd/{print $2}')"
  fi

  if [[ "$pid" == "" || "$args" != "-N" ]]  ; then
    if [[ "$pid" == "" ]] ; then
      sudo kill "$pid"
    fi
    sudo nfsd stop 2> /dev/null > /dev/null
    sudo nfsd -N &
  fi
}

hive_install()
{
  if ! kubectl get namespace hive; then
    kubectl create ns hive
    kubectl -n hive create configmap ca-pemstore --from-file="$MINIKUBE_HOME"/ca.crt
  fi
}

datahub_install()
{
  if ! kubectl get namespace datahub ; then
    helm repo add datahub https://helm.datahubproject.io/
    helm repo update datahub

    POSTGRES_HOST="postgres-postgresql.postgres.svc.cluster2.xpt"
    POSTGRES_USER=postgres
    POSTGRES_PASSWORD=$(kubectl get secret --namespace postgres postgres-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)

    kubectl create namespace datahub

    kubectl create -n datahub secret generic postgresql-secrets --from-literal=postgres-password="$POSTGRES_PASSWORD"
    kubectl create -n datahub secret generic neo4j-secrets --from-literal=neo4j-password=datahub

    helm install --namespace datahub prerequisites datahub/datahub-prerequisites --values k8s/yaml2/datahub/values-prerequisites.yaml

    helm install --namespace datahub datahub datahub/datahub --values k8s/yaml2/datahub/values.yaml
  fi
}

airflow_install()
{
  if ! kubectl get namespace airflow ; then
    helm repo add airflow-stable https://airflow-helm.github.io/charts
    helm repo update airflow-stable
    # See "Airflow Version Support on https://artifacthub.io/packages/helm/airflow-helm/airflow
    helm install airflow airflow-stable/airflow --create-namespace --namespace airflow --version "8.8.0" --values k8s/yaml2/airflow/values.yaml

    POSTGRES_HOST="postgres-postgresql.postgres.svc.cluster2.xpt"
    POSTGRES_USER=postgres
    POSTGRES_PASSWORD=$(kubectl get secret --namespace postgres postgres-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)

    kubectl -n airflow create secret generic airflow-cluster1-database-credentials \
       --from-literal=username="$POSTGRES_USER" \
       --from-literal=password="$POSTGRES_PASSWORD"
  fi
}

airflow_post_install()
{
    if kubectl get namespace airflow ; then
      ### Postgres connection
      kubectl wait pods -n airflow  airflow-worker-0 --for condition=Ready --timeout=300s

      POSTGRES_HOST="postgres-postgresql.postgres.svc.cluster2.xpt"
      POSTGRES_USER=postgres
      POSTGRES_PASSWORD=$(kubectl get secret --namespace postgres postgres-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)

      airflow="kubectl exec -n airflow airflow-worker-0 -- airflow"

      if ! eval "$airflow" connections get db > /dev/null ; then
        eval "$airflow" connections add 'db' \
              --conn-type 'postgres' --conn-host "${POSTGRES_HOST}" --conn-port 5432 \
              --conn-login "${POSTGRES_USER}" --conn-password="${POSTGRES_PASSWORD}" \
              --conn-schema 'metastore_db'

        eval "$airflow" connections list

        ### MongoDB connection
        kubectl wait pods -n mongodb example-mongodb-0 --for condition=Ready --timeout=300s

        MONGODB_HOST=example-mongodb-svc.mongodb.svc.cluster2.xpt
        MONGODB_USER="my-user"
        MONGODB_PASSWORD=$(kubectl get secret --namespace mongodb my-user-password  -o jsonpath="{.data.password}")

        eval "$airflow" connections add 'mongodb' \
              --conn-type 'mongodb' --conn-host "${MONGODB_HOST}" --conn-port 27017 \
              --conn-login "${MONGODB_USER}" --conn-password="${MONGODB_PASSWORD}" \
              --conn-schema 'metastore_db'
      fi
    fi
}

trino_install()
{
  if ! kubectl get namespace trino 2> /dev/null ; then
    helm repo add trino https://trinodb.github.io/charts
    helm repo update trino
    helm install -f k8s/yaml2/trino/values.yaml --create-namespace --namespace trino  trino-cluster trino/trino
  fi
}

mongodb_install()
{
  if ! kubectl get namespace mongodb 2> /dev/null ; then
    helm repo add mongodb https://mongodb.github.io/helm-charts
    helm repo update mongodb
    helm install -f k8s/yaml2/mongodb/values.yaml community-operator mongodb/community-operator --create-namespace --namespace mongodb
  fi
}

postgres_install()
{
  if ! kubectl get namespace postgres 2> /dev/null ; then
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm repo update bitnami

    helm install -f k8s/yaml2/postgres/values.yaml --create-namespace --namespace postgres postgres bitnami/postgresql
  fi
}

minio_install()
{
  if ! kubectl get namespace minio-operator; then
    echo "Installing MINIO operator..."
    kubectl krew update
    kubectl krew install minio
    kubectl minio version
    domain=$(kubectl get cm coredns -n kube-system -o jsonpath="{.data.Corefile}" | grep kubernetes | awk -F ' ' '{print $2}')
    kubectl minio init --namespace minio-operator --cluster-domain "$domain"
  fi

  if ! kubectl get namespace minio-tenant-1; then
    echo "Creating MINIO instance"

    kubectl create ns minio-tenant-1

    kubectl minio tenant create minio-tenant-1 \
    --servers          3                     \
    --volumes          6                     \
    --capacity         100Gi                 \
    --namespace        minio-tenant-1        \
    --storage-class minio-local-storage
  fi
}

kafka_install()
{
  if ! kubectl get ns kafka; then
    kubectl create namespace kafka;

    pushd

    cd "$LABTOOLS_K8S"/modules/kafka-k8s

    for ns in  kafka-project-1 kafka-project-2 kafka-project-3 kafka-project-4 kafka-project-5
    do
      if ! kubectl get ns $ns; then kubectl create namespace $ns; fi

      kubectl create -f k8s/install/cluster-operator/020-RoleBinding-strimzi-cluster-operator.yaml -n $ns
      kubectl create -f k8s/install/cluster-operator/023-RoleBinding-strimzi-cluster-operator.yaml -n $ns
      kubectl create -f k8s/install/cluster-operator/031-RoleBinding-strimzi-cluster-operator-entity-operator-delegation.yaml -n $ns
    done

    # Deploy the Cluster Operator
    kubectl create -f k8s/install/cluster-operator -n kafka

    kubectl rollout status deployment strimzi-cluster-operator -n kafka --timeout=90s

    # Check the status of the deployment
    kubectl get deployments -n kafka

    popd
  fi
}

minio_copy()
{
  set +x

  export https_proxy="http://localhost:8888"

  if ! mc ls local 2> /dev/null > /dev/null ; then
    echo "Waiting MINIO S3"

    while ! mc ls local 2> /dev/null > /dev/null ; do
      echo -n "."
      sleep 10
    done
  fi

  set -x

  # Copy files
  if ! mc ls local/bronze 2> /dev/null > /dev/null ; then
    mc mb local/bronze

    mc cp --recursive "$LABTOOLS_K8S/load-data/bronze/" local/bronze/

    mc mb local/silver
    mc mb local/gold

    mc mb local/spark
  fi
}

zeppelin_create_secret()
{
  # Copy certificate from namespace "kube-system" to namespace "zeppelin"
  kubectl --namespace kube-system get secrets mkcert -o yaml | \
      yq 'del(.metadata.creationTimestamp, .metadata.uid, .metadata.resourceVersion, .metadata.namespace)' | \
      kubectl apply --namespace zeppelin -f -
}

set -x
set -e

sudo -v

nfs_fix

labtools-k8s set-context cluster1

kafka_install

labtools-k8s set-context cluster2

kafka_install

labtools-k8s configure-clusters

labtools-k8s set-context cluster2

kafka_install

minio_install

postgres_install

mongodb_install

trino_install

hive_install

if ! kubectl get namespace aws-glue; then
  kubectl create ns aws-glue
fi

if ! kubectl get namespace zeppelin; then
  kubectl create ns zeppelin
fi

if ! kubectl get namespace tunnel; then
  kubectl create ns tunnel
fi

airflow_install

datahub_install

zeppelin_create_secret

kubectl apply -f "$LABTOOLS_K8S/k8s/yaml2/"

airflow_post_install

sleep 2
labtools-k8s set-ingress zeppelin zeppelin-server zeppelin

minio_copy

#kubectl describe pods -n zeppelin | grep -A20 Events
