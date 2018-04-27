## Kafka Server Reactor设计模型


## 一、概述



## 二、Java NIO由以下几个核心部分组成 :
* Channels;
* Buffers；
* Selectors

Channel(通道)和java中的stream一样，用于传输数据的数据流，数据可以从Channel读到Buffer中，也可以从Buffer 写到Channel中。

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/42.png)


Selector允许单线程处理多个 Channel。使用Selector，首先得向Selector注册Channel，然后调用它的select()方法。此方法会一直阻塞到某个注册的Channel有事件就绪。一旦这个方法返回，线程就可以处理这些事件，事件的例子如新连接进来，数据接收等。
下图为一个单线程中使用一个Selector处理3个Channel：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/43.png)



## 三、认识Linux epoll模型


epoll 是一种IO多路复用技术 ，在linux内核中广泛使用。常见的三种IO多路复用技术为select模型、poll模型和epoll模型。

* select 模型需要轮询所有的套接字查看是否有事件发生 。缺点:  (1)套接字最大支持1024个；(2)主动轮询效率很低；(3) 事件发生后需要将套接字从内核空间拷贝到用户空间，效率低
* poll模型和select模型原理一样，但是修正了select模型最大套接字限制的缺点；
* epoll模型修改主动轮询为被动通知，当有事件发生时，被动接收通知。所以epoll模型注册套接字后，主程序可以做其他事情，当事件发生时，接收到通知后再去处理。修正了select模型的三个缺点(第三点使用共享内存修正)。

Java NIO的Selector模型底层使用的就是epoll IO多路复用模型


## 四、Kafka Server Reactor模型


Kafka  SocketServer是基于Java  NIO开发的，采用了Reactor的模式(已被大量实践证明非常高效，在Netty和Mina中广泛使用)。Kafka Reactor的模式包含三种角色：

* Acceptor;
* Processor ；
* Handler；

Kafka Reacator包含了1个Acceptor负责接受客户端请求，N个Processor线程负责读写数据(为每个Connection创建出一个Processor去单独处理,每个Processor中均引用独立的Selector)，M个Handler来处理业务逻辑。在Acceptor和Processor，Processor和Handler之间都有队列来缓冲请求。

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/44.png)



* Acceptor的主要职责是监听客户端的连接请求，并建立和客户端的数据传输通道，然后为这个客户端指定一个Processor，它的工作就到此结束，这样它就可以去响应下一个客户端的连接请求了;

* Processor的主要职责是负责从客户端读取数据和将响应返回给客户端，它本身不处理具体的业务逻辑，每个Processor都有一个Selector，用来监听多个客户端，因此可以非阻塞地处理多个客户端的读写请求，Processor将数据放入RequestChannel的RequestQueue 中和从ResponseQueue读取响应 ；

* Handler(kafka.server.KafkaRequestHandler,kafka.server.KafkaApis)的职责是从RequestChannel中的RequestQueue取出Request，处理以后再将Response添加到RequestChannel中的ResponseQueue中；


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/45.png)

上面五种分区算法都是选择PreferredReplica作为当前Partition的leader。区别仅仅是选择leader之后的操作有所不同。


所以，对于下图partition 0先选择broker 2，之后选择broker 0作为leader；对于partition 1 先选择broker 0,之后选择broker 1作为leader；partition 2先选择broker 1,之后选择broker 2作为leader


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/kafka/46.png)


