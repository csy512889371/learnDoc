# zookeeper 集群安装

dubbo集群部署安装依赖于zookeeper，所以我们下面重点安装zookeeper集群

## 一、准备三台机器做集群
* 服务器	IP地址	端口
* 服务器1	192.168.0.7	2181/2881/3881
* 服务器2	192.168.0.8	2181/2881/3881
* 服务器3	192.168.0.9	2181/2881/3881
## 二、配置

### 1、配置java环境

* 将jdk-8u141-linux-x64.tar.gz上传到三台服务器安装配置。
* 解压到/data/program/software/
* 并将文件夹重命名为java8
* 配置jdk全局变量。

```shell
#vi /etc/profile
export JAVA_HOME=/data/program/software/java8
export JRE_HOME=/data/program/software/java8/jre
export CLASSPATH=.:$CLASSPATH:$JAVA_HOME/lib:$JRE_HOME/lib 
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin

```

### 2、修改操作系统的/etc/hosts文件，添加IP与主机名映射

```shell
# zookeeper cluster servers
192.168.0.7 bigdata1
192.168.0.8 bigdata2
192.168.0.9 bigdata3
```

### 3下载zookeeper-3.4.9.tar.gz 到/data/program/software/目录
```shell
# wget http://mirror.bit.edu.cn/apache/zookeeper/zookeeper-3.4.9/zookeeper-3.4.9.tar.gz
```

### 4 解压zookeeper安装包，并对节点重民名

```shell
#tar -zxvf zookeeper-3.4.9.tar.gz
服务器1：
#mv zookeeper-3.4.9 zookeeper
服务器2：
#mv zookeeper-3.4.9 zookeeper
服务器3：
#mv zookeeper-3.4.9 zookeeper
```
### 5、在zookeeper的各个节点下 创建数据和日志目录

```shell

#cd zookeeper
#mkdir data
#mkdir logs

```

### 6、重命名配置文件
将zookeeper/conf目录下的zoo_sample.cfg文件拷贝一份，命名为zoo.cfg:
```shell
#cp zoo_sample.cfg zoo.cfg
```


修改zoo.cfg 配置文件

```shell

clientPort=2181
dataDir=/data/program/software/zookeeper/data
dataLogDir=/data/program/software/zookeeper/logs

server.1=bigdata1:2881:3881
server.2=bigdata2:2881:3881
server.3=bigdata3:2881:3881

```


> tickTime=2000

tickTime这个时间是作为Zookeeper服务器之间或客户端与服务器之间维持心跳的时间间隔,也就是每个tickTime时间就会发送一个心跳。

> initLimit=10

initLimit这个配置项是用来配置Zookeeper接受客户端（这里所说的客户端不是用户连接Zookeeper服务器的客户端,而是Zookeeper服务器集群中连接到Leader的Follower 服务器）初始化连接时最长能忍受多少个心跳时间间隔数。当已经超过10个心跳的时间（也就是tickTime）长度后Zookeeper 服务器还没有收到客户端的返回信息,那么表明这个客户端连接失败。总的时间长度就是10*2000=20 秒。

> syncLimit=5

syncLimit这个配置项标识Leader与Follower之间发送消息,请求和应答时间长度,最长不能超过多少个tickTime的时间长度,总的时间长度就是5*2000=10秒。

> dataDir=/data/program/software/zookeeper/data 

dataDir顾名思义就是Zookeeper保存数据的目录,默认情况下Zookeeper将写数据的日志文件也保存在这个目录里。

> clientPort=2181

clientPort这个端口就是客户端（应用程序）连接Zookeeper服务器的端口,Zookeeper会监听这个端口接受客户端的访问请求。

>* server.A=B：C：D
>* server.1=bigdata1:2881:3881
>* server.2=bigdata2:2881:3881
>* server.3=bigdata3:2881:3881


>* A是一个数字,表示这个是第几号服务器；
>* B是这个服务器的IP地址（或者是与IP地址做了映射的主机名）；
>* C第一个端口用来集群成员的信息交换,表示这个服务器与集群中的Leader服务器交换信息的端口；
>* D是在leader挂掉时专门用来进行选举leader所用的端口。


注意：如果是伪集群的配置方式，不同的 Zookeeper 实例通信端口号不能一样，所以要给它们分配不同的端口号。


### 8、创建myid文件

* 在dataDir= dataDir=/data/program/software/zookeeper/data 下创建myid文件
* 编辑myid文件，并在对应的IP的机器上输入对应的编号。如在1上，myid文件内容就是1, 2上就是2， 3上就是3： 
```shell
#vi /myid## 值为1
#vi /myid## 值为2
#vi /myid## 值为3
```


### 9、启动测试zookeeper

1) 进入/bin目录下执行：
```shell

# /zkServer.sh start
# /zkServer.sh start
# /zkServer.sh start
```

2) 输入jps命令查看进程

```shell
# jps

QuorumPeerMain
Jps
```
其中，QuorumPeerMain是zookeeper进程，说明启动正常

3) 查看状态

```shell
# /zkServer.sh status
```

4) 查看zookeeper服务输出信息：

由于服务信息输出文件在/bin/zookeeper.out
```shell
$ tail -500 f zookeeper.out
```


