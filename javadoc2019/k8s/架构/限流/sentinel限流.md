# sentinel 熔断器

Feign环境下：只需两步

1. 在原使用hystrix的模块中添加如下依赖：

```
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-alibaba-sentinel</artifactId>
    <version>0.2.1.RELEASE</version>
</dependency>
```

2. 在application.yml 中添加feign.sentinel.enabled=true 即可为Feign启用Sentinel支持：

```

# 去掉
# feign.hystrix.enabled: true
# 改为如下即可
feign.sentinel.enabled: true
```


Ribbon环境下：
1. 先去除Spring Cloud Netflix Hystrix（ spring-cloud-starter-netflix-hystrix ）的依赖，再添加sentinel依赖
```
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-alibaba-sentinel</artifactId>
    <version>0.2.1.RELEASE</version>
</dependency>
```

2. 再在构造RestTemplate的时候加上@SentinelRestTemplate注解即可

```
@Bean
@SentinelRestTemplate
public RestTemplate restTemplate() {
    return new RestTemplate();
}

```


# 限流组件Sentinel

Sentinel是把流量作为切入点，从流量控制、熔断降级、系统负载保护等多个维度保护服务的稳定性。
默认支持 Servlet、Feign、RestTemplate、Dubbo 和 RocketMQ 限流降级功能的接入，可以在运行时通过控制台实时修改限流降级规则，还支持查看限流降级 Metrics 监控。
自带控台动态修改限流策略。但是每次服务重启后就丢失了。所以它也支持ReadableDataSource 目前支持file, nacos, zk, apollo 这4种类型
接入Sentinel，创建项目cloud-sentinel

1. 引入 Sentinel starter

```
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-sentinel</artifactId>
</dependency>
```

2. application.properties配置如下

```
server.port=18084
spring.application.name=service-sentinel

#Sentinel 控制台地址
spring.cloud.sentinel.transport.dashboard=localhost:8080
#取消Sentinel控制台懒加载
spring.cloud.sentinel.eager=true
```

接入限流埋点

a. Sentinel 默认为所有的 HTTP 服务提供了限流埋点。引入依赖后自动完成所有埋点。只需要再控制配置限流规则即可

b. 注解埋点
如果需要对某个特定的方法进行限流或降级，可以通过 @SentinelResource 注解来完成限流的埋点

```
@SentinelResource("resource")
@RequestMapping("/sentinel/hello")
public Map<String,Object> hello(){
        Map<String,Object> map=new HashMap<>(2);
        map.put("appName",appName);
        map.put("method","hello");
        return map;
}
```

3. 部署Sentinel控制台
* Sentinel下载
* 启动控制台  执行 Java 命令 java -jar sentinel-dashboard.jar 默认的监听端口为 8080

访问
打开http://localhost:8080 即可看到控制台界面

![image-20200210154431467](F:\3GitHub\learnDoc\javadoc2019\k8s\架构\限流\sentinel限流.assets\image-20200210154431467.png)

说明cloud-sentinel已经成功和Sentinel完成率通讯

4. 配置限流规则
如果控制台没有找到自己的应用，可以先调用一下进行了 Sentinel 埋点的 URL 或方法或着禁用Sentinel 的赖加载spring.cloud.sentinel.eager=true

5. 配置 URL 限流规则
控制器随便添加一个普通的http方法

 ```
  /**
     * 通过控制台配置URL 限流
     * @return
        */
  
      @RequestMapping("/sentinel/test")
      public Map<String,Object> test(){
        Map<String,Object> map=new HashMap<>(2);
        map.put("appName",appName);
        map.put("method","test");
        return map;
      }

 ```

点击新增流控规则。为了方便测试阀值设为 1



![image-20200210154543938](F:\3GitHub\learnDoc\javadoc2019\k8s\架构\限流\sentinel限流.assets\image-20200210154543938.png)

浏览器重复请求 http://localhost:18084/sentinel/test 如果超过阀值就会出现如下界面

整个URL限流就完成了。但是返回的提示不够友好。

![image-20200210154602194](F:\3GitHub\learnDoc\javadoc2019\k8s\架构\限流\sentinel限流.assets\image-20200210154602194.png)

