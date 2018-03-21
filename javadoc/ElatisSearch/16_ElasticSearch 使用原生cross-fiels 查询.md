# 16_ElasticSearch 使用原生cross-fields 查询

# 概述

## 例子

```java
GET /forum/article/_search
{
  "query": {
    "multi_match": {
      "query": "Peter Smith",
      "type": "cross_fields", 
      "operator": "and",
      "fields": ["author_first_name", "author_last_name"]
    }
  }
}

```

## 使用most_fields 实现cross-fields存在的问题：

* 只是找到尽可能多的field匹配的doc，而不是某个field完全匹配的doc
* most_fields，没办法用minimum_should_match去掉长尾数据，就是匹配的特别少的结果
* TF/IDF算法，比如Peter Smith和Smith Williams，搜索Peter Smith的时候，由于first_name中很少有Smith的，所以query在所有document中的频率很低，得到的分数很高，可能Smith Williams反而会排在Peter Smith前面

## 使用原生cross-fields 查询解决了以上问题:

问题1：只是找到尽可能多的field匹配的doc，而不是某个field完全匹配的doc 

> 解决，要求每个term都必须在任何一个field中出现Peter，Smith

* 要求Peter必须在author_first_name或author_last_name中出现
* 要求Smith必须在author_first_name或author_last_name中出现

* Peter Smith可能是横跨在多个field中的，所以必须要求每个term都在某个field中出现，组合起来才能组成我们想要的标识，完整的人名
* 原来most_fiels，可能像Smith Williams也可能会出现，因为most_fields要求只是任何一个field匹配了就可以，匹配的field越多，分数越高


问题2：most_fields，没办法用minimum_should_match去掉长尾数据，就是匹配的特别少的结果 

> 解决，既然每个term都要求出现，长尾肯定被去除掉了

* java hadoop spark --> 这3个term都必须在任何一个field出现了
* 比如有的document，只有一个field中包含一个java，那就被干掉了，作为长尾就没了

问题3：TF/IDF算法，比如Peter Smith和Smith Williams，搜索Peter Smith的时候，由于first_name中很少有Smith的，所以query在所有document中的频率很低，得到的分数很高，可能Smith Williams反而会排在Peter Smith前面 

> 计算IDF的时候，将每个query在每个field中的IDF都取出来，取最小值，就不会出现极端情况下的极大值了

说明：

```xml
Peter Smith
1、 Peter
2、 Smith
```

* Smith，在author_first_name这个field中，在所有doc的这个Field中，出现的频率很低，导致IDF分数很高；
* Smith在所有doc的author_last_name field中的频率算出一个IDF分数，因为一般来说last_name中的Smith频率都较高，所以IDF分数是正常的，不会太高；
* 然后对于Smith来说，会取两个IDF分数中，较小的那个分数。就不会出现IDF分过高的情况。

