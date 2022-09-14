# posgtresql をkubernetesにデプロイ

### パスワードを暗号化
```
echo "password" | base64
```

### デプロイ
```
k apply -f pv-volume.yml
k apply -f posgtres-ns.yml
k apply -f postgres-pv-claim.yml
k apply -f postgres-secrets.yml
k apply -f postgres-deployment.yml
k apply -f postgres-service.yml
```

### podから接続
```
kubectl get pods -n postgres
kubectl exec -it postgres-5c8969599b-h7t65 -n postgres -- psql -U postgres
```

### ローカルから接続
```
k get nodes -o wide
NAME       STATUS   ROLES                  AGE    VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE              KERNEL-VERSION   CONTAINER-RUNTIME
minikube   Ready    control-plane,master   237d   v1.22.3   192.168.64.4   <none>        Buildroot 2021.02.4   4.19.202         docker://20.10.8

k get svc -n postgres
NAME       TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
postgres   NodePort   10.96.180.252   <none>        5432:32319/TCP   18m
```

```
psql -h 192.168.64.4 -p 32319 -U postgres -d postgres
```

### データベース作成・削除
```
\l

CREATE DATABASE mydb OWNER = postgres TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'ja_JP.UTF-8' LC_CTYPE = 'ja_JP.UTF-8';
※日本語環境でないとエラー
CREATE DATABASE mydb OWNER = postgres TEMPLATE = template0 ENCODING = 'UTF8';

\c mydb

create table mybook (
  id integer, 
  name varchar(10)
);

\dt;

drop table mybook;

\dn

CREATE SCHEMA myschema;

select current_schema;

SET search_path = myschema;

create table myschema.mybook (
  id integer, 
  name varchar(10)
);

\dt;

insert into myschema.mybook values (1, 'Yamada');

select * from myschema.mybook;

\c postgres

DROP DATABASE myschema.mydb;

help

\q
```

[参考](https://www.sumologic.jp/blog/kubernetes-deploy-postgres/)
