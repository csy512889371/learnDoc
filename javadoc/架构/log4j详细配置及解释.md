# log4j详细配置及解释

# 一、pom文件配置

```xml
	<properties>
		<slf4j.version>1.7.7</slf4j.version>
		<log4j.version>1.2.17</log4j.version>
	</properties>
	
	<!-- 日志文件管理包 -->
		<dependency>
			<groupId>log4j</groupId>
			<artifactId>log4j</artifactId>
			<version>${log4j.version}</version>
		</dependency>
		<!-- 格式化对象，方便输出日志 -->
		<dependency>
			<groupId>com.alibaba</groupId>
			<artifactId>fastjson</artifactId>
			<version>1.1.41</version>
		</dependency>
		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>slf4j-api</artifactId>
			<version>${slf4j.version}</version>
		</dependency>
		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>slf4j-log4j12</artifactId>
			<version>${slf4j.version}</version>
		</dependency>
		<!-- log end -->


```

# 二、log4j.properties配置

Log4J的配置文件(Configuration File)就是用来设置记录器的级别、存放器和布局的，它可接key=value格式的设置或xml格式的设置信息。通过配置，可以创建出Log4J的运行环境。

## 1、配置根Logger

log4j.rootLogger  =   [ level ]   ,  appenderName1 ,  appenderName2 ,  …其中 [level] 是日志输出级别，共有5级：

>*   FATAL      0  
>*   ERROR      3  
>*   WARN       4  
>*   INFO       6  
>*   DEBUG      7 


## 2、配置日志信息输出目的地Appender

Appender 为日志输出目的地，Log4j提供的appender有以下几种：

>* org.apache.log4j.ConsoleAppender（控制台），
>* org.apache.log4j.FileAppender（文件），
>* org.apache.log4j.DailyRollingFileAppender（每天产生一个日志文件），
>* org.apache.log4j.RollingFileAppender（文件大小到达指定尺寸的时候产生一个新的文件），
>* org.apache.log4j.WriterAppender（将日志信息以流格式发送到任意指定的地方）

## 3、Layout：日志输出格式，Log4j提供的layout有以下几种
 
>* org.apache.log4j.HTMLLayout（以HTML表格形式布局），
>* org.apache.log4j.PatternLayout（可以灵活地指定布局模式），
>* org.apache.log4j.SimpleLayout（包含日志信息的级别和信息字符串），
>* org.apache.log4j.TTCCLayout（包含日志产生的时间、线程、类别等等信息）

## 4、打印参数: Log4J采用类似C语言中的printf函数的打印格式格式化日志信息，如下

>*	   %m   输出代码中指定的消息
>* 　　%p   输出优先级，即DEBUG，INFO，WARN，ERROR，FATAL 
>* 　　%r   输出自应用启动到输出该log信息耗费的毫秒数 
>* 　　%c   输出所属的类目，通常就是所在类的全名 
>*　　 %t   输出产生该日志事件的线程名 
>* 　　%n   输出一个回车换行符，Windows平台为“\r\n”，Unix平台为“\n” 
>* 　　%d   输出日志时间点的日期或时间，默认格式为ISO8601，也可以在其后指定格式，比如：%d{yyy MMM dd HH:mm:ss , SSS}，输出类似：2002年10月18日  22 ： 10 ： 28 ， 921  
>*　　 %l   输出日志事件的发生位置，包括类目名、发生的线程，以及在代码中的行数。举例：Testlog4.main(TestLog4.java: 10 ) 

## 5、为不同的 Appender 设置日志输出级别

当调试系统时，我们往往注意的只是异常级别的日志输出，但是通常所有级别的输出都是放在一个文件里的。这时我们也许会想要是能把异常信息单独输出到一个文件里该多好啊。当然可以，Log4j已经提供了这样的功能，我们只需要在配置中修改Appender的Threshold 就能实现,比如下面的例子

> [配置文件]

```xml
### set log levels ###
 log4j.rootLogger = debug ,  stdout ,  D ,  E
 
 ### 输出到控制台 ###
 log4j.appender.stdout = org.apache.log4j.ConsoleAppender
 log4j.appender.stdout.Target = System.out
 log4j.appender.stdout.layout = org.apache.log4j.PatternLayout
 log4j.appender.stdout.layout.ConversionPattern =  %d{ABSOLUTE} %5p %c{ 1 }:%L - %m%n
 
 ### 输出到日志文件 ###
 log4j.appender.D = org.apache.log4j.DailyRollingFileAppender
 log4j.appender.D.File = logs/log.log
 log4j.appender.D.Append = true
 log4j.appender.D.Threshold = DEBUG ## 输出DEBUG级别以上的日志
 log4j.appender.D.layout = org.apache.log4j.PatternLayout
 log4j.appender.D.layout.ConversionPattern = %-d{yyyy-MM-dd HH:mm:ss}  [ %t:%r ] - [ %p ]  %m%n
 
 ### 保存异常信息到单独文件 ###
 log4j.appender.D = org.apache.log4j.DailyRollingFileAppender
 log4j.appender.D.File = logs/error.log ## 异常日志文件名
 log4j.appender.D.Append = true
 log4j.appender.D.Threshold = ERROR ## 只输出ERROR级别以上的日志!!!
 log4j.appender.D.layout = org.apache.log4j.PatternLayout
 log4j.appender.D.layout.ConversionPattern = %-d{yyyy-MM-dd HH:mm:ss}  [ %t:%r ] - [ %p ]  %m%n

```

