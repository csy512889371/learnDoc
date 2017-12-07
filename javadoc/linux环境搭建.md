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
>* http://repo.percona.com/centos/7/os/x86_64/ Percona-Server-server-57-5.7.19-17.1.el7.x86_64.rpm

安装数据库源
```shell
#  yum install http://www.percona.com/downloads/percona-release/
redhat/0.1-3/percona-release-0.1-3.noarch.rpm

https://www.percona.com/downloads/percona-release/redhat/
```

安装Percona 5.7

```shell
查看默认启动的服务
# systemctl list-unit-files|grep enabled

查看监听端口
# netstat -lntp
```

启动数据库并设置开机启动

```shell
# service mysqld restart 
#systemctl start  mysqld.service
```

获取默认密码

```shell
# cat /var/log/mysqld.log  | grep "A temporary password" | awk -F " " '{print$11}'
```
访问mysql

```shell
mysql -uroot -pQzc%ooeze8.u
```

Percona 5.7安装完默认会产生个随机的密码，存在日志中。

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

> CentOS 7.0默认使用的是firewall作为防火墙，这里改为iptables防火墙。

```shell
1、关闭firewall：
systemctl stop firewalld.service
systemctl disable firewalld.service
systemctl mask firewalld.service

2、安装iptables防火墙
yum install iptables-services -y

3.启动设置防火墙

# systemctl enable iptables
# systemctl start iptables

4.查看防火墙状态

systemctl status iptables

5编辑防火墙，增加端口
vi /etc/sysconfig/iptables #编辑防火墙配置文件
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT
:wq! #保存退出

3.重启配置，重启系统
systemctl restart iptables.service #重启防火墙使配置生效
systemctl enable iptables.service #设置防火墙开机启动

```