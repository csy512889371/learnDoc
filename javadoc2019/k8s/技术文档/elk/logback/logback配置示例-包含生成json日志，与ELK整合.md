一、依赖

由于配置中使用了json格式的日志输出，所以需要引入如下依赖

```
"net.logstash.logback:logstash-logback-encoder:4.11",
```

二、配置说明
1.日志的输出路径

```
<property name="LOG_PATH" value="phantom-log" />
```

2.读取spring容器中的属性，这里是获取项目名称和运行的服务器IP

```
<springProperty scope="context" name="appName" source="spring.application.name" />
<springProperty scope="context" name="ip" source="spring.cloud.client.ipAddress" />
```



3.设置日志的格式

```
<property name="CONSOLE_LOG_PATTERN"
            value="[%d{yyyy-MM-dd HH:mm:ss.SSS} ${ip} ${appName} %highlight(%-5level) %yellow(%X{X-B3-TraceId}),%green(%X{X-B3-SpanId}),%blue(%X{X-B3-ParentSpanId}) %yellow(%thread) %green(%logger) %msg%n"/>
```



4.添加一个输出器，并滚动输出

```
<appender name="FILEERROR" class="ch.qos.logback.core.rolling.RollingFileAppender">
```

5.指定输出的文件位置

```
<file>../${LOG_PATH}/${appName}/${appName}-error.log</file>
```

6.指定滚动输出的策略，按天数进行切分，或者文件大小超过2M进行切分

```
<rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
      <fileNamePattern>../${LOG_PATH}/${appName}/${appName}-error-%d{yyyy-MM-dd}.%i.log</fileNamePattern>
      <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
        <maxFileSize>2MB</maxFileSize>
      </timeBasedFileNamingAndTriggeringPolicy>
    </rollingPolicy>
```

7.下面的文件中一共有四个appender, FILEERROR, FILEEWARN, FILEINFO, logstash。

其中FILEERROR, FILEEWARN, FILEINFO三个是相类似的，只是打印不同级别的日志信息。
logstash是用来生成json格式的日志文件，方便与ELK日志系统进行集成。

三、完整配置

```
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
  <contextName>${HOSTNAME}</contextName>
  <property name="LOG_PATH" value="phantom-log" />
  <springProperty scope="context" name="appName" source="spring.application.name" />
  <springProperty scope="context" name="ip" source="spring.cloud.client.ipAddress" />
  <property name="CONSOLE_LOG_PATTERN"
            value="[%d{yyyy-MM-dd HH:mm:ss.SSS} ${ip} ${appName} %highlight(%-5level) %yellow(%X{X-B3-TraceId}),%green(%X{X-B3-SpanId}),%blue(%X{X-B3-ParentSpanId}) %yellow(%thread) %green(%logger) %msg%n"/>

  <appender name="FILEERROR" class="ch.qos.logback.core.rolling.RollingFileAppender">
    <file>../${LOG_PATH}/${appName}/${appName}-error.log</file>
    <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
      <fileNamePattern>../${LOG_PATH}/${appName}/${appName}-error-%d{yyyy-MM-dd}.%i.log</fileNamePattern>
      <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
        <maxFileSize>2MB</maxFileSize>
      </timeBasedFileNamingAndTriggeringPolicy>
    </rollingPolicy>
    <append>true</append>
    <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
      <pattern>${CONSOLE_LOG_PATTERN}</pattern>
      <charset>utf-8</charset>
    </encoder>
    <filter class="ch.qos.logback.classic.filter.LevelFilter">
      <level>error</level>
      <onMatch>ACCEPT</onMatch>
      <onMismatch>DENY</onMismatch>
    </filter>
  </appender>

  <appender name="FILEWARN" class="ch.qos.logback.core.rolling.RollingFileAppender">
    <file>../${LOG_PATH}/${appName}/${appName}-warn.log</file>
    <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
      <fileNamePattern>../${LOG_PATH}/${appName}/${appName}-warn-%d{yyyy-MM-dd}.%i.log</fileNamePattern>
      <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
        <maxFileSize>2MB</maxFileSize>
      </timeBasedFileNamingAndTriggeringPolicy>
    </rollingPolicy>
    <append>true</append>
    <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
      <pattern>${CONSOLE_LOG_PATTERN}</pattern>
      <charset>utf-8</charset>
    </encoder>
    <filter class="ch.qos.logback.classic.filter.LevelFilter">
      <level>warn</level>
      <onMatch>ACCEPT</onMatch>
      <onMismatch>DENY</onMismatch>
    </filter>
  </appender>

  <appender name="FILEINFO" class="ch.qos.logback.core.rolling.RollingFileAppender">
    <file>../${LOG_PATH}/${appName}/${appName}-info.log</file>
    <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
      <fileNamePattern>../${LOG_PATH}/${appName}/${appName}-info-%d{yyyy-MM-dd}.%i.log</fileNamePattern>
      <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
        <maxFileSize>2MB</maxFileSize>
      </timeBasedFileNamingAndTriggeringPolicy>
    </rollingPolicy>
    <append>true</append>
    <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
      <pattern>${CONSOLE_LOG_PATTERN}</pattern>
      <charset>utf-8</charset>
    </encoder>

    <filter class="ch.qos.logback.classic.filter.LevelFilter">
      <level>info</level>
      <onMatch>ACCEPT</onMatch>
      <onMismatch>DENY</onMismatch>
    </filter>
  </appender>

  <appender name="logstash" class="ch.qos.logback.core.rolling.RollingFileAppender">
    <file>../${LOG_PATH}/${appName}/${appName}.json</file>
    <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
      <fileNamePattern>../${LOG_PATH}/${appName}/${appName}-%d{yyyy-MM-dd}.json</fileNamePattern>
      <maxHistory>7</maxHistory>
    </rollingPolicy>
    <encoder class="net.logstash.logback.encoder.LoggingEventCompositeJsonEncoder">
      <providers>
        <timestamp>
          <timeZone>UTC</timeZone>
        </timestamp>
        <pattern>
          <pattern>
            {
            "ip": "${ip}",
            "app": "${appName}",
            "level": "%level",
            "trace": "%X{X-B3-TraceId:-}",
            "span": "%X{X-B3-SpanId:-}",
            "parent": "%X{X-B3-ParentSpanId:-}",
            "thread": "%thread",
            "class": "%logger{40}",
            "message": "%message",
            "stack_trace": "%exception{10}"
            }
          </pattern>
        </pattern>
      </providers>
    </encoder>
  </appender>

  <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
    <encoder>
      <pattern>${CONSOLE_LOG_PATTERN}</pattern>
      <charset>utf-8</charset>
    </encoder>
    <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
      <level>debug</level>
    </filter>
  </appender>

  <logger name="org.springframework" level="INFO" />
  <logger name="org.hibernate" level="INFO" />
  <logger name="com.kingboy.repository" level="DEBUG" />

  <root level="INFO">
    <appender-ref ref="FILEERROR" />
    <appender-ref ref="FILEWARN" />
    <appender-ref ref="FILEINFO" />
    <appender-ref ref="logstash" />
    <appender-ref ref="STDOUT" />
  </root>
</configuration>
```


