#### 二、skywalking 搭建



##### 1、软件包版本

```
1、apache-skywalking-apm-6.6.0.tar.gz

```

将以上三个软件包上传至服务器/usr/local/src/路径下



##### 3、安装Skywalking服务

```
cd /usr/local/src
tar -zxvf apache-skywalking-apm-6.6.0.tar.gz
mv apache-skywalking-apm-incubating skywalking
mv skywalking/ /HWStor/usr/local/

vim /HWStor/usr/local/skywalking/config/application.yml
修改配置如下：

storage:
#  h2:
#    driver: ${SW_STORAGE_H2_DRIVER:org.h2.jdbcx.JdbcDataSource}
#    url: ${SW_STORAGE_H2_URL:jdbc:h2:mem:skywalking-oap-db}
#    user: ${SW_STORAGE_H2_USER:sa}
  elasticsearch:
    # nameSpace: ${SW_NAMESPACE:""}
    clusterNodes: ${SW_STORAGE_ES_CLUSTER_NODES:192.168.251.146:9200}
    indexShardsNumber: ${SW_STORAGE_ES_INDEX_SHARDS_NUMBER:2}
    indexReplicasNumber: ${SW_STORAGE_ES_INDEX_REPLICAS_NUMBER:0}
    # Batch process setting, refer to https://www.elastic.co/guide/en/elasticsearch/client/java-api/5.5/java-docs-bulk-processor.html
    bulkActions: ${SW_STORAGE_ES_BULK_ACTIONS:2000} # Execute the bulk every 2000 requests
    bulkSize: ${SW_STORAGE_ES_BULK_SIZE:20} # flush the bulk every 20mb
    flushInterval: ${SW_STORAGE_ES_FLUSH_INTERVAL:10} # flush the bulk every 10 seconds whatever the number of requests
    concurrentRequests: ${SW_STORAGE_ES_CONCURRENT_REQUESTS:2} # the number of concurrent requests

vim /HWStor/usr/local/skywalking/webapp/webapp.yml
修改配置如下：

server:
  port: 8081

collector:
  path: /graphql
  ribbon:
    ReadTimeout: 10000
    # Point to all backend's restHost:restPort, split by ,
    listOfServers: 192.168.251.146:12800

启动：
cd /HWStor/usr/local/skywalking/bin/
sh startup.sh

```

##### 4、客户端代理：agent

```
实际开发时候，每一个jar包获取应用都应该单独使用一个agent，
所以将agent这个目录拷贝到各自对应的jar包路径下。

核心部分的目录信息如下:

├── activations
├── config
│   └── agent.config
├── logs
│   └── skywalking-api.log
├── optional-plugins
├── plugins
└── skywalking-agent.jar

其中，config/agent.config是最重要的，需要修改的核心参数如下所示

# 应用名称，当前代理的应用名称，用于UI界面分类和展示
agent.service_name=${SW_AGENT_NAME:Your_ApplicationName}
# 收集器的地址，这个根据实际情况设置，上述`Collector`在哪台服务器启动，ip就设置为多少。
collector.backend_service=${SW_AGENT_COLLECTOR_BACKEND_SERVICES:192.168.251.146:11800}

开发11800、12800端口：
firewall-cmd --list-ports
firewall-cmd --zone=public --add-port=11800/tcp --permanent
firewall-cmd --reload


设置好参数后，对于 Java 应用，添加核心的-javaagent进行启动
java -javaagent:agent/skywalking-agent.jar -jar xxx.jar

idea里启动，添加VM启动参数，例如：
-javaagent:.../agent/skywalking-agent.jar 
-Dskywalking.agent.service_name=test_etl-local 
-Dskywalking.collector.backend_service=192.168.251.146:11800

```

##### 5、附：启动／关闭命令：

```
# 启动ES
su es
cd /usr/local/es/elasticsearch-6.3.2/bin/
./elasticsearch -d

# 关闭ES
netstat -ntap | grep 9200
kill -9 pid

# 启动kibana
su root
cd /usr/local/kibana/kibana-6.3.2-linux-x86_64/bin/
nohup ./kibana > /dev/null 2>&1 &

# 关闭kinana
kill -9 `cat /var/run/kibana.pid`

# 启动skywalking
cd /usr/local/skywalking/bin/
sh startup.sh

# 关闭skywalking
netstat -ntap | grep 12000
kill -9 pid
```



```

    # 关闭 skywalking web
    ps -ef|grep skywalking-webapp
    
    kill -9 pid


    # 关闭 OAPServer
    ps -ef|grep skywalking.oap.server.starter.OAPServerStartUp
    
    kill -9 pid



    # 启动skywalking
    cd /usr/local/loit/soft/skywalking/bin/
    sh startup.sh
```



11800 -> 12001 client

12800-> 12002 collection

8080 > 12000 web 

```
nohup java -javaagent:/usr/local/loit/soft/skywalking/agent/skywalking-agent.jar -Dskywalking.agent.service_name=loit-xx -Dskywalking.collector.backend_service=39.100.254.140:12001 -Xms512m -Xmx512m -XX:PermSize=128M -XX:MaxPermSize=256M -jar $KILL_PROCESS_NAME --spring.profiles.active=test7011 >/var/www/law-7011/loit-law.log 2>&1 &
```





