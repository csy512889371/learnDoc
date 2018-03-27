# 4_Spring Cloud技术分析-spring cloud zuul




# zuul是什么

* spring cloud zuul是netflix提供的一个组件，功能类似于nginx，用于反向代理，可以提供动态路由、监控、授权、安全、调度等边缘服务。
* 微服务场景下，每一个微服务对外暴露了一组细粒度的服务。客户端的请求可能会涉及到一串的服务调用，如果将这些微服务都暴露给客户端，那么会增加客户端代码的复杂度。
* 参考GOF设计模式中的Facade模式，将细粒度的服务组合起来提供一个粗粒度的服务，所有请求都导入一个统一的入口，那么整个服务只需要暴露一个api，对外屏蔽了服务端的实现细节，也减少了客户端与服务器的网络调用次数。这就是api gateway。

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/21.png)

有了api gateway之后，一些与业务关系并不大的通用处理逻辑可以从api gateway中剥离出来，api gateway仅仅负责服务的编排与结果的组装。


Spring Cloud Netflix的Zuul组件可以做反向代理的功能，通过路由寻址将请求转发到后端的粗粒度服务上，并做一些通用的逻辑处理。

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/22.png)


## 一、总结Zuul的作用：

* 动态路由
* 监控
* 安全
* 认证鉴权
* 压力测试
* 金丝雀测试
* 审查
* 服务迁移
* 负载剪裁
* 静态应答处理


## 二、怎么使用zuul

**maven配置**

在pom.xml中添加以下配置

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>1.5.3.RELEASE</version>
</parent>

<dependencies>
	<dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-eureka</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-zuul</artifactId>
    </dependency>
</dependencies>

<dependencyManagement>
	<dependencies>
		<dependency>
<groupId>org.springframework.cloud</groupId>
<artifactId>spring-cloud-dependencies</artifactId>
<version>Dalston.RELEASE</version>
<type>pom</type>
<scope>import</scope>
    	</dependency>
    </dependencies>
