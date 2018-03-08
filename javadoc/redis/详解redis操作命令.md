# 详解redis操作命令

## 一、登录
```shell
[root@bigdata1 bin]# ./redis-cli     本机登录
[root@bigdata1 bin]# ./redis-cli -h 127.0.0.1 -p 6379 –a password   远程登录
127.0.0.1:6379> quit    退出
```
## 二、数据类型
Redis支持五种数据类型：string（字符串），hash（哈希），list（列表），set（集合）及zset(sorted set：有序集合)。

### 1、String（字符串）
* String（字符串）：string是redis最基本的类型，你可以理解成与Memcached一模一样的类型，一个key对应一个value。
* string类型是二进制安全的。意思是redis的string可以包含任何数据。比如jpg图片或者序列化的对象 。
* String类型是Redis最基本的数据类型，一个键最大能存储512MB。


### 2、Hash（哈希）：
* Redis hash 是一个键值(key=>value)对集合。
* Redis hash是一个string类型的field和value的映射表，hash特别适合用于存储对象。
* 每个 hash 可以存储 232 -1 键值对（40多亿）。


### 3、List（列表）：
* Redis 列表是简单的字符串列表，按照插入顺序排序。你可以添加一个元素到列表的头部（左边）或者尾部（右边）。
* 列表最多可存储 232 - 1 元素 (4294967295, 每个列表可存储40多亿)。


### 4、Set（集合）：
* Redis的Set是string类型的无序集合。
* 集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是O(1)。


### 5、Zset（有序集合）：
* Redis zset 和 set 一样也是string类型元素的集合,且不允许重复的成员。
* 不同的是每个元素都会关联一个double类型的分数。redis正是通过分数来为集合中的成员进行从小到大的排序。
* zset的成员是唯一的,但分数(score)却可以重复。



## 三、命令介绍

### 1、String（字符串）：
127.0.0.1:6379> SET key "value"  设置key
127.0.0.1:6379> GET key    读取key
127.0.0.1:6379> GETRANGE key 0 3    读取key对应的value前四个字符
127.0.0.1:6379>GETSET db mongodb   设定key的value，并返回旧value，没有旧值，返回nil
127.0.0.1:6379> MGET key1 key2  返回一个或者多个给定的key值

### 2、Hash（哈希）：
127.0.0.1:6379> HMSET myhash field1 "Hello" field2 "World"  同时将多个 field-value (字段-值)对设置到哈希表中。
127.0.0.1:6379> HGET KEY_NAME FIELD_NAME  用于返回哈希表中指定字段的值
127.0.0.1:6379> HEXISTS myhash field1  哈希表含有给定字段，返回 1 。 如果哈希表不含有给定字段，或 key 不存在，返回 0
127.0.0.1:6379> HKEYS myhash   获取哈希表中的所有域（field）

### 3、List（列表）：
127.0.0.1:6379> LPUSH KEY_NAME VALUE1.. VALUEN  将一个或多个值插入到列表头部
127.0.0.1:6379> LRANGE list1 0 -1  返回列表中指定区间内的元素

### 4、Set（集合）：
127.0.0.1:6379> SADD myset "hello"  命令将一个或多个成员元素加入到集合中，已经存在于集合的成员元素将被忽略。
127.0.0.1:6379> SMEMBERS myset1   返回集合中的所有的成员。 不存在的集合 key 被视为空集合。

### 5、Zset（有序集合）：
127.0.0.1:6379>ZADD myzset 2 "two" 3 "three"  用于将一个或多个成员元素及其分数值加入到有序集当中。
127.0.0.1:6379>ZCARD myzset   获取结合中元素的数量。

## 四、封装的redis基本命令

