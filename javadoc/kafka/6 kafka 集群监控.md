# 6 kafka 集群监控


## 一、概述

* Kafka Offset Monitor

* Kafka Manager


在生产环境需要集群高可用，所以需要对Kafka集群进行监控。Kafka Offset Monitor可以监控Kafka集群以下几项：

* Kafka集群当前存活的broker集合；
* Kafka集群当前活动topic集合；
* 消费者组列表
* Kafka集群当前consumer按组消费的offset lag数(即当前topic当前分区目前有多少消息积压而没有及时消费)


## 二、 部署Kafka Offset Minotor


github下载jar包KafkaOffsetMonitor-assembly-0.2.0.jar :

```
https://github.com/quantifind/KafkaOffsetMonitor/releases
```

启动Kafka Offset Minotor :

```
java -cp KafkaOffsetMonitor-assembly-0.2.0.jar com.quantifind.kafka.offsetapp.OffsetGetterWeb --zk zk-01,zk-02 --refresh 5.minutes --retain 1.day &
```

活动broker集合


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/28.png)

consumer按组消费的offset lag数

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/29.png)

## 三、Kafka Manager介绍

Kafka Manager由雅虎开源，提供以下功能：

* 管理几个不同的集群；
* 容易地检查集群的状态(topics, brokers, 副本的分布, 分区的分布) ；
* 选择副本
* 基于集群的当前状态产生分区分配
* 重新分配分区

### Kafka Manager的安装

#### 方法一(不但要求能上网，还要求能翻墙)

安装sbt：

```
http://www.scala-sbt.org/download.html
```

下载后，解压并配置环境变量(将SBT_HOME/bin配置到PATH变量中)

安装Kafka Manager :

```
git clone https://github.com/yahoo/kafka-manager
cd kafka-manager
sbt clean dist
```


部署Kafka Manager

* 修改conf/application.conf，把kafka-manager.zkhosts改为自己的zookeeper服务器地址

* bin/kafka-manager -Dconfig.file=conf/application.conf -Dhttp.port=8007 &

#### 方法二：

下载打包好的Kafka manager：kafka-manager-1.3.3.7

```
链接：https://pan.baidu.com/s/1Unufo8ixJcVKjU9B7bLmhg 密码：7aq1

```

下载后解压

* 修改conf/application.conf，把Kafka-manager.zkhosts改为自己的zookeeper服务器地址
* bin/kafka-manager -Dconfig.file=conf/application.conf -Dhttp.port=8007 &


添加Kafka集群


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/30.png)


集群topic列表


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/31.png)