## 6、最全面的配置例子

Log4j配置文件实现了输出到控制台、文件、回滚文件、发送日志邮件、输出到数据库日志表、自定义标签等全套功能。

```xml
log4j.rootLogger=DEBUG,console,dailyFile,im
log4j.additivity.org.apache=true
# 控制台(console)
log4j.appender.console=org.apache.log4j.ConsoleAppender
log4j.appender.console.Threshold=DEBUG
log4j.appender.console.ImmediateFlush=true
log4j.appender.console.Target=System.err
log4j.appender.console.layout=org.apache.log4j.PatternLayout
log4j.appender.console.layout.ConversionPattern=[%-5p] %d(%r) --> [%t] %l: %m %x %n

# 日志文件(logFile)
log4j.appender.logFile=org.apache.log4j.FileAppender
log4j.appender.logFile.Threshold=DEBUG
log4j.appender.logFile.ImmediateFlush=true
log4j.appender.logFile.Append=true
log4j.appender.logFile.File=D:/logs/log.log4j
log4j.appender.logFile.layout=org.apache.log4j.PatternLayout
log4j.appender.logFile.layout.ConversionPattern=[%-5p] %d(%r) --> [%t] %l: %m %x %n
# 回滚文件(rollingFile)
log4j.appender.rollingFile=org.apache.log4j.RollingFileAppender
log4j.appender.rollingFile.Threshold=DEBUG
log4j.appender.rollingFile.ImmediateFlush=true
log4j.appender.rollingFile.Append=true
log4j.appender.rollingFile.File=D:/logs/log.log4j
log4j.appender.rollingFile.MaxFileSize=200KB
log4j.appender.rollingFile.MaxBackupIndex=50
log4j.appender.rollingFile.layout=org.apache.log4j.PatternLayout
log4j.appender.rollingFile.layout.ConversionPattern=[%-5p] %d(%r) --> [%t] %l: %m %x %n
# 定期回滚日志文件(dailyFile)
log4j.appender.dailyFile=org.apache.log4j.DailyRollingFileAppender
log4j.appender.dailyFile.Threshold=DEBUG
log4j.appender.dailyFile.ImmediateFlush=true
log4j.appender.dailyFile.Append=true
log4j.appender.dailyFile.File=D:/logs/log.log4j
log4j.appender.dailyFile.DatePattern='.'yyyy-MM-dd
log4j.appender.dailyFile.layout=org.apache.log4j.PatternLayout
log4j.appender.dailyFile.layout.ConversionPattern=[%-5p] %d(%r) --> [%t] %l: %m %x %n
# 应用于socket
log4j.appender.socket=org.apache.log4j.RollingFileAppender
log4j.appender.socket.RemoteHost=localhost
log4j.appender.socket.Port=5001
log4j.appender.socket.LocationInfo=true
# Set up for Log Factor 5
log4j.appender.socket.layout=org.apache.log4j.PatternLayout
log4j.appender.socket.layout.ConversionPattern=[%-5p] %d(%r) --> [%t] %l: %m %x %n
# Log Factor 5 Appender
log4j.appender.LF5_APPENDER=org.apache.log4j.lf5.LF5Appender
log4j.appender.LF5_APPENDER.MaxNumberOfRecords=2000
# 发送日志到指定邮件
log4j.appender.mail=org.apache.log4j.net.SMTPAppender
log4j.appender.mail.Threshold=FATAL
log4j.appender.mail.BufferSize=10
log4j.appender.mail.From = xxx@mail.com
log4j.appender.mail.SMTPHost=mail.com
log4j.appender.mail.Subject=Log4J Message
log4j.appender.mail.To= xxx@mail.com
log4j.appender.mail.layout=org.apache.log4j.PatternLayout
log4j.appender.mail.layout.ConversionPattern=[%-5p] %d(%r) --> [%t] %l: %m %x %n
# 应用于数据库
log4j.appender.database=org.apache.log4j.jdbc.JDBCAppender
log4j.appender.database.URL=jdbc:mysql://localhost:3306/test
log4j.appender.database.driver=com.mysql.jdbc.Driver
log4j.appender.database.user=root
log4j.appender.database.password=
log4j.appender.database.sql=INSERT INTO LOG4J (Message) VALUES('=[%-5p] %d(%r) --> [%t] %l: %m %x %n')
log4j.appender.database.layout=org.apache.log4j.PatternLayout
log4j.appender.database.layout.ConversionPattern=[%-5p] %d(%r) --> [%t] %l: %m %x %n

# 自定义Appender
log4j.appender.im = net.cybercorlin.util.logger.appender.IMAppender
log4j.appender.im.host = mail.cybercorlin.net
log4j.appender.im.username = username
log4j.appender.im.password = password
log4j.appender.im.recipient = corlin@cybercorlin.net
log4j.appender.im.layout=org.apache.log4j.PatternLayout
log4j.appender.im.layout.ConversionPattern=[%-5p] %d(%r) --> [%t] %l: %m %x %n

```

