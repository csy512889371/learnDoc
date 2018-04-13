# 基础22 ElastciSearch document增删改内部原理

## 概述

### 增删改内部原理

* 1、客户端选择一个node发送请求过去，这个node就是coordinating node（协调节点）
* 2、coordinating node，对document进行路由，将请求转发给对应的node（有primary shard）
* 3、实际的node上的primary shard处理请求，然后将数据同步到replica node
* 4、coordinating node，如果发现primary node和所有replica node都搞定之后，就返回响应结果给客户端


### document查询内部原理

* 1、客户端发送请求到任意一个node，成为coordinate node
* 2、coordinate node对document进行路由，将请求转发到对应的node，此时会使用round-robin随机轮询算法，在primary shard以及其所有replica中随机选择一个，让读请求负载均衡
* 3、接收请求的node返回document给coordinate node
* 4、coordinate node返回document给客户端
* 5、特殊情况：document如果还在建立索引过程中，可能只有primary shard有，任何一个replica shard都没有，此时可能会导致无法读取到document，但是document完成索引建立之后，primary shard和replica shard就都有了