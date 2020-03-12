## 前言

日志这个东西在日常开发中起了很重要的作用。当你的服务部署到服务器上去，报了出了你意想不到的的错误，然后通过ssh去连接服务器查看日志，还要使用grep语句等查找语句，如果是直接部署到服务器还好，但是部署到Docker上面的话，那查看日志就更加麻烦了。
 所以为了方便，能快速找到报出异常的日志，搭建ELK平台是十分重要的。

本文先讲解Logstash的搭建，Logstash的主要作用是解析日志。

## 日志统一

能快速定位错误日志的前提是，正确的打日志。为了方便我们解析日志，我们所有的项目需要统一日志格式。

在我们项目中，我们统一用logback打印日志，配置统一的logback文件即可。

贴下我们logback的配置



```xml
<configuration scan="true" scanPeriod="3 seconds" debug="false">

    <contextName>scj</contextName>
    <!--配置常量，在后面的配置中使用 -->
    <property name="PROJECT_NAME" value="scj-web" />
    <!--定义日志文件的存储地址 勿在 LogBack 的配置中使用相对路径 -->
    <property name="LOG_HOME" value="/app/logs/${PROJECT_NAME}" />
    <!--定义日志输出格式 -->
    <property name="LOG_PATTERN" value="%d{yyyy-MM-dd HH:mm:ss.SSS} [%X{ip}] [%thread] %-5level %logger{60} - %msg%n" />
    <!-- 定义日志输出字符集 -->
    <property name="LOG_CHARSET" value="UTF-8" />


    <!-- 控制台 -->
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>${LOG_PATTERN}</pattern>
            <charset>${LOG_CHARSET}</charset>
        </encoder>
    </appender>
    <!-- 全量日志 -->
    <appender name="PROJECT-COMMON" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_HOME}/${PROJECT_NAME}-common.log</file>
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>${LOG_PATTERN}</pattern>
            <charset>${LOG_CHARSET}</charset>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_HOME}/${PROJECT_NAME}-common_%d{yyyy-MM-dd}.log
            </fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
    </appender>
    <!-- 错误日志 -->
    <appender name="PROJECT-ERROR" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_HOME}/${PROJECT_NAME}-error.log</file>
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>${LOG_PATTERN}</pattern>
            <charset>${LOG_CHARSET}</charset>
        </encoder>
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>ERROR</level>
        </filter>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_HOME}/${PROJECT_NAME}-error_%d{yyyy-MM-dd}.log
            </fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
    </appender>
    <!-- 业务日志 -->
    <appender name="PROJECT-BIZ" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_HOME}/${PROJECT_NAME}-biz.log</file>
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>${LOG_PATTERN}</pattern>
            <charset>${LOG_CHARSET}</charset>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_HOME}/${PROJECT_NAME}-biz_%d{yyyy-MM-dd}.log
            </fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
    </appender>
    <!-- 持久层日志 -->
    <appender name="PROJECT-DAL" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_HOME}/${PROJECT_NAME}-dal.log</file>
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>${LOG_PATTERN}</pattern>
            <charset>${LOG_CHARSET}</charset>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_HOME}/${PROJECT_NAME}-dal_%d{yyyy-MM-dd}.log
            </fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
    </appender>
    <!-- 调用dubbo日志 -->
    <appender name="PROJECT-INTEG" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_HOME}/${PROJECT_NAME}-integ.log</file>
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>${LOG_PATTERN}</pattern>
            <charset>${LOG_CHARSET}</charset>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_HOME}/${PROJECT_NAME}-integ_%d{yyyy-MM-dd}.log
            </fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
    </appender>


    <appender name="PROJECT-SHIRO" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_HOME}/${PROJECT_NAME}-shiro.log</file>
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>${LOG_PATTERN}</pattern>
            <charset>${LOG_CHARSET}</charset>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_HOME}/${PROJECT_NAME}-shiro_%d{yyyy-MM-dd}.log
            </fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
    </appender>

    <appender name="PROJECT-CAS" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_HOME}/${PROJECT_NAME}-cas.log</file>
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>${LOG_PATTERN}</pattern>
            <charset>${LOG_CHARSET}</charset>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_HOME}/${PROJECT_NAME}-cas_%d{yyyy-MM-dd}.log
            </fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
    </appender>

    <appender name="PROJECT-MYBATIS" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_HOME}/${PROJECT_NAME}-mybatis.log</file>
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>${LOG_PATTERN}</pattern>
            <charset>${LOG_CHARSET}</charset>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_HOME}/${PROJECT_NAME}-mybatis_%d{yyyy-MM-dd}.log
            </fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
    </appender>

    <appender name="PROJECT-DUBBO" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_HOME}/${PROJECT_NAME}-dubbo.log</file>
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>${LOG_PATTERN}</pattern>
            <charset>${LOG_CHARSET}</charset>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_HOME}/${PROJECT_NAME}-dubbo_%d{yyyy-MM-dd}.log
            </fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
    </appender>

    <appender name="PROJECT-APACHECOMMON" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_HOME}/${PROJECT_NAME}-apachecommon.log</file>
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>${LOG_PATTERN}</pattern>
            <charset>${LOG_CHARSET}</charset>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_HOME}/${PROJECT_NAME}-apachecommon_%d{yyyy-MM-dd}.log
            </fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
    </appender>

    <appender name="PROJECT-ZOOKEEPER" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_HOME}/${PROJECT_NAME}-zookeeper.log</file>
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>${LOG_PATTERN}</pattern>
            <charset>${LOG_CHARSET}</charset>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_HOME}/${PROJECT_NAME}-zookeeper_%d{yyyy-MM-dd}.log
            </fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
    </appender>

    <appender name="PROJECT-SPRING" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_HOME}/${PROJECT_NAME}-spring.log</file>
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>${LOG_PATTERN}</pattern>
            <charset>${LOG_CHARSET}</charset>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_HOME}/${PROJECT_NAME}-spring_%d{yyyy-MM-dd}.log
            </fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
    </appender>

    <appender name="PROJECT-QUARTZ" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_HOME}/${PROJECT_NAME}-quartz.log</file>
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>${LOG_PATTERN}</pattern>
            <charset>${LOG_CHARSET}</charset>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_HOME}/${PROJECT_NAME}-quartz_%d{yyyy-MM-dd}.log
            </fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
    </appender>
    
    <appender name="PROJECT-APACHEHTTP" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_HOME}/${PROJECT_NAME}-apachehttp.log</file>
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>${LOG_PATTERN}</pattern>
            <charset>${LOG_CHARSET}</charset>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_HOME}/${PROJECT_NAME}-apachehttp_%d{yyyy-MM-dd}.log
            </fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
    </appender>
    
    <appender name="PROJECT-OTHER" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_HOME}/${PROJECT_NAME}-other.log</file>
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>${LOG_PATTERN}</pattern>
            <charset>${LOG_CHARSET}</charset>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_HOME}/${PROJECT_NAME}-other_%d{yyyy-MM-dd}.log
            </fileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
    </appender>



    <!-- （1）root中只配置控制台日志，其他所有的日志把additivity设置为true都打到控制台，方便开发阶段定位问题。 -->
    <!-- （2）第三方框架的日志抽取到单独的文件中，并且级别为ERROR。 -->
    <!-- root -->
    <root level="INFO">
        <appender-ref ref="CONSOLE" />
        <appender-ref ref="PROJECT-COMMON" />
        <appender-ref ref="PROJECT-ERROR" />
    </root>



    <!-- 项目自己的日志 -->
    <!-- 业务日志 -->
    <logger name="com.scj.controllers" level="debug" additivity="false">
        <appender-ref ref="PROJECT-BIZ" />
        <appender-ref ref="PROJECT-ERROR" />
    </logger>

    <!-- 其他开源框架的日志不打印到PROJECT-COMMON，但错误级别的会打印到PROJECT-ERROR -->
    <!-- shiro日志 -->
    <logger name="org.apache.shiro" level="debug" additivity="false">
        <appender-ref ref="PROJECT-SHIRO" />
        <appender-ref ref="PROJECT-ERROR" />
    </logger>
    <!-- jasig.cas的日志，error级别 -->
    <logger name="org.jasig.cas" level="debug" additivity="false">
        <appender-ref ref="PROJECT-CAS" />
        <appender-ref ref="PROJECT-ERROR" />
    </logger>
    <!-- mybatis的日志 -->
    <logger name="org.mybatis" level="debug" additivity="false">
        <appender-ref ref="PROJECT-MYBATIS" />
        <appender-ref ref="PROJECT-ERROR" />
    </logger>
    <!-- zookeeper的日志，因为会比较多所以是error级别 -->
    <logger name="org.apache.zookeeper" level="debug" additivity="false">
        <appender-ref ref="PROJECT-ZOOKEEPER" />
        <appender-ref ref="PROJECT-ERROR" />
    </logger>
    <logger name="org.I0Itec.zkclient" level="debug" additivity="false">
        <appender-ref ref="PROJECT-ZOOKEEPER" />
        <appender-ref ref="PROJECT-ERROR" />
    </logger>
    <!-- dubbo的日志，error级别 -->
    <logger name="com.alibaba.dubbo" level="debug" additivity="false">
        <appender-ref ref="PROJECT-DUBBO" />
        <appender-ref ref="PROJECT-ERROR" />
    </logger>
    <!-- apache-common的日志，error级别 -->
    <logger name="org.apache.commons" level="debug" additivity="false">
        <appender-ref ref="PROJECT-APACHECOMMON" />
        <appender-ref ref="PROJECT-ERROR" />
    </logger>
    <!-- spring的日志，error级别 -->
    <logger name="org.springframework" level="debug" additivity="false">
        <appender-ref ref="PROJECT-SPRING" />
        <appender-ref ref="PROJECT-ERROR" />
    </logger>
    <!-- quartz的日志，error级别 -->
    <logger name="org.quartz" level="debug" additivity="false">
        <appender-ref ref="PROJECT-QUARTZ" />
        <appender-ref ref="PROJECT-ERROR" />
    </logger>
    <logger name="org.apache.http" level="debug" additivity="false">
        <appender-ref ref="PROJECT-APACHEHTTP" />
        <appender-ref ref="PROJECT-ERROR" />
    </logger>

    <logger name="com.baidu.disconf" level="info" additivity="false">
        <appender-ref ref="PROJECT-COMMON" />
        <appender-ref ref="PROJECT-ERROR" />
    </logger>

</configuration>
```

