**系统流程:**
 `logback -> kafka -> logstash -> elasticsearch -> kibana`

------

本例的操作系统是在**windons**，**Jdk:1.8**.

------

## 1、 logback介绍：

**logback**:是由log4j创始人设计的又一个开源日志组件,性能比log4j要好，

> 目前主要分为3个模块:
>
> - logback-core:其它两个模块的基础模块。
> - logback-classic:log4j的一个改良版本，同时它完整实现了slf4j的接口。
> - logback-access:访问模块与Servlet容器集成提供通过Http来访问日志的功能。

在**默认**的情况下，SpringBoot 使用logback来记录日志,并用INFO级别输出到控制台。

- ##### 在pom 中引入依赖

其实在实际中不需要直接添加该依赖，你会发现spring-boot-starter其中包含了 spring-boot-starter-logging，该依赖内容包含 Spring Boot 默认的日志框架 logback。

> 简单的说明一下:
>  日志级别从低到高分为:`TRACE < DEBUG < INFO < WARN < ERROR < FATAL`，如果设置为WARN，则低于WARN的信息都不会输出。SpringBoot 的默认级别是`INFO`,若需要设置级别如下：
>
> - 使用命名启动：`java -jar XXX.jar --debug`
> - 在`application.properties`中配置:`logging.level.root:debug`

- ##### 日志配置

> Spring Boot官方推荐优先使用带有-spring的文件名作为,按照如下规则组织配置文件名，就能被正确加载:
>  `logback-spring.xml> logback-spring.groovy> logback.xml> logback.groovy`

**logback-spring.xml例子:**



```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration  scan="true" scanPeriod="60 seconds" debug="false">
    <contextName>logback</contextName>
     <!--定义日志文件的存储地址 勿在 LogBack 的配置中使用相对路径-->  
    <property name="LOG_HOME" value="/home" />
    <!--输出到控制台-->
    <appender name="console" class="ch.qos.logback.core.ConsoleAppender">
      <!--格式化输出：%d表示日期，%thread表示线程名，%-5level：级别从左显示5个字符宽度%msg：日志消息，%n是换行符--> 
        <encoder>
            <pattern>%d{HH:mm:ss.SSS} %contextName [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>

    <!--输出到文件-->
    <appender name="file" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
              <!--日志文件输出的文件名-->
            <FileNamePattern>${LOG_HOME}/TestWeb.log.%d{yyyy-MM-dd}.log</FileNamePattern> 
            <!--日志文件保留天数-->
            <MaxHistory>30</MaxHistory>
        </rollingPolicy>
        <encoder>
  <!--格式化输出：%d表示日期，%thread表示线程名，%-5level：级别从左显示5个字符宽度%msg：日志消息，%n是换行符--> 
            <pattern>%d{HH:mm:ss.SSS} %contextName [%thread] %-5level %logger{36} - %msg%n</pattern>
            <charset>UTF-8</charset>  
        </encoder>
    </appender>

    <root level="info">
        <appender-ref ref="console" />
        <appender-ref ref="file" />
    </root>
</configuration>
```

- ##### 日志使用：

直接在类里面添加`private Logger logger = LoggerFactory.getLogger(this.getClass());`就可以了。

------

## 2、kafka  安装及与logback集成

> kafka  在大数据领域的实时计算、日志采集等场景中， 是业内标准的。
>
> - 10 万级，高吞吐，一般配合大数据类的系统来进行实时数据计算、日志采集等场景。
> - topic 从几十到几百个时候，吞吐量会大幅度下降，在同等机器下，Kafka 尽量保证 topic 数量不要过多，如果要支撑大规模的 topic，需要增加更多的机器资源。
> - 延迟在 ms 级以内。
> - 可用性非常高，分布式，一个数据多个副本，少数机器宕机，不会丢失数据，不会导致不可用。
> - 经过参数优化配置，可以做到 0 丢失。
> - 功能较为简单，主要支持简单的 MQ 功能，在大数据领域的实时计算以及日志采集被大规模使用。

- ##### Kafka安装：

