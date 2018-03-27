# 5_Spring Cloud技术分析- spring cloud config

在分布式系统中，spring cloud config 提供一个服务端和客户端去提供可扩展的配置服务。我们可用用配置服务中心区集中的管理所有的服务的各种环境配置文件。配置服务中心采用Git的方式存储配置文件，因此我们很容易部署修改，有助于对环境配置进行版本管理。

## 一、简介

**为什么要配置中心**

一个应用中不只是代码,还需要连接资源和其它应用,经常有很多需要外部设置的项去调整应用行为,如切换不同的数据库，设置功能开关等。

随着系统微服务的不断增加，首要考虑的是系统的可伸缩、可扩展性好，随之就是一个配置管理的问题。各自管各自的开发时没什么问题，到了线上之后管理就会很头疼，到了要大规模更新就更烦了。配置中心就是一个比较好的解决方案，下图就是一个配置中心的解决方案：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/25.png)

### 1.1 常见的配置中心的实现方法有

```
a.硬编码(缺点:需要修改代码,风险大)
b.放在xml等配置文件中,和应用一起打包(缺点:需要重新打包和重启)
c.文件系统中(缺点:依赖操作系统等)
d.环境变量(缺点:有大量的配置需要人工设置到环境变量中,不便于管理,且依赖平台)
e.云端存储(缺点:与其他应用耦合)

```
### 1.2 什么是spring cloud config

在分布式系统中，spring cloud config 提供一个服务端和客户端去提供可扩展的配置服务。我们可用用配置服务中心区集中的管理所有的服务的各种环境配置文件。配置服务中心采用Git的方式存储配置文件，因此我们很容易部署修改，有助于对环境配置进行版本管理。

Spring Cloud Config就是云端存储配置信息的,它具有中心化,版本控制,支持动态更新,平台独立,语言独立等特性。其特点是：


```

a.提供服务端和客户端支持(spring cloud config server和spring cloud config client)
b.集中式管理分布式环境下的应用配置
c.基于Spring环境，无缝与Spring应用集成
d.可用于任何语言开发的程序
e.默认实现基于git仓库，可以进行版本管理
f.可替换自定义实现
```

### 1.3 spring cloud config的结构是什么?

spring cloud config包括两部分：

* spring cloud config server 作为配置中心的服务端

```
拉取配置时更新git仓库副本，保证是最新结果
支持数据结构丰富，yml, json, properties 等
配合 eureke 可实现服务发现，配合 cloud bus 可实现配置推送更新
配置存储基于 git 仓库，可进行版本管理
简单可靠，有丰富的配套方案
```

* Spring Cloud Config Client 客户端
** Spring Boot项目不需要改动任何代码，加入一个启动配置文件指明使用ConfigServer上哪个配置文件即可

Spring Cloud Config的原理如图所示:


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/1.jpg)

真正的数据存在Git等repository中,Config Server去获取相应的信息,然后开发给Client Application,相互间的通信基于HTTP,TCP,UDP等协议。

## 二、初级使用

使用spring cloud config需要先搭建一个config server，然后在config client中获取配置信息

在本章节中，先介绍spring cloud的简单使用，使用例子是从官网上下载的，地址：https://github.com/forezp/SpringCloudLearning/tree/master/chapter6

原理图如下所示：


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/26.png)


### 2.1 构造config server

1.1 创建spring boot项目，在pom.xml中添加依赖

```java
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>1.5.2.RELEASE</version>
    <relativePath/> <!-- lookup parent from repository -->
</parent>
<properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    <java.version>1.8</java.version>
</properties>
<dependencies>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-config-server</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
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
```

2、在程序的入口Application类加上@EnableConfigServer注解开启配置服务器。

```java
@SpringBootApplication
@EnableConfigServer
public class ConfigServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(ConfigServerApplication.class, args);
    }
}
```

3、添加如下配置

在application.xml中添加配置

```xml

spring.application.name=config-server
server.port=8888


spring.cloud.config.server.git.uri=https://github.com/forezp/SpringcloudConfig/
spring.cloud.config.server.git.searchPaths=respo
spring.cloud.config.label=master
spring.cloud.config.server.git.username=
spring.cloud.config.server.git.password=
```

其中：

