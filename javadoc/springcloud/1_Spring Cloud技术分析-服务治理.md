# 1_Spring Cloud技术分析-服务治理

# 一、概述

介绍了Spring Cloud Netflix进行服务治理的技术原理。


[上一篇 Spring Cloud技术分析](https://blog.csdn.net/qq_27384769/article/details/79693621)


# 二、Spring Cloud Netflix的优势

对于微服务的治理而言，核心就是服务的注册和发现。所以选择哪个组件，很大程度上要看它对于服务注册与发现的解决方案。在这个领域，开源架构很多，最常见的是Zookeeper，但这并不是一个最佳选择。


在分布式系统领域有个著名的CAP定理：**C——数据一致性，A——服务可用性，P——服务对网络分区故障的容错性**。这三个特性在任何分布式系统中不能同时满足，最多同时满足两个。


Zookeeper是著名Hadoop的一个子项目，很多场景下Zookeeper也作为Service发现服务解决方案。
**Zookeeper保证的是CP**，即任何时刻对Zookeeper的访问请求能得到一致的数据结果，同时系统对网络分割具备容错性，但是它不能保证每次服务请求的可用性。
从实际情况来分析，在使用Zookeeper获取服务列表时，如果zookeeper正在选主，或者Zookeeper集群中半数以上机器不可用，那么将就无法获得数据了。所以说，Zookeeper不能保证服务可用性。


诚然，对于大多数分布式环境，尤其是涉及到数据存储的场景，数据一致性应该是首先被保证的，这也是zookeeper设计成CP的原因。
但是对于服务发现场景来说，情况就不太一样了：针对同一个服务，即使注册中心的不同节点保存的服务提供者信息不尽相同，也并不会造成灾难性的后果。
因为对于服务消费者来说，能消费才是最重要的——拿到可能不正确的服务实例信息后尝试消费一下，也好过因为无法获取实例信息而不去消费。
**所以，对于服务发现而言，可用性比数据一致性更加重要——AP胜过CP**。而Spring Cloud Netflix在设计Eureka时遵守的就是AP原则。

Eureka本身是Netflix开源的一款提供服务注册和发现的产品，并且提供了相应的Java封装。
在它的实现中，节点之间是相互平等的，部分注册中心的节点挂掉也不会对集群造成影响，即使集群只剩一个节点存活，也可以正常提供发现服务。
哪怕是所有的服务注册节点都挂了，Eureka Clients上也会缓存服务调用的信息。这就保证了我们微服务之间的互相调用是足够健壮的。



除此之外，Spring Cloud Netflix背后强大的开源力量，也促使我们选择了Spring Cloud Netflix：

* 前文提到过，Spring Cloud的社区十分活跃，其在业界的应用也十分广泛（尤其是国外），而且整个框架也经受住了Netflix严酷生产环境的考验。
* 除了服务注册和发现，Spring Cloud Netflix的其他功能也十分强大，包括Ribbon，hystrix，Feign，Zuul等组件，结合到一起，让服务的调用、路由也变得异常容易。
* Spring Cloud Netflix作为Spring的重量级整合框架，使用它也意味着我们能从Spring获取到巨大的便利。Spring Cloud的其他子项目，比如Spring Cloud Stream、Spring Cloud Config等等，都为微服务的各种需求提供了一站式的解决方案。

> Netflix和Spring Cloud是什么关系呢？Netflix是一家成功实践微服务架构的互联网公司，几年前，Netflix就把它的几乎整个微服务框架栈开源贡献给了社区。Spring背后的Pivotal在2015年推出的Spring Cloud开源产品，主要对Netflix开源组件的进一步封装，方便Spring开发人员构建微服务基础框架。

# 三、Spring Cloud Netflix主要组件介绍

Spring Cloud Netflix的核心是用于服务注册与发现的Eureka，接下来我们将以Eureka为线索，介绍Eureka、Ribbon、Hystrix、Feign这些Spring Cloud Netflix主要组件。


##  1.1服务注册与发现——Eureka

> Eureka这个词来源于古希腊语，意为“我找到了！我发现了！”，据传，阿基米德在洗澡时发现浮力原理，高兴得来不及穿上裤子，跑到街上大喊：“Eureka(我找到了)！”。


Eureka由多个instance(服务实例)组成，这些服务实例可以分为两种：Eureka Server和Eureka Client。为了便于理解，我们将Eureka client再分为Service Provider和Service Consumer。如下图所示：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/3.png)

