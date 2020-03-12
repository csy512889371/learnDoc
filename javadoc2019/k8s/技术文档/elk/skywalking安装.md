
# 软件包版本
```
1、elasticsearch-6.3.2.tar.gz
2、kibana-6.3.2-linux-x86_64.tar.gz
3、apache-skywalking-apm-6.4.0.tar.gz

```

将以上三个软件包上传至服务器/usr/local/src/路径下

```
1、创建安装路径
   mkdir /usr/local/es

2、解压软件包
   tar -zxvf /usr/local/src/elasticsearch-6.3.2.tar.gz -C /usr/local/es

3、创建独立用户与组（root用户下创建设定）
   (1)创建用户组
   groupadd es
   (2)创建用户es，并添加至用户组es
   useradd -g es es
   (3)设置密码
   passwd es
   New password:devEs&123
   Retype new password:devEs&123
  （4）使es用户拥有执行权限
   visudo
   
   root    ALL=(ALL)       ALL
   es      ALL=(ALL)       ALL  # 这个新增行
   
4、更改软件包属主属组
   chown -R es:es /usr/local/es/elasticsearch-6.3.2/
   ls -l /usr/local/es/elasticsearch-6.3.2/
   
5、切换到es用户，编辑配置文件，准备启动es
   
   # 设定es群集名称
   cluster.name: my-es-cluster
   # es当前节点名称，用于区分不同节点
   node.name: node-1
   
   # 修改数据目录，此目录为自定义，需要在root用户下创建，且属主属组更改为es
   path.data: /HWStor/data/es-data
   # 日志目录位置，需自己创建，方式同上
   # yum安装则系统自定义，在软件版本或者系统升级时会被删除，所以建议修改
   /HWStor/log/es
   # elasticsearch官网建议生产环境需要设置bootstrap.memory_lock: true
   bootstrap.memory_lock: true
   # 监听访问地址为任意网段
   network.host: 0.0.0.0
   # 服务监听端口
   http.port: 9200
   
6、编辑完成配置文件后，数据目录以及日志文件目录需要创建
   sudo mkdir -p /HWStor/data/es-data
   sudo mkdir -p /HWStor/log/es
   sudo chown -R es:es /HWStor/data/
   sudo chown -R es:es /HWStor/log/es

7、准备工作完成，启动es
   su es
   cd /usr/local/es/elasticsearch-6.3.2/bin/
   ./elasticsearch  # 加上 -d 参数，后台运行

8、启动异常及解决之道
  （1）Caused by: java.lang.RuntimeException: can not run elasticsearch as root
  解决之道：
  su es
  
  （2）Java HotSpot(TM) 64-Bit Server VM warning: Cannot open file logs/gc.log due to Permission denied
     
     Exception in thread "main" org.elasticsearch.bootstrap.BootstrapException: java.nio.file.AccessDeniedException: /usr/local/es/elasticsearch-6.3.2/config/elasticsearch.keystore
     Likely root cause: java.nio.file.AccessDeniedException: /usr/local/es/elasticsearch-6.3.2/config/elasticsearch.keystore
     因为第一次启动不小心用了root启动，导致用root生成了对应的文件。切换es账号之后，没有对应文件的权限导致，删除相关的东西即可。
     
  解决之道：
  su root
  rm -rf /usr/local/es/elasticsearch-6.3.2/config/elasticsearch.keystore
  
  su es
  cd /usr/local/es/elasticsearch-6.3.2/bin/
  ./elasticsearch
  
  （3）2019-05-30 23:17:54,794 main ERROR Unable to locate appender "deprecation_rolling" for logger config "org.elasticsearch.deprecation"
     [2019-05-30T23:17:54,954][WARN ][o.e.b.JNANatives         ] Unable to lock JVM Memory: error=12, reason=Cannot allocate memory
     [2019-05-30T23:17:54,955][WARN ][o.e.b.JNANatives         ] This can result in part of the JVM being swapped out.
     [2019-05-30T23:17:54,955][WARN ][o.e.b.JNANatives         ] Increase RLIMIT_MEMLOCK, soft limit: 65536, hard limit: 65536
     [2019-05-30T23:17:54,956][WARN ][o.e.b.JNANatives         ] These can be adjusted by modifying /etc/security/limits.conf, for example: 
             # allow user 'es' mlockall
             es soft memlock unlimited
             es hard memlock unlimited
   解决之道：
   vim /etc/security/limits.conf
   # 在末尾添加如下内容：
   * soft nofile 65536
   * hard nofile 131072
   es soft memlock unlimited
   es hard memlock unlimited
  
  （4）ERROR: [1] bootstrap checks failed
     [1]: memory locking requested for elasticsearch process but memory is not locked
     
  解决之道：
  vim /etc/sysctl.conf
  sysctl -p
  
  su es
  cd /usr/local/es/elasticsearch-6.3.2/bin/
  ./elasticsearch
  
  启动成功！！！
 
9、检查9200端口是否对外开放
（1）检查9200端口是否开放：netstat -ntap | grep 9200
（2）按照进程号杀掉：kill -9 pid
（3）查看已经开放的端口：firewall-cmd --list-ports
（4）开启端口：firewall-cmd --zone=public --add-port=9200/tcp --permanent
（5）重新载入防火墙的配置：firewall-cmd --reload
（6）重启：
 su es
 cd /usr/local/es/elasticsearch-6.3.2/bin/
 ./elasticsearch -d
 
 另一台电脑浏览器访问http://192.168.251.146:9200/，成功，如下所示：
 {
   "name" : "node-1",
   "cluster_name" : "my-es-cluster",
   "cluster_uuid" : "WDN6zVJQRNWgW2f66b_8rg",
   "version" : {
     "number" : "6.3.2",
     "build_flavor" : "default",
     "build_type" : "tar",
     "build_hash" : "053779d",
     "build_date" : "2018-07-20T05:20:23.451332Z",
     "build_snapshot" : false,
     "lucene_version" : "7.3.1",
     "minimum_wire_compatibility_version" : "5.6.0",
     "minimum_index_compatibility_version" : "5.0.0"
   },
   "tagline" : "You Know, for Search"
 }

```

