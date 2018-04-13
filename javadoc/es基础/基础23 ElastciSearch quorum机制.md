# 基础23 ElastciSearch quorum机制

## 概述

### 1、consistency

one（primary shard），all（all shard），quorum（default）

我们在发送任何一个增删改操作的时候，比如说put /index/type/id，都可以带上一个consistency参数，指明我们想要的写一致性是什么？

```
put /index/type/id?consistency=quorum
```

* one：要求我们这个写操作，只要有一个primary shard是active活跃可用的，就可以执行
* all：要求我们这个写操作，必须所有的primary shard和replica shard都是活跃的，才可以执行这个写操作
* quorum：默认的值，要求所有的shard中，必须是大部分的shard都是活跃的，可用的，才可以执行这个写操作

### 2、quorum机制

quorum机制，写之前必须确保大多数shard都可用，int( (primary + number_of_replicas) / 2 ) + 1，当number_of_replicas>1时才生效

```
quroum = int( (primary + number_of_replicas) / 2 ) + 1
```

举个例子，3个primary shard，number_of_replicas=1，总共有3 + 3 * 1 = 6个shard

```
quorum = int( (3 + 1) / 2 ) + 1 = 3
```

所以，要求6个shard中至少有3个shard是active状态的，才可以执行这个写操作

### 3、如果节点数少于quorum数量，可能导致quorum不齐全，进而导致无法执行任何写操作

* 3个primary shard，replica=1，要求至少3个shard是active，3个shard按照之前学习的shard&replica机制，必须在不同的节点上，如果说只有2台机器的话，是不是有可能出现说，3个shard都没法分配齐全，此时就可能会出现写操作无法执行的情况

* es提供了一种特殊的处理场景，就是说当number_of_replicas>1时才生效，因为假如说，你就一个primary shard，replica=1，此时就2个shard

* (1 + 1 / 2) + 1 = 2，要求必须有2个shard是活跃的，但是可能就1个node，此时就1个shard是活跃的，如果你不特殊处理的话，导致我们的单节点集群就无法工作

### 4、quorum不齐全时，wait，默认1分钟，timeout，100，30s

* 等待期间，期望活跃的shard数量可以增加，最后实在不行，就会timeout
* 我们其实可以在写操作的时候，加一个timeout参数，比如说put /index/type/id?timeout=30，这个就是说自己去设定quorum不齐全的时候，es的timeout时长，可以缩短，也可以增长



