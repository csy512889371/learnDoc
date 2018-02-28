# dubbo控制台及监控台安装部署


## 一、dubbox打包上传到nexus

* 下载源码：git clone https://github.com/dangdangdotcom/dubbox（这边如果不懂git的，可以下载压缩包）
* 编译安装：进入dubbox目录执行mvn install -Dmaven.test.skip=true
* 修改pom.xml文件，将jar上传到nexus
* 在dubbox目录下，修改pom.xml文件，添加如下代码：

```xml
<distributionManagement>
       <repository>
         <id>nexus-releases</id>
         <url>http://192.168.0.7:8081/repository/maven-releases/</url>
       </repository> 
    </distributionManagement>

```
这里的id要和maven中settings.xml中的<server>…</server>下的id一样

* 修改nexus如下：deployment policy: Allow redeploy
* 然后进入到dubbox目录下执行：mvn deploy -Dmaven.test.skip=true，将jar上传到私服。

## 二、服务器
192.168.0.9


## 三、下载安装tomcat
* 下载地址：http://tomcat.apache.org/download-70.cgi
* 下载完直接解压即可。

## 四、安装dubbo控制台

* 下载dubbo-admin：war包分享出来，大家也可以从自己编译的dubbox中获取。
* 移动dubbo-admin-2.8.4.war到/data/program/software/apache-tomcat-7.0.81/webapps目录下
* 重命名mv dubbo-admin-2.8.4.war ROOT.war
* 启动tomcat，/data/program/software/apache-tomcat-7.0.81/bin/startup.sh
* ROOT.war会自动解压，然后进入ROOT目录
```xml
/data/program/software/apache-tomcat-7.0.81/webapps/ROOT/WEB-INF
```

* 设置dubbo.registry.address
```xml
dubbo.registry.address=zookeeper://10.211.55.7:2181?backup=10.211.55.8:2181,10.211.55.9:2181
dubbo.admin.root.password=root
dubbo.admin.guest.password=guest

```

* 重启tomcat
* 打开地址：http://10.211.55.9:9001/   用户名为：root   密码：root

## 五、安装dubbo监控

* 从编译后的目录下获取dubbo-monitor-simple-2.8.4-assembly.tar.gz
* 进入目录解压：tar -zxf dubbo-monitor-simple-2.8.4-assembly.tar.gz
* 进入目录：/data/program/software/dubbo-monitor-simple-2.8.4/conf 修改dubbo.properties

```shell

dubbo.container=log4j,spring,registry,jetty
dubbo.application.name=simple-monitor
dubbo.application.owner=
#dubbo.registry.address=multicast://224.5.6.7:1234
dubbo.registry.address=zookeeper://10.211.55.7:2181?backup=10.211.55.8:2181,10.211.55.9:2181  #zk地址
#dubbo.registry.address=redis://127.0.0.1:6379
#dubbo.registry.address=dubbo://127.0.0.1:9090
dubbo.protocol.port=7070
dubbo.jetty.port=8080   #http访问端口
dubbo.jetty.directory=${user.home}/monitor
dubbo.charts.directory=${dubbo.jetty.directory}/charts
dubbo.statistics.directory=${user.home}/monitor/statistics
dubbo.log4j.file=logs/dubbo-monitor-simple.log
dubbo.log4j.level=WARN

```

* 启动

```shell
[root@bigdata3 bin]# ./start.sh 
Starting the simple-monitor .....OK!
PID: 3262
STDOUT: logs/stdout.log

```

* 访问地址：http://10.211.55.9:8080/