# 二、安装Kibana

```
1、创建安装路径
   mkdir /usr/local/es

2、解压软件包
   tar -zxvf /usr/local/src/kibana-6.3.2-linux-x86_64.tar.gz -C /usr/local/es
  
3、修改配置文件
（1）vim /usr/local/kibana/kibana-6.3.2-linux-x86_64/config/kibana.yml

# 服务端口号：
server.port: 5601

# 服务IP地址：
server.host: "localhost"
server.host: "192.168.251.146"

# ES链接地址：
elasticsearch.url: "localhost"
elasticsearch.url: "http://192.168.251.146:9200"

# 配置pid文件存储运行Kibana时的进程号，便于用kill -9 `cat /var/run/kibana.pid`来杀进程。
pid_file: /var/run/kibana.pid

# 配置Kibana的日志输出位置：
logging.dest: /HWStor/log/kibana/kibana.log

（2）创建日志文件夹：mkdir /HWStor/log/kibana

3、开放端口：
   firewall-cmd --list-ports
   firewall-cmd --zone=public --add-port=5601/tcp --permanent
   firewall-cmd --reload
   
4、启动
   cd /usr/local/kibana/kibana-6.3.2-linux-x86_64/bin/
   ./kibana
   
   # 在后台不输出日志的方式运行
   cd /usr/local/kibana/kibana-6.3.2-linux-x86_64/bin/
   nohup ./kibana > /dev/null 2>&1 &
   
5、访问
http://192.168.251.146:5601
```

# 三、安装Skywalking服务

```
cd /usr/local/src
tar -zxvf apache-skywalking-apm-6.4.0.tar.gz
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

# 客户端代理：agent
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

# 附：启动／关闭命令：
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
cd /HWStor/usr/local/skywalking/bin/
sh startup.sh

# 关闭skywalking
netstat -ntap | grep 8081
kill -9 pid
```
