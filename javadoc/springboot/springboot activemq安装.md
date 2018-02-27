# springboot activemq安装


## 1、新建一个spring boot工程

选择Lombok、JMS、Web三个starter组件，点击完成。Lombok用来给模型自动添加setter、getter、constructor方法。

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mq/1.png)

## 2、修改ActiveMQ配置
在application.yml中添加如下配置
```xml
spring:
  #activemq
  activemq:
    in-memory: true
    pool:
      enabled: false
```
* 实际上这两个是默认值，不配置情况下即是如此

## 3、添加ProducerController类

```java
@RestController
public class ProducerController {
    @Autowired
    private JmsMessagingTemplate jmsMessagingTemplate;

    @Autowired
    private Queue queue;

    @RequestMapping("/sendMsg")
    public void send(String msg) {
        this.jmsMessagingTemplate.convertAndSend(this.queue, msg);
    }
}
```

* @RestController相当于指定类内部的@RequestMapping返回值都是json，就不需要添加@ResponseBody注解了。
* jmsMessagingTemplate和queue都是用@Autowired注解自动注入.其中jmsMessagingTemplate的实例化是spring boot的autoconfigure自动注入的。
* 参见JmsAutoConfiguration.java。大概意思就是当我们引入了jms相关的包，比如activemq的包，又定义了ConnectionFactory的实例，那么他就会自动生成一个JmsTemplate实例。
* ActiveMQConnectionFactoryConfiguration.java。大概意思是，如果没有ConnectionFactory实例，就自动创建一个实例。
* 所以说，只要引入了spring-boot-starter-activemq那么就会给我们自动创建一个JmsTemplate，相关的连接配置从application.properties，如果里面没有配置的话就会使用ActiveMQProperties.java的默认值。

## 4.添加Consumer类

```java
@Component
public class Consumer {

    @JmsListener(destination = "sample.queue")
    public void receiveQueue(String text) {
        System.out.println(text);
    }
}
```
* msListener是spring-jms提供的一个注解，会实例化一个Jms的消息监听实例，也就是一个异步的消费者

## 5.添加JMS的注解扫描

```java
@SpringBootApplication
@EnableJms
public class ActivemqDemoApplication {
    @Bean
    public Queue queue() {
        return new ActiveMQQueue("sample.queue");
    }

    public static void main(String[] args) {
        SpringApplication.run(ActivemqDemoApplication.class, args);
    }
}
```
* @EnableJms会启动jms的注解扫描，相当于<jms:annotation-d riven/>

## 6.启动项目
浏览器输入：http://localhost:8080/sendMsg?msg=HelloActiveMQ


## 7.连接外部的ActiveMQ

> 安装activeMQ


* ActiveMQ默认启动到8161端口，启动完了后在浏览器地址栏输入：http://localhost:8161/admin
* 默认用户名密码为admin、admin

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mq/1.jpg)



- 修改一下配置，来使用外部的ActiveMQ服务
```xml
spring:
  #activemq
  activemq:
    broker-url: tcp://localhost:61616
    close-timeout: 5000
    in-memory: false
    pool:
      max-connections: 100
      enabled: false
    send-timeout: 3000
```

设置pool.enabled=true，如果添加activemq-pool的依赖包

```xml
<dependency>
   <groupId>org.apache.activemq</groupId>
    <artifactId>activemq-pool</artifactId>
   <!--  <version>5.7.0</version> -->
</dependency>
```

## 8.jmsTemplate支持queue和topic

