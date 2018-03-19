# 8_rabbimq路由模式

## 模型

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/31.png)

## 例子代码地址
* https://github.com/csy512889371/learndemo/tree/master/ctoedu-rabitmq


## 生产者

```java

public class Send {
	 private final static String EXCHANGE_NAME = "test_exchange_direct";
	 public static void main(String[] argv) throws Exception {
		 // 获取到连接以及mq通道
		 Connection connection = ConnectionUtils.getConnection();
		 Channel channel = connection.createChannel();
		 // 声明exchange
		 channel.exchangeDeclare(EXCHANGE_NAME, "direct");
		 // 消息内容
		 String message = "id=1001的商品删除了";
		 channel.basicPublish(EXCHANGE_NAME, "delete", null, message.getBytes());
		 System.out.println(" [x] Sent '" + message + "'");
		 channel.close();
		 connection.close();
	 }
}

```

## 消费者 1

```java

import cn.ctoedu.rabbitmq.util.ConnectionUtils;
import com.rabbitmq.client.*;

import java.io.IOException;

public class Recv {
    private final static String QUEUE_NAME = "test_queue_direct_1";
    private final static String EXCHANGE_NAME = "test_exchange_direct";

    public static void main(String[] argv) throws Exception {
        // 获取到连接以及mq通道
        Connection connection = ConnectionUtils.getConnection();
        final Channel channel = connection.createChannel();
        // 声明队列
        channel.queueDeclare(QUEUE_NAME, false, false, false, null);
        // 绑定队列到交换机
        channel.queueBind(QUEUE_NAME, EXCHANGE_NAME, "update");
        channel.queueBind(QUEUE_NAME, EXCHANGE_NAME, "delete");
        // 同一时刻服务器只会发一条消息给消费者
        channel.basicQos(1);
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

消费者 2

```java
public class Recv2 {
    private static final String QUEUE_NAME = "test_work_queue";

    public static void main(String[] args) throws IOException, TimeoutException {
        //获取连接
        Connection connection = ConnectionUtils.getConnection();
        //获取channel
        final Channel channel = connection.createChannel();
        //声明队列
        channel.queueDeclare(QUEUE_NAME, false, false, false, null);
        channel.basicQos(1);//保证一次只分发一个
        //定义一个消费者
        Consumer consumer = new DefaultConsumer(channel) {
            //消息到达 触发这个方法
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
                    //手动回执
                    channel.basicAck(envelope.getDeliveryTag(), false);
                }
            }
        };
        boolean autoAck = false;
        channel.basicConsume(QUEUE_NAME, autoAck, consumer);
    }
}
```


