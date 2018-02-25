# ActiveMQ 的安装与使用（单节点） 

* 环境：CentOS6.6、JDK7 

1) 安装 JDK 并配置环境变量（略）
2) 下载或上传 Linux 版的 ActiveMQ（可按实际情况使用新一点的版本）

```shell
$ cd /home/wusc
$ apache-activemq-5.11.1-bin.tar.gz
```

3) 解压安装
```shell
$ tar -zxvf apache-activemq-5.11.1-bin.tar.gz
$ mv apache-activemq-5.11.1 activemq-01
如果启动脚本 activemq 没有可执行权限，此时则需要授权（此步可选）
$ cd /home/wusc/activemq-01/bin/
$ chmod 755 ./activemq
```

4) 防火墙中打开对应的端口

* ActiveMQ 需要用到两个端口
* 一个是消息通讯的端口（默认为 61616）
* 一个是管理控制台端口（默认为 8161）可在 conf/jetty.xml 中修改，如下：

```xml
<bean id="jettyPort" class="org.apache.activemq.web.WebConsolePort" init-method="start">
 <!-- the default port number for the web console -->
 <property name="host" value="0.0.0.0"/>
 <property name="port" value="8161"/>
</bean>
```

```shell

# vi /etc/sysconfig/iptables
添加：
-A INPUT -m state --state NEW -m tcp -p tcp --dport 61616 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8161 -j ACCEPT
重启防火墙：
# service iptables restart

```

5) 启动

```shell
$ cd /home/wusc/activemq-01/bin
$ ./activemq start

```


6) 打开管理界面：http://192.168.1.101:8161

默认用户名和密码为：admin/admin

7) 安全配置（消息安全）

* ActiveMQ 如果不加入安全机制的话，任何人只要知道消息服务的具体地址(包括 ip，端口，消息地址[队列或者主题地址]，)， 都可以肆无忌惮的 发送、 接收消息。 关 于 ActiveMQ 安装配置http://activemq.apache.org/security.html
* ActiveMQ 的消息安全配置策略有多种，我们以简单授权配置为例：

```shell

$ vi /home/wusc/activemq-01/conf/activemq.xml
<plugins>
<simpleAuthenticationPlugin>
<users>
<authenticationUser username="ctoedu" password="ctoedu.cn" groups="users,admins"/>
</users>
</simpleAuthenticationPlugin>
</plugins>


```

* 定义了一个 ctoedu 用户，密码为 ctoedu.cn ，角色为 users,admins
* 设置 admin 的用户名和密码:

```shell
$ vi /home/wusc/activemq-01/conf/jetty.xml
<bean id="securityConstraint" class="org.eclipse.jetty.util.security.Constraint">
 <property name="name" value="BASIC" />
 <property name="roles" value="admin" />
 <property name="authenticate" value="true" />
</bean>

```


* 确保 authenticate 的值为 true（默认）
* 控制台的登录用户名密码保存在 conf/jetty-realm.properties 文件中,内容如下:

```shell
$ vi /home/wusc/activemq-01/conf/jetty-realm.properties
# Defines users that can access the web (console, demo, etc.)
# username: password [,rolename ...]
admin: admin, admin
```
* 注意:用户名和密码的格式是
* 用户名 : 密码 ,角色名

重启:
```shell
$ /home/wusc/activemq-01/bin/activemq restart
```


设置开机启动：
```shell
# vi /etc/rc.local
```

加入以下内容
```shell
## ActiveMQ
su - wusc -c '/home/wusc/activemq-01/bin/activemq start'
```


## activemq.xml

