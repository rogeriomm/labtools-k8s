#!/usr/bin/env zsh

configure_metallb_for_minikube() {
  # determine load balancer ingress range
  CIDR_BASE_ADDR="$(minikube ip)"
  INGRESS_FIRST_ADDR="$(echo "${CIDR_BASE_ADDR}" | awk -F'.' '{print $1,$2,$3,2}' OFS='.')"
  INGRESS_LAST_ADDR="$(echo "${CIDR_BASE_ADDR}" | awk -F'.' '{print $1,$2,$3,255}' OFS='.')"
  INGRESS_RANGE="${INGRESS_FIRST_ADDR}-${INGRESS_LAST_ADDR}"

  CONFIG_MAP="apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - $INGRESS_RANGE"

  # configure metallb ingress address range
  echo "${CONFIG_MAP}" | kubectl apply -f -
}

certmanager_install()
{
    if ! helm status cert-manager -n cert-manager 2> /dev/null > /dev/null; then
      kubectl create namespace cert-manager
      # https://cert-manager.io/docs/installation/helm/#3-install-customresourcedefinitions
      kubectl -n cert-manager apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.2/cert-manager.crds.yaml

      helm repo add jetstack https://charts.jetstack.io --force-update
      helm repo update jetstack
      helm install --namespace cert-manager --create-namespace cert-manager jetstack/cert-manager \
          --values k8s/cluster2/helm/cert-manager/values.yaml \
          --version v1.14.2
    fi
}

velero_install()
{
    if ! helm status velero -n velero 2> /dev/null > /dev/null; then
      helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts
      helm repo update vmware-tanzu
      helm install --namespace velero velero vmware-tanzu/velero --values k8s/cluster2/helm/velero/values.yaml
    fi
}

localstack_install() {
    if ! helm status localstack -n localstack 2> /dev/null > /dev/null; then
      helm repo add localstack https://localstack.github.io/helm-charts
      helm repo update localstack
      helm install --namespace localstack --create-namespace localstack localstack/localstack \
         --values k8s/cluster2/helm/localstack/values.yaml --version 0.6.8
    fi
}

minikube_configure()
{
  # Raise the kindnet daemonset pod memory resource limit
  kubectl -n kube-system patch daemonset kindnet --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/resources/limits/memory", "value":"100Mi"}]'

  if ! kubectl -n kube-system get secret cluster-truststore-jks; then
    keytool -noprompt -import -alias ca -file "$MINIKUBE_HOME/ca.crt" -keystore /tmp/cluster.truststore.jks -storepass 123456
    kubectl -n kube-system create secret generic cluster-truststore-jks --from-file=cluster.truststore.jks=/tmp/cluster.truststore.jks
    kubectl annotate secret cluster-truststore-jks replicator.v1.mittwald.de/replicate-to=kafka-main-cluster
    rm /tmp/cluster.truststore.jks
  fi
}

argocd_install()
{
  if ! helm status argocd -n argocd 2> /dev/null > /dev/null; then
    helm repo add argocd https://argoproj.github.io/argo-helm
    helm repo update argocd
    helm install --namespace argocd --create-namespace argocd  \
        argocd/argo-cd --values k8s/cluster2/helm/argocd/values.yaml \
        --version 5.55.0 \
        --wait --timeout 600s
  fi

  # Login Argo CD
  #password=$(kubectl -n argocd get secret argocd-initial-admin-secret -o=jsonpath='{.data.password}' | base64 -d)
  #argocd login argocd.worldl.xpt --grpc-web --username admin --password "$password"
  #argocd repo add  https://github.com/rogeriomm/labtools-k8s --name labtools-k8s

  #if ! argocd proj get labtools-k8s > /dev/null ; then
  #  argocd proj create labtools-k8s --description "labtools-k8s"
  #fi
}

nexus_install()
{
  if ! helm status nexus -n nexus 2> /dev/null > /dev/null; then
    helm repo add sonatype https://sonatype.github.io/helm3-charts/
    helm repo update sonatype
    helm install --namespace nexus --create-namespace nexus \
         sonatype/nexus-iq-server --values k8s/cluster2/helm/nexus/values.yaml \
         --version 171.0.0
  fi
}

#
# https://github.com/jfrog/charts
#
jfrog_install()
{
  if ! helm status jfrog-artifactory-jcr -n jfrog 2> /dev/null > /dev/null; then
    helm repo add jfrog https://charts.jfrog.io
    helm repo update jfrog

    helm install --namespace jfrog --create-namespace jfrog-artifactory-jcr \
         jfrog/artifactory-jcr --values k8s/cluster2/helm/jfrog/values-artifactory-jcr.yaml \
         --version 107.77.3
  fi
}

