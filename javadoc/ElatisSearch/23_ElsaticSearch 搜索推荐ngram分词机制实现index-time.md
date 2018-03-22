# 23_ElsaticSearch 搜索推荐ngram分词机制实现index-time

## 一、概述
* 创建索引的时候就对每个单词进行切分，方便做搜索推荐提示。提高速度
* 使用edge ngram将每个单词都进行进一步的分词切分，用切分后的ngram来实现前缀搜索推荐功能
* 搜索的时候，不用再根据一个前缀，然后扫描整个倒排索引了; 简单的拿前缀去倒排索引中匹配即可，如果匹配上了，那么就好了; 

## 二、ngram和index-time搜索推荐原理

### 1.什么是ngram，例子使用单词quick。

* quick，5种长度下的ngram。将quick做不同长度的切分如：
```java
ngram length=1，q u i c k
ngram length=2，qu ui ic ck
ngram length=3，qui uic ick
ngram length=4，quic uick
ngram length=5，quick
```

### 2.什么是edge ngram

quick，anchor首字母后进行ngram（对整个单词进行切分）

```java
q
qu
qui
quic
quick
```

使用edge ngram将每个单词都进行进一步的分词切分，用切分后的ngram来实现前缀搜索推荐功能

### 3、min ngram、max ngram

* 指定切分个数

min ngram = 1
max ngram = 3


### 三、例子

```java
PUT /my_index
{
    "settings": {
        "analysis": {
            "filter": {
                "autocomplete_filter": { 
                    "type":     "edge_ngram",
                    "min_gram": 1,
                    "max_gram": 20
                }
            },
            "analyzer": {
                "autocomplete": {
                    "type":      "custom",
                    "tokenizer": "standard",
                    "filter": [
                        "lowercase",
                        "autocomplete_filter" 
                    ]
                }
            }
        }
    }
}
```

```java
GET /my_index/_analyze
{
  "analyzer": "autocomplete",
  "text": "quick brown"
}
```

```java
PUT /my_index/_mapping/my_type
{
  "properties": {
      "title": {
          "type":     "string",
          "analyzer": "autocomplete",
          "search_analyzer": "standard"
      }
  }
}
```

```java
GET /my_index/my_type/_search 
{
  "query": {
    "match_phrase": {
      "title": "hello w"
    }
  }
}
```

* 如果用match，只有hello的也会出来，全文检索，只是分数比较低
* 推荐使用match_phrase，要求每个term都有，而且position刚好靠着1位，符合我们的期望的





