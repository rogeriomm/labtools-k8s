
   * https://artifacthub.io/packages/helm/airflow-helm/airflow

```shell
labtools-k8s set-context cluster2
POSTGRES_HOST=postgres-postgresql.postgres.svc.cluster2.xpt
export POSTGRES_PASSWORD=$(kubectl get secret --namespace postgres postgres-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)
export POSTGRES_USER=postgres
echo Host: $POSTGRES_HOST \| User: $POSTGRES_USER \| Password: $POSTGRES_PASSWORD
```


```shell
kubectx cluster2
kubectl -n airflow delete secret airflow-cluster1-database-credentials 2> /dev/null
kubectl -n airflow create secret generic airflow-cluster1-database-credentials \
       --from-literal=username=$POSTGRES_USER \
       --from-literal=password=$POSTGRES_PASSWORD
```

```text
NAME: airflow
LAST DEPLOYED: Fri May  5 09:09:55 2023
NAMESPACE: airflow
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
========================================================================
Thanks for deploying Apache Airflow with the User-Community Helm Chart!

====================
        TIPS
====================
Default Airflow Webserver login:
  * Username:  admin
  * Password:  admin

You have NOT set up persistence for worker task logs, do this by:
  1. Using a PersistentVolumeClaim with `logs.persistence.*`
  2. Using remote logging with `AIRFLOW__LOGGING__REMOTE_LOGGING`

It looks like you have NOT exposed the Airflow Webserver, do this by:
  1. Using a Kubernetes Ingress with `ingress.*`
  2. Using a Kubernetes LoadBalancer/NodePort type Service with `web.service.type`

Use these commands to port-forward the Services to your localhost:
  * Airflow Webserver:  kubectl port-forward svc/airflow-web 8080:8080 --namespace airflow
  * Flower Dashboard:   kubectl port-forward svc/airflow-flower 5555:5555 --namespace airflow

====================
      WARNINGS
====================
[CRITICAL] default fernet encryption key value!
  * HELP: set a custom value with `airflow.fernetKey` or `AIRFLOW__CORE__FERNET_KEY`

[CRITICAL] default webserver secret_key value!
  * HELP: set a custom value with `airflow.webserverSecretKey` or `AIRFLOW__WEBSERVER__SECRET_KEY`

[MEDIUM] the scheduler "task creation check" is disabled, the scheduler may not be restarted if it deadlocks!
  * HELP: configure the check with `scheduler.livenessProbe.taskCreationCheck.*`

========================================================================

```