```java
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.context.support.ClassPathXmlApplicationContext;

import redis.clients.jedis.BinaryClient;
import redis.clients.jedis.BinaryClient.LIST_POSITION;
import redis.clients.jedis.JedisCluster;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class redisCluster {
	private static final Log log = LogFactory.getLog(redisCluster.class);
	JedisCluster jedisCluster=null;
	ClassPathXmlApplicationContext context=null;
	/**
	 * 构造函数，初始化jedis连接池
	 */
    public redisCluster(){
    	try{
    		context = new ClassPathXmlApplicationContext("classpath:spring/spring-context.xml");
			context.start();
			jedisCluster = (JedisCluster) context.getBean("jedisCluster");
    	}
        catch(Exception e){
        	log.error("==>redisCluster context start error:", e);
        	context.stop();
        	System.exit(0);
        } 	
    } 
    /**
     * 关闭连接
     */
    public void closeRedisCluster(){
    	jedisCluster.close();
    }
    //Key(键)
    /**
     * 删除指定的key
     * @param key
     * @return 删除的数量
     */
    public Long delete(String key){
    	return jedisCluster.del(key);
    }
    /**
     * 检查指定的key是否存在
     * @param key
     * @return 存在：返回1  不存在：返回0
     */
    public Boolean exists(String key){
    	return jedisCluster.exists(key);
    }
    /**
     * 为给定 key 设置生存时间，当 key 过期时(生存时间为 0 )，它会被自动删除
     * 可以对一个已经带有生存时间的 key 执行 EXPIRE 命令，新指定的生存时间会取代旧的生存时间
     * @param key
     * @param seconds 秒
     * @return 成功:返回1  失败：返回0
     */
    public Long expire(String key,int seconds){
    	return jedisCluster.expire(key, seconds);
    }
    /**
     * EXPIREAT 的作用和 EXPIRE 类似，都用于为 key 设置生存时间
     * 不同在于 EXPIREAT 命令接受的时间参数是 UNIX 时间戳(unix timestamp)
     * @param key
     * @param unixTime  秒
     * @return 成功:返回1  失败：返回0
     */
    public long expireAt(String key,long unixTime){
    	return jedisCluster.expireAt(key, unixTime);
    }
    /**
     * 将当前数据库的 key 移动到给定的数据库 db 当中
     * 如果当前数据库(源数据库)和给定数据库(目标数据库)有相同名字的给定 key ，或者 key 不存在于当前数据库，那么 MOVE 没有任何效果
     * @param key
     * @param dbIndex
     * @return 成功：返回1  失败：返回0
     */
    public Long move(String key,int dbIndex){
    	return jedisCluster.move(key, dbIndex);
    }
    /**
     * 移除给定 key 的生存时间，将这个 key 从『易失的』(带生存时间 key )转换成『持久的』(一个不带生存时间、永不过期的 key )
     * @param key
     * @return  成功：返回1  失败：返回0
     */
    public long persist(String key){
    	return jedisCluster.persist(key);
    }
    /**
     * 为给定 key 设置生存时间，当 key 过期时(生存时间为 0 )，它会被自动删除
     * 可以对一个已经带有生存时间的 key 执行 EXPIRE 命令，新指定的生存时间会取代旧的生存时间
     * @param key
     * @param seconds 毫秒
     * @return 成功:返回1  失败：返回0
     */
    public long pexpire(String key,long milliseconds){
    	return jedisCluster.pexpire(key, milliseconds);
    }
    /**
     * EXPIREAT 的作用和 EXPIRE 类似，都用于为 key 设置生存时间
     * 不同在于 EXPIREAT 命令接受的时间参数是 UNIX 时间戳(unix timestamp)
     * @param key
     * @param unixTime  毫秒
     * @return 成功:返回1  失败：返回0
     */
    public long pexpireAt(String key,long millisecondsTimestamp){
    	return jedisCluster.pexpireAt(key, millisecondsTimestamp);
    }
    /**
     * 返回或保存给定列表、集合、有序集合 key 中经过排序的元素
     * 排序默认以数字作为对象，值被解释为双精度浮点数，然后进行比较
     * @param key
     * @return
     */
    public List<String> sort(String key){
    	return jedisCluster.sort(key);
    }
    /**
     * 以秒为单位，返回给定 key 的剩余生存时间(TTL, time to live)
     * @param key
     * @return key不存在：返回-2   key存在但没有设置生存时间：返回-1   
     */
    public long ttl(String key){
    	return jedisCluster.ttl(key);
    }
    /**
     * 返回 key 所储存的值的类型
     * @param key
     * @return none (key不存在)  string (字符串)  list (列表)  set (集合)  zset (有序集)   hash (哈希表)
     */
    public String type(String key){
    	return jedisCluster.type(key);
    }
    //String(字符串)
    /**
     * 如果 key 已经存在并且是一个字符串， APPEND 命令将 value 追加到 key 原来的值的末尾
     * 如果 key 不存在， APPEND 就简单地将给定 key 设为 value ，就像执行 SET key value 一样
     * @param key
     * @param value
     * @return  追加 value 之后， key 中字符串的长度
     */
    public Long append(String key,String value){
    	return jedisCluster.append(key, value);
    }
    /**
     * 计算给定字符串中，被设置为 1 的比特位的数量
     * @param key
     * @return  被设置为 1 的位的数量
     */
    public Long bitCount(String key){
    	return jedisCluster.bitcount(key);
    }
    /**
     * 通过指定额外的 start 或 end 参数，可以让计数只在特定的位上进行
     * @param key
     * @param start
     * @param end
     * @return 被设置为 1 的位的数量
     */
    public Long bitCount(String key,Long start,Long end){
    	return jedisCluster.bitcount(key, start, end);
    }
    /**
     * 将 key 中储存的数字值减一
     * 如果 key 不存在，那么 key 的值会先被初始化为 0 ，然后再执行 DECR 操作
     * 如果值包含错误的类型，或字符串类型的值不能表示为数字，那么返回一个错误
     * @param key
     * @return  执行 DECR 命令之后 key 的值
     */
    public Long decr(String key){
    	return jedisCluster.decr(key);
    }
    /**
     * 将 key 所储存的值减去减量 decrement 
     * 如果 key 不存在，那么 key 的值会先被初始化为 0 ，然后再执行 DECRBY 操作
     * 如果值包含错误的类型，或字符串类型的值不能表示为数字，那么返回一个错误
     * @param key
     * @param integer
     * @return 减去 decrement 之后， key 的值
     */
    public Long decrBy(String key,long integer){
    	return jedisCluster.decrBy(key, integer);
    }
    /**
     * 返回 key 所关联的字符串值
     * 如果 key 不存在那么返回特殊值 nil 
     * 假如 key 储存的值不是字符串类型，返回一个错误，因为 GET 只能用于处理字符串值
     * @param key
     * @return 当 key 不存在时，返回 nil ，否则，返回 key 的值,如果 key 不是字符串类型，那么返回一个错误
     */
     public String get(String key){
         return jedisCluster.get(key);
     }
     /**
      * 对 key 所储存的字符串值，获取指定偏移量上的位(bit)
      * 当 offset 比字符串值的长度大，或者 key 不存在时，返回 0 
      * @param key
      * @param offset
      * @return 字符串值指定偏移量上的位(bit)
      */
     public Boolean getbit(String key,Long offset){
    	 return jedisCluster.getbit(key, offset);
     }
     /**
      * 返回 key 中字符串值的子字符串，字符串的截取范围由 start 和 end 两个偏移量决定(包括 start 和 end 在内)
      * 负数偏移量表示从字符串最后开始计数， -1 表示最后一个字符， -2 表示倒数第二个，以此类推。
      * @param key
      * @param startOffset
      * @param endOffset
      * @return 截取得出的子字符串
      */
     public String getrange(String key,long startOffset,long endOffset){
     	return jedisCluster.getrange(key, startOffset, endOffset);
     }
     /**
      * 将给定 key 的值设为 value ，并返回 key 的旧值(old value)
      * 当 key 存在但不是字符串类型时，返回一个错误
      * @param key
      * @param value
      * @return 返回给定 key 的旧值,当 key 没有旧值时，也即是， key 不存在时，返回 nil
      */
     public String getSet(String key,String value){
     	return jedisCluster.getSet(key, value);
     }
     /**
      * 将 key 中储存的数字值增一
      * 如果 key 不存在，那么 key 的值会先被初始化为 0 ，然后再执行 INCR 操作
      * 如果值包含错误的类型，或字符串类型的值不能表示为数字，那么返回一个错误
      * @param key
      * @return 执行 INCR 命令之后 key 的值
      */
     public Long incr(String key){
     	return jedisCluster.incr(key);
     }
     /**
      * 将 key 所储存的值加上增量 increment 
      * 如果 key 不存在，那么 key 的值会先被初始化为 0 ，然后再执行 INCRBY 命令
      * 如果值包含错误的类型，或字符串类型的值不能表示为数字，那么返回一个错误
      * @param key
      * @param integer
      * @return 加上 increment 之后， key 的值
      */
     public Long incrBy(String key,long integer){
     	return jedisCluster.incrBy(key, integer);
     }
     /**
      * 为 key 中所储存的值加上浮点数增量 increment 
      * 如果 key 不存在，那么 INCRBYFLOAT 会先将 key 的值设为 0 ，再执行加法操作
      * 如果命令执行成功，那么 key 的值会被更新为（执行加法之后的）新值，并且新值会以字符串的形式返回给调用者
      * @param key
      * @param value
      * @return 执行命令之后 key 的值
      */
    public double incrByFloat(String key,double value){
    	return jedisCluster.incrByFloat(key, value);
    }
    /**
     * 将字符串值 value 关联到 key 
     * 如果 key 已经持有其他值， SET 就覆写旧值，无视类型
     * @param key
     * @param value
     * @return 返回ok
     */
    public String set(String key,String value){    		
   		return jedisCluster.set(key, value);
    }
    /**
     * 对 key 所储存的字符串值，设置或清除指定偏移量上的位(bit)
     * 位的设置或清除取决于 value 参数，可以是 0 也可以是 1 
     * 当 key 不存在时，自动生成一个新的字符串值
     * @param key
     * @param offset
     * @param value
     * @return 指定偏移量原来储存的位
     */
    public Boolean setbit(String key,Long offset,String value){
    	return jedisCluster.setbit(key, offset, value);
    }
    /**
     * 对 key 所储存的字符串值，设置或清除指定偏移量上的位(bit)
     * 位的设置或清除取决于 value 参数，可以是 0 也可以是 1 
     * 当 key 不存在时，自动生成一个新的字符串值
     * @param key
     * @param offset
     * @param value
     * @return 指定偏移量原来储存的位
     */
    public Boolean setbit(String key,long offset,Boolean value){
    	return jedisCluster.setbit(key, offset, value);
    }
    /**
     * 将值 value 关联到 key ，并将 key 的生存时间设为 seconds (以秒为单位)
     * 如果 key 已经存在， SETEX 命令将覆写旧值
     * @param key
     * @param seconds
     * @param value
     * @return 设置成功时返回 OK ,当 seconds 参数不合法时，返回一个错误
     */
    public String setex(String key,int seconds,String value){
    	return jedisCluster.setex(key, seconds, value);
    }   
    /**
     * 将 key 的值设为 value ，当且仅当 key 不存在
     * 若给定的 key 已经存在，则 SETNX 不做任何动作
     * @param key
     * @param value
     * @return 设置成功，返回 1,设置失败，返回 0 
     */
    public Long setnx(String key,String value){
    	return jedisCluster.setnx(key, value);
    }
    /**
     * 用 value 参数覆写(overwrite)给定 key 所储存的字符串值，从偏移量 offset 开始
     * 不存在的 key 当作空白字符串处理
     * @param key
     * @param offset
     * @param value
     * @return 被 SETRANGE 修改之后，字符串的长度
     */
    public Long setrange(String key,Long offset,String value){
    	return jedisCluster.setrange(key, offset, value);
    } 
    /**
     * 返回 key 所储存的字符串值的长度
     * 当 key 储存的不是字符串值时，返回一个错误
     * @param key
     * @return 字符串值的长度,当 key 不存在时，返回 0 
     */
    public Long strlen(String key){
    	return jedisCluster.strlen(key);
    }
    //Hash(哈希表)
    /**
     * 删除哈希表 key 中的一个或多个指定域，不存在的域将被忽略
     * @param key
     * @param fields 格式为：field,field,field....
     * @return 被成功移除的域的数量，不包括被忽略的域
     */
    public Long hdel(String key,String fields){
    	return jedisCluster.hdel(key,fields);
    }
    /**
     * 查看哈希表 key 中，给定域 field 是否存在
     * @param key
     * @param field
     * @return 如果哈希表含有给定域，返回 1,如果哈希表不含有给定域，或 key 不存在，返回 0 
     */
    public Boolean hexists(String key,String field){
    	return jedisCluster.hexists(key, field);
    }
    /**
     * 返回哈希表 key 中给定域 field 的值
     * @param key
     * @param field
     * @return 给定域的值,当给定域不存在或是给定 key 不存在时，返回 nil
     */
    public String hget(String key,String field){
    	return jedisCluster.hget(key, field);
    }
    /**
     * 返回哈希表 key 中，所有的域和值
     * 在返回值里，紧跟每个域名(field name)之后是域的值(value)，所以返回值的长度是哈希表大小的两倍
     * @param key
     * @return 以列表形式返回哈希表的域和域的值,若 key 不存在，返回空列表
     */
    public Map<String,String> hgetAll(String key){
       return jedisCluster.hgetAll(key);
    }
    /**
     * 为哈希表 key 中的域 field 的值加上增量 increment 
     * 增量也可以为负数，相当于对给定域进行减法操作
     * 如果 key 不存在，一个新的哈希表被创建并执行 HINCRBY 命令
     * 如果域 field 不存在，那么在执行命令前，域的值被初始化为 0 
     * 对一个储存字符串值的域 field 执行 HINCRBY 命令将造成一个错误
     * @param key
     * @param field
     * @param value
     * @return 执行 HINCRBY 命令之后，哈希表 key 中域 field 的值
     */
    public Long hincrBy(String key,String field,long value){
    	return jedisCluster.hincrBy(key, field, value);
    }
    /**
     * 返回哈希表 key 中的所有域
     * @param key
     * @return 一个包含哈希表中所有域的表,当 key 不存在时，返回一个空表
     */
    public Set<String> hkeys(String key){
    	return jedisCluster.hkeys(key);
    }
    /**
     * 返回哈希表 key 中域的数量
     * @param key
     * @return 哈希表中域的数量,当 key 不存在时，返回 0
     */
    public Long hlen(String key){
    	return jedisCluster.hlen(key);
    }
    /**
     * 返回哈希表 key 中，一个或多个给定域的值
     * 如果给定的域不存在于哈希表，那么返回一个 nil 值
     * 因为不存在的 key 被当作一个空哈希表来处理，所以对一个不存在的 key 进行 HMGET 操作将返回一个只带有 nil 值的表
     * @param key  
     * @param fields 格式为：field,field,field........
     * @return 一个包含多个给定域的关联值的表，表值的排列顺序和给定域参数的请求顺序一样
     */
    public List<String> hmget(String key,String fields){
    	return jedisCluster.hmget(key, fields);
    }
    /**
     * 同时将多个 field-value (域-值)对设置到哈希表 key 中
     * 此命令会覆盖哈希表中已存在的域
     * 如果 key 不存在，一个空哈希表被创建并执行 HMSET 操作
     * @param key
     * @param fieldValues field,value,field,value....
     * @return 如果命令执行成功，返回 OK ,当 key 不是哈希表(hash)类型时，返回一个错误
     */
    public String hmset(String key,String fieldValues){
    	String[] fieldValue=fieldValues.split(",");
    	Map<String,String> map=new HashMap<String,String>();
    	for(int i=0;i<fieldValue.length;i++){
    		map.put(fieldValue[i],fieldValue[i+1]);
    	}
    	return jedisCluster.hmset(key,map);
    }
    /**
     * 将哈希表 key 中的域 field 的值设为 value
     * 如果 key 不存在，一个新的哈希表被创建并进行 HSET 操作
     * 如果域 field 已经存在于哈希表中，旧值将被覆盖
     * @param key
     * @param field
     * @param value
     * @return 如果 field 是哈希表中的一个新建域，并且值设置成功，返回 1,如果哈希表中域 field 已经存在且旧值已被新值覆盖，返回 0 
     */
    public Long hset(String key,String field,String value){
    	return jedisCluster.hset(key, field, value);
    }
    /**
     * 将哈希表 key 中的域 field 的值设置为 value ，当且仅当域 field 不存在
     * 若域 field 已经存在，该操作无效
     * 如果 key 不存在，一个新哈希表被创建并执行 HSETNX 命令
     * @param key
     * @param field
     * @param value
     * @return  设置成功，返回 1 ,如果给定域已经存在且没有操作被执行，返回 0 
     */
    public Long hsetnx(String key,String field,String value){
    	return jedisCluster.hsetnx(key, field, value);
    }
    /**
     * 返回哈希表 key 中所有域的值
     * @param key
     * @return 一个包含哈希表中所有值的表,当 key 不存在时，返回一个空表
     */
    public List<String> hvals(String key){   	
    	return jedisCluster.hvals(key);
    }
    //List(列表)
    /**
     *  LPOP 命令的阻塞版本，当给定列表内没有任何元素可供弹出的时候，连接将被 BLPOP 命令阻塞，直到等待超时或发现可弹出元素为止
     * @param timeout 超时时间，设置为0 表示无限制等待
     * @param key
     * @return
     */
    public String blpop(int timeout,String key){
    	List<String> value=jedisCluster.blpop(timeout, key);
    	return value.get(0);
    }
    /**
     *  RPOP 命令的阻塞版本，当给定列表内没有任何元素可供弹出的时候，连接将被 BLPOP 命令阻塞，直到等待超时或发现可弹出元素为止
     * @param timeout 超时时间，设置为0 表示无限制等待
     * @param key
     * @return
     */
    public String brpop(int timeout,String key){
    	List<String> value=jedisCluster.brpop(timeout, key);
    	return value.get(0);
    }
    /**
     * 返回列表 key 中，下标为 index 的元素。
     *下标(index)参数 start 和 stop 都以 0 为底，也就是说，以 0 表示列表的第一个元素，以 1 表示列表的第二个元素，以此类推
     *你也可以使用负数下标，以 -1 表示列表的最后一个元素， -2 表示列表的倒数第二个元素，以此类推
     *如果 key 不是列表类型，返回一个错误
     * @param key
     * @param index
     * @return
     */
    public String lindex(String key,long index){
    	return jedisCluster.lindex(key, index);
    }
    /**
     * 将值 value 插入到列表 key 当中，位于值 pivot 之前或之后
     * 当 pivot 不存在于列表 key 时，不执行任何操作
     * 当 key 不存在时， key 被视为空列表，不执行任何操作
     * 如果 key 不是列表类型，返回一个错误
     * @param key
     * @param where  值为BEFORE或者AFTER
     * @param pivot
     * @param value
     * @return 成功：返回list长度  无pivot：返回-1   key不存在或者空列表：返回0 where输入错误：返回-2
     */
    public long linsert(String key,String where,String pivot,String value){
        long result=-2;
    	if(where.toUpperCase()=="BEFORE"){
           result=jedisCluster.linsert(key,LIST_POSITION.BEFORE, pivot, value);
    	}
    	else if(where.toUpperCase()=="AFTER"){
    	   result=jedisCluster.linsert(key,LIST_POSITION.AFTER, pivot, value);
    	}
    	return result;
    }
    /**
     * 返回列表 key 的长度
     * 如果 key 不存在，则 key 被解释为一个空列表，返回 0 
     * 如果 key 不是列表类型，返回一个错误
     * @param key
     * @return
     */
    public long llen(String key){
    	return jedisCluster.llen(key);
    }
    /**
     * 移除并返回列表 key 的头元素
     * @param key
     * @return
     */
    public String lpop(String key){
    	return jedisCluster.lpop(key);
    }
    /**
     * 将一个或多个值 value 插入到列表 key 的表头
     * 如果 key 不存在，一个空列表会被创建并执行 LPUSH 操作
     * 当 key 存在但不是列表类型时，返回一个错误
     * @param key
     * @param values  要插入的value的组合，格式为：value,value,......
     * @return 列表长度
     */
    public long lpush(String key,String values){
    	return jedisCluster.lpush(key,values);
    }
    /**
     * 将值 value 插入到列表 key 的表头
     * @param key
     * @param value
     * @return 列表长度
     */
    public long lpushx(String key,String value){
    	return jedisCluster.lpushx(key, value);
    }
    /**
     * 返回列表 key 中指定区间内的元素，区间以偏移量 start 和 stop 指定
     * 下标(index)参数 start 和 stop 都以 0 为底，也就是说，以 0 表示列表的第一个元素，以 1 表示列表的第二个元素，以此类推
     * 你也可以使用负数下标，以 -1 表示列表的最后一个元素， -2 表示列表的倒数第二个元素，以此类推。
     * @param key
     * @param start
     * @param stop
     * @return
     */
    public List<String> lrange(String key,long start,long stop){
    	return jedisCluster.lrange(key, start, stop);
    }
    /**
     * count > 0 : 从表头开始向表尾搜索，移除与 value 相等的元素，数量为 count 
     * count < 0 : 从表尾开始向表头搜索，移除与 value 相等的元素，数量为 count 的绝对值
     * count = 0 : 移除表中所有与 value 相等的值
     * @param key
     * @param count
     * @param value
     * @return  被移除元素的数量
     */
    public long lrem(String key,long count,String value){
    	return jedisCluster.lrem(key, count, value);
    }
    /**
     * 将列表 key 下标为 index 的元素的值设置为 value 
     * 当 index 参数超出范围，或对一个空列表( key 不存在)进行 LSET 时，返回一个错误
     * @param key
     * @param index
     * @param value
     * @return
     */
    public String lset(String key,long index,String value){
    	return jedisCluster.lset(key, index, value);
    }
    /**
     * 对一个列表进行修剪(trim)，就是说，让列表只保留指定区间内的元素，不在指定区间之内的元素都将被删除
     * @param key
     * @param start
     * @param end
     * @return 成功返回OK
     */
    public String ltrim(String key,long start,long end){
    	return jedisCluster.ltrim(key, start, end);
    }
    /**
     * 移除并返回列表 key 的尾元素
     * 当 key 不存在时，返回 nil
     * @param key
     * @return
     */
    public String rpop(String key){
    	return jedisCluster.rpop(key);
    }
    /**
     * 将一个或多个值 value 插入到列表 key 的表尾
     * 如果 key 不存在，一个空列表会被创建并执行 RPUSH 操作
     * 当 key 存在但不是列表类型时，返回一个错误
     * @param key
     * @param values  要插入的value的组合，格式为：value,value,......
     * @return 列表长度
     */
    public long rpush(String key,String values){
    	return jedisCluster.rpush(key,values);
    }
    /**
     * 将值 value 插入到列表 key 的表尾
     * @param key
     * @param value
     * @return 列表长度
     */
    public long rpushx(String key,String value){
    	return jedisCluster.rpushx(key, value);
    }
    //Set(集合)
    /**
     * 将一个或多个 member 元素加入到集合 key 当中，已经存在于集合的 member 元素将被忽略
     * 假如 key 不存在，则创建一个只包含 member 元素作成员的集合
     * 当 key 不是集合类型时，返回一个错误
     * @param key
     * @param members 格式为：member,member,.......
     * @return 被添加到集合中的新元素的数量，不包括被忽略的元素
     */
    public long sadd(String key,String members){
    	return jedisCluster.sadd(key, members);
    }
    /**
     * 返回集合 key 的基数(集合中元素的数量)
     * @param key
     * @return 集合的基数,当 key 不存在时，返回 0 
     */
    public long scard(String key){
    	return jedisCluster.scard(key);
    }
    /**
     * 判断 member 元素是否集合 key 的成员
     * @param key
     * @param member
     * @return 如果 member 元素是集合的成员，返回 1,如果 member 元素不是集合的成员，或 key 不存在，返回 0
     */
    public Boolean sismember(String key,String member){
    	return jedisCluster.sismember(key, member);
    }
    /**
     * 返回集合 key 中的所有成员,不存在的 key 被视为空集合
     * @param key
     * @return 集合中的所有成员
     */
    public Set<String> smembers(String key){
    	return jedisCluster.smembers(key);
    }
    /**
     * 移除并返回集合中的一个随机元素
     * @param key
     * @return 被移除的随机元素,当 key 不存在或 key 是空集时，返回 nil 
     */
    public String spop(String key){
    	return jedisCluster.spop(key);
    }
    /**
     * 移除并返回集合中的一个随机元素
     * @param key
     * @return 被移除的随机元素,当 key 不存在或 key 是空集时，返回 nil 
     */
    public Set<String> spop(String key,long count){
    	return jedisCluster.spop(key, count);
    }
    /**
     * 只提供了 key 参数，那么返回集合中的一个随机元素, 不做删除
     * @param key
     * @return 返回一个元素；如果集合为空，返回 nil 
     */
    public String srandMember(String key){
    	return jedisCluster.srandmember(key);
    }
    /**
     * 如果 count 为正数，且小于集合基数，那么命令返回一个包含 count 个元素的数组，数组中的元素各不相同。如果 count 大于等于集合基数，那么返回整个集合
     * 如果 count 为负数，那么命令返回一个数组，数组中的元素可能会重复出现多次，而数组的长度为 count 的绝对值
     * @param key
     * @param count
     * @return 返回一个数组；如果集合为空，返回空数组
     */
    public List<String> srandMember(String key,int count){
    	return jedisCluster.srandmember(key, count);
    }
    /**
     * 返回一个数组；如果集合为空，返回空数组
     * @param key
     * @param members 格式为：member,member,......
     * @return 被成功移除的元素的数量，不包括被忽略的元素
     */
    public long srem(String key,String members){
    	return jedisCluster.srem(key, members);
    }
    //SortedSet(有序集合)
    /**
     * 将一个member 元素及其 score 值加入到有序集 key 当中
     * 如果某个 member 已经是有序集的成员，那么更新这个 member 的 score 值，并通过重新插入这个 member 元素，来保证该 member 在正确的位置上
     * @param key
     * @param score
     * @param member
     * @return 被成功添加的新成员的数量，不包括那些被更新的、已经存在的成员
     */
    public long zadd(String key,double score,String member){
    	return jedisCluster.zadd(key, score, member);
    }
    /**
     * 将一个或多个 member 元素及其 score 值加入到有序集 key 当中
     * 如果某个 member 已经是有序集的成员，那么更新这个 member 的 score 值，并通过重新插入这个 member 元素，来保证该 member 在正确的位置上
     * @param key
     * @param scoreMembers 格式为：member,score,member,score,......
     * @return 被成功添加的新成员的数量，不包括那些被更新的、已经存在的成员
     */
    public long zadd(String key,String scoreMembers){
    	String[] scoreMember=scoreMembers.split(",");
    	Map<String,Double> map=new HashMap<String,Double>();
    	for(int i=0;i<scoreMember.length;i++){
    		map.put(scoreMember[i],Double.valueOf(scoreMember[i+1]));
    	}
    	return jedisCluster.zadd(key, map);
    }
    /**
     * 返回有序集 key 的基数
     * @param key
     * @return 当 key 存在且是有序集类型时，返回有序集的基数,当 key 不存在时，返回 0 
     */
    public long zcard(String key){
    	return jedisCluster.zcard(key);
    }
    /**
     * 返回有序集 key 中， score 值在 min 和 max 之间(默认包括 score 值等于 min 或 max )的成员的数量
     * @param key
     * @param min
     * @param max
     * @return score 值在 min 和 max 之间的成员的数量
     */
    public long zcount(String key,double min,double max){
    	return jedisCluster.zcount(key, min, max);
    }
    /**
     * 为有序集 key 的成员 member 的 score 值加上增量 increment 
     * 可以通过传递一个负数值 increment ，让 score 减去相应的值，比如 ZINCRBY key -5 member ，就是让 member 的 score 值减去 5 
     * 当 key 不存在，或 member 不是 key 的成员时， ZINCRBY key increment member 等同于 ZADD key increment member 
     * 当 key 不是有序集类型时，返回一个错误
     * @param key
     * @param score
     * @param member
     * @return member 成员的新 score 值
     */
    public double zincrby(String key,double increment,String member){
    	return jedisCluster.zincrby(key, increment, member);
    }
    /**
     * 返回有序集 key 中，指定区间内的成员,其中成员的位置按 score 值递增(从小到大)来排序
     * 具有相同 score 值的成员按字典序(lexicographical order )来排列
     * 下标参数 start 和 stop 都以 0 为底，也就是说，以 0 表示有序集第一个成员，以 1 表示有序集第二个成员，以此类推。
     * 你也可以使用负数下标，以 -1 表示最后一个成员， -2 表示倒数第二个成员，以此类推
     * @param key
     * @param start
     * @param end
     * @return 指定区间内，带有 score 值(可选)的有序集成员的列表
     */
    public Set<String> zrange(String key,long start,long end){
    	return jedisCluster.zrange(key, start, end);
    }
    /**
     * 返回有序集 key 中，所有 score 值介于 min 和 max 之间(包括等于 min 或 max )的成员。有序集成员按 score 值递增(从小到大)次序排列
     * @param key
     * @param min
     * @param max
     * @return 指定区间内，带有 score 值(可选)的有序集成员的列表
     */
    public Set<String> zrangeByScore(String key,String min,String max){
    	return jedisCluster.zrangeByScore(key, min, max);
    }
    /**
     * 返回有序集 key 中，所有 score 值介于 min 和 max 之间(包括等于 min 或 max )的成员。有序集成员按 score 值递增(从小到大)次序排列
     * @param key
     * @param min
     * @param max
     * @return 指定区间内，带有 score 值(可选)的有序集成员的列表
     */
    public Set<String> zrangeByScore(String key,double min,double max){
    	return jedisCluster.zrangeByScore(key, min, max);
    }
    /**
     * 返回有序集 key 中，所有 score 值介于 min 和 max 之间(包括等于 min 或 max )的成员。有序集成员按 score 值递增(从小到大)次序排列
     * 可选的 LIMIT 参数指定返回结果的数量及区间(就像SQL中的 SELECT LIMIT offset, count )，注意当 offset 很大时，定位 offset 的操作可能需要遍历整个有序集，此过程最坏复杂度为 O(N) 时间
     * @param key
     * @param min
     * @param max
     * @return 指定区间内，带有 score 值(可选)的有序集成员的列表
     */
    public Set<String> zrangeByScore(String key,String min,String max,int offset,int count){
    	return jedisCluster.zrangeByScore(key, min, max, offset, count);
    }
    /**
     * 返回有序集 key 中，所有 score 值介于 min 和 max 之间(包括等于 min 或 max )的成员。有序集成员按 score 值递增(从小到大)次序排列
     * 可选的 LIMIT 参数指定返回结果的数量及区间(就像SQL中的 SELECT LIMIT offset, count )，注意当 offset 很大时，定位 offset 的操作可能需要遍历整个有序集，此过程最坏复杂度为 O(N) 时间
     * @param key
     * @param min
     * @param max
     * @return 指定区间内，带有 score 值(可选)的有序集成员的列表
     */
    public Set<String> zrangeByScore(String key,double min,double max,int offset,int count){
    	return jedisCluster.zrangeByScore(key, min, max, offset, count);
    }
    /**
     * 返回有序集 key 中成员 member 的排名。其中有序集成员按 score 值递增(从小到大)顺序排列
     * 排名以 0 为底，也就是说， score 值最小的成员排名为 0
     * @param key
     * @param member
     * @return
     */
    public long zrank(String key,String member){
    	return jedisCluster.zrank(key, member);
    }
    /**
     * 移除有序集 key 中的一个或多个成员，不存在的成员将被忽略
     * 当 key 存在但不是有序集类型时，返回一个错误
     * @param key
     * @param members 格式为：member,member,......
     * @return 被成功移除的成员的数量，不包括被忽略的成员
     */
    public long zrem(String key,String members){
    	return jedisCluster.zrem(key, members);
    }
    /**
     * 移除有序集 key 中，指定排名(rank)区间内的所有成员
     * 区间分别以下标参数 start 和 stop 指出，包含 start 和 stop 在内
     * @param key
     * @param start
     * @param end
     * @return 被移除成员的数量
     */
    public long zremRangeByRank(String key,long start,long end){
    	return jedisCluster.zremrangeByRank(key, start, end);
    }
    /**
     * 移除有序集 key 中，所有 score 值介于 min 和 max 之间(包括等于 min 或 max )的成员。
     * @param key
     * @param start
     * @param end
     * @return 被移除成员的数量
     */
    public long zremRangeByScore(String key,String start,String end){
    	return jedisCluster.zremrangeByScore(key, start, end);
    }
    /**
     * 移除有序集 key 中，所有 score 值介于 min 和 max 之间(包括等于 min 或 max )的成员。
     * @param key
     * @param start
     * @param end
     * @return 被移除成员的数量
     */
    public long zremRangeByScore(String key,double start,double end){
    	return jedisCluster.zremrangeByScore(key, start, end);
    }
    /**
     * 返回有序集 key 中，指定区间内的成员
     * 其中成员的位置按 score 值递减(从大到小)来排列
     * @param key
     * @param start
     * @param end
     * @return 指定区间内，带有 score 值(可选)的有序集成员的列表
     */
    public Set<String> zrevRange(String key,long start,long end){
    	return jedisCluster.zrevrange(key, start, end);
    }
    /**
     * 返回有序集 key 中，所有 score 值介于 max 和 min 之间(包括等于 max 或 min )的成员。有序集成员按 score 值递减(从大到小)次序排列
     * @param key
     * @param min
     * @param max
     * @return 指定区间内，带有 score 值(可选)的有序集成员的列表
     */
    public Set<String> zrevrangeByScore(String key,String max,String min){
    	return jedisCluster.zrevrangeByScore(key, max, min);
    }
    /**
     * 返回有序集 key 中，所有 score 值介于 max 和 min 之间(包括等于 max 或 min )的成员。有序集成员按 score 值递减(从大到小)次序排列
     * @param key
     * @param min
     * @param max
     * @return 指定区间内，带有 score 值(可选)的有序集成员的列表
     */
    public Set<String> zrevrangeByScore(String key,double max,double min){
    	return jedisCluster.zrevrangeByScore(key, max, min);
    }
    /**
     * 返回有序集 key 中，所有 score 值介于 max 和 min 之间(包括等于 max 或 min )的成员。有序集成员按 score 值递减(从大到小)次序排列
     * 可选的 LIMIT 参数指定返回结果的数量及区间(就像SQL中的 SELECT LIMIT offset, count )，注意当 offset 很大时，定位 offset 的操作可能需要遍历整个有序集，此过程最坏复杂度为 O(N) 时间
     * @param key
     * @param min
     * @param max
     * @return 指定区间内，带有 score 值(可选)的有序集成员的列表
     */
    public Set<String> zrevrangeByScore(String key,String max,String min,int offset,int count){
    	return jedisCluster.zrevrangeByScore(key, max,min , offset, count);
    }
    /**
     * 返回有序集 key 中，所有 score 值介于 max 和 min 之间(包括等于 max 或 min )的成员。有序集成员按 score 值递减(从大到小)次序排列
     * 可选的 LIMIT 参数指定返回结果的数量及区间(就像SQL中的 SELECT LIMIT offset, count )，注意当 offset 很大时，定位 offset 的操作可能需要遍历整个有序集，此过程最坏复杂度为 O(N) 时间
     * @param key
     * @param min
     * @param max
     * @return 指定区间内，带有 score 值(可选)的有序集成员的列表
     */
    public Set<String> zrevrangeByScore(String key,double max,double min,int offset,int count){
    	return jedisCluster.zrevrangeByScore(key, max, min, offset, count);
    }
    /**
     * 返回有序集 key 中成员 member 的排名。其中有序集成员按 score 值递减(从大到小)排序
     * 排名以 0 为底，也就是说， score 值最大的成员排名为 0 
     * @param key
     * @param member
     * @return 如果 member 是有序集 key 的成员，返回 member 的排名,如果 member 不是有序集 key 的成员，返回 nil
     */
    public long zrevRank(String key,String member){
    	return jedisCluster.zrevrank(key, member);
    }
    /**
     * 返回有序集 key 中，成员 member 的 score 值
     * 如果 member 元素不是有序集 key 的成员，或 key 不存在，返回 nil 
     * @param key
     * @param member
     * @return member 成员的 score 值
     */
    public Double zscore(String key,String member){
    	return jedisCluster.zscore(key, member);
    }
    //Connection(连接)
    /**
     * 通过设置配置文件中 requirepass 项的值(使用命令 CONFIG SET requirepass password )，可以使用密码来保护 Redis 服务器
     * 如果开启了密码保护的话，在每次连接 Redis 服务器之后，就要使用 AUTH 命令解锁，解锁之后才能使用其他 Redis 命令
     * 如果 AUTH 命令给定的密码 password 和配置文件中的密码相符的话，服务器会返回 OK 并开始接受命令输入
     * 另一方面，假如密码不匹配的话，服务器将返回一个错误，并要求客户端需重新输入密码。
     * @param password
     * @return 密码匹配时返回 OK ，否则返回一个错误
     */
	public String auth(String password){
    	return jedisCluster.auth(password);
    }
	/**
	 * 打印一个特定的信息 message ，测试时使用
	 * @param message
	 * @return message 自身
	 */
	public String echo(String message){
		return jedisCluster.echo(message);
	}
	/**
	 * 使用客户端向 Redis 服务器发送一个 PING ，如果服务器运作正常的话，会返回一个 PONG 
	 * 通常用于测试与服务器的连接是否仍然生效，或者用于测量延迟值
	 * @return 如果连接正常就返回一个 PONG ，否则返回一个连接错误
	 */
	public String ping(){
		return jedisCluster.ping();
	}
	/**
	 * 请求服务器关闭与当前客户端的连接
	 * 一旦所有等待中的回复(如果有的话)顺利写入到客户端，连接就会被关闭
	 * @return 总是返回 OK
	 */
	public String quit(){
		return jedisCluster.quit();
	}
	/**
	 * 切换到指定的数据库，数据库索引号 index 用数字值指定，以 0 作为起始索引值,默认使用 0 号数据库
	 * @param index
	 * @return ok
	 */
	public String select(int index){
		return jedisCluster.select(index);
	}
	//Server(服务器)
	/**
	 * 执行一个 AOF文件 重写操作。重写会创建一个当前 AOF 文件的体积优化版本
	 * @return 反馈信息
	 */
	public String bgreWriteAof(){
		return jedisCluster.bgrewriteaof();
	}
	/**
	 * 在后台异步(Asynchronously)保存当前数据库的数据到磁盘
	 * BGSAVE 命令执行之后立即返回 OK ，然后 Redis fork 出一个新子进程，原来的 Redis 进程(父进程)继续处理客户端请求，而子进程则负责将数据保存到磁盘，然后退出
	 * @return 反馈信息
	 */
	public String bgSave(){
		return jedisCluster.bgsave();
	}
	/**
	 * 返回当前数据库的 key 的数量
	 * @return 当前数据库的 key 的数量
	 */
	public long dbSize(){
		return jedisCluster.dbSize();
	}
	/**
	 * 清空整个 Redis 服务器的数据(删除所有数据库的所有 key )
	 * @return 总是返回 OK
	 */
	public String flushAll(){
		return jedisCluster.flushAll();
	}
	/**
	 * 清空当前数据库中的所有 key
	 * @return 总是返回 OK
	 */
	public String flushDB(){
		return jedisCluster.flushDB();
	}
	/**
	 * 返回关于 Redis 服务器的各种信息和统计数值
	 * @return
	 */
	public String info(){
		return jedisCluster.info();
	}
	/**
	 * 以一种易于解释（parse）且易于阅读的格式，返回关于 Redis 服务器的各种信息和统计数值
	 * @param section
	 * @return
	 */
	public String info(String section){
		return jedisCluster.info(section);
	}
	/**
	 * 返回最近一次 Redis 成功将数据保存到磁盘上的时间，以 UNIX 时间戳格式表示
	 * @return
	 */
	public long lastsave(){
		return jedisCluster.lastsave();
	}
	/**
	 * SAVE 命令执行一个同步保存操作，将当前 Redis 实例的所有数据快照(snapshot)以 RDB 文件的形式保存到硬盘
	 * @return 保存成功时返回 OK 
	 */
	public String save(){
		return jedisCluster.save();
	}
	/**
	 * SHUTDOWN 命令执行以下操作：停止所有客户端
	 * 如果有至少一个保存点在等待，执行 SAVE 命令
	 * 如果 AOF 选项被打开，更新 AOF 文件
	 * 关闭 redis 服务器(server)
	 * 如果持久化被打开的话， SHUTDOWN 命令会保证服务器正常关闭而不丢失任何数据
	 * @return 执行失败时返回错误,执行成功时不返回任何信息，服务器和客户端的连接断开，客户端自动退出
	 */
	public String shutdown(){
		return jedisCluster.shutdown();
	}
	/**
	 * SLAVEOF 命令用于在 Redis 运行时动态地修改复制(replication)功能的行为
	 * 通过执行 SLAVEOF host port 命令，可以将当前服务器转变为指定服务器的从属服务器(slave server)
	 * @param host
	 * @param port
	 * @return 总是返回 OK 
	 */
	public String slaveof(String host,int port){
		return jedisCluster.slaveof(host, port);
	}
}

```