# 11_ElastisSearch 基于tie_breaker参数优化dis_max搜索效果

## 问题

* 有些场景不是太好复现的，因为是这样，你需要尝试去构造不同的文本，然后去构造一些搜索出来，去达到你要的一个效果
* dis_max，只是取分数最高的那个query的分数而已。

> 可能在实际场景中出现的一个情况是这样的：

* 1、某个帖子，doc1，title中包含java（1），content不包含java beginner任何一个关键词 
* 2、某个帖子，doc2，content中包含beginner（1），title中不包含任何一个关键词
* 3、某个帖子，doc3，title中包含java（1），content中包含beginner（1）
* 4、以上3个doc的最高score都是1所有最终出来的排序不一定是想要的结果
* 5、最终搜索，可能出来的结果是，doc1和doc2排在doc3的前面，而不是我们期望的doc3排在最前面

原因：

* dis_max只取某一个query最大的分数，完全不考虑其他query的分数


## 例子

* 搜索title或content中包含java beginner的帖子

```java
GET /forum/article/_search
{
    "query": {
        "dis_max": {
            "queries": [
                { "match": { "title": "java beginner" }},
                { "match": { "body":  "java beginner" }}
            ]
        }
    }
}
```

## tie_breaker 优化 dis_max
使用tie_breaker将其他query的分数也考虑进去

* tie_breaker参数的意义，在于说，将其他query的分数，乘以tie_breaker，然后综合与最高分数的那个query的分数，综合在一起进行计算
* 除了取最高分以外，还会考虑其他的query的分数
* tie_breaker的值，在0~1之间，是个小数，就ok

```java
GET /forum/article/_search
{
    "query": {
        "dis_max": {
            "queries": [
                { "match": { "title": "java beginner" }},
                { "match": { "body":  "java beginner" }}
            ],
            "tie_breaker": 0.3
        }
    }
}
```



