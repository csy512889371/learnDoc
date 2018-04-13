# 85 ElasticSearch  Java API 基于scroll

## 概述

比如说，现在要下载大批量的数据，从es，放到excel中，我们说，月度，或者年度，销售记录，很多，比如几千条，几万条，几十万条

其实就要用到我们之前讲解的es scroll api，对大量数据批量的获取和处理

```
PUT /car_shop/sales/4
{
    "brand": "宝马",
    "name": "宝马320",
    "price": 320000,
    "produce_date": "2017-01-01",
    "sale_price": 280000,
    "sale_date": "2017-01-25"
}
```

就是要看宝马的销售记录

2条数据，做一个演示，每个批次下载一条宝马的销售记录，分2个批次给它下载完

```
SearchResponse scrollResp = client.prepareSearch("car_shop")
		.addTypes("sales")
        .setScroll(new TimeValue(60000))
        .setQuery(termQuery("brand.raw", "宝马"))
        .setSize(1)
        .get(); 

do {
    for (SearchHit hit : scrollResp.getHits().getHits()) {
    	
    }
    
    scrollResp = client.prepareSearchScroll(scrollResp.getScrollId())
            .setScroll(new TimeValue(60000))
            .execute()
            .actionGet();
} while(scrollResp.getHits().getHits().length != 0);

```
