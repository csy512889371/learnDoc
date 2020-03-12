之前使用的架构为：`项目日志` -> `Filebeat` -> `redis` -> `Logstash` -> `ElasticSearch` -> `Kibana`
如果使用TCP input的话就可以简化为这样：`项目` -> `Logstash` -> `ElasticSearch` -> `Kibana`
这样可以少去每台服务器上面FileBeat的维护。

项目日志格式：

```
19-03-06 12:17:12 INFO http-nio-8080-exec-3 cn.xxx.xxx.xxx.xxx.XXXUtils.call(246) | request(<?xml version="1.0" encoding="GB2312"?><SendData>xxx</SendData>)

19-03-06 12:17:12 INFO http-nio-8080-exec-3 cn.xxx.xxx.xxx.xxx.XXX.getResultSet2015(34) | api_monitor ---> platform=p1, name=n1, tget=666
```



## 1.修改项目Logback配置

### 1.1.

新增maven依赖

```
<!-- logstash -->
<dependency>
    <groupId>net.logstash.logback</groupId>
    <artifactId>logstash-logback-encoder</artifactId>
    <version>5.3</version>
</dependency>
<!--<dependency>
    <groupId>org.codehaus.janino</groupId>
    <artifactId>janino</artifactId>
    <version>3.0.12</version>
</dependency>-->
```



### 1.2.

修改Logback配置，让其将项目日志通过tcp方式，直接推送到Logstash。
需要修改logback的配置文件。

```
<property name="logger.pattern"
            value="%d{yy-MM-dd HH:mm:ss} %highlight(%p) %yellow(%t) %cyan(%c.%M\\(%L\\)) | %m%n"/>
<appender name="stdout" class="ch.qos.logback.core.ConsoleAppender">
    <encoder charset="${logger.charset}">
        <pattern>${logger.pattern}</pattern>
    </encoder>
</appender>
<appender name="stdout2" class="net.logstash.logback.appender.LogstashTcpSocketAppender">
    <destination>localhost:5044</destination>

    <!--过滤特定日志进行传输-->
    <!--<filter class="ch.qos.logback.core.filter.EvaluatorFilter">
        <evaluator class="ch.qos.logback.classic.boolex.JaninoEventEvaluator">
            <expression>return message.contains("api_monitor");</expression>
        </evaluator>
        <onMatch>ACCEPT</onMatch>
        <onMismatch>DENY</onMismatch>
    </filter>-->

    <encoder charset="${logger.charset}" class="net.logstash.logback.encoder.LoggingEventCompositeJsonEncoder">
        <providers>
            <!--时区的问题可以直接在这里加也可以在logstash加-->
            <!--在logstash的话就是mutate {replace => [ "time","%{time}+08:00" ]}-->
            <timestamp>
                <timeZone>GMT+8</timeZone>
            </timestamp>
            <pattern>
                <pattern>
                    {
                    "time": "%d{yy-MM-dd HH:mm:ss}",
                    "level": "%p",
                    "thread": "%t",
                    "class": "%c.%M\\(%L\\)",
                    "message": "%m"
                    }
                </pattern>
            </pattern>
            <stackTrace>
                <throwableConverter class="net.logstash.logback.stacktrace.ShortenedThrowableConverter">
                    <maxDepthPerThrowable>full</maxDepthPerThrowable>
                    <maxLength>full</maxLength>
                    <shortenedClassNameLength>20</shortenedClassNameLength>
                    <rootCauseFirst>true</rootCauseFirst>
                    <inlineHash>true</inlineHash>
                    <!-- generated class names -->
                    <exclude>\$\$FastClassByCGLIB\$\$</exclude>
                    <exclude>\$\$EnhancerBySpringCGLIB\$\$</exclude>
                    <exclude>^sun\.reflect\..*\.invoke</exclude>
                    <!-- JDK internals -->
                    <exclude>^com\.sun\.</exclude>
                    <exclude>^sun\.net\.</exclude>
                    <!-- dynamic invocation -->
                    <exclude>^net\.sf\.cglib\.proxy\.MethodProxy\.invoke</exclude>
                    <exclude>^org\.springframework\.cglib\.</exclude>
                    <exclude>^org\.springframework\.transaction\.</exclude>
                    <exclude>^org\.springframework\.validation\.</exclude>
                    <exclude>^org\.springframework\.app\.</exclude>
                    <exclude>^org\.springframework\.aop\.</exclude>
                    <exclude>^java\.lang\.reflect\.Method\.invoke</exclude>
                    <!-- Spring plumbing -->
                    <exclude>^org\.springframework\.ws\..*\.invoke</exclude>
                    <exclude>^org\.springframework\.ws\.transport\.</exclude>
                    <exclude>^org\.springframework\.ws\.soap\.saaj\.SaajSoapMessage\.</exclude>
                    <exclude>^org\.springframework\.ws\.client\.core\.WebServiceTemplate\.</exclude>
                    <exclude>^org\.springframework\.web\.filter\.</exclude>
                    <!-- Tomcat internals -->
                    <exclude>^org\.apache\.tomcat\.</exclude>
                    <exclude>^org\.apache\.catalina\.</exclude>
                    <exclude>^org\.apache\.coyote\.</exclude>
                    <exclude>^java\.util\.concurrent\.ThreadPoolExecutor\.runWorker</exclude>
                    <exclude>^java\.lang\.Thread\.run$</exclude>
                </throwableConverter>
            </stackTrace>
        </providers>
    </encoder>
</appender>
<root level="info">
    <appender-ref ref="stdout"/>
    <appender-ref ref="stdout2"/>
</root>
```



