# 11 kafka 用户日志上报

## 一、概述

对网站产生的用户访问日志进行处理并分析出该网站在某天的PV、UV等数据，其走的就是离线处理的数据处理方式，而这里即将要介绍的是另外一条路线的数据处理方式，即基于Storm的在线处理，在下面给出的完整案例中，我们将会完成下面的几项工作：


* 1.如何一步步构建我们的实时处理系统（Flume+Kafka+Storm+Redis）
* 2.实时处理网站的用户访问日志，并统计出该网站的PV、UV
* 3.将实时分析出的PV、UV动态地展示在我们的前面页面上


 实时处理系统架构

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/58.png)


即从上面的架构中我们可以看出，其由下面的几部分构成：

* Flume集群
* Kafka集群
* Storm集群

从构建实时处理系统的角度出发，我们需要做的是，如何让数据在各个不同的集群系统之间打通（从上面的图示中也能很好地说明这一点），即需要做各个系统之前的整合，包括Flume与Kafka的整合，Kafka与Storm的整合。当然，各个环境是否使用集群，依个人的实际需要而定，在我们的环境中，Flume、Kafka、Storm都使用集群。

kafka概述

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/47.png)

整体流程预览如下图所示

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/48.png)


数据源生产

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/49.png)

数据源消费
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/50.png)



## 二、Flume+Kafka整合

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/59.png)


 整合思路

对于Flume而言，关键在于如何采集数据，并且将其发送到Kafka上，并且由于我们这里了使用Flume集群的方式，Flume集群的配置也是十分关键的。而对于Kafka，关键就是如何接收来自Flume的数据。从整体上讲，逻辑应该是比较简单的，即可以在Kafka中创建一个用于我们实时处理系统的topic，然后Flume将其采集到的数据发送到该topic上即可。

整合过程：Flume集群配置与Kafka Topic创建


Flume集群配置

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/60.png)

在我们的场景中，两个Flume Agent分别部署在两台Web服务器上，用来采集Web服务器上的日志数据，然后其数据的下沉方式都为发送到另外一个Flume Agent上，所以这里我们需要配置三个Flume Agent.


### 1、Flume Agent01

该Flume Agent部署在一台Web服务器上，用来采集产生的Web日志，然后发送到Flume Consolidation Agent上，创建一个新的配置文件flume-sink-avro.conf，其配置内容如下：

```
#########################################################
##
##主要作用是监听文件中的新增数据，采集到数据之后，输出到avro
##    注意：Flume agent的运行，主要就是配置source channel sink
##  下面的a1就是agent的代号，source叫r1 channel叫c1 sink叫k1
#########################################################
a1.sources = r1
a1.sinks = k1
a1.channels = c1

#对于source的配置描述 监听文件中的新增数据 exec
a1.sources.r1.type = exec
a1.sources.r1.command  = tail -F /home/uplooking/data/data-clean/data-access.log

#对于sink的配置描述 使用avro日志做数据的消费
a1.sinks.k1.type = avro
a1.sinks.k1.hostname = uplooking03
a1.sinks.k1.port = 44444

#对于channel的配置描述 使用文件做数据的临时缓存 这种的安全性要高
a1.channels.c1.type = file
a1.channels.c1.checkpointDir = /home/uplooking/data/flume/checkpoint
a1.channels.c1.dataDirs = /home/uplooking/data/flume/data

#通过channel c1将source r1和sink k1关联起来
a1.sources.r1.channels = c1
a1.sinks.k1.channel = c1
```


配置完成后， 启动Flume Agent，即可对日志文件进行监听：

```
$ flume-ng agent --conf conf -n a1 -f app/flume/conf/flume-sink-avro.conf >/dev/null 2>&1 &
```

### 2、 Flume Agent02


该Flume Agent部署在一台Web服务器上，用来采集产生的Web日志，然后发送到Flume Consolidation Agent上，创建一个新的配置文件flume-sink-avro.conf，其配置内容如下：


