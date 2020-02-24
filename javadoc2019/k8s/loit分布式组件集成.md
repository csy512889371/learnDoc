#### 一、组件库说明

 

```
spring-cloud-timeloit                                  --timeloit spring cloud 组件封装
├── spring-cloud-starter-timeloit                
│   ├── spring-cloud-starter-timeloit-nacos-discovery      --服务注册与发现组件Starter
│   ├── spring-cloud-starter-timeloit-sentinel             --服务限流组件组件Starter
├── spring-cloud-timeloit-dependencies                     --统一依赖版本
├── spring-cloud-timeloit-examples                         --timeloit组件使用例子
│   ├── seata-example                                      --分布式事务例子
│   │   ├── loit-seata-order-example                       --分布式事务例子-订单
│   │   ├── loit-seata-storage-example                     --分布式事务例子-库存
├── spring-cloud-timeloit-nacos-config                     --配置中心组件封装
├── spring-cloud-timeloit-nacos-discovery                  --服务注册与发现组件
├── spring-cloud-timeloit-seata                            --分布式事务组件封装
├── spring-cloud-timeloit-sentinel                         --流控组件封装
├── spring-cloud-timeloit-sentinel-datasource              --限流熔断和流控-规则存储
├── spring-cloud-timeloit-sentinel-gateway                 --网关限流组件封装-限流
```



#### 一、maven 配置

C:\Users\nick\.m2\settings.xml

```
<?xml version="1.0" encoding="UTF-8"?>


<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">

  <localRepository>E:\1maven_repo_jycj</localRepository>

  <pluginGroups>

  </pluginGroups>

  <proxies>
  </proxies>
  <servers>
   
	<server>
	  <id>nexus-releases</id>
	  <username>deployment</username>
	  <password>loitdev</password>
	</server>

	<server>
	  <id>nexus-snapshots</id>
	  <username>deployment</username>
	  <password>loitdev</password>
	</server>
  </servers>

  
  <mirrors>
  </mirrors>
  
  <profiles>
  </profiles>
</settings>

```

pom.xml

```
	<distributionManagement>
        <repository>
            <id>nexus-releases</id>
            <name>Nexus Release Repository</name>
            <url>http://39.100.254.140:12010/repository/maven-releases/</url>
        </repository>
        <snapshotRepository>
            <id>nexus-snapshots</id>
            <name>Nexus Snapshot Repository</name>
            <url>http://39.100.254.140:12010/repository/maven-snapshots/</url>
        </snapshotRepository>
    </distributionManagement>

    <repositories>
        <repository>
            <id>nexus-loit-dev</id>
            <name>Nexus Repository</name>
            <url>http://39.100.254.140:12010/repository/maven-public/</url>
            <snapshots>
                <enabled>true</enabled>
            </snapshots>
            <releases>
                <enabled>true</enabled>
            </releases>
        </repository>
    </repositories>
    <pluginRepositories>
        <pluginRepository>
            <id>nexus-loit-dev</id>
            <name>Nexus Plugin Repository</name>
            <url>http://39.100.254.140:12010/repository/maven-public/</url>
            <snapshots>
                <enabled>true</enabled>
            </snapshots>
            <releases>
                <enabled>true</enabled>
            </releases>
        </pluginRepository>
    </pluginRepositories>

```

```
clean deploy -Dmaven.test.skip=true
clean install -Dmaven.test.skip=true
```



#### 二、配置中心

##### 1、引入依赖:

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

##### 2、创建文件 resources/bootstrap.properties

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

##### 3、配置属性说明

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



##### 4、配置自动刷新

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



5、

```
@NacosPropertySource(dataId = "example", autoRefreshed = true)
```



```
    @NacosValue(value = "${useLocalCache:false}", autoRefreshed = true)
    private boolean useLocalCache;
```





#### 三、服务发现

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
  cloud:
    nacos:
      discovery:
        # Nacos 注册中心地址
        server-addr: 39.100.254.140:8103
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



