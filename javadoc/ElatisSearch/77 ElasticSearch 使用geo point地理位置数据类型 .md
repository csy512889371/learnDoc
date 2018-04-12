# 77 ElasticSearch 使用geo point地理位置数据类型 


## 一、概述

es支持基于地理位置的搜索，和聚合分析

* 举个例子，比如说，我们后面就会给大家演示一下，你现在如果说做了一个酒店o2o app，让你的用户在任何地方，都可以根据当前所在的位置，找到自己身边的符合条件的一些酒店，那么此时就完全可以使用es来实现，非常合适
* 我现在在上海某个大厦附近，我要搜索到距离我2公里以内的5星级的带游泳池的一个酒店s，用es就完全可以实现类似这样的基于地理位置的搜索引擎

## 二、例子

### 1、建立geo_point类型的mapping

第一个地理位置的数据类型，就是geo_point，geo_point，说白了，就是一个地理位置坐标点，包含了一个经度，一个维度，经纬度，就可以唯一定位一个地球上的坐标

```
PUT /my_index 
{
  "mappings": {
    "my_type": {
      "properties": {
        "location": {
          "type": "geo_point"
        }
      }
    }
  }
}
```

### 2、写入geo_point的3种方法

```
PUT my_index/my_type/1
{
  "text": "Geo-point as an object",
  "location": { 
    "lat": 41.12,
    "lon": -71.34
  }
}
```

* latitude：维度
* longitude：经度

百度地图api提供各个地方的经纬度

不建议用下面两种语法

```
PUT my_index/my_type/2
{
  "text": "Geo-point as a string",
  "location": "41.12,-71.34" 
}
```

```
PUT my_index/my_type/4
{
  "text": "Geo-point as an array",
  "location": [ -71.34, 41.12 ] 
}
```

### 3、根据地理位置进行查询

最最简单的，根据地理位置查询一些点，比如说，下面geo_bounding_box查询，查询某个矩形的地理位置范围内的坐标点

```
GET /my_index/my_type/_search 
{
  "query": {
    "geo_bounding_box": {
      "location": {
        "top_left": {
          "lat": 42,
          "lon": -72
        },
        "bottom_right": {
          "lat": 40,
          "lon": -74
        }
      }
    }
  }
}
```

```
{
  "took": 81,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "failed": 0
  },
  "hits": {
    "total": 1,
    "max_score": 1,
    "hits": [
      {
        "_index": "my_index",
        "_type": "my_type",
        "_id": "1",
        "_score": 1,
        "_source": {
          "location": {
            "lat": 41.12,
            "lon": -71.34
          }
        }
      }
    ]
  }
}
```

比如41.12,-71.34就是一个酒店，然后我们现在搜索的是从42,-72（代表了大厦A）和40,-74（代表了马路B）作为矩形的范围(矩形的对角两个点)，在这个范围内的酒店，是什么


