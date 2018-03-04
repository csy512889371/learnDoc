# spring-security-oauth2代码实现

# 代码地址
* https://github.com/csy512889371/learndemo/tree/master/ctoedu-oauth

# 如何使用
1) 需要认证的项目中 引入上面项目的pom

```java
        <dependency>
            <groupId>cn.ctoedu</groupId>
            <artifactId>ctoedu-oauth</artifactId>
            <version>1.0</version>
        </dependency>
```

2) WEB-INF 下加入dispatcher-servlet.xml
```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd
        http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc-3.0.xsd">

    <!-- <context:component-scan base-package="com.test.springmvc"/> -->
    <context:annotation-config/>
    <mvc:annotation-driven/>

    <bean id="viewResolver"
          class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="prefix" value="/pages/"/>
        <property name="suffix" value=".jsp"/>
    </bean>

    <mvc:resources mapping="/static/**" location="/resources/"/>

    <mvc:default-servlet-handler/>

</beans>
```

3) web.xml中加入
```xml
    <servlet>
        <servlet-name>dispatcher</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <load-on-startup>1</load-on-startup>
    </servlet>
    <servlet-mapping>
        <servlet-name>dispatcher</servlet-name>
        <url-pattern>/oauth/token</url-pattern>
    </servlet-mapping>

	
	    <filter>
        <filter-name>springSecurityFilterChain</filter-name>
        <filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>springSecurityFilterChain</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
```

4) spring-context.xml 中加入

```java
	<import resource="classpath:spring/security-context.xml"/>

	<import resource="classpath:spring/mysql-context.xml"/>
```


5) 获取token

http://localhost:8080/xxservice/oauth/token?client_id=client&grant_type=client_credentials&client_secret=ctoedu

6) 请求接口带上token

http://localhost:8080/xxservice/getInfo/1?access_token=safdioiidfoasdifuao