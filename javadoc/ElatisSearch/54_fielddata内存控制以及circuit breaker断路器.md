# 54_fielddata内存控制以及circuit breaker断路器



## 1、fielddata核心原理

* fielddata加载到内存的过程是lazy加载的，对一个analzyed field执行聚合时，才会加载，而且是field-level加载的
* 一个index的一个field，所有doc都会被加载，而不是少数doc
* 不是index-time创建，是query-time创建

## 2、fielddata内存限制

* indices.fielddata.cache.size: 20%，超出限制，清除内存已有fielddata数据
* fielddata占用的内存超出了这个比例的限制，那么就清除掉内存中已有的fielddata数据
* 默认无限制，限制内存使用，但是会导致频繁evict和reload，大量IO性能损耗，以及内存碎片和gc

## 3、监控fielddata内存使用

```
GET /_stats/fielddata?fields=*
GET /_nodes/stats/indices/fielddata?fields=*
GET /_nodes/stats/indices/fielddata?level=indices&fields=*
```

## 4、circuit breaker

* 如果一次query load的feilddata超过总内存，就会oom --> 内存溢出
* circuit breaker会估算query要加载的fielddata大小，如果超出总内存，就短路，query直接失败

```
indices.breaker.fielddata.limit：fielddata的内存限制，默认60%
indices.breaker.request.limit：执行聚合的内存限制，默认40%
indices.breaker.total.limit：综合上面两个，限制在70%以内
```


