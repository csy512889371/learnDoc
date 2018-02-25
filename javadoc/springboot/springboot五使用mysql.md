# mysql关系型数据库-JdbcTemplate 

## 配置数据源：
> 嵌入式数据库的支持：Spring Boot 可以自动配置 H2, HSQL and Derby 数据库，不需要提供任何的链接 URLs，只需要加入相应的 jar 包，Spring boot 可以自动发现装配

```xml
<!-- 数据库 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jdbc</artifactId>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <scope>runtime</scope>
</dependency>

```
mysql

```xml
spring.datasource.url=jdbc:mysql://localhost/spring_boot_demo?useUnicode=true&character
Encoding=utf-8
spring.datasource.username=root
spring.datasource.password=123456
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
```

**注**：
* 1.可以不指定 driver-class-name，spring boot 会自动识别 url。
* 2.数据连接池默认使用 tomcat-jdbc
* 连接池的配置： spring.datasource.tomcat.* 

## JdbcTemplate 模板

```java
  // 自动注册
  @Autowired
  private JdbcTemplate jdbcTemplate;
```

## sql 日志

> 在logback 中加入 org.springframework.jdbc.core.JdbcTemplate
```xml
	<springProfile name="dev">
		<appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
			<encoder>
				<pattern>${PATTERN}</pattern>
			</encoder>
		</appender>
		
		<logger name="com.roncoo.education" level="debug"/>
		<logger name="org.springframework.jdbc.core.JdbcTemplate" level="debug"/>

		<root level="info">
			<appender-ref ref="CONSOLE" />
		</root>
	</springProfile>
```

# springdata 参考

> https://docs.spring.io/spring-data/jpa/docs/1.10.2.RELEASE/reference/html/