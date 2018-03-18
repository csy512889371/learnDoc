# 6_rabbitmq消息应答与消息持久化

## 例子代码地址
* https://github.com/csy512889371/learndemo/tree/master/ctoedu-rabitmq


## 消息应答与消息持久化

###1 Message acknowledgment（消息应答）

>* 1. boolean autoAck = false;
>* 2. channel.basicConsume(QUEUE_NAME, autoAck, consumer);

* boolean autoAck = true;(自动确认模式)一旦 RabbitMQ 将消息分发给了消费者，就会从内存中删除。在这种情况下，如果杀死正在执行任务的消费者，会丢失正在处理的消息，也会丢失已经分发给这个消费者但尚未处理的消息。
* boolean autoAck = false; (手动确认模式) 我们不想丢失任何任务，如果有一个消费者挂掉了，那么我们应该将分发给它的任务交付给另一个消费者去处理。 为了确保消息不会丢失，RabbitMQ 支持消息应答。消费者发送一个消息应答，告诉 RabbitMQ 这个消息已经接收并且处理完毕了。RabbitMQ 可以删除它了。
* 消息应答是默认打开的。也就是 boolean autoAck =false;


## Message durability（消息持久化）
我们已经了解了如何确保即使消费者死亡，任务也不会丢失。但是如果 RabbitMQ 服务器停止，我们的任务仍将失去！当 RabbitMQ 退出或者崩溃，将会丢失队列和消息。除非你不要队列和消息。两件事儿必须保证消息不被丢失：我们必须把“队列”和“消息”设为持久化。

>* 1. boolean durable = true;
>* 2. channel.queueDeclare("test_queue_work", durable, false, false, null);

那么我们直接将程序里面的 false 改成 true 就行了?? 不可以会 报异常 
```java
channel error; protocol method: #method<channel.close>(reply-code=406, replytext=PRECONDITION_FAILED
- inequivalent arg 'durable' for queue 'test_queue_work'
```
尽管这行代码是正确的，他不会运行成功。因为我们已经定义了一个名叫 test_queue_work 的未持久化的队列。RabbitMQ 不允许使用不同的参数设定重新定义已经存在的队列，并且会返回一个错误。一个快速的解决方案——就是声明一个不同名字的队列，比如 task_queue。或者我们登录控制台将队列删除就可以了