```xml
<!--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    (the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<!-- START SNIPPET: example -->
<beans
  xmlns="http://www.springframework.org/schema/beans"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
  http://activemq.apache.org/schema/core http://activemq.apache.org/schema/core/activemq-core.xsd">

    <!-- Allows us to use system properties as variables in this configuration file -->
    <bean class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
        <property name="locations">
            <value>file:${activemq.conf}/credentials.properties</value>
        </property>
    </bean>

   <!-- Allows accessing the server log -->
    <bean id="logQuery" class="io.fabric8.insight.log.log4j.Log4jLogQuery"
          lazy-init="false" scope="singleton"
          init-method="start" destroy-method="stop">
    </bean>

    <!--
        The <broker> element is used to configure the ActiveMQ broker.
    -->
    <broker xmlns="http://activemq.apache.org/schema/core" brokerName="localhost" dataDirectory="${activemq.data}">

        <destinationPolicy>
            <policyMap>
              <policyEntries>
                <policyEntry topic=">" >
                    <!-- The constantPendingMessageLimitStrategy is used to prevent
                         slow topic consumers to block producers and affect other consumers
                         by limiting the number of messages that are retained
                         For more information, see:

                         http://activemq.apache.org/slow-consumer-handling.html

                    -->
                  <pendingMessageLimitStrategy>
                    <constantPendingMessageLimitStrategy limit="1000"/>
                  </pendingMessageLimitStrategy>
                </policyEntry>
              </policyEntries>
            </policyMap>
        </destinationPolicy>


        <!--
            The managementContext is used to configure how ActiveMQ is exposed in
            JMX. By default, ActiveMQ uses the MBean server that is started by
            the JVM. For more information, see:

            http://activemq.apache.org/jmx.html
        -->
        <managementContext>
            <managementContext createConnector="false"/>
        </managementContext>

        <!--
            Configure message persistence for the broker. The default persistence
            mechanism is the KahaDB store (identified by the kahaDB tag).
            For more information, see:

            http://activemq.apache.org/persistence.html
        -->
        <persistenceAdapter>
            <kahaDB directory="${activemq.data}/kahadb"/>
        </persistenceAdapter>


          <!--
            The systemUsage controls the maximum amount of space the broker will
            use before disabling caching and/or slowing down producers. For more information, see:
            http://activemq.apache.org/producer-flow-control.html
          -->
          <systemUsage>
            <systemUsage>
                <memoryUsage>
                    <memoryUsage percentOfJvmHeap="70" />
                </memoryUsage>
                <storeUsage>
                    <storeUsage limit="100 gb"/>
                </storeUsage>
                <tempUsage>
                    <tempUsage limit="50 gb"/>
                </tempUsage>
            </systemUsage>
        </systemUsage>

        <!--
            The transport connectors expose ActiveMQ over a given protocol to
            clients and other brokers. For more information, see:

            http://activemq.apache.org/configuring-transports.html
        -->
        <transportConnectors>
            <!-- DOS protection, limit concurrent connections to 1000 and frame size to 100MB -->
            <transportConnector name="openwire" uri="tcp://0.0.0.0:61616?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
            <transportConnector name="amqp" uri="amqp://0.0.0.0:5672?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
            <transportConnector name="stomp" uri="stomp://0.0.0.0:61613?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
            <transportConnector name="mqtt" uri="mqtt://0.0.0.0:1883?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
            <transportConnector name="ws" uri="ws://0.0.0.0:61614?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
        </transportConnectors>

        <!-- destroy the spring context on shutdown to stop jetty -->
        <shutdownHooks>
            <bean xmlns="http://www.springframework.org/schema/beans" class="org.apache.activemq.hooks.SpringContextHook" />
        </shutdownHooks>
		
		
		<plugins>
			<simpleAuthenticationPlugin>
				<users>
					<authenticationUser username="ctoedu" password="ctoedu.cn" groups="users,admins"/>
				</users>
			</simpleAuthenticationPlugin>
		</plugins>

    </broker>

    <!--
        Enable web consoles, REST and Ajax APIs and demos
        The web consoles requires by default login, you can disable this in the jetty.xml file

        Take a look at ${ACTIVEMQ_HOME}/conf/jetty.xml for more details
    -->
    <import resource="jetty.xml"/>

</beans>
<!-- END SNIPPET: example -->

```

# 应用端配置

```xml
## MQ 
#ctoedu.pay.mq.brokerURL=failover\:(tcp\://192.168.1.81\:51511,tcp\://192.168.1.82\:51512,tcp\://192.168.1.83\:51513)?jms.prefetchPolicy.queuePrefetch=50&jms.redeliveryPolicy.maximumRedeliveries=1&randomize=false&initialReconnectDelay=1000&maxReconnectDelay=30000
ctoedu.pay.mq.brokerURL=failover\:(tcp\://192.168.1.101\:61616)?jms.prefetchPolicy.queuePrefetch=50&jms.redeliveryPolicy.maximumRedeliveries=1&randomize=false&initialReconnectDelay=1000&maxReconnectDelay=30000
ctoedu.pay.mq.userName=ctoedu
ctoedu.pay.mq.password=ctoedu.com
ctoedu.pay.mq.pool.maxConnections=50

## Queue Name
ctoedu.pay.trade.notify=merchantNotify
```

* jms.prefetchPolicy.queuePrefetch=x （一次抓取x条）
* jms.redeliveryPolicy.maximumRedeliveries=x （消息重发尝试次数，缺省为6次）


