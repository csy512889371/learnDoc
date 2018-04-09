# 62_elasticSearch 对文件系统进行数据建模以及文件搜索实战


## 概述

数据建模，对类似文件系统这种的有多层级关系的数据进行建模

### 1、文件系统数据构造

```
PUT /fs
{
  "settings": {
    "analysis": {
      "analyzer": {
        "paths": { 
          "tokenizer": "path_hierarchy"
        }
      }
    }
  }
}
```

path_hierarchy tokenizer讲解

* /a/b/c/d --> path_hierarchy -> /a/b/c/d, /a/b/c, /a/b, /a
* fs: filesystem

```
PUT /fs/_mapping/file
{
  "properties": {
    "name": { 
      "type":  "keyword"
    },
    "path": { 
      "type":  "keyword",
      "fields": {
        "tree": { 
          "type":     "text",
          "analyzer": "paths"
        }
      }
    }
  }
}
```

```
PUT /fs/file/1
{
  "name":     "README.txt", 
  "path":     "/workspace/projects/helloworld", 
  "contents": "这是我的第一个elasticsearch程序"
}
```

### 2、对文件系统执行搜索

文件搜索需求：查找一份，内容包括elasticsearch，在/workspace/projects/hellworld这个目录下的文件

```
GET /fs/file/_search 
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "contents": "elasticsearch"
          }
        },
        {
          "constant_score": {
            "filter": {
              "term": {
                "path": "/workspace/projects/helloworld"
              }
            }
          }
        }
      ]
    }
  }
}
```


```

{
  "took": 2,
  "timed_out": false,
  "_shards": {
    "total": 5,
    "successful": 5,
    "failed": 0
  },
  "hits": {
    "total": 1,
    "max_score": 1.284885,
    "hits": [
      {
        "_index": "fs",
        "_type": "file",
        "_id": "1",
        "_score": 1.284885,
        "_source": {
          "name": "README.txt",
          "path": "/workspace/projects/helloworld",
          "contents": "这是我的第一个elasticsearch程序"
        }
      }
    ]
  }
}
```

搜索需求2：搜索/workspace目录下，内容包含elasticsearch的所有的文件

```
/workspace/projects/helloworld    doc1
/workspace/projects               doc1
/workspace                        doc1
```


```
GET /fs/file/_search 
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "contents": "elasticsearch"
          }
        },
        {
          "constant_score": {
            "filter": {
              "term": {
                "path.tree": "/workspace"
              }
            }
          }
        }
      ]
    }
  }
}

```