# 27_ElasticSearch误拼写时的fuzzy模糊搜索技术

## 一、概述

* fuzzy搜索技术 
* 搜索的时候，可能输入的搜索文本会出现误拼写的情况
* 自动将拼写错误的搜索文本，进行纠正，纠正以后去尝试匹配索引中的数据
* 纠正在一定的范围内如果差别大无法搜索出来

## 二、例子说明

搜索的时候，可能输入的搜索文本会出现误拼写的情况


* fuzzy搜索技术 --> 自动将拼写错误的搜索文本，进行纠正，纠正以后去尝试匹配索引中的数据

初始化数据：

```java
POST /my_index/my_type/_bulk
{ "index": { "_id": 1 }}
{ "text": "Surprise me!"}
{ "index": { "_id": 2 }}
{ "text": "That was surprising."}
{ "index": { "_id": 3 }}
{ "text": "I wasn't surprised."}
```


fuzzy 查询，并设置纠正字数为2
```java
GET /my_index/my_type/_search 
{
  "query": {
    "fuzzy": {
      "text": {
        "value": "surprize",
        "fuzziness": 2
      }
    }
  }
}
```

* surprize --> 拼写错误 --> surprise --> s -> z
* surprize --> surprise -> z -> s，纠正一个字母，就可以匹配上，所以在fuziness指定的2范围内
* surprize --> surprised -> z -> s，末尾加个d，纠正了2次，也可以匹配上，在fuziness指定的2范围内
* surprize --> surprising -> z -> s，去掉e，ing，3次，总共要5次，才可以匹配上，始终纠正不了

fuzzy搜索以后，会自动尝试将你的搜索文本进行纠错，然后去跟文本进行匹配

fuzziness，你的搜索文本最多可以纠正几个字母去跟你的数据进行匹配，默认如果不设置，就是2

```java

GET /my_index/my_type/_search 
{
  "query": {
    "match": {
      "text": {
        "query": "SURPIZE ME",
        "fuzziness": "AUTO",
        "operator": "and"
      }
    }
  }
}
```