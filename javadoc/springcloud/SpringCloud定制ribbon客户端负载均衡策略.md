# 定制Rabbon客户端负载均衡策略

* Rabbon默认的负载均衡方式是轮询
* WeightedResponseTimeRule 访问权重
## 第一种使用注解方式

RibbonConfiguration
* ExcludeFromComponentScan为自定义的注解，如果不加排除扫描会使所有的接口的策略发生改变，不能单独指定特殊接口的负载均衡方式
* ribbonRule 指定负载均衡的方式
```java
@Configuration
@ExcludeFromComponentScan
public class RibbonConfiguration {

  @Bean
  public IRule ribbonRule() {
    return new RandomRule();
  }
}

```

* 定义注解
```java
public @interface ExcludeFromComponentScan {

}

```
程序入口
* RibbonClient 可以指定特定提供者的负载均衡方式
* ComponentScan 排除扫描配置文件ExcludeFromComponentScan
* LoadBalanced 指定使用ribbon做负载均衡


```java
@SpringBootApplication
@EnableEurekaClient
@RibbonClient(name = "microservice-provider-user", configuration = RibbonConfiguration.class)
@ComponentScan(excludeFilters = { @ComponentScan.Filter(type = FilterType.ANNOTATION, value = ExcludeFromComponentScan.class) })
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

* 获取服务提供者的信息
```java

  @Autowired
  private LoadBalancerClient loadBalancerClient;
  
  
  @GetMapping("/test")
  public String test() {
    ServiceInstance serviceInstance = this.loadBalancerClient.choose("microservice-provider-user");
    System.out.println("111" + ":" + serviceInstance.getServiceId() + ":" + serviceInstance.getHost() + ":" + serviceInstance.getPort());

    return "1";
  }
```

## 基于配置文件的方式

* microservice-provider-user 指定调用这个微服务的客户端使用的负载均衡方式


```java
eureka:
  client:
    healthcheck:
      enabled: true
    serviceUrl:
      defaultZone: http://user:password123@localhost:8761/eureka
  instance:
    prefer-ip-address: true
microservice-provider-user:
  ribbon:
    NFLoadBalancerRuleClassName: com.netflix.loadbalancer.RandomRule
```

## ribbon 指定访问特定ip的服务

* 关闭eureka
* 指定listOfServers

```java
ribbon:
  eureka:
   enabled: false
microservice-provider-user:
  ribbon:
    listOfServers: localhost:7900
```


