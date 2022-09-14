### ssh用コンテナのビルド
```
docker build -t devhishiki/remote-development:v0.2 ./container/
docker images
```

### ssh用のコンテナイメージをコンテナレジストリにプッシュ
```
docker push devhishiki/remote-development:v0.2
```

[参考1](https://rikeiin.hatenablog.com/entry/2019/10/21/192403)
[参考2](https://github.com/ruediste/docker-sshd)

### ホスト鍵作成・kubernetesに登録
```
./generateHostKeys.sh
```

### クライアント（自分）の公開鍵を作成・登録
```
ssh-keygen
~/.ssh/remote-development_rsa
cat ~/.ssh/remote-development_rsa.pub > ./authorized_keys
```

### クライアント（自分）の公開鍵をkubernetesの登録
```
./UpdateKeys.sh
```

### kubernetesにssh用コンテナをデプロイ
```
kubectl apply -f ./k8s/
k get all -n development
```

### クライアント（自分）のssh接続設定（mac）

```
kubectl get nodes -o wide
NAME       STATUS   ROLES                  AGE    VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE              KERNEL-VERSION   CONTAINER-RUNTIME
minikube   Ready    control-plane,master   237d   v1.22.3   192.168.64.4   <none>        Buildroot 2021.02.4   4.19.202         docker://20.10.8

vim ~/.ssh/config

※以下の内容を追加
Host 192.168.64.4
  User root
  HostName 192.168.64.4
  IdentityFile ~/.ssh/remote-development_rsa
```

### ssh用コンテナへの接続確認
```
kubectl get svc -n development
NAME   TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
ssh    NodePort   10.101.71.194   <none>        22:31098/TCP   2m52s

ssh root@192.168.64.4 -p 31098

※「.ssh/config」に設定せず、以下のコマンドでも接続可
ssh root@192.168.64.4 -p 31098 -i ~/.ssh/remote-development_rsa
```


※コンテナに接続
kubectl get pods -n development
kubectl exec -it ssh-858558c659-n2dbw -n development -- bash

※コンテナイメージ作成前の作成方法確認
kubectl run -it ubuntu --image=ubuntu:20.04 --restart=Never -- bash