elasticsearch_install()
{
  if ! helm status elasticsearch -n elasticsearch 2> /dev/null > /dev/null; then
    helm install --namespace elasticsearch --create-namespace elasticsearch \
         oci://registry-1.docker.io/bitnamicharts/elasticsearch --values k8s/cluster2/helm/elasticsearch/values.yaml \
         --version 19.17.2
  fi
}

# https://github.com/open-metadata/openmetadata-helm-charts
openmetadata_install()
{
  if ! helm status openmetadata -n openmetadata 2> /dev/null > /dev/null; then
    helm repo add open-metadata https://helm.open-metadata.org/
    helm repo update open-metadata

    helm install openmetadata --namespace openmetadata --create-namespace open-metadata/openmetadata \
        --values k8s/cluster2/helm/openmetadata/values.yaml --version 1.3.0
  fi
}

#
# https://datahubproject.io/docs/deploy/kubernetes/#quickstart
#
datahub_install()
{
  if ! helm status datahub -n datahub 2> /dev/null > /dev/null; then
    helm repo add datahub https://helm.datahubproject.io/
    helm repo update datahub

    kubectl create namespace datahub

    helm install --namespace datahub prerequisites datahub/datahub-prerequisites \
      --values k8s/cluster2/helm/datahub/values-prerequisites.yaml \
      --version 0.1.7

    helm install --namespace datahub datahub datahub/datahub \
       --values k8s/cluster2/helm/datahub/values.yaml \
       --version 0.3.28 \
       --wait --timeout 1000s
  fi
}

keycloak_install()
{
  if ! helm status my-release -n keycloak 2> /dev/null > /dev/null; then
    helm install my-release oci://registry-1.docker.io/bitnamicharts/keycloak --create-namespace --namespace keycloak  \
         --values k8s/cluster2/helm/keycloak/values.yaml
  fi
}

#
# helm search repo airflow-stable
#
airflow_install()
{
  if ! helm status airflow -n airflow 2> /dev/null > /dev/null; then
    helm repo add airflow-stable https://airflow-helm.github.io/charts
    helm repo update airflow-stable
    # See "Airflow Version Support on https://artifacthub.io/packages/helm/airflow-helm/airflow
    helm install airflow airflow-stable/airflow --create-namespace --namespace airflow --version "8.8.0" --values k8s/cluster2/helm/airflow/values.yaml
  fi
}

# https://github.com/trinodb/charts
trino_install()
{
  if ! helm status trino -n trino 2> /dev/null > /dev/null;  then
    helm repo add trino https://trinodb.github.io/charts
    helm repo update trino
    helm install -f k8s/cluster2/helm/trino/values.yaml --create-namespace --namespace trino  trino trino/trino --version 0.18.0
  fi
}

mongodb_install()
{
  if ! helm status community-operator -n mongodb 2> /dev/null > /dev/null; then
    helm repo add mongodb https://mongodb.github.io/helm-charts
    helm repo update mongodb
    helm install -f k8s/cluster2/helm/mongodb/values.yaml community-operator mongodb/community-operator
    --create-namespace --namespace mongodb --version 0.9.0
  fi
}

# https://github.com/bitnami/charts/tree/main/bitnami/mysql
mysql_install()
{
  if ! helm status my-release -n mysql 2> /dev/null > /dev/null; then
    helm install my-release oci://registry-1.docker.io/bitnamicharts/mysql -f k8s/cluster2/helm/mysql/values.yaml \
         --create-namespace --namespace mysql
  fi
}

mysql_show()
{
  set +x && echo -n "\033[34mMySQL root password: " && \
    kubectl -n mysql get secret my-release-mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode && \
    echo -n "\033[0m" && echo "" &&
    set -x
}

# https://stackoverflow.com/questions/55499984/postgresql-in-helm-initdbscripts-parameter
postgres_install()
{
  if ! helm status postgres -n postgres 2> /dev/null > /dev/null; then
    helm install postgres oci://registry-1.docker.io/bitnamicharts/postgresql -f k8s/cluster2/helm/postgres/values.yaml \
         --create-namespace --namespace postgres --version 13.2.30
  fi
}

postgres_show()
{
  set +x && echo -n "\033[34mPostgres admin password: " && \
    kubectl -n postgres  get secret postgres-postgresql -o jsonpath="{.data.postgres-password}" | base64 --decode | grep -v '^$' && \
    echo -n "\033[0m" &&
    set -x
}

# https://artifacthub.io/packages/helm/simcube/mssqlserver-2022
sqlserver_install()
{
  if ! helm status mssqlserver-2022 -n sqlserver 2> /dev/null > /dev/null; then
    helm repo add simcube https://simcubeltd.github.io/simcube-helm-charts/
    helm repo update simcube

    helm install mssqlserver-2022 simcube/mssqlserver-2022 -f k8s/cluster2/helm/sqlserver/values.yaml \
        --create-namespace --namespace sqlserver --version 1.2.3

    #kubectl -n sqlserver  wait deployment/mssqlserver-2022 --for=condition=Available --timeout=30m
  fi
}

