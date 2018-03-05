# Spring boot 日志


## 一、spring boot默认的日志系统

> 2017-10-22 20:12:10.136  INFO 1264 --- [           main] s.d.spring.web.caching.CachingAspect     : Caching aspect applied for cache modelDependencies with key java.lang.String(true)

* 1、2017-10-22 20:12:10.136   时间日期  精确到毫秒
* 2、INFO  日志级别-error warn debug info
* 3、1264  进程ID
* 4、--- 分隔符，标识实际日志的开始
* 5、 [           main]  线程名
* 6、 s.d.spring.web.caching.CachingAspect   logger名，通常使用源代码的类名
* 7、日志的具体内容


> 在spring boot中默认配置了error、warn 和info级别的日志输出到控制台。可以用过这两种方式去切换至dubug级别。

* 1、在运行命令后加入 --dubug标志，例如： java -jar app.jar --debug
* 2、在application.properties中配置debug=true，该属性设置为true的时候，核心logger会输出更多的内容，但是自己的应用日志不会输出。

> spring boot默认配置只会输出到控制台，并不会记录到文件中，我们再生产环境使用时需要以文件方式记录，可以通过增加如下配置，来将日志输出到文件：

* 1、logging.file :设置文件，可以使绝对路径，也可以是相对路径。
* 2、logging.path：设置目录，会在该目录下创建spring.log文件，并写入日志内容。
* 3、日志文件会在10mb大小的时候被切断，产生新的日志文件。

> spring boot默认日志的级别控制：

* 在spring boot中只需要在application.properties中进行配置完成日志记录的级别控制。
* 配置格式：logging.level.*=LEVEL
* logging.level:日志级别控制的前缀，*为包名或者logger名
* LEVEL：TRACE INFO ERROR WARN FATAL OFF

```xml
debug=true
logging.file=/Users/zhangyong/Documents/test/springboot.txt
logging.level.com.xxxx.sevice.Domain=INFO
```


## 二、用log4j记录日志
其中包含了spring-boot-starter-logging，该依赖内容就是spring boot默认的日志框架logback，所以我们在引入log4j之前，需要先排除该包的依赖，再引入log4j的依赖

```xml
  <dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter</artifactId>
			<exclusions>
				<exclusion>
					<groupId>org.springframework.boot</groupId>
					<artifactId>spring-boot-starter-logging</artifactId>
				</exclusion>
			</exclusions>
		</dependency>

		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-log4j</artifactId>
			<version>1.3.8.RELEASE</version>
		</dependency>
```