# 66_elasticSearch 基于nested object实现博客与评论嵌套关系


## 概述

### 1、做一个实验，引出来为什么需要nested object

冗余数据方式的来建模，其实用的就是object类型，我们这里又要引入一种新的object类型，nested object类型

博客，评论，做的这种数据模型

```
PUT /website/blogs/6
{
  "title": "花无缺发表的一篇帖子",
  "content":  "我是花无缺，大家要不要考虑一下投资房产和买股票的事情啊。。。",
  "tags":  [ "投资", "理财" ],
  "comments": [ 
    {
      "name":    "小鱼儿",
      "comment": "什么股票啊？推荐一下呗",
      "age":     28,
      "stars":   4,
      "date":    "2016-09-01"
    },
    {
      "name":    "黄药师",
      "comment": "我喜欢投资房产，风，险大收益也大",
      "age":     31,
      "stars":   5,
      "date":    "2016-10-22"
    }
  ]
}
```

被年龄是28岁的黄药师评论过的博客，搜索

```
GET /website/blogs/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "comments.name": "黄药师" }},
        { "match": { "comments.age":  28      }} 
      ]
    }
  }
}
```

```
{
  "took": 102,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "failed": 0
  },
  "hits": {
    "total": 1,
    "max_score": 1.8022683,
    "hits": [
      {
        "_index": "website",
        "_type": "blogs",
        "_id": "6",
        "_score": 1.8022683,
        "_source": {
          "title": "花无缺发表的一篇帖子",
          "content": "我是花无缺，大家要不要考虑一下投资房产和买股票的事情啊。。。",
          "tags": [
            "投资",
            "理财"
          ],
          "comments": [
            {
              "name": "小鱼儿",
              "comment": "什么股票啊？推荐一下呗",
              "age": 28,
              "stars": 4,
              "date": "2016-09-01"
            },
            {
              "name": "黄药师",
              "comment": "我喜欢投资房产，风，险大收益也大",
              "age": 31,
              "stars": 5,
              "date": "2016-10-22"
            }
          ]
        }
      }
    ]
  }
}

```
结果是。。。好像不太对啊？？？

object类型数据结构的底层存储。。。

```
{
  "title":            [ "花无缺", "发表", "一篇", "帖子" ],
  "content":             [ "我", "是", "花无缺", "大家", "要不要", "考虑", "一下", "投资", "房产", "买", "股票", "事情" ],
  "tags":             [ "投资", "理财" ],
  "comments.name":    [ "小鱼儿", "黄药师" ],
  "comments.comment": [ "什么", "股票", "推荐", "我", "喜欢", "投资", "房产", "风险", "收益", "大" ],
  "comments.age":     [ 28, 31 ],
  "comments.stars":   [ 4, 5 ],
  "comments.date":    [ 2016-09-01, 2016-10-22 ]
}
```

object类型底层数据结构，会将一个json数组中的数据，进行扁平化

所以，直接命中了这个document，name=黄药师，age=28，正好符合

### 2、引入nested object类型，来解决object类型底层数据结构导致的问题

修改mapping，将comments的类型从object设置为nested

```
PUT /website
{
  "mappings": {
    "blogs": {
      "properties": {
        "comments": {
          "type": "nested", 
          "properties": {
            "name":    { "type": "string"  },
            "comment": { "type": "string"  },
            "age":     { "type": "short"   },
            "stars":   { "type": "short"   },
            "date":    { "type": "date"    }
          }
        }
      }
    }
  }
}
```

```
{ 
  "comments.name":    [ "小鱼儿" ],
  "comments.comment": [ "什么", "股票", "推荐" ],
  "comments.age":     [ 28 ],
  "comments.stars":   [ 4 ],
  "comments.date":    [ 2014-09-01 ]
}
{ 
  "comments.name":    [ "黄药师" ],
  "comments.comment": [ "我", "喜欢", "投资", "房产", "风险", "收益", "大" ],
  "comments.age":     [ 31 ],
  "comments.stars":   [ 5 ],
  "comments.date":    [ 2014-10-22 ]
}
{ 
  "title":            [ "花无缺", "发表", "一篇", "帖子" ],
  "body":             [ "我", "是", "花无缺", "大家", "要不要", "考虑", "一下", "投资", "房产", "买", "股票", "事情" ],
  "tags":             [ "投资", "理财" ]
}

```

再次搜索，成功了。

```
GET /website/blogs/_search 
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "title": "花无缺"
          }
        },
        {
          "nested": {
            "path": "comments",
            "query": {
              "bool": {
                "must": [
                  {
                    "match": {
                      "comments.name": "黄药师"
                    }
                  },
                  {
                    "match": {
                      "comments.age": 28
                    }
                  }
                ]
              }
            }
          }
        }
      ]
    }
  }
}
```

score_mode：max，min，avg，none，默认是avg

如果搜索命中了多个nested document，如何讲个多个nested document的分数合并为一个分数
