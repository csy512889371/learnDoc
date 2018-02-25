# spring cloud 知识点

## Spring Cloud简介
> 简介

* Spring Cloud 为开发者提供了在分布式系统（配置管理，服务发现，熔断，路由，微代理，控制总线，一次性token，全居琐，leader选举，分布式session，集群状态）中快速构建的工具，使用Spring Cloud的开发者可以快速的启动服务或构建应用、同时能够快速和云平台资源进行对接。


![image](https://github.com/csyeva/eva/blob/master/img/springcloud/jg.png)

## 统一配置中心

> 配置的管理
```xml
/{application}/{profile}[/{label}]
/{application}-{profile}.yml
/{label}/{application}-{profile}.yml
/{application}-{profile}.properties
/{label}/{application}-{profile}.properties
```
> 配置的刷新

```xml
/refresh
/bus/refresh ===> amqp
```

![image](https://github.com/csyeva/eva/blob/master/img/springcloud/pz.jpg)

## API网关
[「Chris Richardson 微服务系列」使用 API 网关构建微服务](http://blog.daocloud.io/microservices-2/)
[Zuul API](https://github.com/netflix/zuul)

![image](https://github.com/csyeva/eva/blob/master/img/springcloud/fwwg.jpg)

## 微服务容错

### 雪崩效应

![image](https://github.com/csyeva/eva/blob/master/img/springcloud/xb.png)

### 实现容错的方案
> 为请求设置超时
* 通过网络请求其他服务时，都必须设置超时。正常情况下，一个远程调用一般在几十毫秒内就能得到响应了。如果依赖的服务不可用，或者网络有问题，响应时间将会变得很长（几十秒）。
通常情况下，一次远程调用对应着一个线程/进程。如果响应太慢，这个线程/进程就得不到释放。而线程/进程又对应着系统资源，如果得不到释放的线程/进程越积越多，服务资源就会被耗尽，从而导致服务不可用。
因此，必须为每个请求设置超时，让资源尽快地得到释放。


> 使用断路器
* 试想一下，如果家庭里没有断路器，电流过载了（例如功率过大、短路等），电路不断开，电路就会升温，甚至是烧断电路、起火。有了断路器之后，当电流过载时，会自动切断电路（跳闸），从而保护了整条电路与家庭的安全。当电流过载的问题被解决后，只要将关闭断路器，电路就又可以工作了。
同样的道理，当依赖的服务有大量超时时，再让新的请求去访问已经没有太大意义，只会无谓的消耗现有资源。譬如我们设置了超时时间为1秒，如果短时间内有大量的请求（譬如50个）在1秒内都得不到响应，就往往意味着异常。此时就没有必要让更多的请求去访问这个依赖了，我们应该使用断路器避免资源浪费。
断路器可以实现快速失败，如果它在一段时间内侦测到许多类似的错误（譬如超时），就会强迫其以后的多个调用快速失败，不再请求所依赖的服务，从而防止应用程序不断地尝试执行可能会失败的操作，这样应用程序可以继续执行而不用等待修正错误，或者浪费CPU时间去等待长时间的超时。断路器也可以使应用程序能够诊断错误是否已经修正，如果已经修正，应用程序会再次尝试调用操作。
断路器模式就像是那些容易导致错误的操作的一种代理。这种代理能够记录最近调用发生错误的次数，然后决定使用允许操作继续，或者立即返回错误。
断路器开关相互转换的逻辑如下图：

![image](https://github.com/csyeva/eva/blob/master/img/springcloud/rdq1.png)



![image](https://github.com/csyeva/eva/blob/master/img/springcloud/rdq.png)


## 声明式的Http Client Feign
[feign github](https://github.com/OpenFeign/feign)

## 客户端负载均衡Ribbon
![image](https://github.com/csyeva/eva/blob/master/img/springcloud/rb.png)

## 服务注册与发现
> 创建调用关系的微服务
* 服务消费者   调用别的微服务的微服务
* 服务提供者   提供API的微服务

> 使用Eureka实现服务注册与发现

![image](https://github.com/csyeva/eva/blob/master/img/springcloud/fwfx.jpg)




