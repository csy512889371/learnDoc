# ElasticSearch 过滤+聚合：统计价格大于1200的电视平均价格

## 一、需求说明

统计价格大于1200的电视平均价格
* filter 价格大于1200
* 对过滤结果做聚合求平均值
* 搜索+聚合（过滤+聚合）


## 二、查询


```
GET /tvs/sales/_search 
{
  "size": 0,
  "query": {
    "constant_score": {
      "filter": {
        "range": {
          "price": {
            "gte": 1200
          }
        }
      }
    }
  },
  "aggs": {
    "avg_price": {
      "avg": {
        "field": "price"
      }
    }
  }
}
```

## 三、结果

```
{
  "took": 41,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "failed": 0
  },
  "hits": {
    "total": 7,
    "max_score": 0,
    "hits": []
  },
  "aggregations": {
    "avg_price": {
      "value": 2885.714285714286
    }
  }
}
```

