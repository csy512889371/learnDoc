# 7_ElatisSearch term+bool实现的multiword搜索原理

## 概述

* es 底层会将 match query 转成bool term 查询：match query --> bool + term。

## 例子一
普通match如何转换为term+should

```java
{
    "match": { "title": "java elasticsearch"}
}
```

* 使用诸如上面的match query进行多值搜索的时候，es会在底层自动将这个match query转换为bool的语法
* bool should，指定多个搜索词，同时使用term query

```java
{
  "bool": {
    "should": [
      { "term": { "title": "java" }},
      { "term": { "title": "elasticsearch"   }}
    ]
  }
}
```

## 例子二

and match如何转换为term+must

```java
{
    "match": {
        "title": {
            "query":    "java elasticsearch",
            "operator": "and"
        }
    }
}
```

转化后
```java
{
  "bool": {
    "must": [
      { "term": { "title": "java" }},
      { "term": { "title": "elasticsearch"   }}
    ]
  }
}
```
## 例子三

minimum_should_match如何转换
```java

{
    "match": {
        "title": {
            "query":                "java elasticsearch hadoop spark",
            "minimum_should_match": "75%"
        }
    }
}
```

转化后

```java
{
  "bool": {
    "should": [
      { "term": { "title": "java" }},
      { "term": { "title": "elasticsearch"   }},
      { "term": { "title": "hadoop" }},
      { "term": { "title": "spark" }}
    ],
    "minimum_should_match": 3 
  }
}
```


