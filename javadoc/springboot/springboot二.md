# xml 配置文件
* Spring Boot 提倡零配置，即无xml配置，但实际项目中，可能有一些特殊要求你必须使用xml配置，这时我们可以通过Spring 提供的@ImportResource来加载xml配置
* @ImportResource({"classpath:some-context.xml","classpath:other-context.xml"})

# Spring Boot 的自动配置的原理
* Spring Boot 在进行SpringApplication 对象实例化时会加载 META-INF/spring.factories文件。将该配置文件中的配置载入到Spring 容器。
* spring-boot.jar/META-INF下的spring.factories

# 条件注解
> SpringBoot内部提供了特有的注解：条件注解(Conditional Annotation)。

* 比如@ConditionalOnBean、@ConditionalOnClass、@ConditionalOnExpression、@ConditionalOnMissingBean等
* @ConditionalOnClass会检查类加载器中是否存在对应的类，如果有的话被注解修饰的类就有资格被Spring容器所注册，否则会被skip。

# 静态资源
设置静态资源放到指定路径下
* spring.resources.static-locations=classpath:/META-INF/resources/,classpath:/static/

# 自定义消息转化器
> 自定义消息转化器，只需要在@Configuration的类中添加消息转化器的@bean加入到Spring容器，就会被Spring boot自动加入到容器中。

```java
    @Bean
    public StringHttpMessageConverter stringHttpMessageConverter() {
        StringHttpMessageConverter converter = new StringHttpMessageConverter(Charset.forName("UTF-8"));
        return converter;
    }
```

# 自定义SpringMVC的配置
有些时候我们需要自己配置SpringMVC而不是采用默认，比如增加一个拦截器，这个时候就得通过继承WebMvcConfigureAdapter 然后重写父类中的方法进行扩展。

```java
@Configuration
public class SpringMVCConfig extends WebMvcConfigurerAdapter{
    
    @Autowired
    private  UserLoginHandlerInterceptor userLoginHandlerInterceptor;
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(userLoginHandlerInterceptor).addPathPatterns("/api/user/**");
    }
}
```

# 设置Mybatis 和 Spring Boot 整合

> Mybatis 和 Spring Boot的整合有两种方式：
* 第一种：使用mybatis官方提供的Spring Boot整合包实现，地址：https://github.com/mybatis/spring-boot-starter
* 第二种：使用mybatis-spring整合的方式，传统的方式

# 设置事务管理
在Spring Boot中推荐使用@Transaction注解来声明事务
当引入jdbc依赖后，spring boot会自动默认分别注入DataSourceTransactionManager 或者 JpaTransactionManager 所以我们不需要任何额外配置就可以用@Transaction注解进行事务的配置。

# redis spring 整合

# httpClient
多例

# 设置RabbitMQ 和 Spring的整合

> pom.xml
```xml
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-amqp</artifactId>
        </dependency>
```

> 配置queue
```java
@Configuration
public class RabbitMQSpringConfig {

    @Autowired
    private ConnectionFactory connectionFactory;

    @Bean
    public RabbitAdmin rabbitAdmin() {
        return new RabbitAdmin(connectionFactory)
    }

    @Bean
    public Queue blogUserLoginQueue() {
        return new Queue("BLOG-USER-LOGIN-QUEUE", true);
    }
}

```

> 设置监听
* @component 在类上
* @RabbitListener(queues = "BLOG-USER-LOGIN-QUEUE")

# dubbo 整合

```java
@ImportResource({"classpath:dubbo/dubbo-consumer.xml"})
```