* Eureka Server：服务的注册中心，负责维护注册的服务列表。
* Service Provider：服务提供方，作为一个Eureka Client，向Eureka Server做服务注册、续约和下线等操作，注册的主要数据包括服务名、机器ip、端口号、域名等等。
* Service Consumer：服务消费方，作为一个Eureka Client，向Eureka Server获取Service Provider的注册信息，并通过远程调用与Service Provider进行通信。

> Service Provider和Service Consumer不是严格的概念，Service Consumer也可以随时向Eureka Server注册，来让自己变成一个Service Provider。

----------

> Spring Cloud针对服务注册与发现，进行了一层抽象，并提供了三种实现：Eureka、Consul、Zookeeper。目前支持得最好的就是Eureka，其次是Consul，最后是Zookeeper。


### 1.2  Eureka Server

Eureka Server作为一个独立的部署单元，以REST API的形式为服务实例提供了注册、管理和查询等操作。同时，Eureka Server也为我们提供了可视化的监控页面，可以直观地看到各个Eureka Server当前的运行状态和所有已注册服务的情况。


### 1.3 Eureka Server的高可用集群

Eureka Server可以运行多个实例来构建集群，解决单点问题，但不同于ZooKeeper的选举leader的过程，Eureka Server采用的是Peer to Peer对等通信。这是一种去中心化的架构，无master/slave区分，每一个Peer都是对等的。在这种架构中，节点通过彼此互相注册来提高可用性，每个节点需要添加一个或多个有效的serviceUrl指向其他节点。每个节点都可被视为其他节点的副本。


如果某台Eureka Server宕机，Eureka Client的请求会自动切换到新的Eureka Server节点，当宕机的服务器重新恢复后，Eureka会再次将其纳入到服务器集群管理之中。当节点开始接受客户端请求时，所有的操作都会进行replicateToPeer（节点间复制）操作，将请求复制到其他Eureka Server当前所知的所有节点中。


一个新的Eureka Server节点启动后，会首先尝试从邻近节点获取所有实例注册表信息，完成初始化。Eureka Server通过getEurekaServiceUrls()方法获取所有的节点，并且会通过心跳续约的方式定期更新。默认配置下，如果Eureka Server在一定时间内没有接收到某个服务实例的心跳，Eureka Server将会注销该实例（默认为90秒，通过eureka.instance.lease-expiration-duration-in-seconds配置）。当Eureka Server节点在短时间内丢失过多的心跳时（比如发生了网络分区故障），那么这个节点就会进入自我保护模式。下图为Eureka官网的架构图

> 什么是自我保护模式？默认配置下，如果Eureka Server每分钟收到心跳续约的数量低于一个阈值（instance的数量*(60/每个instance的心跳间隔秒数)*自我保护系数），并且持续15分钟，就会触发自我保护。在自我保护模式中，Eureka Server会保护服务注册表中的信息，不再注销任何服务实例。当它收到的心跳数重新恢复到阈值以上时，该Eureka Server节点就会自动退出自我保护模式。它的设计哲学前面提到过，那就是宁可保留错误的服务注册信息，也不盲目注销任何可能健康的服务实例。该模式可以通过eureka.server.enable-self-preservation = false来禁用，同时eureka.instance.lease-renewal-interval-in-seconds可以用来更改心跳间隔，eureka.server.renewal-percent-threshold可以用来修改自我保护系数（默认0.85）。


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/4.png)



### 1.4 Eureka Server的Region、Zone

Eureka的官方文档对Regin、Zone几乎没有提及，由于概念抽象，新手很难理解。因此，我们先来了解一下Region、Zone、Eureka集群三者的关系，如下图所示：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/5.png)