```
#########################################################
##
##主要作用是监听文件中的新增数据，采集到数据之后，输出到avro
##    注意：Flume agent的运行，主要就是配置source channel sink
##  下面的a1就是agent的代号，source叫r1 channel叫c1 sink叫k1
#########################################################
a1.sources = r1
a1.sinks = k1
a1.channels = c1

#对于source的配置描述 监听文件中的新增数据 exec
a1.sources.r1.type = exec
a1.sources.r1.command  = tail -F /home/uplooking/data/data-clean/data-access.log

#对于sink的配置描述 使用avro日志做数据的消费
a1.sinks.k1.type = avro
a1.sinks.k1.hostname = uplooking03
a1.sinks.k1.port = 44444

#对于channel的配置描述 使用文件做数据的临时缓存 这种的安全性要高
a1.channels.c1.type = file
a1.channels.c1.checkpointDir = /home/uplooking/data/flume/checkpoint
a1.channels.c1.dataDirs = /home/uplooking/data/flume/data

#通过channel c1将source r1和sink k1关联起来
a1.sources.r1.channels = c1
a1.sinks.k1.channel = c1
```

配置完成后， 启动Flume Agent，即可对日志文件进行监听：

```
$ flume-ng agent --conf conf -n a1 -f app/flume/conf/flume-sink-avro.conf >/dev/null 2>&1 &
```


### 3、 Flume Consolidation Agent

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/61.png)

该Flume Agent用于接收其它两个Agent发送过来的数据，然后将其发送到Kafka上，创建一个新的配置文件flume-source_avro-sink_kafka.conf，配置内容如下：

```
#########################################################
##
##主要作用是监听目录中的新增文件，采集到数据之后，输出到kafka
##    注意：Flume agent的运行，主要就是配置source channel sink
##  下面的a1就是agent的代号，source叫r1 channel叫c1 sink叫k1
#########################################################
a1.sources = r1
a1.sinks = k1
a1.channels = c1

#对于source的配置描述 监听avro
a1.sources.r1.type = avro
a1.sources.r1.bind = 0.0.0.0
a1.sources.r1.port = 44444

#对于sink的配置描述 使用kafka做数据的消费
a1.sinks.k1.type = org.apache.flume.sink.kafka.KafkaSink
a1.sinks.k1.topic = f-k-s
a1.sinks.k1.brokerList = uplooking01:9092,uplooking02:9092,uplooking03:9092
a1.sinks.k1.requiredAcks = 1
a1.sinks.k1.batchSize = 20

#对于channel的配置描述 使用内存缓冲区域做数据的临时缓存
a1.channels.c1.type = memory
a1.channels.c1.capacity = 1000
a1.channels.c1.transactionCapacity = 100

#通过channel c1将source r1和sink k1关联起来
a1.sources.r1.channels = c1
a1.sinks.k1.channel = c1   
```

配置完成后， 启动Flume Agent，即可对avro的数据进行监听：

```
$ flume-ng agent --conf conf -n a1 -f app/flume/conf/flume-source_avro-sink_kafka.conf >/dev/null 2>&1 &
```

### 4、 Kafka配置
在我们的Kafka中，先创建一个topic，用于后面接收Flume采集过来的数据

```
kafka-topics.sh --create --topic f-k-s  --zookeeper uplooking01:2181,uplooking02:2181,uplooking03:2181 --partitions 3 --replication-factor 3
```

###  5、整合验证

启动Kafka的消费脚本

```
$ kafka-console-consumer.sh --topic f-k-s --zookeeper uplooking01:2181,uplooking02:2181,uplooking03:2181
```

如果在Web服务器上有新增的日志数据，就会被我们的Flume程序监听到，并且最终会传输到到Kafka的f-k-stopic中，这里作为验证，我们上面启动的是一个kafka终端消费的脚本，这时会在终端中看到数据的输出：


```
$ kafka-console-consumer.sh --topic f-k-s --zookeeper uplooking01:2181,uplooking02:2181,uplooking03:2181
1003    221.8.9.6 80    0f57c8f5-13e2-428d-ab39-9e87f6e85417    10709   0       GET /index HTTP/1.1     null    null      Mozilla/5.0 (Windows; U; Windows NT 5.2)Gecko/2008070208 Firefox/3.0.1  1523107496164
1002    220.194.55.244  fb953d87-d166-4cb4-8a64-de7ddde9054c    10201   0       GET /check/detail HTTP/1.1      null      null    Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko    1523107497165
1003    211.167.248.22  9d7bb7c2-00bf-4102-9c8c-3d49b18d1b48    10022   1       GET /user/add HTTP/1.1  null    null      Mozilla/4.0 (compatible; MSIE 8.0; Windows NT6.0)       1523107496664
1002    61.172.249.96   null    10608   0       POST /updateById?id=21 HTTP/1.1 null    null    Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko      1523107498166
1000    202.98.11.101   aa7f62b3-a6a1-44ef-81f5-5e71b5c61368    20202   0       GET /getDataById HTTP/1.0       404       /check/init     Mozilla/5.0 (Windows; U; Windows NT 5.1)Gecko/20070803 Firefox/1.5.0.12 1523107497666
```

