# 11_RabbitMQ之消息确认机制


## 例子代码地址
* https://github.com/csy512889371/learndemo/tree/master/ctoedu-rabitmq


# 概述
* 在 Rabbitmq 中我们可以通过持久化来解决因为服务器异常而导致丢失的问题
* 除此之外我们还会遇到一个问题:生产者将消息发送出去之后,消息到底有没有正确到达 Rabbit 服务器呢?如果不错得数处理,我们是不知道的,(即 Rabbit 服务器不会反馈任何消息给生产者),也就是默认的情况下是不知道消息有没有正确到达;

**导致的问题**:消息到达服务器之前丢失,那么持久化也不能解决此问题,因为消息根本就没有到达 Rabbit 服务器!

# RabbitMQ 为我们提供了两种方式:
* 1. 通过 AMQP 事务机制实现，这也是 AMQP 协议层面提供的解决方案；
* 2. 通过将 channel 设置成 confirm 模式来实现；


# 事务机制

* RabbitMQ 中与事务机制有关的方法有三个：txSelect(), txCommit()以及 txRollback(), txSelect 用于将当前 channel 设置成 transaction 模式
* txCommit 用于提交事务, txRollback 用于回滚事务，在通过 txSelect 开启事务之后，我们便可以发布消息给 broker 代理服务器了，如果 txCommit 提交成功了，则消息一定到达了 broker 了
* 如果在 txCommit执行之前 broker 异常崩溃或者由于其他原因抛出异常，这个时候我们便可以捕获异常通过 txRollback 回滚事务了。

关键代码：
```java
channel.txSelect();
channel.basicPublish("", QUEUE_NAME, null, msg.getBytes());
channel.txCommit();

```


## 生产者 

```java
import cn.ctoedu.rabbitmq.util.ConnectionUtils;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import org.junit.Test;

import java.io.IOException;

public class SendMQ {
    private static final String QUEUE_NAME = "QUEUE_simple";

    @Test
    public void sendMsg() throws IOException, TimeoutException {
/* 获取一个连接 */
        Connection connection = ConnectionUtils.getConnection();
/* 从连接中创建通道 */
        Channel channel = connection.createChannel();
        channel.queueDeclare(QUEUE_NAME, false, false, false, null);
        String msg = "Hello Simple QUEUE !";
        try {
            channel.txSelect();
            channel.basicPublish("", QUEUE_NAME, null, msg.getBytes());
            int result = 1 / 0;
            channel.txCommit();
        } catch (Exception e) {
            channel.txRollback();
            System.out.println("----msg rollabck ");
        } finally {
            System.out.println("---------send msg over:" + msg);
        }
        channel.close();
        connection.close();
    }
}
```

## 消费者 

```java
import cn.ctoedu.rabbitmq.util.ConnectionUtils;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.DefaultConsumer;
import com.rabbitmq.client.Envelope;

import java.io.IOException;

public class Consumer {
    private static final String QUEUE_NAME = "QUEUE_simple";

    public static void main(String[] args) throws Exception {
        Connection connection = ConnectionUtils.getConnection();
        Channel channel = connection.createChannel();
        channel.queueDeclare(QUEUE_NAME, false, false, false, null);
        DefaultConsumer consumer = new DefaultConsumer(channel) {
            //获取到达的消息
            @Override
            public void handleDelivery(String consumerTag, Envelope envelope,
                                       BasicProperties properties, byte[] body) throws IOException {
                String message = new String(body, "UTF-8");
                System.out.println(" [x] Received '" + message + "'");
            }
        };
        //监听队列
        channel.basicConsume(QUEUE_NAME, true, consumer);
    }
}
```
此种模式还是很耗时的,采用这种方式 降低了 Rabbitmq 的消息吞吐量

# Confirm 模式

## 概述
上面我们介绍了 RabbitMQ 可能会遇到的一个问题，即生成者不知道消息是否真正到达 broker，随后通过 AMQP 协议层面为我们提供了事务机制解决了这个问题，但是**采用事务机制实现会降低RabbitMQ 的消息吞吐量**，那么有没有更加高效的解决方式呢？答案是采用 Confirm 模式。

## producer 端 confirm 模式的实现原理

* 生产者将信道设置成 confirm 模式，一旦信道进入 confirm 模式，所有在该信道上面发布的消息都会被指派一个唯一的 ID(从 1 开始)
* 一旦消息被投递到所有匹配的队列之后，broker 就会发送一个确认给生产者（包含消息的唯一ID）,这就使得生产者知道消息已经正确到达目的队列了
* 如果消息和队列是可持久化的，那么确认消息会将消息写入磁盘之后发出，broker 回传给生产者的确认消息中 deliver-tag 域包含了确认消息的序列号
* 此外 broker 也可以设置 basic.ack 的 multiple 域，表示到这个序列号之前的所有消息都已经得到了处理。


* confirm 模式最大的好处在于他是异步的，一旦发布一条消息，生产者应用程序就可以在等信道返回确认的同时继续发送下一条消息，当消息最终得到确认之后，生产者应用便可以通过回调方法来处理该确认消息，
* 如果RabbitMQ 因为自身内部错误导致消息丢失，就会发送一条 nack 消息，生产者应用程序同样可以在回调方法中处理该 nack 消息。


## 开启 confirm 模式的方法

** 已经在 transaction 事务模式的 channel 是不能再设置成 confirm 模式的，即这两种模式是不能共存的。**

生产者通过调用 channel 的 confirmSelect 方法将 channel 设置为 confirm 模式

核心代码:
```java
//生产者通过调用channel的confirmSelect方法将channel设置为confirm模式
channel.confirmSelect();
```

