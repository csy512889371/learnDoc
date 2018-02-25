# Spring Cloud 配置中心 认证和高可用

* 配置中心认证
* 配置中心高可用

## 一、配置中心认证

### config server

> pom.xml 增加 security 安全认证

```xml
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-config-server</artifactId>
		</dependency>
		
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-security</artifactId>
		</dependency>
```

> application.yml 配置配置中心的帐号密码
```xml
security:
  basic:
    enabled: true
  user:
    name: user
    password: password123
server:
  port: 8080

```

### config client 客户端

> pom.xml 增加对config client 的依赖

```xml
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-config</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>
```

> bootstrap.yml 配置 config server的地址
> username: config  server 的用户名
> password: config  server 的password
```xml
spring:
  cloud:
    config:
      uri: http://localhost:8080  # curl style
      username: user
      password: password123
      profile: dev
      label: master   # 当configserver的后端存储是Git时，默认就是master 
  application:
    name: foobar
```


## 二、配置中心与eureka结合

### config server 配置中心服务端

> pom.xml 增加对eureka client 的依赖

```xml
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-config-server</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-eureka</artifactId>
		</dependency>
```

> application.yml 
* spring.application.name 配置应用名称
* eureka.client.serviceUrl.defaultZone 配置eureka 服务器地址

```xml
server:
  port: 8080
spring:
  application:
    name: microservice-config-server-eureka

eureka:
  client:
    serviceUrl:
      defaultZone: http://user:password123@localhost:8761/eureka
  instance:
    prefer-ip-address: true
```


> 应用入口
* @EnableDiscoveryClient 激活eureka客户端

```java

@SpringBootApplication
@EnableConfigServer
@EnableDiscoveryClient
public class ConfigServerApplication {
  public static void main(String[] args) {
    SpringApplication.run(ConfigServerApplication.class, args);
  }
}
```

### config client 配置中心客户端

> pom.xml 增加eureka clent的依赖和 端点的依赖

```xml
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-eureka</artifactId>
		</dependency>
		
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-actuator</artifactId>
		</dependency>

```


> bootstrap.yml 配置eureka 服务器的地址

```xml
eureka:
  client:
    serviceUrl:
      defaultZone: http://user:password123@localhost:8761/eureka
  instance:
    prefer-ip-address: true
```

> 应用入口类
* @EnableDiscoveryClient 激活 Eureka客户端

```java
@SpringBootApplication
@EnableDiscoveryClient
public class ConfigServerApplication {
  public static void main(String[] args) {
    SpringApplication.run(ConfigServerApplication.class, args);
  }
}
```