region和zone（或者Availability Zone）均是AWS的概念。在非AWS环境下，我们可以先简单地将region理解为Eureka集群，zone理解成机房。上图就可以理解为一个Eureka集群被部署在了zone1机房和zone2机房中。

## 2、Service Provider

### 2.1 服务注册

Service Provider本质上是一个Eureka Client。它启动时，会调用服务注册方法，向Eureka Server注册自己的信息。Eureka Server会维护一个已注册服务的列表，这个列表为一个嵌套的hash map：

* 第一层，application name和对应的服务实例。
* 第二层，服务实例及其对应的注册信息，包括IP，端口号等。


当实例状态发生变化时（如自身检测认为Down的时候），也会向Eureka Server更新自己的服务状态，同时用replicateToPeers()向其它Eureka Server节点做状态同步。


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/6.png)


### 2.2 续约与剔除

前面提到过，服务实例启动后，会周期性地向Eureka Server发送心跳以续约自己的信息，避免自己的注册信息被剔除。续约的方式与服务注册基本一致：首先更新自身状态，再同步到其它Peer


如果Eureka Server在一段时间内没有接收到某个微服务节点的心跳，Eureka Server将会注销该微服务节点（自我保护模式除外）。

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/7.png)



### 2.3 Service Consumer

Service Consumer本质上也是一个Eureka Client（它也会向Eureka Server注册，只是这个注册信息无关紧要罢了）。它启动后，会从Eureka Server上获取所有实例的注册信息，包括IP地址、端口等，并缓存到本地。这些信息默认每30秒更新一次。前文提到过，如果与Eureka Server通信中断，Service Consumer仍然可以通过本地缓存与Service Provider通信。



实际开发Eureka的过程中，有时会遇见Service Consumer获取到Server Provider的信息有延迟，在Eureka Wiki中有这么一段话:

> All operations from Eureka client may take some time to reflect in the Eureka servers and subsequently in other Eureka clients. This is because of the caching of the payload on the eureka server which is refreshed periodically to reflect new information. Eureka clients also fetch deltas periodically. Hence, it may take up to 2 mins for changes to propagate to all Eureka clients.

最后一句话提到，服务端的更改可能需要2分钟才能传播到所有客户端，至于原因并没有介绍。这是因为Eureka有三处缓存和一处延迟造成的。

* Eureka Server对注册列表进行缓存，默认时间为30s。
* Eureka Client对获取到的注册信息进行缓存，默认时间为30s。
* Ribbon会从上面提到的Eureka Client获取服务列表，将负载均衡后的结果缓存30s
* 如果不是在Spring Cloud环境下使用这些组件(Eureka, Ribbon)，服务启动后并不会马上向Eureka注册，而是需要等到第一次发送心跳请求时才会注册。心跳请求的发送间隔默认是30s。Spring Cloud对此做了修改，服务启动后会马上注册。


基于Service Consumer获取到的服务实例信息，我们就可以进行服务调用了。而Spring Cloud也为Service Consumer提供了丰富的服务调用工具：

* Ribbon，实现客户端的负载均衡。
* Hystrix，断路器。
* Feign，RESTful Web Service客户端，整合了Ribbon和Hystrix。


## 3、服务调用端负载均衡——Ribbon

Ribbon是Netflix发布的开源项目，主要功能是为REST客户端实现负载均衡。它主要包括六个组件

* ServerList，负载均衡使用的服务器列表。这个列表会缓存在负载均衡器中，并定期更新。当Ribbon与Eureka结合使用时，ServerList的实现类就是DiscoveryEnabledNIWSServerList，它会保存Eureka Server中注册的服务实例表。
* ServerListFilter，服务器列表过滤器。这是一个接口，主要用于对Service Consumer获取到的服务器列表进行预过滤，过滤的结果也是ServerList。Ribbon提供了多种过滤器的实现。
* IPing，探测服务实例是否存活的策略。
* IRule，负载均衡策略，其实现类表述的策略包括：轮询、随机、根据响应时间加权等，其类结构如下图所示。

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/8.png)


> 我们也可以自己定义负载均衡策略，比如我们就利用自己实现的策略，实现了服务的版本控制和直连配置。实现好之后，将实现类重新注入到Ribbon中即可。


