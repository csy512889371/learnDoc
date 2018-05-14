# Hadoop生态系统概述


## 一、概述

Hadoop 1.0与2.0


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/90.png)


## 二、Hadoop介绍

> 分布式存储系统

提供了高可靠性、高扩展性和高吞吐率的数据存储服务

> 资源管理系统YARN（Yet Another Resource Negotiator）

负责集群资源的统一管理和调度

> 分布式计算框架MapReduce

1、分布式计算框架

2、具有易于编程、高容错性和高扩展性等优点

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/91.png)


### 1、HDFS（分布式文件系统）

> 基本原理

1、将文件切分成等大的数据块，存储到多台机器上

2、将数据切分、容错、负载均衡等功能透明化

3、可将HDFS看成一个容量巨大、具有高容错性的磁盘

> 应用场景

1、海量数据的可靠性存储

2、数据归档

* nn name node
* dn Data node

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/92.png)


### 2、YARN（资源管理系统）


> YARN是什么

1、Hadoop 2.0新增系统

2、负责集群的资源管理和调度

3、使得多种计算框架可以运行在一个集群中

> YARN的特点

1、良好的扩展性、高可用性

2、对多种类型的应用程序进行统一管理和调度

3、自带了多种多用户调度器，适合共享集群环境


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/93.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/94.png)

### 3、MapReduce（分布式计算框架）


> 源自于Google的MapReduce论文
 
* 发表于2004年12月

* Hadoop MapReduce是Google MapReduce克隆版

> MapReduce特点

* 良好的扩展性
* 高容错性
* 适合PB级以上海量数据的离线处理

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/95.png)


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/96.png)


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/97.png)


## 三、Hadoop生态系统

### 1、1.0时代

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/98.png)

### 2、2.0时代

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/99.png)

### 3、Hive（基于MR的数据仓库）

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/100.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/101.png)


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/102.png)


### 4、Pig

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/103.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/104.png)


### 5、MapReduce程序


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/105.png)


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/106.png)


### 6、Hive语句

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/107.png)

### 7、pig 语句

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/108.png)


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/109.png)

### 8、Mahout（数据挖掘库）


Mahout实现的算法

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/111.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/112.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/113.png)


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/114.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/115.png)

### 9、HBase（分布式数据库）



![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/116.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/117.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/118.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/118.png)

Hbase 架构
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/119.png)


### 10、Zookeeper（分布式协作服务）

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/120.png)

Zookeeper应用

```

  HDFS
YARN
Storm
HBase
Flume
Dubbo（阿里巴巴）
Metaq（阿里巴巴
```



### 11、Sqoop（数据同步工具）



![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/121.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/122.png)

### 12、Flume（日志收集工具）


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/123.png)

### 13、Oozie（作业流调度系统）

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/124.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/125.png)


## 四、Hadoop版本衍化



![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/126.png)

HDP

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/127.png)

CDH

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/128.png)

Hadoop版本选择

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/129.png)

