# 41_ElasticSearch global bucket：单个品牌与所有品牌销量对比

## 一、需求

单个品牌与所有品牌销量对比

* 出来两个结果
* 一个结果，是基于query搜索结果来聚合的，一个聚合操作，必须在query的搜索结果范围内执行
* 一个结果，是对所有数据执行聚合的

## 二、查询
```
GET /tvs/sales/_search 
{
  "size": 0, 
  "query": {
    "term": {
      "brand": {
        "value": "长虹"
      }
    }
  },
  "aggs": {
    "single_brand_avg_price": {
      "avg": {
        "field": "price"
      }
    },
    "all": {
      "global": {},
      "aggs": {
        "all_brand_avg_price": {
          "avg": {
            "field": "price"
          }
        }
      }
    }
  }
}
```
global：就是global bucket，就是将所有数据纳入聚合的scope，而不管之前的query

## 二、结果

```
{
  "took": 4,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "failed": 0
  },
  "hits": {
    "total": 3,
    "max_score": 0,
    "hits": []
  },
  "aggregations": {
    "all": {
      "doc_count": 8,
      "all_brand_avg_price": {
        "value": 2650
      }
    },
    "single_brand_avg_price": {
      "value": 1666.6666666666667
    }
  }
}
```

* single_brand_avg_price：就是针对query搜索结果，执行的，拿到的，就是长虹品牌的平均价格
* all.all_brand_avg_price：拿到所有品牌的平均价格
