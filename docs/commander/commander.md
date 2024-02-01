```shell
kubectx cluster2
kubectl create -n commander secret generic ssh --from-file=id_rsa=$HOME/.ssh/id_rsa_tunnel
```

   * ~/.ssh/config
```text
Host tunnel
	Hostname localhost
	StrictHostKeyChecking no
	UserKnownHostsFile /dev/null
    LogLevel ERROR
	User tunnel
	Port 2222
```

# Links
   * https://gist.github.com/pyhedgehog/f64df4cb4e2abf4cbb240edfc8aafd88