## 2.修改Logstash配置文件

### 2.1新增01-tcp-input.conf

```
input {
     tcp {
     	port => 5044
     	codec => json_lines
		type => "tcp-input"
     }
}
```

### 2.2新增10-filter-api-monitor.conf

```
filter {
    if [type] == "tcp-input" {
        if [message] =~ /api_monitor/ {
            dissect {
                mapping => { "message" => "api_monitor%{}platform=%{platform}, name=%{name}, tget=%{tget}" }
                add_field => { "index_prefix" => "api-monitor" }
            }
            mutate {
                gsub => [
                    "tget", "755", "深圳",
                    "tget", "200", "广州",
                    "tget", "760", "中山",
                    "tget", "660", "汕尾",
                    "tget", "668", "茂名",
                    "tget", "754", "汕头",
                    "tget", "756", "珠海",
                    "tget", "757", "佛山",
                    "tget", "759", "湛江",
                    "tget", "758", "肇庆",
                    "tget", "769", "东莞",
                    "tget", "750", "江门",
                    "tget", "751", "韶关",
                    "tget", "662", "阳江",
                    "tget", "768", "潮州",
                    "tget", "752", "惠州",
                    "tget", "762", "河源",
                    "tget", "763", "清远",
                    "tget", "753", "梅州",
                    "tget", "766", "云浮",
                    "tget", "663", "揭阳"
                ]
                remove_field => [ "time" ]
                remove_field => [ "message" ]
            }
        }
    }
}
```

### 2.3新增99-output.conf

```
output {
    if [type] and [type] == "tcp-input" {
        if [index_prefix] {
            elasticsearch {
                hosts => [ "localhost" ]
                index => "%{index_prefix}-%{+YYYY.MM.dd}"
	    }
        } else {
            elasticsearch {
                hosts => [ "localhost" ]
                index => "%{type}-%{+YYYY.MM.dd}"
	    }
	}
    } else {
        elasticsearch {
            hosts => ["localhost"]
            manage_template => false
            index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
            document_type => "%{[@metadata][type]}"
        }
    }
}
```

### 3.检验结果

经过这样配置，当启动项目，有日志生成之后，推送到Logstash，Logstash监听到有消息发送过来之后会经过10-filter-api-monitor.conf的配置进行数据清洗，如果日志有包含api_monitor的字眼，将会被打上index_prefix字段标识，然后在99-output.conf的时候使用该字段进行判断，根据情况，最后如果是tcpinput进来的数据，将会生成两种格式的索引。
使用kibana查看索引将会看到一种为以tcp-input开头的索引以及api_monitor开头的索引。
[![img](http://img.tidyko.com/blog/Logstash-tcp-1.png)](http://img.tidyko.com/blog/Logstash-tcp-1.png)