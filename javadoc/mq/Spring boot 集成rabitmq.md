# Spring boot 集成rabitmq

## RabbitMQ的介绍

* RabbitMQ是消息中间件的一种,消息中间件即分布式系统中完成消息的发送和接收的基础软件.这些软件有很多,包括ActiveMQ(apache公司的),RocketMQ
* 消息中间件的工作过程可以用生产者消费者模型来表示.即,生产者不断的向消息队列发送信息,而消费者从消息队列中消费信息.
* 对于消息队列来说,生产者,消息队列,消费者是最重要的三个概念,生产者发消息到消息队列中去,消费者监听指定的消息队列,并且当消息队列收到消息之后,接收消息队列传来的消息,并且给予相应的处理.消息队列常用于分布式系统之间互相信息的传递.
* 对于RabbitMQ来说,除了这三个基本模块以外,还添加了一个模块,即交换机(Exchange).它使得生产者和消息队列之间产生了隔离,生产者将消息发送给交换机,而交换机则根据调度策略把相应的消息转发给对应的消息队列.

## 交换机有四种类型,分别为Direct,topic,headers,Fanout
* Direct是RabbitMQ默认的交换机模式,也是最简单的模式.即创建消息队列的时候,指定一个BindingKey.当发送者发送消息的时候,指定对应的Key.当Key和消息队列的BindingKey一致的时候,消息将会被发送到该消息队列中.
* topic转发信息主要是依据通配符,队列和交换机的绑定主要是依据一种模式(通配符+字符串),而当发送消息的时候,只有指定的Key和该模式相匹配的时候,消息才会被发送到该消息队列中.
* headers也是根据一个规则进行匹配,在消息队列和交换机绑定的时候会指定一组键值对规则,而发送消息的时候也会指定一组键值对规则,当两组键值对规则相匹配的时候,消息会被发送到匹配的消息队列中.
* Fanout是路由广播的形式,将会把消息发给绑定它的全部队列,即便设置了key,也会被忽略.

## pom.xml

添加对消息中间件的支持

```xml
        <!-- 加入消息中间件的依赖 -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-amqp</artifactId>
        </dependency>
```

## application.properties

```xml

spring.application.name=springboot-mq
spring.rabbitmq.host=10.211.55.9
spring.rabbitmq.port=5672
spring.rabbitmq.username=mytest
spring.rabbitmq.password=mytest
```

## 代码

1) 配置Queue(消息队列).那注意由于采用的是Direct模式,需要在配置Queue的时候,指定一个键,使其和交换机绑定

RabbitConfig.java
```java
@Configuration
public class RabbitConfig {

	@Bean
	public Queue bigdataQueue(){
		return new Queue("ctoedu");
	}
}

```

2) 使用AmqpTemplate去发送消息:

```java
@Component
public class Sender {
  
	@Autowired
	private AmqpTemplate rabbitTemplate;
	
	public void send(){
		String context="bigdataspringboot"+new Date();
		System.out.println("Sender:"+context);
		this.rabbitTemplate.convertAndSend("ctoedu",context);
	}
}
```


3) 配置监听器去监听绑定到的消息队列,当消息队列有消息的时候,予以接收

```java
@Component
@RabbitListener(queues="ctoedu")
public class Receiver {
   
	@RabbitHandler
	public void process(String data){
		System.out.println("Receiver:"+data);
	}
}
```

* Direct模式相当于一对一模式,一个消息被发送者发送后,会被转发到一个绑定的消息队列中,然后被一个接收者接收!
* RabbitMQ还可以支持发送对象:当然由于涉及到序列化和反序列化,该对象要实现Serilizable接口

