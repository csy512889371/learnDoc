# 生产准备-基于HTTP的监控

# 利用Spring Boot的特性进行监控你的应用
* 通过HTTP（最简单方便）
* 通过JMX
* 通过远程shell

# 添加依赖

```xml
    <!-- actuator -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
    <!-- security -->
	<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-security</artifactId>
	</dependency>

```

# 配置
端点的配置
```xml
endpoints.sensitive=true
endpoints.shutdown.enabled=true

#保护端点
security.basic.enabled=true
security.user.name=roncoo
security.user.password=roncoo
management.security.roles=SUPERUSER

#自定义路径
security.basic.path=/manage
management.context-path=/manage

```
五、	备注
度量： http://localhost:8081/manage/metrics
追踪： http://localhost:8081/manage/trace
