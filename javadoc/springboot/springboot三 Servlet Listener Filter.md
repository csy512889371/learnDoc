# Web 开发使用 Controller 基本上可以完成大部分需求，但是我们还可能会用到 Servlet、 Filter、Listener 等等

## 第一种方法
* 方法一：通过注册 ServletRegistrationBean、 FilterRegistrationBean 和 ServletListenerRegistrationBean 获得控制

```java
@SpringBootApplication
public class SpringBootEduApplication {

	@Bean
	public ServletRegistrationBean servletRegistrationBean() {
		return new ServletRegistrationBean(new CustomServlet(), "/api/blog");
	}

	@Bean
	public FilterRegistrationBean filterRegistrationBean() {
		return new FilterRegistrationBean(new CustomFilter(), servletRegistrationBean());
	}

	@Bean
	public ServletListenerRegistrationBean<CustomListener> servletListenerRegistrationBean() {
		return new ServletListenerRegistrationBean<CustomListener>(new CustomListener());
	}

	public static void main(String[] args) {
		SpringApplication.run(SpringBootEduApplication.class, args);
	}
}

```

> servlet

```java

public class CustomServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("servlet get method");
		doPost(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("servlet post method");
		response.getWriter().write("hello world");
	}

}

```
> filter

```java
public class CustomFilter implements Filter {

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		System.out.println("init filter");
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		System.out.println("do filter");
		chain.doFilter(request, response);
	}

	@Override
	public void destroy() {
		System.out.println("destroy filter");
	}

}
```

> listener

```java

public class CustomListener implements ServletContextListener {

	@Override
	public void contextInitialized(ServletContextEvent sce) {
		System.out.println("contextInitialized");
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		System.out.println("contextDestroyed");
	}

}

```

## 第二种方法

通过实现 ServletContextInitializer 接口直接注册

```java
@SpringBootApplication
public class SpringBootEduApplication implements ServletContextInitializer {

	@Override
	public void onStartup(ServletContext servletContext) throws ServletException {
		servletContext.addServlet("customServlet", new CustomServlet()).addMapping("/api/blog");
		servletContext.addFilter("customFilter", new CustomFilter())
				.addMappingForServletNames(EnumSet.of(DispatcherType.REQUEST), true, "customServlet");
		servletContext.addListener(new CustomListener());
	}

	public static void main(String[] args) {
		SpringApplication.run(SpringBootEduApplication.class, args);
	}
}


```

## 方法三

> 在 SpringBootApplication 上使用@ServletComponentScan 注解后，直接通过@WebServlet、@WebFilter、@WebListener 注解自动注册

```java

@ServletComponentScan
@SpringBootApplication
public class SpringBootDemo103Application {

	public static void main(String[] args) {
		SpringApplication.run(SpringBootDemo103Application.class, args);
	}
}
```

```java
@WebFilter(filterName = "customFilter", urlPatterns = "/*")
public class CustomFilter implements Filter {
    
}

@WebListener
public class CustomListener implements ServletContextListener {
    
}
```

```java
@WebServlet(name = "customServlet", urlPatterns = "/roncoo")
public class CustomServlet extends HttpServlet {
    
}
```