```
spring.cloud.config.server.git.uri：配置git仓库地址
spring.cloud.config.server.git.searchPaths：配置仓库路径
spring.cloud.config.label：配置仓库的分支
spring.cloud.config.server.git.username：访问git仓库的用户名
spring.cloud.config.server.git.password：访问git仓库的用户密码
```

该git仓库是配置的git的仓库，比如说官网上给出的例子里面，远程仓库https://github.com/forezp/SpringcloudConfig/ 中有个文件夹respo，文件夹内有config-client-dev.properties文件，所以这里配置的git仓库地址是：https://github.com/forezp/SpringcloudConfig/，仓库路径是respo


配置也支持.yml格式的配置文件，在application.yml中添加配置：

```xml
server:
 port: 8888
spring:
 cloud:
  config:
   server:
    git:
     uri: https://github.com/forezp/SpringcloudConfig/
     searchPaths: respo
   label: master
 application:
   name: config-server

```


注意一下：编写yml文件的时候，树形结构的下一级和上一级之间用的是“**空格键**”，不能是Tab，并且必须是严格的树形结构。同时，key与value之间的冒号后面必须有一个“空格”！

4、 启动程序


经过上面的配置之后，启动程序，就启动了一个简单的spring cloud config server。

因为在上面的配置仓库中有一个config-client-dev.properties配置文件，配置内容如下：

```xml
foo = foo version 4
democonfigclient.message=hello spring io
```

所以访问http://localhost:8888/config-client/dev，可以看到如下展示，表示config-server启动成功：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/27.png)

URL与配置文件的映射关系如下：

```
/{name}/{profiles:.*[^-].*}
/{name}/{profiles}/{label:.*}
/{name}-{profiles}.properties
/{label}/{name}
/{profiles}.properties
/{name}-{profiles}.json
/{label}/{name}-{profiles}.json
```


上面的url会映射{application}-{profile}.properties对应的配置文件，{label}对应git上不同的分支，默认为master。

通过浏览器可以查看json格式，yml格式和propertis格式，分别如下：


* yml格式：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/28.png)

* json格式：
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/29.png)

* properties格式：
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/30.png)


### 2.2 构造config client

构造一个config-client项目，去使用config-server中的配置。

2.1 pom.xml文件中添加maven依赖

```
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>1.5.2.RELEASE</version>
    <relativePath/> <!-- lookup parent from repository -->
</parent>

<dependencies>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-config</artifactId>
    </dependency>

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>

<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-dependencies</artifactId>
            <version>Dalston.RC1</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

2.在application.properties文件中添加相关配置

```
spring.application.name=config-client
spring.cloud.config.label=master
spring.cloud.config.profile=dev
spring.cloud.config.uri= http://localhost:8888/
server.port=8881
```

其中：

* spring.cloud.config.label 指明远程仓库的分支
* spring.cloud.config.profile
** dev开发环境配置文件
** test测试环境
** pro正式环境
* spring.cloud.config.uri指明配置服务中心的网址，即上面搭建的config-server的地址

3.使用配置

```java
@Value("${foo}")
String foo;
@RequestMapping(value = "/hi")
public String hi(){
    return foo;
}
```

启动config-client之后，访问上面的接口http://localhost:8881/hi，看到的页面如下

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/31.png)


## 三、高级使用


### 3.1 使用Spring Security进行安全控制

如果觉得直接访问config-server的url不安全，可以使用Spring Security进行安全控制 。

1、config-server端配置

pom加入依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

application.yml文件中加入：

```xml
security:
  user:
    password: 123456
    name: wanfei
```


重新启动后进入页面的时候要求输入用户名和密码

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/32.png)

2、 config-client端配置


config-client需要在配置文件中添加验证信息：

```xml
spring.cloud.config.username=wanfei
spring.cloud.config.password=123456
```

### 3.2、配置中心微服务化、集群化

原理图如下所示

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/33.png)


1、准备eureka-server

2、改造config-server

* 修改pom文件，添加maven依赖

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-eureka</artifactId>
</dependency>
```

在程序的入口Application类加上@EnableEurekaClient或者@EnableDiscoveryClient注解

修改配置文件，将其注册到eureka-server服务

