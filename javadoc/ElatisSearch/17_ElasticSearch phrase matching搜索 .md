# 17_ElasticSearch phrase matching搜索 

## 概述

* 0、需求：搜索java spark 靠在一起doc
* 1、java spark，就靠在一起，中间不能插入任何其他字符，就要搜索出来这种doc
* 2、java spark，但是要求，java和spark两个单词靠的越近，doc的分数越高，排名越靠前

近似匹配

* phrase match 短语匹配
* proximity match 近似匹配

## 例子

两个句子

```java
java is my favourite programming language, and I also think spark is a very good big data system.
java spark are very related, because scala is spark's programming language and scala is also based on jvm like java.
```


使用match query，搜索java spark。无法实现以上需求如：

```java

{
	"match": {
		"content": "java spark"
	}
}
```

单单包含java的doc也返回了，不是我们想要的结果

POST /forum/article/5/_update
{
  "doc": {
    "content": "spark is best big data solution based on scala ,an programming language similar to java spark"
  }
}


### match query 的问题：

* match query，只能搜索到包含java和spark的document，但是不知道java和spark是不是离的很近
* 包含java或包含spark，或包含java和spark的doc，都会被返回回来。
* 我们其实并不知道哪个doc，java和spark距离的比较近。
* 如果我们就是希望搜索java spark，中间不能插入任何其他的字符，那这个时候match去做全文检索，将无法实现。
* 如果我们要尽量让java和spark离的很近的document优先返回，要给它一个更高的relevance score，这就涉及到了proximity match，近似匹配

### 近似匹配



如果说，要实现两个需求：

* 1、java spark，就靠在一起，中间不能插入任何其他字符，就要搜索出来这种doc
* 2、java spark，但是要求，java和spark两个单词靠的越近，doc的分数越高，排名越靠前

用proximity match，近似匹配 实现以上需求

* phrase match，就是仅仅搜索出java和spark靠在一起的那些doc，比如有个doc，是java use'd spark，不行。必须是比如java spark are very good friends，是可以搜索出来的。
* phrase match，就是要去将多个term作为一个短语，一起去搜索，只有包含这个短语的doc才会作为结果返回。不像是match，java spark，java的doc也会返回，spark的doc也会返回。


match_phrase语法


```java
GET /forum/article/_search
{
    "query": {
        "match_phrase": {
            "content": "java spark"
        }
    }
}
```


成功了，只有包含java spark这个短语的doc才返回了，只包含java的doc不会返回

## match_phrase的基本原理

```java
GET _analyze
{
  "text": "hello world, java spark",
  "analyzer": "standard"
}
```

term position

```java
hello world, java spark		doc1
hi, spark java				doc2
```

生成以下倒排索引：包含位置信息.索引中的position，match_phrase

```java
hello 		doc1(0)		
wolrd		doc1(1)
java		doc1(2) doc2(2)
spark		doc1(3) doc2(1)
```

* 1、java spark --> match phrase
* 2、java spark --> java和spark
* 3、java --> doc1(2) doc2(2)
* 4、spark --> doc1(3) doc2(1)

### 分析 doc1

* 1.要找到每个term都在的一个共有的那些doc，就是要求一个doc，必须包含每个term，才能拿出来继续计算
* 2、doc1 --> java和spark --> spark position恰巧比java大1 --> java的position是2，spark的position是3，恰好满足条件
* 3、doc1符合条件

### 分析 doc2

* 1、doc2 --> java和spark 
* 2、java position是2，spark position是1，spark position比java position小1，而不是大1 
* 3、光是position就不满足，那么doc2不匹配


