# 84 ElasticSearch  Java API 基于bulk实现

## 概述


业务场景：有一个汽车销售公司，拥有很多家4S店，这些4S店的数据，都会在一段时间内陆续传递过来，汽车的销售数据，现在希望能够在内存中缓存比如1000条销售数据，然后一次性批量上传到es中去

```
PUT /car_shop/sales/1
{
    "brand": "宝马",
    "name": "宝马320",
    "price": 320000,
    "produce_date": "2017-01-01",
    "sale_price": 300000,
    "sale_date": "2017-01-21"
}

```

```
PUT /car_shop/sales/2
{
    "brand": "宝马",
    "name": "宝马320",
    "price": 320000,
    "produce_date": "2017-01-01",
    "sale_price": 300000,
    "sale_date": "2017-01-21"
}

```

```
BulkRequestBuilder bulkRequest = client.prepareBulk();

bulkRequest.add(client.prepareIndex("car_shop", "sales", "3")
        .setSource(jsonBuilder()
                    .startObject()
                        .field("brand", "奔驰")
                        .field("name", "奔驰C200")
                        .field("price", 350000)
                        .field("produce_date", "2017-01-05")
                        .field("sale_price", 340000)
                        .field("sale_date", "2017-02-03")
                    .endObject()
                  )
        );

bulkRequest.add(client.prepareUpdate("car_shop", "sales", "1")
        .setDoc(jsonBuilder()               
		            .startObject()
		                .field("sale_price", "290000")
		            .endObject()
		        )
        );

bulkRequest.add(client.prepareDelete("car_shop", "sales", "2"));

BulkResponse bulkResponse = bulkRequest.get();

if (bulkResponse.hasFailures()) {}
```



