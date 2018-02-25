# 生产环境搭建二
>* 安装数据库mysql percona 5.7


# 安装percona 5.7

>* 首先，你需要设置Percona的Yum库:
```shell
yum install http://www.percona.com/downloads/percona-release/redhat/0.1-4/percona-release-0.1-4.noarch.rpm
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/mysql/mysql1.png)

>* 接下来安装Percona:
```shell
yum install Percona-Server-client-57 Percona-Server-server-57
```
>* 上面的命令安装Percona的服务器和客户端、共享库，可能需要Perl和Perl模块，以及其他依赖的需要，如DBI::MySQL

```shell
wget -r -l 1 -nd -A rpm -R "*devel*,*debuginfo*" \
https://www.percona.com/downloads/Percona-Server-LATEST/Percona-Server-5.7.20-18/binary/redhat/7/x86_64/

使用rpm工具，一次性安装所有的rpm包：

rpm -ivh Percona-Server-server-57-5.7.20-18.1.el7.x86_64.rpm \
Percona-Server-client-57-5.7.20-18.1.el7.x86_64.rpm \
Percona-Server-shared-57-5.7.20-18.1.el7.x86_64.rpm

```

## 查看默认启动的服务

```shell
# systemctl list-unit-files|grep enabled
查看监听端口
# netstat -lntp

```
![image](https://github.com/csy512889371/learnDoc/blob/master/image/mysql/mysql2.png)

>* 启动数据库并设置开机启动
```shell
# service mysqld restart 
#systemctl start  mysqld.service

```

>* 获取默认密码
```shell
# cat /var/log/mysqld.log  | grep "A temporary password" | awk -F " " '{print$11}'

访问mysql
# mysql -uroot -pQzc%ooeze8.u

设置密码
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

##  CentOS 7.0默认使用的是firewall作为防火墙，这里改为iptables防火墙。

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
-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 3306 -j ACCEPT
:wq! #保存退出

3.重启配置，重启系统
systemctl restart iptables.service #重启防火墙使配置生效
systemctl enable iptables.service #设置防火墙开机启动

```



