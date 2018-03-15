# 小米监控Open-Falcon：Redis监控

## 一、	介绍

* Redis的数据采集可以通过采集脚本redis-monitor 或者 redismon来做。
* redis-monitor是一个cron，每分钟跑一次采集脚本redis-monitor.py，其中配置了redis服务的地址，redis-monitor连到redis实例，采集一些监控指标，比如connected_clients、used_memory等等，然后组装为open-falcon规定的格式的数据，post给本机的falcon-agent。falcon-agent提供了一个http接口，使用方法可以参考数据采集中的例子。
* 比如，我们有1000台机器都部署了Redis实例，可以在这1000台机器上分别部署1000个cron，即：与Redis实例一一对应。

## 二、	配置安装
* 下载地址：https://github.com/iambocai/falcon-monit-scripts
* 进入目录：/data/program/software/falcon-monit-scripts-master/redis
* 修改配置文件：

```shell
vi redis-monitor.py
```

修改对应连接到agent的地址(特别是红颜色部分注意修改)：

```python

#!/bin/env python
#-*- coding:utf-8 -*-

__author__ = 'iambocai'

import json
import time
import socket
import os
import re
import sys
import commands
import urllib2, base64

class RedisStats:
    # 如果你是自己编译部署到redis，请将下面的值替换为你到redis-cli路径
    _redis_cli = '/usr/local/redis/redis-cli'
    _stat_regex = re.compile(ur'(\w+):([0-9]+\.?[0-9]*)\r')

    def __init__(self,  port='6379', passwd=None, host='127.0.0.1'):
        self._cmd = '%s -h %s -p %s info' % (self._redis_cli, host, port)
        if passwd not in ['', None]:
            self._cmd = '%s -h %s -p %s -a %s info' % (self._redis_cli, host, port, passwd)

    def stats(self):
        ' Return a dict containing redis stats '
        info = commands.getoutput(self._cmd)
        return dict(self._stat_regex.findall(info))


def main():
    ip = "dst6-redis"
    timestamp = int(time.time())
    step = 60
    # inst_list中保存了redis配置文件列表，程序将从这些配置中读取port和password，建议使用动态发现的方法获得，如：
    # inst_list = [ i for i in commands.getoutput("find  /etc/ -name 'redis*.conf'" ).split('\n') ]
    insts_list = [ '/usr/local/redis/redis.conf' ]
    p = []
    
    monit_keys = [
        ('connected_clients','GAUGE'), 
        ('blocked_clients','GAUGE'), 
        ('used_memory','GAUGE'),
        ('used_memory_rss','GAUGE'),
        ('mem_fragmentation_ratio','GAUGE'),
        ('total_commands_processed','COUNTER'),
        ('rejected_connections','COUNTER'),
        ('expired_keys','COUNTER'),
        ('evicted_keys','COUNTER'),
        ('keyspace_hits','COUNTER'),
        ('keyspace_misses','COUNTER'),
        ('keyspace_hit_ratio','GAUGE'),
    ]
  
    for inst in insts_list:
        port = commands.getoutput("sed -n 's/^port *\([0-9]\{4,5\}\)/\\1/p' %s" % inst)
        passwd = commands.getoutput("sed -n 's/^requirepass *\([^ ]*\)/\\1/p' %s" % inst)
        metric = "redis"
        endpoint = ip
        tags = 'port=%s' % port

        try:
            conn = RedisStats(port, passwd)
            stats = conn.stats()
        except Exception,e:
            continue

        for key,vtype in monit_keys:
            #一些老版本的redis中info输出的信息很少，如果缺少一些我们需要采集的key就跳过
            if key not in stats.keys():
                continue
            #计算命中率
            if key == 'keyspace_hit_ratio':
                try:
                    value = float(stats['keyspace_hits'])/(int(stats['keyspace_hits']) + int(stats['keyspace_misses']))
                except ZeroDivisionError:
                    value = 0
            #碎片率是浮点数
            elif key == 'mem_fragmentation_ratio':
                value = float(stats[key])
            else:
                #其他的都采集成counter，int
                try:
                    value = int(stats[key])
                except:
                    continue
            
            i = {
                'Metric': '%s.%s' % (metric, key),
                'Endpoint': endpoint,
                'Timestamp': timestamp,
                'Step': step,
                'Value': value,
                'CounterType': vtype,
                'TAGS': tags
            }
            p.append(i)
        

    print json.dumps(p, sort_keys=True,indent=4)
    method = "POST"
    handler = urllib2.HTTPHandler()
    opener = urllib2.build_opener(handler)
    url = 'http://127.0.0.1:1988/v1/push'
    request = urllib2.Request(url, data=json.dumps(p) )
    request.add_header("Content-Type",'application/json')
    request.get_method = lambda: method
    try:
        connection = opener.open(request)
    except urllib2.HTTPError,e:
        connection = e

    # check. Substitute with appropriate HTTP code.
    if connection.code == 200:
        print connection.read()
    else:
        print '{"err":1,"msg":"%s"}' % connection
if __name__ == '__main__':
    proc = commands.getoutput(' ps -ef|grep %s|grep -v grep|wc -l ' % os.path.basename(sys.argv[0]))
    sys.stdout.flush()
    if int(proc) < 5:
        main()

```


启动测试：python redis-monitor.py

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon/20.png)

将脚本加入crontab执行即可

```shell
查看服务状态：service crond status
编辑：crontab –e
加入命令，一分钟执行一次，然后保存。
*/1 * * * * python /data/program/software/falcon-monit-scripts-master/redis/redis-monitor.py
重启服务：service crond restart 
备注：

```


汇报字段


* key	tag	type	note
* redis.connected_clients	port	GAUGE	已连接客户端的数量
* redis.blocked_clients	port	GAUGE	正在等待阻塞命令（BLPOP、BRPOP、BRPOPLPUSH）的客户端的数量
* redis.used_memory	port	GAUGE	由 Redis 分配器分配的内存总量，以字节（byte）为单位
* redis.used_memory_rss	port	GAUGE	从操作系统的角度，返回 Redis 已分配的内存总量（俗称常驻集大小）
* redis.mem_fragmentation_ratio	port	GAUGE	used_memory_rss 和 used_memory 之间的比率
* redis.total_commands_processed	port	COUNTER	采集周期内执行命令总数
* redis.rejected_connections	port	COUNTER	采集周期内拒绝连接总数
* redis.expired_keys	port	COUNTER	采集周期内过期key总数
* redis.evicted_keys	port	COUNTER	采集周期内踢出key总数
* redis.keyspace_hits	port	COUNTER	采集周期内key命中总数
* redis.keyspace_misses	port	COUNTER	采集周期内key拒绝总数
* redis.keyspace_hit_ratio	port	GAUGE	访问命中率


如需增减字段，请修改monit_keys变量