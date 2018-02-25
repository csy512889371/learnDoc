# linux环境搭建
包含内容：

>* linux安装
>* 常用命令
>* Docker安装配置
>* mysql_percona安装
>* percona PMM 监控
>* redis安装
>* active MQ安装
>* tomcat7 安装
>* zookeeper 安装

## linux 安装介绍

### 工具
http://mirrors.cn99.com/centos/7/isos/x86_64/

![image](https://github.com/csy512889371/reactLearn/blob/master/img/tools/linux0.png)

![image](https://github.com/csy512889371/reactLearn/blob/master/img/tools/linux1.png)


|项目|描述|
| --------   | :--------------------  |
|Centos 版本|http://mirrors.cn99.com/centos/7/isos/x86_64/|
|Vm 版本|12|
|客户端|Xshell 5|
|虚拟机安装路径|虚拟机安装路径|
|登录帐号|nick|
|密码|123456|
|ip|192.168.14.128|

### 参考文档


|项目|描述|
| -------   | :----------------------  |
|在Centos7上安装 Percona 5.7|http://blog.csdn.net/wylfengyujiancheng/article/details/51334875 |
|percona5.7 源码安装|http://www.cnblogs.com/chenmh/p/5738209.html |


## 常用命令

### 基础命令

|项目|描述|
| -------   | :----------------------  |
|	查看ip	|	Ifconfig -a	|
|	Centos的yum源更换为国内的阿里云源	|		|
|	Vi 查找	|	命令模式下输入“/字符串”，例如“/Section 3”。	|
|	查看监听端口	|	# netstat -lntp	|



配置静态ip

```shell
# cd /etc/sysconfig/network-scripts
# vi ifcfg-ens33

```

```shell
TYPE=Ethernet
BOOTPROTO=static
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
HWADDR="00:0C:29:F2:0F:56"
NAME=ens33
DEVICE=ens33
ONBOOT=yes
IPADDR=192.168.1.188
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=192.168.1.1

```

```shell
# cd /etc/udev/rules.d/
# rm -f 70-persistent-ipoib.rules

```

```shell
# systemctl stop NetworkManager
# systemctl disable NetworkManager
重新启动网络：
# systemctl start network.service
```

## 安装percona

下载地址
>* http://repo.percona.com/centos/7/os/x86_64/ 
>* Percona-Server-server-57-5.7.19-17.1.el7.x86_64.rpm

安装数据库源
```shell
#  yum install http://www.percona.com/downloads/percona-release/
redhat/0.1-3/percona-release-0.1-3.noarch.rpm

https://www.percona.com/downloads/percona-release/redhat/
```

### 安装Percona 5.7


> 查看默认启动的服务
```shell
# systemctl list-unit-files|grep enabled
```
> 查看监听端口
```shell
# netstat -lntp
```

> 启动数据库并设置开机启动

```shell
# service mysqld restart 
#systemctl start  mysqld.service
```

> 获取默认密码

```shell
# cat /var/log/mysqld.log  | grep "A temporary password" | awk -F " " '{print$11}'
```
> 访问mysql

```shell
mysql -uroot -pQzc%ooeze8.u
```

### Percona 5.7安装完默认会产生个随机的密码，存在日志中。

> 设置密码
```shell
SET PASSWORD = PASSWORD('Csy@123456');
```
> 授予root远程连接权限

```shell
默认root只运行本地访问
use mysql
select user,host from user where user='root';
授予root远程连接权限，生产环境慎用
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'Csy@123456' WITH GRANT OPTION;

```

### CentOS 7.0默认使用的是firewall作为防火墙，这里改为iptables防火墙。

> 1、关闭firewall：
```shell
systemctl stop firewalld.service
systemctl disable firewalld.service
systemctl mask firewalld.service
```
> 2、安装iptables防火墙
```shell
yum install iptables-services -y
```
> 3.启动设置防火墙
```shell

# systemctl enable iptables
# systemctl start iptables
```
> 4.查看防火墙状态
```shell
systemctl status iptables
```
> 5编辑防火墙，增加端口
```shell
vi /etc/sysconfig/iptables #编辑防火墙配置文件
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT
:wq! #保存退出
```
> 3.重启配置，重启系统
```shell
systemctl restart iptables.service #重启防火墙使配置生效
systemctl enable iptables.service #设置防火墙开机启动
```

## Docker安装


### Docker参考文档


从入门到实践 
>* https://yeasy.gitbooks.io/docker_practice/content/image/rmi.html

CentOS 7.2部署Percona Monitoring and Management

>* http://www.linuxidc.com/Linux/2017-02/141015.htm

配置 Docker 加速器
>* 注册DaoCloud 网址：https://dashboard.daocloud.io/

Docker 容器使用
>* http://www.runoob.com/docker/docker-container-usage.html

查看Docker的底层信息

>* docker inspect 07cb215742fd
停止应用容器
>* docker stop 07cb215742fd

查找镜像
>* https://hub.docker.com/

高效应用开发

>* https://m.aliyun.com/yunqi/wenzhang/tag/tagid_20917

云茜社区
>* https://yq.aliyun.com/

Docker常用命令
>* http://blog.csdn.net/zhang__jiayu/article/details/42611469

### 配置 Docker CE

卸载旧版本

```shell
$ sudo yum remove docker \
                  docker-common \
                  docker-selinux \
                  docker-engine

```

> 执行以下命令安装依赖包：

```shell
$ sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```
> 国内源

```shell
$ sudo yum-config-manager \
    --add-repo \
    https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

```

> 如果需要最新版本的 Docker CE 请使用以下命令：

```shell
$ sudo yum-config-manager --enable docker-ce-edge
$ sudo yum-config-manager --enable docker-ce-test

```
> 安装 Docker CE

```shell
> 更新 yum 软件源缓存，并安装 docker-ce。

$ sudo yum makecache fast
$ sudo yum install docker-ce

```

> 使用脚本自动安装

```shell
$ curl -fsSL get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh --mirror Aliyun
执行这个命令后，脚本就会自动的将一切准备工作做好，并且把 Docker CE 的 edge 版本安装在系统中。

```
> 启动 Docker CE

```shell
$ sudo systemctl enable docker
$ sudo systemctl start docker

```

>* 建立 docker 用户组


```shell
默认情况下，docker 命令会使用 Unix socket 与 Docker 引擎通讯。而只有 root 用户和 docker 组的用户才可以访问 Docker 引擎的 Unix socket。出于安全考虑，一般 Linux 系统上不会直接使用 root 用户。因此，更好地做法是将需要使用 docker 的用户加入 docker 用户组。

建立 docker 组：

$ sudo groupadd docker
将当前用户加入 docker 组：

$ sudo usermod -aG docker $USER

```

> 镜像加速
```shell
对于使用 systemd 的系统，用 systemctl enable docker 启用服务后，编辑 /etc/systemd/system/multi-user.target.wants/docker.service 文件，找到 ExecStart= 这一行，在这行最后添加加速器地址 --registry-mirror=<加速器地址>，如：

ExecStart=/usr/bin/dockerd --registry-mirror=https://jxus37ad.mirror.aliyuncs.com
注：对于 1.12 以前的版本，dockerd 换成 docker daemon。

重新加载配置并且重新启动。

$ sudo systemctl daemon-reload
$ sudo systemctl restart docker

```

> 信息版本

```shell
# docker version
```
> 查看信息

```shell
# docker info
```

> 查看我们正在运行的容器
```shell
# docker ps -a
```

> 查看映射端口
```shell
docker port pmm-server
```

> 查看应用进程日志

```shell
docker logs -f pmm-server
```
> 查看应用进程

```shell
docker top pmm-server
```

> 重启
```shell
docker start pmm-server
```
> 停止

```shell
docker stop pmm-server
```
> 我们可以使用 docker rm 命令来删除不需要的容器

```shell
docker rm pmm-server
```
> 列出镜像列表

```shell
docker images

REPOSTITORY：表示镜像的仓库源
TAG：镜像的标签
IMAGE ID：镜像ID
CREATED：镜像创建时间
SIZE：镜像大小

```


> 查询出Pid
```shell
docker inspect --format "{{ .State.Pid}}" <container-id>

```
> 然后通过得到的Pid执行
```shell
nsenter --target 6537 --mount --uts --ipc --net --pid
```
> 输出日志

```shell
Docker logs –f container
```

> 进入具体的容器

```shell
Docker exec –it container /bin/bash
```

> 退出容器

```shell
exit
```

## 安装percona PMM 监控

MySQL性能监控软件：慢查询分析利器
>* http://www.sohu.com/a/160166744_505802

Percona监控工具初探
>* http://blog.csdn.net/woshiaotian/article/details/53304408


### 配置

> 安装

```shell
#docker pull percona/pmm-server:1.1.3
```
> 创建PMM 数据容器
```shell
docker create \
 -v /opt/prometheus/data \
 -v /opt/consul-data \
 -v /var/lib/mysql \
 -v /var/lib/grafana \
 --name pmm-data \
 percona/pmm-server:1.1.3 /bin/true

```

> 运行PMM server容器

```shell
docker run -d \
 -p 80:80 \
 --volumes-from pmm-data \
 --name pmm-server \
 --restart always \
 percona/pmm-server:1.1.3

```

> 参数说明

```shell
docker: Docker 的二进制执行文件。
run:与前面的 docker 组合来运行一个容器。
-d:让容器在后台运行。
-P:将容器内部使用的网络端口映射到我们使用的主机上。
percona/pmm-server:1.1.3指定要运行的镜像，Docker首先从本地主机上查找镜像是否存在，如果不存在，Docker 就会从镜像仓库 Docker Hub 下载公共镜像。

```
> 安装PMM客户端
```shell
sudo yum install pmm-client

pmm-admin config --server 127.0.0.1
```

> 配置MySQL监控：

```shell
sudo pmm-admin add mysql --user root --password Csy@123456 --host 127.0.0.1 --port 3306
```

> PMM Landing page
```shell
http://192.168.1.188/
```

> Query AnalytiCs(QAN web app)

```shell
http://192.168.1.188/qan/
http://192.168.1.188/graph/

```

> Metrics Manitor(Grafana)

```shell
User name: admin
Password:admin

```
> Orchestrator

```shell
http://192.168.1.188/orchestrator
```

## 安装redis


### 文档

docker安装redis 指定配置文件且设置了密码

>* http://www.cnblogs.com/cgpei/p/7151612.html

Redis 社区

>* http://www.redis.cn/download.html

Redis conf 配置详解
>* http://blog.csdn.net/neubuffer/article/details/17003909

### Redis config 配置

daemonize  no

>* 默认情况下，redis 不是在后台运行的，如果需要在后台运行，把该项的值更改为yes。


pidfile  /var/run/redis.pid

>* 当Redis 在后台运行的时候，Redis 默认会把pid 文件放在/var/run/redis.pid，你可以配置到其他地址。当运行多个redis 服务时，需要指定不同的pid 文件和端口

port 

>* 监听端口，默认为6379

#bind 127.0.0.1
>* 指定Redis 只接收来自于该IP 地址的请求，如果不进行设置，那么将处理所有请求，在生产环境中为了安全最好设置该项。默认注释掉，不开启

### 配置


获取最新redis镜像
>* docker pull redis:latest

创建目录

```shell
mkdir /data
mkdir /etc/redis

```

启动redis

```shell

第一种方式.
sudo docker run -t -i redis:latest
-i：标准输入给容器    -t：分配一个虚拟终端
第二种.后台运行
docker run --name redis4.0.1 -p 7001:6379 -d redis:latest redis-server --appendonly yes
第三种方式：
docker run -p 7001:6379 --name redis4.0.1 \
 --restart always \
 -v $PWD/redis.conf:/etc/redis/redis.conf -v $PWD/data:/data -d \
 redis:latest redis-server /etc/redis/redis.conf --appendonly yes

```
进入容器

```shell
PID=$(docker inspect --format "{{ .State.Pid }}" <container>)
nsenter --target $PID --mount --uts --ipc --net --pid

```

redis-cli就可以连上redis了
```shell
Redis-cli
```


输出日志

```shell
Docker logs –f container
```

## 安装active MQ

### 文档

ActiveMQ此例简单介绍基于docker的activemq安装与集群搭建

>* http://blog.csdn.net/metar_he/article/details/56674598

后台访问
>* http://192.168.1.189:8161/admin/send.jsp

### 配置

下载
```shell
docker pull webcenter/activemq
```

配置

```shell

docker run --name activemq -p 61616:61616 -p 8161:8161 -e ACTIVEMQ_ADMIN_LOGIN=admin -e ACTIVEMQ_ADMIN_PASSWORD=123 --restart=always -d webcenter/activemq
```


## 安装tomcat 7

Docker 仓库搜索
>*  docker search tomcat

拉取Docker Hub里的镜像

>* docker pull tomcat:8

>* 可以看到，星数最高的是官方的tomcat，有关官方tomcat的镜像可以访问 https://hub.docker.com/r/library/tomcat/

>* 运行我们的web应用.假设我们应用是www,目录位置在/app/deploy/shjtweb

```shell
#docker run --privileged=true --name shjtweb --restart always -v /app/deploy/shjtweb:/usr/local/tomcat/webapps/ROOT  -d -p 8080:8080 tomcat:8
```
解压
>* unzip jtiism-uwp-web.rar

停止容器
```shell
# 停止一个容器
docker stop shjtweb

```

启动容器
```shell
# 停止一个容器
docker start shjtweb

```

## 安装zookeeper
Docker 仓库搜索

> https://hub.docker.com/explore/