# https://github.com/minio/operator
minio_install()
{
  if ! kubectl get namespace minio-operator; then
    echo "Installing MINIO operator..."
    kubectl krew update
    kubectl krew install minio
    kubectl krew update minio
    kubectl minio version
    domain=$(kubectl get cm coredns -n kube-system -o jsonpath="{.data.Corefile}" | grep kubernetes | awk -F ' ' '{print $2}')
    kubectl minio init --namespace minio-operator --cluster-domain "$domain"
  fi

  if ! kubectl minio tenant info minio-tenant-1 > /dev/null 2> /dev/null; then
    echo "Creating MINIO instance"

    kubectl minio tenant create minio-tenant-1 \
      --servers        3                       \
      --volumes        6                       \
      --capacity       100Gi                   \
      --namespace      minio-tenant-1          \
      --storage-class  minio-local-storage
  fi

  kubectl minio version
}

minio_show()
{
  set +x && echo "Minio password: " \
    set -x
}

minio_show_admin()
{
    user=$(kubectl -n minio-tenant-1 get secret minio-tenant-1-user-1  -o jsonpath='{.data.CONSOLE_ACCESS_KEY}' | base64 -d)
    password=$(kubectl -n minio-tenant-1 get secret minio-tenant-1-user-1  -o jsonpath='{.data.CONSOLE_SECRET_KEY}' | base64 -d)
    echo "Admin: $user/$password"
}

