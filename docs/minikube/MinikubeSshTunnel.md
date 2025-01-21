```shell
docker ps
```
```text
CONTAINER ID   IMAGE                                 COMMAND                  CREATED      STATUS             PORTS                                                                                                                                  NAMES
e7dc39ad7c72   gcr.io/k8s-minikube/kicbase:v0.0.42   "/usr/local/bin/entr…"   9 days ago   Up About an hour   127.0.0.1:50382->22/tcp, 127.0.0.1:50383->2376/tcp, 127.0.0.1:50385->5000/tcp, 127.0.0.1:50386->8443/tcp, 127.0.0.1:50384->32443/tcp   cluster1
576c1e719a88   gcr.io/k8s-minikube/kicbase:v0.0.42   "/usr/local/bin/entr…"   9 days ago   Up About an hour   127.0.0.1:51109->22/tcp, 127.0.0.1:51110->2376/tcp, 127.0.0.1:51107->5000/tcp, 127.0.0.1:51108->8443/tcp, 127.0.0.1:51106->32443/tcp   cluster2-m04
460b768be541   gcr.io/k8s-minikube/kicbase:v0.0.42   "/usr/local/bin/entr…"   9 days ago   Up About an hour   127.0.0.1:50929->22/tcp, 127.0.0.1:50930->2376/tcp, 127.0.0.1:50927->5000/tcp, 127.0.0.1:50928->8443/tcp, 127.0.0.1:50931->32443/tcp   cluster2-m03
5e5881379c9d   gcr.io/k8s-minikube/kicbase:v0.0.42   "/usr/local/bin/entr…"   9 days ago   Up About an hour   127.0.0.1:50789->22/tcp, 127.0.0.1:50790->2376/tcp, 127.0.0.1:50792->5000/tcp, 127.0.0.1:50793->8443/tcp, 127.0.0.1:50791->32443/tcp   cluster2-m02
e6b14b3b6567   gcr.io/k8s-minikube/kicbase:v0.0.42   "/usr/local/bin/entr…"   9 days ago   Up About an hour   127.0.0.1:50571->22/tcp, 127.0.0.1:50567->2376/tcp, 127.0.0.1:50569->5000/tcp, 127.0.0.1:50570->8443/tcp, 127.0.0.1:50568->32443/tcp   cluster2
```

Search 127.0.0.1:50571->22/tcp

```shell
minikube -p cluster2 ssh-key
```
```text
/Volumes/data/.minikube/machines/cluster2/id_rsa
```

```shell
ssh docker@localhost -p 50571 -i /Volumes/data/.minikube/machines/cluster2/id_rsa 
```

<img src="JetbrainsSshTunnel.png" alt="drawing" width="400"/>
