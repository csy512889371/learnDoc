# 83 ElasticSearch  Java API 基于mget实现

## 概述


场景，一般来说，我们都可以在一些汽车网站上，或者在混合销售多个品牌的汽车4S店的内部，都可以在系统里调出来多个汽车的信息，放在网页上，进行对比

mget，一次性将多个document的数据查询出来，放在一起显示，多个汽车的型号，一次性拿出了多辆汽车的信息

```
PUT /car_shop/cars/2
{
	"brand": "奔驰",
	"name": "奔驰C200",
	"price": 350000,
	"produce_date": "2017-01-05"
}
```

```
MultiGetResponse multiGetItemResponses = client.prepareMultiGet()
    .add("car_shop", "cars", "1")           
    .add("car_shop", "cars", "2")        
    .get();

for (MultiGetItemResponse itemResponse : multiGetItemResponses) { 
    GetResponse response = itemResponse.getResponse();
    if (response.isExists()) {                      
        String json = response.getSourceAsString(); 
    }
}

```
