# 基础35 ElasticSearch search api的基础语法

## 概述


### 1、search api的基本语法

```
GET /_search
{}
```

```
GET /index1,index2/type1,type2/_search
{}
```

```
GET /_search
{
  "from": 0,
  "size": 10
}
```

## 2、http协议中get是否可以带上request body

HTTP协议，一般不允许get请求带上request body，但是因为get更加适合描述查询数据的操作，因此还是这么用了

```
GET /_search?from=0&size=10
```

```
POST /_search
{
  "from":0,
  "size":10
}
```

碰巧，很多浏览器，或者是服务器，也都支持GET+request body模式

```
如果遇到不支持的场景，也可以用POST /_search

```
