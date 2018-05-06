# Flume+Kafka+Storm+Redis实时分析系统基本架构


## 一、概述

* 1)    整个实时分析系统的架构是
* 2)    先由电商系统的订单服务器产生订单日志,
* 3)    然后使用Flume去监听订单日志，
* 4)    并实时把每一条日志信息抓取下来并存进Kafka消息系统中,
* 5)    接着由Storm系统消费Kafka中的消息，
* 6)    同时消费记录由Zookeeper集群管理，这样即使Kafka宕机重启后也能找到上次的消费记录，接着从上次宕机点继续从Kafka的Broker中进行消费。但是由于存在先消费后记录日志或者先记录后消费的非原子操作，如果出现刚好消费完一条消息并还没将信息记录到Zookeeper的时候就宕机的类似问题，或多或少都会存在少量数据丢失或重复消费的问题, 其中一个解决方案就是Kafka的Broker和Zookeeper都部署在同一台机子上。
* 7)    接下来就是使用用户定义好的Storm Topology去进行日志信息的分析并输出到Redis缓存数据库中(也可以进行持久化)，最后用Web APP去读取Redis中分析后的订单信息并展示给用户。

之所以在Flume和Storm中间加入一层Kafka消息系统，就是因为在高并发的条件下, 订单日志的数据会井喷式增长，如果Storm的消费速度(Storm的实时计算能力那是最快之一,但是也有例外, 而且据说现在Twitter的开源实时计算框架Heron比Storm还要快)慢于日志的产生速度，加上Flume自身的局限性，必然会导致大量数据滞后并丢失，所以加了Kafka消息系统作为数据缓冲区，而且Kafka是基于log File的消息系统，也就是说消息能够持久化在硬盘中，再加上其充分利用Linux的I/O特性,提供了可观的吞吐量。架构中使用Redis作为数据库也是因为在实时的环境下，Redis具有很高的读写速度。

## 二、Flume和Kafka对比

* 1）kafka和flume都是日志系统。kafka是分布式消息中间件，自带存储，提供push和pull存取数据功能。flume分为agent（数据采集器）,collector（数据简单处理和写入）,storage（存储器）三部分，每一部分都是可以定制的。比如agent采用RPC（Thrift-RPC）、text（文件）等，storage指定用hdfs做。

* 2）kafka做日志缓存应该是更为合适的，但是 flume的数据采集部分做的很好，可以定制很多数据源，减少开发量。所以比较流行flume+kafka模式，如果为了利用flume写hdfs的能力，也可以采用kafka+flume的方式。


## 三、Flume

Flume是2009年7月开源的日志系统。它内置的各种组件非常齐全，用户几乎不必进行任何额外开发即可使用。是分布式的日志收集系统，它将各个服务器中的数据收集起来并送到指定的地方去，比如HDFS

### Flume特点：


1) 可靠性

当节点出现故障时，日志能够被传送到其他节点上而不会丢失。Flume提供了三种级别的可靠性保障，从强到弱依次分别为：end-to-end（收到数据 agent首先将event写到磁盘上，当数据传送成功后，再删除；如果数据发送失败，可以重新发送），Store on failure（这也是scribe采用的策略，当数据接收方crash时，将数据写到本地，待恢复后，继续发送），Best effort（数据发送到接收方后，不会进行确认）

2)   可扩展性

Flume采用了三层架构，分别问agent，collector和storage，每一层均可以水平扩展。其中，所有agent和collector由 master统一管理，这使得系统容易监控和维护，且master允许有多个（使用ZooKeeper进行管理和负载均衡），这就避免了单点故障问题。

3)   可管理性

所有agent和colletor由master统一管理，这使得系统便于维护。用户可以在master上查看各个数据源或者数据流执行情况，且可以对各个数据源配置和动态加载。

4)   功能可扩展性

用户可以根据需要添加自己的agent，colletor或者storage。

### Flume架构

Flume采用了分层架构，由三层组成：agent，collector和storage。其中，agent和collector均由两部分组成：source和sink，source是数据来源，sink是数据去向。

