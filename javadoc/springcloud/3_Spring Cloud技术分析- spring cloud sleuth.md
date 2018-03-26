# 3_Spring Cloud技术分析- spring cloud sleuth

pring cloud sleuth是从google的dapper论文的思想实现的，提供了对spring cloud系列的链路追踪。本文主要从spring cloud sleuth的使用着手。


# 一、目的

* 提供链路追踪。通过sleuth可以很清楚的看出一个请求都经过了哪些服务。可以很方便的理清服务间的调用关系。
* 可视化错误。对于程序未捕捉的异常，可以在zipkin界面上看到。
* 分析耗时。通过sleuth可以很方便的看出每个采样请求的耗时，分析出哪些服务调用比较耗时。当服务调用的耗时随着请求量的增大而增大时，也可以对服务的扩容提供一定的提醒作用。
* 优化链路。对于频繁地调用一个服务，或者并行地调用等，可以针对业务做一些优化措施。

# 二、应用程序集成spring cloud sleuth

spring cloud sleuth可以结合zipkin，将信息发送到zipkin，利用zipkin的存储来存储信息，利用zipkin ui来展示数据。同时也可以只是简单的将数据记在日志中。


## 1、仅仅使用sleuth+log配置


maven配置

```xml
<dependency>
	<groupId>org.springframework.cloud</groupId>
	<artifactId>spring-cloud-dependencies</artifactId>
	<version>Camden.SR6</version>
	<type>pom</type>
	<scope>import</scope>
</dependency>
<dependency>
	<groupId>org.springframework.cloud</groupId>
	<artifactId>spring-cloud-starter-sleuth</artifactId>
</dependency>

```

这种方式只需要引入jar包即可。如果配置log4j，这样会在打印出如下的日志

```xml
2017-04-08 23:56:50.459 INFO [bootstrap,38d6049ff0686023,d1b8b0352d3f6fa9,false] 8764 — [nio-8080-exec-1] demo.JpaSingleDatasourceApplication : Step 2: Handling print
2017-04-08 23:56:50.459 INFO [bootstrap,38d6049ff0686023,d1b8b0352d3f6fa9,false] 8764 — [nio-8080-exec-1] demo.JpaSingleDatasourceApplication : Step 1: Handling home
```


比原先的日志多出了 [bootstrap,38d6049ff0686023,d1b8b0352d3f6fa9,false] 这些内容，[appname,traceId,spanId,exportable]。
* appname：服务名称
* traceId\spanId：链路追踪的两个术语，后面有介绍
* exportable:是否是发送给zipkin

## 2、sleuth+zipkin+http

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/17.png)

BlockingQueue的大小sleuth写死了为1000。当队列满了还往里放的话，sleuth只是加了个记录处理。


### 2.1应用程序配置

maven引入
```xml

<dependency>
	<groupId>org.springframework.cloud</groupId>
	<artifactId>spring-cloud-dependencies</artifactId>
	<version>Camden.SR6</version>
	<type>pom</type>
	<scope>import</scope>
</dependency>
<dependency>
	<groupId>org.springframework.cloud</groupId>
	<artifactId>spring-cloud-starter-sleuth</artifactId>
</dependency>
<dependency>
	<groupId>org.springframework.cloud</groupId>
	<artifactId>spring-cloud-starter-zipkin</artifactId>
</dependency>
```

配置文件配置
```java
spring.sleuth.sampler.percentage=0.1  采样率 
spring.zipkin.baseUrl=http://zipkin.xxx.com 发送到zipkinServer的url
spring.zipkin.enabled=true
```

### 2.2 zipkin

maven引入

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-sleuth</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-zipkin</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-stream-binder-kafka</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-sleuth-zipkin-stream</artifactId>
</dependency>
<dependency>
    <groupId>io.zipkin.java</groupId>
    <artifactId>zipkin-autoconfigure-ui</artifactId>
    <!--<version>1.40.2</version>-->