6. 配置自定义限流规则(@SentinelResource埋点)
自定义限流规则就不是添加方法的访问路径。 配置的是@SentinelResource注解中value的值。比如@SentinelResource("resource")就是配置路径为resource

访问：http://localhost:18084/sentinel/hello
通过@SentinelResource注解埋点配置的限流规则如果没有自定义限流处理逻辑，当请求到达限流的阀值时就返回404页面


6.1. 自定义限流处理逻辑
@SentinelResource 注解包含以下属性：

value：资源名称，必需项（不能为空）
entryType：入口类型，可选项（默认为 EntryType.OUT）
blockHandler：blockHandlerClass中对应的异常处理方法名。参数类型和返回值必须和原方法一致
blockHandlerClass：自定义限流逻辑处理类

 ```
 //通过注解限流并自定义限流逻辑
 @SentinelResource(value = "resource2", blockHandler = "handleException", blockHandlerClass = {ExceptionUtil.class})
 @RequestMapping("/sentinel/test2")
    public Map<String,Object> test2() {
        Map<String,Object> map=new HashMap<>();
        map.put("method","test2");
        map.put("msg","自定义限流逻辑处理");
        return  map;
    }

public class ExceptionUtil {

    public static Map<String,Object> handleException(BlockException ex) {
        Map<String,Object> map=new HashMap<>();
        System.out.println("Oops: " + ex.getClass().getCanonicalName());
        map.put("Oops",ex.getClass().getCanonicalName());
        map.put("msg","通过@SentinelResource注解配置限流埋点并自定义处理限流后的逻辑");
        return  map;
    }
}
 ```

6.2. 控制台新增resource2的限流规则并设置阀值为1。访问http://localhost:18084/sentinel/test2 请求到达阀值时机会返回自定义的异常消息

基本的限流处理就完成了。 但是每次服务重启后之前配置的限流规则就会被清空因为是内存态的规则对象。所以下面就要用到Sentinel一个特性 ReadableDataSource 获取文件、数据库或者配置中心是限流规则

读取文件的实现限流规则
一条限流规则主要由下面几个因素组成：

resource：资源名，即限流规则的作用对象
count: 限流阈值
grade: 限流阈值类型（QPS 或并发线程数）
limitApp: 流控针对的调用来源，若为 default 则不区分调用来源
strategy: 调用关系限流策略
controlBehavior: 流量控制效果（直接拒绝、Warm Up、匀速排队）
SpringCloud alibaba集成Sentinel后只需要在配置文件中进行相关配置，即可在 Spring 容器中自动注册 DataSource，这点很方便。

配置文件添加如下配置：

```
#  通过文件读取限流规则
spring.cloud.sentinel.datasource.ds1.file.file=classpath: flowrule.json
spring.cloud.sentinel.datasource.ds1.file.data-type=json
spring.cloud.sentinel.datasource.ds1.file.rule-type=flow
```


在resources新建一个文件 比如flowrule.json 添加限流规则
```
[
  {
    "resource": "resource",
    "controlBehavior": 0,
    "count": 1,
    "grade": 1,
    "limitApp": "default",
    "strategy": 0
  },
  {
    "resource": "resource3",
    "controlBehavior": 0,
    "count": 1,
    "grade": 1,
    "limitApp": "default",
    "strategy": 0
  }
]
```

重新启动项目。出现如下日志说明文件读取成功

```
 [Sentinel Starter] DataSource ds1-sentinel-file-datasource start to loadConfig
 [Sentinel Starter] DataSource ds1-sentinel-file-datasource load 2 FlowRule
```

刷新Sentinel 控制台 限流规则就会自动添加进去

```
Sentinel的配置
spring.cloud.sentinel.enabled              #Sentinel自动化配置是否生效
spring.cloud.sentinel.eager               #取消Sentinel控制台懒加载
spring.cloud.sentinel.transport.dashboard   #Sentinel 控制台地址
spring.cloud.sentinel.transport.heartbeatIntervalMs        #应用与Sentinel控制台的心跳间隔时间
spring.cloud.sentinel.log.dir            #Sentinel 日志文件所在的目录
```

