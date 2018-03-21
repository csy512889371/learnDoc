# 8_基于boost的搜索条件权重控制

## 需求

>* 搜索标题中包含java的帖子
>* 同时，如果标题中包含hadoop或elasticsearch就优先搜索出来
>* 同时，如果一个帖子包含java hadoop，一个帖子包含java elasticsearch，包含hadoop的帖子要比elasticsearch优先搜索出来

## 知识点

* 搜索条件的权重，boost，可以将某个搜索条件的权重加大，此时当匹配这个搜索条件和匹配另一个搜索条件的document
* 知识点计算relevance score时，匹配权重更大的搜索条件的document，relevance score会更高，当然也就会优先被返回回来
* 默认情况下，搜索条件的权重都是一样的，都是1

## 例子

```java
GET /forum/article/_search 
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "title": "blog"
          }
        }
      ],
      "should": [
        {
          "match": {
            "title": {
              "query": "java"
            }
          }
        },
        {
          "match": {
            "title": {
              "query": "hadoop"
            }
          }
        },
        {
          "match": {
            "title": {
              "query": "elasticsearch"
            }
          }
        },
        {
          "match": {
            "title": {
              "query": "spark",
              "boost": 5
            }
          }
        }
      ]
    }
  }
}
```



