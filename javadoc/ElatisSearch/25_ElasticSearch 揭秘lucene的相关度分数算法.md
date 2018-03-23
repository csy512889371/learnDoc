# 25_ElasticSearch 揭秘lucene的相关度分数算法


## 一、概述

* 一个搜索引擎使用的时候必定需要排序这个模块，一般情况下在不选择按照某一字段排序的情况下，都是按照打分的高低进行一个默认排序的，所以如果正式使用的话，必须对默认排序的打分策略有一个详细的了解
* 对TF/IDF算法，在lucene中，底层，到底进行TF/IDF算法计算的一个完整的公式进行说明

ES官网给出的打分公式：

```java
score(q,d)  =  
            queryNorm(q)  
          · coord(q,d)    
          · ∑ (           
                tf(t in d)   
              · idf(t)2      
              · t.getBoost() 
              · norm(t,d)    
            ) (t in q) 
```


* t 表示term
* q 表示 query 表示一个queue. 一个query 里有多个term
* d 表示 doc 文档
* score(q,d)计算分数的算法. 表示计算一个query对一个doc的分数的公式
* queryNorm将分数进行规范化,使分数不会太高。不影响排序
* coord() 就是对更加匹配的doc，进行一些分数上的成倍的奖励(奖励那些匹配更多字符的doc更多的分数)
* norm() 根据 field-length 进行分数上的奖励。field越短，如果召回的话权重越大
* t.getBoost 获取每一个term的权值


## 二、例子

* 使用hello world 关键字进行查询
* 普通multivalue搜索，转换为bool搜索，boolean model

```java
"bool": {
	"should": [
		{
			"match": {
				"title": "hello"
			}
		},
		{
			"natch": {
				"title": "world"
			}
		}
	]
}
```

## 二、算法解释

### 1、lucene practical scoring function

practical scoring function，来计算一个query对一个doc的分数的公式，该函数会使用一个公式来计算

**公式: **

```java
score(q,d)  =  
            queryNorm(q)  
          · coord(q,d)    
          · ∑ (           
                tf(t in d)   
              · idf(t)2      
              · t.getBoost() 
              · norm(t,d)    
            ) (t in q) 
```

### 2、公式解释

* 1、score(q,d) score(q,d) is the relevance score of document d for query q.
* 1、这个公式的最终结果，就是说是一个query（叫做q），对一个doc（叫做d）的最终的总评分

* 2、queryNorm(q) is the query normalization factor (new).
* 2、queryNorm，是用来让一个doc的分数处于一个合理的区间内，不要太离谱，举个例子，一个doc分数是10000，一个doc分数是0.1，你们说好不好，肯定不好

* 3、coord(q,d) is the coordination factor (new).
* 3、简单来说，就是对更加匹配的doc，进行一些分数上的成倍的奖励

* 4、The sum of the weights for each term t in the query q for document d.
* 4、求和

### 3、对求进行解释

```java
	∑ (           
		tf(t in d)   
	  · idf(t)2      
	  · t.getBoost() 
	  · norm(t,d)    
	) (t in q) 
```

* 1、∑：求和的符号
* 2、∑ (t in q)：query中每个term，query = hello world，query中的term就包含了hello和world
* 3、query中每个term对doc的分数，进行求和，多个term对一个doc的分数，组成一个vector space，然后计算吗，就在这一步

* 4、tf(t in d) is the term frequency for term t in document d.
* 4、计算每一个term对doc的分数的时候，就是TF/IDF算法

* 5、idf(t) is the inverse document frequency for term t.
* 5、计算IDF算法

* 6、t.getBoost() is the boost that has been applied to the query (new).
* 6、getBoost表明该field的权值越大,越重要

* 7、 norm(t,d) is the field-length norm, combined with the index-time field-level boost, if any. (new).
* 7、 字段长度归约是为了让内容较短的字段发挥更大的作用,而内容较长的字段权重相对降低

### 4、queryNorm(query normalization factor)

是用来让一个doc的分数处于一个合理的区间内，不要太离谱。不影响排序


公式：

```java

queryNorm = 1 / √sumOfSquaredWeights

```

* 1、sumOfSquaredWeights = 所有term的IDF分数之和，开一个平方根，然后做一个平方根分之1
* 2、主要是为了将分数进行规范化 
* 2.1 开平方根，首先数据就变小了 
* 2.2 然后还用1去除以这个平方根，分数就会很小 
* 2.3 1.几 / 零点几
* 3、分数就不会出现几万，几十万，那样的离谱的分数

### 5、coord (query coodination)

* 奖励那些匹配更多字符的doc更多的分数
* 把计算出来的总分数 * 匹配上的term数量 / 总的term数量，让匹配不同term/query数量的doc，分数之间拉开差距


例子：
```java
Document 1 with hello → score: 1.5
Document 2 with hello world → score: 3.0
Document 3 with hello world java → score: 4.5
```

```java
Document 1 with hello → score: 1.5 * 1 / 3 = 0.5
Document 2 with hello world → score: 3.0 * 2 / 3 = 2.0
Document 3 with hello world java → score: 4.5 * 3 / 3 = 4.5
```


### 6、field level boost

