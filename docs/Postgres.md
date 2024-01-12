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

# Security

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

In PostgreSQL, the `pg_hba.conf` file specifies several authentication methods (`auth_method`) that can be used to control how users authenticate when connecting to the database. Here are some common `auth_method` values:

1. **Trust**: This method allows a user to connect without a password. As the name implies, it's based on trust and is not secure for production environments.
2. **Reject**: This method rejects the connection unconditionally. It's useful for explicitly denying access in certain scenarios.
3. **Md5**: This method uses MD5 cryptographic hashing for password-based authentication. It's more secure than `trust` but less secure than newer methods like `scram-sha-256`.
4. **Password**: This is a clear-text password method. It's not as secure as `md5` or `scram-sha-256` because the password is sent over the network as plain text.
5. **Gss**: This method uses Generic Security Services for authentication. It's often used in enterprise environments with existing GSSAPI infrastructure.
6. **Sspi**: This method is similar to GSSAPI but is specific to Windows and uses the native SSPI interface for authentication.
7. **Kerberos**: This method uses Kerberos V5 for authentication. It's a secure, ticket-based protocol commonly used in enterprise environments.
8. **Ident**: This method is used for TCP/IP connections and obtains the client's operating system user name from an ident server and uses it for authentication.
9. **Peer**: Similar to `ident`, this method is used for local connections and obtains the client's operating system user name from the kernel and uses it for authentication.
10. **Pam**: This method uses the Pluggable Authentication Modules (PAM) for authentication. It allows PostgreSQL to use more complex authentication methods configured through PAM.
11. **Ldap**: This method uses Lightweight Directory Access Protocol (LDAP) for authentication against an LDAP server.
12. **RADIUS**: This method uses RADIUS (Remote Authentication Dial-In User Service) protocol for authentication.
13. **Scram-sha-256**: This is a secure method that uses SCRAM-SHA-256, a salted challenge-response mechanism. It's recommended over `md5` for better security.
14. **Cert**: This method uses SSL client certificates for authentication.

These methods can be mixed in the `pg_hba.conf` file to provide different authentication mechanisms for different types of connections (local, host, etc.), users, and databases. 
The choice of authentication method should align with the security requirements and infrastructure of the environment where PostgreSQL is deployed.



# Logs

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


# Install psql on macOS
   * https://stackoverflow.com/questions/44654216/correct-way-to-install-psql-without-full-postgres-on-macos


# Create database/users
   * https://github.com/bitnami/charts/issues/7378
   * https://github.com/bitnami/charts/tree/main/bitnami/postgresql
   * https://github.com/bitnami/charts/tree/main/bitnami/postgresql#initialize-a-fresh-instance

```text
Initialize a fresh instance
The Bitnami PostgreSQL image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, you can specify custom scripts using the primary.initdb.scripts parameter as a string.
In addition, you can also set an external ConfigMap with all the initialization scripts. This is done by setting the primary.initdb.scriptsConfigMap parameter. Note that this will override the two previous options. If your initialization scripts contain sensitive information such as credentials or passwords, you can use the primary.initdb.scriptsSecret parameter.
The allowed extensions are .sh, .sql and .sql.gz.
```

```shell
export POSTGRES_PASSWORD=$(kubectl get secret --namespace postgres postgres-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)
echo $POSTGRES_PASSWORD
```

```shell
export POSTGRES_PASSWORD=$(kubectl get secret --namespace postgres postgres-postgresql -o jsonpath="{.data.password}" | base64 -d)
kubectl run postgres-postgresql-client --rm --tty -i --restart='Never' --namespace postgres --image docker.io/bitnami/postgresql:16.1.0-debian-11-r19 --env="PGPASSWORD=$POSTGRES_PASSWORD" \
      --command -- psql --host postgres-postgresql -U airflow -d airflow -p 5432
```


   * https://stackoverflow.com/questions/55499984/postgresql-in-helm-initdbscripts-parameter