minio_copy()
{
  export https_proxy="http://localhost:8888"

  # Add "minio" user with policie "consoleAdmin"
  if ! mc admin user info local minio; then
    user=$(kubectl -n minio-tenant-1 get secret minio-tenant-1-user-1  -o jsonpath='{.data.CONSOLE_ACCESS_KEY}' | base64 -d)
    password=$(kubectl -n minio-tenant-1 get secret minio-tenant-1-user-1  -o jsonpath='{.data.CONSOLE_SECRET_KEY}' | base64 -d)
    echo -e "minio\nawesomes3" | mc admin user add local
    mc admin policy attach local consoleAdmin --user minio
  fi

  set +xlg

  if ! mc ls local 2> /dev/null > /dev/null ; then
    echo "Waiting MINIO S3"

    # Show MinIO Root User Credentials
    kubectl minio tenant info minio-tenant-1

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

livy_install()
{
  echo "Install Livy"
}

bitnami_confluent_registry_install()
{
    if ! helm status main-registry -n kafka-main-cluster 2> /dev/null > /dev/null; then
      # Bitnami package for Confluent Schema Registry
      helm install main-registry oci://registry-1.docker.io/bitnamicharts/schema-registry --namespace kafka-main-cluster \
                 --values "$LABTOOLS_K8S/k8s/$1/helm/registry-confluent/values.yaml" --version 14.1.1
    fi

    if kubectl get secret kafka-user-registry -n kafka-main-cluster 2> /dev/null > /dev/null; then
      kubectl get secret kafka-user-registry -n kafka-main-cluster -o json | \
          jq '.metadata.name = "kafka-user-registry-copy" | .metadata.labels = {"strimzi.io/kind":"Kafka", "strimzi.io/cluster":"main"} | .data."client-passwords" = .data.password | del(.metadata.creationTimestamp) | del(.metadata.resourceVersion) | del(.metadata.selfLink) | del(.metadata.uid)' | \
          kubectl apply -n kafka-main-cluster -f -
    fi
}

confluent_install_operator()
{
    if ! helm status confluent-operator -n kafka 2> /dev/null > /dev/null; then
      helm repo add confluentinc https://packages.confluent.io/helm
      helm repo update
      helm upgrade --install confluent-operator \
        confluentinc/confluent-for-kubernetes \
        --namespace kafka
    fi
}

kafka_ui_install()
{
  if kubectl -n kafka-main-cluster get secret kafka-user-ui; then
      sasl_jaas_config=$(kubectl -n kafka-main-cluster get secret kafka-user-ui -o=jsonpath='{.data.sasl\.jaas\.config}' | base64 -d)

      echo "
      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: kafka-ui-configmap
        namespace: kafka
      data:
        config.yml: |-
          kafka:
            clusters:
              - name: main
                bootstrapServers: main-kafka-bootstrap.kafka-main-cluster.svc:9092
                properties:
                  security.protocol: SASL_PLAINTEXT
                  sasl.mechanism: SCRAM-SHA-512
                  sasl.jaas.config: $sasl_jaas_config
                  schemaRegistry: http://main-registry-schema-registry.kafka-main-cluster.svc:8081
          auth:
            type: disabled
          management:
            health:
              ldap:
                enabled: false
      " | kubectl -n kafka apply -f -
  fi

  if ! helm status kafka-ui -n kafka 2> /dev/null > /dev/null; then
    helm install kafka-ui kafka-ui/kafka-ui --version 0.7.5 --namespace kafka \
         --values "$LABTOOLS_K8S/k8s/$1/helm/kafka-ui/values.yaml"
  fi
}

redpanda_console_install()
{
  if ! helm status redpandas-console -n kafka 2> /dev/null > /dev/null; then
    helm repo add redpanda https://charts.redpanda.com
    helm repo update redpanda

    kubectl -n kafka-main-cluster wait kafka/main --for=condition=Ready --timeout=900s

    # https://github.com/redpanda-data/console/blob/master/docs/installation.md#configuration
    #   In general we only use flags to specify the path to your config file which contains all the actual configuration.
    #   Because Console requires sensitive information such as credentials, we offer further flags so that you don't
    #   need to put them into your YAML configuration.
    sasl_password=$(kubectl -n kafka-main-cluster get secret kafka-user-ui -o=jsonpath='{.data.password}' | base64 -d)

    helm upgrade --install redpandas-console --namespace kafka redpanda/console \
       --values "$LABTOOLS_K8S/k8s/$1/helm/redpanda/values-console.yaml" \
       --set console.config.kafka.sasl.password="$sasl_password" \
       --version 0.7.20
  fi
}

kafka_install()
{
  if ! helm status strimzi-cluster-operator -n kafka 2> /dev/null > /dev/null; then
    kubectl create ns kafka
    kubectl create ns kafka-main-cluster
    kubectl create ns kafka-project-1
    kubectl create ns kafka-project-2
    kubectl create ns kafka-project-3
    kubectl create ns kafka-project-4
    kubectl create ns kafka-project-5

    # https://quay.io/repository/strimzi/operator
    helm install --namespace kafka strimzi-cluster-operator  oci://quay.io/strimzi-helm/strimzi-kafka-operator \
                 --create-namespace \
                 --values "k8s/$1/helm/kafka/values.yaml" --version 0.39.0

    kubectl rollout status deployment strimzi-cluster-operator -n kafka --timeout=90s

    # Check the status of the deployment
    kubectl get deployments -n kafka

    helm repo add kafka-ui https://provectus.github.io/kafka-ui-charts
    helm repo update kafka-ui
  fi
 }

kafka_wait_main_cluster()
{
  echo "Waiting Kafka main cluster"
  kubectl -n kafka-main-cluster wait kafka/main --for=condition=Ready --timeout=30m
}

#
# https://cert-manager.io/docs/devops-tips/syncing-secrets-across-namespaces/
#   https://github.com/mittwald/kubernetes-replicator
k8s-replicator_install()
{
  if ! helm status kubernetes-replicator -n k8s-replicator 2> /dev/null > /dev/null; then
    helm repo add mittwald https://helm.mittwald.de
    helm repo update mittwald
    helm upgrade --install kubernetes-replicator --create-namespace --namespace k8s-replicator mittwald/kubernetes-replicator
  fi
}

set -x
set -e

sudo -v

# Cluster 1 setup
labtools-k8s set-context cluster1

#minikube_configure

k8s-replicator_install

# Install Kafka api-resource on cluster1
kafka_install cluster1

kubectl apply -k "$LABTOOLS_K8S/k8s/cluster1/base"

#kubectl annotate secret kafka-user-ide  replicator.v1.mittwald.de/replicate-to="kafka" -n kafka-main-cluster

# Cluster 2 setup
labtools-k8s set-context cluster2

minikube_configure

#velero_install

k8s-replicator_install

# Install Kafka api-resource on cluster2
kafka_install cluster2

kafka_ui_install cluster2
bitnami_confluent_registry_install cluster2


certmanager_install

argocd_install

configure_metallb_for_minikube

# Install MongoDB api-resource on cluster2
mongodb_install

# Replicator
kubectl annotate secret mkcert replicator.v1.mittwald.de/replicate-to="zeppelin" -n kube-system

kubectl apply -k "$LABTOOLS_K8S/k8s/cluster2/overlay/dev"

#kafka_wait_main_cluster

jfrog_install

localstack_install

elasticsearch_install

minio_install
postgres_install
mysql_install
sqlserver_install

airflow_install
livy_install

trino_install
datahub_install
openmetadata_install

keycloak_install

redpanda_console_install cluster2

labtools-k8s set-ingress zeppelin zeppelin-server zeppelin

postgres_show
mysql_show
minio_show

minio_show_admin
minio_copy