* ILoadBalancer，负载均衡器。这也是一个接口，Ribbon为其提供了多个实现，比如ZoneAwareLoadBalancer。而上层代码通过调用其API进行服务调用的负载均衡选择。一般ILoadBalancer的实现类中会引用一个IRule。
* RestClient，服务调用器。顾名思义，这就是负载均衡后，Ribbon向Service Provider发起REST请求的工具。


Ribbon工作时会做四件事情：

* 1.优先选择在同一个Zone且负载较少的Eureka Server；
* 2、定期从Eureka更新并过滤服务实例列表；
* 3、根据用户指定的策略，在从Server取到的服务注册列表中选择一个实例的地址；
* 4、通过RestClient进行服务调用。



## 4、服务调用端熔断——Hystrix


Netflix创建了一个名为Hystrix的库,实现了断路器的模式。“断路器”本身是一种开关装置，当某个服务单元发生故障之后，通过断路器的故障监控（类似熔断保险丝），向调用方返回一个符合预期的、可处理的备选响应（FallBack），而不是长时间的等待或者抛出调用方无法处理的异常，这样就保证了服务调用方的线程不会被长时间、不必要地占用，从而避免了故障在分布式系统中的蔓延，乃至雪崩。


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/9.png)

当然，在请求失败频率较低的情况下，Hystrix还是会直接把故障返回给客户端。只有当失败次数达到阈值（默认在20秒内失败5次）时，断路器打开并且不进行后续通信，而是直接返回备选响应。当然，Hystrix的备选响应也是可以由开发者定制的。

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/10.png)


除了隔离依赖服务的调用以外，Hystrix还提供了准实时的调用监控（Hystrix Dashboard），Hystrix会持续地记录所有通过Hystrix发起的请求的执行信息，并以统计报表和图形的形式展示给用户，包括每秒执行多少请求多少成功，多少失败等。Netflix通过hystrix-metrics-event-stream项目实现了对以上指标的监控。Spring Cloud也提供了Hystrix Dashboard的整合，对监控内容转化成可视化界面，Hystrix Dashboard Wiki上详细说明了图上每个指标的含义。


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/11.png)



## 5、服务调用端代码抽象和封装——Feign

Feign是一个声明式的Web Service客户端，它的目的就是让Web Service调用更加简单。它整合了Ribbon和Hystrix，从而让我们不再需要显式地使用这两个组件。Feign还提供了HTTP请求的模板，通过编写简单的接口和插入注解，我们就可以定义好HTTP请求的参数、格式、地址等信息。接下来，Feign会完全代理HTTP的请求，我们只需要像调用方法一样调用它就可以完成服务请求。

Feign具有如下特性：

* 可插拔的注解支持，包括Feign注解和JAX-RS注解
* 支持可插拔的HTTP编码器和解码器
* 支持Hystrix和它的Fallback
* 支持Ribbon的负载均衡
* 支持HTTP请求和响应的压缩


以下是一个Feign的简单示例：

```java
@SpringBootApplication
@EnableDiscoveryClient //启用Feign
@EnableFeignClients
public class Application
{
    public static void main(String[] args)
    {
        SpringApplication.run(Application.class, args);
    }
}

@FeignClient(name = "elements", fallback = ElementsFallback.class) //指定feign调用的服务和Hystrix Fallback（name即eureka的application name）
public interface Elements
{
    @RequestMapping(value = "/index")
    String index();
}

//Hystrix Fallback    
@Component
public class ElementsFallback implements Elements
{
    @Override
    public String index()
    {
        return "**************";
    }
}

//测试类
@Component    
public class TestController {
    @Autowired
    Elements elements;

    @RequestMapping(value = "/testEureka", method = RequestMethod.GET)
    public String testeureka()
    {
         return elements.index();
    }
}

```

# 三、参考文档

http://cloud.spring.io/spring-cloud-static/Brixton.SR7

https://github.com/Netflix/eureka/wiki

http://itmuch.com/spring-cloud-sum-eureka

http://nobodyiam.com/2016/06/25/dive-into-eureka



















