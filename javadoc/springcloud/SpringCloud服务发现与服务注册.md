# 服务发现与服务注册

# 服务发现的方式

## 客户端发现
> Eureka
* Eureka是Netflix开发的服务发现框架，本身是一个基于REST的服务，主要用于定位运行在AWS域中的中间层服务，以达到负载均衡和中间层服务故障转移的目的。Spring Cloud将它集成在其子项目spring-cloud-netflix中，以实现Spring Cloud的服务发现功能。
* Eureka 项目相当活跃，代码更新相当频繁，目前最新的版本是1.5.5。Eureka 2.0的版本也正在紧锣密鼓地开发中，2.0将会带来更好的扩展性，并且使用细粒度的订阅模型取代了基于拉取的模型，目前还没有Release。

> Zk 

## 服务器端发现
* Consul + nginx

# 服务发现
![image](https://github.com/csyeva/eva/blob/master/img/springcloud/fwfxx.png)

## 服务发现组件的功能
> 服务注册表
* 服务注册表是一个记录当前可用服务实例的网络信息的数据库，是服务发现机制的核心。服务注册表提供查询API和管理API，使用查询API获得可用的服务实例，使用管理API实现注册和注销；

> 服务注册
* 服务注册:服务启动时，将服务的网络地址注册到服务注册表中；


> 健康检查
* 服务发现组件会通过一些机制定时检测已注册的服务，如果发现某服务无法访问了（可能是某几个心跳周期后），就将该服务从服务注册表中移除。

# 服务发现组件：Eureka

* Eureka来自生产环境
* Spring Cloud对Eureka支持很好

## Eureka 原理

![image](https://github.com/csyeva/eva/blob/master/img/springcloud/er1.png)
![image](https://github.com/csyeva/eva/blob/master/img/springcloud/er2.png)

> 上图是来自Eureka官方的架构图，大致描述了Eureka集群的工作过程。

* Application Service 就相当于本书中的服务提供者（用户微服务），Application Client就相当于本书中的服务消费者（电影微服务）；
* Make Remote Call，可以简单理解为调用RESTful的接口；
* us-east-1c、us-east-1d等是zone，它们都属于us-east-1这个region；
 
> 由图可知，Eureka包含两个组件：Eureka Server 和 Eureka Client。
 
* Eureka Server提供服务注册服务，各个节点启动后，会在Eureka Server中进行注册，这样Eureka Server中的服务注册表中将会存储所有可用服务节点的信息，服务节点的信息可以在界面中直观的看到。
* Eureka Client是一个Java客户端，用于简化与Eureka Server的交互，客户端同时也具备一个内置的、使用轮询（round-robin）负载算法的负载均衡器。
* 在应用启动后，将会向Eureka Server发送心跳（默认周期为30秒）。如果Eureka Server在多个心跳周期内没有接收到某个节点的心跳，Eureka Server将会从服务注册表中把这个服务节点移除（默认90秒）。
* Eureka Server之间将会通过复制的方式完成数据的同步。
* Eureka还提供了客户端缓存的机制，即使所有的Eureka Server都挂掉，客户端依然可以利用缓存中的信息消费其他服务的API。
 
> 综上，Eureka通过心跳检测、健康检查、客户端缓存等机制，确保了系统的高可用性、灵活性和可伸缩性。

# 代码解析

## Eureka 服务器端

> 引入依赖

```xml
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-eureka-server</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-security</artifactId>
		</dependency>
```

> 应用入口增加EnableEurekaServer
```java
@SpringBootApplication
@EnableEurekaServer
public class EurekaApplication {
  public static void main(String[] args) {
    SpringApplication.run(EurekaApplication.class, args);
  }
}

```

> 配置文件

* security.user.name\password 登录eureka后台的帐号密码
* eureka.datacenter 设置eureka的数据中心名称
* eureka.environment 设置eureka的环境名称

```xml
# 增加用户名和密码
security:
  basic:
    enabled: true
  user:
    name: user
    password: password123
server:
  port: 8761

eureka:
  client:
    register-with-eureka: false # 单机环境设置成false
    fetch-registry: false # 单机环境设置成false
    service-url:
      defaultZone: http://user:password123@localhost:8761/eureka
  datacenter: cloud
  environment: product
```

## provider服务提供者

* 引入服务注册eureka
* 引入端点actuator
* http://localhost:7900/env 环境
* http://localhost:7900/health 监控状态

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


> 应用入口增加 @EnableEurekaClient 或者 @EnableDiscoveryClient
```java
@SpringBootApplication
@EnableEurekaClient
public class MicroserviceSimpleProviderUserApplication {

  public static void main(String[] args) {
    SpringApplication.run(MicroserviceSimpleProviderUserApplication.class, args);
  }
}

```

> 配置文件

* spring.application.name 指定服务名称（全部小写）
* eureka.instance.instance-id 指定服务在eureka上的显示
* eureka.client.healthcheck.enabled 健康检查

> 健康检查

* Eureka Server与Eureka Client之间使用心跳机制来确定Eureka Client的状态，默认情况下，服务器端与客户端的心跳保持正常，应用程序就会始终保持“UP”状态，所以微服务的UP并不能完全反应应用程序的状态。
* Spring Boot Actuator提供了/health端点，该端点可展示应用程序的健康信息，只有将该端点中的健康状态传播到Eureka Server就可以了，实现这点很简单，只需为微服务配置如下内容
* eureka.instance.appname 设置后会替换spring.application.name 在eureka 的dashboard

```xml
server:
  port: 7900
  
spring:
  application:
    name: microservice-provider-user
	
eureka:
  client:
    healthcheck:
      enabled: true
    serviceUrl:
      defaultZone: http://user:password123@localhost:8761/eureka
  instance:
    prefer-ip-address: true
    instance-id: ${spring.application.name}:${spring.cloud.client.ipAddress}:${spring.application.instance_id:${server.port}}
    metadata-map:
      zone: ABC      # eureka可以理解的元数据
      lilizhou: BBC  # 不会影响客户端行为
    lease-renewal-interval-in-seconds: 5
    appname: microservice-provider-user
```

* 提供findById服务
* 获取服务信息serviceUrl\showInfo
```java

@RestController
public class UserController {

  @Autowired
  private UserRepository userRepository;

  @GetMapping("/simple/{id}")
  public User findById(@PathVariable Long id) {
    return this.userRepository.findOne(id);
  }
  
  @Autowired
  private EurekaClient eurekaClient;

  @Autowired
  private DiscoveryClient discoveryClient;
  
  //获取服务提供的ip
  @GetMapping("/eureka-instance")
  public String serviceUrl() {
    InstanceInfo instance = this.eurekaClient.getNextServerFromEureka("MICROSERVICE-PROVIDER-USER", false);
    return instance.getHomePageUrl();
  }

  //获取服务提供者信息
  @GetMapping("/instance-info")
  public ServiceInstance showInfo() {
    ServiceInstance localServiceInstance = this.discoveryClient.getLocalServiceInstance();
    return localServiceInstance;
  }
}
```

## consumer消费者


> 使用RestTemplate消费spring boot的Restful服务

* RestTemplate是Spring提供的用于访问Rest服务的客户端，RestTemplate提供了多种便捷访问远程Http服务的方法，能够大大提高客户端的编写效率

> 引入eureka依赖



```java
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-eureka</artifactId>
		</dependency>
```

* 使用this.restTemplate调用服务提供者的接口
* 使用ribbon 做客户端负载均衡 @LoadBalanced 
* 默认负载均衡的方式是轮询

```java
@SpringBootApplication
@EnableEurekaClient
public class ConsumerMovieRibbonApplication {

  @Bean
  @LoadBalanced
  public RestTemplate restTemplate() {
    return new RestTemplate();
  }

  public static void main(String[] args) {
    SpringApplication.run(ConsumerMovieRibbonApplication.class, args);
  }
}

```

> findById调用提供者提供的接口
```java
@RestController
public class MovieController {
  @Autowired
  private RestTemplate restTemplate;

  @GetMapping("/movie/{id}")
  public User findById(@PathVariable Long id) {
    return this.restTemplate.getForObject("http://microservice-provider-user/simple/" + id, User.class);
  }
}

```

application.yml

* 配置eureka的地址

```xml
spring:
  application:
    name: microservice-consumer-movie-ribbon
server:
  port: 8010
eureka:
  client:
    healthcheck:
      enabled: true
    serviceUrl:
      defaultZone: http://user:password123@localhost:8761/eureka
  instance:
    prefer-ip-address: true

```

## 客户端地址
* 查看eraka接口信息 http://localhost:8761/eureka/apps
* 查看eraka指定接口信息 http://localhost:8761/eureka/apps/microservice-provider-user/



