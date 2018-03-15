# 小米监控Open-Falcon告警判断-Judge

## 一、	介绍

* Judge用于告警判断，agent将数据push给Transfer，Transfer不但会转发给Graph组件来绘图，还会转发给Judge用于判断是否触发告警。
* 因为监控系统数据量比较大，一台机器显然是搞不定的，所以必须要有个数据分片方案。Transfer通过一致性哈希来分片，每个Judge就只需要处理一小部分数据就可以了。所以判断告警的功能不能放在直接的数据接收端：Transfer，而应该放到Transfer后面的组件里。

## 二、	配置说明

* Judge监听了一个http端口，提供了一个http接口：/count，访问之，可以得悉当前Judge实例处理了多少数据量。推荐的做法是一个Judge实例处理50万~100万数据，用个5G~10G内存，如果所用物理机内存比较大，比如有128G，可以在一个物理机上部署多个Judge实例。
* 配置文件必须叫cfg.json: 

```xml
{
    "debug": true,
    "debugHost": "nil",
    "remain": 11,
    "http": {
        "enabled": true,
        "listen": "0.0.0.0:6081"
    },
    "rpc": {
        "enabled": true,
        "listen": "0.0.0.0:6080"
    },
    "hbs": {
        "servers": ["127.0.0.1:6030"], # hbs最好放到lvs vip后面，所以此处最好配置为vip:port
        "timeout": 300,
        "interval": 60
    },
    "alarm": {
        "enabled": true,
        "minInterval": 300, # 连续两个报警之间至少相隔的秒数，维持默认即可
        "queuePattern": "event:p%v",
        "redis": {
            "dsn": "127.0.0.1:6379", # 与alarm、sender使用一个redis
            "maxIdle": 5,
            "connTimeout": 5000,
            "readTimeout": 5000,
            "writeTimeout": 5000
        }
    }
}

```

remain这个配置详细解释一下： remain指定了judge内存中针对某个数据存多少个点，比如host01这个机器的cpu.idle的值在内存中最多存多少个，配置报警的时候比如all(#3)，这个#后面的数字不能超过remain-1，一般维持默认就够用了。

## 三、	进程管理

```shell

# 启动
./open-falcon start judge

# 停止
./open-falcon stop judge

# 查看日志
./open-falcon monitor judge

```

