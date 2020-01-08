# 一、配置中心

## 1、引入依赖:

```
	  <dependency>
		  <groupId>com.timeloit.cloud</groupId>
		  <artifactId>spring-cloud-timeloit-nacos-config</artifactId>
		  <version>0.0.1-SNAPSHOT</version>
	  </dependency>

	  <dependency>
		  <groupId>org.springframework.boot</groupId>
		  <artifactId>spring-boot-starter-actuator</artifactId>
	  </dependency>
```

## 2、创建文件 resources/bootstrap.properties

```
spring.profiles.active=devnacos
# Nacos 配置中心上配置文件名称 前缀
spring.application.name=loit-portal
# Nacos 配置中心地址
spring.cloud.nacos.config.server-addr=192.168.66.40:8848

# spring.cloud.nacos.config.group=DEFAULT_GROUP
# spring.cloud.nacos.config.file-extension=properties
spring.cloud.nacos.config.file-extension=yaml
spring.cloud.nacos.config.namespace=e15d31e9-88f3-4f8d-be57-916992ea757c
```

## 3、配置属性说明

* **spring.cloud.nacos.config.namespace **
* * 命名空间
* * 不填默认 pubic
* * 填写时使用命名空间ID
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200108105223242.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI3Mzg0NzY5,size_16,color_FFFFFF,t_70)
*  **nacos上的配置文件: 	loit-portal-devnacos.yaml**
* * spring.profiles.active=devnacos
* * spring.application.name=loit-portal
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200108105611798.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI3Mzg0NzY5,size_16,color_FFFFFF,t_70)
**注意** 需要将本地相应的配置文件删除如：loit-portal-devnacos.yaml。优先使用本地对应配置



## 4、配置自动刷新

* 增加属性 @RefreshScope

```
@RestController
@RequestMapping(value = "demo")
@RefreshScope
public class CasServerLoginValidateController {

    @Value("${echo.info}")
    private String echoInfo;

    @RequestMapping("/echo")
    public String simple() {
        return "echoInfo: " + echoInfo;
    }

}
```





# 二、服务发现

pom 添加

```
        <!-- nacos -->
        <dependency>
            <groupId>com.timeloit.cloud</groupId>
            <artifactId>spring-cloud-timeloit-nacos-discovery</artifactId>
        </dependency>

```



```
spring:
  application:
    nacos:
      discovery:
        server-addr: 192.168.66.40:8848
```

Application添加注解 @EnableDiscoveryClient

```
@EnableDiscoveryClient
public class NacosProviderApplication {
    public static void main(String[] args) {
        SpringApplication.run(NacosProviderApplication.class, args);
    }
}
```



# 三、熔断器



### feign 熔断

```
<!-- 熔断器 -->
<dependency>
    <groupId>com.timeloit.cloud</groupId>
    <artifactId>spring-cloud-starter-timeloit-sentinel</artifactId>
</dependency>
```

```
spring:
  cloud:
    sentinel:
      transport:
        port: 8720
        dashboard: localhost:8080
```



fallback = EchoServiceFallback.class

```
@FeignClient(name = "storage-service", fallback = EchoServiceFallback.class)
public interface StorageFeignClient {

    @GetMapping("storage/deduct")
    Boolean deduct(@RequestParam("commodityCode") String commodityCode, @RequestParam("count") Integer count);
}

```



```
@Component
@Slf4j
public class EchoServiceFallback implements StorageFeignClient{

    @Override
    public Boolean deduct(String commodityCode, Integer count) {
        throw new RuntimeException("服务关闭了");
    }

}
```

# 四、流控

### dashboard

```
java -jar -Xms250m -Xmx250m -Dserver.port=8090 -Dcsp.sentinel.dashboard.server=localhost:8090 E:\2service\sentinel\sentinel-dashboard-1.6.3.jar
```



```
默认用户名和密码都是sentinel。对于用户登录的相关配置可以在启动命令中增加下面的参数来进行配置：

-Dsentinel.dashboard.auth.username=sentinel: 用于指定控制台的登录用户名为 sentinel；
-Dsentinel.dashboard.auth.password=123456: 用于指定控制台的登录密码为 123456；如果省略这两个参数，默认用户和密码均为 sentinel
-Dserver.servlet.session.timeout=7200: 用于指定 Spring Boot 服务端 session 的过期时间，如 7200 表示 7200 秒；60m 表示 60 分钟，默认为 30 分钟；
```



### 项目配置