Flume的核心是Agent进程，是一个运行在服务器节点的Java进程。

* agent：将数据源的数据发送到collector
* collector：将多个agent的数据汇总后，加载到storage。它的source和sink与agent类似
* storage：存储系统，可以是一个普通file，也可以是HDFS，Hive，HBase等。
* source（数据源）：用于收集各种数据
* channel：临时存放数据，可以存放在memory、jdbc、file等
* sink：把数据发送到目的地，如HDFS、HBase等
* Flume传输数据的基本单位是event，事务保证是在event级别进行的，event将传输的数据进行封装
* 只有在sink将channel中的数据成功发送出去之后，channel才会将临时数据进行删除，这种机制保证了数据传输的可靠性与安全性。


### Flume的广义用法


Flume支持多级Flume的Agent，即sink可以将数据写到下一个Agent的source中，且Flume支持扇入（source可以接受多个输入）、扇出（sink可以将数据输出多个目的地）

 一个复杂的例子如下：有6个agent，3个collector，所有collector均将数据导入HDFS中。agent A，B将数据发送给collector A，agent C，D将数据发送给collectorB，agent C，D将数据发送给collectorB。同时，为每个agent添加end-to-end可靠性保障，如果collector A出现故障时，agent A和agent B会将数据分别发给collector B和collector C。


 ![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/85.png)


## 四、Kafka



Kafka是2010年12月份开源的项目，采用scala语言编写，采用push/pull架构，更适合异构集群数据的传递方式
### Kafka 特征

* 持久性消息：不会丢失任何信息，提供稳定的TB级消息存储
* 高吞吐量：Kafka设计工作在商用硬件上，提供每秒百万的消息
* 分布式架构，能够对消息分区
* 实时：消息由生产者线程生产出来立刻被消费者看到，数据在磁盘上的存取代价为O(1)

### Kafka架构


Kafka实际上是一个消息发布订阅系统。Kafka将消息以Topic为单位进行归纳，将向Topic发布消息的程序作为producer，预定消息的作为consumer。Kafka以集群方式运行，可以由一个或多个服务组成，每个服务叫做一个broker。一旦有新的关于某topic的消息，broker会传递给订阅它的所有consumer。 在kafka中，消息是按topic组织的，而每个topic又会分为多个partition，这样便于管理数据和进行负载均衡。同时，它也使用了 zookeeper进行负载均衡。

#### Producer

向broker发送数据。

Kafka提供了两种producer接口：

* a) low_level接口，用于向特定的broker的某个topic下的某个partition发送数据；
* b) high level接口，支持同步/异步发送数据，基于zookeeper的broker自动识别和负载均衡（基于Partitioner）。producer可以通过zookeeper获取可用的broker列表，也可以在zookeeper中注册listener，该listener在添加删除broker，注册新的topic或broker注册已存在的topic时被唤醒：当producer得知以上时间时，可根据需要采取一定的行动。


#### Broker

Broker采取了多种策略提高数据处理效率，包括sendfile和zero copy等技术。

#### Consumer

将日志信息加载到中央存储系统上。

kafka提供了两种consumer接口：

* a)   low level接口：维护到某一个broker的连接，并且这个连接是无状态的，每次从broker上pull数据时，都要告诉broker数据的偏移量。

* b)   high level接口：隐藏了broker的细节，允许consumer从broker上push数据而不必关心网络拓扑结构。更重要的是，对于大部分日志系统而言，consumer已经获取的数据信息都由broker保存，而在kafka中，由consumer自己维护所取数据信息

#### Kafka消息发送流程


* 1)  Producer根据指定的partition方法，将消息发布到指定topic的partition里面
* 2)  集群接收到Producer发送的消息后，将其持久化到硬盘，并保留消息指定时长，而不关注消息是否被消费。
* 3)  Consumer从kafka集群pull数据，并控制获取消息的offset

详细过程：

Kafka是一个分布式的高吞吐量的消息系统，同时兼有点对点和发布订阅两种消息消费模式。

