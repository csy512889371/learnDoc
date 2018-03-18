# rabbitmq java操作简单队列


## 例子代码地址
* https://github.com/csy512889371/learndemo/tree/master/ctoedu-rabitmq


## 队列-java 

官方 demo 使用的是 4.0.2 版本

```xml
<dependencies>
	<dependency>
		<groupId>com.rabbitmq</groupId>
		<artifactId>amqp-client</artifactId>
		<version>4.0.2</version>
	</dependency>
	<dependency>
		<groupId>org.slf4j</groupId>
		<artifactId>slf4j-api</artifactId>
		<version>1.7.10</version>
	</dependency>
	<dependency>
		<groupId>org.slf4j</groupId>
		<artifactId>slf4j-log4j12</artifactId>
		<version>1.7.5</version>
	</dependency>
	<dependency>
		<groupId>log4j</groupId>
		<artifactId>log4j</artifactId>
		<version>1.2.17</version>
	</dependency>
	<dependency>
		<groupId>junit</groupId>
		<artifactId>junit</artifactId>
		<version>4.11</version>
	</dependency>
</dependencies>
```

## 简单队列 hello world

### 模型图片 

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/23.png)

* P：消息的生产者
* C：消息的消费者
* 红色：队列

生产者将消息发送到队列，消费者从队列中获取消息。那么我们根据以上的模型,咱们抽取出 3 个对象 生产者(用户发送消息) 队列(中间件):类似于容器(存储消息) 消费者(获取队列中的消息)


## JAVA 操作 获取 MQ 连接

类似于我们在操作数据库的时候,的要获取到连接,然后才对数据进行操作

```java
package com.mmr.rabbitmq.conn;
import java.io.IOException;
import java.util.concurrent.TimeoutException;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.Connection;
public class ConnectionUtils {
	public static Connection getConnection() throws IOException, TimeoutException {
		//定义连接工厂
		ConnectionFactory factory = new ConnectionFactory();
		//设置服务地址
		factory.setHost("127.0.0.1");
		//端口
		factory.setPort(5672);//amqp协议 端口 类似与mysql的3306
		//设置账号信息，用户名、密码、vhost
		factory.setVirtualHost("/vhost_mmr");
		factory.setUsername("user_mmr");
		factory.setPassword("admin");
		// 通过工程获取连接
		Connection connection = factory.newConnection();
		return connection;
	}
}
```

## 生产者发送数据到消息队列 

```java

public class SendMQ {
	private static final String QUEUE_NAME="QUEUE_simple";
		/*
		P----->|QUEUE |
		*/
		@Test
		public void sendMsg() throws Exception {
		/* 获取一个连接 */
		Connection connection = ConnectionUtils.getConnection();
		/*从连接中创建通道*/
		Channel channel = connection.createChannel();
		//创建队列 (声明) 因为我们要往队列里面发送消息,这是后就得知道往哪个队列中发送,就好比在哪个管子里面放
		水,
		boolean durable=false;
		boolean exclusive=false;
		boolean autoDelete=false;
		channel.queueDeclare(QUEUE_NAME, durable, exclusive, autoDelete, null);//如果这个队列不存在,其实
		这句话是不需要的
		String msg="Hello Simple QUEUE !";
		//第一个参数是exchangeName(默认情况下代理服务器端是存在一个""名字的exchange的,
		 //因此如果不创建exchange的话我们可以直接将该参数设置成"",如果创建了exchange的话
		//我们需要将该参数设置成创建的exchange的名字),第二个参数是路由键
		channel.basicPublish("", QUEUE_NAME, null, msg.getBytes());
		System.out.println("---------send ms :"+msg);
		channel.close();
		connection.close();
	}
}
```

## 查看消息 


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/24.png)


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/25.png)

## 消费者消费

```java
import java.io.IOException;
import com.mmr.rabbitmq.conn.ConnectionUtils;
import com.rabbitmq.client.AMQP.BasicProperties;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.DefaultConsumer;
import com.rabbitmq.client.Envelope;
import com.rabbitmq.client.QueueingConsumer;
public class Consumer {
	private static final String QUEUE_NAME = "QUEUE_simple";
	public static void main(String[] args) throws Exception {
		/* 获取一个连接 */
		Connection connection = ConnectionUtils.getConnection();
		Channel channel = connection.createChannel();
		//声明队列 如果能确定是哪一个队列 这边可以删掉,不去掉 这里会忽略创建
		//channel.queueDeclare(QUEUE_NAME, false, false, false, null);
		DefaultConsumer consumer = new DefaultConsumer(channel) {
			//获取到达的消息
			@Override
			public void handleDelivery(String consumerTag, Envelope envelope, BasicProperties
				properties, byte[] body) throws IOException {
				
				
				String message = new String(body, "UTF-8");
				System.out.println(" [x] Received '" + message + "'");
			}
		};
		//监听队列
		channel.basicConsume(QUEUE_NAME, true, consumer);
	}
	
}
```

## 简单队列的不足 

耦合性高 生产消费一一对应(如果有多个消费者想都消费这个消息,就不行了) 队列名称变更时需要同时更改