编程模式
* 1. 普通 confirm 模式：每发送一条消息后，调用 waitForConfirms()方法，等待服务器端confirm。实际上是一种串行 confirm 了。
* 2. 批量 confirm 模式：每发送一批消息后，调用 waitForConfirms()方法，等待服务器端confirm。
* 3. 异步 confirm 模式：提供一个回调方法，服务端 confirm 了一条或者多条消息后 Client 端会回调这个方法。


## 1、普通 confirm 模式
```java

import cn.ctoedu.rabbitmq.util.ConnectionUtils;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import org.junit.Test;

import java.io.IOException;

public class SendConfirm {
    private static final String QUEUE_NAME = "QUEUE_simple_confirm";

    @Test
    public void sendMsg() throws IOException, TimeoutException,
            InterruptedException {
        /* 获取一个连接 */
        Connection connection = ConnectionUtils.getConnection();
        /* 从连接中创建通道 */
        Channel channel = connection.createChannel();
        channel.queueDeclare(QUEUE_NAME, false, false, false, null);
        //生产者通过调用channel的confirmSelect方法将channel设置为confirm模式
        channel.confirmSelect();
        String msg = "Hello QUEUE !";
        channel.basicPublish("", QUEUE_NAME, null, msg.getBytes());
        if (!channel.waitForConfirms()) {
            System.out.println("send message failed.");
        } else {
            System.out.println(" send messgae ok ...");
        }
        channel.close();
        connection.close();
    }
}

```


## 2、批量 confirm 模式

批量 confirm 模式稍微复杂一点，客户端程序需要定期（每隔多少秒）或者定量（达到多少条）或者两则结合起来publish 消息，然后等待服务器端 confirm, 相比普通 confirm 模式，批量极大提升 confirm 效率，但是问题在于一旦出现 confirm 返回 false 或者超时的情况时，客户端需要将这一批次的消息全部重发，这会带来明显的重复消息数量，并且，当消息经常丢失时，批量 confirm 性能应该是不升反降的。

```java
import cn.ctoedu.rabbitmq.util.ConnectionUtils;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import org.junit.Test;

import java.io.IOException;

public class SendbatchConfirm {
    private static final String QUEUE_NAME = "QUEUE_simple_confirm";

    @Test
    public void sendMsg() throws IOException, TimeoutException,
            InterruptedException {
        /* 获取一个连接 */
        Connection connection = ConnectionUtils.getConnection();
        /* 从连接中创建通道 */
        Channel channel = connection.createChannel();
        channel.queueDeclare(QUEUE_NAME, false, false, false, null);
        //生产者通过调用channel的confirmSelect方法将channel设置为confirm模式
        channel.confirmSelect();
        String msg = "Hello QUEUE !";
        for (int i = 0; i < 10; i++) {
            channel.basicPublish("", QUEUE_NAME, null, msg.getBytes());
        }
        if (!channel.waitForConfirms()) {
            System.out.println("send message failed.");
        } else {
            System.out.println(" send messgae ok ...");
        }
        channel.close();
        connection.close();
    }
}
```

## 3、异步 confirm 模式

* Channel 对象提供的 ConfirmListener()回调方法只包含 deliveryTag（当前 Chanel 发出的消息序号），我们需要自己为每一个 Channel 维护一个 unconfirm 的消息序号集合，每 publish 一条数据，集合中元素加 1，每回调一次 handleAck方法，unconfirm 集合删掉相应的一条（multiple=false）或多条（multiple=true）记录。从程序运行效率上看，这个unconfirm 集合最好采用有序集合 SortedSet 存储结构。
* 实际上，SDK 中的 waitForConfirms()方法也是通过 SortedSet维护消息序号的。

```java
import cn.ctoedu.rabbitmq.util.ConnectionUtils;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.ConfirmListener;
import com.rabbitmq.client.Connection;

import java.io.IOException;
import java.util.Collections;
import java.util.SortedSet;
import java.util.TreeSet;

public class SendAync {
    private static final String QUEUE_NAME = "QUEUE_simple_confirm_aync";

    public static void main(String[] args) throws IOException, TimeoutException {
        /* 获取一个连接 */
        Connection connection = ConnectionUtils.getConnection();
        /* 从连接中创建通道 */
        Channel channel = connection.createChannel();
        channel.queueDeclare(QUEUE_NAME, false, false, false, null);
        //生产者通过调用channel的confirmSelect方法将channel设置为confirm模式
        channel.confirmSelect();
        final SortedSet<Long> confirmSet = Collections.synchronizedSortedSet(new TreeSet<Long>());
        channel.addConfirmListener(new ConfirmListener() {
        //每回调一次handleAck方法，unconfirm集合删掉相应的一条（multiple=false）或多条（multiple=true）记录。

            @Override
            public void handleAck(long deliveryTag, boolean multiple) throws
                    IOException {
                if (multiple) {
                    System.out.println("--multiple--");
                    confirmSet.headSet(deliveryTag + 1).clear();//用一个SortedSet, 返回此有序集合中小于end的所有元素。
                } else {
                    System.out.println("--multiple false--");
                    confirmSet.remove(deliveryTag);
                }
            }

            @Override
            public void handleNack(long deliveryTag, boolean multiple) throws IOException {
                System.out.println("Nack, SeqNo: " + deliveryTag + ", multiple: " + multiple);
                if (multiple) {
                    confirmSet.headSet(deliveryTag + 1).clear();
                } else {
                    confirmSet.remove(deliveryTag);
                }
            }
        });
        String msg = "Hello QUEUE !";
        while (true) {
            long nextSeqNo = channel.getNextPublishSeqNo();
            channel.basicPublish("", QUEUE_NAME, null, msg.getBytes());
            confirmSet.add(nextSeqNo);
        }
    }
}
```



