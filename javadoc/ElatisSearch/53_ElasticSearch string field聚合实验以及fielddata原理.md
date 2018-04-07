# 53_ElasticSearch string field聚合实验以及fielddata原理

## 一、概念
* 对于分词的field执行聚合是有问题的。
* 如果对不分词的field执行聚合操作，直接就可以执行，不需要设置fieldata=true
* 如果要对分词的field执行聚合操作，必须将fielddata设置为true
* 分词field默认没有doc value，所以直接对分词field执行聚合操作，是会报错的

分词field+fielddata的工作原理

```
doc value 
--> 不分词的所有field，可以执行聚合操作 
--> 如果你的某个field不分词，那么在index-time，就会自动生成doc value 
--> 针对这些不分词的field执行聚合操作的时候，自动就会用doc value来执行
```

* 分词field，是没有doc value的。在index-time，
* 如果某个field是分词的，那么是不会给它建立doc value正排索引的，因为分词后，占用的空间过于大，所以默认是不支持分词field进行聚合的
* 分词field默认没有doc value，所以直接对分词field执行聚合操作，是会报错的

* 1、对于分词field，必须打开和使用fielddata，
* 2、完全存在于纯内存中。结构和doc value类似。如果是ngram或者是大量term，那么必将占用大量的内存。
* 3、如果一定要对分词的field执行聚合，那么必须将fielddata=true，然后es就会在执行聚合操作的时候，现场将field对应的数据，建立一份fielddata正排索引，fielddata正排索引的结构跟doc value是类似的，但是只会讲fielddata正排索引加载到内存中来，然后基于内存中的fielddata正排索引执行分词field的聚合操作
* 4、如果直接对分词field执行聚合，报错，才会让我们开启fielddata=true，告诉我们，会将fielddata uninverted index，正排索引，加载到内存，会耗费内存空间
* 5、为什么fielddata必须在内存.因为分词的字符串，需要按照term进行聚合，需要执行更加复杂的算法和操作，如果基于磁盘和os cache，那么性能会很差

## 二、 场景一

1、对于分词的field执行aggregation，发现报错。

```
GET /test_index/test_type/_search 
{
  "aggs": {
    "group_by_test_field": {
      "terms": {
        "field": "test_field"
      }
    }
  }
}

```

* 对分词的field，直接执行聚合操作，会报错，大概意思是说，你必须要打开fielddata
* 然后将正排索引数据加载到内存中，才可以对分词的field执行聚合操作，而且会消耗很大的内存

```
{
  "error": {
    "root_cause": [
      {
        "type": "illegal_argument_exception",
        "reason": "Fielddata is disabled on text fields by default. Set fielddata=true on [test_field] in order to load fielddata in memory by uninverting the inverted index. Note that this can however use significant memory."
      }
    ],
    "type": "search_phase_execution_exception",
    "reason": "all shards failed",
    "phase": "query",
    "grouped": true,
    "failed_shards": [
      {
        "shard": 0,
        "index": "test_index",
        "node": "4onsTYVZTjGvIj9_spWz2w",
        "reason": {
          "type": "illegal_argument_exception",
          "reason": "Fielddata is disabled on text fields by default. Set fielddata=true on [test_field] in order to load fielddata in memory by uninverting the inverted index. Note that this can however use significant memory."
        }
      }
    ],
    "caused_by": {
      "type": "illegal_argument_exception",
      "reason": "Fielddata is disabled on text fields by default. Set fielddata=true on [test_field] in order to load fielddata in memory by uninverting the inverted index. Note that this can however use significant memory."
    }
  },
  "status": 400
}

```

## 例子二

* 给分词的field，设置fielddata=true，发现可以执行。
* 如果要对分词的field执行聚合操作，必须将fielddata设置为true


设置 "fielddata": true
```
POST /test_index/_mapping/test_type 
{
  "properties": {
    "test_field": {
      "type": "text",
      "fielddata": true
    }
  }
}

```

```
{
  "test_index": {
    "mappings": {
      "test_type": {
        "properties": {
          "test_field": {
            "type": "text",
            "fields": {
              "keyword": {
                "type": "keyword",
                "ignore_above": 256
              }
            },
            "fielddata": true
          }
        }
      }
    }
  }
}

```

查询：
```
GET /test_index/test_type/_search 
{
  "size": 0, 
  "aggs": {
    "group_by_test_field": {
      "terms": {
        "field": "test_field"
      }
    }
  }
}

```

查询结果：
```
{
  "took": 23,
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
    "group_by_test_field": {
      "doc_count_error_upper_bound": 0,
      "sum_other_doc_count": 0,
      "buckets": [
        {
          "key": "test",
          "doc_count": 2
        }
      ]
    }
  }
}

```


## 例子三

使用内置field keyword不分词，对string field进行聚合

```
GET /test_index/test_type/_search 
{
  "size": 0,
  "aggs": {
    "group_by_test_field": {
      "terms": {
        "field": "test_field.keyword"
      }
    }
  }
}
```

结果：

```
{
  "took": 3,
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
    "group_by_test_field": {
      "doc_count_error_upper_bound": 0,
      "sum_other_doc_count": 0,
      "buckets": [
        {
          "key": "test",
          "doc_count": 2
        }
      ]
    }
  }
}
```

