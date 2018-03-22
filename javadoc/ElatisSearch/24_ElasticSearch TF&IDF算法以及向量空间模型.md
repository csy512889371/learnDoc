# 24_ElasticSearch TF&IDF算法以及向量空间模型

## 一、概述
* boolean model 类似and这种逻辑操作符，先过滤出包含指定term的doc
* TF （term frequency） 一个term在一个doc中，出现的次数越多，那么最后给的相关度评分就会越高
* IDF（inversed document frequency） 一个term在所有的doc中，出现的次数越多，那么最后给的相关度评分就会越低
* length norm  搜索的那个field的长度，field长度越长，给的相关度评分越低; field长度越短，给的相关度评分越高
* vector space model 向量空间模型


## 二、boolean model

类似and这种逻辑操作符，先过滤出包含指定term的doc

* query "hello world" --> 过滤 --> hello / world / hello & world
* bool --> must/must not/should --> 过滤 --> 包含 / 不包含 / 可能包含
* doc --> 不打分数 --> 正或反 true or false --> 为了减少后续要计算的doc的数量，提升性能

## 三、TF/IDF

单个term在doc中的分数

* query: 搜索关键字hello world 在doc.content中搜索

```java
doc1: java is my favourite programming language, hello world !!!
doc2: hello java, you are very good, oh hello world!!!
```

hello对doc1的评分

### 1、TF: term frequency 

* 找到hello在doc1中出现了几次，1次，会根据出现的次数给个分数
* 一个term在一个doc中，出现的次数越多，那么最后给的相关度评分就会越高

### 2、IDF：inversed document frequency

* 找到hello在所有的doc中出现的次数，3次
* 一个term在所有的doc中，出现的次数越多，那么最后给的相关度评分就会越低

### 3、length norm

* hello搜索的那个field的长度，field长度越长，给的相关度评分越低; field长度越短，给的相关度评分越高

### 4、综合平分

最后，会将hello这个term，对doc1的分数，综合TF，IDF，length norm，计算出来一个综合性的分数

```java

搜索关键字：hello world 

--> doc1 
--> hello对doc1的分数，world对doc1的分数 
--> 但是最后hello world query要对doc1有一个总的分数 
--> vector space model

```

## 四、vector space model 向量空间模型


### 1、例子：

多个term对一个doc的总分数

```java
hello world 
--> es会根据hello world在所有doc中的评分情况，计算出一个query vector，query向量
```

* hello这个term，给的基于所有doc的一个评分就是2
* world这个term，给的基于所有doc的一个评分就是5
* doc vector，3个doc，一个包含1个term，一个包含另一个term，一个包含2个term

```java
doc1：包含hello --> [2, 0]
doc2：包含world --> [0, 5]
doc3：包含hello, world --> [2, 5]
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/es/2.png)

如图，取每个doc vector对query vector的弧度，给出每个doc对多个term的总分数
* 每个doc vector计算出对query vector的弧度，最后基于这个弧度给出一个doc相对于query中多个term的总分数
* 弧度越大，分数月底; 弧度越小，分数越高
* 如果是多个term，那么就是线性代数来计算，无法用图表示


