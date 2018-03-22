# 18_ElasticSearch 基于slop参数实现近似匹配


## 概述

slop的含义

>* query string，搜索文本，中的几个term，要经过几次移动才能与一个document匹配，这个移动的次数，就是slop

实际举例

一个query string经过几次移动之后可以匹配到一个document，然后设置slop

```java
hello world, java is very good, spark is also very good.
```
* 以上doc 使用 java spark 搜索，方式 match phrase，无法搜索到 因为 java和 spark 中间还有间隔包含其他

## 例子一 slop 查询

* slop的phrase match，就是proximity match，近似匹配
* 如果我们指定了slop，那么就允许java spark进行移动，来尝试与doc进行匹配
* ava spark，可以有一定的距离，但是靠的越近，越先搜索出来，proximity match

```java
GET /forum/article/_search
{
    "query": {
        "match_phrase": {
            "title": {
                "query": "java spark",
                "slop":  1
            }
        }
    }
}

```

原理解析：移动规则

* 将spark 往前移动了3此匹配上doc
* 这里的slop，就是3，因为java spark这个短语，spark移动了3次，就可以跟一个doc匹配上了
* slop的含义，不仅仅是说一个query string terms移动几次，跟一个doc匹配上。一个query string terms，最多可以移动几次去尝试跟一个doc匹配上

```java

java		is		very		good		spark		is

java		spark
java		-->		spark
java				-->			spark
java							-->			spark
```

* slop 查询 就可以把刚才那个doc匹配上，那个doc会作为结果返回
* 但是如果slop设置的是2，那么java spark，spark最多只能移动2次，此时跟doc是匹配不上的，那个doc是不会作为结果返回的

```java
GET /forum/article/_search
{
    "query": {
        "match_phrase": {
            "title": {
                "query": "java spark",
                "slop":  3
            }
        }
    }
}
```

## 例子二


```java
spark		is				best		big			data
```

```java
data		spark
-->			data/spark
spark		<--data
spark		-->				data
spark						-->			data
spark									-->			data
```

* 移动了5次才搜索到

```java

GET /forum/article/_search
{
  "query": {
    "match_phrase": {
      "content": {
        "query": "data spark",
        "slop": 5
      }
    }
  }
}

```


## 例子三

slop搜索下，关键词离的越近，relevance score就会越高


```java
GET /forum/article/_search
{
  "query": {
    "match_phrase": {
      "content": {
        "query": "java best",
        "slop": 15
      }
    }
  }
}
```

返回结果:

* 1、java spark，可以有一定的距离，但是靠的越近分数越高，越先搜索出来，proximity match

```java
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
    "max_score": 0.65380025,
    "hits": [
      {
        "_index": "forum",
        "_type": "article",
        "_id": "2",
        "_score": 0.65380025,
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
          "new_author_first_name": "Smith"
        }
      },
      {
        "_index": "forum",
        "_type": "article",
        "_id": "5",
        "_score": 0.07111243,
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
          "new_author_first_name": "Tonny"
        }
      }
    ]
  }
}
```


