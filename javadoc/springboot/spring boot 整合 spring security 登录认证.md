# spring boot 整合 spring security 登录认证

实现访问控制的方法多种多样，可以通过Aop、拦截器实现，也可以通过框架实现（如：Apache Shiro）,本文将具体介绍在Spring Boot中如何使用Spring Security进行安全控制


## 一、pom.xml
```xml
		<!-- 整合spring security -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>
        <!-- 以thymeleaf的形式渲染页面 -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-thymeleaf</artifactId>
        </dependency>
```

## 二、WebSecurityConfig

* 通过 @EnableWebMvcSecurity 注解开启Spring Security的功能
* 继承 WebSecurityConfigurerAdapter ，并重写它的方法来设置一些web安全的细节
* configure(HttpSecurity http) 方法
* 通过 authorizeRequests() 定义哪些URL需要被保护、哪些不需要被保护。例如以上代码指定了 / 和 /home 不需要任何认证就可以访问，其他的路径都必须通过身份验证。
* 通过 formLogin() 定义当需要用户登录时候，转到的登录页面。
* configureGlobal(AuthenticationManagerBuilder auth) 方法，在内存中创建了一个用户，该用户的名称为user，密码为password，用户角色为USER。

```java
@Configuration
@EnableWebSecurity // 注解开启Spring Security的功能
//WebSecurityConfigurerAdapter:重写它的方法来设置一些web的安全西街
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {
  @Override
  protected void configure(HttpSecurity http) throws Exception {
      http
          .authorizeRequests()  //定义哪些url需要保护，哪些url不需要保护
              .antMatchers("/", "/message/").permitAll()    //定义不需要认证就可以访问
              .anyRequest().authenticated()
              .and()
          .formLogin()
              .loginPage("/login")  //定义当需要用户登录时候，转到的登录页面
              .permitAll()
              .and()
          .logout()
              .permitAll();
      http.csrf().disable();
  }
  @Autowired
  public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
      auth
          .inMemoryAuthentication()
              .withUser("user").password("password").roles("USER");
     //在内存中创建了一个用户，该用户的名称为user，密码为password，用户角色为USER
  }
}
```

## 三、Controller

@Controller
public class HelloController {

    @RequestMapping("/")
    public String index() {
        return "index";
    }

    @RequestMapping("/hello")
    public String hello() {
        return "hello";
    }

	@RequestMapping("/login")
    public String login() {
        return "login";
    }

}


## 四、页面 

login.html
```java
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:th="http://www.thymeleaf.org"
      xmlns:sec="http://www.thymeleaf.org/thymeleaf-extras-springsecurity3">
    <head>
        <title>Spring Security Example </title>
    </head>
    <body>
        <div th:if="${param.error}">
            用户名或密码错
        </div>
        <div th:if="${param.logout}">
            您已注销成功
        </div>
        <form th:action="@{/login}" method="post">
            <div><label> 用户名 : <input type="text" name="username"/> </label></div>
            <div><label> 密  码 : <input type="password" name="password"/> </label></div>
            <div><input type="submit" value="登录"/></div>
        </form>
    </body>
</html>
```

index.html
```java
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"/>
<title>Security</title>
</head>
<body>
        <h1>Spring Security!</h1>
        <p>点击<a th:href="@{/hello}">这里</a>到碗里来！</p>
</body>
</html>
```

hello.html

```java
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"/>
<title>Hello World!</title>
</head>
<body>
    <h1>Hello world!</h1>
</body>
</html>
```

