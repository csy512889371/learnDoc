# 63_基于全局锁实现悲观锁并发控制

## 概述


课程大纲

### 1、悲观锁的简要说明

* 基于version的乐观锁并发控制

* 在数据建模，结合文件系统建模的这个案例，把悲观锁的并发控制，3种锁粒度，都给大家仔细讲解一下

* 最粗的一个粒度，全局锁

```
/workspace/projects/helloworld
```

* 如果多个线程，都过来，要并发地给/workspace/projects/helloworld下的README.txt修改文件名

* 实际上要进行并发的控制，避免出现多线程的并发安全问题，比如多个线程修改，纯并发，先执行的修改操作被后执行的修改操作给覆盖了

```
get current version
```

* 带着这个current version去执行修改，如果一旦发现数据已经被别人给修改了，version号跟之前自己获取的已经不一样了; 那么必须重新获取新的version号再次尝试修改

* 上来就尝试给这条数据加个锁，然后呢，此时就只有你能执行各种各样的操作了，其他人不能执行操作

* 第一种锁：全局锁，直接锁掉整个fs index


### 2、全局锁的上锁实验

```
PUT /fs/lock/global/_create
{}
```

* fs: 你要上锁的那个index
* lock: 就是你指定的一个对这个index上全局锁的一个type
* global: 就是你上的全局锁对应的这个doc的id
* create：强制必须是创建，如果/fs/lock/global这个doc已经存在，那么创建失败，报错


利用了doc来进行上锁


```
/fs/lock/global /index/type/id --> doc

{
  "_index": "fs",
  "_type": "lock",
  "_id": "global",
  "_version": 1,
  "result": "created",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  },
  "created": true
}
```

另外一个线程同时尝试上锁

```
PUT /fs/lock/global/_create
{}
```

```
{
  "error": {
    "root_cause": [
      {
        "type": "version_conflict_engine_exception",
        "reason": "[lock][global]: version conflict, document already exists (current version [1])",
        "index_uuid": "IYbj0OLGQHmMUpLfbhD4Hw",
        "shard": "2",
        "index": "fs"
      }
    ],
    "type": "version_conflict_engine_exception",
    "reason": "[lock][global]: version conflict, document already exists (current version [1])",
    "index_uuid": "IYbj0OLGQHmMUpLfbhD4Hw",
    "shard": "2",
    "index": "fs"
  },
  "status": 409
}
```

* 1、如果失败，就再次重复尝试上锁
* 2、执行各种操作。

```
POST /fs/file/1/_update
{
  "doc": {
    "name": "README1.txt"
  }
}
```

```
{
  "_index": "fs",
  "_type": "file",
  "_id": "1",
  "_version": 2,
  "result": "updated",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  }
}
```

DELETE /fs/lock/global

```
{
  "found": true,
  "_index": "fs",
  "_type": "lock",
  "_id": "global",
  "_version": 2,
  "result": "deleted",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  }
}
```

另外一个线程，因为之前发现上锁失败，反复尝试重新上锁，终于上锁成功了，因为之前获取到全局锁的那个线程已经delete /fs/lock/global全局锁了

```
PUT /fs/lock/global/_create
{}
```

```
{
  "_index": "fs",
  "_type": "lock",
  "_id": "global",
  "_version": 3,
  "result": "created",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  },
  "created": true
}
```

```
POST /fs/file/1/_update 
{
  "doc": {
    "name": "README.txt"
  }
}
```

```
{
  "_index": "fs",
  "_type": "file",
  "_id": "1",
  "_version": 3,
  "result": "updated",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  }
}
```

DELETE /fs/lock/global

### 3、全局锁的优点和缺点

* 优点：操作非常简单，非常容易使用，成本低
* 缺点：你直接就把整个index给上锁了，这个时候对index中所有的doc的操作，都会被block住，导致整个系统的并发能力很低

上锁解锁的操作不是频繁，然后每次上锁之后，执行的操作的耗时不会太长，用这种方式，方便


