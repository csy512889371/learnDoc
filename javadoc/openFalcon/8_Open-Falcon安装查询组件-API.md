# Open-Falcon 安装查询组件-API

## 一、	介绍
api组件，提供统一的restAPI操作接口。比如：api组件接收查询请求，根据一致性哈希算法去相应的graph实例查询不同metric的数据，然后汇总拿到的数据，最后统一返回给用户。

## 二、	服务部署
服务部署，包括配置修改、启动服务、检验服务、停止服务等。这之前，需要将安装包解压到服务的部署目录下。

```shell
# 修改配置, 配置项含义见下文, 注意graph集群的配置
vim cfg.json

# 启动服务
./open-falcon start api

# 停止服务
./open-falcon stop api

# 查看日志
./open-falcon monitor api
```

## 三、	服务说明

注意: 请确保 graphs的内容与transfer的配置完全一致

```shell

{
    "log_level": "debug",
    "db": {  //数据库相关的连接配置信息
        "faclon_portal": "root:@tcp(127.0.0.1:3306)/falcon_portal?charset=utf8&parseTime=True&loc=Local",
        "graph": "root:@tcp(127.0.0.1:3306)/graph?charset=utf8&parseTime=True&loc=Local",
        "uic": "root:@tcp(127.0.0.1:3306)/uic?charset=utf8&parseTime=True&loc=Local",
        "dashboard": "root:@tcp(127.0.0.1:3306)/dashboard?charset=utf8&parseTime=True&loc=Local",
        "alarms": "root:@tcp(127.0.0.1:3306)/alarms?charset=utf8&parseTime=True&loc=Local",
        "db_bug": true
    },
    "graphs": {  // graph模块的部署列表信息
        "cluster": {
            "graph-00": "127.0.0.1:6070"
        },
        "max_conns": 100,
        "max_idle": 100,
        "conn_timeout": 1000,
        "call_timeout": 5000,
        "numberOfReplicas": 500
    },
    "metric_list_file": "./api/data/metric",
    "web_port": ":8080",  // http监听端口
    "access_control": true, // 如果设置为false，那么任何用户都可以具备管理员权限
    "salt": "pleaseinputwhichyouareusingnow",  //数据库加密密码的时候的salt
    "skip_auth": false, //如果设置为true，那么访问api就不需要经过认证
    "default_token": "default-token-used-in-server-side",  //用于服务端各模块间的访问授权
    "gen_doc": false,
    "gen_doc_path": "doc/module.html"
}

```

## 备注：
* 部署完成api组件后，请修改dashboard组件的配置、使其能够正确寻址到api组件。
* 请确保api组件的graph列表 与 transfer的配置 一致。





