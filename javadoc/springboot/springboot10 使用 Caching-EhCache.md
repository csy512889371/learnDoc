# 用 Caching-EhCache 

Spring boot 支持的缓存：
* Generic
* JCache (JSR-107)
* EhCache 2.x
* Hazelcast
* Infinispan
* Couchbase
* Redis
* Caffeine
* Guava
* Simple

#  添加依赖
 ```xml
 <!-- caching -->
  <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-cache</artifactId>
  </dependency>
  <dependency>
      <groupId>net.sf.ehcache</groupId>
      <artifactId>ehcache</artifactId>
  </dependency>
```
# 配置文件：
```xml
spring.cache.type=ehcache
spring.cache.ehcache.config=classpath:config/ehcache.xml
```

ehcache.xml
```xml
<ehcache xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:noNamespaceSchemaLocation="ehcache.xsd">
<cache name="codeCache"
eternal="false"
maxEntriesLocalHeap="0"
timeToIdleSeconds="50"></cache>
<!-- eternal：true表示对象永不过期，此时会忽略timeToIdleSeconds和timeToLiveSeconds属性，默认为false -->
<!-- maxEntriesLocalHeap：堆内存中最大缓存对象数，0没有限制 -->

<!-- timeToIdleSeconds： 设定允许对象处于空闲状态的最长时间，以秒为单位。
当对象自从最近一次被访问后，如果处于空闲状态的时间超过了timeToIdleSeconds属性值，这个对象就会过期，EHCache将把它从缓存中清空。
只有当eternal属性为false，该属性才有效。如果该属性值为0，则表示对象可以无限期地处于空闲状态 -->
</ehcache>
```

# 启用注解支持：
@EnableCaching：启用缓存注解

```java
@EnableCaching
@SpringBootApplication
public class BlogApiBootJpaDataApplication {

	public static void main(String[] args) {
		SpringApplication.run(BlogApiBootJpaDataApplication.class, args);
	}
}
```

# 代码实现： 

```java

@CacheConfig(cacheNames = "codeCache")
@Repository
public class UserLogCacheImpl implements UserLogCache {
@Autowired
private UserLogDao userLogDao;

@Cacheable(key = "#p0")
@Override
public UserLog selectById(Integer id) {
    
}
@CachePut(key = "#p0")
@Override
public UserLog updateById(UserLog userLog) {

}
@CacheEvict(key = "#p0")
@Override
public String deleteById(Integer id) {

}

```

# 注解说明：
* @CacheConfig：缓存配置
* @Cacheable：应用到读取数据的方法上，即可缓存的方法，如查找方法：先从缓存中读取，如果没有再调用方法获取数据，然后把数据添加到缓存中。适用于查找
* @CachePut：主要针对方法配置，能够根据方法的请求参数对其结果进行缓存，和 @Cacheable 不同的是，它每次都会触发真实方法的调用。适用于更新和插入
* @CacheEvict：主要针对方法配置，能够根据一定的条件对缓存进行清空。适用于删除