```
   
   <dependency>
    	<groupId>com.timeloit.cloud</groupId>
    	<artifactId>spring-cloud-starter-timeloit-sentinel</artifactId>
	</dependency>
   <dependency>
        <groupId>com.alibaba.csp</groupId>
        <artifactId>sentinel-datasource-nacos</artifactId>
    </dependency>
```



```
spring.application.name=alibaba-sentinel-datasource-nacos
server.port=8003

# sentinel dashboard
spring.cloud.sentinel.transport.dashboard=localhost:8080

# sentinel datasource nacos ：http://blog.didispace.com/spring-cloud-alibaba-sentinel-2-1/
spring.cloud.sentinel.datasource.ds.nacos.server-addr=localhost:8848
spring.cloud.sentinel.datasource.ds.nacos.dataId=${spring.application.name}-sentinel
spring.cloud.sentinel.datasource.ds.nacos.groupId=DEFAULT_GROUP
spring.cloud.sentinel.datasource.ds.nacos.rule-type=flow
```

- `spring.cloud.sentinel.transport.dashboard`：sentinel dashboard的访问地址，根据上面准备工作中启动的实例配置
- `spring.cloud.sentinel.datasource.ds.nacos.server-addr`：nacos的访问地址，，根据上面准备工作中启动的实例配置
- `spring.cloud.sentinel.datasource.ds.nacos.groupId`：nacos中存储规则的groupId
- `spring.cloud.sentinel.datasource.ds.nacos.dataId`：nacos中存储规则的dataId
- `spring.cloud.sentinel.datasource.ds.nacos.rule-type`：该参数是spring cloud alibaba升级到0.2.2之后增加的配置，用来定义存储的规则类型。所有的规则类型可查看枚举类：`org.springframework.cloud.alibaba.sentinel.datasource.RuleType`，每种规则的定义格式可以通过各枚举值中定义的规则对象来查看，比如限流规则可查看：`com.alibaba.csp.sentinel.slots.block.flow.FlowRule`

这里对于dataId使用了`${spring.application.name}`变量，这样可以根据应用名来区分不同的规则配置。

**注意**：由于版本迭代关系，Github Wiki中的文档信息不一定适用所有版本。比如：在这里适用的0.2.1版本中，并没有`spring.cloud.sentinel.datasource.ds2.nacos.rule-type`这个参数。所以，读者在使用的时候，可以通过查看`org.springframework.cloud.alibaba.sentinel.datasource.config.DataSourcePropertiesConfiguration`和`org.springframework.cloud.alibaba.sentinel.datasource.config.NacosDataSourceProperties`两个类来分析具体的配置内容，会更为准确。



```
[
    {
        "resource": "/order/placeOrder/commit",
        "limitApp": "default",
        "grade": 1,
        "count": 5,
        "strategy": 0,
        "controlBehavior": 0,
        "clusterMode": false
    }
]
```

可以看到上面配置规则是一个数组类型，数组中的每个对象是针对每一个保护资源的配置对象，每个对象中的属性解释如下：

- resource：资源名，即限流规则的作用对象
- limitApp：流控针对的调用来源，若为 default 则不区分调用来源
- grade：限流阈值类型（QPS 或并发线程数）；`0`代表根据并发数量来限流，`1`代表根据QPS来进行流量控制
- count：限流阈值
- strategy：调用关系限流策略
- controlBehavior：流量控制效果（直接拒绝、Warm Up、匀速排队）
- clusterMode：是否为集群模式

### 注意

在完成了上面的整合之后，对于接口流控规则的修改就存在两个地方了：Sentinel控制台、Nacos控制台。

这个时候，需要注意当前版本的Sentinel控制台不具备同步修改Nacos配置的能力，而Nacos由于可以通过在客户端中使用Listener来实现自动更新。所以，在整合了Nacos做规则存储之后，需要知道在下面两个地方修改存在不同的效果：

- Sentinel控制台中修改规则：仅存在于服务的内存中，不会修改Nacos中的配置值，重启后恢复原来的值。
- Nacos控制台中修改规则：服务的内存中规则会更新，Nacos中持久化规则也会更新，重启后依然保持。

# 五、 链路监控

client端

```
-javaagent:E:\2service\apache-skywalking-apm-bin\agent\skywalking-agent.jar -Dskywalking.agent.service_name=rjsoft-jycj-admin-main -Dskywalking.collector.backend_service=localhost:11800
```



# 六、 分布式事务





# 七、 分布式任务器



