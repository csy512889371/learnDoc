# 基础10 ElasticSearch document id的手动指定与自动生成


## 概述


* 1、手动指定document id
* 2、自动生成document id


## 1、手动指定document id

1、根据应用情况来说，是否满足手动指定document id的前提：

一般来说，是从某些其他的系统中，导入一些数据到es时，会采取这种方式，就是使用系统中已有数据的唯一标识，作为es中document的id。举个例子，比如说，我们现在在开发一个电商网站，做搜索功能，或者是OA系统，做员工检索功能。这个时候，数据首先会在网站系统或者IT系统内部的数据库中，会先有一份，此时就肯定会有一个数据库的primary key（自增长，UUID，或者是业务编号）。如果将数据导入到es中，此时就比较适合采用数据在数据库中已有的primary key。

如果说，我们是在做一个系统，这个系统主要的数据存储就是es一种，也就是说，数据产生出来以后，可能就没有id，直接就放es一个存储，那么这个时候，可能就不太适合说手动指定document id的形式了，因为你也不知道id应该是什么，此时可以采取下面要讲解的让es自动生成id的方式。

2、put /index/type/id

```
PUT /test_index/test_type/2
{
  "test_content": "my test"
}

```

## 2、自动生成document id

1、post /index/type

```
POST /test_index/test_type
{
  "test_content": "my test"
}
```

```
{
  "_index": "test_index",
  "_type": "test_type",
  "_id": "AVp4RN0bhjxldOOnBxaE",
  "_version": 1,
  "result": "created",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  },
  "created": true
}
```

2、自动生成的id，长度为20个字符，URL安全，base64编码，GUID，分布式系统并行生成时不可能会发生冲突


