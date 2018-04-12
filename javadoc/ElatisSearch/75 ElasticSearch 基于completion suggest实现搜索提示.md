# 75 ElasticSearch 基于completion suggest实现搜索提示

## 概述


suggest，completion suggest，自动完成，搜索推荐，搜索提示 --> 自动完成，auto completion

## auto completion

* 比如说我们在百度，搜索，你现在搜索“大话西游” --> 百度，自动给你提示，“大话西游电影”，“大话西游小说”， “大话西游手游”
* 不用你把所有你想要输入的文本都输入完，搜索引擎会自动提示你可能是你想要搜索的那个文本


## 例子一

```
PUT /news_website
{
  "mappings": {
    "news" : {
      "properties" : {
        "title" : {
          "type": "text",
          "analyzer": "ik_max_word",
          "fields": {
            "suggest" : {
              "type" : "completion",
              "analyzer": "ik_max_word"
            }
          }
        },
        "content": {
          "type": "text",
          "analyzer": "ik_max_word"
        }
      }
    }
  }
}
```

completion，es实现的时候，是非常高性能的，会构建不是倒排索引，也不是正排索引，就是纯的用于进行前缀搜索的一种特殊的数据结构，而且会全部放在内存中，所以auto completion进行的前缀搜索提示，性能是非常高的

### 例子一

大话西游

```
PUT /news_website/news/1
{
  "title": "大话西游电影",
  "content": "大话西游的电影时隔20年即将在2017年4月重映"
}
```

```
PUT /news_website/news/2
{
  "title": "大话西游小说",
  "content": "某知名网络小说作家已经完成了大话西游同名小说的出版"
}
```

```
PUT /news_website/news/3
{
  "title": "大话西游手游",
  "content": "网易游戏近日出品了大话西游经典IP的手游，正在火爆内测中"
}

```


```
GET /news_website/news/_search
{
  "suggest": {
    "my-suggest" : {
      "prefix" : "大话西游",
      "completion" : {
        "field" : "title.suggest"
      }
    }
  }
}
```

```
{
  "took": 6,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "failed": 0
  },
  "hits": {
    "total": 0,
    "max_score": 0,
    "hits": []
  },
  "suggest": {
    "my-suggest": [
      {
        "text": "大话西游",
        "offset": 0,
        "length": 4,
        "options": [
          {
            "text": "大话西游小说",
            "_index": "news_website",
            "_type": "news",
            "_id": "2",
            "_score": 1,
            "_source": {
              "title": "大话西游小说",
              "content": "某知名网络小说作家已经完成了大话西游同名小说的出版"
            }
          },
          {
            "text": "大话西游手游",
            "_index": "news_website",
            "_type": "news",
            "_id": "3",
            "_score": 1,
            "_source": {
              "title": "大话西游手游",
              "content": "网易游戏近日出品了大话西游经典IP的手游，正在火爆内测中"
            }
          },
          {
            "text": "大话西游电影",
            "_index": "news_website",
            "_type": "news",
            "_id": "1",
            "_score": 1,
            "_source": {
              "title": "大话西游电影",
              "content": "大话西游的电影时隔20年即将在2017年4月重映"
            }
          }
        ]
      }
    ]
  }
}
```

```
GET /news_website/news/_search 
{
  "query": {
    "match": {
      "content": "大话西游电影"
    }
  }
}
```

```
{
  "took": 9,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "failed": 0
  },
  "hits": {
    "total": 3,
    "max_score": 1.3495269,
    "hits": [
      {
        "_index": "news_website",
        "_type": "news",
        "_id": "1",
        "_score": 1.3495269,
        "_source": {
          "title": "大话西游电影",
          "content": "大话西游的电影时隔20年即将在2017年4月重映"
        }
      },
      {
        "_index": "news_website",
        "_type": "news",
        "_id": "3",
        "_score": 1.217097,
        "_source": {
          "title": "大话西游手游",
          "content": "网易游戏近日出品了大话西游经典IP的手游，正在火爆内测中"
        }
      },
      {
        "_index": "news_website",
        "_type": "news",
        "_id": "2",
        "_score": 1.1299736,
        "_source": {
          "title": "大话西游小说",
          "content": "某知名网络小说作家已经完成了大话西游同名小说的出版"
        }
      }
    ]
  }
}
```
