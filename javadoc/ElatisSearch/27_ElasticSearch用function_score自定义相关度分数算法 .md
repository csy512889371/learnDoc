# 27_ElasticSearch用function_score自定义相关度分数算法 

## 需求
* 1、在field: tile 和 content 中查找 java spark 的doc
* 2、要求follower_num越多的 doc 分数越高。(看帖子的人越多，那么帖子的分数就越高)

function_score函数：
* 我们可以做到自定义一个function_score函数
* 自己将某个field的值，跟es内置算出来的分数进行运算
* 然后由自己指定的field来进行分数的增强

## 例子


给所有的帖子数据增加follower数量

```java
POST /forum/article/_bulk
{ "update": { "_id": "1"} }
{ "doc" : {"follower_num" : 5} }
{ "update": { "_id": "2"} }
{ "doc" : {"follower_num" : 10} }
{ "update": { "_id": "3"} }
{ "doc" : {"follower_num" : 25} }
{ "update": { "_id": "4"} }
{ "doc" : {"follower_num" : 3} }
{ "update": { "_id": "5"} }
{ "doc" : {"follower_num" : 60} }
```

* 将对帖子搜索得到的分数，跟follower_num进行运算，由follower_num在一定程度上增强帖子的分数
* 看帖子的人越多，那么帖子的分数就越高

```java
GET /forum/article/_search
{
  "query": {
    "function_score": {
      "query": {
        "multi_match": {
          "query": "java spark",
          "fields": ["tile", "content"]
        }
      },
      "field_value_factor": {
        "field": "follower_num",
        "modifier": "log1p",
        "factor": 0.5
      },
      "boost_mode": "sum",
      "max_boost": 2
    }
  }
}
```

* field_value_factor中如果只有field，那么会将每个doc的分数都乘以follower_num，如果有的doc follower是0，那么分数就会变为0，效果很不好。
* 因此一般会加个log1p函数，公式会变为，new_score = old_score * log(1 + number_of_votes)，这样出来的分数会比较合理
* 再加个factor，可以进一步影响分数，new_score = old_score * log(1 + factor * number_of_votes)
* boost_mode，可以决定分数与指定字段的值如何计算，multiply，sum，min，max，replace
* max_boost，限制计算出来的分数不要超过max_boost指定的值


