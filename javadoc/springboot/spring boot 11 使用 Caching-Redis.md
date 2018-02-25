# 添加依赖

```java
<!-- redis -->
<dependency>
<groupId>org.springframework.boot</groupId>
<artifactId>spring-boot-starter-redis</artifactId>
</dependency>

```
# 配置文件：
spring.cache.type=redis

# 缓存使用优先级问题
* 1.默认按照 spring boot 的加载顺序来实现
* 2.配置文件优先于默认

# 自定义缓存管理器 

```java
public class RedisCacheConfiguration extends CachingConfigurerSupport {

	@Autowired
	private RedisConnectionFactory connectionFactory;

	/**
	 * 缓存管理器
	 * @return CacheManager
	 */
	@Bean
	public CacheManager cacheManager() {
		RedisCacheManagerBuilder builder = RedisCacheManagerBuilder.fromConnectionFactory(connectionFactory);
		Set<String> cacheNames = new HashSet<String>() {{
			add("codeNameCache");
		}};
		builder.initialCacheNames(cacheNames);
		return builder.build();

	}

	/**
	 * @description 自定义的缓存key的生成策略</br>
	 *              若想使用这个key</br>
	 *              只需要讲注解上keyGenerator的值设置为customKeyGenerator即可</br>
	 * @return 自定义策略生成的key
	 */
	@Bean
	public KeyGenerator customKeyGenerator() {
		return (o, method, objects) -> {
			StringBuilder sb = new StringBuilder();
			sb.append(o.getClass().getName());
			sb.append(method.getName());
			for (Object obj : objects) {
				sb.append(obj.toString());
			}
			return sb.toString();
		};
	}


}
```



