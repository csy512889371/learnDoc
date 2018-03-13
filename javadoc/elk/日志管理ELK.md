# 运维架构日志管理ELK：ElasticSearch 、 Logstash 和 Kibana 介绍，结合redis安装配置及展示


# 一、	介绍
* 1、日志主要包括系统日志、应用程序日志和安全日志。系统运维和开发人员可以通过日志了解服务器软硬件信息、检查配置过程中的错误及错误发生的原因。经常分析日志可以了解服务器的负荷，性能安全性，从而及时采取措施纠正错误。
* 2、通常，日志被分散的储存不同的设备上。如果你管理数十上百台服务器，你还在使用依次登录每台机器的传统方法查阅日志。这样是不是感觉很繁琐和效率低下。当务之急我们使用集中化的日志管理，例如：开源的syslog，将所有服务器上的日志收集汇总。
* 3、集中化管理日志后，日志的统计和检索又成为一件比较麻烦的事情，一般我们使用grep、awk和wc等Linux命令能实现检索和统计，但是对于要求更高的查询、排序和统计等要求和庞大的机器数量依然使用这样的方法难免有点力不从心。
* 4、开源实时日志分析ELK平台能够完美的解决我们上述的问题，ELK由ElasticSearch、Logstash和Kiabana三个开源工具组成。官方网站：https://www.elastic.co/products


* 1.Elasticsearch是个开源分布式搜索引擎，它的特点有：分布式，零配置，自动发现，索引自动分片，索引副本机制，restful风格接口，多数据源，自动搜索负载等。
* 2.Logstash是一个完全开源的工具，他可以对你的日志进行收集、分析，并将其存储供以后使用（如，搜索）。
* 3.kibana 也是一个开源和免费的工具，他Kibana可以为 Logstash 和 ElasticSearch 提供的日志分析友好的 Web 界面，可以帮助您汇总、分析和搜索重要数据日志。

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/elk/1.png)

* 在需要收集日志的所有服务上部署logstash，作为logstash agent（logstash shipper）用于监控并过滤收集日志，
* 将过滤后的内容发送到logstash indexer，logstash indexer将日志收集在一起交给全文搜索服务ElasticSearch，
* 可以用ElasticSearch进行自定义搜索通过Kibana 来结合自定义搜索进行页面展示。



# 二、	安装ElasticSearch

## 1、	安装jdk

```shell

wget  http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.tar.gz
mkdir /usr/local/java 
tar -zxf jdk-8u45-linux-x64.tar.gz -C /usr/local/java/
export JAVA_HOME=/usr/local/java/jdk1.8.0_4
export PATH=$PATH:$JAVA_HOME/bin

export CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:$CLASSPATH
```

## 2、	安装ElasticSearch

```shell
wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.2.0/elasticsearch-2.2.0.tar.gz
解压：tar -zxf elasticsearch-2.2.0.tar.gz -C ./
安装elasticsearch的head插件: 
cd /data/program/software/elasticsearch-2.2.0 
./bin/plugin install mobz/elasticsearch-head 
```

执行结果： 

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/elk/2.png)

安装elasticsearch的kopf插件 

```shell
./bin/plugin install lmenezes/elasticsearch-kopf 
```

执行结果： 


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/elk/3.png)


创建elasticsearch的data和logs目录
```shell
mkdir data
mkdir logs
```


配置elasticsearch的配置文件
```shell
cd config/
```

备份一下源文件： 
```shell
cp elasticsearch.yml elasticsearch.yml_back
```

编辑配置文件：
```shell
vim elasticsearch.yml 
```
  
配置内容如下：

```shell
cluster.name: dst98  主机名称
node.name: node-1
path.data: /data/program/software/elasticsearch-2.2.0/data
path.logs: /data/program/software/elasticsearch-2.2.0/logs
network.host: 10.15.0.98   主机IP地址
network.port: 9200    主机端口
```

启动elasticsearch: ./bin/elasticsearch


报如下错误：说明不能以root账户启动，需要创建一个普通用户，用普通用户启动才可以。

```shell
[root@dst98 elasticsearch-2.2.0]# ./bin/elasticsearch
Exception in thread "main" java.lang.RuntimeException: don't run elasticsearch as root.
        at org.elasticsearch.bootstrap.Bootstrap.initializeNatives(Bootstrap.java:93)
        at org.elasticsearch.bootstrap.Bootstrap.setup(Bootstrap.java:144)
        at org.elasticsearch.bootstrap.Bootstrap.init(Bootstrap.java:285)
        at org.elasticsearch.bootstrap.Elasticsearch.main(Elasticsearch.java:35)
Refer to the log for complete error details.
```

