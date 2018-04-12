# 基础12 ElasticSearch document的全量替换、强制创建


## 概述

* 1、document的全量替换
* 2、document的强制创建
* 3、document的删除


## 1、document的全量替换

* 1）语法与创建文档是一样的，如果document id不存在，那么就是创建；如果document id已经存在，那么就是全量替换操作，替换document的json串内容
* 2）document是不可变的，如果要修改document的内容，第一种方式就是全量替换，直接对document重新建立索引，替换里面所有的内容
* 3）es会将老的document标记为deleted，然后新增我们给定的一个document，当我们创建越来越多的document的时候，es会在适当的时机在后台自动删除标记为deleted的document

```
PUT /ecommerce/product/1
{
    "name" : "gaolujie yagao",
    "desc" :  "gaoxiao meibai",
    "price" :  30,
    "producer" :      "gaolujie producer",
    "tags": [ "meibai", "fangzhu" ]
}

```

## 2、document的强制创建

* 1）创建文档与全量替换的语法是一样的，有时我们只是想新建文档，不想替换文档，如果强制进行创建呢？

```
PUT /index/type/id?op_type=create，PUT /index/type/id/_create
```

## 3、document的删除

* 1）DELETE /index/type/id
* 2）不会理解物理删除，只会将其标记为deleted，当数据越来越多的时候，在后台自动删除


