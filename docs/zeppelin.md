

# Create http authentication file
```shell
cat dot.htpasswd | base64
kubectl get secret secret-basic-auth  --output="jsonpath={.data.dot\.htpasswd}" | base64 --decode
```
# Create TLS certificate
```shell
kubectl -n zeppelin create secret tls zeppelin-tls-secret \
  --cert=cert/public.crt \
  --key=cert/private.key
```
   * Show certificate
```shell
openssl x509 -in public.crt -noout -text
```

# References
   * https://kubernetes.io/docs/concepts/configuration/secret/: Secrets
      * Search "TLS secrets" 