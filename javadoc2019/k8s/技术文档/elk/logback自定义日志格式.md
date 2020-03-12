logback自定义日志格式

1.ClassicConverter

继承ClassicConverter

```
package com.demo.conf;

import ch.qos.logback.classic.pattern.ClassicConverter;
import ch.qos.logback.classic.spi.ILoggingEvent;

import java.net.InetAddress;
import java.net.UnknownHostException;

/**
 * 配置日志中显示IP
 */
public class IPLogConfig extends ClassicConverter {
    @Override
    public String convert(ILoggingEvent event) {
        try {
            return InetAddress.getLocalHost().getHostAddress();
        } catch (UnknownHostException e) {
            e.printStackTrace();
        }
        return null;
    }
}
```


然后再logback.xml中配置

```
<!--配置规则类的位置-->
<conversionRule conversionWord="ip" converterClass="com.demo.conf.IPLogConfig" />
 <appender name="Console" class="ch.qos.logback.core.ConsoleAppender">
        <layout>
            <pattern>%ip -%date{HH:mm:ss} %highlight(%-5level)[%yellow(%thread)]%green(%logger{56}.%method:%L) -%msg%n"</pattern>
        </layout>
    </appender>
```



2.实现PropertyDefiner
logback提供自定义属性接口PropertyDefiner

实现PropertyDefiner：getPropertyValue()方法

```
public class GetIpProperty implements PropertyDefiner{
    @override
    public String getPropertyValue() {
        try {
                InetAddress address = InetAddress.getLocalHost();
                return address.getHostAddress();

          } catch (UnknownHostException e) {
              e.printStackTrace();
          }   
               return null;
      }
   	//....
}
```



然后在logback.xml配置文件中，定义自定义标签define name代表标签，class指向处理的类。在初始化时调用getPropertyValue()

```
<configuration>
	<define name="ip" class="com.lay.config.log.GetIpProperty"></define>
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
    	<encode>
        	<parttern>${ip}-%date{HH:mm:ss} %highlight(%-5level)[%yellow(%thread)]%green(%logger{56}.%method:%L) -%msg%n"</parttern>
        </encode>
    </appender>
</configuration>
```

3.SLF4JMDC
Logback是在logback-classic模块中实现了SLF4J的MDC功能。

MDC中管理的数据（简称MDC数据）是以单个线程为单位进行访问的，即对MDC数据的操作（如put, get）只对当前线程有效，所以也永远是线程安全的。
在服务端，为每个请求分配一个线程进行处理，所以每个服务端线程处理的请求，都具有唯一的MDC上下文数据。

子线程不会自动继承父线程的MDC数据。所以在创建子线程时，可以先调用MDC的getCopyOfContextMap()方法以返回一个Map<String, String>对象，从而获取父线程的MDC数据，然后再在子线程的开始处，最先调用MDC的setContextMap()方法为子线程设置父线程的MDC数据。从而能够在子线程中访问父线程的MDC数据。

在使用java.util.concurrent.Executors管理线程时，使用同样的方法让子线程继承主线程的MDC数据。

但是，在Web应用中，一个请求可能在不同的阶段被多个线程处理。这时，只是在服务端的处理线程中设置MDC数据，并不能保证请求的某些信息（如用户的认证信息等）总是能够被处理线程访问到。为了在处理一个请求时能够保证某些信息总是可访问，建议使用Servlet Filter，在请求到来时就将信息装入到MDC中，在完成所有的后续处理后，再次通过过滤器时将MDC数据移除。

```
	public class MyFilter implements Filter {
		public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
			...
			MDC.put(MY_KEY, myValue);
			...
		    try {
			  chain.doFilter(request, response);
			} finally {
			  if (MDC.contains(MY_KEY)) {
				MDC.remove(MY_KEY);
			  }
			}
```


Logback自带的ch.qos.logback.classic.helpers.MDCInsertingServletFilter能够将HTTP请求的hostname, request URI, user-agent等信息装入MDC，只需在web.xml中设置（建议MDCInsertingServletFilter作为第一个Filter配置，原因请读者思考），后续处理过程就可以直接访问如下请求参数的值：

req.remoteHost
req.xForwardedFor
req.method
req.requestURI
req.requestURL
req.queryString

req.userAgent

源码如下

