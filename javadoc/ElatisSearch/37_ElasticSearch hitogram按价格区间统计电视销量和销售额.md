# 37_ElasticSearch hitogram按价格区间统计电视销量和销售额

## 一、需求说明

按价格区间统计电视销量和销售额

* histogram：类似于terms，也是进行bucket分组操作
* 接收一个field，按照这个field的值的各个范围区间，进行bucket分组操作

```
"histogram":{ 
  "field": "price",
  "interval": 2000
}

```

* 价格区间2000，每间隔2000 作为一个分组
* interval：2000，划分范围，0~2000，2000~4000，4000~6000，6000~8000，8000~10000，buckets
* 根据price的值，比如2500，看落在哪个区间内，比如2000~4000，此时就会将这条数据放入2000~4000对应的那个bucket中
* terms，将field值相同的数据划分到一个bucket中
* bucket有了之后，一样的，去对每个bucket执行avg，count，sum，max，min，等各种metric操作，聚合分析

## 二、查询

```
GET /tvs/sales/_search
{
   "size" : 0,
   "aggs":{
      "price":{
         "histogram":{ 
            "field": "price",
            "interval": 2000
         },
         "aggs":{
            "revenue": {
               "sum": { 
                 "field" : "price"
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
  "took": 13,
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
    "group_by_price": {
      "buckets": [
        {
          "key": 0,
          "doc_count": 3,
          "sum_price": {
            "value": 3700
          }
        },
        {
          "key": 2000,
          "doc_count": 4,
          "sum_price": {
            "value": 9500
          }
        },
        {
          "key": 4000,
          "doc_count": 0,
          "sum_price": {
            "value": 0
          }
        },
        {
          "key": 6000,
          "doc_count: {
            "value":": 0,
          "sum_price" 0
          }
        },
        {
          "key": 8000,
          "doc_count": 1,
          "sum_price": {
            "value": 8000
          }
        }
      ]
    }
  }
}

```
