# ElasticSearch bucket filter：统计牌品最近一个月的平均价格

## 一、需求说明

统计牌品：最近一个月的平均价格、最近三个月的平均价格、最近10个月的平均价格

* bucket -> filter (对不同的bucket下的aggs，进行filter)
* 如果放query里面的filter，是全局的，会对所有的数据都有影响


## 二、查询

要统计，长虹电视，最近1个月的平均值; 最近3个月的平均值; 最近6个月的平均值

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
    "recent_150d": {
      "filter": {
        "range": {
          "sold_date": {
            "gte": "now-150d"
          }
        }
      },
      "aggs": {
        "recent_150d_avg_price": {
          "avg": {
            "field": "price"
          }
        }
      }
    },
    "recent_140d": {
      "filter": {
        "range": {
          "sold_date": {
            "gte": "now-140d"
          }
        }
      },
      "aggs": {
        "recent_140d_avg_price": {
          "avg": {
            "field": "price"
          }
        }
      }
    },
    "recent_130d": {
      "filter": {
        "range": {
          "sold_date": {
            "gte": "now-130d"
          }
        }
      },
      "aggs": {
        "recent_130d_avg_price": {
          "avg": {
            "field": "price"
          }
        }
      }
    }
  }
}
```


