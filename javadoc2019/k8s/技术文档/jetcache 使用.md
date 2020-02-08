#### jetcache 介绍

Jetcache主要表现在

* 分布式缓存和内存型缓存可以共存，当共存时，优先访问内存，保护远程缓存；也可以只用某一种，分布式 or 内存
* 自动刷新策略，防止某个缓存失效，访问量突然增大时，所有机器都去访问数据库，可能导致数据库挂掉
* 利用不严格的分布式锁，对同一key，全局只有一台机器自动刷新


jetcache 特性

- 通过注解实现声明式的方法缓存，支持TTL和两级缓存
- 分布式缓存自动刷新，分布式锁 (2.2+)
- 支持异步Cache API
- Spring Boot支持
- Key的生成策略和Value的序列化策略是可以定制的
- 针对所有Cache实例和方法缓存的自动统计



**例子代码:**

http://39.100.254.140:12011/loit-Infrastructure-example/loit-mybatis-example



##### 组件整合


pom 引入Jar

```
            <dependency>
                <groupId>com.timeloit.project</groupId>
                <artifactId>loit-component-jetcache-client</artifactId>
                <version>1.0-SNAPSHOT</version>
            </dependency>

```

配置文件

```
# jetcache使用
jetcache:
  areaInCacheName: false
  # 控制台输出统计数据，统计间隔，0表示不统计
  statIntervalMinutes: 1
  local:
    default:
      limit: 300
      expireAfterWriteInMillis: 100000
      # 缓存类型。tair、redis为当前支持的远程缓存；linkedhashmap、caffeine为当前支持的本地缓存类型
      type: linkedhashmap
      keyConvertor: fastjson
  remote:
    default:
      keyConvertor: fastjson
      valueEncoder: java
      valueDecoder: java
      poolConfig:
        minIdle: 5
        maxIdle: 20
        maxTotal: 50
      type: redis.lettuce
      uri: redis://portal2019@39.100.254.140:6379/
      #redis://password@127.0.0.1:6379/0
      
      
```


ITStorageCacheService

```
/**
 * 仓库Cache服务
 */
public interface ITStorageCacheService {

    TStorage getStorageCache(Integer storageId);

    void removeCache(Integer storageId);
}
```

CacheType 说明

* BOTH 表示使用二级缓存
* LOCAL 表示使用本地缓存
* REMOTE 表示使用远程缓存
* cacheType为REMOTE或者BOTH的时候，刷新行为是全局唯一的，也就是说，即使应用服务器是一个集群，也不会出现多个服务器同时去刷新一个key的情况。
* 一个key的刷新任务，自该key首次被访问后初始化，如果该key长时间不被访问，在stopRefreshAfterLastAccess指定的时间后，相关的刷新任务就会被自动移除，这样就避免了浪费资源去进行没有意义的刷新。




expire : TTL（超时时间）默认单位TimeUnit.SECONDS （秒）

```
@Service("iTStorageCacheService")
public class ITStorageCacheServiceImpl implements ITStorageCacheService {

    @Resource(name = "iTStorageService")
    private ITStorageService itStorageService;

    @CreateCache(expire = 100, cacheType = CacheType.BOTH)
    private Cache<Integer, TStorage> storageCache;

    @Override
    public TStorage getStorageCache(Integer storageId) {
        return storageCache.get(storageId);
    }

    @Override
    public void removeCache(Integer id) {
        storageCache.remove(id);
    }

    @PostConstruct
    public void init() {
        // 自动刷新
        RefreshPolicy policy = RefreshPolicy.newPolicy(15, TimeUnit.MINUTES).stopRefreshAfterLastAccess(30, TimeUnit.MINUTES);
        storageCache.config().setLoader(this::loadMenuByUserFromDatabase);
        storageCache.config().setRefreshPolicy(policy);
    }

    private TStorage loadMenuByUserFromDatabase(Integer id) {
        return itStorageService.getById(id);
    }

}
```



##### 使用说明



![image-20200207173501229](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\jetcache 使用.assets\image-20200207173501229.png)

和Spring Cache很像，不过@Cached注解原生支持了TTL（超时时间），cacheType有LOCAL/REMOTE/BOTH三种选择，

分别代表本地内存/远程Cache Server（例如Redis）/两级缓存，可根据情况选用，合理的使用LOCAL或BOTH类型可以降低Cache Server的压力以及我们提供的服务的响应时间。

通过注解的方式。

* 注解毕竟不能提供最灵活的控制，所以JetCache提供了Cache API



![image-20200207171707314](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\jetcache 使用.assets\image-20200207171707314.png)



JetCache提供了Cache API，使用起来就像Map一样:

```
UserDO user = userCache.get(12345L);
userCache.put(12345L,loadUserFromDataBase(12345L));
userCache.remove(12345L);
userCache.computeIfAbsent(1234567L, (key) -> loadUserFromDataBase(1234567L));
```



Cache实例可以通过注解创建：

```
@CreateCache(expire = 100, cacheType = CacheType.BOTH, localLimit = 50)private Cache userCache;
```



也可以通过和guava cache/caffeine类似的builder来创建：

```
GenericObjectPoolConfig pc = new GenericObjectPoolConfig();
pc.setMinIdle(2);
pc.setMaxIdle(10);
pc.setMaxTotal(10);

JedisPool pool = new JedisPool(pc, "localhost", 6379);
Cache userCache = RedisCacheBuilder.createRedisCacheBuilder() .keyConvertor(FastjsonKeyConvertor.INSTANCE) 
.valueEncoder(JavaValueEncoder.INSTANCE) 
.valueDecoder(JavaValueDecoder.INSTANCE) 
.jedisPool(pool) 
.keyPrefix("userCache-") 
.expireAfterWrite(200, TimeUnit.SECONDS) 
.buildCache();

```

Cache接口支持异步：

```
CacheGetResult r = cache.GET(userId);
CompletionStage future = r.future();
future.thenRun(() -> { if(r.isSuccess()){ System.out.println(r.getValue()); }});
```

可以实现不严格的分布式锁：

```
cache.tryLockAndRun("key", 60, TimeUnit.SECONDS, () -> heavyDatabaseOperation());
```

使用Cache API也可以做自动刷新哦：

![image-20200207172926585](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\jetcache 使用.assets\image-20200207172926585.png)



如果没有使用注解，用builder一样也可以做出自动刷新：

```
Cache orderSumCache = RedisCacheBuilder.createRedisCacheBuilder() ......省略 .refreshPolicy(RefreshPolicy.newPolicy(60, TimeUnit.SECONDS)) .loader(this::loadOrderSumFromDatabase) .buildCache();
```



当前支持的缓存系统包括以下4个，而且要支持一种新的缓存也是非常容易的：

- Caffeine（基于本地内存）
- LinkedHashMap（基于本地内存，JetCache自己实现的简易LRU缓存）
- Alibaba Tair（相关实现未在Github开源，在阿里内部Gitlab上可以找到）
- Redis