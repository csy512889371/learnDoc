# 57_海量bucket优化机制 从深度优 先到广度优先


## 概述

1、当buckets数量特别多的时候，深度优先和广度优先的原理

```
    actor1            actor2            .... actor
film1 film2 film3   film1 film2 film3   ...film
```

2、广度优先的方式去执行聚合

```
actor1    actor2    actor3    ..... n个actor
```

10万个actor，不去构建它下面的film数据，10万 --> 99990，10个actor，构建出film，裁剪出其中的5个film即可，10万 -> 50个


## 例子



* 我们的数据，是每个演员的每个电影的评论
* 每个演员的评论的数量 --> 每个演员的每个电影的评论的数量
* 评论数量排名前10个的演员 --> 每个演员的电影取到评论数量排名前5的电影

```
{
  "aggs" : {
    "actors" : {
      "terms" : {
         "field" :        "actors",
         "size" :         10,
         "collect_mode" : "breadth_first" 
      },
      "aggs" : {
        "costars" : {
          "terms" : {
            "field" : "films",
            "size" :  5
          }
        }
      }
    }
  }
}
```

### 1、深度优先的方式去执行聚合操作的

```
    actor1            actor2            .... actor
film1 film2 film3   film1 film2 film3   ...film
```

* 比如说，我们有10万个actor，最后其实是主要10个actor就可以了
* 但是我们已经深度优先的方式，构建了一整颗完整的树出来了，10万个actor，每个actor平均有10部电影，10万 + 100万 --> 110万的数据量的一颗树
* 裁剪掉10万个actor中的99990 actor，99990 * 10 = film，剩下10个actor，每个actor的10个film裁剪掉5个，110万 --> 10 * 5 = 50个
* 构建了大量的数据，然后裁剪掉了99.99%的数据，浪费了

### 2、广度优先的方式去执行聚合

```
actor1    actor2    actor3    ..... n个actor
```

10万个actor，不去构建它下面的film数据，10万 --> 99990，10个actor，构建出film，裁剪出其中的5个film即可，10万 -> 50个

