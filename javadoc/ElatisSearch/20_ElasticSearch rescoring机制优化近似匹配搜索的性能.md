# 20_ElasticSearch rescoring机制优化近似匹配搜索的性能

## 一、概述

* rescore：重打分
* 对match 查询的结果中的前几条重新使用proximity match 打分。原因是 match效率是proximity match的50倍，而proximity match 可以提高搜索的精度

## 二、比较 match和phrase match(proximity match)区别

### 1、match

只要简单的匹配到了一个term，就可以理解将term对应的doc作为结果返回，扫描倒排索引，扫描到了就ok

### 2、phrase match
首先扫描到所有term的doc list; 找到包含所有term的doc list; 然后对每个doc都计算每个term的position，是否符合指定的范围; slop，需要进行复杂的运算，来判断能否通过slop移动，匹配一个doc

### 3、结论
* match query的性能比phrase match和proximity match（有slop）要高很多。因为后两者都要计算position的距离。
* match query比phrase match的性能要高10倍，比proximity match的性能要高20倍。

但是别太担心，因为es的性能一般都在毫秒级别，match query一般就在几毫秒，或者几十毫秒，而phrase match和proximity match的性能在几十毫秒到几百毫秒之间，所以也是可以接受的。

## 三、优化proximity match的性能

* 优化proximity match的性能，一般就是减少要进行proximity match搜索的document数量。
* 主要思路就是，用match query先过滤出需要的数据
* 然后再用proximity match来根据term距离提高doc的分数
* 同时proximity match只针对每个shard的分数排名前n个doc起作用，来重新调整它们的分数，这个过程称之为rescoring，重计分。
* 因为一般用户会分页查询，只会看到前几页的数据，所以不需要对所有结果进行proximity match操作。

使用match + proximity match同时实现召回率和精准度

## 四、例子
* 默认情况下，match也许匹配了1000个doc，proximity match全都需要对每个doc进行一遍运算，判断能否slop移动匹配上，然后去贡献自己的分数
* 但是很多情况下，match出来也许1000个doc，其实用户大部分情况下是分页查询的，所以可能最多只会看前几页
* 比如一页是10条，最多也许就看5页，就是50条proximity match只要对前50个doc进行slop移动去匹配，去贡献自己的分数即可，不需要对全部1000个doc都去进行计算和贡献分数


rescore：重打分：
* match：1000个doc，其实这时候每个doc都有一个分数了; proximity match，前50个doc，进行rescore，重打分，即可; 让前50个doc，term举例越近的，排在越前面

```java

GET /forum/article/_search 
{
  "query": {
    "match": {
      "content": "java spark"
    }
  },
  "rescore": {
    "window_size": 50,
    "query": {
      "rescore_query": {
        "match_phrase": {
          "content": {
            "query": "java spark",
            "slop": 50
          }
        }
      }
    }
  }
}
```

