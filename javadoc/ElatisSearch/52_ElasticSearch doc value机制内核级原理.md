# 52_ElasticSearch doc value机制内核级原理

## 一、概述
* doc value原理（正排索引）
* index-time生成
* 核心原理
* 性能问题

## 二、doc value原理（正排索引）

### 1、index-time生成

PUT/POST的时候，就会生成doc value数据，也就是正排索引

### 2、核心原理与倒排索引类似

正排索引，也会写入磁盘文件中，然后呢，os cache先进行缓存，以提升访问doc value正排索引的性能

如果os cache内存大小不足够放得下整个正排索引，doc value，就会将doc value的数据写入磁盘文件中

### 3、性能问题：给jvm更少内存，64g服务器，给jvm最多16g

* es官方是建议，es大量是基于os cache来进行缓存和提升性能的，不建议用jvm内存来进行缓存，那样会导致一定的gc开销和oom问题
* 给jvm更少的内存，给os cache更大的内存
* 64g服务器，给jvm最多16g，几十个g的内存给os cache
* os cache可以提升doc value和倒排索引的缓存和查询效率

## 三、column压缩

例如 正排索引:

```
doc1: 550
doc2: 550
doc3: 500

```
对于以上索引存储：合并相同值，550，doc1和doc2都保留一个550的标识即可
* 1、所有值相同，直接保留单值
* 2、少于256个值，使用table encoding模式：一种压缩方式
* 3、大于256个值，看有没有最大公约数，有就除以最大公约数，然后保留这个最大公约数

最大公约数例子：

```
doc1: 36
doc2: 24
```

```
其中36和 24的最大公约数为6 
--> doc1: 6, doc2: 4
--> 保留一个最大公约数6的标识，6也保存起来

```

* 4、如果没有最大公约数，采取offset结合压缩的方式：
* 总的思路 doc value 进行压缩，尽量减少doc value


## 四、disable doc value

如果的确不需要doc value，比如聚合等操作，那么可以禁用，减少磁盘空间占用

```

PUT my_index
{
  "mappings": {
    "my_type": {
      "properties": {
        "my_field": {
          "type": "keyword"
          "doc_values": false 
        }
      }
    }
  }
}

```