# 19_ElasticSearch 使用match和近似匹配实现召回率与精准度的平衡


## 一、概要

### 1.召回率
比如你搜索一个java spark，总共有100个doc，能返回多少个doc作为结果，就是召回率，recall

### 2.精准度
比如你搜索一个java spark，能不能尽可能让包含java spark，或者是java和spark离的很近的doc，排在最前面，precision

### 3.需求

* 但是有时可能我们希望的是匹配到几个term中的部分，就可以作为结果出来，这样可以提高召回率。
* 同时我们也希望用上match_phrase根据距离提升分数的功能，让几个term距离越近分数就越高，优先返回
* 就是优先满足召回率，意思，java spark，包含java的也返回，包含spark的也返回，包含java和spark的也返回；
* 同时兼顾精准度，就是包含java和spark，同时java和spark离的越近的doc排在最前面

### 4.问题分析

* 直接用match_phrase短语搜索，会导致必须所有term都在doc field中出现，而且距离在slop限定范围内，才能匹配上
* match phrase，proximity match，要求doc必须包含所有的term，才能作为结果返回；如果某一个doc可能就是有某个term没有包含，那么就无法作为结果返回

```java
java spark --> hello world java --> 就不能返回了
java spark --> hello world, java spark --> 才可以返回
```

* 近似匹配的时候，召回率比较低，精准度太高了


## 二、平衡召回率与精准度

此时可以用bool组合match query和match_phrase query一起，来实现上述效果

### 1、查询语法说明

```java
GET /forum/article/_search
{
  "query": {
    "bool": {
      "must": {
        "match": { 
          "title": {
            "query":                "java spark" --> java或spark或java spark，java和spark靠前，但是没法区分java和spark的距离，也许java和spark靠的很近，但是没法排在最前面
          }
        }
      },
      "should": {
        "match_phrase": { --> 在slop以内，如果java spark能匹配上一个doc，那么就会对doc贡献自己的relevance score，如果java和spark靠的越近，那么就分数越高
          "title": {
            "query": "java spark",
            "slop":  50
          }
        }
      }
    }
  }
}
```

### 例子一

先使用 match查询

```java
GET /forum/article/_search 
{
  "query": {
    "bool": {
      "must": [
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

match查询结果

```java

{
  "took": 5,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "failed": 0
  },
  "hits": {
    "total": 2,
    "max_score": 0.68640786,
    "hits": [
      {
        "_index": "forum",
        "_type": "article",
        "_id": "2",
        "_score": 0.68640786,
        "_source": {
          "articleID": "KDKE-B-9947-#kL5",
          "userID": 1,
          "hidden": false,
          "postDate": "2017-01-02",
          "tag": [
            "java"
          ],
          "tag_cnt": 1,
          "view_cnt": 50,
          "title": "this is java blog",
          "content": "i think java is the best programming language",
          "sub_title": "learned a lot of course",
          "author_first_name": "Smith",
          "author_last_name": "Williams",
          "new_author_last_name": "Williams",
          "new_author_first_name": "Smith",
          "followers": [
            "Tom",
            "Jack"
          ]
        }
      },
      {
        "_index": "forum",
        "_type": "article",
        "_id": "5",
        "_score": 0.68324494,
        "_source": {
          "articleID": "DHJK-B-1395-#Ky5",
          "userID": 3,
          "hidden": false,
          "postDate": "2017-03-01",
          "tag": [
            "elasticsearch"
          ],
          "tag_cnt": 1,
          "view_cnt": 10,
          "title": "this is spark blog",
          "content": "spark is best big data solution based on scala ,an programming language similar to java spark",
          "sub_title": "haha, hello world",
          "author_first_name": "Tonny",
          "author_last_name": "Peter Smith",
          "new_author_last_name": "Peter Smith",
          "new_author_first_name": "Tonny",
          "followers": [
            "Jack",
            "Robbin Li"
          ]
        }
      }
    ]
  }
}
```

### 例子二 使用 match和 match_phrase 组合查询


```java
GET /forum/article/_search 
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "content": "java spark"
          }
        }
      ],
      "should": [
        {
          "match_phrase": {
            "content": {
              "query": "java spark",
              "slop": 50
            }
          }
        }
      ]
    }
  }
}
```


match和 match_phrase 组合查询结果：


```java

{
  "took": 5,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "failed": 0
  },
  "hits": {
    "total": 2,
    "max_score": 1.258609,
    "hits": [
      {
        "_index": "forum",
        "_type": "article",
        "_id": "5",
        "_score": 1.258609,
        "_source": {
          "articleID": "DHJK-B-1395-#Ky5",
          "userID": 3,
          "hidden": false,
          "postDate": "2017-03-01",
          "tag": [
            "elasticsearch"
          ],
          "tag_cnt": 1,
          "view_cnt": 10,
          "title": "this is spark blog",
          "content": "spark is best big data solution based on scala ,an programming language similar to java spark",
          "sub_title": "haha, hello world",
          "author_first_name": "Tonny",
          "author_last_name": "Peter Smith",
          "new_author_last_name": "Peter Smith",
          "new_author_first_name": "Tonny",
          "followers": [
            "Jack",
            "Robbin Li"
          ]
        }
      },
      {
        "_index": "forum",
        "_type": "article",
        "_id": "2",
        "_score": 0.68640786,
        "_source": {
          "articleID": "KDKE-B-9947-#kL5",
          "userID": 1,
          "hidden": false,
          "postDate": "2017-01-02",
          "tag": [
            "java"
          ],
          "tag_cnt": 1,
          "view_cnt": 50,
          "title": "this is java blog",
          "content": "i think java is the best programming language",
          "sub_title": "learned a lot of course",
          "author_first_name": "Smith",
          "author_last_name": "Williams",
          "new_author_last_name": "Williams",
          "new_author_first_name": "Smith",
          "followers": [
            "Tom",
            "Jack"
          ]
        }
      }
    ]
  }
}
```

