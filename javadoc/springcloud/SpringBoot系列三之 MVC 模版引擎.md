# Spring Boot spring mvc

>* spring boot的web应用开发，是基于spring mvc

> Spring boot 在spring默认基础上，自动配置添加了以下特性

>* 包含了ContentNegotiatingViewResolver和BeanNameViewResolver beans。
>* 对静态资源的支持，包括对WebJars的支持。
>* 自动注册Converter，GenericConverter，Formatter beans。
>* 对HttpMessageConverters的支持。
>* 自动注册MessageCodeResolver。
>* 对静态index.html的支持。
>* 对自定义Favicon的支持。
>* 主动使用ConfigurableWebBindingInitializer bean

## 模板引擎的选择

>* FreeMarker
>* Thymeleaf
>* Velocity (1.4版本之后弃用，Spring Framework 4.3版本之后弃用)
>* Groovy
>* Mustache

注：jsp应该尽量避免使用，原因如下：
>* jsp只能打包为：war格式，不支持jar格式，只能在标准的容器里面跑（tomcat，jetty都可以） 
>* 内嵌的Jetty目前不支持JSPs
>* Undertow不支持jsps
>* jsp自定义错误页面不能覆盖spring boot 默认的错误页面

## FreeMarker 例子

pom.xml
```xml
<dependencies>
	
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-freemarker</artifactId>
		</dependency>
		
		<dependency>
			<groupId>org.webjars</groupId>
			<artifactId>jquery</artifactId>
			<version>2.1.4</version>
		</dependency>

		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-devtools</artifactId>
		</dependency>

		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-test</artifactId>
			<scope>test</scope>
		</dependency>
	</dependencies>

```

WebController.java

```xml
@Controller
@RequestMapping(value = "/web")
public class WebController {

	@RequestMapping(value = "index")
	public String index(ModelMap map) {
		map.put("title", "freemarker hello word");
		return "index"; // 开头不要加上/，linux下面会出错
	}

}

```

SpringBootDemo61Application

```java

@ServletComponentScan
@SpringBootApplication
public class SpringBootDemo61Application {

	public static void main(String[] args) {
		SpringApplication.run(SpringBootDemo61Application.class, args);
	}
}
```


## 目录结构

```

├── java                 
│   ├── com.eva.learn                          
│   │   │
│   │   └── controller   controller
│   │
│   
├── resources
│   │
│   ├── static           静态文件
│   │
│   ├── templates        页面模版  

```