</dependency>
```

**spring boot程序**
```java
@SpringBootApplication(exclude = SleuthStreamAutoConfiguration.class)
@EnableZipkinServer
public class SleuthServerApplication
{
	public static void main(String[] args)
	{
		SpringApplication.run(SleuthServerApplication.class, args);
	}
}
```

**存储配置**

zipkin的存储包括mysql、es、cassadra。如果不配置存储的话，默认是在内存中的。如果在内存中的话，当重启应用后，数据就会丢失了。


**mysql存储**
```java
spring:
  application:
    name: sleuth-zipkin-http
  datasource:
    schema: classpath:/mysql.sql
    url: jdbc:mysql://192.168.3.3:2222/zipkin
    driverClassName: com.mysql.jdbc.Driver
    username: app
    password: %jdbc-1.password%
    # Switch this on to create the schema on startup:
    initialize: true
    continueOnError: true
  sleuth:
    enabled: false

# default is mem (in-memory)
zipkin:
	storage:
	   type: mysql
```
mysql的脚本在zipkin包里已经提供了，只需要执行一下就可以了。


**es存储**

```xml
zipkin:
  storage:
    type: elasticsearch
    elasticsearch:
      cluster: ${ES_CLUSTER:elasticsearch}
      hosts: ${ES_HOSTS:localhost:9300}
      index: ${ES_INDEX:zipkin}
      index-shards: ${ES_INDEX_SHARDS:5}
      index-replicas: ${ES_INDEX_REPLICAS:1}

```


## 3、sletuh+streaming+zipkin

这种方式通过spring cloud streaming将追踪信息发送到zipkin。spring cloud streaming目前只有kafka和rabbitmq的binder。以kafka为例：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/18.png)

Collector是源码的类名。Collector从消息中间件中读取数据并存储到db和es中。

### 3.1、应用程序配置

maven引入

```xml
<dependency>
	<groupId>org.springframework.cloud</groupId>
	<artifactId>spring-cloud-dependencies</artifactId>
	<version>Camden.SR6</version>
	<type>pom</type>
	<scope>import</scope>
</dependency>
<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-sleuth-stream</artifactId>
</dependency>
<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-starter-sleuth</artifactId>
</dependency>
<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-stream-binder-kafka</artifactId>
</dependency>
```

### 3.2、zipkin

maven引入

```java
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-sleuth</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-zipkin</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-stream-binder-kafka</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-sleuth-zipkin-stream</artifactId>
</dependency>
<dependency>
    <groupId>io.zipkin.java</groupId>
    <artifactId>zipkin-autoconfigure-ui</artifactId>
    <!--<version>1.40.2</version>-->
</dependency>
```

spring boot程序

```java
@EnableZipkinStreamServer
@EnableBinding(SleuthSink.class)
@SpringBootApplication(exclude = SleuthStreamAutoConfiguration.class)
@MessageEndpoint
public class SleuthServerApplication
{
	public static void main(String[] args)
	{
		SpringApplication.run(SleuthServerApplication.class, args);
	}
}
```

配置

```xml
stream:
  kafka:
    binder:
      brokers: xxx:9098,xxx:9098,xxx:9098
      zk-nodes: xxx:2186,xxx:2186,xxx:2186,xxx:2186,xxx:2186
