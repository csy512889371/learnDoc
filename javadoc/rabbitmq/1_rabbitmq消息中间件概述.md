#  一、RabbitMQ  概述

* MQ 为Message Queue，消息队列是应用程序和应用程序之间的通信方法。
* RabbitMQ是一个开源的，在AMQP基础上完整的，可复用的企业消息系统
* 支持主流的操作系统：linux、windows、macOX等
* 多种开发语言支持，java、pytyhon、Ruby、.Net、 php、c/c++、node.js等

* 开发语言：Erlang – 面向并发的编程语言。
* AMQP:是消息队列的一个协议。mysql 是 java 写的吗?不是 那么 java 能不能访问?可以,则通过(驱动)协议;那么要访问 RabbitMQ 是不是也可以通过驱动来访问

## rabbit例子代码地址

* https://github.com/csy512889371/learndemo/tree/master/ctoedu-rabitmq

## 1.1 官网

* http://www.rabbitmq.com/

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/1.png)

## 1.2 其他 MQ
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/2.png)

## 1.3 六种消息类型

http://www.rabbitmq.com/getstarted.html

* 1、simple 简单队列
* 2、work queues 工作队列 公平分发 轮询分发
* 3、public/subscribe 发布订阅
* 4、routing 路由选择 通配符模式
* 5、topic 主题
* 6、手动和自动确认
* 7、队列的持久化和菲持久化
* 8、rabbitmq的延时队列

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/3.png)


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/4.png)

# 二、消息队列解决了什么问题

## 1、异步处理 
* a、跨系统的异步通信，所有需要异步交互的地方都可以使用消息队列。异步调用其他系统的接口。
* b、场景说明：用户注册后，需要发注册邮件和注册短信,传统的做法有两种1.串行的方式;2.并行的方式。 引入消息队列后，把发送邮件,短信不是必须的业务逻辑异步处理。


## 2、应用解耦 

由于消息是平台无关和语言无关的，而且语义上也不再是函数调用，因此更适合作为多个应用之间的松耦合的接口。基于消息队列的耦合，不需要发送方和接收方同时在线。

场景：
* a、双11是购物狂节,用户下单后,订单系统需要通知库存系统,传统的做法就是订单系统调用库存系统的接口.缺点：当库存系统出现故障时,订单就会失败
* b、订单系统和库存系统高耦合. 引入消息队列


## 3、流量消锋 

**场景一**

* 应用内的同步变异步，比如订单处理，就可以由前端应用将订单信息放到队列，后端应用从队列里依次获得消息处理，高峰时的大量订单可以积压在队列里慢慢处理掉。
* 由于同步通常意味着阻塞，而大量线程的阻塞会降低计算机的性能。

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/6.png)

**场景二**

秒杀活动，一般会因为流量过大，导致应用挂掉,为了解决这个问题，一般在应用前端加入消息队列。

作用: 
* 1.可以控制活动人数，超过此一定阀值的订单直接丢弃 
* 2.可以缓解短时间的高流量压垮应用(应用程序按自己的最大处理能力获取订单) 

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/5.png)

* 1.用户的请求,服务器收到之后,首先写入消息队列,加入消息队列长度超过最大值,则直接抛弃用户请求或跳转到错误页面. 
* 2.秒杀业务根据消息队列中的请求信息，再做后续处理.

# 三 、RabbitMQ组件
AMQP协议是一个高级抽象层消息通信协议，RabbitMQ是AMQP协议的实现。它主要包括以下组件

