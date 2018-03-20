# spring boot整合RabbitMQ TOPIC

## 一、前言
本篇主要讲述Spring Boot与RabbitMQ的整合，内容非常简单，纯API的调用操作。 操作之间需要加入依赖Jar

```xml
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-amqp</artifactId>
		</dependency>
```

## 二、ConnectionFactory配置

* spring boot 的RabbitAutoConfiguration 中使用RabbitConnectionFactoryCreator来创建connectionFactory , 相关属性配置在RabbitProperties, 以spring.rabbitmq 开头。
* 也可自定义 connectionFactory 如下
* 本例子使用 spring boot 内置的connectFactory

```java

@Configuration  
public class RabbitConfig {  
  
    public static final String EXCHANGE   = "trmessageExchange";  

  
    @Bean  
    public ConnectionFactory connectionFactory() {  
        CachingConnectionFactory connectionFactory = new CachingConnectionFactory();  
        connectionFactory.setAddresses("127.0.0.1:5672");  
        connectionFactory.setUsername("guest");  
        connectionFactory.setPassword("guest");  
        connectionFactory.setVirtualHost("/");  
        connectionFactory.setPublisherConfirms(true); //如果需要confirm则设置为true  
        return connectionFactory;  
    }  
}  
```


## 三、消息生产者

RabbitConstans:

```java
/**
 *  rabbit 常量类
 */
public class RabbitConstans {

    /**
     * 交换机的名称
     */
    public static final String EXCHANGE = "trmessageExchange";

    /**
     * 路由key 前缀
     */
    public static final String PREROUTINGKEY = "trmessage";

    /**
     * 路由分割符号
     */
    public static final String PREROUTINGSEG = ".";
}
```

TrmessageBean:

```java

/**
 * 消息体
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TrmessageBean implements Serializable {

    private static final long serialVersionUID = 3387041179388866333L;

    /**
     * 模块
     */
    private String routingModule;

    /**
     * 子模块
     */
    private String routingSub;

    /**
     * 消息数据
     */
    private String context;


}

```

TrmessageSender:

```java

/**
 * 消息发送
 */
@Component
@Slf4j
public class TrmessageSender {

    @Autowired
    private AmqpTemplate rabbitTemplate;

    /**
     * 发送消息
     *
     * @param trmessageBean 消息实体
     */
    public void send(TrmessageBean trmessageBean) {
        String routingKey = RabbitConstans.PREROUTINGKEY + RabbitConstans.PREROUTINGSEG + trmessageBean.getRoutingModule() + RabbitConstans.PREROUTINGSEG + trmessageBean.getRoutingSub();

        log.info(routingKey);
        rabbitTemplate.convertAndSend(RabbitConstans.EXCHANGE, routingKey, trmessageBean);
    }

}
```

* 通过使用RabbitTemplate来对开发者提供API操作


在发送消息时通过调用RabbitTemplate中的如下方法

```java
public void convertAndSend(String exchange, String routingKey, final Object object, CorrelationData correlationData) 
```

* exchange:交换机名称
* routingKey:路由关键字
* object:发送的消息内容
* correlationData:消息ID


## 消息消费者

消费者负责申明交换机(生产者也可以申明)、队列、两者的绑定操作。

交换机

```java
	/**  
     * 针对消费者配置  
        FanoutExchange: 将消息分发到所有的绑定队列，无routingkey的概念  
        HeadersExchange ：通过添加属性key-value匹配  
        DirectExchange:按照routingkey分发到指定队列  
        TopicExchange:多关键字匹配  
     */  
    @Bean
    TopicExchange exchange() {
        return new TopicExchange(RabbitConstans.EXCHANGE);
    }
```

在Spring Boot中交换机继承AbstractExchange类

### 队列

* 这里定义了两个队列。用于绑定不同的routing key
```java
    /**
     * 查询相关的消息队列
     *
     * @return 消息队列
     */
    @Bean
    public Queue xfQueryQueue() {
        return new Queue("xfQueryQueue");
    }

    /**
     * 统计分析相关的queue
     *
     * @return 消息队列
     */
    @Bean
    public Queue xfAnalyQueue() {
        return new Queue("xfAnalyQueue");
    }
```

### 绑定
* 对以上定义的queue 进行绑定到不同的交换机上

```java
    @Bean
    Binding bindingXfQueryQueue(@Qualifier("xfQueryQueue") Queue queueMessages, TopicExchange exchange) {
        return BindingBuilder.bind(queueMessages).to(exchange).with("trmessage.xfQuery.*");
    }

    @Bean
    Binding bindingXfAnalyQueue(@Qualifier("xfAnalyQueue") Queue queueMessages, TopicExchange exchange) {
        return BindingBuilder.bind(queueMessages).to(exchange).with("trmessage.xfAnaly.*");
    }
```

完成以上工作后，在spring boot中通过消息监听容器实现消息的监听，在消息到来时执行回调操作。

### 消息消费

```java
@Component
@RabbitListener(queues = "xfAnalyQueue")
public class XfAnalyReceiver {

    @RabbitHandler
    public void process(TrmessageBean trmessageBean) {
        System.out.println("xfAnaly receiver" + trmessageBean);
    }
}


@Component
@RabbitListener(queues = "xfQueryQueue")
public class XfQueryReceiver {

    @RabbitHandler
    public void process(TrmessageBean trmessageBean) {
        System.out.println("xfQuery receiver" + trmessageBean);
    }
}
```

## 下面给出完整的配置文件：

```java
@Configuration
public class RabbitConfig {



    /**
     * 查询相关的消息队列
     *
     * @return 消息队列
     */
    @Bean
    public Queue xfQueryQueue() {
        return new Queue("xfQueryQueue");
    }

    /**
     * 统计分析相关的queue
     *
     * @return 消息队列
     */
    @Bean
    public Queue xfAnalyQueue() {
        return new Queue("xfAnalyQueue");
    }


    /**
     * 创建交换机
     *
     * @return 交换机
     */
    @Bean
    TopicExchange exchange() {
        return new TopicExchange(RabbitConstans.EXCHANGE);
    }

    /**
     * 队列绑定并关联到RoutingKey
     *
     * @param queueMessages 队列名称
     * @param exchange      交换机
     * @return 绑定
     */
    @Bean
    Binding bindingXfQueryQueue(@Qualifier("xfQueryQueue") Queue queueMessages, TopicExchange exchange) {
        return BindingBuilder.bind(queueMessages).to(exchange).with("trmessage.xfQuery.*");
    }

    @Bean
    Binding bindingXfAnalyQueue(@Qualifier("xfAnalyQueue") Queue queueMessages, TopicExchange exchange) {
        return BindingBuilder.bind(queueMessages).to(exchange).with("trmessage.xfAnaly.*");
    }
}

```



## application.yml

```xml

spring:
  rabbitmq:
    host: 205.0.3.94
    port: 5672
    username: admin
    password: admin123
```