这样的话，我们的整合就没有问题，当然kafka中的数据应该是由我们的storm来进行消费的，这里只是作为整合的一个测试，下面就会来做kafka+storm的整合。


## 三、Kafka+Storm整合

* Kafka和Storm的整合其实在Storm的官网上也有非常详细清晰的文档 :  http://storm.apache.org/releases/1.0.6/storm-kafka.html

### 1、整合思路

在这次的大数据实时处理系统的构建中，Kafka相当于是作为消息队列（或者说是消息中间件）的角色，其产生的消息需要有消费者去消费，所以Kafka与Storm的整合，关键在于我们的Storm如何去消费Kafka消息topic中的消息（kafka消息topic中的消息正是由Flume采集而来，现在我们需要在Storm中对其进行消费）。


在Storm中，topology是非常关键的概念。

对比MapReduce，在MapReduce中，我们提交的作业称为一个job，在一个Job中，又包含若干个Mapper和Reducer，正是在Mapper和Reducer中有我们对数据的处理逻辑：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/62.png)

在Storm中，我们提交的一个作业称为topology，其又包含了spout和bolt，在Storm中，对数据的处理逻辑正是在spout和bolt中体现：


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/63.png)

即在spout中，正是我们数据的来源，又因为其实时的特性，所以可以把它比作一个“水龙头”，表示其源源不断地产生数据：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/64.png)

所以，问题的关键是spout如何去获取来自kafka的数据？

好在，storm-kafka的整合库中提供了这样的API来供我们进行操作。

### 2、整合过程：KafkaSpout的应用

在代码的逻辑中只需要创建一个由storm-kafkaAPI提供的KafkaSpout对象即可

```
SpoutConfig spoutConf = new SpoutConfig(hosts, topic, zkRoot, id);
return new KafkaSpout(spoutConf);
```
下面给出完整的整合代码


