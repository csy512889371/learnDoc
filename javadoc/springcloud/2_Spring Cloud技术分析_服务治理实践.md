# 2_Spring Cloud技术分析_服务治理实践


## 一、概述

Spring Cloud的服务发现一共三个角色，如下图：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/12.png)

接下来我们按照这三个角色来介绍Netflix的实际使用（本篇介绍的配置基于Spring Boot 1.5.2.RELEASE版本和Spring Cloud Camden.SR6版本）。

## 二、Eureka Server配置

新建一个Spring Boot工程，添加如下Maven依赖

```java
<dependencyManagement>
   <dependencies>
      <dependency>
         <groupId>org.springframework.cloud</groupId>
         <artifactId>spring-cloud-dependencies</artifactId>
         <version>Camden.SR6</version>
         <type>pom</type>
         <scope>import</scope>
      </dependency>
   </dependencies>
</dependencyManagement>
 
 
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-eureka-server</artifactId>
</dependency>
```

在项目的application.properties添加配置:

```xml

//eureka server注册的name，唯一标识
spring.application.name=eureka-server
//eureka server服务的端口号
server.port=1111
```

在启动类上加入@EnableEurekaServer注解：

```java
@EnableEurekaServer
@SpringBootApplication
public class ApplicationDemo
{
	public static void main(String[] args)
	{
	   SpringApplication.run(ApplicationDemo.class, args);
	}
}
```

运行，访问http://localhost:1111/， 出现以下页面，则证明启动成功：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/13.png)


如果需要配置Eureka高可用集群，则可以通过相互注册的方式来实现。

接下来我们在本地启动，配置多个application，例如创建application-peer1和application-peer2。



application-peer1配置如下：

```xml
server.port=1111
eureka.instance.hostname= peer1
spring.application.name=eureka-server
eureka.client.serviceUrl.defaultZone=http://peer2:1112/eureka/

```

application-peer2配置如下：

```xml
server.port=1112
eureka.instance.hostname= peer2
spring.application.name=eureka-server
eureka.client.serviceUrl.defaultZone=http://peer1:1111/eureka/

```

配本地host：

```java
127.0.0.1 peer1 peer2

```

运行mvn install，分别启动peer1和peer2：

```java
java -jar eureka.jar --spring.profiles.active=peer1
java -jar eureka.jar --spring.profiles.active=peer2

```


访问http://peer1:1111/ 或者 http://peer2:1112/ ，即可看到两个实例已经相互注册：


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/14.png)

输入http://peer1:1111/eureka/apps ， 即可看到每个实例的详细信息：


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/15.png)


由于在线环境的发布脚本是统一的，可以采用相同配置在多台机器上部署的方式，例如我们有10.120.163.1和10.120.163.2这两台机器。其application.properties配置如下：

```xml
server.port=1111
spring.application.name=eureka-server
eureka.client.serviceUrl.defaultZone=http://10.120.163.01:1111/eureka/,http://10.120.163.02:1111/eureka/

```

然后在10.120.163.1和10.120.163.2两台机器上分别运行这个服务，访问http://10.120.163.1:1111/ 即可看到Eureka页面。


## 三、线上问题：Eureka Server间无法同步数据


请注意，Eureka Server相互注册后可能出现无法同步数据的情况。具体表现是每个Eureka Server上的续约数都不一样，同时在General Info标签下别的Eureka Server显示为”unavailable-replicas”。

这是因为Eureka通过serviceUrl.defaultZone解析到副本的hostname，与实例互相注册时的hostname对比，来判断副本是不是available。而我们application.properties的配置是：

```java
eureka.client.serviceUrl.defaultZone=http://common-eureka1:1111/,http://common-eureka2:1111/
```

这就导致Eureka认为这两个Server的hosts应该是common-eureka1和common-eureka2。但实际上，这两台机器的hostname配置却是hz-kfk-01和hz-kfk-02，这就导致Eureka Server相互注册时使用的hostname也是hz-kfk-01和hz-kfk-02。因此，这两台Eureka Server被判定为unavailable。

解决这个问题的方式是保证配置和机器实际的hostname配置一致。实际上，我们也可以配置eureka.instance.preferIpAddress=true来保证Eureka Server相互注册时hostname使用IP地址，同时使用IP地址作为eureka.client.serviceUrl.defaultZone的配置值

