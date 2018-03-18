# rabbitmq work queues 工作队列


# 模型图

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/26.png)

## 例子代码地址
* https://github.com/csy512889371/learndemo/tree/master/ctoedu-rabitmq

# 为什么会出现 work queues?

> 前提:使用 simple 队列的时候

* 我们应用程序在是使用消息系统的时候,一般生产者 P 生产消息是毫不费力的(发送消息即可),而消费者接收完消息后的需要处理,会耗费一定的时间,这时候,就有可能导致很多消息堆积在队列里面,一个消费者有可能不够用
* 那么怎么让消费者同事处理多个消息呢?在同一个队列上创建多个消费者,让他们相互竞争,这样消费者就可以同时处理多条消息了
* 使用任务队列的优点之一就是可以轻易的并行工作。如果我们积压了好多工作，我们可以通过增加工作者（消费者）来解决这一问题，使得系统的伸缩性更加容易。


# Round-robin（轮询分发）

生产者发送消息
```java
public class Send {
	private final static String QUEUE_NAME = "test_queue_work";
	public static void main(String[] argv) throws Exception {
		// 获取到连接以及mq通道
		Connection connection = ConnectionUtils.getConnection();
		Channel channel = connection.createChannel();
		// 声明队列
		channel.queueDeclare(QUEUE_NAME, false, false, false, null);
		for (int i = 0; i < 50; i++) {
			// 消息内容
			String message = "." + i;
			channel.basicPublish("", QUEUE_NAME, null, message.getBytes());
			System.out.println(" [x] Sent '" + message + "'");
			Thread.sleep(i * 10);
		}
		channel.close();
		connection.close();
	}
}

```

## 消费者 1 

```java
@SuppressWarnings("deprecation")
public class Recv1 {
	private final static String QUEUE_NAME = "test_queue_wor1k";
	public static void main(String[] args) throws Exception {
		// 获取到连接以及mq通道
		Connection connection = ConnectionUtils.getConnection();
		final Channel channel = connection.createChannel();
		// 声明队列，主要为了防止消息接收者先运行此程序，队列还不存在时创建队列。
		channel.queueDeclare(QUEUE_NAME, false, false, false, null);
		//定义一个消息的消费者
		final Consumer consumer = new DefaultConsumer(channel) {
			@Override
			public void handleDelivery(String consumerTag, Envelope envelope, BasicProperties
				properties, byte[] body) throws IOException {
				
				String message = new String(body, "UTF-8");
				System.out.println(" [1] Received '" + message + "'");
					
				try {
					doWork(message);
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					System.out.println(" [x] Done");
				}
			}
		};
		boolean autoAck = true; //消息的确认模式自动应答
		channel.basicConsume(QUEUE_NAME, autoAck, consumer);
	}
	private static void doWork(String task) throws InterruptedException {
		Thread.sleep(1000);
	}
	
}

```

## 消费者 2 

```java
public class Recv2 {
	private final static String QUEUE_NAME = "test_queue_work";
	public static void main(String[] args) throws Exception {
		// 获取到连接以及mq通道
		Connection connection = ConnectionUtils.getConnection();
		final Channel channel = connection.createChannel();
		// 声明队列
		channel.queueDeclare(QUEUE_NAME, false, false, false, null);
		//定义一个消息的消费者
		final Consumer consumer = new DefaultConsumer(channel) {
			@Override
			public void handleDelivery(String consumerTag, Envelope envelope, BasicProperties
				properties, byte[] body) throws IOException {
				
				String message = new String(body, "UTF-8");
				System.out.println(" [2] Received '" + message + "'");
				
				try {
					Thread.sleep(2000);
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					System.out.println(" [x] Done");
				}
			}
		};
		
		boolean autoAck = true; //
		channel.basicConsume(QUEUE_NAME, autoAck, consumer);
	}
}
```

## 测试

* 备注:消费者 1 我们处理时间是 1s ;而消费者 2 中处理时间是 2s;
* 但是我们看到的现象并不是 1 处理的多 消费者 2 处理的少,

```java
[1] Received '.0'
[x] Done
[1] Received '.2'
[x] Done
[1] Received '.4'
[x] Done
[1] Received '.6'
……….
```

消费者 1 中将偶数部分处理掉了

```java
[2] Received '.1'
[x] Done
[2] Received '.3'
[x] Done
[2] Received '.5'
[x] Done
…… .. . . .
```
消费者2中将基数部分处理掉了

> 我想要的是 1 处理的多,而 2 处理的少

测试结果:
* 1.消费者 1 和消费者 2 获取到的消息内容是不同的,同一个消息只能被一个消费者获取
* 2.消费者 1 和消费者 2 货到的消息数量是一样的 一个奇数一个偶数
* 按道理消费者 1 获取的比消费者 2 要多