* 1.Server(broker): 接受客户端连接，实现AMQP消息队列和路由功能的进程。
* 2.Virtual Host:其实是一个虚拟概念，类似于权限控制组，一个Virtual Host里面可以有若干个Exchange和Queue，但是权限控制的最小粒度是Virtual Host
* 3.Exchange:接受生产者发送的消息，并根据Binding规则将消息路由给服务器中的队列。ExchangeType决定了Exchange路由消息的行为，例如，在RabbitMQ中，ExchangeType有direct、Fanout和Topic三种，不同类型的Exchange路由的行为是不一样的。
* 4.Message Queue：消息队列，用于存储还未被消费者消费的消息。
* 5.Message: 由Header和Body组成，Header是由生产者添加的各种属性的集合，包括Message是否被持久化、由哪个Message Queue接受、优先级是多少等。而Body是真正需要传输的APP数据。
* 6.Binding:Binding联系了Exchange与Message Queue。Exchange在与多个Message Queue发生Binding后会生成一张路由表，路由表中存储着Message Queue所需消息的限制条件即Binding Key。当Exchange收到Message时会解析其Header得到Routing Key，Exchange根据Routing Key与Exchange Type将Message路由到Message Queue。Binding Key由Consumer在Binding Exchange与Message Queue时指定，而Routing Key由Producer发送Message时指定，两者的匹配方式由Exchange Type决定。 
* 7.Connection:连接，对于RabbitMQ而言，其实就是一个位于客户端和Broker之间的TCP连接。
* 8.Channel:信道，仅仅创建了客户端到Broker之间的连接后，客户端还是不能发送消息的。需要为每一个Connection创建Channel，AMQP协议规定只有通过Channel才能执行AMQP的命令。一个Connection可以包含多个Channel。之所以需要Channel，是因为TCP连接的建立和释放都是十分昂贵的，如果一个客户端每一个线程都需要与Broker交互，如果每一个线程都建立一个TCP连接，暂且不考虑TCP连接是否浪费，就算操作系统也无法承受每秒建立如此多的TCP连接。**RabbitMQ建议客户端线程之间不要共用Channel，至少要保证共用Channel的线程发送消息必须是串行的，但是建议尽量共用Connection**。
* 9.Command:AMQP的命令，客户端通过Command完成与AMQP服务器的交互来实现自身的逻辑。例如在RabbitMQ中，客户端可以通过publish命令发送消息，txSelect开启一个事务，txCommit提交一个事务。


# 四、任务分发机制

## 1、Round-robin dispathching循环分发
RabbbitMQ的分发机制非常适合扩展,而且它是专门为并发程序设计的,如果现在load加重,那么只需要创建更多的Consumer来进行任务处理

## 2、Message acknowledgment消息确认

* 为了保证数据不被丢失,RabbitMQ支持消息确认机制,为了保证数据能被正确处理而不仅仅是被Consumer收到,那么我们不能采用no-ack，而应该是在处理完数据之后发送ack. 
* 在处理完数据之后发送ack,就是告诉RabbitMQ数据已经被接收,处理完成,RabbitMQ可以安全的删除它了. 
* 如果Consumer退出了但是没有发送ack,那么RabbitMQ就会把这个Message发送到下一个Consumer，这样就保证在Consumer异常退出情况下数据也不会丢失. 
* RabbitMQ它没有用到超时机制.RabbitMQ仅仅通过Consumer的连接中断来确认该Message并没有正确处理，也就是说RabbitMQ给了Consumer足够长的时间做数据处理。 
* 如果忘记ack,那么当Consumer退出时,Mesage会重新分发,然后RabbitMQ会占用越来越多的内存.

# 五、Message durability消息持久化

* 要持久化队列queue的持久化需要在声明时指定durable=True; 
* 队列和交换机有一个创建时候指定的标志durable,durable的唯一含义就是具有这个标志的队列和交换机会在重启之后重新建立,它不表示说在队列中的消息会在重启后恢复 
* 消息持久化包括3部分 
* 1. exchange持久化,在声明时指定durable => true
* 2.queue持久化,在声明时指定durable => true
* 3.消息持久化,在投递时指定delivery_mode => 2(1是非持久化).
```java
//声明消息队列，且为可持久化的
hannel.ExchangeDeclare(ExchangeName, "direct", durable: true, autoDelete: false, arguments: null);

///声明消息队列，且为可持久化的
channel.QueueDeclare(QueueName, durable: true, exclusive: false, autoDelete: false, arguments: null);/

channel.basicPublish("", queueName, MessageProperties.PERSISTENT_TEXT_PLAIN, msg.getBytes());  
```
* 如果exchange和queue都是持久化的,那么它们之间的binding也是持久化的,如果exchange和queue两者之间有一个持久化，一个非持久化,则不允许建立绑定. 

注意：一旦创建了队列和交换机,就不能修改其标志了,例如,创建了一个non-durable的队列,然后想把它改变成durable的,唯一的办法就是删除这个队列然后重现创建。


# 六、Fair dispath 公平分发

* 你可能也注意到了,分发机制不是那么优雅,默认状态下,RabbitMQ将第n个Message分发给第n个Consumer。n是取余后的,它不管Consumer是否还有unacked Message，只是按照这个默认的机制进行分发. 
* 那么如果有个Consumer工作比较重,那么就会导致有的Consumer基本没事可做,有的Consumer却毫无休息的机会,那么,Rabbit是如何处理这种问题呢?

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/7.png)

通过basic.qos方法设置prefetch_count=1，这样RabbitMQ就会使得每个Consumer在同一个时间点最多处理一个Message，换句话说,在接收到该Consumer的ack前,它不会将新的Message分发给它

