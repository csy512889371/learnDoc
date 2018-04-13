# 基础26 ElasticSerach deep paging性能问题

## 概述

1、讲解如何使用es进行分页搜索的语法

size，from

```
GET /_search?size=10
GET /_search?size=10&from=0
GET /_search?size=10&from=20
```

分页的上机实验

```
GET /test_index/test_type/_search
```

```
"hits": {
    "total": 9,
    "max_score": 1,
```

我们假设将这9条数据分成3页，每一页是3条数据，来实验一下这个分页搜索的效果

```
GET /test_index/test_type/_search?from=0&size=3
```

```
{
  "took": 2,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "failed": 0
  },
  "hits": {
    "total": 9,
    "max_score": 1,
    "hits": [
      {
        "_index": "test_index",
        "_type": "test_type",
        "_id": "8",
        "_score": 1,
        "_source": {
          "test_field": "test client 2"
        }
      },
      {
        "_index": "test_index",
        "_type": "test_type",
        "_id": "6",
        "_score": 1,
        "_source": {
          "test_field": "tes test"
        }
      },
      {
        "_index": "test_index",
        "_type": "test_type",
        "_id": "4",
        "_score": 1,
        "_source": {
          "test_field": "test4"
        }
      }
    ]
  }
}
```

第一页：id=8,6,4

```
GET /test_index/test_type/_search?from=3&size=3
```

第二页：id=2,自动生成,7

```
GET /test_index/test_type/_search?from=6&size=3
```

第三页：id=1,11,3

## 2、什么是deep paging问题


deep paging性能问题


搜索过深的时候，就需要coordinate node 上保存大量的数据，还要进行大量数据的排序，排序之后，再取出对应的那一页。所以这个过程，即耗费内存，耗费cpu。所以deep paging的性能问题。我们应该尽量避免出现这种deep paging 的操作。