# 34_ElasticSearch bucket+metric：统计每种分组中的平均值

## 一、需求说明

bucket和metric 组合：统计每种颜色电视平均价格
* 按照color去分组
* 对分组结果进行求平均值


## 二、查询

* 按照color去分bucket，可以拿到每个color bucket中的数量
* 对一个bucket分组操作之后，再对每个bucket都要执行的一个metric（求平均值）
* metric操作（avg），对之前的每个bucket中的数据的指定的field，price field，求一个平均值

```
GET /tvs/sales/_search
{
   "size" : 0,
   "aggs": {
      "colors": {
         "terms": {
            "field": "color"
         },
         "aggs": { 
            "avg_price": { 
               "avg": {
                  "field": "price" 
               }
            }
         }
      }
   }
}
```

## 三、结果

```

{
  "took": 28,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "failed": 0
  },
  "hits": {
    "total": 8,
    "max_score": 0,
    "hits": []
  },
  "aggregations": {
    "group_by_color": {
      "doc_count_error_upper_bound": 0,
      "sum_other_doc_count": 0,
      "buckets": [
        {
          "key": "红色",
          "doc_count": 4,
          "avg_price": {
            "value": 3250
          }
        },
        {
          "key": "绿色",
          "doc_count": 2,
          "avg_price": {
            "value": 2100
          }
        },
        {
          "key": "蓝色",
          "doc_count": 2,
          "avg_price": {
            "value": 2000
          }
        }
      ]
    }
  }
}
```
* buckets，除了key和doc_count
* avg_price：我们自己取的metric aggs的名字
* value：我们的metric计算的结果，每个bucket中的数据的price字段求平均值后的结果

```
select avg(price)
from tvs.sales
group by color
```