```
package com.lay.log.core.filter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;

/**
 * @Description:
 * @Author: lay
 * @Date: Created in 11:22 2019/3/19
 * @Modified By:IntelliJ IDEA
 */
public class LogFilter implements Filter {
    private static final Logger log = LoggerFactory.getLogger(LogFilter.class);


    @Override
    public void init(FilterConfig filterConfig) {
    
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        log.info("start log filter");
        this.insertIntoMDC(request);
        log.info("log filter....");
        try {
            chain.doFilter(request, response);
        } finally {
            log.info("log filter....");
            this.clearMDC();
            log.info("end log filter");
        }
    
    }
    
    void insertIntoMDC(ServletRequest request) {
        MDC.put("req.remoteHost", request.getRemoteHost());
        if (request instanceof HttpServletRequest) {
            HttpServletRequest httpServletRequest = (HttpServletRequest) request;
            MDC.put("req.requestURI", httpServletRequest.getRequestURI());
            StringBuffer requestURL = httpServletRequest.getRequestURL();
            if (requestURL != null) {
                MDC.put("req.requestURL", requestURL.toString());
            }
            String requestNo = httpServletRequest.getHeader("Request-No");
            if (requestNo != null && !requestNo.equals("")) {
                MDC.put("req.requestNo", requestNo);
            }
            MDC.put("req.method", httpServletRequest.getMethod());
            MDC.put("req.queryString", httpServletRequest.getQueryString());
            MDC.put("req.userAgent", httpServletRequest.getHeader("User-Agent"));
            MDC.put("req.xForwardedFor", httpServletRequest.getHeader("X-Forwarded-For"));
            MDC.put("req.hostIp", getHostIp());
        }
    }
    
    void clearMDC() {
        MDC.remove("req.remoteHost");
        MDC.remove("req.requestURI");
        MDC.remove("req.queryString");
        MDC.remove("req.requestURL");
        MDC.remove("req.method");
        MDC.remove("req.userAgent");
        MDC.remove("req.xForwardedFor");
        MDC.remove("req.requestNo");
        MDC.remove("req.ho  stIp");
    }
    
    @Override
    public void destroy() {
    
    }
    
    public String getHostIp() {
        try {
            InetAddress address = InetAddress.getLocalHost();
            return address.getHostAddress();
    
        } catch (UnknownHostException e) {
            e.printStackTrace();
        }
        return null;
    }
}
```



配置

```
@Component
public class ApplicationConfig {
    @Bean
    public FilterRegistrationBean filterRegistrationBean() {
        FilterRegistrationBean registrationBean = new FilterRegistrationBean();
        Filter actionFilter = new MDCInsertingServletFilter();
        registrationBean.setFilter(actionFilter);
        List<String> urlPatterns = new ArrayList<>();
        urlPatterns.add("/*");
        registrationBean.setUrlPatterns(urlPatterns);
        return registrationBean;
    }
}
```

使用

```
<configuration>
    <!-- 彩色日志 -->
    <!-- 彩色日志依赖的渲染类 -->
    <conversionRule conversionWord="clr" converterClass="org.springframework.boot.logging.logback.ColorConverter"/>
    <conversionRule conversionWord="wex"
                    converterClass="org.springframework.boot.logging.logback.WhitespaceThrowableProxyConverter"/>
    <conversionRule conversionWord="wEx"
                    converterClass="org.springframework.boot.logging.logback.ExtendedWhitespaceThrowableProxyConverter"/>
    <!-- 彩色日志格式 -->
    <property name="CONSOLE_LOG_PATTERN"
              value="${CONSOLE_LOG_PATTERN:-%clr(%d{yyyy-MM-dd HH:mm:ss.SSS}){faint} %clr(${LOG_LEVEL_PATTERN:-%5p}) %clr(${PID:- }){magenta} %clr(--){faint} %clr([%15.15t]){faint} %clr(%-40.40logger{39}){cyan} %clr(:){faint} %m%n${LOG_EXCEPTION_CONVERSION_WORD:-%wEx}}"/>/>



    <property name="MDC_LOG_PATTERN" value="IP:%X{req.remoteHost} -url:%X{req.requestURI} -Method:%X{req.method} - QueryString:%X{req.queryString} - device:%X{req.userAgent}  -ips:%X{req.xForwardedFor}  - %m%n "></property>
    
    <appender name="Console" class="ch.qos.logback.core.ConsoleAppender">
        <layout>
            <pattern>${MDC_LOG_PATTERN}</pattern>
        </layout>
    </appender>


    <root level="INFO">
        <appender-ref ref="Console"/>
        <!--<appender-ref ref="Sentry"/>-->
    </root>
</configuration>
```


