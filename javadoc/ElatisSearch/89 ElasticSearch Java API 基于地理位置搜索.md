# 89 ElasticSearch Java API 基于地理位置搜索


## 代码

```
<dependency>
    <groupId>org.locationtech.spatial4j</groupId>
    <artifactId>spatial4j</artifactId>
    <version>0.6</version>                        
</dependency>

<dependency>
    <groupId>com.vividsolutions</groupId>
    <artifactId>jts</artifactId>
    <version>1.13</version>                         
    <exclusions>
        <exclusion>
            <groupId>xerces</groupId>
            <artifactId>xercesImpl</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

比如我们有很多的4s店，然后呢给了用户一个app，在某个地方的时候，可以根据当前的地理位置搜索一下，自己附近的4s店

```
POST /car_shop/_mapping/shops
{
  "properties": {
      "pin": {
          "properties": {
              "location": {
                  "type": "geo_point"
              }
          }
      }
  }
}
```

```
PUT /car_shop/shops/1
{
    "name": "上海至全宝马4S店",
    "pin" : {
        "location" : {
            "lat" : 40.12,
            "lon" : -71.34
        }
    }
}

```

第一个需求：搜索两个坐标点组成的一个区域

```
QueryBuilder qb = geoBoundingBoxQuery("pin.location").setCorners(40.73, -74.1, 40.01, -71.12); 
```

第二个需求：指定一个区域，由三个坐标点，组成，比如上海大厦，东方明珠塔，上海火车站

```
List<GeoPoint> points = new ArrayList<>();             
points.add(new GeoPoint(40.73, -74.1));
points.add(new GeoPoint(40.01, -71.12));
points.add(new GeoPoint(50.56, -90.58));
```

```
QueryBuilder qb = geoPolygonQuery("pin.location", points); 
```

第三个需求：搜索距离当前位置在200公里内的4s店

```
QueryBuilder qb = geoDistanceQuery("pin.location").point(40, -70).distance(200, DistanceUnit.KILOMETERS);   

SearchResponse response = client.prepareSearch("car_shop")
        .setTypes("shops")
        .setQuery(qb)                
        .get();

```