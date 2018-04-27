# Kafka Partition Leader选主机制


## 一、概述

* 大数据常用的选主机制
* 常用选主机制的缺点
* Kafka Partition选主机制


## 二、大数据常用的选主机制

Leader选举算法非常多，大数据领域常用的有 以下两种:
* Zab(zookeeper使用);
* Raft；
……

它们都是Paxos算法的变种。

> Zab协议有四个阶段:
* Leader election;
* Discovery（或者epoch establish）；
* Synchronization（或者sync with followers）
* Broadcast

比如3个节点选举leader，编号为1,2,3。1先启动，选择自己为leader，然后2启动首先也选择自己为 leader，由于1,2都没过半，选择编号大的为leader，所以1,2都选择2为leader,然后3启动发现1,2已经协商好且数量过半，于是3也选择2为leader，leader选举结束。 


> 在Raft中，任何时候一个服务器可以扮演下面角色之一

* Leader: 处理所有客户端交互，日志复制等，一般只有一个Leader；
* Follower: 类似选民，完全被动
* Candidate候选人: 可以被选为一个新的领导人

启动时在集群中指定一些机器为Candidate ，然后Candidate开始向其他机器(尤其是Follower)拉票，当某一个Candidate的票数超过半数，它就成为leader。


> 常用选主机制的缺点

由于Kafka集群依赖zookeeper集群，所以最简单最直观的方案是，所有Follower都在ZooKeeper上设置一个Watch，一旦Leader宕机，其对应的ephemeral znode会自动删除，此时所有Follower都尝试创建该节点，而创建成功者（ZooKeeper保证只有一个能创建成功）即是新的Leader，其它Replica即为Follower。

前面的方案有以下缺点：

* split-brain (脑裂):  这是由ZooKeeper的特性引起的，虽然ZooKeeper能保证所有Watch按顺序触发，但并不能保证同一时刻所有Replica“看”到的状态是一样的，这就可能造成不同Replica的响应不一致 ;
* herd effect (羊群效应):  如果宕机的那个Broker上的Partition比较多，会造成多个Watch被触发，造成集群内大量的调整；


* ZooKeeper负载过重 :  每个Replica都要为此在ZooKeeper上注册一个Watch，当集群规模增加到几千个Partition时ZooKeeper负载会过重 

## 三、Kafka Partition选主机制

Kafka 的Leader Election方案解决了上述问题，它在所有broker中选出一个controller，所有Partition的Leader选举都由controller决定。controller会将Leader的改变直接通过RPC的方式（比ZooKeeper Queue的方式更高效）通知需为此作为响应的Broker。


Kafka 集群controller的选举过程如下 ：

* 每个Broker都会在Controller Path (/controller)上注册一个Watch。

* 当前Controller失败时，对应的Controller Path会自动消失（因为它是ephemeral Node），此时该Watch被fire，所有“活”着的Broker都会去竞选成为新的Controller（创建新的Controller Path),但是只会有一个竞选成功（这点由Zookeeper保证）。

* 竞选成功者即为新的Leader，竞选失败者则重新在新的Controller Path上注册Watch。因为Zookeeper的Watch是一次性的，被fire一次之后即失效，所以需要重新注册。


Kafka  partition  leader的选举过程如下 (由controller执行)：

* 从Zookeeper中读取当前分区的所有ISR(in-sync replicas)集合
* 调用配置的分区选择算法选择分区的leader
