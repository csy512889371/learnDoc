在开发中比较常见的还是log4j，基本上每个开发者都知道，但是使用logback输出日志，估计用的人不多，其实这两个都是slf4j的实现，而且是同一个作者。



Log4j是Apache的一个开源项目，通过使用Log4j，我们可以控制日志信息输送的目的地是控制台、文件、GUI组件，甚至是套接口服务器、NT的事件记



录器、UNIX Syslog守护进程等；我们也可以控制每一条日志的输出格式；通过定义每一条日志信息的级别，我们能够更加细致地控制日志



的生成过程。最令人感兴趣的就是，这些可以通过一个配置文件来灵活地进行配置，而不需要修改应用的代码。。Logback是由log4j创始人设计的又一个开源日志组件。logback当前分成三个模块：logback-core,logback- classic和logback-access。logback-core是其它两个模块的基础模块。logback-classic是log4j的一个改良版本。logback-classic完整实现SLF4J API使你可以很方便地更换成其它日志系统如log4j或JDK14 Logging。logback-access访问模块与Servlet容器集成提供通过Http来访问日志的功能。 Logback是要与SLF4J结合起来用两个组件的官方网站如下：



    logback的官方网站： http://logback.qos.ch
    
    SLF4J的官方网站：http://www.slf4j.org



使用logback的好处：比log4j更加好用，而且效率更高。
首先在pom.xml中引入如下依赖jar：



```
<span style="font-family:SimSun;font-size:14px;"><dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-classic</artifactId>
    <version>1.1.8</version>
</dependency></span>
配置logback.xml文件，配置信息如下：
<span style="font-family:SimSun;font-size:14px;"><?xml version="1.0" encoding="UTF-8" ?>
 <configuration scan="true" scanPeriod="10 minutes">
 <property name="LOG_HOME" value="F:\\logs"/>

 <appender name="stdot" class="ch.qos.logback.core.ConsoleAppender">        
  <layout class="ch.qos.logback.classic.PatternLayout">           
   <pattern>%d{yyyy-MM-dd HH:mm:ss} [%p][%c][%M][%L]-> %m%n</pattern>        
  </layout>
 </appender>
 <appender name="file" class="ch.qos.logback.core.rolling.RollingFileAppender">       
  <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">           
   <FileNamePattern>${LOG_HOME}/log.%d{yyyy-MM-dd}(%i).log</FileNamePattern>          、       
   <cleanHistoryOnStart>true</cleanHistoryOnStart>          
   <TimeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">              
    <MaxFileSize>10MB</MaxFileSize>          
   </TimeBasedFileNamingAndTriggeringPolicy>      
  </rollingPolicy>       
  <encoder>       
    <charset>utf-8</charset>           
    <pattern>%d{yyyy-MM-dd HH:mm:ss} [%p][%c][%M][%L]-> %m%n</pattern>  
  </encoder>       
  <append>false</append>       
  <prudent>false</prudent>
 </appender>

 <logger name="org.mortbay.log" additivity="false"  level="ERROR">
       <appender-ref ref="stdot" />
 </logger>

 <logger name="org.mybatis.spring" additivity="false"  level="ERROR">
       <appender-ref ref="stdot" />
 </logger>

 <root level="debug">     
  <appender-ref ref="stdot" />    
  <appender-ref ref="file" />
 </root>

</configuration></span>
```

其中，level 是日志记录的优先级，分为OFF、FATAL、ERROR、WARN、INFO、DEBUG、ALL或者自定义的级别。Log4j建议只使用四个级别，优先级从高到低分别是ERROR、WARN、INFO、DEBUG。通过在这里定义的级别，您可以控制到应用程序中相应级别的日志信息的开关。比如在这里定义了INFO级别，只有等于及高于这个级别的才进行处理，则应用程序中所有DEBUG级别的日志信息将不被打印出来。ALL:打印所有的日志，OFF：关闭所有的日志输出。 appenderName就是指定日志信息输出到哪个地方。可同时指定多个输出目的地

配置完成之后把logback.xml文件放在资源文件目录下，启动项目即可。logback会根据logback这个名称自己去匹配加载。

```
<pattern>%d{yyyy-MM-dd HH:mm:ss} [%p][%c][%M][%L]-> %m%n</pattern> 
```

以上格式说明如下：

```
%m

输出代码中指定的消息

%p

输出优先级，即DEBUG，INFO，WARN，ERROR，FATAL

%r

输出自应用启动到输出该log信息耗费的毫秒数

%c

输出所属的类目，通常就是所在类的全名

%t

输出产生该日志事件的线程名

%n

输出一个回车换行符，Windows平台为“\r\n”，Unix平台为“\n”

%d

输出日志时间点的日期或时间，默认格式为ISO8601，也可以在其后指定格式，比如：%d{yyy MMM dd HH:mm:ss,SSS}，

输出类似：2002年10月18日 22：10：28，921

%l

输出日志事件的发生位置，包括类目名、发生的线程，以及在代码中的行数。举例：Testlog4.main(TestLog4.java:10)
```


