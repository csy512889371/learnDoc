# 小米监控Open-Falcon 告警处理-Alarm

## 一、	介绍
* alarm模块是处理报警event的，judge产生的报警event写入redis，alarm从redis读取处理，并进行不同渠道的发送。
* 报警event的处理逻辑并非仅仅是发邮件、发短信这么简单。为了能够自动化对event做处理，alarm需要支持在产生event的时候回调用户提供的接口；有的时候报警短信、邮件太多，对于优先级比较低的报警，希望做报警合并，这些逻辑都是在alarm中做的。
* 我们在配置报警策略的时候配置了报警级别，比如P0/P1/P2等等，每个及别的报警都会对应不同的redis队列 alarm去读取这个数据的时候我们希望先读取P0的数据，再读取P1的数据，最后读取P5的数据，因为我们希望先处理优先级高的。于是：用了redis的brpop指令。
* 已经发送的告警信息，alarm会写入MySQL中保存，这样用户就可以在dashboard中查阅历史报警，同时针对同一个策略发出的多条报警，在MySQL存储的时候，会聚类；历史报警保存的周期，是可配置的，默认为7天。

## 二、	部署说明

alarm是个单点。对于未恢复的告警是放到alarm的内存中的，alarm还需要做报警合并，故而alarm只能部署一个实例。需要对alarm的存活做好监控。

```xml
配置文件必须叫cfg.json：
{
    "log_level": "debug",
    "http": {
        "enabled": true,
        "listen": "0.0.0.0:9912"
    },
    "redis": {
        "addr": "127.0.0.1:6379",
        "maxIdle": 5,
        "highQueues": [
            "event:p0",
            "event:p1",
            "event:p2"
        ],
        "lowQueues": [
            "event:p3",
            "event:p4",
            "event:p5",
            "event:p6"
        ],
        "userIMQueue": "/queue/user/im",
        "userSmsQueue": "/queue/user/sms",
        "userMailQueue": "/queue/user/mail"
    },
    "api": {
        "im": "http://127.0.0.1:10086/wechat",  //微信发送网关地址
        "sms": "http://127.0.0.1:10086/sms",  //短信发送网关地址
        "mail": "http://127.0.0.1:10086/mail", //邮件发送网关地址
        "dashboard": "http://127.0.0.1:8081",  //dashboard模块的运行地址
        "plus_api":"http://127.0.0.1:8080",   //falcon-plus api模块的运行地址
        "plus_api_token": "default-token-used-in-server-side" //用于和falcon-plus api模块服务端之间的通信认证token
    },
    "falcon_portal": {
        "addr": "root:@tcp(127.0.0.1:3306)/alarms?charset=utf8&loc=Asia%2FChongqing",
        "idle": 10,
        "max": 100
    },
    "worker": {
        "im": 10,
        "sms": 10,
        "mail": 50
    },
    "housekeeper": {
        "event_retention_days": 7,  //报警历史信息的保留天数
        "event_delete_batch": 100
    }
}

```

## 三、	进程管理

```shell

# 启动
./open-falcon start alarm

# 停止
./open-falcon stop alarm

# 查看日志
./open-falcon monitor alarm

```

## 四、	备注
* 如果某个核心服务挂了，可能会造成大面积报警，为了减少报警短信数量，我们做了报警合并功能。把报警信息写入dashboard模块，然后dashboard返回一个url地址给alarm，alarm将这个url链接发给用户，这样用户只要收到一条短信（里边是个url地址），点击url进去就是多条报警内容。
* highQueues中配置的几个event队列中的事件是不会做报警合并的，因为那些是高优先级的报警，报警合并只是针对lowQueues中的事件。如果所有的事件都不想做报警合并，就把所有的event队列都配置到highQueues中即可


