# 22_ElasticSearch 搜索推荐match_phrase_prefix实现search-time

## 一、概述

### 1.名称解释

搜索推荐，search as you type，搜索提示。

* 如百度搜索输入 elas 会提示 --> elasticsearch  提示 --> elasticsearch权威指南
* 如 输入 hello w 会有一下提示

```java
hello world
hello we
hello win
hello wind
hello dog
hello cat
```
### 2.说明

* 尽量不要用，因为，最后一个前缀始终要去扫描大量的索引，性能可能会很差
*  max_expansions：指定prefix最多匹配多少个term，超过这个数量就不继续匹配了

## 二、语法

```java
GET /my_index/my_type/_search 
{
  "query": {
    "match_phrase_prefix": {
      "title": "hello d"
    }
  }
}
```

## 三、原理

原理跟match_phrase类似，唯一的区别，就是把最后一个term作为前缀去搜索。一下用输入  hello w 进行讲解

* 1、hello就是去进行match，搜索对应的doc
* 2、w，会作为前缀，去扫描整个倒排索引，找到所有w开头的doc
* 3、然后找到所有doc中，即包含hello，又包含w开头的字符的doc
* 4、根据你的slop去计算，看在slop范围内，能不能让hello w，正好跟doc中的hello和w开头的单词的position相匹配

>* 也可以指定slop，但是只有最后一个term会作为前缀
>* max_expansions：指定prefix最多匹配多少个term，超过这个数量就不继续匹配了，限定性能
>* 默认情况下，前缀要扫描所有的倒排索引中的term，去查找w打头的单词，但是这样性能太差。可以用max_expansions限定，w前缀最多匹配多少个term，就不再继续搜索倒排索引了。