Kafka主要由Producer，Consumer和Broker组成。Kafka中引入了一个叫“topic”的概念，用来管理不同种类的消息，不同类别的消息会记录在到其对应的topic池中。而这些进入到topic中的消息会被Kafka写入磁盘的log文件中进行持久化处理。对于每一个topic里的消息log文件，Kafka都会对其进行分片处理。而每一个消息都会顺序写入中log分片中，并且被标上“offset”的标量来代表这条消息在这个分片中的顺序，并且这些写入的消息无论是内容还是顺序都是不可变的。所以Kafka和其它消息队列系统的一个区别就是它能做到分片中的消息是能顺序被消费的，但是要做到全局有序还是有局限性的，除非整个topic只有一个log分片。并且无论消息是否有被消费，这条消息会一直保存在log文件中，当留存时间足够长到配置文件中指定的retention的时间后，这条消息才会被删除以释放空间。对于每一个Kafka的Consumer，它们唯一要存的Kafka相关的元数据就是这个“offset”值，记录着Consumer在分片上消费到了哪一个位置。通常Kafka是使用Zookeeper来为每一个Consumer保存它们的offset信息，所以在启动Kafka之前需要有一个Zookeeper集群;而且Kafka默认采用的是先记录offset再读取数据的策略，这种策略会存在少量数据丢失的可能。不过用户可以灵活设置Consumer的“offset”的位置，在加上消息记录在log文件中，所以是可以重复消费消息的。log的分片和它们的备份会分散保存在集群的服务器上，对于每一个partition，在集群上都会有一台这个partition存在的服务器作为leader，而这个partitionpartition的其它备份所在的服务器做为follower，leader负责处理关于这个partition的所有请求，而follower负责这个partition的其它备份的同步工作，当leader服务器宕机时，其中一个follower服务器就会被选举为新的leader。


 ![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/86.png)

#### 数据的传递方式



> 1) Socket：最简单的交互方式，典型的c/s交互模式。传输协议可以是TCP/UDP

优点：易于编程，Java有很多框架，隐藏了细节；容易控制权限，通过https，使得安全性提高；通用性强

缺点：服务器和客户端必须同时在线；当传输数据量比较大的时候，严重占用网络带宽，导致连接超时


> 2)   FTP/文件共享服务器方式：适用于大数据量的交互


优点：数据量大时，不会超时，不占用网络带宽；方案简单，避免网络传输、网络协议相关概念

缺点：不适合做实时类的业务；必须有共同的服务器，可能存在文件泄密；必须约定文件数据的格式


> 3)   数据库共享数据方式：系统A、B通过连接同一个数据库服务器的同一张表进行数据交换


优点：使用同一个数据库，使得交互更简单，交互方式灵活，可更新，回滚，因为数据库的事务，交互更可靠

缺点：当连接B的系统越来越多，会导致每个系统分配到的连接不会很多；

一般来说，两个公司的系统不会开放自己的数据库给对方，影响安全性


> 4)   消息方式：Java消息服务（Java Message Service）是message数据传输的典型的实现方式

优点：JMS定义了规范，有很多消息中间件可选；消息方式比较灵活，可采取同步、异步、可靠性的消息处理

缺点：JMS相关的学习对开发有一定的学习成本；在大数据量的情况下，可能造成消息积压、延迟、丢失甚至中间件崩溃

 

#### 消息队列

任何软件工程遇到的问题都可以通过增加一个中间层来解决

消息队列是在消息的传输过程中保存消息的容器。主要目的是提供路由并保证消息的传递，如果发送消息时接收者不可用，消息队列会保留消息，直到可以成功地传递它。

#### 消息中间件作用

* 系统解耦：服务B出现问题不会影响服务A
* 削峰填谷：对请求压力实现削峰填谷，降低系统峰值压力
* 数据交换：无需暴露企业A和B的内网就可以实现数据交换
* 异步通知：减少前端和后端服务之间大量不必要的轮询请求
* 定时任务：如生成付款检查任务，延迟30分钟