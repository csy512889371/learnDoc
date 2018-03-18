# rabbimq订阅模式 PublishSubscribe


## 例子代码地址
* https://github.com/csy512889371/learndemo/tree/master/ctoedu-rabitmq

## 模型图
我们之前学习的都是一个消息只能被一个消费者消费,那么如果我想发一个消息 能被多个消费者消费,这时候怎么办? 这时候我们就得用到了消息中的发布订阅模型

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/28.png)

* 在前面的教程中，我们创建了一个工作队列，都是一个任务只交给一个消费者。
* 这次我们做 将消息发送给多个消费者。这种模式叫做“发布/订阅”。

### 举列:
类似微信订阅号 发布文章消息 就可以广播给所有的接收者。(订阅者)

那么咱们来看一下图,我们学过前两种有一些不一样,work 模式 是不是同一个队列 多个消费者,而 ps 这种模式呢,是一个队列对应一个消费者,pb 模式还多了一个 X(交换机 转发器) ,这时候我们要获取消息 就需要队列绑定到交换机上,交换机把消息发送到队列 , 消费者才能获取队列的消息

解读：
* 1、1 个生产者，多个消费者
* 2、每一个消费者都有自己的一个队列
* 3、生产者没有将消息直接发送到队列，而是发送到了交换机(转发器)
* 4、每个队列都要绑定到交换机
* 5、生产者发送的消息，经过交换机，到达队列，实现，一个消息被多个消费者获取的目的

注册完 发短信 发邮件

## 生产者

后台注册 ->邮件->短信

```java
public class Send {
	 private final static String EXCHANGE_NAME = "test_exchange_fanout";
	 public static void main(String[] argv) throws Exception {
		 // 获取到连接以及mq通道
		 Connection connection = ConnectionUtils.getConnection();
		 Channel channel = connection.createChannel();
		 // 声明exchange 交换机 转发器
		 channel.exchangeDeclare(EXCHANGE_NAME, "fanout"); //fanout 分裂
		 // 消息内容
		 String message = "Hello PB";
		 channel.basicPublish(EXCHANGE_NAME, "", null, message.getBytes());
		 System.out.println(" [x] Sent '" + message + "'");
		 channel.close();
		 connection.close();
	 }
}

```

那么先看一下控制台 是不是有这个交换机

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/29.png)

但是这个发送的消息到哪了呢? 消息丢失了!!!因为交换机没有存储消息的能力,在 rabbitmq 中只有队列存储消息的能力.因为这时还没有队列,所以就会丢失;

小结:消息发送到了一个没有绑定队列的交换机时,消息就会丢失!

那么我们再来写消费者

## 消费者 1

邮件发送系统

```java
public class Recv {
	private final static String QUEUE_NAME = "test_queue_fanout_email";
	private final static String EXCHANGE_NAME = "test_exchange_fanout";
	public static void main(String[] argv) throws Exception {
		// 获取到连接以及mq通道
		Connection connection = ConnectionUtils.getConnection();
		final Channel channel = connection.createChannel();
		// 声明队列
		channel.queueDeclare(QUEUE_NAME, false, false, false, null);
		// 绑定队列到交换机
		channel.queueBind(QUEUE_NAME, EXCHANGE_NAME, "");
		//------------下面逻辑和work模式一样-----
		// 同一时刻服务器只会发一条消息给消费者
		channel.basicQos(1);
		// 定义一个消费者
		Consumer consumer = new DefaultConsumer(channel) {
			// 消息到达 触发这个方法
			@Override
			public void handleDelivery(String consumerTag, Envelope envelope,
			BasicProperties properties, byte[] body) throws IOException {
				String msg = new String(body, "utf-8");
				System.out.println("[1] Recv msg:" + msg);
				try {
					Thread.sleep(1000);
				} catch (InterruptedException e) {
					e.printStackTrace();
				} finally {
					System.out.println("[1] done ");
					// 手动回执
					channel.basicAck(envelope.getDeliveryTag(), false);
				}
			}
		};
		boolean autoAck = false;
		channel.basicConsume(QUEUE_NAME, autoAck, consumer);
	}
}

```

## 消费者 2

类似短信发送系统

```java
public class Recv2 {

	private final static String QUEUE_NAME = "test_queue_fanout_2";
	private final static String EXCHANGE_NAME = "test_exchange_fanout";
	
	public static void main(String[] argv) throws Exception {
		// 获取到连接以及mq通道
		Connection connection = ConnectionUtils.getConnection();
		final Channel channel = connection.createChannel();
		// 声明队列
		channel.queueDeclare(QUEUE_NAME, false, false, false, null);
		// 绑定队列到交换机
		channel.queueBind(QUEUE_NAME, EXCHANGE_NAME, "");
		// 同一时刻服务器只会发一条消息给消费者
		// 定义一个消费者
		Consumer consumer = new DefaultConsumer(channel) {
			// 消息到达 触发这个方法
			@Override
			public void handleDelivery(String consumerTag, Envelope envelope,
			BasicProperties properties, byte[] body) throws IOException {
				String msg = new String(body, "utf-8");
				System.out.println("[2] Recv msg:" + msg);
				try {
					Thread.sleep(1000);
				} catch (InterruptedException e) {
					e.printStackTrace();
				} finally {
					System.out.println("[2] done ");
					// 手动回执
					channel.basicAck(envelope.getDeliveryTag(), false);
				}
			}
		};
		boolean autoAck = false;
		channel.basicConsume(QUEUE_NAME, autoAck, consumer);
	}
}
```

## 测试

一个消息 可以被多个消费者获取
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/30.png)
