# 基础30 ElasticSearch 倒排索引核心


## 概述

## 一、创建


```
doc1：I really liked my small dogs, and I think my mom also liked them.
doc2：He never liked any dogs, so I hope that my mom will not expect me to liked him.
```

分词，初步的倒排索引的建立

```
word		doc1			doc2

I		*			*
really		*
liked		*			*
my		*			*
small		*	
dogs		*
and		*
think		*
mom		*			*
also		*
them		*	
He					*
never					*
any					*
so					*
hope					*
that					*
will					*
not					*
expect					*
me					*
to					*
him					*
```

演示了一下倒排索引最简单的建立的一个过程

## 二、搜索

mother like little dog，不可能有任何结果

```
mother
like
little
dog
```

这个是不是我们想要的搜索结果？绝对不是，因为在我们看来

```
mother和mom有区别吗？同义词，都是妈妈的意思。
like和liked有区别吗？没有，都是喜欢的意思，只不过一个是现在时，一个是过去时。
little和small有区别吗？同义词，都是小小的。
dog和dogs有区别吗？狗，只不过一个是单数，一个是复数。
```

normalization，建立倒排索引的时候，会执行一个操作，也就是说对拆分出的各个单词进行相应的处理，以提升后面搜索的时候能够搜索到相关联的文档的概率

时态的转换，单复数的转换，同义词的转换，大小写的转换

```
mom ―> mother
liked ―> like
small ―> little
dogs ―> dog
```

重新建立倒排索引，加入normalization，再次用mother liked little dog搜索，就可以搜索到了

```
word		doc1			doc2

I		*			*
really		*
like		*			*			liked --> like
my		*			*
little		*						small --> little
dog		*			*			dogs --> dog						
and		*
think		*
mom		*			*
also		*
them		*	
He					*
never					*
any					*
so					*
hope					*
that					*
will					*
not					*
expect					*
me					*
to					*
him					*
```

mother like little dog，分词，normalization

```
mother	--> mom
like	--> like
little	--> little
dog	--> dog
```

doc1和doc2都会搜索出来

```
doc1：I really liked my small dogs, and I think my mom also liked them.
doc2：He never liked any dogs, so I hope that my mom will not expect me to liked him.
```