## 四、Service Provider配置

服务提供者者需要在Eureka注册自己的信息，首先要保证上面例子中Eurek Server的peer1和peer2正常运行。

新建一个Spring Boot工程，添加如下Maven依赖：


```xml
<dependencyManagement>
   <dependencies>
       <dependency>
           <groupId>org.springframework.cloud</groupId>
           <artifactId>spring-cloud-dependencies</artifactId>
           <version>Camden.SR6</version>
           <type>pom</type>
           <scope>import</scope>
       </dependency>
   </dependencies>
</dependencyManagement>
 
<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-starter-eureka</artifactId>
</dependency>
```

配置application.properties：

```xml
#Service Provider服务的端口号
server.port=2222
#Service Provider注册的name，唯一标识
spring.application.name=service-provider
#指定注册的Eureka Server地址
eureka.client.serviceUrl.defaultZone=http://peer:1111/eureka,http://peer:1112/eureka
```

提供一个基于SpringMVC的Rest接口：

```java
@RestController
public class IndexController
{
	@RequestMapping("/index")
	public String index()
	{
	   return "这里是Service Provider";
	}
}
```

在启动类上加入@EnableDiscoveryClient注解：

```java

@EnableDiscoveryClient
@SpringBootApplication
public class ApplicationDemo
{
	public static void main(String[] args)
	{
	    SpringApplication.run(ApplicationDemo.class, args);
	}
}
```

运行，即可在http://peer1:1111/ 看到这个Service Provider的注册信息：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/16.png)


## 五、Service Consumer配置


首先要保证Eureka Server的peer1和peer2正常运行，Service Provider正常运行，并注册到Eureka Server上。本节主要介绍Spring Cloud Feign客户端配置。

同样新建一个Spring Boot工程，添加如下Maven依赖：


```xml
<dependencyManagement>
   <dependencies>
       <dependency>
           <groupId>org.springframework.cloud</groupId>
           <artifactId>spring-cloud-dependencies</artifactId>
           <version>Camden.SR6</version>
           <type>pom</type>
           <scope>import</scope>
       </dependency>
   </dependencies>
</dependencyManagement>
 
<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-starter-eureka</artifactId>
</dependency>
<dependency>
   <groupId>org.springframework.cloud</groupId>
   <artifactId>spring-cloud-starter-feign</artifactId>
</dependency>
```

配置application.properties：

```xml
#Service Consumer服务的端口号
server.port=3333
#Service Consumer注册的name，唯一标识
spring.application.name=service-consumer
#指定注册的Eureka Server地址
eureka.client.serviceUrl.defaultZone=http://peer:1111/eureka,http://peer:1112/eureka
```

接下来配置Feign+Ribbon+Hystrix，消费上面Service Provider提供的服务。请注意，因为Spring Cloud的封装，我们几乎不需要关心Ribbon和Hystrix的细节，只需要进行Feign的配置即可。

首先我们在启动类上加入@EnableDiscoveryClient和@EnableFeignClients来开启Eureka Client和Feign的相关功能：


```java

@EnableFeignClients
@EnableDiscoveryClient
@SpringBootApplication
public class ApplicationDemo
{
	public static void main(String[] args)
	{
	    SpringApplication.run(ApplicationDemo.class, args);
	}
}
```


然后我们创建一个interface，由Spring Cloud根据这个interface创建可供程序直接调用的代理类。为了完成代理，我们需要添加一些注解，其中@FeignClient中的name为Service Provider的application.properties中配置的spring.application.name，fallback为Hystrix降级处理类（当调用触发熔断时会调用该类的方法，不配时表示不启用熔断回退）。而@RequestMapping就是SpringMVC的注解，对应服务方提供的接口：


```java

//Consumer接口
@FeignClient(name = "service-provider", fallback = ConsumerFallback.class)
public interface Consumer
{
	@RequestMapping(value = "/index")
	String index();
}


//ConsumerFallback类，实现Consumer接口
@Component
public class ConsumerFallback implements Consumer
{
	@Override
	public String index()
	{
	   return "Feign客户端访问失败";
	}
}
```


接下来，像正常的Spring bean一样调用即可：

```java

@Autowired
private Consumer consumer
//...
consumer.index()
```


## 六、在非Spring Boot环境下配置Eureka Service Provider

