# 50_ElasticSearch percentiles rank以及网站访问时延SLA统计

## 一、需求

需求：在200ms以内的，有百分之多少，在1000毫秒以内的有百分之多少

* 我们的网站的提供的访问延时的SLA，确保所有的请求100%，都必须在200ms以内，大公司内，一般都是要求100%在200ms以内
* SLA：就是你提供的服务的标准
* 如果超过1s，则需要升级到A级故障，代表网站的访问性能和用户体验急剧下降
* percentile ranks metric 使用场景二 如：按照品牌分组，计算，电视机，售价在1000占比，2000占比，3000占比



## 二、请求

```
GET /website/logs/_search 
{
  "size": 0,
  "aggs": {
    "group_by_province": {
      "terms": {
        "field": "province"
      },
      "aggs": {
        "latency_percentile_ranks": {
          "percentile_ranks": {
            "field": "latency",
            "values": [
              200,
              1000
            ]
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
  "took": 38,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "failed": 0
  },
  "hits": {
    "total": 12,
    "max_score": 0,
    "hits": []
  },
  "aggregations": {
    "group_by_province": {
      "doc_count_error_upper_bound": 0,
      "sum_other_doc_count": 0,
      "buckets": [
        {
          "key": "新疆",
          "doc_count": 6,
          "latency_percentile_ranks": {
            "values": {
              "200.0": 29.40613026819923,
              "1000.0": 100
            }
          }
        },
        {
          "key": "江苏",
          "doc_count": 6,
          "latency_percentile_ranks": {
            "values": {
              "200.0": 100,
              "1000.0": 100
            }
          }
        }
      ]
    }
  }
}

```

## 四、percentile的优化

* TDigest算法，用很多节点来执行百分比的计算，近似估计，有误差，节点越多，越精准
* 限制节点数量最多 compression * 20 = 2000个node去计算
* 默认100，越大，占用内存越多，越精准，性能越差
* 一个节点占用32字节，100 * 20 * 32 = 64KB
* 如果你想要percentile算法越精准，compression可以设置的越大

