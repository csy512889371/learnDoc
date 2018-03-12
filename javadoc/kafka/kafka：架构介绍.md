# kafka：架构介绍
* 什么是kafka呢，他是LinkedIn开发的一个分布式消息系统，用scala编写的，可以水平扩展和高吞吐率。
* 原本开发自LinkedIn，用作他们的活动流和运营数据处理管道的基础，之后被多家公司使用，慢慢发展壮大起来。

## 一、	简单介绍
kafka是分布式的，基于发布/订阅的消息系统。

* 1、即使对TB级以上数据也能保证常数时间复杂度的访问性能。
* 2、	高吞吐率：即使在非常廉价的商用机器上也能做到单机支持每秒100k条以上消息的传输。
* 3、	支持分区，消息分布式消费，但是只能保证每个partition内的消息顺序传输。并且支持在线水平扩展。

为何使用消息中间件呢，大家肯定接触过rabbitmq、activemq、redis等，估计有很多感触。我就不详细描述了，这个只能亲身参加过大的技术架构，自己身在其中，并且感受到不用消息中间件和用的区别。

## 二、	架构

了解架构之前，我们先了解一下基本名词。

* Broker：安装了kafka的服务器就是一个broker。
* Topic：消息的类比，最好一类数据定一个topic去存储传输。
* Partition:分区，topic可以定分到几个分区中。
* Producer：发送消息，发送者。
* Consumer：消费消息，消费者。
* Consumer Group：每个Consumer属于一个特定的Consumer Group。


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/1.png)

* 从图中来看，kafka集群包含若干个producer和consumer以及broker，还有一个zk集群。Producer通过push模式将数据发送到broker，Consumer通过pull模式拉取数据。
* Producer发送消息到broker时，根据partition机制选择分不到哪一个partition，设置合理的情况下，所有消息可    
* 以均匀分不到不同的partition里，实现了负载均衡。


