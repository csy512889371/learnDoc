# 3 kafka 基础


## 一、概述


## 二、Kafka使用背景

在我们大量使用分布式数据库、分布式计算集群的时候，是否会遇到这样一些问题：

** 我想分析一下用户行为（pageviews），以便我能设计出更好的广告位;
* 我想对用户的搜索关键词进行统计，分析出前的流行趋势；
* 有些数据，存数据库浪费，直接存硬盘操作效率又低;
* 这个时候，就可以用消息系统了，尤其是分布式消息系统


kafka的定义:    

* 是一个分布式消息系统，由LinkedIn使用Scala编写，用作LinkedIn的活动流（Activity Stream）和运营数据处理管道（Pipeline）的基础，具有高水平扩展和高吞吐量。
* 应用领域： 已被多家不同类型的公司作为多种类型的数据管道和消息系统使用。如:
** 淘宝，支付宝，百度，twitter等
* 目前越来越多的开源分布式处理系统如Apache flume、Apache Storm、Spark,elasticsearch都支持与Kafka集成。



## 三、Kafka相关概念

### AMQP协议

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/9.png)


一些基本的概念:
* 消费者（Consumer）：从消息队列中请求消息的客户端应用程序；
* 生产者（Producer）：向broker发布消息的客户端应用程序；
* AMQP服务器端（broker）:用来接收生产者发送的消息并将这些消息路由给服务器中的队列；


###  Kafka支持的客户端语言

Kafka 客户端支持当前大部分主流语言，包括:  C、C++、Erlang、Java、.net、perl、PHP、Python、Ruby、Go、Javascript。

可以使用以上任何一种语言和kafka服务器进行通信（即编写自己的consumer和producer程序）



### Kafka架构

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/10.png)


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/11.png)

一些基本的概念:

* 主题（Topic）：一个主题类似新闻中的体育、娱乐、教育等分类概念，在实际工程中通常一个业务一个主题；

* 分区（Partition）：一个topic中的消息数据按照多个分区组织，分区是kafka消息队列组织的最小单位，一个分区可以看做是一个FIFO的队列;

* 备份（Replication）：为了保证分布式可靠性,kafka0.8开始对每个分区的数据进行备份（不同Broker上），防止其中一个Broker宕机造成分区数据不可用


* zookeeper：一个提供分布式状态管理、分布式配置管理、分布式锁服务等的集群

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/12.png)

## 四、zookeeper集群搭建


### zk集群搭建

软件环境:

```
Linux服务器一台、三台、五台（2*n+1台）；
Java jdk 1.7；
zookeeper 3.4.6版；
```


在任一台机器运行sh zkServer.sh status出现下面两幅图中任一输出结果，说明你的集群成功搭建。


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/13.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/14.png)

### kafka 集群搭建


软件环境:
* Linux服务器一台或多台；
* 已经搭建好zookeeper集群；
* kafka_2.9.2-0.8.1.1 ；

启动kafka集群命令:

```
kafka-server-start.sh -daemon $KAFKA_HOME/config/server.properties
```


在两台机器上运行http://kafka.apache.org/documentation.html#quickstart里面step3-step5 成功(步骤中要将localhoast换成自己的机器ip)


### 集群配置参数介绍


重要配置:

* server.properties 文件；
* consumer.properties 文件；
* producer.properties 文件；


http://kafka.apache.org/documentation.html#configuration这里的配置


