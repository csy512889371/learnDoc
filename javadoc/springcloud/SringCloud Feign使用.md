# Spring Cloud Feign使用

我们消费spring boot提供的Restful服务的时候，使用的是RestTemplate来实现的，实现起来还是比较复杂的，尤其是在消费复杂的Restful服务的时候，还需要进行一系列的转换，编解码等，使用Feign就完全不用考虑这个问题了

# Feign简介

Feign是一种声明式、模板化的HTTP客户端。在Spring Cloud中使用Feign, 我们可以做到使用HTTP请求远程服务时能与调用本地方法一样的编码体验，开发者完全感知不到这是远程方法，更感知不到这是个HTTP请求，这整个调用过程和Dubbo的RPC非常类似。开发起来非常的优雅。

# Feign 使用
* Feign 本身支持 SpringMvc的部分注解

## 代码实现

* 配置依赖
```xml
	<dependency>
		<groupId>org.springframework.cloud</groupId>
		<artifactId>spring-cloud-starter-feign</artifactId>
	</dependency>
```

* 入口应用程序
* @EnableFeignClients 增加feign的支持
```java
@SpringBootApplication
@EnableEurekaClient
@EnableFeignClients
public class ConsumerMovieFeignApplication {
  public static void main(String[] args) {
    SpringApplication.run(ConsumerMovieFeignApplication.class, args);
  }
}

```

* 编写接口
* feign 不支持 @GetMapping
* @PathVariable 必须得设置
* 参数是复杂对象，即使指定了是GET方法，feign依然会以POST方法进行发送请求

```java

@FeignClient("microservice-provider-user")
public interface UserFeignClient {
  @RequestMapping(value = "/simple/{id}", method = RequestMethod.GET)
  public User findById(@PathVariable("id") Long id); 

  @RequestMapping(value = "/user", method = RequestMethod.POST)
  public User postUser(@RequestBody User user);
}

```

controller

```java
@RestController
public class MovieController {

  @Autowired
  private UserFeignClient userFeignClient;

  @GetMapping("/movie/{id}")
  public User findById(@PathVariable Long id) {
    return this.userFeignClient.findById(id);
  }

  @GetMapping("/test")
  public User testPost(User user) {
    return this.userFeignClient.postUser(user);
  }

}
```

# 指定特定接口的负载均衡
```java
microservice-provider-user:
  ribbon:
    NFLoadBalancerRuleClassName: com.netflix.loadbalancer.RandomRule
```






