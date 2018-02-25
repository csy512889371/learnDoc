# SpringCloud Hystrix 实现

> 超时机制、断路器模式简介

# 使用Hystrix保护应用

## 目前存在的问题
* 现在我们假设一下，服务提供者响应非常缓慢，那么消费者对提供者的请求就会被强制等待，直到服务返回。
* 在高负载场景下，如果不做任何处理，这种问题很可能造成所有处理用户请求的线程都被耗竭，而不能响应用户的进一步请求。

## 雪崩效应
* 在微服务架构中通常会有多个服务层调用，大量的微服务通过网络进行通信，从而支撑起整个系统。
* 各个微服务之间也难免存在大量的依赖关系。然而任何服务都不是100%可用的，网络往往也是脆弱的，所以难免有些请求会失败。基础服务的故障导致级联故障，进而造成了整个系统的不可用，这种现象被称为服务雪崩效应。
* 服务雪崩效应描述的是一种因服务提供者的不可用导致服务消费者的不可用，并将不可用逐渐放大的过程。
* A作为服务提供者，B为A的服务消费者，C和D是B的服务消费者。A不可用引起了B的不可用，并将不可用像滚雪球一样放大到C和D时，雪崩效应就形成了。

![image](https://github.com/csyeva/eva/blob/master/img/springcloud/xb.png)


## 解决方案

> 超时机制
* 通过网络请求其他服务时，都必须设置超时。正常情况下，一个远程调用一般在几十毫秒内就返回了。当依赖的服务不可用，或者因为网络问题，响应时间将会变得很长（几十秒）。而通常情况下，一次远程调用对应了一个线程/进程，如果响应太慢，那这个线程/进程就会得不到释放。而线程/进程都对应了系统资源，如果大量的线程/进程得不到释放，并且越积越多，服务资源就会被耗尽，从而导致资深服务不可用。所以必须为每个请求设置超时。

> 断路器模式
* 试想一下，家庭里如果没有断路器，电流过载了（例如功率过大、短路等），电路不断开，电路就会升温，甚至是烧断电路、起火。有了断路器之后，当电流过载时，会自动切断电路（跳闸），从而保护了整条电路与家庭的安全。当电流过载的问题被解决后，只要将关闭断路器，电路就又可以工作了。
* 同样的道理，当依赖的服务有大量超时时，再让新的请求去访问已经没有太大意义，只会无谓的消耗现有资源。譬如我们设置了超时时间为1秒，如果短时间内有大量的请求（譬如50个）在1秒内都得不到响应，就往往意味着异常。此时就没有必要让更多的请求去访问这个依赖了，我们应该使用断路器避免资源浪费。
* 断路器可以实现快速失败，如果它在一段时间内侦测到许多类似的错误（譬如超时），就会强迫其以后的多个调用快速失败，不再请求所依赖的服务，从而防止应用程序不断地尝试执行可能会失败的操作，这样应用程序可以继续执行而不用等待修正错误，或者浪费CPU时间去等待长时间的超时。断路器也可以使应用程序能够诊断错误是否已经修正，如果已经修正，应用程序会再次尝试调用操作。
* 断路器模式就像是那些容易导致错误的操作的一种代理。这种代理能够记录最近调用发生错误的次数，然后决定使用允许操作继续，或者立即返回错误。


# 基于方法的融断

> pom.xml引入相应的依赖

```java
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-hystrix</artifactId>
		</dependency>
```

## 配置hystrix 默认超时时间

```xml
hystrix.command.default.execution.isolation.thread.timeoutInMilliseconds: 5000
```

## 应用入口

> 应用入口 引入@EnableCircuitBreaker 熔断器注解

```java

@SpringBootApplication
@EnableEurekaClient
@EnableCircuitBreaker
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

# 基于Feign的融断

> UserFeignClient

```java
@FeignClient(name = "microservice-provider-user", fallback = HystrixClientFallback.class)
public interface UserFeignClient {
  @RequestMapping(value = "/simple/{id}", method = RequestMethod.GET)
  public User findById(@PathVariable("id") Long id);
}
```

> HystrixClientFallback
```java
@Component
public class HystrixClientFallback implements UserFeignClient {

  @Override
  public User findById(Long id) {
    User user = new User();
    user.setId(0L);
    return user;
  }
}
```


## controller 中实现融短方法

> @HystrixCommand 指定融断方法
> 注意熔断器的方法一定和原方法的名称保持一致
> 配置@HystrixCommand(fallbackMethod = "findByIdFallback", commandProperties = @HystrixProperty(name = "execution.isolation.strategy", value = "SEMAPHORE"))
* 配置完上面isolation的表示findById 与 findByIdFallback 在同一线程。不配置表示默认两个方法在不同的线程,其中findByIdFallback在隔离线程。

```java
@RestController
public class MovieController {
  @Autowired
  private RestTemplate restTemplate;

  @GetMapping("/movie/{id}")
  @HystrixCommand(fallbackMethod = "findByIdFallback")
  public User findById(@PathVariable Long id) {
    return this.restTemplate.getForObject("http://microservice-provider-user/simple/" + id, User.class);
  }

  public User findByIdFallback(Long id) {
    User user = new User();
    user.setId(0L);
    return user;
  }
}
```

## Feign 关闭Hystrix

### 局部关闭Hystrix支持

* Feign 默认支持Hystrix。Feign.Builder: HystrixFeign.Builder
* 关闭Hystrix的支持只需要修改feignBuilder配置如下：

```java
  @Bean
  @Scope("prototype")
  public Feign.Builder feignBuilder() {
    return Feign.builder();
  }
```

### 全局关闭Hystrix支持
* feign.hystrix.enabled = false

## 采用FallbackFactory 实现熔断

> 为FeignClient 配置HystrixClientFactory

```java
@FeignClient(name = "microservice-provider-user", fallbackFactory = HystrixClientFactory.class)
public interface UserFeignClient {
  @RequestMapping(value = "/simple/{id}", method = RequestMethod.GET)
  public User findById(@PathVariable("id") Long id);
}

```
> HystrixClientFactory 
```java
@Component
public class HystrixClientFactory implements FallbackFactory<UserFeignClient> {

  private static final Logger LOGGER = LoggerFactory.getLogger(HystrixClientFactory.class);

  @Override
  public UserFeignClient create(Throwable cause) {
    HystrixClientFactory.LOGGER.info("fallback; reason was: {}", cause.getMessage());
    return new UserFeignClientWithFactory() {
      @Override
      public User findById(Long id) {
        User user = new User();
        user.setId(-1L);
        return user;
      }
    };
  }
}

```

## UserFeignClientWithFactory 实现了 UserFeignClient接口
```java
public interface UserFeignClientWithFactory extends UserFeignClient {

}
```

# 查看Hystrix状态
> http://localhost:8010/hystrix.stream 查看Hystrix信息
> http://localhost:8010/health 查看监控状态

# Hystrix DashBoard

pom.xml 

* 引入对DashBoard的支持


```java

		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-hystrix-dashboard</artifactId>
		</dependency>
```


> EnableHystrixDashboard 应用入口指定对HystrixDashboard的支持

```java
@EnableHystrixDashboard
@SpringBootApplication
public class EurekaApplication {
  public static void main(String[] args) {
    SpringApplication.run(EurekaApplication.class, args);
  }
}

```

* 访问地址 http://localhost:8030/hystrix
* 填写要检测的hystrix: http://localhost:8010/hystrix.stream 



