
# 24 ElastciSearch search结果解析

## 概述

* 1、我们如果发出一个搜索请求的话，会拿到一堆搜索结果，本节课，我们来讲解一下，这个搜索结果里的各种数据，都代表了什么含义
* 2、我们来讲解一下，搜索的timeout机制，底层的原理，画图讲解

```
GET /_search
```


```

{
  "took": 6,
  "timed_out": false,
  "_shards": {
    "total": 6,
    "successful": 6,
    "failed": 0
  },
  "hits": {
    "total": 10,
    "max_score": 1,
    "hits": [
      {
        "_index": ".kibana",
        "_type": "config",
        "_id": "5.2.0",
        "_score": 1,
        "_source": {
          "buildNum": 14695
        }
      }
    ]
  }
}
```

* took：整个搜索请求花费了多少毫秒
* hits.total：本次搜索，返回了几条结果
* hits.max_score：本次搜索的所有结果中，最大的相关度分数是多少，每一条document对于search的相关度，越相关，_score分数越大，排位越靠前
* hits.hits：默认查询前10条数据，完整数据，score降序排序

* shards：shards fail的条件（primary和replica全部挂掉），不影响其他shard。默认情况下来说，一个搜索请求，会打到一个index的所有primary shard上去，当然了，每个primary shard都可能会有一个或多个replic shard，所以请求也可以到primary shard的其中一个replica shard上去。

* timeout：默认无timeout，latency平衡completeness，手动指定timeout，timeout查询执行机制

可以修改timeout 默认超时时间

```
timeout=10ms，timeout=1s，timeout=1m
GET /_search?timeout=10m
```