```
package cn.xpleaf.bigdata.storm.statics;

import kafka.api.OffsetRequest;
import org.apache.storm.Config;
import org.apache.storm.LocalCluster;
import org.apache.storm.StormSubmitter;
import org.apache.storm.generated.StormTopology;
import org.apache.storm.kafka.BrokerHosts;
import org.apache.storm.kafka.KafkaSpout;
import org.apache.storm.kafka.SpoutConfig;
import org.apache.storm.kafka.ZkHosts;
import org.apache.storm.topology.BasicOutputCollector;
import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.topology.TopologyBuilder;
import org.apache.storm.topology.base.BaseBasicBolt;
import org.apache.storm.tuple.Tuple;

/**
 * Kafka和storm的整合，用于统计实时流量对应的pv和uv
 */
public class KafkaStormTopology {

    //    static class MyKafkaBolt extends BaseRichBolt {
    static class MyKafkaBolt extends BaseBasicBolt {

        /**
         * kafkaSpout发送的字段名为bytes
         */
        @Override
        public void execute(Tuple input, BasicOutputCollector collector) {
            byte[] binary = input.getBinary(0); // 跨jvm传输数据，接收到的是字节数据
//            byte[] bytes = input.getBinaryByField("bytes");   // 这种方式也行
            String line = new String(binary);
            System.out.println(line);
        }

        @Override
        public void declareOutputFields(OutputFieldsDeclarer declarer) {

        }
    }

    public static void main(String[] args) throws Exception {
        TopologyBuilder builder = new TopologyBuilder();
        /**
         * 设置spout和bolt的dag（有向无环图）
         */
        KafkaSpout kafkaSpout = createKafkaSpout();
        builder.setSpout("id_kafka_spout", kafkaSpout);
        builder.setBolt("id_kafka_bolt", new MyKafkaBolt())
                .shuffleGrouping("id_kafka_spout"); // 通过不同的数据流转方式，来指定数据的上游组件
        // 使用builder构建topology
        StormTopology topology = builder.createTopology();
        String topologyName = KafkaStormTopology.class.getSimpleName();  // 拓扑的名称
        Config config = new Config();   // Config()对象继承自HashMap，但本身封装了一些基本的配置

        // 启动topology，本地启动使用LocalCluster，集群启动使用StormSubmitter
        if (args == null || args.length < 1) {  // 没有参数时使用本地模式，有参数时使用集群模式
            LocalCluster localCluster = new LocalCluster(); // 本地开发模式，创建的对象为LocalCluster
            localCluster.submitTopology(topologyName, config, topology);
        } else {
            StormSubmitter.submitTopology(topologyName, config, topology);
        }
    }

    /**
     * BrokerHosts hosts  kafka集群列表
     * String topic       要消费的topic主题
     * String zkRoot      kafka在zk中的目录（会在该节点目录下记录读取kafka消息的偏移量）
     * String id          当前操作的标识id
     */
    private static KafkaSpout createKafkaSpout() {
        String brokerZkStr = "uplooking01:2181,uplooking02:2181,uplooking03:2181";
        BrokerHosts hosts = new ZkHosts(brokerZkStr);   // 通过zookeeper中的/brokers即可找到kafka的地址
        String topic = "f-k-s";
        String zkRoot = "/" + topic;
        String id = "consumer-id";
        SpoutConfig spoutConf = new SpoutConfig(hosts, topic, zkRoot, id);
        // 本地环境设置之后，也可以在zk中建立/f-k-s节点，在集群环境中，不用配置也可以在zk中建立/f-k-s节点
        //spoutConf.zkServers = Arrays.asList(new String[]{"uplooking01", "uplooking02", "uplooking03"});
        //spoutConf.zkPort = 2181;
        spoutConf.startOffsetTime = OffsetRequest.LatestTime(); // 设置之后，刚启动时就不会把之前的消费也进行读取，会从最新的偏移量开始读取
        return new KafkaSpout(spoutConf);
    }
}
```

其实代码的逻辑非常简单，我们只创建了 一个由storm-kafka提供的KafkaSpout对象和一个包含我们处理逻辑的MyKafkaBolt对象，MyKafkaBolt的逻辑也很简单，就是把kafka的消息打印到控制台上。

> 需要注意的是，后面我们分析网站PV、UV的工作，正是在上面这部分简单的代码中完成的，所以其是非常重要的基础。


### 3、整合验证


上面的整合代码，可以在本地环境中运行，也可以将其打包成jar包上传到我们的Storm集群中并提交业务来运行。如果Web服务器能够产生日志，并且前面Flume+Kafka的整合也没有问题的话，将会有下面的效果。

如果是在本地环境中运行上面的代码，那么可以在控制台中看到日志数据的输出：

```
......
45016548 [Thread-16-id_kafka_spout-executor[3 3]] INFO  o.a.s.k.ZkCoordinator - Task [1/1] Refreshing partition manager connections
45016552 [Thread-16-id_kafka_spout-executor[3 3]] INFO  o.a.s.k.DynamicBrokersReader - Read partition info from zookeeper: GlobalPartitionInformation{topic=f-k-s, partitionMap={0=uplooking02:9092, 1=uplooking03:9092, 2=uplooking01:9092}}
45016552 [Thread-16-id_kafka_spout-executor[3 3]] INFO  o.a.s.k.KafkaUtils - Task [1/1] assigned [Partition{host=uplooking02:9092, topic=f-k-s, partition=0}, Partition{host=uplooking03:9092, topic=f-k-s, partition=1}, Partition{host=uplooking01:9092, topic=f-k-s, partition=2}]
45016552 [Thread-16-id_kafka_spout-executor[3 3]] INFO  o.a.s.k.ZkCoordinator - Task [1/1] Deleted partition managers: []
45016552 [Thread-16-id_kafka_spout-executor[3 3]] INFO  o.a.s.k.ZkCoordinator - Task [1/1] New partition managers: []
45016552 [Thread-16-id_kafka_spout-executor[3 3]] INFO  o.a.s.k.ZkCoordinator - Task [1/1] Finished refreshing
1003    221.8.9.6 80    0f57c8f5-13e2-428d-ab39-9e87f6e85417    10709   0   GET /index HTTP/1.1 null    null    Mozilla/5.0 (Windows; U; Windows NT 5.2)Gecko/2008070208 Firefox/3.0.1  1523107496164
1000    202.98.11.101   aa7f62b3-a6a1-44ef-81f5-5e71b5c61368    20202   0   GET /getDataById HTTP/1.0   404 /check/init Mozilla/5.0 (Windows; U; Windows NT 5.1)Gecko/20070803 Firefox/1.5.0.12 1523107497666
1002    220.194.55.244  fb953d87-d166-4cb4-8a64-de7ddde9054c    10201   0   GET /check/detail HTTP/1.1  null    null    Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko    1523107497165
1003    211.167.248.22  9d7bb7c2-00bf-4102-9c8c-3d49b18d1b48    10022   1   GET /user/add HTTP/1.1  null    null    Mozilla/4.0 (compatible; MSIE 8.0; Windows NT6.0)   1523107496664
1002    61.172.249.96   null    10608   0   POST /updateById?id=21 HTTP/1.1 null    null    Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko    1523107498166
......
```

