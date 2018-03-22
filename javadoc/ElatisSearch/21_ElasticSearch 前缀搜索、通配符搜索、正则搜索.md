# 21_ElasticSearch 前缀搜索、通配符搜索、正则搜索

## 一、概述

* 前缀搜索 prefix
* 前缀搜索的原理
* 通配符搜索 wildcard和regexp

wildcard和regexp，与prefix原理一致，都会扫描整个索引，性能很差.在实际应用中，能不用尽量别用。性能太差了。

实际场景中，可能有些场景是全文检索，而只能用prefix

## 二、前缀搜索

前缀搜索 顾名思义:对field中的text 进行前缀搜索(根据字符串的前缀去搜索)。其中text 需要不分词。

### 1.例子一

```java
C3D0-KD345
C3K5-DFG65
C4I8-UI365
```

使用C3查询：

```java
C3 --> 上面这两个都搜索出来 --> 根据字符串的前缀去搜索
```

### 2.例子二

创建index(类似 数据库)

```java
PUT my_index
{
  "mappings": {
    "my_type": {
      "properties": {
        "title": {
          "type": "keyword"
        }
      }
    }
  }
}
```

prefix 搜索

```java
GET my_index/my_type/_search
{
  "query": {
    "prefix": {
      "title": {
        "value": "C3"
      }
    }
  }
}
```

## 二、前缀搜索的原理

前缀越短，要处理的doc越多，性能越差，尽可能用长前缀搜索

* prefix query不计算relevance score
* 与prefix filter唯一的区别就是，filter会cache bitset

扫描整个倒排索引，举例说明:

```java
C3-D0-KD345
C3-K5-DFG65
C4-I8-UI365
```


### 1、使用match进行搜索，不用prefix

对以上的text 进行分词，每个字符串都需要被分词

```java
c3			doc1,doc2
d0
kd345
k5
dfg65
c4
i8
ui365
```

match性能往往是很高的 如搜索关键字c3

```java
c3 --> 扫描倒排索引 --> 一旦扫描到c3，就可以停了，因为带c3的就2个doc，已经找到了 --> 没有必要继续去搜索其他的term了
```

### 1、直接使用prefix

因为使用prefix就不分词，无法使用bitset。只能一条一条扫描例如：

```java
C3-D0-KD345
C3-K5-DFG65
C4-I8-UI365
```

搜索关键字c3
```java
搜索 c3 
--> 先扫描到了C3-D0-KD345，很棒，找到了一个前缀带c3的字符串 
--> 还是要继续搜索的，因为后面还有一个C3-K5-DFG65，也许还有其他很多的前缀带c3的字符串 
--> 你扫描到了一个前缀匹配的term，不能停，必须继续搜索 
--> 直到扫描完整个的倒排索引，才能结束
```


## 三、通配符搜索

跟前缀搜索类似，功能更加强大. 性能一样差，必须扫描整个倒排索引

* ?：任意字符
* *：0个或任意多个字符


### 1、例子一

```java
C3D0-KD345
C3K5-DFG65
C4I8-UI365
```

* 5字符-D任意个字符5
* 5?-*5：通配符去表达更加复杂的模糊搜索的语义

```java
GET my_index/my_type/_search
{
  "query": {
    "wildcard": {
      "title": {
        "value": "C?K*5"
      }
    }
  }
}

```


## 四、正则搜索

wildcard和regexp，与prefix原理一致，都会扫描整个索引，性能很差

* [0-9]：指定范围内的数字
* [a-z]：指定范围内的字母
* .：一个字符
* +：前面的正则表达式可以出现一次或多次

```java
GET /my_index/my_type/_search 
{
  "query": {
    "regexp": {
      "title": "C[0-9].+"
    }
  }
}
```








