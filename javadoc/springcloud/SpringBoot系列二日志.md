# spring 日志

>* 支持日志框架：Java Util Logging, Log4J2 and Logback，默认是使用logback
>* 配置方式：默认配置文件配置和引用外部配置文件配置

# 一、Logback

## 默认配置文件配置

>* 不建议使用：不够灵活，对log4j2等不够友好

```xml

# 日志文件名，比如：eva.log，或者是 /var/log/eva.log
logging.file=eva.log 
# 日志级别配置，比如： logging.level.org.springframework=DEBUG
logging.level.*=info
logging.level.org.springframework=DEBUG

```

## 引用外部配置文件

>* spring boot默认会加载classpath:logback-spring.xml或者classpath:logback-spring.groovy
>* 使用自定义配置文件，配置方式为

```xml
logging.config=classpath:logback-eva.xml
注意：不要使用logback这个来命名，否则spring boot将不能完全实例化
```

## 使用基于spring boot的配置
```xml

<?xml version="1.0" encoding="UTF-8"?>
<configuration>
<include resource="org/springframework/boot/logging/logback/base.xml"/>
<logger name="org.springframework.web" level="DEBUG"/>
</configuration>

```

> logback-eva.xml

```xml

<?xml version="1.0" encoding="UTF-8"?>
<configuration>

	<!-- 文件输出格式 -->
	<property name="PATTERN" value="%-12(%d{yyyy-MM-dd HH:mm:ss.SSS}) |-%-5level [%thread] %c [%L] -| %msg%n" />
	<!-- test文件路径 -->
	<property name="TEST_FILE_PATH" value="d:/opt/eva/logs" />
	<!-- pro文件路径 -->
	<property name="PRO_FILE_PATH" value="/opt/eva/logs" />

	<!-- 开发环境 -->
	<springProfile name="dev">
		<appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
			<encoder>
				<pattern>${PATTERN}</pattern>
			</encoder>
		</appender>
		
		<logger name="com.eva.learn" level="debug"/>

		<root level="info">
			<appender-ref ref="CONSOLE" />
		</root>
	</springProfile>

	<!-- 测试环境 -->
	<springProfile name="test">
		<!-- 每天产生一个文件 -->
		<appender name="TEST-FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
			<!-- 文件路径 -->
			<file>${TEST_FILE_PATH}</file>
			<rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
				<!-- 文件名称 -->
				<fileNamePattern>${TEST_FILE_PATH}/info.%d{yyyy-MM-dd}.log</fileNamePattern>
				<!-- 文件最大保存历史数量 -->
				<MaxHistory>100</MaxHistory>
			</rollingPolicy>
			
			<layout class="ch.qos.logback.classic.PatternLayout">
				<pattern>${PATTERN}</pattern>
			</layout>
		</appender>
		
		<root level="info">
			<appender-ref ref="TEST-FILE" />
		</root>
	</springProfile>

	<!-- 生产环境 -->
	<springProfile name="prod">
		<appender name="PROD_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
			<file>${PRO_FILE_PATH}</file>
			<rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
				<fileNamePattern>${PRO_FILE_PATH}/warn.%d{yyyy-MM-dd}.log</fileNamePattern>
				<MaxHistory>100</MaxHistory>
			</rollingPolicy>
			<layout class="ch.qos.logback.classic.PatternLayout">
				<pattern>${PATTERN}</pattern>
			</layout>
		</appender>
		
		<root level="warn">
			<appender-ref ref="PROD_FILE" />
		</root>
	</springProfile>
</configuration>

```

# 二、Log4j


> 去除logback的依赖包，添加log4j2的依赖包

```xml
		<exclusions>
			<exclusion>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-starter-logging</artifactId>
			</exclusion>
		</exclusions>

		<!-- 使用log4j2 -->
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-log4j2</artifactId>
		</dependency>

```

>* 在classpath添加log4j2.xml或者log4j2-spring.xml（spring boot 默认加载）

## 应用自定义配置

```xml
# 应用自定义配置
logging.config=classpath:log4j2-dev.xml
```
log4j2-dev.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
	<properties>
		<!-- 文件输出格式 -->
		<property name="PATTERN">%d{yyyy-MM-dd HH:mm:ss.SSS} |-%-5level [%thread] %c [%L] -| %msg%n</property>
	</properties>

	<appenders>
		<Console name="CONSOLE" target="system_out">
			<PatternLayout pattern="${PATTERN}" />
		</Console>
	</appenders>
	
	<loggers>
		<logger name="com.roncoo.education" level="debug" />
		<root level="info">
			<appenderref ref="CONSOLE" />
		</root>
	</loggers>

</configuration>
```


# 比较 Logback 与 Log4J2
>* 性能比较：Log4J2 和 Logback都优于 log4j（不推荐使用）
>* 配置方式：Logback最简洁，spring boot默认，推荐使用








