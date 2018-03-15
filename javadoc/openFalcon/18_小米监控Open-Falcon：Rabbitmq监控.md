# 小米监控Open-Falcon：Rabbitmq监控


## 一、	介绍

* 在数据采集一节中我们介绍了常见的监控数据源。open-falcon作为一个监控框架，可以去采集任何系统的监控指标数据，只要将监控数据组织为open-falcon规范的格式就OK了。
* RMQ的数据采集可以通过脚本rabbitmq-monitor来做。
* rabbitmq-monitor是一个cron，每分钟跑一次脚本rabbitmq-monitor.py，其中配置了RMQ的用户名&密码等，脚本连到该RMQ实例，采集一些监控指标，比如messages_ready、messages_total、deliver_rate、publish_rate等等，然后组装为open-falcon规定的格式的数据，post给本机的falcon-agent。falcon-agent提供了一个http接口，使用方法可以参考数据采集中的例子。

## 二、	安装配置

* 下载地址：https://github.com/iambocai/falcon-monit-scripts/tree/master/rabbitmq
* 修改配置：vi rabbitmq-monitor.py
*   1、根据实际部署情况，修改15,16行的rabbitmq-server管理端口和登录用户名密码
*   2、确认1中配置的rabbitmq用户有你想监控的queue/vhosts的权限
*   3、将脚本加入crontab即可
* 新建脚本:vi rabbitmq_cron

```shell
* * * * * root (cd /data/program/software/falcon-monit-scripts-master/rabbitmq && python  rabbitmq-monitor.py  > /dev/null)

```

* cp rabbitmq_cron /etc/cron.d/

## 三、	汇报字段

```xml

key	tag	type	note
rabbitmq.messages_ready	name(Queue名字)	GAUGE	队列中处于等待被消费状态消息数
rabbitmq.messages_unacknowledged	name(Queue名字)	GAUGE	队列中处于消费中状态的消息数
rabbitmq.messages_total	name(Queue名字)	GAUGE	队列中所有未完成消费的消息数，等于messages_ready+messages_unacknowledged
rabbitmq.ack_rate	name(Queue名字)	GAUGE	消费者ack的速率
rabbitmq.deliver_rate	name(Queue名字)	GAUGE	deliver的速率
rabbitmq.deliver_get_rate	name(Queue名字)	GAUGE	deliver_get的速率
rabbitmq.publish_rate	name(Queue名字)	GAUGE	publish的速率
```