kafka 是依赖zookeeper的，所以在安装kafka之前需要先安装zookeeper
 [zookeeper下载地址](https://www.apache.org/dyn/closer.cgi/zookeeper/)解压进入`conf`复制`zoo_sample.cfg`并改名`zoo.cfg`



```ruby
# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial 
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between 
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just 
# example sakes.
dataDir=/tmp/zookeeper
# the port at which the clients will connect
clientPort=2181
# the maximum number of client connections.
# increase this if you need to handle more clients
#maxClientCnxns=60
#
# Be sure to read the maintenance section of the 
# administrator guide before turning on autopurge.
#
# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
#
# The number of snapshots to retain in dataDir
#autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
#autopurge.purgeInterval=1
```

在**windons**操作系统中，直接双击`bin`中的`zkServer.cmd`就可以直接启动zookeeper。

[kafka下载](http://kafka.apache.org/downloads)，解压，相关配置在`config`文件夹中，可以根据实际情况进行配置，若是zookeeper使用的是默认配置，而kafka中也可以简单的使用默认配置即可。（具体的说明在每个配置中都有说明）

> producer.properties:生产端的配置文件
>  consumer.properties:消费端的配置文件
>  server.properties:服务端的配置文件

配置完成后直接启动kafka`.\bin\windows\kafka-server-start.bat .\config\server.properties`

- ##### Kafka与logback集成：

Kafka与logback集成是使用**[logback-kafka-appender](https://github.com/danielwegener/logback-kafka-appender)**
 首先需要在**pom 中引入依赖**



```xml
     <!--kafka依赖-->
     <dependency>
            <groupId>org.springframework.kafka</groupId>
            <artifactId>spring-kafka</artifactId>
            <version>2.1.6.RELEASE</version>
      </dependency>
      <!--logback-kafka-appender依赖-->
      <dependency>
            <groupId>com.github.danielwegener</groupId>
            <artifactId>logback-kafka-appender</artifactId>
            <version>0.2.0-RC2</version>
      </dependency>
```

在`logback-spring.xml`中增加appender



```xml
   <!-- This is the kafkaAppender -->
<appender name="kafkaAppender" class="com.github.danielwegener.logback.kafka.KafkaAppender">
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
        <topic>applog</topic>
        <!-- we don't care how the log messages will be partitioned  -->
        <keyingStrategy class="com.github.danielwegener.logback.kafka.keying.NoKeyKeyingStrategy" />

        <!-- use async delivery. the application threads are not blocked by logging -->
        <deliveryStrategy class="com.github.danielwegener.logback.kafka.delivery.AsynchronousDeliveryStrategy" />

        <!-- each <producerConfig> translates to regular kafka-client config (format: key=value) -->
        <!-- producer configs are documented here: https://kafka.apache.org/documentation.html#newproducerconfigs -->
        <!-- bootstrap.servers is the only mandatory producerConfig -->
        <producerConfig>bootstrap.servers=localhost:9092</producerConfig>
        <!-- don't wait for a broker to ack the reception of a batch.  -->
        <producerConfig>acks=0</producerConfig>
        <!-- wait up to 1000ms and collect log messages before sending them as a batch -->
        <producerConfig>linger.ms=1000</producerConfig>
        <!-- even if the producer buffer runs full, do not block the application but start to drop messages -->
        <producerConfig>max.block.ms=0</producerConfig>
        <!-- define a client-id that you use to identify yourself against the kafka broker -->
        <producerConfig>client.id=${HOSTNAME}-${CONTEXT_NAME}-logback-relaxed</producerConfig>

    </appender>

    <root level="info">
        <appender-ref ref="kafkaAppender" />
    </root>
```

------

## 3、logstash安装及配置

> Logstash 是开源的服务器端数据处理管道，能够同时从多个来源采集数据，转换数据，然后将数据发送到您最喜欢的 “存储库” 中。

大概**步骤**也很简单：[logstash下载](https://www.elastic.co/cn/downloads/logstash)，解压，配置，启动。

**这里相对具体一点的说一下配置**
 在配置之前首先知道一下logstash的大致工作流程：



```php
input->filter(非必须)->output
```

所以配置文件也是与之对应，大致内容格式如下：



```bash
#　输入
input {
  ...
}
# 过滤器
filter {
  ...
}
# 输出
output {
  ...
}
```

- **输入**

> 采集各种样式、大小和来源的数据，数据往往以各种各样的形式，或分散或集中地存在于很多系统中。 Logstash 支持[各种输入选择](https://www.elastic.co/guide/en/logstash/current/input-plugins.html) ，可以在同一时间从众多常用来源捕捉事件。能够以连续的流式传输方式，轻松地从您的日志、指标、Web 应用、数据存储以及各种 AWS 服务采集数据。在本例当中，我们使用kafka。

[kafka输入相关配置](https://www.elastic.co/guide/en/logstash/current/plugins-inputs-kafka.html#plugins-inputs-kafka-type)
 简单配置如下:



```php
input {
     kafka {
        #Value type is string
        #There is no default value for this setting.
        #A topic regex pattern to subscribe to.The topics configuration will be ignored when using this configuration.
        topics => ["applog"]
        #Value type isstring
        #Default value is "localhost:9092"
        #A list of URLs of Kafka instances to use for establishing the initial connection to the cluster. This list should be in the form of host1:port1,host2:port2 These urls are just used for the initial connection to discover the full cluster membership (which may change dynamically) so this list need not contain the full set of servers (you may want more than one, though, in case a server is down).
        bootstrap_servers => "localhost:9092"
        #Value type is codec
        #Default value is "plain"
        #The codec used for input data. Input codecs are a convenient method for decoding your data before it enters the input, without needing a separate filter in your Logstash pipeline.
        codec => "json"
    }
}
```

- **过滤器**

> 实时解析和转换数据，数据从源传输到存储库的过程中，Logstash 过滤器能够解析各个事件，识别已命名的字段以构建结构，并将它们转换成通用格式，以便更轻松、更快速地分析和实现商业价值。
>
> - 利用 Grok 从非结构化数据中派生出结构
> - 从 IP 地址破译出地理坐标
> - 将 PII 数据匿名化，完全排除敏感字段
> - 简化整体处理，不受数据源、格式或架构的影响
>    我们的[过滤器库](https://www.elastic.co/guide/en/logstash/current/filter-plugins.html)丰富多样，拥有无限可能。
>    本例当中并没使用过滤器，所以配置中是空的（配置可以不写）。

- **输出**

> 选择您的存储库，导出您的数据，尽管 Elasticsearch 是我们的首选输出方向，能够为我们的搜索和分析带来无限可能，但它并非唯一选择。
>  Logstash 提供[众多输出选择](https://www.elastic.co/guide/en/logstash/current/output-plugins.html)，您可以将数据发送到您要指定的地方，并且能够灵活地解锁众多下游用例。
>  [elasticsearch输出相关配置](https://www.elastic.co/guide/en/logstash/current/plugins-outputs-elasticsearch.html)
>  简单配置如下:



```php
output {
  elasticsearch {
    # Value type is uri
    # Default value is [//127.0.0.1]
    #Sets the host(s) of the remote instance. If given an array it will load balance requests across the hosts specified in the `hosts` parameter. Remember the `http` protocol uses the [http](http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-http.html#modules-http) address (eg. 9200, not 9300). `"127.0.0.1"` `["127.0.0.1:9200","127.0.0.2:9200"]` `["http://127.0.0.1"]``["https://127.0.0.1:9200"]` `["https://127.0.0.1:9200/mypath"]` (If using a proxy on a subpath) It is important to exclude [dedicated master nodes](http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html) from the `hosts` list to prevent LS from sending bulk requests to the master nodes. So this parameter should only reference either data or client nodes in Elasticsearch.
    #Any special characters present in the URLs here MUST be URL escaped! This means `#` should be put in as `%23` for instance.
    hosts => [ "localhost:9200" ]
    #Value type is string
    #Default value is "logstash-%{+YYYY.MM.dd}"
    #The index to write events to. This can be dynamic using the `%{foo}` syntax. The default value will partition your indices by day so you can more easily delete old data or only search specific date ranges. Indexes may not contain uppercase characters. For weekly indexes ISO 8601 format is recommended, eg. logstash-%{+xxxx.ww}. LS uses Joda to format the index pattern from event timestamp. Joda formats are defined [here](http://www.joda.org/joda-time/apidocs/org/joda/time/format/DateTimeFormat.html).
    index => "kafka"
  }
}
```

完整配置如下：



```dart
input {
     kafka {
        topics => "applog"    
        bootstrap_servers => "localhost:9092"
        codec => "json"
    }
}
filter {
}
output {
  //控制台输入
  stdout {  codec => rubydebug }
  elasticsearch {
    hosts => [ "localhost:9200" ]
    index => "kafka"
  }

}
```

最后启动：`.\bin\logstash -f .\conf\logstash-kaka.conf`，其中logstash-kaka.conf是配置文件。

------

## 3、elasticsearch 安装及配置。

> Elasticsearch（[下载](https://www.elastic.co/downloads/elasticsearch) ）是一个分布式、RESTful 风格的搜索和数据分析引擎，能够解决不断涌现出的各种用例。
>
> 索引（名词）：
>  如前所述，一个 *索引* 类似于传统关系数据库中的一个 *数据库* ，是一个存储关系型文档的地方。 *索引* (*index*) 的复数词为 *indices* 或 *indexes* 。
>  索引（动词）：
>  *索引一个文档* 就是存储一个文档到一个 *索引* （名词）中以便它可以被检索和查询到。这非常类似于 SQL 语句中的 `INSERT` 关键词，除了文档已存在时新文档会替换就文档情况之外。
>  倒排索引：
>  关系型数据库通过增加一个 *索引* 比如一个 B树（B-tree）索引 到指定的列上，以便提升数据检索速度。?Elasticsearch 和 Lucene 使用了一个叫做 *倒排索引* 的结构来达到相同的目的。
>
> - 默认的，一个文档中的每一个属性都是 *被索引* 的（有一个倒排索引）和可搜索的。一个没有倒排索引的属性是不能被搜索到的。我们将在 [倒排索引](https://elasticsearch.cn/book/elasticsearch_definitive_guide_2.x/inverted-index.html) 讨论倒排索引的更多细节。

------

Elasticsearch的具体可以查看：[Elasticsearch: 权威指南](https://elasticsearch.cn/book/elasticsearch_definitive_guide_2.x/index.html)、[官方文档](https://www.elastic.co/guide/en/elasticsearch/reference/index.html)。
 安装要求：需要先安装jdk，jdk具体版本要根据elasticsearch的版本有关，现在较新的elasticsearch版本都会要求jdk版本必须为1.8或者及以上。

------

虽然elasticsearch是主要使用集群，但是本例只是配置了单机简单演示一下，具体的安装和配置细节在官方文档中都要详细的说明。

- **配置**



```bash
# NOTE: Elasticsearch comes with reasonable defaults for most settings.
#       Before you set out to tweak and tune the configuration, make sure you
#       understand what are you trying to accomplish and the consequences.
```

配置已经提醒不要随意的去修改配置，大部分的配置都有了一个合理的默认值。在本例当中并不需要更新配置文件。其中`.\config\elasticsearch.yml`为主配置，`log4j2.properties`为日志配置，具体配置在配置文件汇总都有具体的说明，可以查看`.\config\elasticsearch.yml`，如下：



```bash
# ---------------------------------- Cluster -----------------------------------
# Use a descriptive name for your cluster:
#cluster.name: my-application

#------------------------------------ Node ------------------------------------
# Use a descriptive name for the node:
#node.name: node-1
# Add custom attributes to the node:
#node.attr.rack: r1
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data (separate multiple locations by comma):
#path.data: /path/to/data
#
# Path to log files:
#path.logs: /path/to/logs
#
# ----------------------------------- Memory -----------------------------------
#
# Lock the memory on startup:
#
#bootstrap.memory_lock: true
#
# Make sure that the heap size is set to about half the memory available
# on the system and that the owner of the process is allowed to use this
# limit.
#
# Elasticsearch performs poorly when the system is swapping the memory.
#
# ---------------------------------- Network -----------------------------------
#
# Set the bind address to a specific IP (IPv4 or IPv6):
#
#network.host: 192.168.0.1
#
# Set a custom port for HTTP:
#
#http.port: 9200
#
# For more information, consult the network module documentation.
#
# --------------------------------- Discovery ----------------------------------
#
# Pass an initial list of hosts to perform discovery when new node is started:
# The default list of hosts is ["127.0.0.1", "[::1]"]
#
#discovery.zen.ping.unicast.hosts: ["host1", "host2"]
#
# Prevent the "split brain" by configuring the majority of nodes (total number of master-eligible nodes / 2 + 1):
#
#discovery.zen.minimum_master_nodes: 
#
# For more information, consult the zen discovery module documentation.
#
# ---------------------------------- Gateway -----------------------------------
#
# Block initial recovery after a full cluster restart until N nodes are started:
#
#gateway.recover_after_nodes: 3
#
# For more information, consult the gateway module documentation.
#
# ---------------------------------- Various -----------------------------------
#
# Require explicit names when deleting indices:
#
#action.destructive_requires_name: true
```

- **启动**
   直接EeasticSearch的home目录中打开在cmd，然后执行`.\bin\elasticsearch.bat`命令。如果你想把 Elasticsearch 作为一个守护进程在后台运行，那么可以在后面添加参数 -d 。
   启动成功后，在浏览器中输入`http://localhost:9200/`，可以看到如下结果：



```json
{
  "name" : "UPL-Xd0",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "BkRY23s-RdmcNjp1SfMUGw",
  "version" : {
    "number" : "6.5.4",
    "build_flavor" : "default",
    "build_type" : "zip",
    "build_hash" : "d2ef93d",
    "build_date" : "2018-12-17T21:17:40.758843Z",
    "build_snapshot" : false,
    "lucene_version" : "7.5.0",
    "minimum_wire_compatibility_version" : "5.6.0",
    "minimum_index_compatibility_version" : "5.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

------

## 5、kibana安装及配置

------

[kibana 下载](https://www.elastic.co/downloads/kibana)
 [kibana 官方中文文档](https://www.elastic.co/guide/cn/kibana/current/index.html)

------

> Kibana 是一款开源的数据分析和可视化平台，它是 Elastic Stack 成员之一，设计用于和 Elasticsearch 协作。您可以使用 Kibana 对 Elasticsearch 索引中的数据进行搜索、查看、交互操作。您可以很方便的利用图表、表格及地图对数据进行多元化的分析和呈现。

- **配置**
   kibana的配置文档home目录下的`.\config\kibana.yml`,在上述的elasticsearch是使用默认配置，所以在本例中重点是在于搭建，所以本例可以直接使用默认配置就可以了，对于配置不做详细说明，想知道的可以参照[官方配置文档说明](https://www.elastic.co/guide/cn/kibana/current/settings.html)。

- **启动**
   进入到kiban的home目录在cmd中执行`.\bin\kibana`,在浏览器中输入`http://localhost:5601`就可以看到kibana的主界面了。

- **简单使用**

  - 1、定义索引模式

    ![img](https:////upload-images.jianshu.io/upload_images/11277994-ab7b64fac4bb205b.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

在主页面的导航中的 `Management`选项进入 Kibana 的定义索引模式 功能，然后选中 `Index Patterns` 选项。最后点击 Add New 定义一个新的索引模式。你可以根据需求 Elasticsearch 的索引重新定义成一个自己需要的索引模式，这里是可以通过通配符来配置的。

- 2、搜索数据

  ![img](https:////upload-images.jianshu.io/upload_images/11277994-d3626ba8643d99ff.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

在主页面的导航中的 Discover 进入 Kibana 的搜索数据功能，可以选择上述的定义索引模式 ，如图中的`ka*`。在搜索框中可以通过 [Elasticsearch 查询语句](https://www.elastic.co/guide/en/elasticsearch/reference/6.0/query-dsl-query-string-query.html#query-string-syntax) 来搜索数据。

- 3、可视化数据

  ![img](https:////upload-images.jianshu.io/upload_images/11277994-349210e2ce67c88a.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

  在主页面的导航中的 Visualize 进入 Kibana 的可视化数据功能 。根据提示构建相应的图。



