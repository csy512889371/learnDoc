# 48_ElasticSearch ardinality算法之优化内存开销以及HLL算法 

## 一、概述

* ardinality算法类似与count(distcint)。在多shard情况下有一定的误差
* cardinality，count(distinct)，5%的错误率，性能在100ms左右

## 二、precision_threshold优化准确率和内存开销

```
GET /tvs/sales/_search
{
    "size" : 0,
    "aggs" : {
        "distinct_brand" : {
            "cardinality" : {
              "field" : "brand",
              "precision_threshold" : 100 
            }
        }
    }
}

```
例子：设置 precision_threshold 为100 者表示：

* 对品牌brand去重，如果brand的unique value，在100个以内，小米，长虹，三星，TCL，HTL。几乎保证100%准确
* precision_threshold 表示：在多少个unique value以内，cardinality，几乎保证100%准确
* cardinality算法，会占用precision_threshold * 8 byte 内存消耗，100 * 8 = 800个字节
* 占用内存很小。而且unique value如果的确在值以内，那么可以确保100%准确
* 设置为100，如果有数百万的unique value，那么错误率也在5%以内
* precision_threshold，值设置的越大，占用内存越大，1000 * 8 = 8000 / 1000 = 8KB，可以确保更多unique value的场景下，100%的准确


## 三、HyperLogLog++ (HLL)算法性能优化

* cardinality底层算法：HLL算法，HLL算法的性能
* 会对所有的uqniue value取hash值，通过hash值近似去求distcint count，误差
* 默认情况下，发送一个cardinality请求的时候，会动态地对所有的field value，取hash值; 将取hash值的操作，前移到建立索引的时候

```
PUT /tvs/
{
  "mappings": {
    "sales": {
      "properties": {
        "brand": {
          "type": "text",
          "fields": {
            "hash": {
              "type": "murmur3" 
            }
          }
        }
      }
    }
  }
}

```

```
GET /tvs/sales/_search
{
    "size" : 0,
    "aggs" : {
        "distinct_brand" : {
            "cardinality" : {
              "field" : "brand.hash",
              "precision_threshold" : 100 
            }
        }
    }
}

```
