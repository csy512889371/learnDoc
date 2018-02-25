# 开源配置中心 - Apollo

Apollo（阿波罗）是携程框架部门研发的配置管理平台，能够集中化管理应用不同环境、不同集群的配置，配置修改后能够实时推送到应用端，并且具备规范的权限、流程治理等特性。服务端基于Spring Boot和Spring Cloud开发，打包后可以直接运行，不需要额外安装Tomcat等应用容器。

# 检出代码

[apollo github](https://github.com/ctripcorp/apollo)

* 可以fork下然后本地使用idea打开


# 数据库脚本

> 执行以下脚本创建ApolloConifgDB、ApolloPortalDB

* apollo.scripts.sql.apolloconfigdb.sql
* apollo.scripts.sql.apolloportaldb.sql

# 启动configservice adminservice

## Main class配置

> com.ctrip.framework.apollo.assembly.ApolloApplication

> VM opions
```xml
-Dapollo_profile=github 
-Dspring.datasource.url=jdbc:mysql://localhost:3306/ApolloConfigDB?characterEncoding=utf8 
-Dspring.datasource.username=root 
-Dspring.datasource.password=

```

Program arguments
```xml
--configservice --adminservice
```
 
> 启动完后，打开http://localhost:8080可以看到apollo-configservice和apollo-adminservice都已经启动完成并注册到Eureka

# 启动Apollo-Portal

## Main class配置

> com.ctrip.framework.apollo.portal.PortalApplication
```xml
-Dapollo_profile=github,auth 
-Ddev_meta=http://localhost:8080/ 
-Dserver.port=8070 
-Dspring.datasource.url=jdbc:mysql://localhost:3306/ApolloPortalDB?characterEncoding=utf8 
-Dspring.datasource.username=root 
-Dspring.datasource.password=
```

* 如果启用了auth profile的话，默认的用户名是apollo，密码是admin

## 应用在SIT、UAT、生产环境机器上

* 1.新增目录/opt/data/目录，且有可读写权限；
* 2.新增文件：/opt/settings/server.properties 且加入配置:
```java
env=DEV
sit: env=FAT
uat: env=UAT
生产：env=PRO
```

## 客户端例子

* @Component 设置组件名称
* @RefreshScope 指定配置改变可以刷新

```java
@ConfigurationProperties(prefix = "redis.cache")
@Component("sampleRedisConfig")
@RefreshScope
public class SampleRedisConfig {

  private static final Logger logger = LoggerFactory.getLogger(SampleRedisConfig.class);

  private int expireSeconds;
  private String clusterNodes;
  private int commandTimeout;

  private Map<String, String> someMap = Maps.newLinkedHashMap();
  private List<String> someList = Lists.newLinkedList();

  @PostConstruct
  private void initialize() {
    logger.info(
        "SampleRedisConfig initialized - expireSeconds: {}, clusterNodes: {}, commandTimeout: {}, someMap: {}, someList: {}",
        expireSeconds, clusterNodes, commandTimeout, someMap, someList);
  }

  public void setExpireSeconds(int expireSeconds) {
    this.expireSeconds = expireSeconds;
  }

  public void setClusterNodes(String clusterNodes) {
    this.clusterNodes = clusterNodes;
  }

  public void setCommandTimeout(int commandTimeout) {
    this.commandTimeout = commandTimeout;
  }

  public Map<String, String> getSomeMap() {
    return someMap;
  }

  public List<String> getSomeList() {
    return someList;
  }

  @Override
  public String toString() {
    return String.format(
        "[SampleRedisConfig] expireSeconds: %d, clusterNodes: %s, commandTimeout: %d, someMap: %s, someList: %s",
            expireSeconds, clusterNodes, commandTimeout, someMap, someList);
  }
}

```


## 设置监听
```java
@Component
public class SpringBootApolloRefreshConfig {
  private static final Logger logger = LoggerFactory.getLogger(SpringBootApolloRefreshConfig.class);

  @Autowired
  private ApolloRefreshConfig apolloRefreshConfig;

  @Autowired
  private SampleRedisConfig sampleRedisConfig;

  @Autowired
  private RefreshScope refreshScope;

  @ApolloConfigChangeListener
  public void onChange(ConfigChangeEvent changeEvent) {
    logger.info("before refresh {}", sampleRedisConfig.toString());
    refreshScope.refresh("sampleRedisConfig");
    logger.info("after refresh {}", sampleRedisConfig.toString());
  }
}

```








