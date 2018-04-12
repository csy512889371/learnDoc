# 基础13 ElasticSearch 基于_version进行乐观锁并发控制

## 概述一


## 1、基于_version进行乐观锁并发控制

1）version元数据

```
PUT /test_index/test_type/6
{
  "test_field": "test test"
}
```


```

{
  "_index": "test_index",
  "_type": "test_type",
  "_id": "6",
  "_version": 1,
  "result": "created",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  },
  "created": true
}
```

第一次创建一个document的时候，它的_version内部版本号就是1；以后，每次对这个document执行修改或者删除操作，都会对这个_version版本号自动加1；哪怕是删除，也会对这条数据的版本号加1

```
{
  "found": true,
  "_index": "test_index",
  "_type": "test_type",
  "_id": "6",
  "_version": 4,
  "result": "deleted",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  }
}
```

我们会发现，在删除一个document之后，可以从一个侧面证明，它不是立即物理删除掉的，因为它的一些版本号等信息还是保留着的。先删除一条document，再重新创建这条document，其实会在delete version基础之上，再把version号加1

