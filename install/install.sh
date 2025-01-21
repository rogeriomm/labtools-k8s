#!/usr/bin/env zsh

ingress_redirect()
{
  sudo nohup socat TCP-LISTEN:80,reuseaddr,fork,bind=192.168.100.250 TCP:ingress-nginx-controller.ingress-nginx.svc.cluster2.xpt:80 &
}


airflow_install()
{
  if ! kubectl get namespace airflow ; then
    helm repo add airflow-stable https://airflow-helm.github.io/charts
    helm repo update
    helm search repo airflow
    helm install airflow airflow-stable/airflow --create-namespace --namespace airflow --version "8.7.0" --values k8s/yaml2/airflow/values.yaml

    POSTGRES_HOST=postgres-postgresql.postgres.svc.cluster2.xpt
    POSTGRES_PASSWORD=$(kubectl get secret --namespace postgres postgres-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)

    kubectl -n airflow create secret generic airflow-cluster1-database-credentials \
       --from-literal=username="$POSTGRES_USER" \
       --from-literal=password="$POSTGRES_PASSWORD"
  fi
}

trino_install()
{
  if ! kubectl get namespace trino 2> /dev/null ; then
    helm repo add trino https://trinodb.github.io/charts
    helm repo update
    helm install -f k8s/yaml2/trino/values.yaml --create-namespace --namespace trino  trino-cluster trino/trino
  fi
}

mongodb_install()
{
  if ! kubectl get namespace mongodb 2> /dev/null ; then
    helm repo add mongodb https://mongodb.github.io/helm-charts
    helm repo update
    helm install community-operator mongodb/community-operator --create-namespace --namespace mongodb
  fi
}

postgres_install()
{
  if ! kubectl get namespace postgres 2> /dev/null ; then
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm repo update

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

minio_copy()
{
  set +x

  echo "Waiting MINIO S3"

  while ! mc ls local 2> /dev/null ; do
    echo -n "."
    sleep 10
  done

  set -x

  # Copy files
  if ! mc ls local/bronze ; then
    mc mb local/bronze

    mc cp --recursive "$LABTOOLS_K8S/load-data/bronze/" local/bronze/

    mc mb local/silver
    mc mb local/gold
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

# brew install minio-mc helm TODO

labtools-k8s configure-clusters

labtools-k8s set-context cluster2

minio_install

postgres_install

mongodb_install

trino_install

airflow_install

kubectl apply -f "$LABTOOLS_K8S/k8s/yaml2/"

zeppelin_create_secret

sleep 2
labtools-k8s set-ingress zeppelin zeppelin-server zeppelin

ingress_redirect

sleep 5

minio_copy

kubectl describe pods -n zeppelin | grep -A20 Events
