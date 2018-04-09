# 59_通过应用层join实现用户与博客的关联


## 一、概述


### 1、构造用户与博客数据


在构造数据模型的时候，还是将有关联关系的数据，然后分割为不同的实体，类似于关系型数据库中的模型


案例背景：博客网站， 我们会模拟各种用户发表各种博客，然后针对用户和博客之间的关系进行数据建模，同时针对建模好的数据执行各种搜索/聚合的操作


```
PUT /website/users/1 
{
  "name":     "乔峰",
  "email":    "xiaoyuer@sina.com",
  "birthday":      "1980-01-01"
}

PUT /website/blogs/1
{
  "title":    "我的第一篇博客",
  "content":     "这是我的第一篇博客，开通啦！！！"
  "userId":     1 
}

```


一个用户对应多个博客，一对多的关系，做了建模


建模方式，分割实体，类似三范式的方式，用主外键关联关系，将多个实体关联起来


### 2、搜索乔峰发表的所有博客

```
GET /website/users/_search 
{
  "query": {
    "term": {
      "name.keyword": {
        "value": "乔峰"
      }
    }
  }
}
```


```
{
  "took": 91,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "failed": 0
  },
  "hits": {
    "total": 1,
    "max_score": 0.2876821,
    "hits": [
      {
        "_index": "website",
        "_type": "users",
        "_id": "1",
        "_score": 0.2876821,
        "_source": {
          "name": "乔峰",
          "email": "xiaoyuer@sina.com",
          "birthday": "1980-01-01"
        }
      }
    ]
  }
}
```


比如这里搜索的是，1万个用户的博客，可能第一次搜索，会得到1万个userId


```
GET /website/blogs/_search 
{
  "query": {
    "constant_score": {
      "filter": {
        "terms": {
          "userId": [
            1
          ]
        }
      }
    }
  }
}
```


第二次搜索的时候，要放入terms中1万个userId，才能进行搜索，这个时候性能比较差了


```
{
  "took": 4,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "failed": 0
  },
  "hits": {
    "total": 1,
    "max_score": 1,
    "hits": [
      {
        "_index": "website",
        "_type": "blogs",
        "_id": "1",
        "_score": 1,
        "_source": {
          "title": "乔峰的第一篇博客",
          "content": "大家好，我是乔峰，这是我写的第一篇博客！",
          "userId": 1
        }
      }
    ]
  }
}
```


上面的操作，就属于应用层的join，在应用层先查出一份数据，然后再查出一份数据，进行关联

### 3、优点和缺点

* 优点：数据不冗余，维护方便

* 缺点：应用层join，如果关联数据过多，导致查询过大，性能很差