</dependencyManagement>
```

引入eureka的目的是为了后续与eureka做整合，使用serviceId做路由


**java编程** 

在启动类添加@EnableZuulProxy注解

```java
@EnableZuulProxy
@SpringCloudApplication
public class GatewayServer
{
    public static void main(String[] args)
    {
        SpringApplication.run(GatewayServer.class, args);
    }
}
```


## 三、zuul对路由的配置

Zuul对路由跳转的配置是在application.yml文件中，定义了两种映射方式

* url映射
* serviceId映射

### 3.1 url直接映射

* 单实例url直连

```xml
zuul:
	routes:
		wap:
			path: /wap/**
			url: http://192.168.1.10:8081

```


* 多实例路由

```xml

zuul:
	routes:
		wap:
			path: /wap/**
			serviceId: wap
ribbon:
	eureka:
		enabled: false
wap:
	ribbon:
		listOfServers: http://192.168.1.10:8081, http://192.168.1.11:8081

```


* forward跳转到本地url

```xml
zuul:
	routes:
		wap:
			path: /wap/**
			url: forward:/wap
```


### 3.2 serviceId映射

* 默认serviceId，serviceId：activity，路由规则：/activity/101 -> /101

```java
zuul:
	routes:
		activity: /activity/**

```

* 指定serviceId，serviceId：micro-activity，路由规则：/activity/101 -> /activity/101

```java
zuul:
	routes:
		activity:
			path: /activity/** # 指定
			serviceId: micro-activity # 指定路由的serviceId
			stripPrefix: false
```


## 四、Cookie与头信息

默认情况下，Zuul在请求路由时，会过滤HTTP请求头信息中的一些敏感信息，默认的敏感头信息通过zuul.sensitiveHeaders定义，包括Cookie、Set-Cookie、Authorization。

* 设置全局参数覆盖默认值

```java
zuul:
	sensitiveHeaders: # 使用空来覆盖默认值

```

* 指定路由的参数配置

```java
zuul:
	routes:
		[route]:
			customSensitiveHeaders: true # 对指定路由开启自定义敏感头
```

```java

zuul:
	routes:
		[route]:
			sensitiveHeaders: # 对指定路由的敏感头设置为空
```


## 五、zuul的关键知识点

filter是Zuul的核心，用来实现对外服务的控制。filter的生命周期有4个，分别是”pre”、”route”、”post”、”error”，整个生命周期可以用下图来表示。


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/23.png)

具体的代码是在ZuulServletFilter类中，从实现可以看出，error可以在所有阶段捕获异常后执行，但是当post阶段处理中出现异常不会再回到post阶段，那么这就需要保证在post阶段不要有异常，因为一旦有异常后就不会走post执行SendErrorFilter了。

```java
public class ZuulServletFilter implements Filter {
	@Override
	public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
		try {
			init((HttpServletRequest) servletRequest, (HttpServletResponse) servletResponse);
			try {
				preRouting();
			} catch (ZuulException e) {
				error(e);
				postRouting();
				return;
			}
            
			// Only forward onto to the chain if a zuul response is not being sent
			if (!RequestContext.getCurrentContext().sendZuulResponse()) {
				filterChain.doFilter(servletRequest, servletResponse);
				return;
			}
            
			try {
				routing();
			} catch (ZuulException e) {
				error(e);
				postRouting();
				return;
			}
			
			try {
				postRouting();
			} catch (ZuulException e) {
				error(e);
				return;
			}
		} catch (Throwable e) {
			error(new ZuulException(e, 500, "UNCAUGHT_EXCEPTION_FROM_FILTER_" + e.getClass().getName()));
		} finally {
			RequestContext.getCurrentContext().unset();
		}
	}
}

```

### 5.1zuul中默认实现的filter

```

类型	 顺序	              过滤器	                   功能
pre	     -3	          ServletDetectionFilter	    标记处理Servlet的类型
pre	     -2	          Servlet30WrapperFilter	    包装HttpServletRequest请求
pre	     -1	          FormBodyWrapperFilter	        包装请求体
route	 1	          DebugFilter	                标记调试标志
route	 5	          PreDecorationFilter	        处理请求上下文供后续使用
route	 10	          RibbonRoutingFilter	        serviceId请求转发
route	 100	      SimpleHostRoutingFilter	    url请求转发
route	 500	      SendForwardFilter	            forward请求转发
post	 0	          SendErrorFilter	            处理有错误的请求响应
post	 1000	      SendResponseFilter	        处理正常的请求响应

```

### 5.2禁用指定的filter

可以在application.yml中配置需要禁用的filter，格式：zuul:[filter-name]:[filter-type]:disable:true。

```java
zuul:
	FormBodyWrapperFilter:
		pre:
			disable: true
```

### 5.3 自定义filter
使用java实现自定义filter，需要添加继承于ZuulFilter的类，覆盖其中的4个方法

```java

public class CustomerPreFilter extends ZuulFilter {
    @Override
    String filterType() {
        return "pre"; //定义filter的类型，有pre、route、post、error四种
    }

    @Override
    int filterOrder() {
        return 10; //定义filter的顺序，数字越小表示顺序越高，越先执行
    }

    @Override
    boolean shouldFilter() {
        return true; //表示是否需要执行该filter，true表示执行，false表示不执行
    }

    @Override
    Object run() {
        return null; //filter需要执行的具体操作
    }
}
```


## 六、zuul对动态语言的支持

zuul支持使用groovy语言来动态修改filter，它是基于jvm的语言，语法简单并且很多与java类似。

需要先将groovy的jar包引入

```xml
<dependency>
    <groupId>org.codehaus.groovy</groupId>
    <artifactId>groovy-all</artifactId>
    <version>2.4.9</version>
</dependency>
```

然后扫描groovy文件

```java
FilterLoader.getInstance().setCompiler(new GroovyCompiler());
FilterFileManager.setFilenameFilter(new GroovyFileFilter());
FilterFileManager.init(internal, path);
```

FilterFileManager会对groovy文件变更加载如内存，其实现是开启了一个后台线程，以指定间隔的时间长度管理文件，具体的代码如下。

```java
public class FilterFileManager {
    public static void init(int pollingIntervalSeconds, String... directories) throws Exception, IllegalAccessException, InstantiationException {
        if (INSTANCE == null) INSTANCE = new FilterFileManager();
        INSTANCE.aDirectories = directories;
        INSTANCE.pollingIntervalSeconds = pollingIntervalSeconds;
        INSTANCE.manageFiles();
        INSTANCE.startPoller();
    }

    void startPoller() {
        poller = new Thread("GroovyFilterFileManagerPoller") {
            public void run() {
                while (bRunning) {
                    try {
                        sleep(pollingIntervalSeconds * 1000);
                        manageFiles();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        };
        poller.setDaemon(true);
        poller.start();
    }
}
```

最终调用的是FilterLoader的putFilter方法，是否需要重新加载文件，判断依据是看文件是否已经加载到内存中，同时文件是否被修改过。

```java

public class FilterLoader {
    public boolean putFilter(File file) throws Exception {
        String sName = file.getAbsolutePath() + file.getName();
        if (filterClassLastModified.get(sName) != null && (file.lastModified() != filterClassLastModified.get(sName))) {
            LOG.debug("reloading filter " + sName);
            filterRegistry.remove(sName);
        }
        ZuulFilter filter = filterRegistry.get(sName);
        if (filter == null) {
            Class clazz = COMPILER.compile(file);
            if (!Modifier.isAbstract(clazz.getModifiers())) {
                filter = (ZuulFilter) FILTER_FACTORY.newInstance(clazz);
                List<ZuulFilter> list = hashFiltersByType.get(filter.filterType());
                if (list != null) {
                    hashFiltersByType.remove(filter.filterType()); //rebuild this list
                }
                filterRegistry.put(file.getAbsolutePath() + file.getName(), filter);
                filterClassLastModified.put(sName, file.lastModified());
                return true;
            }
        }

        return false;
    }
}
```

groovy实现的filter，groovy语法格式与java相近：


```java
class PreFilter extends ZuulFilter {
	@Override
	String filterType() {
		return "pre"
	}

	@Override
	int filterOrder() {
		return 1000
	}

	@Override
	boolean shouldFilter() {
		return true
	}

	@Override
	Object run() {
		return null
	}
}
```

## 七、全局异常处理

介绍一下Zuul的全局异常处理的一种方式：添加一个类型为”error”的filter，将错误信息写入RequestContext，这样SendErrorFilter就可以获取错误信息了。


```java

class ErrorFilter extends ZuulFilter {
	@Override
	String filterType() {
		return FilterConstants.ERROR_TYPE
	}
		
	@Override
	int filterOrder() {
		return 10
	}
		
	@Override
	boolean shouldFilter() {
		return true
	}
		
	@Override
	Object run() {
		RequestContext context = getRequestContext()
		Throwable throwable = context.getThrowable()
		LOGGER.error("[ErrorFilter] error message: {}", throwable.getCause().getMessage())
		ctx.set("error.status_code", HttpServletResponse.SC_INTERNAL_SERVER_ERROR)
		ctx.set("error.exception", throwable.getCause())
		return null
	}
}
```


## 八、性能优化参考

在application.yml文件中配置线程数、缓冲大小

```java

server:
	tomcat:
		max-threads: 128 # 最大worker线程
		min-spare-threads: 64 # 最小worker线程
	undertow:
		io-threads: 8 # IO线程数，默认为CPU核心数，最小为2
		worker-threads: 40 # 阻塞任务线程池，值设置取决于系统的负载，默认为io-threads * 8
		buffer-size: 512 # 每块buffer的空间大小
		buffers-per-region: 10 # 每个区分配的buffer数量
		direct-buffers: 512 # 是否分配的直接内存
```


在application.yml文件中配置zuul和ribbon

```java
zuul:
	host:
		max-total-connections: 500 # 每个服务的http客户端连接池最大连接，默认值是200
		max-per-route-connections: 50 # 每个route可用的最大连接数，默认值是20
	ribbon-isolation-strategy: THREAD # 可选：SEMAPHORE THREAD
```


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/springcloud/24.png)


在application.yml文件中配置hystrix


```xml

hystrix.command.default.execution.isolation.thread.timeoutInMilliseconds 设置thread的默认超时时间，默认值是10000。

hystrix.command.[CommandKey].execution.isolation.thread.timeoutInMilliseconds 设置不同微服务的超时时间。
```