添加用户及用户组

```shell
#groupadd search
#useradd -g search  search
```

将data和logs目录的属主和属组改为search

```shell
#chown search.search /elasticsearch/ -R
```

然后切换用户并且启动程序：
```shell
su search
./bin/elasticsearch

后台启动：nohup ./bin/elasticsearch &
```

启动成功后浏览器访问如下：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/elk/4.png)


通过安装head插件可以查看集群的一些信息，访问地址及结果如下：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/elk/5.png)


# 三、安装Kibana

下载kibana：

```shell
wget https://download.elastic.co/kibana/kibana/kibana-4.4.0-linux-x64.tar.gz
```

解压：
```shell
tar -zxf kibana-4.4.0-linux-x64.tar.gz -C ./
```

重命名：

```shell
mv kibana-4.4.0-linux-x64 kibana-4.4.0
```

先备份配置文件：

```shell
/data/program/software/kibana-4.4.0/config
cp kibana.yml  kibana.yml_back
```

修改配置文件：
```shell
server.port: 5601           
server.host: "10.15.0.98"
elasticsearch.url: "http://10.15.0.98:9200"    --ip为server的ip地址
kibana.defaultAppId: "discover"
elasticsearch.requestTimeout: 300000
elasticsearch.shardTimeout: 0
```

启动程序：
```shell
 nohup ./bin/kibana &
```

# 四、配置Logstash

下载logstash到要采集日志的服务器上和安装ELK的机器上。
```shell
wget https://download.elastic.co/logstash/logstash/logstash-2.2.0.tar.gz
```

解压： tar -zxf logstash-2.2.0.tar.gz -C ./

运行如下命令进行测试：
```shell
./bin/logstash -e 'input { stdin{} } output { stdout {} }' 
Logstash startup completed
Hello World!     #输入字符
2015-07-15T03:28:56.938Z noc.vfast.com Hello World!  #输出字符格式
```

注：其中-e参数允许Logstash直接通过命令行接受设置。使用CTRL-C命令可以退出之前运行的Logstash。

## 1、配置ElasticSearch上的LogStash读取redis里的日志写到ElasticSearch

进入logstash目录新建一个配置文件： 

```shell
cd logstash-2.2.0 
touch logstash-indexer.conf #文件名随便起 
```

写如下配置到新建立的配置文件： 

```shell
input和output根据日志服务器数量，可以增加多个。
input {
    redis {
        data_type => "list"
        key => "mid-dst-oms-155"
        host => "10.15.0.96"
        port => 6379
        db => 0
        threads => 10
        }
}

output {
        if [type] == "mid-dst-oms-155"{
        elasticsearch {
        hosts => "10.15.0.98"
        index => "mid-dst-oms-155"
        codec => "json"
        }
       }
}
```

启动logstash：

```shell
nohup ./bin/logstash -f logstash-indexer.conf  -l logs/logstash.log &
```

## 2、配置客户端的LogStash读取日志写入到redis

进入logstash目录新建一个配置文件： 
```shell
cd logstash-2.2.0 
touch logstash_agent.conf #文件名随便起 
```

写如下配置到新建立的配置文件： 

```shell
input和output根据日志服务器数量，可以增加多个。

input { 
file { 
path => [“/data/program/logs/MID-DST-OMS/mid-dst-oms.txt”] 
type => “mid-dst-oms-155” 
} 
} 
output{ 
redis { 
host => “125.35.5.98” 
port => 6379 
data_type => “list” 
key => “mid-dst-oms-155” 
} 
}
```

启动logstash：

```shell
nohup ./bin/logstash -f logstash_agent.conf -l logs/logstash.log &
```

备注： 

```shell

logstash中input参数设置： 
1. start_position：设置beginning保证从文件开头读取数据。 
2. path：填入文件路径。 
3. type：自定义类型为tradelog，由用户任意填写。 
4. codec：设置读取文件的编码为GB2312,用户也可以设置为UTF-8等等 
5. discover_interval：每隔多久去检查一次被监听的 path 下是否有新文件，默认值是15秒 
6. sincedb_path：设置记录源文件读取位置的文件，默认为文件所在位置的隐藏文件。 
7. sincedb_write_interval：每隔15秒记录一下文件读取位置
```


