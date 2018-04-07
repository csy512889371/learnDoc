# 55_fielddata filter的细粒度内存加载控制

## 概述

min：仅仅加载至少在1%的doc中出现过的term对应的fielddata

> 比如说某个值，hello，总共有1000个doc，hello必须在10个doc中出现，那么这个hello对应的fielddata才会加载到内存中来

min_segment_size：少于500 doc的segment不加载fielddata

> 加载fielddata的时候，也是按照segment去进行加载的，某个segment里面的doc数量少于500个，那么这个segment的fielddata就不加载

* 一般不会去设置它

## 例子

```
POST /test_index/_mapping/my_type
{
  "properties": {
    "my_field": {
      "type": "text",
      "fielddata": { 
        "filter": {
          "frequency": { 
            "min":              0.01, 
            "min_segment_size": 500  
          }
        }
      }
    }
  }
}
```






