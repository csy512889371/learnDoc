# 56 fielddata预加载机制以及序号标记预加载


## 一、概述

如果真的要对分词的field执行聚合，那么每次都在query-time现场生产fielddata并加载到内存中来，速度可能会比较慢

我们是不是可以预先生成加载fielddata到内存中来

## 二、例子

### 1、fielddata预加载

```
POST /test_index/_mapping/test_type
{
  "properties": {
    "test_field": {
      "type": "string",
      "fielddata": {
        "loading" : "eager" 
      }
    }
  }
}
```

query-time的fielddata生成和加载到内存，变为index-time，建立倒排索引的时候，会同步生成fielddata并且加载到内存中来，这样的话，对分词field的聚合性能当然会大幅度增强

### 2、序号标记预加载

global ordinal原理解释

```
doc1: status1
doc2: status2
doc3: status2
doc4: status1
```

有很多重复值的情况，会进行global ordinal标记

```
status1 --> 0
status2 --> 1

doc1: 0
doc2: 1
doc3: 1
doc4: 0
```

建立的fielddata也会是这个样子的，这样的好处就是减少重复字符串的出现的次数，减少内存的消耗

```

POST /test_index/_mapping/test_type
{
  "properties": {
    "test_field": {
      "type": "string",
      "fielddata": {
        "loading" : "eager_global_ordinals" 
      }
    }
  }
}

```