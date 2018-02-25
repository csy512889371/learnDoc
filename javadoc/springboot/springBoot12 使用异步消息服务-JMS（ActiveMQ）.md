# 使用异步消息服务-JMS（ActiveMQ）
Spring Boot支持的jms有：ActiveMQ、Artemis、HornetQ

# 添加依赖
```xml
		<!-- jms -->
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-activemq</artifactId>
		</dependency>
```

# 配置文件
```xml
# ACTIVEMQ (ActiveMQProperties)
spring.activemq.in-memory=true
#spring.activemq.broker-url= 
#spring.activemq.password= 
#spring.activemq.user= 
#spring.activemq.packages.trust-all=false
#spring.activemq.packages.trusted=
#spring.activemq.pool.configuration.*= 
#spring.activemq.pool.enabled=false
#spring.activemq.pool.expiry-timeout=0
#spring.activemq.pool.idle-timeout=30000
#spring.activemq.pool.max-connections=1
```

# 代码实现
启动注解：
* @EnableJms 添加在main方法里面

# 配置队列
```java
/**
 * jms队列配置
 * 
 */
@Configuration
publicclass JmsConfiguration {

	@Bean
	publicQueue queue() {
		returnnew ActiveMQQueue("ctoedu.queue");
	}

}
```

```java
@Component
publicclass JmsComponent {

	@Autowired
	private JmsMessagingTemplate jmsMessagingTemplate;
	
	@Autowired
	private Queue queue;

	publicvoid send(String msg) {
		this.jmsMessagingTemplate.convertAndSend(this.queue, msg);
	}
	
	@JmsListener(destination = "ctoedu.queue")
	publicvoid receiveQueue(String text) {
		System.out.println("接受到：" + text);
	}

}

```

# 测试

```java
@Autowired
	private JmsComponent jmsComponent;

	@Test
	public void send() {
		jmsComponent.send("hello world");
	}


```

