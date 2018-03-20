# 2_ElatisSearch filter执行原理 bitset机制与caching机制

## 1、

在倒排索引中查找搜索串，获取document list

* 用时间类型date作为filter来举例, filter：2017-02-02
* 例子一：倒排索引如下：
```java
word		doc1		doc2		doc3
2017-01-01	*		*
2017-02-02			*		*
2017-03-03	*		*		*
```

到倒排索引中一找，发现2017-02-02对应的document list是doc2,doc3

## 2、

为每个在倒排索引中搜索到的结果，构建一个bitset

* 其中个bitset 如下，其中0表示未匹配，1 表示匹配

```java
[0, 1, 1]
```

* 使用找到的doc list，构建一个bitset，就是一个二进制的数组，数组每个元素都是0或1，用来标识一个doc对一个filter条件是否匹配，如果匹配就是1，不匹配就是0
* 例子一中的bitset结果：[0, 1, 1]
* doc1：不匹配这个filter的* doc2和do3：是匹配这个filter的
* 尽可能用简单的数据结构去实现复杂的功能，可以节省内存空间，提升性能

## 3、

遍历每个过滤条件对应的bitset，优先从最稀疏的开始搜索，查找满足所有条件的document

* 一次性可以在一个search请求中，发出多个filter条件，每个filter条件都会对应一个bitset
* 遍历每个filter条件对应的bitset，先从最稀疏的开始遍历

```java
[0, 0, 0, 1, 0, 0]：比较稀疏
[0, 1, 0, 1, 0, 1]
```
* 先遍历比较稀疏的bitset，就可以先过滤掉尽可能多的数据
* 遍历所有的bitset，找到匹配所有filter条件的doc
* 请求：filter，postDate=2017-01-01，userID=1

```java
postDate: [0, 0, 1, 1, 0, 0]
userID:   [0, 1, 0, 1, 0, 1]
```
* 遍历完两个bitset之后，找到的匹配所有条件的doc，就是doc4
* 就可以将document作为结果返回给client了

## 4、
caching bitset，跟踪query，在最近256个query中超过一定次数的过滤条件，缓存其bitset。对于小segment（<1000条，或<3%），不缓存bitset。

* 比如postDate=2017-01-01，[0, 0, 1, 1, 0, 0]，可以缓存在内存中，这样下次如果再有这个条件过来的时候，就不用重新扫描倒排索引，反复生成bitset，可以大幅度提升性能。
* 在最近的256个filter中，有某个filter超过了一定的次数，次数不固定，就会自动缓存这个filter对应的bitset
* segment，filter针对小segment获取到的结果，可以不缓存，segment记录数<1000，或者segment大小<index总大小的3%
* segment数据量很小，此时哪怕是扫描也很快；segment会在后台自动合并，小segment很快就会跟其他小segment合并成大segment，此时就缓存也没有什么意义，segment很快就消失了。针对一个小segment的bitset，[0, 0, 1, 0]
* filter比query的好处就在于会caching，但是之前不知道caching的是什么东西，实际上并不是一个filter返回的完整的doc list数据结果。而是filter bitset缓存起来。下次不用扫描倒排索引了。

## 5、
filter大部分情况下来说，在query之前执行，先尽量过滤掉尽可能多的数据

* query：是会计算doc对搜索条件的relevance score，还会根据这个score去排序
* filter：只是简单过滤出想要的数据，不计算relevance score，也不排序

## 6、
如果document有新增或修改，那么cached bitset会被自动更新

```java
postDate=2017-01-01，[0, 0, 1, 0]
document，id=5，postDate=2017-01-01，会自动更新到postDate=2017-01-01这个filter的bitset中，全自动，缓存会自动更新。postDate=2017-01-01的bitset，[0, 0, 1, 0, 1]
document，id=1，postDate=2016-12-30，修改为postDate-2017-01-01，此时也会自动更新bitset，[1, 0, 1, 0, 1]

```
## 7、
以后只要是有相同的filter条件的，会直接来使用这个过滤条件对应的cached bitset



