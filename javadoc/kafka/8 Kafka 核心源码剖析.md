# 8 Kafka 核心源码剖析


## 一、概述


* 分区消费模式源码
* 组消费模式源码
* 两种消费模式服务器端源码对比

* 同步发送模式源码介绍
* 异步发送模式源码介绍
* 两种生产模式服务器端源码对比


## 二、分区消费模式

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/36.png)


分区消费模式直接由客户端(任何高级语言编写)
使用Kafka提供的协议向服务器发送RPC请求获取数据，服务器接受到客户端的RPC请求后，将数据构造成RPC响应，返回给客户端，客户端解析相应的RPC响应获取数据。

Kafka支持的协议众多，使用比较重要的有：

* 获取消息的FetchRequest和FetchResponse
* 获取offset的OffsetRequest和OffsetResponse
* 提交offset的OffsetCommitRequest和OffsetCommitResponse
* 获取Metadata的Metadata Request和Metadata Response
* 生产消息的ProducerRequest和ProducerResponse

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/37.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/38.png)

## 三、两种消费模式服务器端源码对比


分区消费模式具有以下特点：

* 指定消费topic、partition和offset通过向服务器发送RPC请求进行消费;
* 需要自己提交offset；
* 需要自己处理各种错误，如:leader切换错误
* 需要自己处理消费者负载均衡策略

组消费模式具有以下特点：

* 最终也是通过向服务器发送RPC请求完成的(和分区消费模式一样);
* 组消费模式由Kafka服务器端处理各种错误，然后将消息放入队列再封装为迭代器(队列为FetchedDataChunk对象) ，客户端只需在迭代器上迭代取出消息；
* 由Kafka服务器端周期性的通过scheduler提交当前消费的offset，无需客户端负责
* Kafka服务器端处理消费者负载均衡
* 监控工具Kafka Offset Monitor 和Kafka Manager 均是基于组消费模式；

所以，尽可能使用组消费模式，除非你需要：

* 自己管理offset(比如为了实现消息投递的其他语义);
* 自己处理各种错误(根据自己业务的需求)；



## 四、Kafka生产者源码介绍

同步发送模式源码介绍

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/39.png)

异步发送模式源码介绍


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/40.png)
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/41.png)


同步发送模式具有以下特点：

* 同步的向服务器发送RPC请求进行生产;
* 发送错误可以重试；
* 可以向客户端发送ack;

异步发送模式具有以下特点：
* 最终也是通过向服务器发送RPC请求完成的(和同步发送模式一样);
* 异步发送模式先将一定量消息放入队列中，待达到一定数量后再一起发送；
* 异步发送模式不支持发送ack，但是Client可以调用回调函数获取发送结果；

所以，性能比较高的场景使用异步发送，准确性要求高的场景使用同步发送


