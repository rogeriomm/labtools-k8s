```shell
kubectl get pv | tail -n+2 | awk '$5 == "Released" {print $1}' | xargs -I{} kubectl patch pv {} --type='merge' -p '{"spec":{"claimRef": null}}
```


# Links
   * https://stackoverflow.com/questions/50667437/what-to-do-with-released-persistent-volume
   * https://copyprogramming.com/howto/kubernetes-pod-warning-1-node-s-had-volume-node-affinity-conflict
