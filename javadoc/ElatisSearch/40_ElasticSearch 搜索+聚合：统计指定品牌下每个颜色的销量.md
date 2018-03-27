# 40_ElasticSearch 搜索+聚合：统计指定品牌下每个颜色的销量

## 一、需求说明

统计指定品牌下每个颜色的销量

实际上来说，搜索，完全可以和聚合组合起来使用

* query -> aggs

```
select count(*)
from tvs.sales
where brand like "%长%"
group by price
```

任何的聚合，都必须在搜索出来的结果数据中进行，搜索结果，就是聚合分析操作的scope

## 二、查询

```
GET /tvs/sales/_search 
{
  "size": 0,
  "query": {
    "term": {
      "brand": {
        "value": "小米"
      }
    }
  },
  "aggs": {
    "group_by_color": {
      "terms": {
        "field": "color"
      }
    }
  }
}
```

## 三、结果

```
{
  "took": 5,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "failed": 0
  },
  "hits": {
    "total": 2,
    "max_score": 0,
    "hits": []
  },
  "aggregations": {
    "group_by_color": {
      "doc_count_error_upper_bound": 0,
      "sum_other_doc_count": 0,
      "buckets": [
        {
          "key": "绿色",
          "doc_count": 1
        },
        {
          "key": "蓝色",
          "doc_count": 1
        }
      ]
    }
  }
}
```
