# Windows平台kafka环境的搭建


## 概述


### 1.安装Zookeeper 

* 参照 https://blog.csdn.net/qq_27384769/article/details/78770248


* 运行zookeeper
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/5.png)

### 2. 安装并运行Kafka

* 下载安装文件： http://kafka.apache.org/downloads.html 

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/4.png)

* 解压到 G:\tools\kafka_2.11-1.1.0

* 打开 G:\tools\kafka_2.11-1.1.0\config\ server.properties 

```
把 log.dirs的值改成 log.dirs=G:\data\logs\kafka
```

* 创建文件kafka.cmd

```

@Echo Off

cd G:\tools\kafka_2.11-1.1.0\

G:

.\bin\windows\kafka-server-start.bat .\config\server.properties


pause

```

* 运行 kafka.cmd

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/6.png)


### 3、创建topics

G:\tools\kafka_2.11-1.1.0\bin\windows文件夹中”Shift+鼠标右键”点击空白处打开命令提示窗口


```
kafka-topics.bat --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
```

### 4、打开一个Producer

G:\tools\kafka_2.11-1.1.0\bin\windows文件夹中”Shift+鼠标右键”点击空白处打开命令提示窗口

```
kafka-console-producer.bat --broker-list localhost:9092 --topic test
```

### 5、打开一个Consumer 

G:\tools\kafka_2.11-1.1.0\bin\windows文件夹中”Shift+鼠标右键”点击空白处打开命令提示窗口

```
kafka-console-consumer.bat --zookeeper localhost:2181 --topic test
```

注意：以上打开的窗口不要关闭 
然后就可以在Producer控制台窗口输入消息了。在消息输入过后，很快Consumer窗口就会显示出Producer发送的消息


