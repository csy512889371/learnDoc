# 36_ElasticSearch 统计每种颜色电视最大最小价格


## 一、需求说明

每种颜色电视最大最小价格

* 对颜色进行分组
* 对分组结果进行求 最大、最小、平均值（metric）等 

** count：bucket，terms，自动就会有一个doc_count，就相当于是count
** avg：avg aggs，求平均值
** max：求一个bucket内，指定field值最大的那个数据
** min：求一个bucket内，指定field值最小的那个数据
** sum：求一个bucket内，指定field值的总和

一般来说，90%的常见的数据分析的操作，metric，无非就是count，avg，max，min，sum

## 二、查询

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
            "avg_price": { "avg": { "field": "price" } },
            "min_price" : { "min": { "field": "price"} }, 
            "max_price" : { "max": { "field": "price"} },
            "sum_price" : { "sum": { "field": "price" } } 
         }
      }
   }
}

```

求总和，就可以拿到一个颜色下的所有电视的销售总额

## 三、结果

```

{
  "took": 16,
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
          "max_price": {
            "value": 8000
          },
          "min_price": {
            "value": 1000
          },
          "avg_price": {
            "value": 3250
          },
          "sum_price": {
            "value": 13000
          }
        },
        {
          "key": "绿色",
          "doc_count": 2,
          "max_price": {
            "value": 3000
          },
          "min_price": {
            "value":
          }, 1200
          "avg_price": {
            "value": 2100
          },
          "sum_price": {
            "value": 4200
          }
        },
        {
          "key": "蓝色",
          "doc_count": 2,
          "max_price": {
            "value": 2500
          },
          "min_price": {
            "value": 1500
          },
          "avg_price": {
            "value": 2000
          },
          "sum_price": {
            "value": 4000
          }
        }
      ]
    }
  }
}

```