```java
channel.basic_qos(prefetch_count=1) 
```

**注意，这种方法可能会导致queue满。当然，这种情况下你可能需要添加更多的Consumer，或者创建更多的virtualHost来细化你的设计。**


# 七、分发到多个Consumer

## 1、Exchange

* Direct Exchange:直接匹配,通过Exchange名称+RountingKey来发送与接收消息. 
* Fanout Exchange:广播订阅,向所有的消费者发布消息,但是只有消费者将队列绑定到该路由器才能收到消息,忽略Routing Key. 
* Topic Exchange：主题匹配订阅,这里的主题指的是RoutingKey,RoutingKey可以采用通配符,如:*或#，RoutingKey命名采用.来分隔多个词,只有消息这将队列绑定到该路由器且指定RoutingKey符合匹配规则时才能收到消息; 
* Headers Exchange:消息头订阅,消息发布前,为消息定义一个或多个键值对的消息头,然后消费者接收消息同时需要定义类似的键值对请求头:(如:x-mactch=all或者x_match=any)，只有请求头与消息头匹配,才能接收消息,忽略RoutingKey. 
* 默认的exchange:如果用空字符串去声明一个exchange，那么系统就会使用”amq.direct”这个exchange，我们创建一个queue时,默认的都会有一个和新建queue同名的routingKey绑定到这个默认的exchange上去

```java
channel.BasicPublish("", "TaskQueue", properties, bytes);
```

* 因为在第一个参数选择了默认的exchange，而我们申明的队列叫TaskQueue，所以默认的，它在新建一个也叫TaskQueue的routingKey，并绑定在默认的exchange上，导致了我们可以在第二个参数routingKey中写TaskQueue，这样它就会找到定义的同名的queue，并把消息放进去
* 如果有两个接收程序都是用了同一个的queue和相同的routingKey去绑定direct exchange的话，分发的行为是负载均衡的，也就是说第一个是程序1收到，第二个是程序2收到，以此类推。 
* 如果有两个接收程序用了各自的queue，但使用相同的routingKey去绑定direct exchange的话，分发的行为是复制的，也就是说每个程序都会收到这个消息的副本。行为相当于fanout类型的exchange。



## 2、Bindings 绑定
绑定其实就是关联了exchange和queue，或者这么说:queue对exchange的内容感兴趣,exchange要把它的Message deliver到queue。


## 3、Direct exchange

Driect exchange的路由算法非常简单:通过bindingkey的完全匹配，可以用下图来说明
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/8.png)


* Exchange和两个队列绑定在一起,Q1的bindingkey是orange，Q2的binding key是black和green. 
* 当Producer publish key是orange时,exchange会把它放到Q1上,如果是black或green就会到Q2上,其余的Message被丢弃.

## 4、Multiple bindings
多个queue绑定同一个key也是可以的,对于下图的例子,Q1和Q2都绑定了black,对于routing key是black的Message，会被deliver到Q1和Q2，其余的Message都会被丢弃. 
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/10.png)


## 5、Topic exchange

对于Message的routing_key是有限制的，不能使任意的。格式是以点号“.”分割的字符表。比如：”stock.usd.nyse”, “nyse.vmw”, “quick.orange.rabbit”。你可以放任意的key在routing_key中，当然最长不能超过255 bytes。 


对于routing_key，有两个特殊字符

* *(星号)代表任意一个单词
* #(hash)0个或多个单词 

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/rabbitmq/1.png)

Producer发送消息时需要设置routing_key，routing_key包含三个单词和连个点号o,第一个key描述了celerity(灵巧),第二个是color(色彩),第三个是物种: 

在这里我们创建了两个绑定： Q1 的binding key 是”.orange.“； Q2 是 “..rabbit” 和 “lazy.#”：

* Q1感兴趣所有orange颜色的动物
* Q2感兴趣所有rabbits和所有的lazy的. 
* 例子:rounting_key 为 “quick.orange.rabbit”将会发送到Q1和Q2中 
* rounting_key 为”lazy.orange.rabbit.hujj.ddd”会被投递到Q2中,#匹配0个或多个单词。

## 八、消息序列化

RabbitMQ使用ProtoBuf序列化消息,它可作为RabbitMQ的Message的数据格式进行传输,由于是结构化的数据,这样就极大的方便了Consumer的数据高效处理,当然也可以使用XML，与XML相比,ProtoBuf有以下优势: 
* 1.简单 
* 2.size小了3-10倍 
* 3.速度快了20-100倍 
* 4.易于编程 
* 6.减少了语义的歧义

ProtoBuf具有速度和空间的优势，使得它现在应用非常广泛