### Dubbo Main方式启动设置logback

我们的纯Dubbo项目不是通过web容器启动，所以需要做一些配置让logback生效



```java
public static void main(String[] args) throws Exception {
        System.setProperty("dubbo.application.logger","slf4j");
        MDC.put("ip", InetAddress.getLocalHost().getHostAddress());
        com.alibaba.dubbo.container.Main.main(args);
    }
```

dubbo默认的日志系统是log4j，这边通过设置环境变量把日志系统改为slf4j，slf4j会根据classpath中的桥接包选择具体的日志系统实现。需要注意在pom依赖中去除其他的桥接包，比如org.slf4j.slf4j-log4j12。

### MDC

logback内置的日志字段还是比较少，如果我们需要打印有关业务的更多的内容，包括自定义的一些数据，需要借助logback MDC机制，MDC为“Mapped Diagnostic Context”（映射诊断上下文），即将一些运行时的上下文数据通过logback打印出来；此时我们需要借助org.sl4j.MDC类。

MDC类基本原理其实非常简单，其内部持有一个InheritableThreadLocal实例，用于保存context数据，MDC提供了put/get/clear等几个核心接口，用于操作ThreadLocal中的数据；ThreadLocal中的K-V，可以在logback.xml中声明，最终将会打印在日志中。

