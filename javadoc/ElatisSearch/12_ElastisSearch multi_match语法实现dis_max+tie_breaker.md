# 12_ElastisSearch multi_match语法实现dis_max+tie_breaker

## 概述:

> dis_max
* score沿用子查询score的最大值

> tie_breaker
* 可以通过tie_breaker来控制其他field的得分

> minimum_should_match，主要是作用:
* 1、去长尾，long tail
* 2、长尾，比如你搜索5个关键词，但是很多结果是只匹配1个关键词的，其实跟你想要的结果相差甚远，这些结果就是长尾
* 3、minimum_should_match，控制搜索结果的精准度，只有匹配一定数量的关键词的数据，才能返回

## 例子：

```java
GET /forum/article/_search
{
  "query": {
    "multi_match": {
        "query":                "java solution",
        "type":                 "best_fields", 
        "fields":               [ "title^2", "content" ],
        "tie_breaker":          0.3,
        "minimum_should_match": "50%" 
    }
  } 
}
```

```java

GET /forum/article/_search
{
  "query": {
    "dis_max": {
      "queries":  [
        {
          "match": {
            "title": {
              "query": "java beginner",
              "minimum_should_match": "50%",
			  "boost": 2
            }
          }
        },
        {
          "match": {
            "body": {
              "query": "java beginner",
              "minimum_should_match": "30%"
            }
          }
        }
      ],
      "tie_breaker": 0.3
    }
  } 
}
```




