# 26_ElasticSearch 四种常见的相关度分数优化方法

对相关度评分进行调节和优化的常见的4种方法
* 1、query-time boost 查询的时候设置query的boost. 增加权重
* 2、重构查询结构.如should中嵌套bool。
* 3、negative boost 包含了negative term的doc，分数乘以negative boost，分数降低
* 4、constant_score 如果你压根儿不需要相关度评分，直接走constant_score加filter，所有的doc分数都是1，没有评分的概念了

## 1、query-time boost

```java
GET /forum/article/_search
{
  "query": {
    "bool": {
      "should": [
        {
          "match": {
            "title": {
              "query": "java spark",
              "boost": 2
            }
          }
        },
        {
          "match": {
            "content": "java spark"
          }
        }
      ]
    }
  }
}
```

## 2、重构查询结构

重构查询结果，在es新版本中，影响越来越小了。一般情况下，没什么必要的话，大家不用也行。

```java
GET /forum/article/_search 
{
  "query": {
    "bool": {
      "should": [
        {
          "match": {
            "content": "java"  1/3
          }
        },
        {
          "match": {
            "content": "spark"  1/3
          }
        },
        {
          "bool": {
            "should": [
              {
                "match": {
                  "content": "solution"  1/6
                }
              },
              {
                "match": {
                  "content": "beginner"  1/6
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

## 3、negative boost

* 搜索包含java，不包含spark的doc，但是这样子很死板
* 搜索包含java，尽量不包含spark的doc，如果包含了spark，不会说排除掉这个doc，而是说将这个doc的分数降低
* 包含了negative term的doc，分数乘以negative boost，分数降低

```java
GET /forum/article/_search 
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "content": "java"
          }
        }
      ],
      "must_not": [
        {
          "match": {
            "content": "spark"
          }
        }
      ]
    }
  }
}
```

```java
GET /forum/article/_search 
{
  "query": {
    "boosting": {
      "positive": {
        "match": {
          "content": "java"
        }
      },
      "negative": {
        "match": {
          "content": "spark"
        }
      },
      "negative_boost": 0.2
    }
  }
}
```


negative的doc，会乘以negative_boost，降低分数

## 4、constant_score

如果你压根儿不需要相关度评分，直接走constant_score加filter，所有的doc分数都是1，没有评分的概念了

```java
GET /forum/article/_search 
{
  "query": {
    "bool": {
      "should": [
        {
          "constant_score": {
            "query": {
              "match": {
                "title": "java"
              }
            }
          }
        },
        {
          "constant_score": {
            "query": {
              "match": {
                "title": "spark"
              }
            }
          }
        }
      ]
    }
  }
}
```
