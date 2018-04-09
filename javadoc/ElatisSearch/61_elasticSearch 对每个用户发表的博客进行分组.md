# 61_对每个用户发表的博客进行分组


### 1、构造更多测试数据

```
PUT /website/users/3
{
  "name": "虚竹",
  "email": "caoren@sina.com",
  "birthday": "1970-10-24"
}

```


```
PUT /website/blogs/3
{
  "title": "我是虚竹",
  "content": "我是虚竹啊，各位同学们！",
  "userInfo": {
    "userId": 1,
    "userName": "虚竹"
  }
}

```

```
PUT /website/users/2
{
  "name": "超人",
  "email": "caoren@sina.com",
  "birthday": "1980-02-02"
}

```

```
PUT /website/blogs/4
{
  "title": "超人的身世揭秘",
  "content": "大家好，我是超人，所以我的身世是。",
  "userInfo": {
    "userId": 2,
    "userName": "超人"
  }
}
```

### 2、对每个用户发表的博客进行分组

比如说，小鱼儿发表的那些博客，超人发表了哪些博客，虚竹发表了哪些博客

```
GET /website/blogs/_search 
{
  "size": 0, 
  "aggs": {
    "group_by_username": {
      "terms": {
        "field": "userInfo.username.keyword"
      },
      "aggs": {
        "top_blogs": {
          "top_hits": {
            "_source": {
              "include": "title"
            }, 
            "size": 5
          }
        }
      }
    }
  }
}
```

