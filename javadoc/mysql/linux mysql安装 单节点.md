# Mysql 安装

1) yum 安装mysql
```shell
yum -y install mysql-server
```
2) 启动mysql服务
```shell
service mysqld start
```

3) 设置mysql的root用户，设置密码
```shell
mysql -u root

```

查看mysql用户和密码

```shell
select user,host,password from mysql.user;
```
发现密码都是空，然后开始设置root的密码为bigdata
```shell
mysql> set password for root@localhost=password('bigdata')
退出： mysql>exit
```

4) 用新密码登录
```shell
mysql -u root -p
```

5) 基本命令操作
```shell
show databases; //查看系统已存在的数据库
use databasesname;//选择需要使用的数据库
drop database databasename;//删除选定的数据库
exit //退出数据库的连接
create database test01;//建立名为test的数据库
show tables; //列出当前数据库下的表
```

6) 开启远程登录权限
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'IDENTIFIED BY 'bigdata' WITH GRANT OPTION;
FLUSH PRIVILEGES;





