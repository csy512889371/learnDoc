# Elastic Search partial update

## 概述

### 1、什么是partial update

PUT /index/type/id，创建文档&替换文档，就是一样的语法

一般对应到应用程序中，每次的执行流程基本是这样的：

* 1）应用程序先发起一个get请求，获取到document，展示到前台界面，供用户查看和修改
* 2）用户在前台界面修改数据，发送到后台
* 3）后台代码，会将用户修改的数据在内存中进行执行，然后封装好修改后的全量数据
* 4）然后发送PUT请求，到es中，进行全量替换
* 5）es将老的document标记为deleted，然后重新创建一个新的document

### 2 例子


partial update

```
post /index/type/id/_update 
{
   "doc": {
      "要修改的少数几个field即可，不需要全量的数据"
   }
}
```

看起来，好像就比较方便了，每次就传递少数几个发生修改的field即可，不需要将全量的document数据发送过去

### 3、例子 partial update

```
PUT /test_index/test_type/10
{
  "test_field1": "test1",
  "test_field2": "test2"
}
```

```
POST /test_index/test_type/10/_update
{
  "doc": {
    "test_field2": "updated test2"
  }
}
```