如果是在Storm集群中提交的作业运行，那么也可以在Storm的日志中看到Web服务器产生的日志数据

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/65.png)

这样的话就完成了Kafka+Storm的整合


## 四、Storm+Redis整合


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/66.png)


### 1、整合思路

其实所谓Storm和Redis的整合，指的是在我们的实时处理系统中的数据的落地方式，即在Storm中包含了我们处理数据的逻辑，而数据处理完毕后，产生的数据处理结果该保存到什么地方呢？显然就有很多种方式了，关系型数据库、NoSQL、HDFS、HBase等，这应该取决于具体的业务和数据量，在这里，我们使用Redis来进行最后分析数据的存储。

所以实际上做这一步的整合，其实就是开始写我们的业务处理代码了，因为通过前面Flume-Kafka-Storm的整合，已经打通了整个数据的流通路径，接下来关键要做的是，在Storm中，如何处理我们的数据并保存到Redis中。

而在Storm中，spout已经不需要我们来写了（由storm-kafka的API提供了KafkaSpout对象），所以问题就变成，如何根据业务编写分析处理数据的bolt。


### 整合过程：编写Storm业务处理Bolt

日志分析

我们实时获取的日志格式如下：

```
1002    202.103.24.68   1976dc2e-f03a-44f0-892f-086d85105f7e    14549   1       GET /top HTTP/1.1       200     /tologin  Mozilla/5.0 (Windows; U; Windows NT 5.2)AppleWebKit/525.13 (KHTML, like Gecko) Version/3.1Safari/525.13 1523806916373
1000    221.8.9.6 80    542ccf0a-9b14-49a0-93cd-891d87ddabf3    12472   1       GET /index HTTP/1.1     500     /top      Mozilla/4.0 (compatible; MSIE 5.0; WindowsNT)   1523806916874
1003    211.167.248.22  0e4c1875-116c-400e-a4f8-47a46ad04a42    12536   0       GET /tologin HTTP/1.1   200     /stat     Mozilla/5.0 (Windows; U; Windows NT 5.2) AppleWebKit/525.13 (KHTML,like Gecko) Chrome/0.2.149.27 Safari/525.13    1523806917375
1000    219.147.198.230 07eebc1a-740b-4dac-b53f-bb242a45c901    11847   1       GET /userList HTTP/1.1  200     /top      Mozilla/4.0 (compatible; MSIE 6.0; Windows NT5.1)       1523806917876
1001    222.172.200.68  4fb35ced-5b30-483b-9874-1d5917286675    13550   1       GET /getDataById HTTP/1.0       504       /tologin        Mozilla/5.0 (Windows; U; Windows NT 5.2)AppleWebKit/525.13 (KHTML, like Gecko) Version/3.1Safari/525.13   1523806918377
```


其中需要说明的是第二个字段和第三个字段，因为它对我们统计pv和uv非常有帮助，它们分别是ip字段和mid字段，说明如下：

```
ip：用户的IP地址
mid：唯一的id，此id第一次会种在浏览器的cookie里。如果存在则不再种。作为浏览器唯一标示。移动端或者pad直接取机器码。
```

