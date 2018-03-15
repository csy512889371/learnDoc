# Open-Falcon：安装绘图数据的组件- Graph

## 一、	介绍
graph是存储绘图数据的组件。graph组件 接收transfer组件推送上来的监控数据，同时处理api组件的查询请求、返回绘图数据。

## 二、	服务部署
服务部署，包括配置修改、启动服务、检验服务、停止服务等。这之前，需要将安装包解压到服务的部署目录下。（通知之前的一样，拷贝需要的包到指定的服务器）

```shell
# 修改配置, 配置项含义见下文
vim cfg.json

# 启动服务
./open-falcon start graph

# 停止服务
./open-falcon stop graph

# 查看日志
    ./open-falcon monitor graph
```

## 三、	配置说明

配置文件默认为./cfg.json，配置如下：

```xml
{
    "debug": false, //true or false, 是否开启debug日志
    "http": {
        "enabled": true, //true or false, 表示是否开启该http端口，该端口为控制端口，主要用来对graph发送控制命令、统计命令、debug命令
        "listen": "0.0.0.0:6071" //表示监听的http端口
    },
    "rpc": {
        "enabled": true, //true or false, 表示是否开启该rpc端口，该端口为数据接收端口
        "listen": "0.0.0.0:6070" //表示监听的rpc端口
    },
    "rrd": {
        "storage": "./data/6070" // 历史数据的文件存储路径（如有必要，请修改为合适的路径）
    },
    "db": {
        "dsn": "root:@tcp(127.0.0.1:3306)/graph?loc=Local&parseTime=true", //MySQL的连接信息，默认用户名是root，密码为空，host为127.0.0.1，database为graph（如有必要，请修改)
        "maxIdle": 4  //MySQL连接池配置，连接池允许的最大连接数，保持默认即可
    },
    "callTimeout": 5000,  //RPC调用超时时间，单位ms
    "migrate": {  //扩容graph时历史数据自动迁移
        "enabled": false,  //true or false, 表示graph是否处于数据迁移状态
        "concurrency": 2, //数据迁移时的并发连接数，建议保持默认
        "replicas": 500, //这是一致性hash算法需要的节点副本数量，建议不要变更，保持默认即可（必须和transfer的配置中保持一致）
        "cluster": { //未扩容前老的graph实例列表
            "graph-00" : "127.0.0.1:6070"
        }
    }
}


```

四、	备注


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon/7.png)

如果上图红框中出现同一台服务器的不同名字的配置，则进入数据库，进行如下操作：

* 进入数据库：mysql –u root –p
* 查看所有数据库：show databses;
* 选择数据库：use graph;
* 查看表：show tables;
* 查询表：select * from endpoint;
* 删除不需要的数据：delete from endpoint where id=153;

如下可以不操作：
* 可以一起删除falcon_portal库中的host表中的无用数据。


