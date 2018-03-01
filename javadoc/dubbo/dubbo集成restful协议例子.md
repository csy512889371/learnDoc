# dubbo集成restful协议例子

## 一、代码地址

https://github.com/csy512889371/learndemo/tree/master/ctoedu-dubbo

* dubbo-learn-parent 父类
* dubbo-learn-config 配置
* dubbo-learn-facade 实体类与接口
* dubbo-learn-oauth 待续（接口认证）
* dubbo-learn-service 服务提供者
* dubbo-learn-web-service 服务消费者和rest服务提供者

## 二、基于dubbo协议的配置说明

### 1、消息提供者

dubbo-provider.xml


* 只订阅
* 只注册
* 协议选择: dubbo\rmi\http\webservice\thrift
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:dubbo="http://code.alibabatech.com/schema/dubbo"
	xsi:schemaLocation="http://www.springframework.org/schema/beans  
            http://www.springframework.org/schema/beans/spring-beans.xsd  
            http://code.alibabatech.com/schema/dubbo  
            http://code.alibabatech.com/schema/dubbo/dubbo.xsd">  
   
   <!-- 只订阅 -->
   <!--<dubbo:registry address="10.20.153.10:9090" register="false" /> -->
   

   <!-- 只注册 -->
   <!-- 如果有两个镜像环境，两个注册中心，有一个服务只在其中一个注册中心有部署，另一个注册中心还没来得及部署，
   而两个注册中心的其它应用都需要依赖此服务。这个时候，可以让服务提供者方只注册服务到另一注册中心，而不从另一注册中心订阅服务。-->
   <!-- <dubbo:registry id="hzRegistry" address="10.20.153.10:9090" />
        <dubbo:registry id="qdRegistry" address="10.20.141.150:9090" subscribe="false" /> -->
    <dubbo:service interface="com.ctoedu.learn.repo.IEnterpriseService" ref="enterpriseService"  protocol="dubbo"/>
    <dubbo:service interface="com.ctoedu.learn.repo.IProductService" ref="productService"  protocol="dubbo"/>
    <dubbo:service interface="com.ctoedu.learn.repo.IEnterpriseMongoService" ref="enterpriseMongoService"  protocol="dubbo"/>
    <dubbo:service interface="com.ctoedu.learn.repo.IProductMongoService" ref="productMongoService"  protocol="dubbo"/>

 <!-- ****************协议选择讲解***************************************** -->
 
  <!-- dubbo://
   	Dubbo缺省协议采用单一长连接和NIO异步通讯，适合于小数据量大并发的服务调用，以及服务消费者机器数远大于服务提供者机器数的情况。
	Dubbo缺省协议不适合传送大数据量的服务，比如传文件，传视频等，除非请求量很低。
	<dubbo:protocol name="dubbo" port="20884" />
	连接个数：单连接
    连接方式：长连接
    传输协议：TCP
    传输方式：NIO异步传输
    序列化：Hessian二进制序列化
    适用范围：传入传出参数数据包较小（建议小于100K），消费者比提供者个数多，单一消费者无法压满提供者，尽量不要用dubbo协议传输大文件或超大字符串。
    适用场景：常规远程服务方法调用
   -->
  <!--rmi://
     RMI协议采用JDK标准的java.rmi.*实现，采用阻塞式短连接和JDK标准序列化方式。
     <dubbo:protocol name="rmi"port="1099"/>  
     连接个数：多连接
     连接方式：短连接
     传输协议：TCP
     传输方式：同步传输
     序列化：Java标准二进制序列化
     适用范围：传入传出参数数据包大小混合，消费者与提供者个数差不多，可传文件。
     适用场景：常规远程服务方法调用，与原生RMI服务互操作
    -->
  <!-- hessian:// 
     Hessian协议用于集成Hessian的服务，Hessian底层采用Http通讯，采用Servlet暴露服务，Dubbo缺省内嵌Jetty作为服务器实现。
     <dubbo:protocol name="hessian" port="8080" server="jetty"/>  
     连接个数：多连接
     连接方式：短连接
     传输协议：HTTP
     传输方式：同步传输
     序列化：Hessian二进制序列化
     适用范围：传入传出参数数据包较大，提供者比消费者个数多，提供者压力较大，可传文件。
     适用场景：页面传输，文件传输，或与原生hessian服务互操作
     
     依赖：
     <dependency>  
       <groupId>com.caucho</groupId>  
        <artifactId>hessian</artifactId>  
        <version>4.0.7</version>  
     </dependency>  
     web.xml配置：如果使用server="servlet"如要做配置
     <servlet>  
         <servlet-name>dubbo</servlet-name>  
         <servlet-class>com.alibaba.dubbo.remoting.http.servlet.DispatcherServlet</servlet-class>  
         <load-on-startup>1</load-on-startup>  
       </servlet>  
        <servlet-mapping>  
            <servlet-name>dubbo</servlet-name>  
             <url-pattern>/*</url-pattern>   
        </servlet-mapping>  
   -->
  <!--http://
     采用Spring的HttpInvoker实现
     <dubbo:protocol name="http" port="8080"/>  
     连接个数：多连接
     连接方式：短连接
     传输协议：HTTP
     传输方式：同步传输
     序列化：表单序列化
     适用范围：传入传出参数数据包大小混合，提供者比消费者个数多，可用浏览器查看，可用表单或URL传入参数，暂不支持传文件。
     适用场景：需同时给应用程序和浏览器JS使用的服务。    
    -->
  <!-- webservice://
  	2.3.0以上版本支持。
	基于CXF的frontend-simple和transports-http实现。
    <dubbo:protocol name="webservice"port="8080"server="jetty"/>  
    依赖：
    <dependency>  
      <groupId>org.apache.cxf</groupId>  
      <artifactId>cxf-rt-frontend-simple</artifactId>  
      <version>2.6.1</version>  
    </dependency>  
   <dependency>  
      <groupId>org.apache.cxf</groupId>  
      <artifactId>cxf-rt-transports-http</artifactId>  
      <version>2.6.1</version>  
    </dependency>  
    连接个数：多连接
    连接方式：短连接
    传输协议：HTTP
    传输方式：同步传输
    序列化：SOAP文本序列化
    适用场景：系统集成，跨语言调用。
   -->
   
   <!-- thrift://
   	Thrift说明:Thrift是Facebook捐给Apache的一个RPC框架
   	依赖：
   	<dependency>  
      <groupId>org.apache.thrift</groupId>  
       <artifactId>libthrift</artifactId>  
       <version>0.8.0</version>  
    </dependency  
    
   	<dubbo:protocol name="thrift"port="3030"/>  
    -->
    
    <!-- memcached://
    	Memcached说明:Memcached是一个高效的KV缓存服务器
     -->
    <!-- redis://
        Redis说明:Redis是一个高效的KV存储服务器
     -->
</beans>
```

### 2、消费者

dubbo-consumer-dev.xml

* 启动时检查
* 集群容错
* 负载均衡
* 配置直连

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:dubbo="http://code.alibabatech.com/schema/dubbo"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd  
        http://code.alibabatech.com/schema/dubbo  
        http://code.alibabatech.com/schema/dubbo/dubbo.xsd">

	<dubbo:application name="dubbo-learn-web" />

	<dubbo:registry protocol="zookeeper" address="10.211.55.7:2181" />
    <!--***********讲解启动时检查**********-->
    <!--Dubbo缺省会在启动时检查依赖的服务是否可用，不可用时会抛出异常，阻止Spring初始化完成，以便上线时，能及早发现问题，默认check="true"  -->
    <!-- 不启动service服务，直接启动web，演示报错问题 -->
    <!--  dubbo.properties可以直接配置：dubbo.reference.check=false 强制改变所有 reference 的 check 值，就算配置中有声明，也会被覆盖。 -->

    <!-- ********讲解集群容错*************** -->
    <!-- 在集群调用失败时，Dubbo 提供了多种容错方案，缺省为 failover 重试。 -->
    <!--Failover Cluster: 失败自动切换，当出现失败，重试其它服务器 1。通常用于读操作，但重试会带来更长延迟。可通过 retries="2" 来设置重试次数(不含第一次)。 -->
    <!-- Failfast Cluster:快速失败，只发起一次调用，失败立即报错。通常用于非幂等性的写操作，比如新增记录。 -->
    <!-- Failsafe Cluster:失败安全，出现异常时，直接忽略。通常用于写入审计日志等操作。 -->
    <!-- Failback Cluster:失败自动恢复，后台记录失败请求，定时重发。通常用于消息通知操作。 -->
    <!-- Forking Cluster:并行调用多个服务器，只要一个成功即返回。通常用于实时性要求较高的读操作，但需要浪费更多服务资源。可通过 forks="2" 来设置最大并行数。 -->
    <!-- Broadcast Cluster:广播调用所有提供者，逐个调用，任意一台报错则报错 2。通常用于通知所有提供者更新缓存或日志等本地资源信息。 -->

    <!-- **********讲解负载均衡************** -->
    <!--在集群负载均衡时，Dubbo 提供了多种均衡策略，缺省为 random 随机调用。  -->
    <!-- Random LoadBalance:随机，按权重设置随机概率。在一个截面上碰撞的概率高，但调用量越大分布越均匀，而且按概率使用权重后也比较均匀，有利于动态调整提供者权重。-->
    <!--RoundRobin LoadBalance：轮循，按公约后的权重设置轮循比率。存在慢的提供者累积请求的问题，比如：第二台机器很慢，但没挂，当请求调到第二台时就卡在那，久而久之，所有请求都卡在调到第二台上。  -->
    <!-- LeastActive LoadBalance:最少活跃调用数，相同活跃数的随机，活跃数指调用前后计数差,慢的提供者收到更少请求，因为越慢的提供者的调用前后计数差会越大 -->
    <!-- ConsistentHash LoadBalance:一致性 Hash，相同参数的请求总是发到同一提供者,当某一台提供者挂时，原本发往该提供者的请求，基于虚拟节点，平摊到其它提供者，不会引起剧烈变动。 -->


	<dubbo:reference interface="com.ctoedu.learn.repo.IEnterpriseService" id="enterpriseService" timeout="10000" check="false"  cluster="failover" retries="2" loadbalance="random"/>
    <dubbo:reference interface="com.ctoedu.learn.repo.IProductService" id="productService" timeout="10000" check="false"  cluster="failover" retries="2" loadbalance="random"/>
    <dubbo:reference interface="com.ctoedu.learn.repo.IEnterpriseMongoService" id="enterpriseMongoService" timeout="10000" check="false"  cluster="failover" retries="2" loadbalance="random"/>
    <dubbo:reference interface="com.ctoedu.learn.repo.IProductMongoService" id="productMongoService" timeout="10000" check="false"  cluster="failover" retries="2" loadbalance="random"/>

	<!--*********** 配置直连**************** -->
	<!-- 在开发及测试环境下，经常需要绕过注册中心，只测试指定服 务提供者，这时候可能需要点对点直连，点对点直联方式，
	      将以服务接口为单位，忽略注册中心的提供者列表，A 接口配置点对点，不影响 B 接口从注册中心获取列表。 -->
	<!-- 如果是线上需求需要点对点，可在 <dubbo:reference> 中配置 url 指向提供者，将绕过注册中心，多个地址用分号隔开，配置如下: -->
<!-- 		<dubbo:reference interface="com.ctoedu.learn.repo.IEnterpriseService" id="enterpriseService" timeout="10000" check="false" url="dubbo://localhost:20884" />
 -->
</beans>  
```


web.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>  
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:web="http://xmlns.jcp.org/xml/ns/javaee" xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd">

    <display-name>Archetype Created Web Application</display-name>  
   
	<context-param>
		<param-name>spring.profiles.active</param-name>
		 <param-value>dev</param-value>
	</context-param>
  

    <listener>
        <listener-class>com.alibaba.dubbo.remoting.http.servlet.BootstrapListener</listener-class>
    </listener>

    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>

    <servlet>
        <servlet-name>dis</servlet-name>
        <servlet-class>com.alibaba.dubbo.remoting.http.servlet.DispatcherServlet</servlet-class>
        <load-on-startup>1</load-on-startup>
    </servlet>

    <servlet-mapping>
        <servlet-name>dis</servlet-name>
        <url-pattern>/*</url-pattern>
    </servlet-mapping>
    
      <servlet>
    <servlet-name>dispatcher</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <load-on-startup>1</load-on-startup>
  </servlet>
  <servlet-mapping>
    <servlet-name>dispatcher</servlet-name>
    <url-pattern>/oauth/token</url-pattern>
  </servlet-mapping>
  
    <context-param>  
        <param-name>contextConfigLocation</param-name>  
        <param-value>classpath:spring/spring-context.xml</param-value>  
    </context-param>  
    
    <filter>
       <filter-name>springSecurityFilterChain</filter-name>
       <filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
    </filter>
    <filter-mapping>
       <filter-name>springSecurityFilterChain</filter-name>
       <url-pattern>/*</url-pattern>
    </filter-mapping>
   <!-- 
    <filter>  
        <filter-name>encodingFilter</filter-name>  
        <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>  
        <async-supported>true</async-supported>  
        <init-param>  
            <param-name>encoding</param-name>  
            <param-value>UTF-8</param-value>  
        </init-param>  
    </filter>  
    <filter-mapping>  
        <filter-name>encodingFilter</filter-name>  
        <url-pattern>/*</url-pattern>  
    </filter-mapping>  
    Spring监听器  
    <listener>  
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>  
    </listener>  
    防止Spring内存溢出监听器  
    <listener>  
        <listener-class>org.springframework.web.util.IntrospectorCleanupListener</listener-class>  
    </listener>  
  
    Spring MVC servlet  
    <servlet>  
        <servlet-name>SpringMVC</servlet-name>  
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>  
        <init-param>  
            <param-name>contextConfigLocation</param-name>  
            <param-value>classpath:spring/spring-mvc.xml</param-value>  
        </init-param>  
        <load-on-startup>1</load-on-startup>  
        <async-supported>true</async-supported>  
    </servlet>  
    <servlet-mapping>  
        <servlet-name>SpringMVC</servlet-name>  
        此处可以可以配置成*.do，对应struts的后缀习惯  
        <url-pattern>/</url-pattern>  
    </servlet-mapping>  
    <welcome-file-list>  
        <welcome-file>/index.jsp</welcome-file>  
    </welcome-file-list>  
   -->
</web-app>  
```

## 三、基于restful协议的配置说明
dubbo-provider.xml

* 线程模型


```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:dubbo="http://code.alibabatech.com/schema/dubbo"
	xsi:schemaLocation="http://www.springframework.org/schema/beans  
        http://www.springframework.org/schema/beans/spring-beans.xsd  
        http://code.alibabatech.com/schema/dubbo  
        http://code.alibabatech.com/schema/dubbo/dubbo.xsd">
   
	<!-- **********讲解线程模型 **************-->
	<!--如果事件处理的逻辑能迅速完成，并且不会发起新的 IO 请求，比如只是在内存中记个标识，则直接在 IO 线程上处理更快，因为减少了线程池调度。
        但如果事件处理逻辑较慢，或者需要发起新的 IO 请求，比如需要查询数据库，则必须派发到线程池，否则 IO 线程阻塞，将导致不能接收其它请求。  -->
    <!-- Dispatcher
           all 所有消息都派发到线程池，包括请求，响应，连接事件，断开事件，心跳等。
           direct 所有消息都不派发到线程池，全部在 IO 线程上直接执行。
           message 只有请求响应消息派发到线程池，其它连接断开事件，心跳等消息，直接在 IO 线程上执行。
           execution 只请求消息派发到线程池，不含响应，响应和其它连接断开事件，心跳等消息，直接在 IO 线程上执行。
           connection 在 IO 线程上，将连接断开事件放入队列，有序逐个执行，其它消息派发到线程池。
        ThreadPool
          fixed 固定大小线程池，启动时建立线程，不关闭，一直持有。(缺省)
          cached 缓存线程池，空闲一分钟自动删除，需要时重建。
          limited 可伸缩线程池，但池中的线程数只会增长不会收缩。只增长不收缩的目的是为了避免收缩时突然来了大流量引起的性能问题。 -->
	<dubbo:protocol name="rest" contextpath="dubbo-learn-web-service" port="8080" server="servlet" dispatcher="all" threadpool="fixed" threads="100" />
	
    <dubbo:service interface="com.ctoedu.learn.restservice.IEnterpriseRestService"  ref="enterpriseRestService"  protocol="rest" validation="true"/>
        <dubbo:service interface="com.ctoedu.learn.restservice.IProductRestService"  ref="productRestService"  protocol="rest" validation="true"/>
        <dubbo:service interface="com.ctoedu.learn.restservice.IEnterpriseMongoRestService"  ref="enterpriseMongoRestService"  protocol="rest" validation="true"/>
            <dubbo:service interface="com.ctoedu.learn.restservice.IProductMongoRestService"  ref="productMongoRestService"  protocol="rest" validation="true"/>
    
</beans>
```

实现类: EnterpriseRestServiceImpl
```xml
package com.ctoedu.learn.restservice.impl;

import com.alibaba.dubbo.rpc.protocol.rest.support.ContentType;
import com.ctoedu.learn.mybatis.domain.Enterprise;
import com.ctoedu.learn.repo.IEnterpriseService;
import com.ctoedu.learn.restservice.IEnterpriseRestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;

@Path("/")
//@Consumes({ MediaType.APPLICATION_JSON, MediaType.TEXT_XML, MediaType.APPLICATION_FORM_URLENCODED })
//@Produces({ ContentType.APPLICATION_JSON_UTF_8, ContentType.TEXT_XML_UTF_8 })
@Consumes({MediaType.APPLICATION_JSON, MediaType.TEXT_XML})
@Produces({ContentType.APPLICATION_JSON_UTF_8, ContentType.TEXT_XML_UTF_8})
@Service("enterpriseRestService")
public class EnterpriseRestServiceImpl implements IEnterpriseRestService {
   
	@Autowired
	IEnterpriseService enterpriseService;

	@Path("/getenterprise/{id}")
	@GET
	public Enterprise getEnterpriseById(@PathParam("id") int id) {
		return enterpriseService.getEnterpriseById(id);
	}
	@Path("/insertenterprise")
	@POST
	public void insertEnterprise(@RequestBody Enterprise enterprise) {
		// TODO Auto-generated method stub
	
		enterpriseService.insertEnterprise(enterprise);
	}
	@Path("/getstring/{name}")
	@GET
	public String getString(@PathParam("name") String name) {
		return name;
	}
	@Path("/deleteenterprise/{id}")
	@DELETE
	public void deleteEnterprise(@PathParam("id") int enterpriseId) {
		enterpriseService.deleteEnterprise(enterpriseId);
	}

}

```
