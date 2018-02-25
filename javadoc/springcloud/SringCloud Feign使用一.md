# SpringCloud Feign使用二

[SpringCloud Feign使用一](http://blog.csdn.net/qq_27384769/article/details/79081014)

## 一使用原生Feign注解

* Feign默认使用的是 SpringMvc的注解，如果要使用Feign原生注解配置如下

```java
@Configuration
public class Configuration1 {
  @Bean
  public Contract feignContract() {
    return new feign.Contract.Default();
  }


  //改变Feign 日志级别
  @Bean
  Logger.Level feignLoggerLevel() {
    return Logger.Level.FULL;
  }
}
```

* 指定使用配置Configuration1
```java
import feign.Param;
import feign.RequestLine;

@FeignClient(name = "microservice-provider-user", configuration = Configuration1.class)
public interface UserFeignClient {
  @RequestLine("GET /simple/{id}")
  public User findById(@Param("id") Long id);
}
```





## 编写接口查询eureka接口信息

* 指定eureka 的帐号信息
```java
@Configuration
public class Configuration2 {
  @Bean
  public BasicAuthRequestInterceptor basicAuthRequestInterceptor() {
    return new BasicAuthRequestInterceptor("user", "password123");
  }
}


```

* 可以指定请求的eureka 的 url
* 指定配置文件 Configuration2

```java
@FeignClient(name = "xxxx", url = "http://localhost:8761/", configuration = Configuration2.class)
public interface FeignClient2 {
  @RequestMapping(value = "/eureka/apps/{serviceName}")
  public String findServiceInfoFromEurekaByServiceName(@PathVariable("serviceName") String serviceName);
}
```
## 日志级别

```xml
logging:
  level:
    com.itmuch.cloud.feign.UserFeignClient: DEBUG
```

## Feign 加入Ribbon 负载均衡

> 加入以下配置
```java
microservice-provider-user:
  ribbon:
    NFLoadBalancerRuleClassName: com.netflix.loadbalancer.RandomRule
```


## Feign支持请求和响应的压缩

* 增加gzip配置

```java
#请求和响应GZIP压缩支持
feign.compression.request.enabled=true
feign.compression.response.enabled=true
```

## histrix

> 如果没有用到histrix则关闭

```java
#Hystrix支持，如果为true，hystrix库必须在classpath中
feign.hystrix.enabled=false
```

> 可修改融短器的超时时间

* 修改长超时时间
* timeout设置为false
* 禁用掉hystrix

```xml
# hystrix.command.default.execution.isolation.thread.timeoutInMilliseconds: 5000
# 或者：
# hystrix.command.default.execution.timeout.enabled: false
# 或者：
feign.hystrix.enabled: false ## 索性禁用feign的hystrix支持

# 超时的issue：https://github.com/spring-cloud/spring-cloud-netflix/issues/768
# 超时的解决方案： http://stackoverflow.com/questions/27375557/hystrix-command-fails-with-timed-out-and-no-fallback-available
# hystrix配置： https://github.com/Netflix/Hystrix/wiki/Configuration#execution.isolation.thread.timeoutInMilliseconds

```