对于一些老系统而言，进行Spring Boot的改造可能牵涉甚广。但是当周边系统被改造成基于Spring Cloud的微服务后，这些老系统也存在集成Eureka去提供和调用REST服务的诉求。所以我们简单研究了一下如何在非Spring Boot应用中集成原生的Eureka Client。

首先，添加Maven依赖：

```xml
<dependency>
    <groupId>com.netflix.eureka</groupId>
    <artifactId>eureka-client</artifactId>
    <version>1.4.12</version>
</dependency>
<dependency>
    <groupId>com.netflix.archaius</groupId>
    <artifactId>archaius-core</artifactId>
    <version>0.7.3</version>
</dependency>
```

然后是配置文件（必须起名eureka-client.properties，放在classpath中才能被eureka感知到）：

```xml
#Eureka Server的地址（对应zone的名称为default）
eureka.serviceUrl.default=http://common1-o1.eureka.s:1111/eureka/,http://common2-o2.eureka.s:1111/eureka/,http://common3-o3.eureka.s:1111/eureka/
#应用名称
eureka.name=xxname
#Virtual IP Address，这也是一个应用的标识符，类似于域名
eureka.vipAddress=xxaddress
#服务端口
eureka.port=8006
```


代码如下：

```java

@Component
public class EurekaRegister
{
	private final static Logger LOG = Logger.getLogger(AdminEurekaRegister.class);

	private ApplicationInfoManager applicationInfoManager;
	private EurekaClient eurekaClient;

	@PostConstruct
	public void init()
	{
		//初始化应用信息管理器，设置其状态为STAERTING
                applicationInfoManager = initializeApplicationInfoManager(new MyDataCenterInstanceConfig());
                applicationInfoManager.setInstanceStatus(InstanceInfo.InstanceStatus.STARTING);
		LOG.info("Registering service to eureka with STARTING status");

                //读取配置文件，初始化eurekaClient，并设置应用信息管理器的状态为UP
		configInstance = DynamicPropertyFactory.getInstance();
		eurekaClient = initializeEurekaClient(applicationInfoManager, new DefaultEurekaClientConfig());
		applicationInfoManager.setInstanceStatus(InstanceInfo.InstanceStatus.UP);
		LOG.info("Initialization finished, now changing eureka client status to UP");
	}

	@PreDestroy
	public void stop()
	{
		if (eurekaClient != null)
		{
			LOG.info("Shutting down eureka service.");
			eurekaClient.shutdown();
		}
	}

	//初始化应用信息管理器
    private synchronized ApplicationInfoManager initializeApplicationInfoManager(EurekaInstanceConfig instanceConfig)
	{
		if (applicationInfoManager == null)
		{
			InstanceInfo instanceInfo = new EurekaConfigBasedInstanceInfoProvider(instanceConfig).get();
			applicationInfoManager = new ApplicationInfoManager(instanceConfig, instanceInfo);
		}
		return applicationInfoManager;
	}

	//初始化EurekaClient
    private synchronized EurekaClient initializeEurekaClient(ApplicationInfoManager applicationInfoManager, EurekaClientConfig clientConfig)
	{
		if (eurekaClient == null)
			eurekaClient = new DiscoveryClient(applicationInfoManager, clientConfig);
		return eurekaClient;
	}
}
```

其实很简单，就是初始化一个ApplicationInfoManager和EurekaClient，剩下的注册和续约细节会由EurekaClient接管。但是这样注册上去后，服务消费者通过REST接口访问该服务还是会报异常。分析堆栈，我们发现Service Consumer获取的Service Provider的地址信息中只有域名，而Service Consumer本地并没有配置这个域名的解析，所以调用异常了。我们并不想增加过多的域名解析环节，所以最好的方案是让Service Provider使用IP地址而不是域名来注册。


研究Eureka源码后，我们发现Eureka本身获取并告知Eureka Server的域名是服务器本地配置的hostname，而Spring Cloud注册的服务对这点做了改进，提供了eureka.instance.preferIpAddress这个参数来允许IP地址注册。但Eureka本身并没有提供这个功能，所以我们要进行一些简单的改进：


创建一个新的服务实例配置类，并继承自MyDataCenterInstanceConfig：


