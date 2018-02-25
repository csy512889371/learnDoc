# h2 嵌入式数据库的使用

## 添加依赖
```xml
<dependency>
<groupId>com.h2database</groupId>
<artifactId>h2</artifactId>
<scope>runtime</scope>
</dependency>
```

# 配置
```xml
spring.datasource.url=jdbc:h2:~/test;AUTO_SERVER=TRUE;DB_CLOSE_ON_EXIT=FALSE
spring.datasource.username=sa
spring.datasource.password=
```

注：
* 1."~"这个符号代表的就是当前登录到操作系统的用户对应的用户目录
* 2.账号密码我们指定之后，就会自动创建

## 指定路径：

```xml
spring.datasource.url=jdbc:h2:file:D:/roncoo_h2/roncoo_spring_
boot;AUTO_SERVER=TRUE;DB_CLOSE_ON_EXIT=FALSE
内存模式：
spring.datasource.url=jdbc:h2:mem:test
```
# 三、 进入控制台

* 路径：http://localhost:8080/h2-console

