# 分布式事务服务 DTS四


# 事务恢复

学习了 DTS 的原理之后，可能你会问，如果二阶段失败会怎样？比如需要 commit app2 和 app3，如果 commit app2 的时候断电了，这笔事务数据是否还能正常提交？答案是肯定的，通过我们的 xts-server 这个恢复系统来保证事务一定会被提交/回滚。在某些特殊情况下（比如断电，jvm crash等导致分布式事务没有处理完就结束了），xts-server 靠持久化记录到 db 的事务数据来完成恢复

## 恢复系统的特点

1) 恢复系统需要配置所有参与者信息，比如参与者的名称，全类名以及提交和回滚方法名
2) 恢复系统需要连接发起方的数据库，来获取对应的事务数据
3) 恢复系统是定时恢复的，每隔一分钟从发起方的数据库获取一次数据
4) 恢复系统获取的数据都是一分钟之前待处理的数据，这个一分钟是一个经验值，我们认为 99.9999% 的分布式事务一分钟就应该结束了，事实也确实如此

# 嵌套事务支持

在前面的典型场景里是 A->B 单层调用的关系，随着业务越来越复杂，可能会出现 A->B->C 的嵌套场景，在这个场景下，A 仍然是作为事务的发起方，我们把 B 称为嵌套参与者，C 为普通参与者，如果所示

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/fbs/dts6.png)

可以看到，一阶段和二阶段的调用链路是完全一致的，需要注意的是对于嵌套参与者 B 来说需要 DB 资源来存放下游参与者（这里是 C）的分支事务记录，在 B 调用 C 的一阶段的时候会记录代表 C 的分支事务记录，在二阶段 XTS 框架在提交完 B 这个参与者之后，会捞取 B 的分支事务表，找到 C 的记录，从而发起对 C 的二阶段提交

## 例子

我们假设 A 系统提供一个充值服务，调用 B 系统，B 系统再调用 C 系统完成充值，对于 A 系统发起方代码看起来是这样的 

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/fbs/dts7.png)

来看看 B 这个嵌套参与者的接口，和普通参与者没什么差别

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/fbs/dts8.png)

看看对应的实现 

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/fbs/dts9.png)

可以看到对应 B 参与者来说代码里并没有什么特殊的点，那么 XTS 框架是如何做到在提交 B 的时候自动提交 C 的呢？答案就是拦截器，对于嵌套参与者我们需要配置一个特殊的拦截器NestedBusinessActionInterceptor

> 看看 NestedBusinessActionInterceptor 的配置 

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/fbs/dts10.png)

NestedBusinessActionInterceptor 作用于 B 服务端拦截 B 的分布式服务，和 A 系统没关系

> 前面提到对于嵌套参与者需要提供 DB 资源来存储下游的分支事务记录，所以对于 B 系统也需要配置 BusinessActivityControlService 来让 XTS 框架感知 B 的 DB 信息 

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/fbs/dts11.png)

## 总结

对于嵌套参与者的使用： 

1) 需要提供 DB 资源，来让 XTS 框架持久化分支事务记录 
2) 配置 NestedBusinessActionInterceptor 拦截器



