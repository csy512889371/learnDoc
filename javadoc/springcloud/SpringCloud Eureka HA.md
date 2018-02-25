# Spring Cloud Eureka HA 高可用


* 依赖eureka-server
* 依赖security需要用户名和密码登录

```java
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-eureka-server</artifactId>
		</dependency>
		
		<!-- <dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-security</artifactId>
		</dependency> -->

```

## 配置文件

* 配置节点三个节点 peer1 peer2 peer3 
* 配置eureka.client.serviceUrl.defaultZone 多个节点之间需要相互注册
* 可以修改eureka.dashboard.enabled = false 来禁用之中某些节点的后台

```java
spring:
  application:
    name: EUREKA-HA
---
server:
  port: 8761
spring:
  profiles: peer1
eureka:
  instance:
    hostname: peer1
  client:
    serviceUrl:
      defaultZone: http://peer2:8762/eureka/,http://peer3:8763/eureka/
---
server:
  port: 8762
spring:
  profiles: peer2
eureka:
  instance:
    hostname: peer2
  client:
    serviceUrl:
      defaultZone: http://peer1:8761/eureka/,http://peer3:8763/eureka/
---
server:
  port: 8763
spring:
  profiles: peer3
eureka:
  instance:
    hostname: peer3
  client:
    serviceUrl:
      defaultZone: http://peer1:8761/eureka/,http://peer2:8762/eureka/
```



