# 基础21 ElastciSearch document数据路由

## 概述

* 1）document路由到shard上是什么意思？
* 2）路由算法：shard = hash(routing) % number_of_primary_shards

举个例子，一个index有3个primary shard，P0，P1，P2

每次增删改查一个document的时候，都会带过来一个routing number，默认就是这个document的_id（可能是手动指定，也可能是自动生成）

```
routing = _id，假设_id=1
```

* 会将这个routing值，传入一个hash函数中，产出一个routing值的hash值，hash(routing) = 21
* 然后将hash函数产出的值对这个index的primary shard的数量求余数，21 % 3 = 0 就决定了，这个document就放在P0上。

* 决定一个document在哪个shard上，最重要的一个值就是routing值，默认是_id，也可以手动指定，相同的routing值，每次过来，从hash函数中，产出的hash值一定是相同的

* 无论hash值是几，无论是什么数字，对number_of_primary_shards求余数，结果一定是在0~number_of_primary_shards-1之间这个范围内的。0,1,2。

* 3）id or custom routing value

* 默认的routing就是_id
* 也可以在发送请求的时候，手动指定一个routing value，比如说put /index/type/id?routing=user_id

手动指定routing value是很有用的，可以保证说，某一类document一定被路由到一个shard上去，那么在后续进行应用级别的负载均衡，以及提升批量读取的性能的时候，是很有帮助的

