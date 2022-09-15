# mongodb をkubernetesにデプロイ

### ユーザ・パスワードを暗号化
```
echo "adminuser" | base64
echo "password" | base64
```

### mongodbサーバのデプロイ
```
k apply -f mongodb-pv.yaml
k apply -f mongodb-ns.yaml
k apply -f mongodb-secrets.yaml
k apply -f mongodb-pvc.yaml
k apply -f mongodb-statefulset.yaml
k apply -f mongodb-nodeport-svc.yaml
```

### 接続特権ユーザの登録
```
kubectl exec statefulset/mongo -it -n mongodb -- /bin/bash
mongo
rs.status()
rs.initiate()
use admin
db.createUser({user:"adminuser", pwd:"password", roles:["root"]})
exit

mongo -u adminuser
use admin
show users
db.getUsers();
```

### ローカル(mongo shell)から接続
```
k get nodes -o wide
NAME       STATUS   ROLES                  AGE    VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE              KERNEL-VERSION   CONTAINER-RUNTIME
minikube   Ready    control-plane,master   237d   v1.22.3   192.168.64.4   <none>        Buildroot 2021.02.4   4.19.202         docker://20.10.8

k get svc -n mongodb
NAME                 TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)           AGE
mongo-nodeport-svc   NodePort   10.98.237.216   <none>        27017:32000/TCP   5m29s
```

```
mongosh mongodb://192.168.64.4:32000 -u adminuser -p password

or

mongosh mongodb://adminuser:password@192.168.64.4:32000

※mongosh mongodb://<ip>:<port of nodeport svc>/ships -u adminuser -p password
```

### mongodbクライアントをデプロイして、クライアントから接続
```
k apply -f mongodb-client.yaml

kubectl exec deployment/mongo-client -it -n mongodb -- /bin/bash
mongosh --host mongo-nodeport-svc --port 27017 -u adminuser -p password

help
show dbs
db
use db1
show collections
db.blogs.insert({name: "devopscube" })
db.blogs.find()
db.blogs.updateOne({ name: "devops"}, { $set: { name: "devopsaaa" }})
db.blogs.findOneAndUpdate({name: "devopscube" }, { $set: { name: "devops" }})
db.blogs.find({name:"devops"})
db.blogs.deleteOne({name:"devops"})
db.blogs.drop()
show logs
exit
```

[参考](https://devopscube.com/deploy-mongodb-kubernetes/)
