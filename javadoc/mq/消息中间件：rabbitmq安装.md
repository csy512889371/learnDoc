# 消息中间件：rabbitmq安装

## 一、	安装Erlang

### 1、下载Erlang

```shell
wget  http://erlang.org/download/otp_src_17.0.tar.gz
```
### 2、 解压

```shell
tar -zxvf otp_src_17.0.tar.gz
```

### 3、 安装Erlang编译环境

```shell
yum -y install make ncurses-devel gcc gcc-c++ unixODBC unixODBC-devel openssl openssl-devel
```

### 4、 编译安装Erlang
```shell
cd otp_src_17.0
```
配置：

```shell
./configure  --prefix=/usr/local/erlang   --enable-smp-support   --enable-threads   --enable-sctp  --enable-kernel-poll    --enable-hipe  --with-ssl
```

参数说明：

* --prefix  指定安装目录
* --enable-smp-support启用对称多处理支持（Symmetric Multi-Processing对称多处理结构的简称）
* --enable-threads启用异步线程支持
* --enable-sctp启用流控制协议支持（Stream Control Transmission Protocol，流控制传输协议）
* --enable-kernel-poll启用Linux内核poll
* --enable-hipe启用高性能Erlang（High Performance Erlang）
* --with-ssl使用SSL包

编译和安装：
```java
make && make install
```

### 5、设置环境变量

```java
vi /etc/profile 
ERL_HOME=/usr/local/erlang  
PATH=$ERL_HOME/bin:$PATH  
export ERL_HOME PATH  
```

使配置生效：source /etc/profile


## 二、安装rabbitmq

### 1、下载rabbigmq

```java
wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.0/rabbitmq-server-3.6.0-1.noarch.rpm
```

### 2、	安装
```java
rpm -i --nodeps rabbitmq-server-3.6.0-1.noarch.rpm
```

### 3、	启动
```java
service rabbitmq-server start 
```

出现的错误以及解决办法如下

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mq/rabbitmq1.png)

常用的几个命令:

* service rabbitmq-server start  启动服务  
* service rabbitmq-server etc   查看哪些命令可以使用  
* service rabbitmq-server stop  停止服务  
* service rabbitmq-server status查看服务状态  


## 三、开启界面访问rabbitmq
* 执行：/usr/sbin/rabbitmq-plugins enable rabbitmq_management 添加可视化插件
* 页面访问：http://10.211.55.9:15672/

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mq/rabbitmq2.png)


添加访问账号和密码：

* rabbitmqctl add_user mytest mytest
* rabbitmqctl set_user_tags mytest administrator
* rabbitmqctl set_permissions -p / mytest '.*' '.*' '.*'
* rabbitmqctl list_permissions



