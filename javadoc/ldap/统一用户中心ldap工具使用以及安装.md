# 统一用户中心ldap工具使用以及安装

* 选择服务器：192.168.0.8

# 一、安装OpenLDAP

## 1、安装

```shell
yum -y install openldap openldap-servers openldap-clients openldap-devel compat-openldap
```

安装完之后查看自动创建了ldap用户：
```shell
[root@bigdata2 ~]# tail -n 1 /etc/passwd
ldap:x:55:55:LDAP User:/var/lib/ldap:/sbin/nologin
```


查看安装了哪些包:
```shell
[root@bigdata2 ~]# rpm -qa |grep openldap
openldap-2.4.40-16.el6.x86_64
openldap-devel-2.4.40-16.el6.x86_64
compat-openldap-2.3.43-2.el6.x86_64
openldap-clients-2.4.40-16.el6.x86_64
openldap-servers-2.4.40-16.el6.x86_64
```

## 2、介绍ldap相关配置文件信息

* /etc/openldap/slapd.conf：OpenLDAP的主配置文件，记录根域信息，管理员名称，密码，日志，权限等
* /etc/openldap/slapd.d/*：这下面是/etc/openldap/slapd.conf配置信息生成的文件，每修改一次配置信息， 这里的东西就要重新生成
* /etc/openldap/schema/*：OpenLDAP的schema存放的地方
* /var/lib/ldap/*：OpenLDAP的数据文件
* /usr/share/openldap-servers/slapd.conf.obsolete 模板配置文件
* /usr/share/openldap-servers/DB_CONFIG.example 模板数据库配置文件

OpenLDAP监听的端口：
* 默认监听端口：389（明文数据传输）
* 加密监听端口：636（密文数据传输）

## 3、初始化配置信息

```shell
[root@bigdata2 ldap]#  cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
[root@bigdata2 ldap]#  cp /usr/share/openldap-servers/slapd.conf.obsolete /etc/openldap/slapd.conf
```


## 4、修改配置文件
直接运行slappasswd命令（密码我输入的是123456）

```shell
[root@bigdata2 ldap]# slappasswd
New password: 
Re-enter new password: 
{SSHA}L7pAtZ6Dn37Oh0nR8KkuZZeuKnUVQrR3

```

将生成的秘钥拷贝到/etc/openldap/slapd.conf，rootpwd和秘钥之间用tab键隔开

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/ldap/1.png)

接着修改如下：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/ldap/2.png)
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/ldap/3.png)


启动LDAP的slapd服务，并设置自启动

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/ldap/4.png)

赋予配置目录相应的权限：
```shell
[root@bigdata2 slapd.d]# chown -R ldap:ldap /var/lib/ldap
[root@bigdata2 slapd.d]# chown -R ldap:ldap /etc/openldap/
```

测试配置文件是否有错误：
```shell
[root@bigdata2 slapd.d]# slaptest -f /etc/openldap/slapd.conf
config file testing succeeded
```

删除最先的配置文件生成的信息：
```shell
[root@bigdata2 slapd.d]# rm -rf /etc/openldap/slapd.d/*
```


重新生成配置文件：
```shell
[root@bigdata2 slapd.d]# slaptest -f /etc/openldap/slapd.conf -F /etc/openldap/slapd.d/
config file testing succeeded
```


查看是否生成的是自己修改的配置文件信息：
```shell
cat /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}bdb.ldif
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/ldap/5.png)

授权新配置文件：
```shell
[root@bigdata2 slapd.d]# chown -R ldap.ldap /etc/openldap/slapd.d/
```

重启：
```shell
       [root@bigdata2 slapd.d]# service slapd restart
       Stopping slapd:                                            [  OK  ]
       Starting slapd:                                            [  OK  ]
```
       
安装完成！


## 二、安装PhpLDAPAdmin

* 1、安装PhpLDAPAdmin
```shell
yum install -y phpldapadmin
```

* 2、	修改phpldapadmin的配置文件
```shell
vim /etc/httpd/conf.d/phpldapadmin.conf
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/ldap/6.png)

```shell
vim /etc/phpldapadmin/config.php
```

将如下第一个注释去掉，第二加上注释：
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/ldap/7.png)

重启服务：
```shell
/etc/init.d/httpd restart
```
访问如下：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/ldap/8.png)

* 这样是登录不了的，需要做如下配置：
* 服务器随便找个目录然后执行：vi root.ldif
```shell
dn: dc=service,dc=com
objectclass: dcObject
objectclass: organization
o: Yunzhi,Inc.
dc: service

dn: cn=xxxx,dc=service,dc=com
objectclass: organizationalRole
```


然后执行如下命令：
```shell
ldapadd -x -D "cn=xxxx,dc=service,dc=com" -W -f root.ldif
```
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/ldap/9.png)


* 然后再去登录服务器：
* 账号：cn=xxxx,dc=service,dc=com
* 密码：123456

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/ldap/10.png)

