# 3_ElatisSearch 基于bool组合多个filter条件来搜索数据

## 例子一

1、搜索发帖日期为2017-01-01，或者帖子ID为XHDK-A-1293-#fJ3的帖子，同时要求帖子的发帖日期绝对不为2017-01-02

以上需求类似sql:
```sql
select *
from forum.article
where (post_date='2017-01-01' or article_id='XHDK-A-1293-#fJ3')
and post_date!='2017-01-02'
```

```java
GET /forum/article/_search
{
  "query": {
    "constant_score": {
      "filter": {
        "bool": {
          "should": [
            {"term": { "postDate": "2017-01-01" }},
            {"term": {"articleID": "XHDK-A-1293-#fJ3"}}
          ],
          "must_not": {
            "term": {
              "postDate": "2017-01-02"
            }
          }
        }
      }
    }
  }
}
```

must，should，must_not，filter：必须匹配，可以匹配其中任意一个即可，必须不匹配

## 例子二
2、搜索帖子ID为XHDK-A-1293-#fJ3，或者是帖子ID为JODL-X-1937-#pV7而且发帖日期为2017-01-01的帖子

以上需求类似sql:

```sql
select *
from forum.article
where article_id='XHDK-A-1293-#fJ3'
or (article_id='JODL-X-1937-#pV7' and post_date='2017-01-01')
```

```java
GET /forum/article/_search 
{
  "query": {
    "constant_score": {
      "filter": {
        "bool": {
          "should": [
            {
              "term": {
                "articleID": "XHDK-A-1293-#fJ3"
              }
            },
            {
              "bool": {
                "must": [
                  {
                    "term":{
                      "articleID": "JODL-X-1937-#pV7"
                    }
                  },
                  {
                    "term": {
                      "postDate": "2017-01-01"
                    }
                  }
                ]
              }
            }
          ]
        }
      }
    }
  }
}
```


## 知识点
* 1、bool：must，must_not，should，组合多个过滤条件
* 2、bool可以嵌套
* 3、相当于SQL中的多个and条件：当你把搜索语法学好了以后，基本可以实现部分常用的sql语法对应的功能


