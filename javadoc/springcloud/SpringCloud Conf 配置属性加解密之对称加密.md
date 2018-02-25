# SpringCloud Conf 搭建配置中心二
* 加密和解密
* 对称加解密
* 非对称加解密



# 对称加解密

Spring Cloud可以在本地进行预处理的解密，需要在JVM添加JCE扩展.


## 下载JCE 安装对应的java版本

[下载地址](http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html)

* 下载后替换本地安装的jre下的文件
* 替换文件local_policy.jar 和 US_export_policy.jar。 加解密的策略文件

## 修改配置文件


> application.yml 加入encrypt.key 

```java

encrypt:
  key: ctoedu

```

## 加密和解密
```shell
# encrypt 加密
crul -X POST http://localhost:8080/encrypt -d mmmmm

# decrypt 解密

curl localhost:8888/decrypt -d 682bc583f4641835fa2db009355293665d2647dade3375c0ee201de2a49f7bda

```

## 配置文件中存储加密后的配置

> 如果是application.yml 则用引号且 前面加{cipher}

```xml

spring:
  datasource:
    username: dbuser
    password: '{cipher}FKSAJDFGYOS8F7GLHAKERGFHLSAJ'

```

> 如果是 application.properties。 不要加引号

```java
spring.datasource.username: dbuser
spring.datasource.password: {cipher}FKSAJDFGYOS8F7GLHAKERGFHLSAJ
```


# 非对称加解密

## 使用keytool生产证书

```shell
keytool -genkeypair -alias mytestkey -keyalg RSA \
  -dname "CN=Web Server,OU=Unit,O=Organization,L=City,S=State,C=US" \
  -keypass changeme -keystore server.jks -storepass letmein
```

## 将生产的证书server.jks 放到resource下

## bootstrap.yml 增加以下配置

```shell
encrypt:
  keyStore:
    location: classpath:/server.jks
    password: letmein
    alias: mytestkey
    secret: changeme
```
## 加密、解密 字符串

```shell
# encrypt 加密
crul -X POST http://localhost:8080/encrypt -d mmmmm

# decrypt 解密

curl localhost:8888/decrypt -d jkjkjkjk
```


