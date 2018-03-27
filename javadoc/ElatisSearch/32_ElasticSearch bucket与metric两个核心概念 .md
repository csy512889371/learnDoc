# 32_ElasticSearch bucket与metric两个核心概念 


## 一、两个核心概念：bucket和metric

* bucket：一个数据分组
* metric：对一个数据分组执行的统计

## 二、例子说明

### bucket

一个数据分组

```
city name

北京 小李
北京 小王
上海 小张
上海 小丽
上海 小陈
```

* 基于city划分buckets.划分出来两个bucket，一个是北京bucket，一个是上海bucket
** 北京bucket：包含了2个人，小李，小王
** 上海bucket：包含了3个人，小张，小丽，小陈

* 按照某个字段进行bucket划分，那个字段的值相同的那些数据，就会被划分到一个bucket中
* 有一些mysql的sql知识的话，聚合，首先第一步就是分组，对每个组内的数据进行聚合分析，分组，就是我们的bucket

### metric

对一个数据分组执行的统计

当我们有了一堆bucket之后，就可以对每个bucket中的数据进行聚合分词了，比如说计算一个bucket内所有数据的数量，或者计算一个bucket内所有数据的平均值，最大值，最小值

metric，就是对一个bucket执行的某种聚合分析的操作，比如说求平均值，求最大值，求最小值

```
select count(*)
from access_log
group by user_id
```

* bucket：group by user_id --> 那些user_id相同的数据，就会被划分到一个bucket中
* metric：count(*)，对每个user_id bucket中所有的数据，计算一个数量


