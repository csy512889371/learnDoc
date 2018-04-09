# 65_基于共享锁和排他锁实现悲观锁并发控制


## 概述

### 1、共享锁和排他锁的说明


#### 共享锁

共享锁：这份数据是共享的，然后多个线程过来，都可以获取同一个数据的共享锁，然后对这个数据执行读操作


#### 排他锁

排他锁：是排他的操作，只能一个线程获取排他锁，然后执行增删改操作

#### 读写锁的分离*

* 如果只是要读取数据的话，那么任意个线程都可以同时进来然后读取数据，每个线程都可以上一个共享锁
* 但是这个时候，如果有线程要过来修改数据，那么会尝试上排他锁，排他锁会跟共享锁互斥，也就是说，如果有人已经上了共享锁了，那么排他锁就不能上，就得等

* 如果有人在读数据，就不允许别人来修改数据
* 反之，也是一样的

* 如果有人在修改数据，就是加了排他锁
* 那么其他线程过来要修改数据，也会尝试加排他锁，此时会失败，锁冲突，必须等待，同时只能有一个线程修改数据
* 如果有人过来同时要读取数据，那么会尝试加共享锁，此时会失败，因为共享锁和排他锁是冲突的
* 如果有在修改数据，就不允许别人来修改数据，也不允许别人来读取数据

### 2、共享锁和排他锁的实验

第一步：有人在读数据，其他人也能过来读数据

```
judge-lock-2.groovy: if (ctx._source.lock_type == 'exclusive') { assert false }; ctx._source.lock_count++
```

```
POST /fs/lock/1/_update 
{
  "upsert": { 
    "lock_type":  "shared",
    "lock_count": 1
  },
  "script": {
    "lang": "groovy",
    "file": "judge-lock-2"
  }
}
```

```
POST /fs/lock/1/_update 
{
  "upsert": { 
    "lock_type":  "shared",
    "lock_count": 1
  },
  "script": {
    "lang": "groovy",
    "file": "judge-lock-2"
  }
}
```

```
GET /fs/lock/1

{
  "_index": "fs",
  "_type": "lock",
  "_id": "1",
  "_version": 3,
  "found": true,
  "_source": {
    "lock_type": "shared",
    "lock_count": 3
  }
}
```

就给大家模拟了，有人上了共享锁，你还是要上共享锁，直接上就行了，没问题，只是lock_count加1

第二步、已经有人上了共享锁，然后有人要上排他锁

```
PUT /fs/lock/1/_create
{ "lock_type": "exclusive" }
```

排他锁用的不是upsert语法，create语法，要求lock必须不能存在，直接自己是第一个上锁的人，上的是排他锁

```
{
  "error": {
    "root_cause": [
      {
        "type": "version_conflict_engine_exception",
        "reason": "[lock][1]: version conflict, document already exists (current version [3])",
        "index_uuid": "IYbj0OLGQHmMUpLfbhD4Hw",
        "shard": "3",
        "index": "fs"
      }
    ],
    "type": "version_conflict_engine_exception",
    "reason": "[lock][1]: version conflict, document already exists (current version [3])",
    "index_uuid": "IYbj0OLGQHmMUpLfbhD4Hw",
    "shard": "3",
    "index": "fs"
  },
  "status": 409
}
```

如果已经有人上了共享锁，明显/fs/lock/1是存在的，create语法去上排他锁，肯定会报错

第三步、对共享锁进行解锁

```

POST /fs/lock/1/_update
{
  "script": {
    "lang": "groovy",
    "file": "unlock-shared"
  }
}
```

连续解锁3次，此时共享锁就彻底没了

每次解锁一个共享锁，就对lock_count先减1，如果减了1之后，是0，那么说明所有的共享锁都解锁完了，此时就就将/fs/lock/1删除，就彻底解锁所有的共享锁

第四步、上排他锁，再上排他锁

```
PUT /fs/lock/1/_create
{ "lock_type": "exclusive" }
```

其他线程

```
PUT /fs/lock/1/_create
{ "lock_type": "exclusive" }
```

```
{
  "error": {
    "root_cause": [
      {
        "type": "version_conflict_engine_exception",
        "reason": "[lock][1]: version conflict, document already exists (current version [7])",
        "index_uuid": "IYbj0OLGQHmMUpLfbhD4Hw",
        "shard": "3",
        "index": "fs"
      }
    ],
    "type": "version_conflict_engine_exception",
    "reason": "[lock][1]: version conflict, document already exists (current version [7])",
    "index_uuid": "IYbj0OLGQHmMUpLfbhD4Hw",
    "shard": "3",
    "index": "fs"
  },
  "status": 409
}
```

第五步、上排他锁，上共享锁

```
POST /fs/lock/1/_update 
{
  "upsert": { 
    "lock_type":  "shared",
    "lock_count": 1
  },
  "script": {
    "lang": "groovy",
    "file": "judge-lock-2"
  }
}

```

```
{
  "error": {
    "root_cause": [
      {
        "type": "remote_transport_exception",
        "reason": "[4onsTYV][127.0.0.1:9300][indices:data/write/update[s]]"
      }
    ],
    "type": "illegal_argument_exception",
    "reason": "failed to execute script",
    "caused_by": {
      "type": "script_exception",
      "reason": "error evaluating judge-lock-2",
      "caused_by": {
        "type": "power_assertion_error",
        "reason": "assert false\n"
      },
      "script_stack": [],
      "script": "",
      "lang": "groovy"
    }
  },
  "status": 400
}
```

第六步、解锁排他锁

```
DELETE /fs/lock/1
```

