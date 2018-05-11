# Windows上搭建Flume运行环境


## 一、概述

1、先安装JDK

2、下载

[官方下载地址](http://flume.apache.org/download.html)
[官方用户手册](http://flume.apache.org/documentation.html)

http://www.apache.org/dyn/closer.lua/flume/1.8.0/apache-flume-1.8.0-bin.tar.gz

## 二、例子一


根据官方用户手册，创建一个简单例子监听44444端口的输入并在console中输出。

1、进入apache-flume-1.8.0-bin\conf文件夹中创建一个example.conf文件

```
# example.conf: A single-node Flume configuration

# Name the components on this agent
a1.sources = r1
a1.sinks = k1
a1.channels = c1

# Describe/configure the source
a1.sources.r1.type = netcat
a1.sources.r1.bind = localhost
a1.sources.r1.port = 44444

# Describe the sink
a1.sinks.k1.type = logger

# Use a channel which buffers events in memory
a1.channels.c1.type = memory
a1.channels.c1.capacity = 1000
a1.channels.c1.transactionCapacity = 100

# Bind the source and sink to the channel
a1.sources.r1.channels = c1
a1.sinks.k1.channel = c1
```

2、使用cmd，进入apache-flume-1.8.0-bin/bin，运行下面命令启动Flume

```
flume-ng agent --conf ../conf --conf-file ../conf/example.conf --name a1 -property flume.root.logger=INFO,console
```

在console最后能看到下面这个端口监听提示表示Flume进程正常启动了。


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/62.png)


3、启动另外一个cmd，使用telnet连接到44444端口并发送信息Hello World!

```
telnet localhost 44444
```

4、在Flume的console中可以看到如下提示

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/63.png)


## 其他配置

flume => kafka

配置一

```
#agent

producer.sources = s
producer.channels = c
producer.sinks = r

#source
producer.sources.s.type = netcat
producer.sources.s.bind = localhost
producer.sources.s.port = 44444
producer.sources.s.channels = c

producer.sinks.r.type = org.apache.flume.sink.kafka.KafkaSink
producer.sinks.r.kafka.topic = flumeTopic
producer.sinks.r.kafka.bootstrap.servers = localhost:9092
producer.sinks.r.kafka.flumeBatchSize = 20
producer.sinks.r.kafka.producer.acks = 1
producer.sinks.r.kafka.producer.linger.ms = 1
producer.sinks.r.kafka.producer.compression.type = snappy


#Specify the channel for the sink

producer.sinks.r.channel = c
producer.channels.c.type = memory
producer.channels.c.capacity = 1000
```

配置2

```
# 定义 agent
a1.sources = src1
a1.channels = ch1
a1.sinks = k1
# 定义 sources
a1.sources.src1.type = exec
a1.sources.src1.command=tail -F /home/centos/log/log
a1.sources.src1.channels=ch1
# 定义 sinks
a1.sinks.k1.type = org.apache.flume.sink.kafka.KafkaSink
a1.sinks.k1.topic = flumeTopic
a1.sinks.k1.brokerList = localhost:9092
a1.sinks.k1.batchSize = 20
a1.sinks.k1.requiredAcks = 1
a1.sinks.k1.channel = ch1

# 定义 channels
a1.channels.ch1.type = memory
a1.channels.ch1.capacity = 1000
```