因此，根据IP地址，我们可以通过查询得到其所在的省份，并且创建一个属于该省份的变量，用于记录pv数，每来一条属于该省份的日志记录，则该省份的pv就加1，以此来完成pv的统计。

而对于mid，我们则可以创建属于该省的一个set集合，每来一条属于该省份的日志记录，则可以将该mid添加到set集合中，因为set集合存放的是不重复的数据，这样就可以帮我们自动过滤掉重复的mid，根据set集合的大小，就可以统计出uv。

在我们storm的业务处理代码中，我们需要编写两个bolt：

* 第一个bolt用来对数据进行预处理，也就是提取我们需要的ip和mid，并且根据IP查询得到省份信息；
* 第二个bolt用来统计pv、uv，并定时将pv、uv数据写入到Redis中；


当然上面只是说明了整体的思路，实际上还有很多需要注意的细节问题和技巧问题，这都在我们的代码中进行体现，我在后面写的代码中都加了非常详细的注释进行说明。

### 2、编写第一个Bolt：ConvertIPBolt

根据上面的分析，编写用于数据预处理的bolt，代码如下：

```
package cn.xpleaf.bigdata.storm.statistic;

import cn.xpleaf.bigdata.storm.utils.JedisUtil;
import org.apache.storm.topology.BasicOutputCollector;
import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.topology.base.BaseBasicBolt;
import org.apache.storm.tuple.Fields;
import org.apache.storm.tuple.Tuple;
import org.apache.storm.tuple.Values;
import redis.clients.jedis.Jedis;

/**
 * 日志数据预处理Bolt，实现功能：
 *     1.提取实现业务需求所需要的信息：ip地址、客户端唯一标识mid
 *     2.查询IP地址所属地，并发送到下一个Bolt
 */
public class ConvertIPBolt extends BaseBasicBolt {
    @Override
    public void execute(Tuple input, BasicOutputCollector collector) {
        byte[] binary = input.getBinary(0);
        String line = new String(binary);
        String[] fields = line.split("\t");

        if(fields == null || fields.length < 10) {
            return;
        }

        // 获取ip和mid
        String ip = fields[1];
        String mid = fields[2];

        // 根据ip获取其所属地（省份）
        String province = null;
        if (ip != null) {
            Jedis jedis = JedisUtil.getJedis();
            province = jedis.hget("ip_info_en", ip);
            // 需要释放jedis的资源，否则会报can not get resource from the pool
            JedisUtil.returnJedis(jedis);
        }

        // 发送数据到下一个bolt，只发送实现业务功能需要的province和mid
        collector.emit(new Values(province, mid));

    }

    /**
     * 定义了发送到下一个bolt的数据包含两个域：province和mid
     */
    @Override
    public void declareOutputFields(OutputFieldsDeclarer declarer) {
        declarer.declare(new Fields("province", "mid"));
    }
}
```

### 3、编写第二个Bolt：StatisticBolt


这个bolt包含我们统计网站pv、uv的代码逻辑，因此非常重要，其代码如下

