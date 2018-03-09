# Redis管道Pipeline使用

* 重要说明: 使用管道发送命令时，服务器将被迫回复一个队列答复，占用很多内存。所以，如果你需要发送大量的命令，最好是把他们按照合理数量分批次的处理，例如10K的命令，读回复，然后再发送另一个10k的命令，等等。

* 项目地址： https://github.com/csy512889371/learndemo/tree/master/ctoedu-redis


## 关于Pipeline 同步数据的问题
* A、Pipeline 有与redis形同的操作，但是在数据落盘的时候需要在执行的方法后添加sync()方法，如果insert时有多条数据，在数据拼接完之后，在执行sync()方法，这样可以提高效率。
* B、如果在hget()时没有sync()时会报，没有在hget()同步数据
* C、如果在hset(),hdel(),hget()获取数据时都没有执行sync()方法，但是在最后执行了pl.close()方法，Pipeline 同样会执行sync()方法

## 相关代码
* 不用pipeline存储数据
* 用pipeline存储数据
* 直接使用Jedis hgetall
* 使用pipeline hgetall

```java
public static void main(String[] args) {
        Jedis jedis = new CtoeduJedisPool().getJedis();
        Map<String, String> data = new HashMap<String, String>();

        //不用pipeline存储数据
        //选择redis的库
        jedis.select(4);
        jedis.flushDB();
        long start = System.currentTimeMillis();
        for (int i = 0; i < 100000; i++) {
            data.clear();
            data.put("k_" + i, "v_" + i);
            jedis.hmset("k_" + i, data);
        }
        long end = System.currentTimeMillis();
        System.out.println("datasize=" + jedis.dbSize());
        System.out.println("hmset without pipeline used=" + (end - start) / 1000 + "seconds!");

        //用pipeline存储数据
        jedis.select(4);
        jedis.flushDB();
        Pipeline pipeline = jedis.pipelined();
        start = System.currentTimeMillis();
        for (int i = 0; i < 100000; i++) {
            data.clear();
            data.put("k_" + i, "v_" + i);
            pipeline.hmset("k_" + i, data);
        }
        pipeline.sync();
        end = System.currentTimeMillis();
        System.out.println("datasize=" + jedis.dbSize());
        System.out.println("hmset with pipeline used=" + (end - start) / 1000 + "seconds!");


        Set<String> keys = jedis.keys("*");
        // 直接使用Jedis hgetall
        start = System.currentTimeMillis();
        Map<String, Map<String, String>> result = new HashMap<String, Map<String, String>>();
        for (String key : keys) {
            result.put(key, jedis.hgetAll(key));
        }
        end = System.currentTimeMillis();
        System.out.println("result size:[" + result.size() + "] ..");
        System.out.println("hgetAll without pipeline used [" + (end - start) / 1000 + "] seconds ..");
        
		// 使用pipeline hgetall
        Map<String, Response<Map<String, String>>> responses =
                new HashMap<String, Response<Map<String, String>>>(
                        keys.size());
        result.clear();
        start = System.currentTimeMillis();
        for (String key : keys) {
            responses.put(key, pipeline.hgetAll(key));
        }
        pipeline.sync();
        for (String k : responses.keySet()) {
            result.put(k, responses.get(k).get());
        }
        end = System.currentTimeMillis();
        System.out.println("result size:[" + result.size() + "] ..");
        System.out.println("hgetAll with pipeline used [" + (end - start) / 1000 + "] seconds ..");
        jedis.disconnect();
    }

```


