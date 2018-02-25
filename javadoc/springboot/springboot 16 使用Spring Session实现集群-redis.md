# spring boot 2.0.0.M7 使用Spring Session实现集群-redis

# session集群的解决方案：
1.扩展指定server
* 利用Servlet容器提供的插件功能，自定义HttpSession的创建和管理策略，并通过配置的方式替换掉默认的策略。缺点：耦合Tomcat/Jetty等Servlet容器，不能随意更换容器。

2.利用Filter
* 利用HttpServletRequestWrapper，实现自己的 getSession()方法，接管创建和管理Session数据的工作。spring-session就是通过这样的思路实现的。

Spring Boot中spring session支持方式：
* JDBC、MongoDB、Redis、Hazelcast、HashMap


# 添加依赖
```xml
		<!-- spring session -->
		<dependency>
			<groupId>org.springframework.session</groupId>
			<artifactId>spring-session-core</artifactId>
			<version>${spring-session-data-redis}</version>
		</dependency>

		<dependency>
			<groupId>org.springframework.session</groupId>
			<artifactId>spring-session-data-redis</artifactId>
			<version>${spring-session-data-redis}</version>
		</dependency>

		<!-- redis -->
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-data-redis</artifactId>
		</dependency>
```

# enableRedisKeyspaceNotificationsInitializer 异常
* spring-session中间件需要依赖redis2.8.0以上版本，并且需要开启：notify-keyspace-events
* 如果spring-session使用的是redis集群环境，且redis集群环境没有开启Keyspace notifications功能，则应用启动时会抛出如下异常：

```xml
@Configuration  
public class HttpSessionConfig {  
    @Bean  
    public static ConfigureRedisAction configureRedisAction() {  
        return ConfigureRedisAction.NO_OP;  
    }  
}  
```

# 配置

```xml
# spring session使用存储类型
#spring.session.store-type=redis
# spring session刷新模式：默认on-save
#spring.session.redis.flush-mode=on-save
#spring.session.redis.namespace= 


#redis
#spring.redis.host=localhost
#spring.redis.port=6379
#spring.redis.password=123456
#spring.redis.database=0
#spring.redis.pool.max-active=8 
#spring.redis.pool.max-idle=8 
#spring.redis.pool.max-wait=-1 
#spring.redis.pool.min-idle=0 
#spring.redis.timeout=0
```

```java
@SpringBootConfiguration
//maxInactiveIntervalInSeconds为SpringSession的过期时间（单位：秒）
@EnableRedisHttpSession(maxInactiveIntervalInSeconds= 1800)
public class RedisSessionConfig {

    @Bean
    public static ConfigureRedisAction configureRedisAction() {
        return ConfigureRedisAction.NO_OP;
    }
}
```

# 测试
    @RequestMapping(value = "/index")
	public String index(ModelMap map, HttpSession httpSession) {
		map.put("title", "第一个应用：sessionID=" + httpSession.getId());
		System.out.println("sessionID=" + httpSession.getId());
		return "index";
	}

