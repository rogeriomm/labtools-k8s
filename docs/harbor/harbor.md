```shell
  echo Username: "admin"
  echo Password: $(kubectl get secret --namespace harbor harbor-core-envvars -o jsonpath="{.data.HARBOR_ADMIN_PASSWORD}" | base64 -d)
```

```shell
docker login harbor.worldl.xpt --username admin \
         --password $(kubectl get secret --namespace harbor harbor-core-envvars -o jsonpath="{.data.HARBOR_ADMIN_PASSWORD}" | base64 -d)
```

```text
Pulled: registry-1.docker.io/bitnamicharts/harbor:19.9.0
Digest: sha256:41c62aab0c37cc5bc7d6613141e225a9491bbcc274b756392ec396c47b843c20
Release "harbor" has been upgraded. Happy Helming!
NAME: harbor
LAST DEPLOYED: Wed Feb 28 07:11:40 2024
NAMESPACE: harbor
STATUS: deployed
REVISION: 2
TEST SUITE: None
NOTES:
CHART NAME: harbor
CHART VERSION: 19.9.0
APP VERSION: 2.10.0

** Please be patient while the chart is being deployed **

1. Get the Harbor URL:

  NOTE: It may take a few minutes for the LoadBalancer IP to be available.
        Watch the status with: 'kubectl get svc --namespace harbor -w harbor'
    export SERVICE_IP=$(kubectl get svc --namespace harbor harbor --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
    echo "Harbor URL: http://$SERVICE_IP/"

2. Login with the following credentials to see your Harbor application

  echo Username: "admin"
  echo Password: $(kubectl get secret --namespace harbor harbor-core-envvars -o jsonpath="{.data.HARBOR_ADMIN_PASSWORD}" | base64 -d)




WARNING: There are "resources" sections in the chart not set. Using "resourcesPreset" is not recommended for production. For production installations, please set the following values according to your workload needs:
  - core.resources
  - exporter.resources
  - jobservice.resources
  - nginx.resources
  - portal.resources
  - registry.controller.resources
  - registry.server.resources
  - trivy.resources
+info https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
```