# SpringCloud Conf 搭建配置中心

Spring Cloud Config支持在Git, SVN和本地存放配置文件，使用Git或者SVN存储库可以很好地支持版本管理，Spring默认配置是使用Git存储库。在本案例中将使用OSChina提供的Git服务存储配置文件。为了能让Config客户端准确的找到配置文件，需要了解application, profile和label的概念

* server 服务器的配置
* client 客户端的配置

# Server 端代码

### pom 依赖 config-server
```xml
	<dependencies>
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-config-server</artifactId>
		</dependency>
	</dependencies>
```

### 应用入口引入SpringBootApplication

```java

@SpringBootApplication
@EnableConfigServer
public class ConfigServerApplication {
  public static void main(String[] args) {
    SpringApplication.run(ConfigServerApplication.class, args);
  }
}

```


### 配置

配置appllication.yml 文件，设置服务器端口号和配置文件Git仓库的链接
```java
spring:
  cloud:
    config:
      server:
        git:
          uri: https://github.com/csyeva/eductoconfig
          username: 
          password: 
```

### 访问方式

```java
/{application}/{profile}[/{label}]
/{application}-{profile}.yml
/{application}-{profile}.properties
/{label}/{application}-{profile}.properties
```
* http://localhost:8080/master/application-profile.properties
* http://localhost:8080/master/userprovider-dev.yml
* http://localhost:8080/application/default/master
* http://localhost:8080/provier/dev/master
* 根据application-profile.properties 判断是否有同名的如果有则使用其配置文件。如果没有则用application.yml 


# client 客户端

### pom 依赖

```java
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-config</artifactId>
		</dependency>
```


### 配置 bootstrap.yml

在bootstrap.yml中设置客户端名称spring.application.name和Config服务器的地址

* label 当configserver的后端存储是Git时，默认就是master 
* 如果本地和远程都配置了 那么以远程为准

```java
spring:
  cloud:
    config:
      uri: http://localhost:8080
      profile: dev
      label: master
  application:
    name: provider
```

###  动态刷新配置

* 无需重新启动客户端，即可更新Spring Cloud Config管理的配置 
* 获取配置文件中的profile 的值

```java
@RestController
public class ConfigClientController {

  @Value("${profile}")
  private String profile;

  @GetMapping("/profile")
  public String getProfile() {
    return this.profile;
  }
}

```




