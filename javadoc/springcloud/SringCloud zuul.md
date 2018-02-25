# SpringCloud zuul 集成

## 配置zuul

> pom.xml 配置依赖

* 引入 zuul
* 引入eureka客户端


```java
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-zuul</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-eureka</artifactId>
		</dependency>

```

> 配置应用路口
> EnableZuulProxy 是组合注解 已经包含 euraka客户端。

```java
@SpringBootApplication
@EnableZuulProxy
public class ZuulApplication {
  public static void main(String[] args) {
    SpringApplication.run(ZuulApplication.class, args);
  }
}
```

> 配置文件
```java

eureka:
  client:
    service-url:
      defaultZone: http://user:password123@localhost:8761/eureka
  instance:
    prefer-ip-address: true
hystrix.command.default.execution.isolation.thread.timeoutInMilliseconds: 60000
ribbon:
  ConnectTimeout: 3000
  ReadTimeout: 60000
```

> 访问注册的应用

* microservice-consumer-movie-feign-with-hystrix 为其中反向代理的应用的application name

```java
http://localhost:8040/microservice-consumer-movie-feign-with-hystrix/movie/1
```

## 配置说明

### 一
* zuul.routes 下可以给指定的微服务配置别名
* zuul 默认代理euraka上的所有微服务

```xml
zuul:
  routes:
    microservice-consumer-movie-feign-with-hystrix: /user/**
```

### 二
以下配置表示只代理配置的微服务
* ignoredServices * 表示不代理所有的服务
* zuul

```xml
zuul:
  ignoredServices: '*'
  routes:
    microservice-consumer-movie-feign-with-hystrix: /user/**
```

### 三

* 为微服务取别名

```java
zuul:
  routes:
    abc:
      path: /user-path/**
      serviceId: microservice-provider-user
```

### 四

> 不实用euraka 实现负载均衡
```xml
ribbon:
  eureka:
    enabled: false
microservice-provider-user:     # 这边是ribbon要请求的微服务的serviceId
  ribbon:
    listOfServers: http://localhost:7900,http://localhost:7901
```

### 五
>实现安装版本号代理


>* zuul入口类中注入 serviceRouteMapper bean

```java
@SpringBootApplication
@EnableZuulProxy
public class ZuulApplication {
  public static void main(String[] args) {
    SpringApplication.run(ZuulApplication.class, args);
  }

  @Bean
  public PatternServiceRouteMapper serviceRouteMapper() {
    return new PatternServiceRouteMapper("(?<name>^.+)-(?<version>v.+$)", "${version}/${name}");
  }
}
```

>* 微服服务提供者的appname 中加入版本信息

```xml
server:
  application:
    name: microservice-provider-user-v1
```
>* 通过zuul访问微服务
localhost:8048/v1/movie/1

### 六

* 访问代理的微服务都加上api前缀
```xml
zuul:
  prefix: /api
```

### 七

* 微服务提供者的接口都以api开头，使用zuul代理可以不加api。做以下配置后默认加上
* 以下是全局的配置。可以配置局部
```xml
zuul:
  prefix: /api
  strip-prefix: false
```

### 八

解决zuul上传文件超时
* zuul默认使用hystrix 所以要设置hystrix超时时间
* zuul 使用ribbon 所以设置ribbon的超时时间


```java
hystrix.command.default.execution.isolation.thread.timeoutInMilliseconds: 60000
ribbon:
  ConnectTimeout: 3000
  ReadTimeout: 60000
```
增加jvm的堆内存
```xml
-Xms512M -Xmx1024M
```

>* 使用curl 上传文件
```shell
curl -F "file=@test.txt" localhost:8085/upload

```

