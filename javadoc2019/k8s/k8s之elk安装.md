 
## 添加 Google incubator 仓库

```
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator

```

## 部署 Elasticsearch
```
kubectl create namespace efk
helm fetch incubator/elasticsearch
helm install --name els1 --namespace=efk -f values.yaml incubator/elasticsearch
kubectl run cirror-$RANDOM --rm -it --image=cirros -- /bin/sh
curl Elasticsearch:Port/_cat/nodes
```


## 部署 Fluentd

```
helm fetch stable/fluentd-elasticsearch
vim values.yaml
```

# 更改其中 Elasticsearch 访问地址

```
helm install --name flu1 --namespace=efk -f values.yaml stable/fluentd-elasticsearch
```


## 部署 kibana
```
helm fetch stable/kibana --version 0.14.8
helm install --name kib1 --namespace=efk -f values.yaml stable/kibana --version 0.14.8
```

