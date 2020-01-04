
kube-proxy开启ipvs的前置条件

```
modprobe br_netfilter

cat > /etc/sysconfig/modules/ipvs.modules <<EOF
#!/bin/bash
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack_ipv4
EOF

chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack_ipv4

```

安装 Docker 软件

```

yum install -y yum-utils device-mapper-persistent-data lvm2

yum-config-manager \
--add-repo \
http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo


yum update -y && yum install -y docker-ce

## 创建 /etc/docker 目录
mkdir /etc/docker

# 配置 daemon.
cat > /etc/docker/daemon.json <<EOF
{
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    }
}
EOF

mkdir -p /etc/systemd/system/docker.service.d


# 重启docker服务
systemctl daemon-reload && systemctl restart docker && systemctl enable docker


docker version

```

备注：centos 8 安装docker报错 containerd 版本太低

```
yum list docker-ce --showduplicates | sort -r


wget https://download.docker.com/linux/centos/7/x86_64/edge/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
yum -y install containerd.io-1.2.6-3.3.el7.x86_64.rpm

```





安装 Kubeadm （主从配置）

```
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

yum -y install kubeadm-1.15.1 kubectl-1.15.1 kubelet-1.15.1

systemctl enable kubelet.service

```

初始化主节点

```
kubeadm config print init-defaults > kubeadm-config.yaml

```

```
localAPIEndpoint:
 advertiseAddress: 192.168.66.10
kubernetesVersion: v1.15.1
networking:
 podSubnet: "10.244.0.0/16"
 serviceSubnet: 10.96.0.0/12
---
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
featureGates:
  SupportIPVSProxyMode: true
mode: ipvs

```

执行以下命令 会从全程拉去docker 镜像此时 可用命令 docker images  或者 docker ps -a 来查看进度(注: 此镜像需要上外网)
```
kubeadm init --config=kubeadm-config.yaml --experimental-upload-certs | tee kubeadm-init.log
```



== 将docker 镜像备份出来


k8s-master01 节点备份


```
mkdir /root/kubeadm-basic.images
cd /root/kubeadm-basic.images

docker save -o kube-apiserver.tar k8s.gcr.io/kube-apiserver
docker save -o kube-controller-manager.tar k8s.gcr.io/kube-controller-manager
docker save -o kube-scheduler.tar k8s.gcr.io/kube-scheduler
docker save -o kube-proxy.tar k8s.gcr.io/kube-proxy
docker save -o coredns.tar k8s.gcr.io/coredns
docker save -o etcd.tar k8s.gcr.io/etcd
docker save -o pause.tar k8s.gcr.io/pause

cd /root
tar -czf kubeadm-basic.images.tar.gz ./kubeadm-basic.images

scp kubeadm-basic.images.tar.gz root@k8s-node01:/root/


```

k8s-node01 节点解压


```
tar -zxvf /root/kubeadm-basic.images.tar.gz 

vim load-images.sh
```

```
#!/bin/bash

ls /root/kubeadm-basic.images > /tmp/image-list.txt

cd /root/kubeadm-basic.images

for i in $( cat /tmp/image-list.txt)
do
	docker load -i $i
done

rm -rf /tmp/image-list.txt

```


```
chmod a+x load-images.sh

 ./load-images.sh 

```


部署网络

```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

或者 

wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

kubectl create -f kube-flannel.yml

```

节点加入

```
 kubeadm join 192.168.66.10:6443 --token abcdef.0123456789abcdef     --discovery-token-ca-cert-hash sha256:e68a39c25a87a9cbcd99013ffdbe2584f78c1191a58dec6f1f48234fead4c570
```

备份位置

```
mv install-k8s/ /usr/local/
```


查看状态

```

kubectl get nodes
kubectl get node

kubectl get pod -n kube-system -o wide
 
kubectl describe pod kube-flannel-ds-amd64-n72ww -n kube-system

kubectl log -f kube-flannel-ds-amd64-n72ww -n kube-system
```

如果是拉去docker 镜像出错则 执行 docker pull 手动拉去(前提是能上外网, 可用拉取后导入)

```
docker pull quay.io/coreos/flannel:v0.11.0-amd64

```

linux 常见目录及其说明

```
/bin
存放二进制可执行文件(ls,cat,mkdir等)，常用命令一般都在这里。

/etc
存放系统管理和配置文件

/home
存放所有用户文件的根目录，是用户主目录的基点，比如用户user的主目录就是/home/user，可以用~user表示

/usr
用于存放系统应用程序，比较重要的目录/usr/local 本地系统管理员软件安装目录（安装系统级的应用）。这是最庞大的目录，要用到的应用程序和文件几乎都在这个目录。

/usr/x11r6 存放x window的目录
/usr/bin 众多的应用程序  
/usr/sbin 超级用户的一些管理程序  
/usr/doc linux文档  
/usr/include linux下开发和编译应用程序所需要的头文件  
/usr/lib 常用的动态链接库和软件包的配置文件  
/usr/man 帮助文档  
/usr/src 源代码，linux内核的源代码就放在/usr/src/linux里  
/usr/local/bin 本地增加的命令  
/usr/local/lib 本地增加的库

/opt
额外安装的可选应用程序包所放置的位置。一般情况下，我们可以把tomcat等都安装到这里。

/proc
虚拟文件系统目录，是系统内存的映射。可直接访问这个目录来获取系统信息。

/root
超级用户（系统管理员）的主目录（特权阶级^o^）

/sbin
存放二进制可执行文件，只有root才能访问。这里存放的是系统管理员使用的系统级别的管理命令和程序。如ifconfig等。

/dev
用于存放设备文件。

/mnt
系统管理员安装临时文件系统的安装点，系统提供这个目录是让用户临时挂载其他的文件系统。

/boot
存放用于系统引导时使用的各种文件

/lib
存放跟文件系统中的程序运行所需要的共享库及内核模块。共享库又叫动态链接共享库，作用类似windows里的.dll文件，存放了根文件系统程序运行所需的共享文件。

/tmp
用于存放各种临时文件，是公用的临时文件存储点。

/var
用于存放运行时需要改变数据的文件，也是某些大文件的溢出区，比方说各种服务的日志文件（系统启动日志等。）等。

/lost+found
这个目录平时是空的，系统非正常关机而留下“无家可归”的文件（windows下叫什么.chk）就在这里
```