```java

@Singleton
@ProvidedBy(MyDataCenterInstanceConfigProvider.class)
public class CustomInstanceConfig extends MyDataCenterInstanceConfig implements EurekaInstanceConfig
{
	@Override
	public String getHostName(boolean refresh)
	{
		try
		{
		    //获取ip地址作为hostName
                    return InetAddress.getLocalHost().getHostAddress();
		}
		catch (UnknownHostException e)
		{
			return super.getHostName(refresh);
		}
	}
}
```

再把初始化ApplicationInfoManager类使用的MyDataCenterInstanceConfig改成CustomInstanceConfig即可：

```java
applicationInfoManager = initializeApplicationInfoManager(new AdminInstanceConfig());
````

这样，我们就能够在其他应用中消费这个服务了。

更多信息请参考：
https://github.com/Netflix/eureka/wiki


## 七、在非Spring Boot环境下配置Eureka Service Consumer

在非Spring Boog环境下配置Eureka Service Consumer，其实就是原生集成Feign+Ribbon+hystrix。

首先，请按照附录1所述配置Eureka Client。不过，在服务注册的时候，还需要将初始化好的EurekaClient注册到Eureka的DiscoveryManager中去：

```java
eurekaClient = initializeEurekaClient(applicationInfoManager, new DefaultEurekaClientConfig());
DiscoveryManager.getInstance().setDiscoveryClient((DiscoveryClient) eurekaClient);
```

第二，添加如下Maven依赖（feign-ribbon依赖的rxjava版本过低，会影响feign-hystrix的使用，所以需要exclude）：

```xml
<dependency>
    <groupId>io.github.openfeign</groupId>
    <artifactId>feign-ribbon</artifactId>
    <version>9.4.0</version>
    <exclusions>
    	<exclusion>
    		<artifactId>rxjava</artifactId>
    		<groupId>io.reactivex</groupId>
        </exclusion>
    </exclusions>
</dependency>
<dependency>
    <groupId>io.github.openfeign</groupId>
    <artifactId>feign-hystrix</artifactId>
    <version>9.4.0</version>
</dependency>
<dependency>
    <groupId>com.netflix.ribbon</groupId>
    <artifactId>ribbon-eureka</artifactId>
    <version>2.2.2</version>
</dependency>
```

第三，配置参数。其中xxx表示调用端的client名称。

```xml
#ribbon loadbalancer的实现类
xxx.ribbon.NFLoadBalancerClassName=com.netflix.loadbalancer.DynamicServerListLoadBalancer
#ribbon ServerList的实现类
xxx.ribbon.NIWSServerListClassName=com.netflix.niws.loadbalancer.DiscoveryEnabledNIWSServerList 
#调用服务的VipAddress，与eureka.vipAddress的参数值对应
xxx.ribbon.DeploymentContextBasedVipAddresses=xxxx
```


第四，编写调用接口。注意，这个接口使用了Feign的原生注解，Feign不区分PathVariable和RequestParam，统一用@Param和{}占位符来表示参数。同时返回值也支持对象、List或者Map的形式。具体更详细的接口书写规则，比如参数格式转换、动态查询参数，可以参考https://github.com/OpenFeign/feign/blob/master/README.md 。


```java
import feign.Param;
import feign.RequestLine;

public interface QueryXXXInterface
{
	@RequestLine("GET xxx/{param}/currentValue")
	public String getXXXCurrentValue(@Param("param") String param);
}
```

第五，调用接口。其实就是初始化接口再调用就行了，其中http://xxx中的xxx对应上文配置中的Client名称。

```java
QueryXXXInterface queryXXXInterface = HystrixFeign.builder().client(RibbonClient.create()).target(QueryXXXInterface.class, "http://xxx");
queryPeriodInterface.getXXXCurrentValue(param);
```

如果需要使用Hystrix的Fallback功能，可以这么写：

```java

QueryXXXInterface queryXXXInterface = HystrixFeign.builder().client(RibbonClient.create()).target(QueryXXXInterface.class, "http://xxx",new QueryXXXInterface() {
	@Override
	public String getXXXCurrentValue(String param){
		return "123";
	}
});
queryXXXInterface.getXXXCurrentValue(param);
```

## 八、更多信息请参考：

https://github.com/OpenFeign/feign/blob/master/hystrix/README.md
https://github.com/OpenFeign/feign/blob/master/ribbon/README.md
https://github.com/Netflix/ribbon/wiki/Getting-Started
https://github.com/Netflix/ribbon/wiki/Working-with-load-balancers




