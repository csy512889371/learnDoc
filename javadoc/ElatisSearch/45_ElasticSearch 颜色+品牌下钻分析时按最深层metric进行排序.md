# 颜色+品牌下钻分析时按最深层metric进行排序


## 需求说明

对品牌下钻的分析结果进行排序

* aggs -> aggs -> order

### 1、查询

```
GET /tvs/sales/_search 
{
  "size": 0,
  "aggs": {
    "group_by_color": {
      "terms": {
        "field": "color"
      },
      "aggs": {
        "group_by_brand": {
          "terms": {
            "field": "brand",
            "order": {
              "avg_price": "desc"
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
      }
    }
  }
}
```


### 2、结果

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
          "group_by_brand": {
            "doc_count_error_upper_bound": 0,
            "sum_other_doc_count": 0,
            "buckets": [
              {
                "key": "三星",
                "doc_count": 1,
                "avg_price": {
                  "value": 8000
                }
              },
              {
                "key": "长虹",
                "doc_count": 3,
                "avg_price": {
                  "value": 1666.6666666666667
                }
              }
            ]
          }
        },
        {
          "key": "绿色",
          "doc_count": 2,
          "group_by_brand": {
            "doc_count_error_upper_bound": 0,
            "sum_other_doc_count": 0,
            "buckets": [
              {
                "key": "小米",
                "doc_count": 1,
                "avg_price": {
                  "value": 3000
                }
              },
              {
                "key": "TCL",
                "doc_count": 1,
                "avg_price": {
                  "value": 1200
                }
              }
            ]
          }
        },
        {
          "key": "蓝色",
          "doc_count": 2,
          "group_by_brand": {
            "doc_count_error_upper_bound": 0,
            "sum_other_doc_count": 0,
            "buckets": [
              {
                "key": "小米",
                "doc_count": 1,
                "avg_price": {
                  "value": 2500
                }
              },
              {
                "key": "TCL",
                "doc_count": 1,
                "avg_price": {
                  "value": 1500
                }
              }
            ]
          }
        }
      ]
    }
  }
}
```