```shell
POSTGRES_HOST=postgres-postgresql.postgres.svc.cluster2.xpt
```

```shell
nc -v $POSTGRES_HOST 5432
```

```shell
labtools-k8s set-context cluster2
export POSTGRES_PASSWORD=$(kubectl get secret --namespace postgres postgres-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)
echo Host: $POSTGRES_HOST \| User: postgres \| Password: $POSTGRES_PASSWORD
```

```shell
kubectl run postgres-postgresql-client --rm --tty -i --restart='Never' \
                                       --namespace postgres --image docker.io/bitnami/postgresql:15.1.0-debian-11-r20 \
                                       --env="PGPASSWORD=$POSTGRES_PASSWORD" \
                                       --command -- psql --host $POSTGRES_HOST -U postgres -d postgres -p 5432
```

   * Shell FIXME
```shell
kubectl run postgres-postgresql-client --rm --tty -i --restart='Never' \
                                       --namespace postgres --image docker.io/bitnami/postgresql:15.1.0-debian-11-r20 \
                                       --env="PGPASSWORD=$POSTGRES_PASSWORD" \
                                       --command -- /bin/bash
```


```postgresql
table pg_hba_file_rules;
```

| PSQL Command      | Description                                   |
|-------------------|-----------------------------------------------|
| \l                | Show database                                 |
| \c test           | Use database                                  |
| \dt               | List tables                                   |
| \dt test          | Describe table                                | 
| select version(); | Show Postgres version                         |
| \h drop table     | Knowing the Syntaxes of PostgreSQL Statements |
| \timing           | Knowing the Execution Times of Queries        |
| \e                | psql + text editor                            |

```text
 line_number | type  | database | user_name |  address  |                 netmask                 | auth_method | options | error 
-------------+-------+----------+-----------+-----------+-----------------------------------------+-------------+---------+-------
           1 | host  | {all}    | {all}     | 0.0.0.0   | 0.0.0.0                                 | md5         |         | 
           2 | host  | {all}    | {all}     | ::        | ::                                      | md5         |         | 
           3 | local | {all}    | {all}     |           |                                         | md5         |         | 
           4 | host  | {all}    | {all}     | 127.0.0.1 | 255.255.255.255                         | md5         |         | 
           5 | host  | {all}    | {all}     | ::1       | ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff | md5         |         | 
```


```shell
kubectl logs -n postgres postgres-postgresql-0 -f
```

```shell
kubectl delete pod postgres-postgresql-client
```

```text
NAME: postgresl -f values.yaml postgres bitnami/postgresql                                                                                                                                                                                                                                        ─╯
LAST DEPLOYED: Mon Jan 23 04:00:26 2023
NAMESPACE: postgres
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: postgresql
CHART VERSION: 12.1.9
APP VERSION: 15.1.0

** Please be patient while the chart is being deployed **

PostgreSQL can be accessed via port 5432 on the following DNS names from within your cluster:

    postgres-postgresql.postgres.svc.cluster.local - Read/Write connection

To get the password for "postgres" run:

    export POSTGRES_PASSWORD=$(kubectl get secret --namespace postgres postgres-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)

To connect to your database run the following command:

    kubectl run postgres-postgresql-client --rm --tty -i --restart='Never' --namespace postgres --image docker.io/bitnami/postgresql:15.1.0-debian-11-r20 --env="PGPASSWORD=$POSTGRES_PASSWORD" \
      --command -- psql --host postgres-postgresql -U postgres -d postgres -p 5432

    > NOTE: If you access the container using bash, make sure that you execute "/opt/bitnami/scripts/postgresql/entrypoint.sh /bin/bash" in order to avoid the error "psql: local user with ID 1001} does not exist"

To connect to your database from outside the cluster execute the following commands:

    kubectl port-forward --namespace postgres svc/postgres-postgresql 5432:5432 &
    PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -d postgres -p 5432
```

## Backup
```shell
kubectl run postgres-postgresql-restore --rm --tty -i --restart='Never' --namespace postgres --image docker.io/bitnami/postgresql:15.1.0-debian-11-r20 --env="PGPASSWORD=$POSTGRES_PASSWORD" \
 --command -- pg_dump
```

## Restore
```shell
kubectl run postgres-postgresql-restore --rm --tty -i --restart='Never' --namespace postgres --image docker.io/bitnami/postgresql:15.1.0-debian-11-r20 --env="PGPASSWORD=$POSTGRES_PASSWORD" \
 --command -- pg_restore --host $POSTGRES_HOST -d teste /Volumes/data/test_bigdata
```
