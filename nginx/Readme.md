### deploy
```
k apply -f deploy.yaml
```

### podから接続
```
kubectl get pods -n nginx
NAME                       READY   STATUS    RESTARTS   AGE
my-nginx-b76ddff66-nwhsq   1/1     Running   0          5m31s
my-nginx-b76ddff66-qct2v   1/1     Running   0          5m32s

kubectl get pods -o yaml -n nginx | grep -i podip:
    podIP: 172.17.0.2
    podIP: 172.17.0.4

kubectl exec -it my-nginx-b76ddff66-nwhsq -n nginx -- curl http://172.17.0.2
kubectl exec -it my-nginx-b76ddff66-nwhsq -n nginx -- curl http://172.17.0.4
```

### ローカルから接続
```
kubectl get nodes -o wide
NAME       STATUS   ROLES                  AGE    VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE              KERNEL-VERSION   CONTAINER-RUNTIME
minikube   Ready    control-plane,master   237d   v1.22.3   192.168.64.4   <none>        Buildroot 2021.02.4   4.19.202         docker://20.10.8

kubectl get svc -n nginx
NAME       TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
my-nginx   NodePort   10.109.114.229   <none>        8080:30080/TCP   16m

curl http://192.168.64.4:30080
```