#### 四、熔断器



\# 改为如下即可
feign.sentinel.enabled: true



###### feign 熔断

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



二



```
@Configuration
public class SentinelAspectConfiguration {
    @Bean
    public SentinelResourceAspect sentinelResourceAspect() {
        return new SentinelResourceAspect();
    }
}

```



```
    @Override
    @SentinelResource(value = "test",blockHandler = "blockHandlerException",fallback = "fallbackException")
    public String test() {
        return "正常数据";
    }

    public String blockHandlerException(BlockException exception){
        return "BlockException...";
    }

    public String fallbackException(){
        return "fallbackException...";
    }
```





#### 五、流控

###### dashboard

```
java -jar -Xms250m -Xmx250m -Dserver.port=8090 -Dcsp.sentinel.dashboard.server=localhost:8090 E:\2service\sentinel\sentinel-dashboard-1.6.3.jar
```



```
默认用户名和密码都是sentinel。对于用户登录的相关配置可以在启动命令中增加下面的参数来进行配置：

-Dsentinel.dashboard.auth.username=sentinel: 用于指定控制台的登录用户名为 sentinel；
-Dsentinel.dashboard.auth.password=123456: 用于指定控制台的登录密码为 123456；如果省略这两个参数，默认用户和密码均为 sentinel
-Dserver.servlet.session.timeout=7200: 用于指定 Spring Boot 服务端 session 的过期时间，如 7200 表示 7200 秒；60m 表示 60 分钟，默认为 30 分钟；
```



###### 项目配置

```
   
   <dependency>
    	<groupId>com.timeloit.cloud</groupId>
    	<artifactId>spring-cloud-starter-timeloit-sentinel</artifactId>
	</dependency>
   <dependency>
        <groupId>com.alibaba.csp</groupId>
        <artifactId>sentinel-datasource-nacos</artifactId>
    </dependency>
    <dependency>
       <groupId>com.timeloit.cloud</groupId>
       <artifactId>spring-cloud-timeloit-sentinel-datasource</artifactId>
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

###### 注意

在完成了上面的整合之后，对于接口流控规则的修改就存在两个地方了：Sentinel控制台、Nacos控制台。

这个时候，需要注意当前版本的Sentinel控制台不具备同步修改Nacos配置的能力，而Nacos由于可以通过在客户端中使用Listener来实现自动更新。所以，在整合了Nacos做规则存储之后，需要知道在下面两个地方修改存在不同的效果：

- Sentinel控制台中修改规则：仅存在于服务的内存中，不会修改Nacos中的配置值，重启后恢复原来的值。
- Nacos控制台中修改规则：服务的内存中规则会更新，Nacos中持久化规则也会更新，重启后依然保持。

#### 六、 链路监控

client端

```
-javaagent:E:\2service\apache-skywalking-apm-bin\agent\skywalking-agent.jar -Dskywalking.agent.service_name=loit-project-name -Dskywalking.collector.backend_service=localhost:11800
```

service_name: 具体项目名称



#### 七、 网关gateway

pom

```
<!-- sentinel gateway流控 -->
        <dependency>
            <groupId>com.timeloit.cloud</groupId>
            <artifactId>spring-cloud-starter-timeloit-sentinel</artifactId>
        </dependency>

        <dependency>
            <groupId>com.timeloit.cloud</groupId>
            <artifactId>spring-cloud-timeloit-sentinel-gateway</artifactId>
        </dependency>

        <!-- sentinel nacos 整合 -->
        <dependency>
            <groupId>com.timeloit.cloud</groupId>
            <artifactId>spring-cloud-timeloit-sentinel-datasource</artifactId>
        </dependency>

        <dependency>
            <groupId>com.alibaba.csp</groupId>
            <artifactId>sentinel-datasource-nacos</artifactId>
        </dependency>


        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-openfeign</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-gateway</artifactId>
        </dependency>


        <!-- Spring Cloud End -->

        <!-- Commons Begin -->
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>javax.servlet-api</artifactId>
        </dependency>
        <!-- Commons Begin -->