```
package cn.xpleaf.bigdata.storm.statistic;

import cn.xpleaf.bigdata.storm.utils.JedisUtil;
import org.apache.storm.Config;
import org.apache.storm.Constants;
import org.apache.storm.topology.BasicOutputCollector;
import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.topology.base.BaseBasicBolt;
import org.apache.storm.tuple.Tuple;
import redis.clients.jedis.Jedis;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 日志数据统计Bolt，实现功能：
 * 1.统计各省份的PV、UV
 * 2.以天为单位，将省份对应的PV、UV信息写入Redis
 */
public class StatisticBolt extends BaseBasicBolt {

    Map<String, Integer> pvMap = new HashMap<>();
    Map<String, HashSet<String>> midsMap = null;
    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");

    @Override
    public void execute(Tuple input, BasicOutputCollector collector) {
        if (!input.getSourceComponent().equalsIgnoreCase(Constants.SYSTEM_COMPONENT_ID)) {  // 如果收到非系统级别的tuple，统计信息到局部变量mids
            String province = input.getStringByField("province");
            String mid = input.getStringByField("mid");
            pvMap.put(province, pvMap.get(province) + 1);   // pv+1
            if(mid != null) {
                midsMap.get(province).add(mid); // 将mid添加到该省份所对应的set中
            }
        } else {    // 如果收到系统级别的tuple，则将数据更新到Redis中，释放JVM堆内存空间
            /*
             * 以 广东 为例，其在Redis中保存的数据格式如下：
             * guangdong_pv（Redis数据结构为hash）
             *         --20180415
             *              --pv数
             *         --20180416
             *              --pv数
             * guangdong_mids_20180415(Redis数据结构为set)
             *         --mid
             *         --mid
             *         --mid
             *         ......
             * guangdong_mids_20180415(Redis数据结构为set)
             *         --mid
             *         --mid
             *         --mid
             *         ......
             */
            Jedis jedis = JedisUtil.getJedis();
            String dateStr = sdf.format(new Date());
            // 更新pvMap数据到Redis中
            String pvKey = null;
            for(String province : pvMap.keySet()) {
                int currentPv = pvMap.get(province);
                if(currentPv > 0) { // 当前map中的pv大于0才更新，否则没有意义
                    pvKey = province + "_pv";
                    String oldPvStr = jedis.hget(pvKey, dateStr);
                    if(oldPvStr == null) {
                        oldPvStr = "0";
                    }
                    Long oldPv = Long.valueOf(oldPvStr);
                    jedis.hset(pvKey, dateStr, oldPv + currentPv + "");
                    pvMap.replace(province, 0); // 将该省的pv重新设置为0
                }
            }
            // 更新midsMap到Redis中
            String midsKey = null;
            HashSet<String> midsSet = null;
            for(String province: midsMap.keySet()) {
                midsSet = midsMap.get(province);
                if(midsSet.size() > 0) {  // 当前省份的set的大小大于0才更新到，否则没有意义
                    midsKey = province + "_mids_" + dateStr;
                    jedis.sadd(midsKey, midsSet.toArray(new String[midsSet.size()]));
                    midsSet.clear();
                }
            }
            // 释放jedis资源
            JedisUtil.returnJedis(jedis);
            System.out.println(System.currentTimeMillis() + "------->写入数据到Redis");
        }
    }

    @Override
    public void declareOutputFields(OutputFieldsDeclarer declarer) {

    }

    /**
     * 设置定时任务，只对当前bolt有效，系统会定时向StatisticBolt发送一个系统级别的tuple
     */
    @Override
    public Map<String, Object> getComponentConfiguration() {
        Map<String, Object> config = new HashMap<>();
        config.put(Config.TOPOLOGY_TICK_TUPLE_FREQ_SECS, 10);
        return config;
    }

    /**
     * 初始化各个省份的pv和mids信息（用来临时存储统计pv和uv需要的数据）
     */
    public StatisticBolt() {
        pvMap = new HashMap<>();
        midsMap = new HashMap<String, HashSet<String>>();
        String[] provinceArray = {"shanxi", "jilin", "hunan", "hainan", "xinjiang", "hubei", "zhejiang", "tianjin", "shanghai",
                "anhui", "guizhou", "fujian", "jiangsu", "heilongjiang", "aomen", "beijing", "shaanxi", "chongqing",
                "jiangxi", "guangxi", "gansu", "guangdong", "yunnan", "sicuan", "qinghai", "xianggang", "taiwan",
                "neimenggu", "henan", "shandong", "shanghai", "hebei", "liaoning", "xizang"};
        for(String province : provinceArray) {
            pvMap.put(province, 0);
            midsMap.put(province, new HashSet());
        }
    }
}
```


###  4、编写Topology

我们需要编写一个topology用来组织前面编写的Bolt，代码如下：

