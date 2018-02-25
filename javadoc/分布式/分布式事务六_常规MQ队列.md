# MQ队列消息模型的特点

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/fbs1/9.png)

> 队列消息模型的特点：
1) 消息生产者将消息发送到Queue中，然后消息消费者监听Queue并接收消息；
2) 消息被确认消费以后，就会从Queue中删除，所以消息消费者不会消费到已经被消费的消息；
3) Queue支持存在多个消费者，但是对某一个消息而言，只会有一个消费者成功消费。

* 常用的MQ中间件产品 ActiveMQ、RabbitMQ、RocketMQ等
* 基本都是这样的流程，具体实现上有各自的差异。规范协议
* 实现上有JMS、AMQP或自定义规范等。
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/fbs1/10.png)

1) Producer生成消息并发送给MQ（同步、异步）；
2) MQ接收消息并将消息数据持久化到消息存储（持久化操作为可选配置）；
3) MQ向Producer返回消息的接收结果（返回值、异常）；
4) Consumer监听并消费MQ中的消息；
5) Consumer获取到消息后执行业务处理；
6) Consumer对已成功消费的消息向MQ进行ACK确认（确认后的消息将从MQ中删除）

## 与消息发送一致性流程的对比

1) 常规MQ队列消息的处理流程无法实现消息发送一致性；
2) 投递消息的流程其实就是消息的消费流程，可细化。

# 总结

常规MQ队列消息的处理流程无法实现消息发送一致性，因此直接使用现成的MQ中间件产品无法实现可靠消息最终一致性的分布式事务解决方案

