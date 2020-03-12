# slf4j-logback 日志以json格式导入ELK

同事整理的，在此分享。logback，log4j2 等slf4j的日志实现都可以以json格式输出日志， 这里采用的是logback。当然也可以以文本行的格式输出，然后在logstash里通过grok解析，但是直接以json格式输出，在logstash处理时效率会高一点。



### Logback 输出 Json格式日志文件

 为了让 logback 输出JSON 格式的日志文件，需要在pom.xml 加入如下依赖

```
<dependency>

   <groupId>net.logstash.logback</groupId>

   <artifactId>logstash-logback-encoder</artifactId>

   <version>4.8</version>

   <scope>runtime</scope>

</dependency>
```

logback日志配置示例
```
<appender name="errorFile" class="ch.qos.logback.core.rolling.RollingFileAppender">

   <filter class="ch.qos.logback.classic.filter.LevelFilter">

      <level>ERROR</level>

      <onMatch>ACCEPT</onMatch>

      <onMismatch>DENY</onMismatch>

   </filter>

   <file>${log.dir}/elk/error.log</file> <!-- 当前的日志文件文件放在 elk文件下，该日志的内容会被filebeat传送到es --> 

   <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">  <! -- 历史日志会放到 bak 文件下，最多保存7天的历史，最多占用 1G的空间 -->

      <fileNamePattern>${log.dir}/bak/error.%d{yyyy-MM-dd}.log</fileNamePattern>

      <maxHistory>7</maxHistory>

      <totalSizeCap>1GB</totalSizeCap>

   </rollingPolicy>

   <encoder class="net.logstash.logback.encoder.LoggingEventCompositeJsonEncoder">

       

      <providers>

         <pattern>

            <pattern>

              {

　　　　　　　　　　　　　　"tags": ["errorlog"],

　　　　　　　　　　　　　　"project": "myproject",

　　　　　　　　　　　　　　"timestamp": "%date{\"yyyy-MM-dd'T'HH:mm:ss,SSSZ\"}",

　　　　　　　　　　　　　　"log_level": "%level",

　　　　　　　　　　　　　　"thread": "%thread",

　　　　　　　　　　　　　　"class_name": "%class",

　　　　　　　　　　　　　　"line_number": "%line",

　　　　　　　　　　　　　　"message": "%message",

　　　　　　　　　　　　　　"stack_trace": "%exception{5}",

　　　　　　　　　　　　　　"req_id": "%X{reqId}",

　　　　　　　　　　　　　　"elapsed_time": "#asLong{%X{elapsedTime}}"

　　　　　　　　　　　　　　}

            </pattern>

         </pattern>

      </providers>

   </encoder>

</appender>
```

 

 

Json 字段说明:

| 名称           | 说明                               | 备注                |      |      |      |      |      |
| -------------- | ---------------------------------- | ------------------- | ---- | ---- | ---- | ---- | ---- |
| tags           | 用于说明这条日志是属于哪一类日志   |                     |      |      |      |      |      |
| `timestamp`    | 日志记录时间                       |                     |      |      |      |      |      |
| `project`      | 系统名称，该日志来自于哪个系统     |                     |      |      |      |      |      |
| `log_level`    | 输出日志级别                       |                     |      |      |      |      |      |
| `thread`       | 输出产生日志的线程名。             |                     |      |      |      |      |      |
| `class_name`   | 输出执行记录请求的调用者的全限定名 | ` `                 |      |      |      |      |      |
| `line_number`  | 输出执行日志请求的行号             | ` `                 |      |      |      |      |      |
| `message`      | 输出应用程序提供的信息             |                     |      |      |      |      |      |
| `stack_trace`  | 异常栈信息                         |                     |      |      |      |      |      |
| `req_id`       | 请求ID，用于追踪请求               | 需要引入aop-logging |      |      |      |      |      |
| `elapsed_time` | 该方法执行时间,单位: 毫秒          | 需要引入aop-logging |      |      |      |      |      |



```
%X{key}: 表示该项来自于SLF4j MDC,需要引入 aop-logging
```

