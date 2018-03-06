# spring boot log写入mongodb

但是当我们在集群中部署应用之后，应用请求的日志被分散记录在了不同应用服务器的文件系统上，这样分散的存储并不利于我们对日志内容的检索。解决日志分散问题的方案多种多样，本文思路以\扩展log4j实现将日志写入MongoDB

## 一、mongo，存储日志

```xml
		<!-- 连接mongo，存储日志 -->
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-aop</artifactId>
		</dependency>
		<!-- 连接mongo的时候已经自动加入了mongodb-driver了，所以这边先隐藏 -->
	 	<dependency>
			<groupId>org.mongodb</groupId>
			<artifactId>mongodb-driver</artifactId>
			<version>3.2.2</version>
		</dependency>
```

## 二、log4j.properties

设置名为mongodb的logger：

* 记录INFO级别日志
* appender实现为com.ctoedu.log.MongoAppende
* mongodb连接地址：mongodb://localhost:27017
* mongodb数据库名：logs
* mongodb集合名：logs_request

```xml
log4j.logger.mongodb=INFO, mongodb  
# mongodb输出  
log4j.appender.mongodb=com.ctoedu.log.MongoAppender  
log4j.appender.mongodb.connectionUrl=mongodb://localhost:27017  
log4j.appender.mongodb.databaseName=logs  
log4j.appender.mongodb.collectionName=logs_request
```

## 三、实现MongoAppender

log4j提供的输出器实现自Appender接口，要自定义appender输出到MongoDB，只需要继承AppenderSkeleton类，并实现几个方法即可完成。

```java

public class MongoAppender  extends AppenderSkeleton {

    private MongoClient mongoClient;
    private MongoDatabase mongoDatabase;
    private MongoCollection<BasicDBObject> logsCollection;

    private String connectionUrl;
    private String databaseName;
    private String collectionName;

    @Override
    protected void append(LoggingEvent loggingEvent) {

        if(mongoDatabase == null) {
            MongoClientURI connectionString = new MongoClientURI(connectionUrl);
            mongoClient = new MongoClient(connectionString);
            mongoDatabase = mongoClient.getDatabase(databaseName);
            logsCollection = mongoDatabase.getCollection(collectionName, BasicDBObject.class);
        }
        logsCollection.insertOne((BasicDBObject) loggingEvent.getMessage());

    }

    @Override
    public void close() {
        if(mongoClient != null) {
            mongoClient.close();
        }
    }

    @Override
    public boolean requiresLayout() {
        return false;
    }

    public String getConnectionUrl() {
        return connectionUrl;
    }

    public void setConnectionUrl(String connectionUrl) {
        this.connectionUrl = connectionUrl;
    }

    public String getDatabaseName() {
        return databaseName;
    }

    public void setDatabaseName(String databaseName) {
        this.databaseName = databaseName;
    }

    public String getCollectionName() {
        return collectionName;
    }

    public void setCollectionName(String collectionName) {
        this.collectionName = collectionName;
    }

}
```

定义MongoDB的配置参数，可通过log4j.properties配置：

* connectionUrl：连接mongodb的串
* databaseName：数据库名
* collectionName：集合名


定义MongoDB的连接和操作对象，根据log4j.properties配置的参数初始化：

* mongoClient：mongodb的连接客户端
* mongoDatabase：记录日志的数据库
* logsCollection：记录日志的集合


重写append函数：

* 根据log4j.properties中的配置创建mongodb连接
* LoggingEvent提供getMessage()函数来获取日志消息
* 往配置的记录日志的collection中插入日志消息
* 重写close函数：关闭mongodb的

## 四、切面中使用mongodb logger

```java
@Aspect
@Order(1)
@Component
public class WebLogAspect {

    private Logger logger = Logger.getLogger("mongodb");

    @Pointcut("execution(public * com.ctoedu.service.web..*.*(..))")
    public void webLog(){}

    @Before("webLog()")
    public void doBefore(JoinPoint joinPoint) throws Throwable {
        // 获取HttpServletRequest
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = attributes.getRequest();
        // 获取要记录的日志内容
        BasicDBObject logInfo = getBasicDBObject(request, joinPoint);
        logger.info(logInfo);
    }


    private BasicDBObject getBasicDBObject(HttpServletRequest request, JoinPoint joinPoint) {
        // 基本信息
        BasicDBObject r = new BasicDBObject();
        r.append("requestURL", request.getRequestURL().toString());
        r.append("requestURI", request.getRequestURI());
        r.append("queryString", request.getQueryString());
        r.append("remoteAddr", request.getRemoteAddr());
        r.append("remoteHost", request.getRemoteHost());
        r.append("remotePort", request.getRemotePort());
        r.append("localAddr", request.getLocalAddr());
        r.append("localName", request.getLocalName());
        r.append("method", request.getMethod());
        r.append("headers", getHeadersInfo(request));
        r.append("parameters", request.getParameterMap());
        r.append("classMethod", joinPoint.getSignature().getDeclaringTypeName() + "." + joinPoint.getSignature().getName());
        r.append("args", Arrays.toString(joinPoint.getArgs()));
        return r;
    }

    /**
     * 获取头信息
     *
     * @param request
     * @return
     */
    private Map<String, String> getHeadersInfo(HttpServletRequest request) {
        Map<String, String> map = new HashMap<>();
        Enumeration headerNames = request.getHeaderNames();
        while (headerNames.hasMoreElements()) {
            String key = (String) headerNames.nextElement();
            String value = request.getHeader(key);
            map.put(key, value);
        }
        return map;
    }
}
```
