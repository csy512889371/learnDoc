# 86 ElasticSearch  Java API 基于search template实现 

## 概述


搜索模板的功能，java api怎么去调用一个搜索模板

```
page_query_by_brand.mustache

{
  "from": {{from}},
  "size": {{size}},
  "query": {
    "match": {
      "brand.keyword": "{{brand}}" 
    }
  }
}
```

```
SearchResponse sr = new SearchTemplateRequestBuilder(client)
    .setScript("page_query_by_brand")                 
    .setScriptType(ScriptService.ScriptType.FILE) 
    .setScriptParams(template_params)             
    .setRequest(new SearchRequest())              
    .get()                                        
    .getResponse(); 

```

