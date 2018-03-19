# 10_rabbit Exchanges（转发器交换机）

转发器一方面它接受生产者的消息，另一方面向队列推送消息。

## 例子代码地址
* https://github.com/csy512889371/learndemo/tree/master/ctoedu-rabitmq


## Nameless exchange（匿名转发）

之前我们对转换器一无所知，却可以将消息发送到队列，那是可能是我们用了默认的转发器，转发器名为空字符串""。之前我们发布消息的代码是：

```java
channel.basicPublish("", "hello", null, message.getBytes());

```

## Fanout Exchange

**不处理路由键**。你只需要将队列绑定到交换机上。发送消息到交换机都会被转发到与该交换机绑定的所有队列上。

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/33.png)

## Direct Exchange

**处理路由键**。

需要将一个队列绑定到交换机上，要求该消息与一个特定的路由键完全匹配。这是一个完整的匹配。如果一个队列绑定到该交换机上要求路由键 “dog”，则只有被标记为“dog”的消息才被转发，不会转发 dog.puppy，也不会转发dog.guard，只会转发 dog。

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/34.png)

## Topic Exchange

**将路由键和某模式进行匹配**。

此时队列需要绑定要一个模式上。符号“#”匹配一个或多个词，符号“*”匹配一个词。因此“audit.#”能够匹配到“audit.irs.corporate”，但是“audit.*” 只会匹配到“audit.irs”。