```xml
spring.application.name=config-server
server.port=8888

spring.cloud.config.server.git.uri=https://github.com/forezp/SpringcloudConfig/
spring.cloud.config.server.git.searchPaths=respo
spring.cloud.config.label=master
spring.cloud.config.server.git.username=
spring.cloud.config.server.git.password=
eureka.client.serviceUrl.defaultZone=http://localhost:8889/eureka/
```

其中：

* eureka.client.serviceUrl.defaultZone是注册的eureka机器地址

3、 改造config-client

修改pom文件，添加maven依赖

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-eureka</artifactId>
</dependency>
```

在程序的入口Application类加上@EnableEurekaClient或者@EnableDiscoveryClient注解

修改配置文件，将其注册到eureka-server服务

```xml
spring.application.name=config-client
server.port=8881

spring.cloud.config.label=master
spring.cloud.config.profile=dev
eureka.client.serviceUrl.defaultZone=http://localhost:8889/eureka/
spring.cloud.config.discovery.enabled=true
spring.cloud.config.discovery.serviceId=config-server
```
其中：

>* spring.cloud.config.discovery.enabled 是否从配置中心读取文件
>* spring.cloud.config.discovery.serviceId 配置中心的servieId，即服务名

由于涉及加载数据，需要在项目中添加bootstrap.properties，该文件会优先于application.properties加载。需要将eureka.client.serviceUrl.defaultZone配置放到bootstrap.properties文件中。

这时发现，在读取配置文件不再写ip地址，而是服务名，这时如果配置服务部署多份，通过负载均衡，从而高可用。


4、启动

访问eureka-server的服务器，可以看到config-server和config-client同时都注册在上面：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/34.png)


### 3.3 基于Spring Boot Admin的监控和配置刷新

Spring Boot Admin 是用来管理 Spring Boot 应用程序的一个简单的界面。提供如下功能：显示name/id和版本号、显示在线状态、显示详情（Java 系统属性、内存信息、环境属性等）。

Admin自身并不需要特殊的配置，同样，自身也是client，需要注册到eureka上，集成actuator后，Admin即可从eureka获取各client端的信息，spring-boot服务提供一套Restful Api便于管理，可以获取到服务的各种详细信息，但出于安全考虑，这些接口我们并不希望被外部访问，因此我们在client端添加了management.context-path=/actuator，即所有管理接口都增加了/actuator的路径，以便于区分其他正常对外提供服务的接口，也可以从运维层度对接口进行控制，因此需要添加以下配置，才能获取到各client的管理接口。

```xml
spring.boot.admin.discovery.converter.management-context-path=/actuator
```

如之前的配置，客户端需要添加如下相关配置：

#开启全部监控
```xml
endpoints.health.sensitive=false
#spring-boot 1.5.x 默认值改为true，需要改成false
management.security.enabled=false
management.context-path=/actuator
```

#重定义健康监控接口

```xml
eureka.instance.statusPageUrlPath=${management.context-path}/info
eureka.instance.healthCheckUrlPath=${management.context-path}/health
```

注意：要使用spring boot admin


### 3.4 除git外的其他类型的仓库

Spring Cloud Config也提供本地存储配置的方式。我们只需要设置属性：

```xml
spring.profiles.active=native
```

Config Server会默认从应用的src/main/resource目录下检索配置文件。也可以通过以下属性来指定配置文件的位置：

```xml
spring.cloud.config.server.native.searchLocations=file:F:/properties/
```

虽然Spring Cloud Config提供了这样的功能，但是为了支持更好的管理内容和版本控制的功能，还是推荐使用git的方式。

还可以使用svn提供的配置，只需要设置属性：
```xml
spring.profiles.active=subversion  
spring.cloud.config.server.svn.uri=svn://IP:port/project/config  
spring.cloud.config.server.svn.username=xxxxx
spring.cloud.config.server.svn.password=xxxxx 
```


## 四、参考链接
http://blog.csdn.net/forezp/article/details/70037291

https://blog.coding.net/blog/spring-cloud-config?utm_source=tuicool&utm_medium=referral

http://blog.didispace.com/springcloud4/

https://segmentfault.com/a/1190000006138698

https://springcloud.cc/spring-cloud-config.html#config-first-bootstrap