```
<dependency>

        <groupId>com.cloud</groupId>

         <artifactId>xspring-aop-logging</artifactId>

        <version>0.7.1</version>

</dependency>

 

针对web应用，在 web.xml 中加入 ReqIdFilter,该过滤器会在MDC 加入 reqId

<filter>

    <filter-name>aopLogReqIdFilter</filter-name>

    <filter-class>com.github.nickvl.xspring.core.log.aop.ReqIdFilter</filter-class>

</filter>

 

<filter-mapping>

    <filter-name>aopLogReqIdFilter</filter-name>

    <url-pattern>/*</url-pattern>

</filter-mapping>

 

 

or register in springboot like this:

 

 

@Bean

public FilterRegistrationBean getDemoFilter(){

    ReqIdFilter reqIdFilter=new ReqIdFilter();

    FilterRegistrationBean registrationBean=new FilterRegistrationBean();

    registrationBean.setFilter(reqIdFilter);

    List<String> urlPatterns=new ArrayList<String>();

    urlPatterns.add("/*");

    registrationBean.setUrlPatterns(urlPatterns);

    registrationBean.setOrder(100);

    return registrationBean;

}

 

如果需要记录该方法执行时间: elapsed_time，如果在该类或者方法上加入如下注解：

 

import com.github.nickvl.xspring.core.log.aop.annotation.LogDebug;

import com.github.nickvl.xspring.core.log.aop.annotation.LogInfo;

 

@LogInfo  // 当logger 设为level=INFO 会输出

@LogException(value = {@Exc(value = Exception.class, stacktrace = false)}, warn = {@Exc({IllegalArgumentException.class})}) //

当logger 设为level=error 会输出

 

针对dubbo 消费者的日志记录,dubbo消费者是通过 javassist 生成的动态类型,如果要监控该dubbo接口的传入参数，返回值，和调用时间 需要引入aop-logging,

以及在 eye-rpc包中的接口上给对应的类或方法 加上上面的注解。

dubbo 消费者的日志会输出如下配置:

 

 <logger name="com.alibaba.dubbo.common.bytecode" level="INFO" additivity="false">

   <appender-ref ref="dubboApiFile"/>

</logger>
```
 



### ElasticSearch 模板设置

```
curl -XPUT http://localhost:9200/_template/log -d '{

  "mappings": {

    "_default_": {

      "_all": {

        "enabled": false

      },

      "_meta": {

        "version": "5.1.1"

      },

      "dynamic_templates": [

        {

          "strings_as_keyword": {

            "mapping": {

              "ignore_above": 1024,

              "type": "keyword"

            },

            "match_mapping_type": "string"

          }

        }

      ],

      "properties": {

        "@timestamp": {

          "type": "date"

        },

        "beat": {

          "properties": {

            "hostname": {

              "ignore_above": 1024,

              "type": "keyword"

            },

            "name": {

              "ignore_above": 1024,

              "type": "keyword"

            },

            "version": {

              "ignore_above": 1024,

              "type": "keyword"

            }

          }

        },

        "input_type": {

          "ignore_above": 1024,

          "type": "keyword"

        },

        "message": {

          "norms": false,

          "type": "text"

        },

        "offset": {

          "type": "long"

        },

        "source": {

          "ignore_above": 1024,

          "type": "keyword"

        },

        "tags": {

          "ignore_above": 1024,

          "type": "keyword"

        },

        "type": {

          "ignore_above": 1024,

          "type": "keyword"

        }

      }

    }

  },

  "order": 0,

  "settings": {

    "index.refresh_interval": "5s"

  },

  "template": "log-*"

}'

 

curl -XPUT http://localhost:9200/_template/log-java -d '

 

{

  "mappings": {

    "_default_": {

      "properties": {

        "log_level": {

          "ignore_above": 1024,

          "type": "keyword"

        },

        "project": {

          "ignore_above": 1024,

          "type": "keyword"

        },

        "thread": {

          "ignore_above": 1024,

          "type": "keyword"

        },

        "req_id": {

          "ignore_above": 1024,

          "type": "keyword"

        },

        "class_name": {

          "ignore_above": 1024,

          "type": "keyword"

        },

        "line_number": {

          "type": "long"

        },

        "exception_class":{

          "ignore_above": 1024,

          "type": "keyword"

        },

        "elapsed_time": {

          "type": "long"

        },

        

        "stack_trace": {

          "type": "keyword"

        }

      }

    }

  },

  "order": 1,

  "settings": {

    "index.refresh_interval": "5s"

  },

  "template": "log-java-*"

}'
```



### logstatsh 设置

**logstash-java-log**

```
if [fields][logType] == "java" {

    json {

        source => "message"

        remove_field => ["offset"]

    }

    date {

        match => ["timestamp","yyyy-MM-dd'T'HH:mm:ss,SSSZ"]

        remove_field => ["timestamp"]

    }

    if [stack_trace] {

         mutate {

            add_field => { "exception_class" => "%{stack_trace}" }

        }

    }

    if [exception_class] {

         mutate {

            gsub => [

                "exception_class", "\n", "",

                "exception_class", ":.*", ""

            ]

        }

    }

}
```



### filebeat 设置

**filebeat.yml**

```
filebeat.prospectors:

- input_type: log

  paths:

    - /eyebiz/logs/eyebiz-service/elk/*.log   # eyebiz-service 日志

    - /eyebiz/logs/eyebiz-web/elk/*.log       # eyebiz-web 日志

  fields:

    logType: "java"

    docType: "log-java-dev"
```

