# 87 ElasticSearch Java API 行全文检索、精准查询和前缀搜索

## 概述

```
PUT /car_shop/cars/5
{
        "brand": "华晨宝马",
        "name": "宝马318",
        "price": 270000,
        "produce_date": "2017-01-20"
}

```

```
SearchResponse response = client.prepareSearch("car_shop")
        .setTypes("cars")
        .setQuery(QueryBuilders.matchQuery("brand", "宝马"))                
        .get();

```

```
SearchResponse response = client.prepareSearch("car_shop")
        .setTypes("cars")
        .setQuery(QueryBuilders.multiMatchQuery("宝马", "brand", "name"))                
        .get();

```

```
SearchResponse response = client.prepareSearch("car_shop")
        .setTypes("cars")
        .setQuery(QueryBuilders.commonTermsQuery("name", "宝马320"))                
        .get();

```

```
SearchResponse response = client.prepareSearch("car_shop")
        .setTypes("cars")
        .setQuery(QueryBuilders.prefixQuery("name", "宝"))                
        .get();
```


