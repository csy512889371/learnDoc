# 使用异步消息服务-AMQP（RabbitMQ）

* RabbitMQ下载地址：http://www.rabbitmq.com/download.html
* erlang 下载地址：http://www.erlang.org/downloads

# 添加依赖
```xml
<!-- amqp -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-amqp</artifactId>
</dependency>
```

# 配置文件
```xml
# RABBIT (RabbitProperties)
#spring.rabbitmq.host=localhost
#spring.rabbitmq.port=5672
#spring.rabbitmq.password=
#spring.rabbitmq.username=
```
# 代码实现
* 1.启用注解： @EnableRabbit
* 2.配置

```java
/**
 * amqp队列配置
 * 
 */
@Configuration
publicclass AmqpConfiguration {

	@Bean
	public Queue queue() {
		returnnew Queue("ctoedu.queue");
	}
}

```

```java

@Component
publicclass AmqpComponent {

	@Autowired
	private AmqpTemplate amqpTemplate;

	publicvoid send(String msg) {
		this.amqpTemplate.convertAndSend("ctoedu.queue", msg);
	}

	@RabbitListener(queues = "ctoedu.queue")
	publicvoid receiveQueue(String text) {
		System.out.println("接受到：" + text);
	}
}

```

四、测试

```java
    @Autowired
	private AmqpComponent amqpComponent;

	@Test
	publicvoid send() {
		amqpComponent.send("hello world2");
	}
```

