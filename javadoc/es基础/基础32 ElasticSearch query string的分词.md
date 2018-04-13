# 基础32 ElasticSearch query string的分词

## 概述

### 1、query string分词

* query string必须以和index建立时相同的analyzer进行分词
* query string对exact value和full text的区别对待

```
date：exact value
_all：full text
```

* 比如我们有一个document，其中有一个field，包含的value是：hello you and me，建立倒排索引
* 我们要搜索这个document对应的index，搜索文本是hell me，这个搜索文本就是query string
* query string，默认情况下，es会使用它对应的field建立倒排索引时相同的分词器去进行分词，分词和normalization，只有这样，才能实现正确的搜索
* 我们建立倒排索引的时候，将dogs --> dog，结果你搜索的时候，还是一个dogs，那不就搜索不到了吗？所以搜索的时候，那个dogs也必须变成dog才行。才能搜索到。

知识点：不同类型的field，可能有的就是full text，有的就是exact value

```
post_date，date：exact value
_all：full text，分词，normalization
```

### 2、

```
GET /_search?q=2017
```

搜索的是_all field，document所有的field都会拼接成一个大串，进行分词

2017-01-02 my second article this is my second article in this website 11400

```
		doc1		doc2		doc3
2017		*		*		*
01		* 		
02				*
03						*
```


```
_all，2017，自然会搜索到3个docuemnt

GET /_search?q=2017-01-01

_all，2017-01-01，query string会用跟建立倒排索引一样的分词器去进行分词

2017
01
01

```



```
GET /_search?q=post_date:2017-01-01
```

date，会作为exact value去建立索引

```
		doc1		doc2		doc3
2017-01-01	*		
2017-01-02			* 		
2017-01-03					*
```

post_date:2017-01-01，2017-01-01，doc1一条document


### 3、测试分词器

```
GET /_analyze
{
  "analyzer": "standard",
  "text": "Text to analyze"
}
```





