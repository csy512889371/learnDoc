# java 日志格式化

文章导航

# 1.日志的重要性

不管我们使用何种语言开发,一旦程序发生异常，日志是一个很重要的数据。但是并不是意味着打印的日志越多越好，我们需要的是有用的日志。
曾经参与一个很重要的项目优化，他们的日志没有进行规范，开发、运维也没有把这个事情放在心上。等到压测的时候TPS和响应时间一直上不去。通过jstack分析发现，大部分的log数据在阻塞！
今天我们不讨论具体的日志规范，我从日志中心的角度来聊下LOG的规范

# 2.日志采集分析 -ELK

目前主流的ELK系统应该都是通过agent端(filebeat/flume)采集具体`.log`文件，对于日志没有多大处理的话，我们可能把整条日志采集过来后，通过logstash后把message存储到elasticsearch中。

> 1. 当我们需要从每条日志中提取日志时间、日志级别等等信息的时候，我们需要在logstash配置相应的 `grok`语法解析其中的message信息。
> 2. 当我们的日志中有异常信息，我们需要提取异常信息的时候，你会发现用`grok`来清洗message很困难！其实也有解决的方法，需要你去慢慢写正则匹配

不错，logstash强大的grok及mutate可以满足需求，但是当日志量很大的时候，logstash的grok和mutate会消耗大量的资源。那我们有没有更有的方案呢？
下面我们用java日志来举例吧
在想要得到答案之前，我们需要知道存储到es的最终数据是`JSON`，logstash清洗数据最终的结果是转换成JSON。一般的agent采集端仅仅只是做日志的采集,即使kafka做缓冲，kafka也不做处理。因此我们需要从日志的根源来解决这个问题。

# 3.为什么使用logstash处理Java的异常信息不好做呢？

这就涉及到日志框架输出的异常信息通常是多行的，这就意味着我们需要在filebeat(flume)或者logstash来处理多行的问题。当我们在日志的配置文件没有很好的区分日志的message和stack时，日志是糅杂一块的。提前其中的信息很难很难

# 4. 日志json化

既然原生的日志数据不好处理，那么我们需要对日志框架做些美容手术。
在日志中，我们一般都会打印，时间/日志级别/线程/日志内容/当前文件名/loggerName/异常信息等等。
其中 日志内容和异常信息可能会出现多行。这个需要处理下，下面我们使用fastjson来处理这两个字段，见代码

```
public class MsgConverter extends ClassicConverter {

    @Override
    public String convert(ILoggingEvent event) {
        return JsonUtils.serialize(event.getFormattedMessage());

    }
}
```



```
public class StackTraceConverter extends ThrowableProxyConverter {
    @Override
    public String convert(ILoggingEvent event) {
        IThrowableProxy throwableProxy = event.getThrowableProxy();
        // 如果没有异信息
        if (throwableProxy == null) {
            //返回字符串 ： "\"\""
            return JsonUtils.serialize("");
        }
        String ex = super.convert(event);
        return JsonUtils.serialize(ex);
    }
}
```



其中JsonUtils可以选择合适的json框架来处理

之后在logback.xml中配置



```
<configuration>
    <conversionRule conversionWord="exdiy" converterClass="xxx.logback.converter.StackTraceConverter" />
    <conversionRule conversionWord="msgdiy" converterClass="xxx.logback.converter.MsgConverter" />
</configuration>
```

修改layout -> Pattern



```
<layout>
        <!--<Pattern>{"date":"%date{yyyy-MM-dd HH:mm:ss.SSS}","level":"%level","tid":"%tid","className":"%logger","fileLine":"%file:%line","msg":%message, "stack_trace":%ex }%n</Pattern>-->
    <Pattern>{"date":"%date{yyyy-MM-dd HH:mm:ss.SSS}","level":"%level","className":"%logger","fileName":"%file","thread":"%thread","msg":%msgdiy, "stack_trace":%exdiy}%n</Pattern>
</Pattern>
```



```
{
    "date":"2019-01-02 16:16:33.817",
    "level":"INFO",
    "className":"org.springframework.web.servlet.DispatcherServlet","fileName":"FrameworkServlet.java","thread":"http-nio-8762-exec-1","msg":"FrameworkServlet 'dispatcherServlet': initialization completed in 38 ms", "stack_trace":"" 
}
```



logstash将json字符串转换成json即可

```
json {
       source => "message"
       #target => "doc"
       remove_field => ["message"]
      }
    date {
        match => ["date","yyyy-MM-dd HH:mm:ss.SSS"]
        target => "@timestamp"
        locale => "cn"
        timezone => "Asia/Shanghai"
       }
```



最终效果



![img](https://jjlu521016.github.io/image/loback-elk.jpg)

