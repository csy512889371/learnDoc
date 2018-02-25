# 分布式事务服务 DTS三

# 典型场景和实现原理

首先来看一个典型的分布式事务场景

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/fbs/dts1.png)

* 在这个例子中，app1 作为分布式事务的发起方调用了参与者 app2 的 insert 操作和 app3 的 update 操作，之后调用自己的本地 insert 操作，在这个分布式事务中包含了 3 次对 db 的操作，而 3 个 db 分属于不同的系统，图中虚线覆盖的范围是 app1 的一个本地事务模版的代码范围。

来看看在 DTS 内部针对这个场景是如何实现的。
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/fbs/dts2.png)

* app2 和 app3 作为参与者分别实现了 prepare，commit 和 rollback 接口
* 我们将 prepare 阶段称为第一阶段，commit/rollback 阶段称为第二阶段
* 上图就是典型的 DTS 事务流转示例，第一阶段被包含在发起方的本地事务模版中，发起方的本地事务结束后，开始执行二阶段操作，二阶段结束，DTS 事务整个结束。

# 针对以上运行流程，我们可以总结如下
1) DTS 分布式事务是基于两阶段提交（ 2 phase commit，简称 2pc）原理
2) 事务发起方是分布式事务的协调者
3) 事务发起方本地事务的最终状态（提交或回滚）决定整个分布式事务的最终状态
4) 分布式事务必须在本地事务模板中进行
5) 参与者通过配置在 xml 中的拦截器来完成 action 信息的获取和数据插入
6) 事务参与者的接口需要支持两阶段。发起方（使用者）只关注第一阶段的方法，第二阶段由框架自动调用。


再来看看以上的说明对应的发起方代码是怎样的

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/fbs/dts3.png)


对应的参与者接口是这样的

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/fbs/dts4.png)

> 最核心的地方在于 prepare 接口打上了@TwoPhaseBusinessAction 标注，通过这个标注DTS 框架可以感知到这个服务就是一个 DTS 的参与者

接下来，结合上面这个例子让我们详细分析下 DTS 内部的工作原理，大体如下图
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/fbs/dts5.png)


## 核心点：

1) 使用数据库持久化记录事务数据，且使用独立的事务模版，也就是单独事务
2) 特别关注红线对应的 sql，这是一句 update 主事务表的 sql，而这句 sql 是在发起方的本地事务中的，这样一来就和发起方的事务绑定了，如果发起方本地事务成功，则这句 update 语句必然成功，如果发起方本地事务失败，则这句 update 语句必然失败，这样我们就可以根据 activity 表的事务记录的状态来决定这笔分布式最终的状态是成功还是失败了
3) 在调用参与者前，启动单独事务插入代表这个参与者的分支事务记录，以供后续恢复使用
4) 二阶段是通过 spring 提供的事务同步器实现的，如果发起方的本地事务失败，则二阶段自动回滚所有参与者，如果发起方的本地事务成功，则二阶段自动提交所有参与者。二阶段结束后，删除所有事务记录



