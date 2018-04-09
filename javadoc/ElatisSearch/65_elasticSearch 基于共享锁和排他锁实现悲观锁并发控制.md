# 65_基于document锁实现悲观锁并发控制



## 概述


### 1、对document level锁，详细的讲解

全局锁，一次性就锁整个index，对这个index的所有增删改操作都会被block住，如果上锁不频繁，还可以，比较简单

细粒度的一个锁，document锁，顾名思义，每次就锁你要操作的，你要执行增删改的那些doc，doc锁了，其他线程就不能对这些doc执行增删改操作了
但是你只是锁了部分doc，其他线程对其他的doc还是可以上锁和执行增删改操作的

document锁，是用脚本进行上锁

```
POST /fs/lock/1/_update
{
  "upsert": { "process_id": 123 },
  "script": "if ( ctx._source.process_id != process_id ) { assert false }; ctx.op = 'noop';"
  "params": {
    "process_id": 123
  }
}
```

/fs/lock，是固定的，就是说fs下的lock type，专门用于进行上锁
/fs/lock/id，比如1，id其实就是你要上锁的那个doc的id，代表了某个doc数据对应的lock（也是一个doc）
update + upsert：执行upsert操作

params，里面有个process_id，process_id，是你的要执行增删改操作的进程的唯一id，比如说可以在java系统，启动的时候，给你的每个线程都用UUID自动生成一个thread id，你的系统进程启动的时候给整个进程也分配一个UUID。process_id + thread_id就代表了某一个进程下的某个线程的唯一标识。可以自己用UUID生成一个唯一ID

process_id很重要，会在lock中，设置对对应的doc加锁的进程的id，这样其他进程过来的时候，才知道，这条数据已经被别人给锁了

assert false，不是当前进程加锁的话，则抛出异常
ctx.op='noop'，不做任何修改

如果该document之前没有被锁，/fs/lock/1之前不存在，也就是doc id=1没有被别人上过锁; upsert的语法，那么执行index操作，创建一个/fs/lock/id这条数据，而且用params中的数据作为这个lock的数据。process_id被设置为123，script不执行。这个时候象征着process_id=123的进程已经锁了一个doc了。

如果document被锁了，就是说/fs/lock/1已经存在了，代表doc id=1已经被某个进程给锁了。那么执行update操作，script，此时会比对process_id，如果相同，就是说，某个进程，之前锁了这个doc，然后这次又过来，就可以直接对这个doc执行操作，说明是该进程之前锁的doc，则不报错，不执行任何操作，返回success; 如果process_id比对不上，说明doc被其他doc给锁了，此时报错

/fs/lock/1
{
  "process_id": 123
}

POST /fs/lock/1/_update
{
  "upsert": { "process_id": 123 },
  "script": "if ( ctx._source.process_id != process_id ) { assert false }; ctx.op = 'noop';"
  "params": {
    "process_id": 123
  }
}


script：ctx._source.process_id，123
process_id：加锁的upsert请求中带过来额proess_id

如果两个process_id相同，说明是一个进程先加锁，然后又过来尝试加锁，可能是要执行另外一个操作，此时就不会block，对同一个process_id是不会block，ctx.op= 'noop'，什么都不做，返回一个success

如果说已经有一个进程加了锁了

/fs/lock/1
{
  "process_id": 123
}

POST /fs/lock/1/_update
{
  "upsert": { "process_id": 123 },
  "script": "if ( ctx._source.process_id != process_id ) { assert false }; ctx.op = 'noop';"
  "params": {
    "process_id": 234
  }
}

"script": "if ( ctx._source.process_id != process_id ) { assert false }; ctx.op = 'noop';"

ctx._source.process_id：123
process_id: 234

process_id不相等，说明这个doc之前已经被别人上锁了，process_id=123上锁了; process_id=234过来再次尝试上锁，失败，assert false，就会报错

此时遇到报错的process，就应该尝试重新上锁，直到上锁成功

有报错的话，如果有些doc被锁了，那么需要重试

直到所有锁定都成功，执行自己的操作。。。

释放所有的锁

### 2、上document锁的完整实验过程

scripts/judge-lock.groovy: if ( ctx._source.process_id != process_id ) { assert false }; ctx.op = 'noop';

POST /fs/lock/1/_update
{
  "upsert": { "process_id": 123 },
  "script": {
    "lang": "groovy",
    "file": "judge-lock", 
    "params": {
      "process_id": 123
    }
  }
}

{
  "_index": "fs",
  "_type": "lock",
  "_id": "1",
  "_version": 1,
  "result": "created",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  }
}

GET /fs/lock/1

{
  "_index": "fs",
  "_type": "lock",
  "_id": "1",
  "_version": 1,
  "found": true,
  "_source": {
    "process_id": 123
  }
}

POST /fs/lock/1/_update
{
  "upsert": { "process_id": 234 },
  "script": {
    "lang": "groovy",
    "file": "judge-lock", 
    "params": {
      "process_id": 234
    }
  }
}

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
      "reason": "error evaluating judge-lock",
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

POST /fs/lock/1/_update
{
  "upsert": { "process_id": 123 },
  "script": {
    "lang": "groovy",
    "file": "judge-lock", 
    "params": {
      "process_id": 123
    }
  }
}

{
  "_index": "fs",
  "_type": "lock",
  "_id": "1",
  "_version": 1,
  "result": "noop",
  "_shards": {
    "total": 0,
    "successful": 0,
    "failed": 0
  }
}

POST /fs/file/1/_update
{
  "doc": {
    "name": "README1.txt"
  }
}

{
  "_index": "fs",
  "_type": "file",
  "_id": "1",
  "_version": 4,
  "result": "updated",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  }
}

POST /fs/_refresh 

GET /fs/lock/_search?scroll=1m
{
  "query": {
    "term": {
      "process_id": 123
    }
  }
}

{
  "_scroll_id": "DnF1ZXJ5VGhlbkZldGNoBQAAAAAAACPkFjRvbnNUWVZaVGpHdklqOV9zcFd6MncAAAAAAAAj5RY0b25zVFlWWlRqR3ZJajlfc3BXejJ3AAAAAAAAI-YWNG9uc1RZVlpUakd2SWo5X3NwV3oydwAAAAAAACPnFjRvbnNUWVZaVGpHdklqOV9zcFd6MncAAAAAAAAj6BY0b25zVFlWWlRqR3ZJajlfc3BXejJ3",
  "took": 51,
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
        "_index": "fs",
        "_type": "lock",
        "_id": "1",
        "_score": 1,
        "_source": {
          "process_id": 123
        }
      }
    ]
  }
}

PUT /fs/lock/_bulk
{ "delete": { "_id": 1}}

{
  "took": 20,
  "errors": false,
  "items": [
    {
      "delete": {
        "found": true,
        "_index": "fs",
        "_type": "lock",
        "_id": "1",
        "_version": 2,
        "result": "deleted",
        "_shards": {
          "total": 2,
          "successful": 1,
          "failed": 0
        },
        "status": 200
      }
    }
  ]
}

POST /fs/lock/1/_update
{
  "upsert": { "process_id": 234 },
  "script": {
    "lang": "groovy",
    "file": "judge-lock", 
    "params": {
      "process_id": 234
    }
  }
}

process_id=234上锁就成功了

