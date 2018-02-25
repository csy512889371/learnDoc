# springBoot-mongodb使用

# 安装：
* mongodb 下载链接：https://www.mongodb.com/download-center#community
* 下载版本：mongodb-win32-x86_64-2008plus-ssl-3.2.9-signed.msi
* 安装出现 2502、2503 错误解决办法：
* http://jingyan.baidu.com/article/a501d80cec07daec630f5e18.html

# 添加依赖
<!-- mongodb -->
<dependency>
<groupId>org.springframework.boot</groupId>
<artifactId>spring-boot-starter-data-mongodb</artifactId>
</dependency>

# 配置文件：
```xml
# MONGODB (MongoProperties)
spring.data.mongodb.uri=mongodb://localhost/test
spring.data.mongodb.port=27017
#spring.data.mongodb.authentication-database=
#spring.data.mongodb.database=test
#spring.data.mongodb.field-naming-strategy=
#spring.data.mongodb.grid-fs-database=
#spring.data.mongodb.host=localhost
#spring.data.mongodb.password=
#spring.data.mongodb.repositories.enabled=true
#spring.data.mongodb.username=
```
# 设置日志打印：
<logger name="org.springframework.data.mongodb.core.MongoTemplate" level="debug"/>

# 使用嵌入式的 mongo
```xml
<dependency>
<groupId>de.flapdoodle.embed</groupId>
<artifactId>de.flapdoodle.embed.mongo</artifactId>
</dependency>
```
注意：
* 1.加入嵌入式的 mongo 之后，首次启动会进行下载，时间会比较久，请耐心等待
* 2.下载完成，启动之后，默认情况下数据会在内存里面，重启会丢失