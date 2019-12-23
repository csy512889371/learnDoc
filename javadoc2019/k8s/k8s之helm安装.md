


```
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz
tar -zxvf helm-v2.13.1-linux-amd64.tar.gz

mkdir -p /root/install-k8s/helm

mv helm-v2.13.1-linux-amd64.tar.gz /root/install-k8s/helm

cd /root/install-k8s/helm
tar -zxvf helm-v2.13.1-linux-amd64.tar.gz
cp -a linux-amd64/helm /usr/local/bin/

chmod a+x /usr/local/bin/helm
```

```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
```



```
kubectl create -f rbac-config.yaml 


serviceaccount/tiller created 
clusterrolebinding.rbac.authorization.k8s.io/tiller created

```

```
helm init --service-account tiller --skip-refresh
```



```
git clone https://github.com/coreos/kube-prometheus.git

cd /root/install-k8s/plugins/prometheus/kube-prometheus/manifests


```



```
vim grafana-service.yaml 

apiVersion: v1
kind: Service
metadata:
  labels:
    app: grafana
  name: grafana
  namespace: monitoring
spec:
  type: NodePort # 添加内容
  ports:
  - name: http
    port: 3000
    targetPort: http
    nodePort: 30100 # 添加内容
  selector:
    app: grafana

```

```
vim prometheus-service.yaml 

apiVersion: v1
kind: Service
metadata:
  labels:
    prometheus: k8s
  name: prometheus-k8s
  namespace: monitoring
spec:
  type: NodePort # 添加内容
  ports:
  - name: web
    port: 9090
    targetPort: web
    nodePort: 30200 # 添加内容
  selector:
    app: prometheus
    prometheus: k8s
  sessionAffinity: ClientIP
```


```
vim alertmanager-service.yaml 
apiVersion: v1
kind: Service
metadata:
  labels:
    alertmanager: main
  name: alertmanager-main
  namespace: monitoring
spec:
  type: NodePort # 添加内容
  ports:
  - name: web
    port: 9093
    targetPort: web
    nodePort: 30300 # 添加内容
  selector:
    alertmanager: main
    app: alertmanager
  sessionAffinity: ClientIP
```


```
kubectl apply -f ../manifests/
```


