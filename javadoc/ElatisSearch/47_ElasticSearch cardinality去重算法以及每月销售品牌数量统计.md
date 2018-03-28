# 47_ElasticSearch cardinality去重算法以及每月销售品牌数量统计

## 一、需求

每月销售品牌数量统计

* 类似与对品牌进行 count(distcint)
* distcint 去重
* cartinality metric，对每个bucket中的指定的field进行去重，取去重后的count
* 存在误差

## 二、查询

```
GET /tvs/sales/_search
{
  "size" : 0,
  "aggs" : {
      "months" : {
        "date_histogram": {
          "field": "sold_date",
          "interval": "month"
        },
        "aggs": {
          "distinct_colors" : {
              "cardinality" : {
                "field" : "brand"
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
  "took": 70,
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
    "group_by_sold_date": {
      "buckets": [
        {
          "key_as_string": "2016-05-01T00:00:00.000Z",
          "key": 1462060800000,
          "doc_count": 1,
          "distinct_brand_cnt": {
            "value": 1
          }
        },
        {
          "key_as_string": "2016-06-01T00:00:00.000Z",
          "key": 1464739200000,
          "doc_count": 0,
          "distinct_brand_cnt": {
            "value": 0
          }
        },
        {
          "key_as_string": "2016-07-01T00:00:00.000Z",
          "key": 1467331200000,
          "doc_count": 1,
          "distinct_brand_cnt": {
            "value": 1
          }
        },
        {
          "key_as_string": "2016-08-01T00:00:00.000Z",
          "key": 1470009600000,
          "doc_count": 1,
          "distinct_brand_cnt": {
            "value": 1
          }
        },
        {
          "key_as_string": "2016-09-01T00:00:00.000Z",
          "key": 1472688000000,
          "doc_count": 0,
          "distinct_brand_cnt": {
            "value": 0
          }
        },
        {
          "key_as_string": "2016-10-01T00:00:00.000Z",
          "key": 1475280000000,
          "doc_count": 1,
          "distinct_brand_cnt": {
            "value": 1
          }
        },
        {
          "key_as_string": "2016-11-01T00:00:00.000Z",
          "key": 1477958400000,
          "doc_count": 2,
          "distinct_brand_cnt": {
            "value": 1
          }
        },
        {
          "key_as_string": "2016-12-01T00:00:00.000Z",
          "key": 1480550400000,
          "doc_count": 0,
          "distinct_brand_cnt": {
            "value": 0
          }
        },
        {
          "key_as_string": "2017-01-01T00:00:00.000Z",
          "key": 1483228800000,
          "doc_count": 1,
          "distinct_brand_cnt": {
            "value": 1
          }
        },
        {
          "key_as_string": "2017-02-01T00:00:00.000Z",
          "key": 1485907200000,
          "doc_count": 1,
          "distinct_brand_cnt": {
            "value": 1
          }
        }
      ]
    }
  }
}

```