那么在logback.xml中，即可在layout中通过声明“%X{userId}”来打印此信息。

### Dubbo Main启动方式设置MDC

这种启动方式设置MDC十分简单
 在main函数中增加一下代码即可



```css
 MDC.put("ip", InetAddress.getLocalHost().getHostAddress());
```

### web容器启动方式设置MDC

这里我们通过监听spring上下文的ContextRefreshedEvent事件实现，代码如下



```java
@Service
@Slf4j
public class MDCListener implements ApplicationListener<ContextRefreshedEvent>{

    @Override
    public void onApplicationEvent(ContextRefreshedEvent contextRefreshedEvent) {
        try {
            MDC.put("ip", InetAddress.getLocalHost().getHostAddress());
        } catch (UnknownHostException e) {
            log.error("MDC 设置ip失败",e);
        }
    }
}
```

### 正确的打日志

日志最大的作用就是排查问题，如果你打的日志没有把问题产生点输出，那这个日志就是白打。在我们项目中，我看到这么一些打印日志的代码



![img](https:////upload-images.jianshu.io/upload_images/9919411-911a151d50cc9eb4.png?imageMogr2/auto-orient/strip|imageView2/2/w/564/format/webp)



把异常也通过占位符输出了，那么会调用e.toString()方法，只会打出当前方法的错误日志，看不到整个异常栈。

正确的做法是



```cpp
log.error("发生错误xxx....",e);
```

日志框架会把整个异常栈打印出来

## Logstash安装

Logstash在Docker中启动，由于公司服务器不能连接elastic官网镜像，所以通过下面命令从docker官方镜像库拉取，版本不能保证是官方最新。



```undefined
docker pull logstash
```

拉好镜像之后就是启动容器了



```jsx
docker run -d 
-v  /app/logs:/app/logs 
-v /etc/logstash/pipeline/first-pipeline.conf:/etc/logstash/pipeline/first-pipeline.conf 
-v /etc/logstash/logstash.yml:/etc/logstash/logstash.yml
-v /app/data/logstash:/app/data/logstash
logstash 
logstash -f /etc/logstash/pipeline/first-pipeline.conf
```

> 上面这个命令我不保证完全正确，因为我都是在rancher配置参数启动的，接下来有空我会写个demo测试

-v  /app/logs:/app/logs 映射日志存储的目录，日志产生的docker容器也需要配置这个
 -v /etc/logstash/pipeline/first-pipeline.conf:/etc/logstash/pipeline/first-pipeline.conf 映射pipeline配置文件
 -v /etc/logstash/logstash.yml:/etc/logstash/logstash.yml 映射logstash配置文件
 -v /app/data/logstash:/app/data/logstash 映射logstash的一些存储文件，我主要想保存file的读取位置，保证镜像升级后不会重新读取

### 一个重要的点

这边需要mark一下， /app/data/logstash这个目录，docker镜像内需要向这个目录写入文件，但是在宿主机权限一般是root用户，docker内部的用户不是root，就算是root id也匹配不上，所以docker容器内向宿主机目录写入的时候会报错。
 两种解决方式，第一种，暴力解决，chmod +777 ，第二种，通过 cat /etc/passwd拿到docker容器内logstash用户id，然后再宿主机，通过chown id  /app/data/logstash设置目录权限。

### 配置文件编写

在使用logstash前，需要对它有一定的了解。logstash的组件其实很简单，主要包括input、filter、output、codec四个部分。

- input 用于读取内容，常用的有stdin(直接从控制台输入)、file(读取文件)等，另外还提供了对接redis、kafka等的插件
- filter 用于对输入的文本进行处理，常用的有grok(基于正则表达式提取字段)、kv(解析键值对形式的数据)、csv、xml等，另外还提供了了一个ruby插件，这个插件如果会用的话，几乎是万能的。
- output 用于把fitler得到的内容输出到指定的接收端，常用的自然是elasticsearch(对接ES)、file(输出到文件)、stdout(直接输出到控制台)
- codec 它用于格式化对应的内容，可以再Input和output插件中使用，比如在output的stdout中使用rubydebug以json的形式输出到控制台

以下是我的配置文件



```dart
input{
        file{
                path => "/app/logs/*/*.log"
                        exclude => "*-error.log"
                        codec => multiline {
                                pattern => "^%{TIMESTAMP_ISO8601}"
                                        what => "previous"
                                        negate => true
                        }
        }
}
filter{
        grok{
                match =>{
                        "message" => "%{TIMESTAMP_ISO8601:date}\s*\[%{DATA:ip}\]\s*\[%{DATA:thread}\]\s*%{LOGLEVEL:level}\s*%{NOTSPACE:clazz}\s*-\s*%{DATA:method}\s*(?<body>[\S\s]*)"
                }
                remove_field => ["@timestamp","host","@version"]

        }
        grok{
                match => {
                        "path" => "/app/logs/%{NOTSPACE:project}/"

                }
        }

        mutate{
                replace => ["date","%{date}+0800"]
}
        date {

                match => ["date", "yyyy-MM-dd HH:mm:ss.SSSZ"]

                        target => "@timestamp"

        }

}
output{
        stdout{
                codec => rubydebug
        }
        elasticsearch{
                hosts => "es:9200"
                        index => "testindex"
        }
}
```

input模块用来配置日志的来源，我这边是文件，codec => multiline用来处理日志分行的情况，异常报错日志有很多行，但是每个日志都是时间开头的

filter用来解析日志，提取有用信息。
 grok模块用来提取字段，我们可以在http://grokdebug.herokuapp.com/这个网站来验证自己写的表达式是否正确，在http://grokdebug.herokuapp.com/patterns可以查看各种自带的配置表达式，我的第一个grok用来解析日志中有用字段，第二个grok通过日志的目录来解析出应用名称。
 mutate模块对时间进行处理，加上时区，不然在kibana查询会有8个小时时间差。
 date模块用来转换时间，经过研究可有可无，直接用date字段即可。

output模块用来选择解析后的日志输出位置，我这边配置了控制台(用于调试)和ES。测试通过后，需要把stdout这块删除。

下面贴上logstash.yml



```kotlin
pipeline:
  batch:
    size: 125
    delay: 50
path:
  data: /app/data/logstash
```

没什么东西，主要设置了path.data,再这个目录下面会保存文件读取位置



![img](https:////upload-images.jianshu.io/upload_images/9919411-5de6502e3031cc63.png?imageMogr2/auto-orient/strip|imageView2/2/w/634/format/webp)

注意这个文件是隐藏的，并且它再plugin/input/file目录下，因为这个读取位置的文件是和file有关的

看下这个文件的内容吧



![img](https:////upload-images.jianshu.io/upload_images/9919411-0544a68a1b2cc361.png?imageMogr2/auto-orient/strip|imageView2/2/w/421/format/webp)

sincedb的格式为inode majorNumber minor Number pos。每行记录每个文件处理进度，比如下面的例子，表示inode为177037的文件处理到25951716位置、inode为176956的文件处理到32955178位置。



```undefined
177037 0 64768 25951716
176956 0 64768 32955178
```

什么是inode请看这篇文章(https://www.cnblogs.com/bkylee/p/5484288.html)

![img](https:////upload-images.jianshu.io/upload_images/9919411-e089f574df92d5ac.png?imageMogr2/auto-orient/strip|imageView2/2/w/839/format/webp)

如果我们测试的时候需要重新读取，那么把这个文件删掉就可以了

## 总结

我这个ELK是给开发测试预发环境使用，因为现在的设计是每个环境搭一套，所以没有必要使用filebeat这种轻量级的收集器，我现在也只是把开发环境搭好了，准备向运维单独申请服务器放置ELK，然后再各个环境启动filebeat，如果ELK消费不过来，中间再弄一个消息队列缓冲。这都是以后的事情了。

下一篇就讲解下Docker搭建ES和Kibana以及一些操作把。相对于本章较简单。

接下来上一点我学习的链接
 logstash官方文档(https://www.elastic.co/guide/en/logstash/current/index.html)
 一篇很好的ELK入门文章(https://www.cnblogs.com/xing901022/p/6596182.html)
 这家伙的logstash介绍也还凑合(http://www.51niux.com/?id=203)
 grok表达式工具网站(http://grokdebug.herokuapp.com/)
 logbakc MDC(http://shift-alt-ctrl.iteye.com/blog/2345272)
 解决Docker不能向宿主机目录写入问题(https://blog.csdn.net/csdn_duomaomao/article/details/78567748)
 logstash处理文件进度记录机制(https://blog.csdn.net/wangyangzhizhou/article/details/53328040)