```
package cn.xpleaf.bigdata.storm.statistic;

import kafka.api.OffsetRequest;
import org.apache.storm.Config;
import org.apache.storm.LocalCluster;
import org.apache.storm.StormSubmitter;
import org.apache.storm.generated.StormTopology;
import org.apache.storm.kafka.BrokerHosts;
import org.apache.storm.kafka.KafkaSpout;
import org.apache.storm.kafka.SpoutConfig;
import org.apache.storm.kafka.ZkHosts;
import org.apache.storm.topology.TopologyBuilder;

/**
 * 构建topology
 */
public class StatisticTopology {
    public static void main(String[] args) throws Exception {
        TopologyBuilder builder = new TopologyBuilder();
        /**
         * 设置spout和bolt的dag（有向无环图）
         */
        KafkaSpout kafkaSpout = createKafkaSpout();
        builder.setSpout("id_kafka_spout", kafkaSpout);
        builder.setBolt("id_convertIp_bolt", new ConvertIPBolt()).shuffleGrouping("id_kafka_spout"); // 通过不同的数据流转方式，来指定数据的上游组件
        builder.setBolt("id_statistic_bolt", new StatisticBolt()).shuffleGrouping("id_convertIp_bolt"); // 通过不同的数据流转方式，来指定数据的上游组件
        // 使用builder构建topology
        StormTopology topology = builder.createTopology();
        String topologyName = KafkaStormTopology.class.getSimpleName();  // 拓扑的名称
        Config config = new Config();   // Config()对象继承自HashMap，但本身封装了一些基本的配置

        // 启动topology，本地启动使用LocalCluster，集群启动使用StormSubmitter
        if (args == null || args.length < 1) {  // 没有参数时使用本地模式，有参数时使用集群模式
            LocalCluster localCluster = new LocalCluster(); // 本地开发模式，创建的对象为LocalCluster
            localCluster.submitTopology(topologyName, config, topology);
        } else {
            StormSubmitter.submitTopology(topologyName, config, topology);
        }
    }

    /**
     * BrokerHosts hosts  kafka集群列表
     * String topic       要消费的topic主题
     * String zkRoot      kafka在zk中的目录（会在该节点目录下记录读取kafka消息的偏移量）
     * String id          当前操作的标识id
     */
    private static KafkaSpout createKafkaSpout() {
        String brokerZkStr = "uplooking01:2181,uplooking02:2181,uplooking03:2181";
        BrokerHosts hosts = new ZkHosts(brokerZkStr);   // 通过zookeeper中的/brokers即可找到kafka的地址
        String topic = "f-k-s";
        String zkRoot = "/" + topic;
        String id = "consumer-id";
        SpoutConfig spoutConf = new SpoutConfig(hosts, topic, zkRoot, id);
        // 本地环境设置之后，也可以在zk中建立/f-k-s节点，在集群环境中，不用配置也可以在zk中建立/f-k-s节点
        //spoutConf.zkServers = Arrays.asList(new String[]{"uplooking01", "uplooking02", "uplooking03"});
        //spoutConf.zkPort = 2181;
        spoutConf.startOffsetTime = OffsetRequest.LatestTime(); // 设置之后，刚启动时就不会把之前的消费也进行读取，会从最新的偏移量开始读取
        return new KafkaSpout(spoutConf);
    }
}
```

### 5、整合验证

将上面的程序打包成jar包，并上传到我们的集群提交业务后，如果前面的整合没有问题，并且Web服务也有Web日志产生，那么一段时间后，我们就可以在Redis数据库中看到数据的最终处理结果，即各个省份的uv和pv信息：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/67.png)

需要说明的是mid信息是一个set集合，只要求出该set集合的大小，也就可以求出uv值。

至此，准确来说，我们的统计pv、uv的大数据实时处理系统是构建完成了，处理的数据结果的用途根据不同的业务需求而不同，但是对于网站的pv、uv数据来说，是非常适合用作可视化处理的，即用网页动态将数据展示出来，我们下一步正是要构建一个简单的Web应用将pv、uv数据动态展示出来。

## 五、总结

那么至此，从整个大数据实时处理系统的构建到最后的数据可视化处理工作，我们都已经完成了，可以看到整个过程下来涉及到的知识层面还是比较多的，不过我个人觉得，只要把核心的原理牢牢掌握了，对于大部分情况而言，环境的搭建以及基于业务的开发都能够很好地解决。

写此文，一来是对自己实践中的一些总结，二来也是希望把一些比较不错的项目案例分享给大家，总之希望能够对大家有所帮助。


## 例子二


在用户上报日志中，每条日志记录代表用户的一次活动状态，示例数据如下：


```
121.40.174.237 yx12345 [21/July/2015 13:25:45 +0000] chrome 
appid_5 "http://www.***.cn/sort/channel/2085.html"

```


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/51.png)


消费数据源统计的KPI指标，如下图所示

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/52.png)


### 项目详细设计流程


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/53.png)


### 配置数据消费模块


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/54.png)

### 数据持久化

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/55.png)

### 应用打包部署

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/56.png)

### 提交 Topology 到 Storm 集群

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/57.png)