**结果就是不管谁忙或清闲，都不会给谁多一个任务或少一个任务，任务总是你一个我一个的分**

# Fair dispatch（公平分发）


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/27.png)

* 虽然上面的分配法方式也还行，但是有个问题就是：比如：现在有 2 个消费者，所有的偶数的消息都是繁忙的，而奇数则是轻松的。按照轮询的方式，偶数的任务交给了第一个消费者，所以一直在忙个不停。奇数的任务交给另一个消费者，则立即完成任务，然后闲得不行。
* 而 RabbitMQ 则是不了解这些的。他是不知道你消费者的消费能力的,这是因为当消息进入队列，RabbitMQ 就会分派消息。而 rabbitmq 只是盲目的将消息轮询的发给消费者。你一个我一个的这样发送.
* 为了解决这个问题，我们使用 basicQos( prefetchCount = 1)方法，来限制 RabbitMQ 只发不超过 1 条的消息给同一个消费者。当消息处理完毕后，有了反馈 ack，才会进行第二次发送。(也就是说需要手动反馈给 Rabbitmq )

**还有一点需要注意，使用公平分发，必须关闭自动应答，改为手动应答。**

## 生产者 
```java
public class Send {
	private final static String QUEUE_NAME = "test_queue_work";
	public static void main(String[] argv) throws Exception {
		// 获取到连接以及mq通道
		Connection connection = ConnectionUtils.getConnection();
		 // 创建一个频道
		Channel channel = connection.createChannel();
		 // 指定一个队列
		channel.queueDeclare(QUEUE_NAME, false, false, false, null);
		int prefetchCount = 1;

		//每个消费者发送确认信号之前，消息队列不发送下一个消息过来，一次只处理一个消息
		 //限制发给同一个消费者不得超过1条消息
		 channel.basicQos(prefetchCount);
		// 发送的消息
		for (int i = 0; i < 50; i++) {
			String message = "." + i;
			 // 往队列中发出一条消息
			channel.basicPublish("", QUEUE_NAME, null, message.getBytes());
			System.out.println(" [x] Sent '" + message + "'");
			Thread.sleep(i * 10);
		}
		// 关闭频道和连接
		channel.close();
		connection.close();
	}
}

```

## 消费者 1 

```java
public class Recv1 {
	private final static String QUEUE_NAME = "test_queue_work";
	public static void main(String[] args) throws Exception {
		// 获取到连接以及mq通道
		Connection connection = ConnectionUtils.getConnection();
		final Channel channel = connection.createChannel();
		// 声明队列，主要为了防止消息接收者先运行此程序，队列还不存在时创建队列。
		channel.queueDeclare(QUEUE_NAME, false, false, false, null);
		 channel.basicQos(1);//保证一次只分发一个
		//定义一个消息的消费者
		final Consumer consumer = new DefaultConsumer(channel) {
			@Override
			public void handleDelivery(String consumerTag, Envelope envelope, BasicProperties
				properties, byte[] body) throws IOException {
				String message = new String(body, "UTF-8");
				System.out.println(" [1] Received '" + message + "'");
				try {
					doWork(message);
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					System.out.println(" [x] Done");
					channel.basicAck(envelope.getDeliveryTag(), false);
				}
			}
		};
		boolean autoAck = false; //手动确认消息
		channel.basicConsume(QUEUE_NAME, autoAck, consumer);
		}
		private static void doWork(String task) throws InterruptedException {
		Thread.sleep(1000);
	}
}

```

## 消费者 2 

```java
@SuppressWarnings("deprecation")
public class Recv2 {
	private final static String QUEUE_NAME = "test_queue_work";
	public static void main(String[] args) throws Exception {
		// 获取到连接以及mq通道
		Connection connection = ConnectionUtils.getConnection();
		final Channel channel = connection.createChannel();
		// 声明队列
		channel.queueDeclare(QUEUE_NAME, false, false, false, null);
		channel.basicQos(1);//保证一次只分发一个
		//定义一个消息的消费者
		final Consumer consumer = new DefaultConsumer(channel) {
			@Override
			public void handleDelivery(String consumerTag, Envelope envelope, BasicProperties
			properties, byte[] body) throws IOException {
			
				String message = new String(body, "UTF-8");
				System.out.println(" [2] Received '" + message + "'");
				
				try {
					doWork(message);
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					System.out.println(" [x] Done");
					channel.basicAck(envelope.getDeliveryTag(), false);
				}
			}
			};
			boolean autoAck = false; //关闭自动 确认
			channel.basicConsume(QUEUE_NAME, autoAck, consumer);
		}
		
		private static void doWork(String task) throws InterruptedException {
			Thread.sleep(2000);
		}
		
}

```

这时候现象就是消费者 1 速度大于消费者 2
