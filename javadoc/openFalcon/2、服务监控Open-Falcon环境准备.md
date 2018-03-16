# 服务监控Open-Falcon环境准备


## 一、安装redis

大家可以yum安装，也可以下载源码安装。

```shell
yum install -y redis
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon1/1.png)

修改配置redis.conf

```shell
vi /etc/redis.conf
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon1/2.png)


```shell
启动redis：redis-server &
```

## 二、	安装mysql

```shell
yum install -y mysql-server
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon1/3.png)


```shell
启动mysql：service mysqld start
查看mysql状态：service mysqld status
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon1/4.png)

# 三、初始化mysql数据库表

数据默认没有设置密码，执行的时候出现输入密码，直接回车。

```shell
cd /tmp/ && git clone https://github.com/open-falcon/falcon-plus.git 
cd /tmp/falcon-plus/scripts/mysql/db_schema/
mysql -h 127.0.0.1 -u root -p < 1_uic-db-schema.sql
mysql -h 127.0.0.1 -u root -p < 2_portal-db-schema.sql
mysql -h 127.0.0.1 -u root -p < 3_dashboard-db-schema.sql
mysql -h 127.0.0.1 -u root -p < 4_graph-db-schema.sql
mysql -h 127.0.0.1 -u root -p < 5_alarms-db-schema.sql
rm -rf /tmp/falcon-plus/
```

设置mysql的root用户密码：

```shell
mysql –u root
```

查看mysql用户和密码

```shell
select user,host,password from mysql.user;
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon1/5.png)


发现查询密码都是空，然后开始设置root的密码为bigdata

```shell
mysql> set password for root@localhost=password('bigdata');

退出：mysql>exit
```


## 四、下载编译后的二进制包
```shell
cd /data/program/software
wget https://github.com/open-falcon/falcon-plus/releases/download/v0.2.1/open-falcon-v0.2.1.tar.gz
```