```

**网关限流设置：**



此模块中包含网关限流的规则和自定义 API 的实体和管理逻辑：

- GatewayFlowRule：网关限流规则，针对 API Gateway 的场景定制的限流规则，可以针对不同 route 或自定义的 API 分组进行限流，支持针对请求中的参数、Header、来源 IP 等进行定制化的限流。
- ApiDefinition：用户自定义的 API 定义分组，可以看做是一些 URL 匹配的组合。比如我们可以定义一个 API 叫 my_api，请求 path 模式为 /foo/** 和 /baz/** 的都归到 my_api 这个 API 分组下面。限流的时候可以针对这个自定义的 API 分组维度进行限流。

其中网关限流规则 GatewayFlowRule 的字段解释如下：

- resource：资源名称，可以是网关中的 `route 名称`或者用户自定义的`API 分组名称`。
- resourceMode：规则是针对 `API Gateway` 的`route（RESOURCE_MODE_ROUTE_ID）`还是用户在 Sentinel 中定义的`API 分组（RESOURCE_MODE_CUSTOM_API_NAME）`，默认是`route`。
- grade：限流指标维度，同限流规则的`grade` 字段。
- count：限流阈值
- intervalSec：统计时间窗口，单位是秒，默认是`1 秒`（目前仅对参数限流生效）。
- controlBehavior：流量整形的控制效果，同限流规则的 `controlBehavior` 字段，目前支持快速失败和匀速排队两种模式，默认是快速失败。
- burst：应对突发请求时额外允许的请求数目（目前仅对参数限流生效）。
- maxQueueingTimeoutMs：匀速排队模式下的最长排队时间，单位是毫秒，仅在匀速排队模式下生效。
- paramItem：参数限流配置。若不提供，则代表不针对参数进行限流，该网关规则将会被转换成普通流控规则；否则会转换成热点规则。其中的字段：
  - parseStrategy：从请求中提取参数的策略，目前支持提取来源 IP`（PARAM_PARSE_STRATEGY_CLIENT_IP）`、`Host（PARAM_PARSE_STRATEGY_HOST）`、`任意 Header（PARAM_PARSE_STRATEGY_HEADER）`和`任意 URL 参数（PARAM_PARSE_STRATEGY_URL_PARAM）`四种模式。
  - fieldName：若提取策略选择 Header 模式或 URL 参数模式，则需要指定对应的 `header 名称`或 `URL 参数名称`。
  - pattern 和 matchStrategy：为后续参数匹配特性预留，目前未实现。
  
  

#### 八、 分布式事务



##### 1、Seata 

Seata 是一款开源的分布式事务解决方案，致力于提供高性能和简单易用的分布式事务服务。Seata 将为用户提供了 AT、TCC、SAGA 和 XA 事务模式，为用户打造一站式的分布式解决方案。



##### 2、部署 Server

Server支持多种方式部署：直接部署，使用 Docker, 使用 Docker-Compose, 使用 Kubernetes, 使用 Helm.

直接部署

1. 在[RELEASE](https://github.com/seata/seata/releases)页面下载相应版本并解压
2. 直接启动

在 Linux/Mac 下

```bash
$ sh ./bin/seata-server.sh
```

在 Windows 下

```cmd
bin\seata-server.bat
```

* server端数据库脚本:global_table、branch_table、lock_table

```
-- -------------------------------- The script used when storeMode is 'db' --------------------------------
-- the table to store GlobalSession data
CREATE TABLE IF NOT EXISTS `global_table`
(
    `xid`                       VARCHAR(128) NOT NULL,
    `transaction_id`            BIGINT,
    `status`                    TINYINT      NOT NULL,
    `application_id`            VARCHAR(32),
    `transaction_service_group` VARCHAR(100),
    `transaction_name`          VARCHAR(128),
    `timeout`                   INT,
    `begin_time`                BIGINT,
    `application_data`          VARCHAR(2000),
    `gmt_create`                DATETIME,
    `gmt_modified`              DATETIME,
    PRIMARY KEY (`xid`),
    KEY `idx_gmt_modified_status` (`gmt_modified`, `status`),
    KEY `idx_transaction_id` (`transaction_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

-- the table to store BranchSession data
CREATE TABLE IF NOT EXISTS `branch_table`
(
    `branch_id`         BIGINT       NOT NULL,
    `xid`               VARCHAR(128) NOT NULL,
    `transaction_id`    BIGINT,
    `resource_group_id` VARCHAR(32),
    `resource_id`       VARCHAR(256),
    `branch_type`       VARCHAR(8),
    `status`            TINYINT,
    `client_id`         VARCHAR(64),
    `application_data`  VARCHAR(2000),
    `gmt_create`        DATETIME,
    `gmt_modified`      DATETIME,
    PRIMARY KEY (`branch_id`),
    KEY `idx_xid` (`xid`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

-- the table to store lock data
CREATE TABLE IF NOT EXISTS `lock_table`
(
    `row_key`        VARCHAR(128) NOT NULL,
    `xid`            VARCHAR(96),
    `transaction_id` BIGINT,
    `branch_id`      BIGINT       NOT NULL,
    `resource_id`    VARCHAR(256),
    `table_name`     VARCHAR(32),
    `pk`             VARCHAR(36),
    `gmt_create`     DATETIME,
    `gmt_modified`   DATETIME,
    PRIMARY KEY (`row_key`),
    KEY `idx_branch_id` (`branch_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
```



各个微服务需要添加表: undo_log

```
-- for AT mode you must to init this sql for you business database. the seata server not need it.
CREATE TABLE IF NOT EXISTS `undo_log`
(
    `id`            BIGINT(20)   NOT NULL AUTO_INCREMENT COMMENT 'increment id',
    `branch_id`     BIGINT(20)   NOT NULL COMMENT 'branch transaction id',
    `xid`           VARCHAR(100) NOT NULL COMMENT 'global transaction id',
    `context`       VARCHAR(128) NOT NULL COMMENT 'undo_log context,such as serialization',
    `rollback_info` LONGBLOB     NOT NULL COMMENT 'rollback info',
    `log_status`    INT(11)      NOT NULL COMMENT '0:normal status,1:defense status',
    `log_created`   DATETIME     NOT NULL COMMENT 'create datetime',
    `log_modified`  DATETIME     NOT NULL COMMENT 'modify datetime',
    PRIMARY KEY (`id`),
    UNIQUE KEY `ux_undo_log` (`xid`, `branch_id`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = utf8 COMMENT ='AT transaction mode undo table';
```



##### 3、项目配置

pom

```

        <!-- seata-->
        <dependency>
            <groupId>com.timeloit.cloud</groupId>
            <artifactId>spring-cloud-timeloit-seata</artifactId>
        </dependency>

        <!-- mysql -->
        <dependency>
            <groupId>com.timeloit.project</groupId>
            <artifactId>loit-seata-mybatis-mysql-suport</artifactId>
        </dependency>

```



**将下面配置拷贝到项目中**

resources/file.conf

修改其中

* vgroup_mapping.storage-service-seata-service-group 修改成: vgroup_mapping.${application-name}-service-group

如application-name 为demo的话则修改成

vgroup_mapping.demo-service-group = "default"

* 修改 store.db下的相关数据库信息

```
transport {
  # tcp udt unix-domain-socket
  type = "TCP"
  #NIO NATIVE
  server = "NIO"
  #enable heartbeat
  heartbeat = true
  #thread factory for netty
  thread-factory {
    boss-thread-prefix = "NettyBoss"
    worker-thread-prefix = "NettyServerNIOWorker"
    server-executor-thread-prefix = "NettyServerBizHandler"
    share-boss-worker = false
    client-selector-thread-prefix = "NettyClientSelector"
    client-selector-thread-size = 1
    client-worker-thread-prefix = "NettyClientWorkerThread"
    # netty boss thread size,will not be used for UDT
    boss-thread-size = 1
    #auto default pin or 8
    worker-thread-size = 8
  }
  shutdown {
    # when destroy server, wait seconds
    wait = 3
  }
  serialization = "seata"
  compressor = "none"
}
service {
  #transaction service group mapping
  vgroup_mapping.storage-service-seata-service-group = "default"
  #only support when registry.type=file, please don't set multiple addresses
  default.grouplist = "127.0.0.1:8091"
  #degrade, current not support
  enableDegrade = false
  #disable seata
  disableGlobalTransaction = false
}

client {
  rm {
    async.commit.buffer.limit = 10000
    lock {
      retry.internal = 10
      retry.times = 30
      retry.policy.branch-rollback-on-conflict = true
    }
    report.retry.count = 5
    table.meta.check.enable = false
    report.success.enable = true
  }
  tm {
    commit.retry.count = 5
    rollback.retry.count = 5
  }
  undo {
    data.validation = true
    log.serialization = "jackson"
    log.table = "undo_log"
  }
  log {
    exceptionRate = 100
  }
  support {
    # auto proxy the DataSource bean
    spring.datasource.autoproxy = false
  }
}

## transaction log store
store {
  ## store mode: file、db
  mode = "db"
  ## file store property
  file {
    ## store location dir
    dir = "sessionStore"
    # branch session size , if exceeded first try compress lockkey, still exceeded throws exceptions
    max-branch-session-size = 16384
    # globe session size , if exceeded throws exceptions
    max-global-session-size = 512
    # file buffer size , if exceeded allocate new buffer
    file-write-buffer-cache-size = 16384
    # when recover batch read size
    session.reload.read_size = 100
    # async, sync
    flush-disk-mode = async
  }

  ## database store property
  db {
    ## the implement of javax.sql.DataSource, such as DruidDataSource(druid)/BasicDataSource(dbcp) etc.
    datasource = "dbcp"
    ## mysql/oracle/h2/oceanbase etc.
    db-type = "mysql"
    driver-class-name = "com.mysql.jdbc.Driver"
    url = "jdbc:mysql://39.98.202.173:3306/seata_server"
    user = "root"
    password = "abcd1234A!"
    min-conn = 1
    max-conn = 10
    global.table = "global_table"
    branch.table = "branch_table"
    lock-table = "lock_table"
    query-limit = 100
  }
}
server {
  recovery {
    #schedule committing retry period in milliseconds
    committing-retry-period = 1000
    #schedule asyn committing retry period in milliseconds
    asyn-committing-retry-period = 1000
    #schedule rollbacking retry period in milliseconds
    rollbacking-retry-period = 1000
    #schedule timeout retry period in milliseconds
    timeout-retry-period = 1000
  }
  undo {
    log.save.days = 7
    #schedule delete expired undo_log in milliseconds
    log.delete.period = 86400000
  }
  #unit ms,s,m,h,d represents milliseconds, seconds, minutes, hours, days, default permanent
  max.commit.retry.timeout = "-1"
  max.rollback.retry.timeout = "-1"
}

## metrics settings
metrics {
  enabled = false
  registry-type = "compact"
  # multi exporters use comma divided
  exporter-list = "prometheus"
  exporter-prometheus-port = 9898
}
```

resources/registry.conf



修改其中

* registry.nacos.serverAddr地址
* config.nacos.serverAddr地址

```
registry {
  # file 、nacos 、eureka、redis、zk、consul、etcd3、sofa
  type = "nacos"

  nacos {
    serverAddr = "192.168.66.40:8848"
    namespace = "public"
    cluster = "default"
  }
  eureka {
    serviceUrl = "http://localhost:8761/eureka"
    application = "default"
    weight = "1"
  }
  redis {
    serverAddr = "localhost:6379"
    db = "0"
  }
  zk {
    cluster = "default"
    serverAddr = "127.0.0.1:2181"
    session.timeout = 6000
    connect.timeout = 2000
  }
  consul {
    cluster = "default"
    serverAddr = "127.0.0.1:8500"
  }
  etcd3 {
    cluster = "default"
    serverAddr = "http://localhost:2379"
  }
  sofa {
    serverAddr = "127.0.0.1:9603"
    application = "default"
    region = "DEFAULT_ZONE"
    datacenter = "DefaultDataCenter"
    cluster = "default"
    group = "SEATA_GROUP"
    addressWaitTime = "3000"
  }
  file {
    name = "file.conf"
  }
}

config {
  # file、nacos 、apollo、zk、consul、etcd3
  type = "file"

  nacos {
    serverAddr = "192.168.66.40:8848"
    namespace = "public"
  }
  consul {
    serverAddr = "127.0.0.1:8500"
  }
  apollo {
    app.id = "seata-server"
    apollo.meta = "http://192.168.1.204:8801"
  }
  zk {
    serverAddr = "127.0.0.1:2181"
    session.timeout = 6000
    connect.timeout = 2000
  }
  etcd3 {
    serverAddr = "http://localhost:2379"
  }
  file {
    name = "file.conf"
  }
}

```



```
@GlobalTransactional(timeoutMills = 300000, name = "dubbo-demo-tx")
```



##### 4、常见问题一


###### 使用Seata框架，来保证事务的隔离性？

因seata一阶段本地事务已提交，为防止其他事务脏读脏写需要加强隔离。

1. 脏读 select语句加for update，代理方法增加@GlobalLock或@GlobalTransaction
2. 脏写 必须使用@GlobalTransaction
   注：如果你查询的业务的接口没有GlobalTransactional 包裹，也就是这个方法上压根没有分布式事务的需求，这时你可以在方法上标注@GlobalLock 注解，并且在查询语句上加 for update。 如果你查询的接口在事务链路上外层有GlobalTransactional注解，那么你查询的语句只要加for update就行。设计这个注解的原因是在没有这个注解之前，需要查询分布式事务读已提交的数据，但业务本身不需要分布式事务。 若使用GlobalTransactional注解就会增加一些没用的额外的rpc开销比如begin 返回xid，提交事务等。GlobalLock简化了rpc过程，使其做到更高的性能。



#### 九、 分布式任务器



#### 十、常见问题

1、nacos 服务停了，客户端启动会出现如下错误：

```
ava.lang.IllegalStateException: failed to req API:/nacos/v1/ns/instance/list after all servers([192.168.66.40:8848]) tried: failed to req API:192.168.66.40:8848/nacos/v1/ns/instance/list. code:500 msg: java.net.ConnectException: Connection refused: connect
	at com.alibaba.nacos.client.naming.net.NamingProxy.reqAPI(NamingProxy.java:467) ~[nacos-client-1.1.4.jar:na]
```

解决：确认nacos运行状态

2、seata server 未启动\事务分组设置错误会提示，客户端错误如下：

```
2020-01-10 09:39:26.276 ERROR 7128 --- [imeoutChecker_1] i.s.c.r.netty.NettyClientChannelManager  : no available service 'default' found, please make sure registry config correct
2020-01-10 09:39:26.293 ERROR 7128 --- [imeoutChecker_2] i.s.c.r.netty.NettyClientChannelManager  : no available service 'default' found, please make sure registry config correct
2020-01-10 09:39:31.278 ERROR 7128 --- [imeoutChecker_1] i.s.c.r.netty.NettyClientChannelManager  : no available service 'default' found, please make sure registry config correct
2020-01-10 09:39:31.292 ERROR 7128 --- [imeoutChecker_2] i.s.c.r.netty.NettyClientChannelManager  : no available service 'default' found, please make sure registry config correct
```

解决：确认seata server 运行状态

3、确认steata serve 是否注册到nacos上

```
io.seata.common.exception.FrameworkException: can not register RM,err:can not connect to services-server.
```

