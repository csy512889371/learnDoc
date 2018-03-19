# 12_Spring rabbit mq 整合


## 简介
为了更好更快速的去开发 Rabbitmq 应用,spring 封装 client ;目的是简化我们的使用.

https://projects.spring.io/spring-amqp/


## 开发集成
maven 依赖
```java

<dependencies>
	 <dependency>
		<groupId>org.springframework.amqp</groupId>
		<artifactId>spring-rabbit</artifactId>
		 <version>1.7.5.RELEASE</version>
	</dependency>
</dependencies>
```


## 生产者
```java
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class SpringMain {
    public static void main(final String... args) throws Exception {
        AbstractApplicationContext ctx = new ClassPathXmlApplicationContext("classpath:context.xml");
        //RabbitMQ模板
        RabbitTemplate template = ctx.getBean(RabbitTemplate.class);
        //发送消息
        template.convertAndSend("Hello, world!");
        Thread.sleep(1000);// 休眠1秒
        ctx.destroy(); //容器销毁
    }
}
```

## 消费者

```java
public class MyConsumer {
    //具体执行业务的方法
    public void listen(String foo) {
        System.out.println("消费者： " + foo);
    }
}
```

## Context.xml 配置文件

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:rabbit="http://www.springframework.org/schema/rabbit"
       xsi:schemaLocation="http://www.springframework.org/schema/rabbit
http://www.springframework.org/schema/rabbit/spring-rabbit-1.4.xsd
http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans-4.0.xsd">
    <!—1.定义RabbitMQ的连接工厂 -->
    <rabbit:connection-factory id="connectionFactory"
                               host="127.0.0.1" port="5672" username="user_mmr" password="admin"
                               virtual-host="/vhost_mmr"/>
    <!—2.定义Rabbit模板，指定连接工厂以及定义exchange -->
    <rabbit:template id="amqpTemplate" connection-factory="connectionFactory"
                     exchange="fanoutExchange"/>
    如果不想将消息发送到交换机 可以将它设置成队列 将交换机删除
    <!-- MQ的管理，包括队列、交换器 声明等 -->
    <rabbit:admin connection-factory="connectionFactory"/>
    <!-- 定义队列，自动声明 -->
    <rabbit:queue name="myQueue" auto-declare="true" durable="true"/>
    <!-- 定义交换器，自动声明 -->
    <rabbit:fanout-exchange name="fanoutExchange" auto-declare="true">
        <rabbit:bindings>
            <rabbit:binding queue="myQueue"/>
        </rabbit:bindings>
    </rabbit:fanout-exchange>
    <!-- 队列监听 -->
    <rabbit:listener-container connection-factory="connectionFactory">
        <rabbit:listener ref="foo" method="listen" queue-names="myQueue"/>
    </rabbit:listener-container>
    <!-- 消费者 -->
    <bean id="foo" class="com.mmr.rabbitmq.spring.MyConsumer"/>
</bean
```

