## 74_使用search template将搜索模板化

## 概述

搜索模板，search template，高级功能，就可以将我们的一些搜索进行模板化，然后的话，每次执行这个搜索，就直接调用模板，给传入一些参数就可以了

### 1、search template入门

```
GET /blog_website/blogs/_search/template
{
  "inline" : {
    "query": { 
      "match" : { 
        "{{field}}" : "{{value}}" 
      } 
    }
  },
  "params" : {
      "field" : "title",
      "value" : "博客"
  }
}
```

```
GET /blog_website/blogs/_search
{
  "query": { 
    "match" : { 
      "title" : "博客" 
    } 
  }
}
```

search template："{{field}}" : "{{value}}" 

### 2、toJson

```
GET /blog_website/blogs/_search/template
{
  "inline": "{\"query\": {\"match\": {{#toJson}}matchCondition{{/toJson}}}}",
  "params": {
    "matchCondition": {
      "title": "博客"
    }
  }
}
```

```
GET /blog_website/blogs/_search
{
  "query": { 
    "match" : { 
      "title" : "博客" 
    } 
  }
}
```

### 3、join

```
GET /blog_website/blogs/_search/template
{
  "inline": {
    "query": {
      "match": {
        "title": "{{#join delimiter=' '}}titles{{/join delimiter=' '}}"
      }
    }
  },
  "params": {
    "titles": ["博客", "网站"]
  }
}
```

博客,网站

```
GET /blog_website/blogs/_search
{
  "query": { 
    "match" : { 
      "title" : "博客 网站" 
    } 
  }
}
```

### 4、default value

```
POST /blog_website/blogs/1/_update
{
  "doc": {
    "views": 5
  }
}
```

```

GET /blog_website/blogs/_search/template
{
  "inline": {
    "query": {
      "range": {
        "views": {
          "gte": "{{start}}",
          "lte": "{{end}}{{^end}}20{{/end}}"
        }
      }
    }
  },
  "params": {
    "start": 1,
    "end": 10
  }
}
```

```
GET /blog_website/blogs/_search
{
  "query": {
    "range": {
      "views": {
        "gte": 1,
        "lte": 10
      }
    }
  }
}

```

```
GET /blog_website/blogs/_search/template
{
  "inline": {
    "query": {
      "range": {
        "views": {
          "gte": "{{start}}",
          "lte": "{{end}}{{^end}}20{{/end}}"
        }
      }
    }
  },
  "params": {
    "start": 1
  }
}
```


```

GET /blog_website/blogs/_search
{
  "query": {
    "range": {
      "views": {
        "gte": 1,
        "lte": 20
      }
    }
  }
}

```

### 5、conditional

es的config/scripts目录下，预先保存这个复杂的模板，后缀名是.mustache，文件名是conditonal

```
{
  "query": {
    "bool": {
      "must": {
        "match": {
          "line": "{{text}}" 
        }
      },
      "filter": {
        {{#line_no}} 
          "range": {
            "line_no": {
              {{#start}} 
                "gte": "{{start}}" 
                {{#end}},{{/end}} 
              {{/start}} 
              {{#end}} 
                "lte": "{{end}}" 
              {{/end}} 
            }
          }
        {{/line_no}} 
      }
    }
  }
}
```

```
GET /my_index/my_type/_search 

{
  "took": 4,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "failed": 0
  },
  "hits": {
    "total": 1,
    "max_score": 1,
    "hits": [
      {
        "_index": "my_index",
        "_type": "my_type",
        "_id": "1",
        "_score": 1,
        "_source": {
          "line": "我的博客",
          "line_no": 5
        }
      }
    ]
  }
}
```

```
GET /my_index/my_type/_search/template
{
  "file": "conditional",
  "params": {
    "text": "博客",
    "line_no": true,
    "start": 1,
    "end": 10
  }
}
```

### 6、保存search template

config/scripts，.mustache 



