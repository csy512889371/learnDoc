# 6_ElatisSearch 控制全文检索结果的精准度

## 概述
* 1、全文检索的时候，进行多个值的检索，有两种做法，match query；should
* 2、控制搜索结果精准度：and operator，minimum_should_match

## 例子
### 1、为帖子数据增加标题（title）字段

```java
POST /forum/article/_bulk
{ "update": { "_id": "1"} }
{ "doc" : {"title" : "this is java and elasticsearch blog"} }
{ "update": { "_id": "2"} }
{ "doc" : {"title" : "this is java blog"} }
{ "update": { "_id": "3"} }
{ "doc" : {"title" : "this is elasticsearch blog"} }
{ "update": { "_id": "4"} }
{ "doc" : {"title" : "this is java, elasticsearch, hadoop blog"} }
{ "update": { "_id": "5"} }
{ "doc" : {"title" : "this is spark blog"} }
```

### 2、搜索标题中包含java或elasticsearch的blog

* 这个，就跟之前的那个term query，不一样了。不是搜索exact value，是进行full text全文检索。
* match query，是负责进行全文检索的。当然，如果要检索的field，是not_analyzed类型的，那么match query也相当于term query。

GET /forum/article/_search
{
    "query": {
        "match": {
            "title": "java elasticsearch"
        }
    }
}

### 3、搜索标题中包含java和elasticsearch的blog

* 搜索中的文章必须 同时包含 java和elasticsearch
* 使用and关键字，如果你是希望所有的搜索关键字都要匹配的，那么就用and，可以实现单纯match query无法实现的效果

```java
GET /forum/article/_search
{
    "query": {
        "match": {
            "title": {
				"query": "java elasticsearch",
				"operator": "and"
			}
        }
    }
}
```

### 4、搜索包含java，elasticsearch，spark，hadoop，4个关键字中，至少3个的blog

* 指定一些关键字中，必须至少匹配其中的多少个关键字，才能作为结果返回

```java
GET /forum/article/_search
{
  "query": {
    "match": {
      "title": {
        "query": "java elasticsearch spark hadoop",
        "minimum_should_match": "75%"
      }
    }
  }
}
```

### 5、用bool组合多个搜索条件，来搜索title

```java
GET /forum/article/_search
{
  "query": {
    "bool": {
      "must":     { "match": { "title": "java" }},
      "must_not": { "match": { "title": "spark"  }},
      "should": [
                  { "match": { "title": "hadoop" }},
                  { "match": { "title": "elasticsearch"   }}
      ]
    }
  }
}
```

### 6、bool组合多个搜索条件，如何计算relevance score

must和should搜索对应的分数，加起来，除以must和should的总数

* 排名第一：java，同时包含should中所有的关键字，hadoop，elasticsearch
* 排名第二：java，同时包含should中的elasticsearch
* 排名第三：java，不包含should中的任何关键字

should是可以影响相关度分数的

* must是确保说，谁必须有这个关键字，同时会根据这个must的条件去计算出document对这个搜索条件的relevance score
* 在满足must的基础之上，should中的条件，不匹配也可以，但是如果匹配的更多，那么document的relevance score就会更高

搜索的结果：

```java
{
  "took": 6,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "failed": 0
  },
  "hits": {
    "total": 3,
    "max_score": 1.3375794,
    "hits": [
      {
        "_index": "forum",
        "_type": "article",
        "_id": "4",
        "_score": 1.3375794,
        "_source": {
          "articleID": "QQPX-R-3956-#aD8",
          "userID": 2,
          "hidden": true,
          "postDate": "2017-01-02",
          "tag": [
            "java",
            "elasticsearch"
          ],
          "tag_cnt": 2,
          "view_cnt": 80,
          "title": "this is java, elasticsearch, hadoop blog"
        }
      },
      {
        "_index": "forum",
        "_type": "article",
        "_id": "1",
        "_score": 0.53484553,
        "_source": {
          "articleID": "XHDK-A-1293-#fJ3",
          "userID": 1,
          "hidden": false,
          "postDate": "2017-01-01",
          "tag": [
            "java",
            "hadoop"
          ],
          "tag_cnt": 2,
          "view_cnt": 30,
          "title": "this is java and elasticsearch blog"
        }
      },
      {
        "_index": "forum",
        "_type": "article",
        "_id": "2",
        "_score": 0.19856805,
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
          "title": "this is java blog"
        }
      }
    ]
  }
}
```


### 7、搜索java，hadoop，spark，elasticsearch，至少包含其中3个关键字

* 默认情况下，should是可以不匹配任何一个的，比如上面的搜索中，this is java blog，就不匹配任何一个should条件
* 但是有个例外的情况，如果没有must的话，那么should中必须至少匹配一个才可以
* 比如下面的搜索，should中有4个条件，默认情况下，只要满足其中一个条件，就可以匹配作为结果返回
* 但是可以精准控制，should的4个条件中，至少匹配几个才能作为结果返回

```java
GET /forum/article/_search
{
  "query": {
    "bool": {
      "should": [
        { "match": { "title": "java" }},
        { "match": { "title": "elasticsearch"   }},
        { "match": { "title": "hadoop"   }},
	{ "match": { "title": "spark"   }}
      ],
      "minimum_should_match": 3 
    }
  }
}
```



