# Spring Cloud技术分析

现如今微服务架构十分流行，而采用微服务构建系统也会带来更清晰的业务划分和可扩展性。同时，支持微服务的技术栈也是多种多样的，本系列文章主要介绍这些技术中的翘楚——Spring Cloud。这是序篇，主要讲述我们为什么选择Spring Cloud和它的技术概览。

## 一、为什么微服务架构需要Spring Cloud

简单来说，服务化的核心就是将传统的一站式应用根据业务拆分成一个一个的服务，而微服务在这个基础上要更彻底地去耦合（不再共享DB、KV，去掉重量级ESB），并且强调DevOps和快速演化。这就要求我们必须采用与一站式时代、泛SOA时代不同的技术栈，而Spring Cloud就是其中的佼佼者。

> DevOps是英文Development和Operations的合体，他要求开发、测试、运维进行一体化的合作，进行更小、更频繁、更自动化的应用发布，以及围绕应用架构来构建基础设施的架构。这就要求应用充分的内聚，也方便运维和管理。这个理念与微服务理念不谋而合。


接下来我们从服务化架构演进的角度来看看为什么Spring Cloud更适应微服务架构。


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/1.png)

这种架构存在很多问题:

* Nginx作为中间层，在配置文件中耦合了服务调用的逻辑，这削弱了微服务的完整性，也使得Nginx在一定程度上变成了一个重量级的ESB。
* 服务的信息分散在各个系统，无法统一管理和维护。每一次的服务调用都是一次尝试，服务消费者并不知道有哪些实例在给他们提供服务。这不符合DevOps的理念。
* 无法直观的看到服务提供者和服务消费者当前的运行状况和通信频率。这也不符合DevOps的理念。
* 消费者的失败重发，负载均衡等都没有统一策略，这加大了开发每个服务的难度，不利于快速演化。

为了解决上面的问题，我们需要一个现成的中心组件对服务进行整合，将每个服务的信息汇总，包括服务的组件名称、地址、数量等。服务的调用方在请求某项服务时首先通过中心组件获取提供这项服务的实例的信息（IP、端口等），再通过默认或自定义的策略选择该服务的某一提供者直接进行访问。所以，我们引入了Dubbo。


## 二、基于Dubbo实现微服务

Dubbo是阿里开源的一个SOA服务治理解决方案，文档丰富，在国内的使用度非常高。

使用Dubbo构建的微服务，已经可以比较好地解决上面提到的问题：

* 调用中间层变成了可选组件，消费者可以直接访问服务提供者。
* 服务信息被集中到Registry中，形成了服务治理的中心组件。
* 通过Monitor监控系统，可以直观地展示服务调用的统计信息。
* Consumer可以进行负载均衡、服务降级的选择。


但是对于微服务架构而言，Dubbo也并不是十全十美的

* Registry严重依赖第三方组件（zookeeper或者redis），当这些组件出现问题时，服务调用很快就会中断
* DUBBO只支持RPC调用。使得服务提供方与调用方在代码上产生了强依赖，服务提供者需要不断将包含公共代码的jar包打包出来供消费者使用。一旦打包出现问题，就会导致服务调用出错。

> 目前Github社区上有一个DUBBO的升级版，叫DUBBOX，提供了更高效的RPC序列化方式和REST调用方式。但是该项目也基本停止维护了。


## 三、新的选择——Spring Cloud

作为新一代的服务框架，Spring Cloud提出的口号是开发“面向云环境的应用程序”，它为微服务架构提供了更加全面的技术支持。

结合我们一开始提到的微服务的诉求，我们把Spring Cloud与DUBBO进行一番对比：


```
微服务需要的功能	     Dubbo	              Spring Cloud
服务注册和发现	         Zookeeper	          Eureka
服务调用方式	         RPC	              RESTful API
断路器	                 有	                  有
负载均衡	             有	                  有
服务路由和过滤	         有	                  有
分布式配置	             无	                  有
分布式锁	             无	                  计划开发
集群选主	             无	                  有
分布式消息	             无	                  有

```

> Spring Cloud抛弃了Dubbo的RPC通信，采用的是基于HTTP的REST方式。严格来说，这两种方式各有优劣。虽然从一定程度上来说，后者牺牲了服务调用的性能，但也避免了上面提到的原生RPC带来的问题。而且REST相比RPC更为灵活，服务提供方和调用方的依赖只依靠一纸契约，不存在代码级别的强依赖，这在强调快速演化的微服务环境下，显得更加合适。


> Eureka相比于zookeeper，更加适合于服务发现的场景，这点会在下一篇会详细展开。


很明显，Spring Cloud的功能比DUBBO更加强大，涵盖面更广，而且作为Spring的拳头项目，它也能够与Spring Framework、Spring Boot、Spring Data、Spring Batch等其他Spring项目完美融合，
这些对于微服务而言是至关重要的。前面提到，微服务背后一个重要的理念就是持续集成、快速交付，而在服务内部使用一个统一的技术框架，
显然比把分散的技术组合到一起更有效率。更重要的是，相比于Dubbo，它是一个正在持续维护的、社区更加火热的开源项目，这就保证使用它构建的系统，可以持续地得到开源力量的支持。



## 四、Spring Cloud技术概览


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/2.png)

* 服务治理：这是Spring Cloud的核心。目前Spring Cloud主要通过整合Netflix的相关产品来实现这方面的功能（Spring Cloud Netflix），包括用于服务注册和发现的Eureka，调用断路器Hystrix，调用端负载均衡Ribbon，Rest客户端Feign，智能服务路由Zuul，用于监控数据收集和展示的Spectator、Servo、Atlas，用于配置读取的Archaius和提供Controller层Reactive封装的RxJava。除此之外，针对


> Feign和RxJava并不是Netiflix的产品，但是被整合到了Spring Cloud Netflix中

------------

> 对于服务的注册和发现，除了Eureka，Spring Cloud也整合了Consul和Zookeeper作为备选，但是因为这两个方案在CAP理论上都遵循CP而不是AP（下一篇会详细介绍这点），所以官方并没有推荐使用。


* 分布式链路监控：Spring Cloud Sleuth提供了全自动、可配置的数据埋点，以收集微服务调用链路上的性能数据，并发送给Zipkin进行存储、统计和展示。
* 消息组件：Spring Cloud Stream对于分布式消息的各种需求进行了抽象，包括发布订阅、分组消费、消息分片等功能，实现了微服务之间的异步通信。Spring Cloud Stream也集成了第三方的RabbitMQ和Apache Kafka作为消息队列的实现。而Spring Cloud Bus基于Spring Cloud Stream，主要提供了服务间的事件通信（比如刷新配置）
* 配置中心：基于Spring Cloud Netflix和Spring Cloud Bus，Spring又提供了Spring Cloud Config，实现了配置集中管理、动态刷新的配置中心概念。配置通过Git或者简单文件来存储，支持加解密。
* 安全控制：Spring Cloud Security基于OAUTH2这个开放网络的安全标准，提供了微服务环境下的单点登录、资源授权、令牌管理等功能。
* 命令行工具：Spring Cloud Cli提供了以命令行和脚本的方式来管理微服务及Spring Cloud组件的方式。
* 集群工具：Spring Cloud Cluster提供了集群选主、分布式锁（暂未实现）、一次性令牌（暂未实现）等分布式集群需要的技术组件。


## 原文地址

http://tech.lede.com/2017/03/15/rd/server/SpringCloud0/


