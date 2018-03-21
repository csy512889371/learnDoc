# 9_ElastisSearch 多shard场景下relevance score不准确


## 图解

如果你的一个index有多个shard的话，可能搜索结果会不准确

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/es/1.png)

## 如何解决该问题

### 1、生产环境下，数据量大，尽可能实现均匀分配

* 数据量很大的话，其实一般情况下，在概率学的背景下，es都是在多个shard中均匀路由数据的，路由的时候根据_id，负载均衡
* 比如说有10个document，title都包含java，一共有5个shard，那么在概率学的背景下，如果负载均衡的话，其实每个shard都应该有2个doc，title包含java
* 如果说数据分布均匀的话，其实就没有刚才说的那个问题了

### 2、测试环境下

* 将索引的primary shard设置为1个，number_of_shards=1，index settings
* 如果说只有一个shard，那么当然，所有的document都在这个shard里面，就没有这个问题了

### 3、测试环境下
* 搜索附带search_type=dfs_query_then_fetch参数，会将local IDF取出来计算global IDF
* 计算一个doc的相关度分数的时候，就会将所有shard对的local IDF计算一下，获取出来，在本地进行global IDF分数的计算，会将所有shard的doc作为上下文来进行计算，也能确保准确性。
* 但是production生产环境下，不推荐这个参数，因为性能很差。

