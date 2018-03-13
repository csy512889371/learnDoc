# 消息中间件kafka高可用集群安装

## 一、利用安装zookeeper的三台服务器做KAFKA集群


服务器	IP地址	端口
* 服务器1	10.211.55.7	9092
* 服务器2	10.211.55.8	9092
* 服务器3	10.211.55.9	9092

## 1.1	下载 kafka_2.9.2-0.8.1

* 下载地址：https://archive.apache.org/dist/kafka/0.8.1/kafka_2.9.2-0.8.1.tgz
* 分别在三台服务器创建kafka目录并且下载kafka压缩包
```shell
#mkdir /usr/local/kafka
#tar –zxvf kafka_2.9.2-0.8.1.tar.gz
```

## 1.2 创建log文件夹

```shell
#mkdir /usr/local/kafka/kafkalogs
```

## 1.3 配置kafka
```shell

#cd /usr/local/kafka/kafka_2.9.2-0.8.1/config

#vi server.properties  修改项如下：

broker.id=0      //当前机器在集群中的唯一标识
port=9092       //kafka对外提供服务的tcp端口
host.name=10.211.55.7    //主机IP地址
log.dirs=/usr/local/kafka/kafkalogs    //log存放目录
message.max.byte=5048576     //kafka一条消息容纳的消息最大为多少
default.replication.factor=2   //每个分区默认副本数量
replica.fetch.max.bytes=5048576   
zookeeper.connect=10.211.55.7:2181, 10.211.55.8:2181, 10.211.55.9:2181

```
## 4.4 启动kafka

```shell
# ./kafka-server-start.sh  -daemon ../config/server.properties   //后台启动运行
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/1.bmp)

##4.5 问题解决
```shell
[root@master ~]#  /export/kafka/bin/kafka-console-producer.sh  --broker-list 10.14.2.201:9092,10.14.2.202:9092,10.14.2.203:9092,10.14.2.204:9092    --topic test 
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
 SLF4J: Defaulting to no-operation (NOP) logger implementation
 SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.

```

```shell
 # /export/kafka/bin/kafka-console-consumer.sh  --zookeeper   10.14.2.201:2181,10.14.2.202:2181,10.14.2.203:2181,10.14.2.204:2181  --topic test --from-beginning
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
 SLF4J: Defaulting to no-operation (NOP) logger implementation
 SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
```

解决方法：
```shell
 下载slf4j-1.7.6.zip
 http://www.slf4j.org/dist/slf4j-1.7.6.zip
 解压
 unzip slf4j-1.7.6.zip
 把slf4j-nop-1.7.6.jar 包复制到kafka libs目录下面
 cd  slf4j-1.7.6
 cp slf4j-nop-1.7.6.jar  /export/kafka/libs/

```


# 二、KAFKA集群验证

2.1 创建topic
```shell
#./kafka-topics.sh --create --zookeeper 10.211.55.7:2181 --replication-factor 1 --partitions 1 --topic test

```

2.2 查看topic
```shell
# ./kafka-topics.sh --list --zookeeper 10.211.55.7:2181
```

2.3 开启发送者并发送消息
```shell
#./kafka-console-producer.sh --broker-list 10.211.55.7:9092 --topic test
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/2.png)

2.4 开启消费者并接收消息
#./kafka-console-consumer.sh --zookeeper 10.211.55.8:2181 --topic test --from-beginning

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/3.png)








