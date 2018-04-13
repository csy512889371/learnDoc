# 82 ElasticSearch  Java API_基于upsert 

## 概述


做一个汽车零售数据的mapping，我们要做的第一份数据，其实汽车信息

```
PUT /car_shop
{
    "mappings": {
        "cars": {
            "properties": {
                "brand": {
                    "type": "text",
                    "analyzer": "ik_max_word",
                    "fields": {
                        "raw": {
                            "type": "keyword"
                        }
                    }
                },
                "name": {
                    "type": "text",
                    "analyzer": "ik_max_word",
                    "fields": {
                        "raw": {
                            "type": "keyword"
                        }
                    }
                }
            }
        }
    }
}
```

首先的话呢，第一次调整宝马320这个汽车的售价，我们希望将售价设置为32万，用一个upsert语法，如果这个汽车的信息之前不存在，那么就insert，如果存在，那么就update

```java

IndexRequest indexRequest = new IndexRequest("car_shop", "cars", "1")
        .source(jsonBuilder()
            .startObject()
                .field("brand", "宝马")
                .field("name", "宝马320")
                .field("price", 320000)
                .field("produce_date", "2017-01-01")
            .endObject());

UpdateRequest updateRequest = new UpdateRequest("car_shop", "cars", "1")
        .doc(jsonBuilder()
            .startObject()
                .field("price", 320000)
            .endObject())
        .upsert(indexRequest);       
               
client.update(updateRequest).get();

IndexRequest indexRequest = new IndexRequest("car_shop", "cars", "1")
        .source(jsonBuilder()
            .startObject()
                .field("brand", "宝马")
                .field("name", "宝马320")
                .field("price", 310000)
                .field("produce_date", "2017-01-01")
            .endObject());
UpdateRequest updateRequest = new UpdateRequest("car_shop", "cars", "1")
        .doc(jsonBuilder()
            .startObject()
                .field("price", 310000)
            .endObject())
        .upsert(indexRequest);              
client.update(updateRequest).get();

```