```

存储配置和上面的一样。


## 3、sleuth支持

通过sleuth-core的jar包结构，可以很明显的看出，sleuth可以进行链路追踪的代码

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/19.png)

web下面包括http和feign。


### 3.1、http

可以通过spring.sleuth.web.enabled=false来禁止这种类型的链路追踪。http支持实现的关键类是 TraceFilter和TraceHandlerInterceptor。

* TraceFilter：对入站的请求加上X-B3-SpanId、X-B3-TraceId等属性，来对请求进行链路追踪。这时候，Span的名字为http:加上请求的路径。例如，如果请求是/foo/bar，那span名字就是http:/foo/bar。
* TraceHandlerInterceptor：如果需要对span名字进行进一步的控制，可以使用TraceHandlerInterceptor，它会对已有的HandlerInterceptor进行包装，或者直接添加到已有的HandlerInterceptors中。TraceHandlerInterceptor会在HttpServletRequest中添加一个特别的request attribute。如果TraceFilter没有发现这个属性，就会创建一个额外的“fallback”（保底）span，这样确保跟踪信息完整。


### 3.2、runnable、callable、Executor

可以通过 TraceRunnable 和 TraceCallable来对runnable和callable进行包装。也可以用LazyTraceExecutor来代替java的Executor。比如：

```java
@Autowired
private BeanFactory beanFactory;
private static final ExecutorService EXECUTOR = Executors.newFixedThreadPool(2);
@RequestMapping("/service1")
public String service1()
{

	Runnable runnable = () ->
	{
		try
		{
			Thread.sleep(1000);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	};
	Executor executor = new LazyTraceExecutor(beanFactory, EXECUTOR);
	executor.execute(runnable);
	return "hello world";
}
```

这样每次执行都有span的新建和销毁。通过LazyTraceExecutor源码可以很轻松的看到：

```java
@Override
public void run() {
	Span span = startSpan();
	try {
		this.getDelegate().run();
	}
	finally {
		close(span);
	}
}
```

### 3.3 feign

默认情况下，Spring Cloud Sleuth提供了一个TraceFeignClientAutoConfiguration来整合Feign。如果需要禁用的话，可以设置spring.sleuth.feign.enabled为false。如果禁用，与Feign相关的机制就不会发生


### 3.4  RxJava

建议自定义一个RxJavaSchedulersHook,它使用TraceAction来包装实例中所有的Action0。这个钩子对象，会根据之前调度的Action是否已经开始跟踪，来决定是创建还是延续使用span。可以通过设置spring.sleuth.rxjava.schedulers.hook.enabled为false来关闭这个对象的使用。可以定义一组正则表达式来对线程名进行过滤，来选择哪些线程不需要跟踪。可以使用逗号分割的方式来配置spring.sleuth.rxjava.schedulers.ignoredthreads属性。


### 3.5 messaging

Spring Cloud Sleuth本身就整合了Spring Integration。它发布/订阅事件都是会创建span。可以设置spring.sleuth.integration.enabled=false来禁用这个机制。

## 4、基本概念

因为sleuth是根据google的dapper论文而来的，所以用的术语和dapper一样。

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/20.png)


### 4.1术语

* span：最基本的工作单元。由spanId来标志。Span也可以带有其他数据，例如：描述，时间戳，键值对标签，起始Span的ID，以及处理ID（通常使用IP地址）等等。 Span有起始和结束，他们跟踪着时间信息。span应该都是成对出现的，所以一旦创建了一个span，那就必须在未来某个时间点结束它。起始的span通常被称为：root span。它的id通常也被作为一个跟踪记录的id。
* traceId：一个树结构的span集合。把相同traceId的span串起来。
* annotation：用于记录一个事件时间信息。
** cs：client send。客户端发送，一个span的开始
** cr：client receive。客户端接收。一个span的结束
** ss：server send。服务器发送
** sr：server receive。服务器接收，开始处理。
** sr-cs和cr-ss:表示网络传输时长
** ss-sr:表示服务端处理请求的时长
** cr-cs:表示请求的响应时长

### 4.2采样率

如果服务的流量很大，全部采集对存储压力比较大。这个时候可以设置采样率，sleuth 可以通过设置 spring.sleuth.sampler.percentage=0.1。不配置的话，默认采样率是0.1。也可以通过实现bean的方式来设置采样为全部采样(AlwaysSampler)或者不采样(NeverSampler)：如

```java
@Bean public Sampler defaultSampler() {
	return new AlwaysSampler();
}
```

sleuth采样算法的实现是 Reservoir sampling（水塘抽样）。实现类是 PercentageBasedSampler。

### 4.3 traceId和spanId的生成问题

traceId和spanId的生成,sleuth是通过java 的Random类的nextLong方法生成的。这样的话就存在traceId存在一样的情况，不知道为什么要这么设计。


## 参考资料
* http://cloud.spring.io/spring-cloud-sleuth/spring-cloud-sleuth.html
* zipkin github地址
* https://github.com/openzipkin/zipkin/issues/
* spring cloud 中国社区



