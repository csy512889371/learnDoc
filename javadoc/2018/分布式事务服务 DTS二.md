# 分布式事务服务 DTS二
如何玩转 DTS，基本上使用 DTS 对发起方的配置要求会多一点。

## 添加 DTS 的依赖

> NOTE： 发起方和参与方都需要添加依赖。

如果使用 SOFA Lite，只需按照样例工程里的方式添加依赖：

```xml
<dependency>
    <groupId>com.alipay.sofa</groupId>
    <artifactId>slite-starter-xts</artifactId>
</dependency>
```

如果没有使用 SOFA Lite，那么需要在 pom 配置里加上 DTS 的依赖：

```xml
<dependency>
    <groupId>com.alipay.xts</groupId>
    <artifactId>xts-core</artifactId>
    <version>6.0.8</version>
</dependency>
<dependency>
    <groupId>com.alipay.xts</groupId>
    <artifactId>xts-adapter-sofa</artifactId>
    <version>6.0.8</version>
</dependency>
```

# 场景介绍
1) 首先我们假想这样一种场景：转账服务，从银行 A 某个账户转 100 元钱到银行 B 的某个账户，银行 A 和银行 B 可以认为是两个单独的系统，也就是两套单独的数据库。
2) 我们将账户系统简化成只有账户和余额 2 个字段，并且为了适应 DTS 的两阶段设计要求，业务上又增加了一个冻结金额（冻结金额是指在一笔转账期间，在一阶段的时候使用该字段临时存储转账金额，该转账额度不能被使用，只有等这笔分布式事务全部提交成功时，才会真正的计入可用余额）。按这样的设计，用户的可用余额等于账户余额减去冻结金额。这点是理解参与者设计的关键，也是 DTS 保证最终一致的业务约束。
3) 同时为了记录账户操作明细，我们设计了一张账户流水表用来记录每次账户的操作明细，所以领域对象简单设计如下：

```java
public class Account {
    /**
     * 账户
     */
    private String accountNo;
    /**
     * 余额
     */
    private double amount;
    /**
     * 冻结金额
     */
    private double freezedAmount;
```

```java
public class AccountTransaction {
    /**
     * 事务id
     */
    private String txId;
    /**
     * 操作账户
     */
    private String accountNo;
    /**
     * 操作金额
     */
    private double amount;
    /**
     * 操作类型，扣帐还是入账
     */
    private String type;
```

## A 银行参与者

我们假设需要从 A 账户扣 100 元钱，所以 A 系统提供了一个扣帐的服务，对应扣帐的一阶段接口和相应的二阶段接口如下：
```java

/**
 * A银行参与者，执行扣帐操作
 * @version $Id: FirstAction.java, v 0.1 2014年9月22日 下午5:32:59 Exp $
 */
public interface FirstAction {
  /**
   * 一阶段方法，注意要打上xts的标注哦
   * 
   * @param businessActionContext
   * @param accountNo
   * @param amount
   */
  @TwoPhaseBusinessAction(name = "firstAction", commitMethod = "commit", rollbackMethod = "rollback")
  public void prepare_minus(BusinessActionContext businessActionContext,String accountNo,double amount);
  /**
   * 二阶段的提交方法
   * @param businessActionContext
   * @return
   */
  public boolean commit(BusinessActionContext businessActionContext);
  /**
   * 二阶段的回滚方法
   * @param businessActionContext
   * @return
   */
  public boolean rollback(BusinessActionContext businessActionContext);
}
```
对应的一阶段扣帐实现

```java
public void prepare_minus(final BusinessActionContext businessActionContext,
                          final String accountNo, final double amount) {
    transactionTemplate.execute(new TransactionCallback() {
        @Override
        public Object doInTransaction(TransactionStatus status) {
            try {
                try {
                        //锁定账户
                        Account account = accountDAO.getAccount(accountNo);
                        if (account.getAmount() - amount < 0) {
                            throw new TransactionFailException("余额不足");
                        }
                        //先记一笔账户操作流水
                        AccountTransaction accountTransaction = new AccountTransaction();
                        accountTransaction.setTxId(businessActionContext.getTxId());
                        accountTransaction.setAccountNo(accountNo);
                        accountTransaction.setAmount(amount);
                        accountTransaction.setType("minus");
                        //初始状态，如果提交则更新为C状态，如果失败则删除记录
                        accountTransaction.setStatus("I");
                        accountTransactionDAO.addTransaction(accountTransaction);
                        //再递增冻结金额，表示这部分钱已经被冻结，不能使用
                        double freezedAmount = account.getFreezedAmount() + amount;
                        account.setFreezedAmount(freezedAmount);
                        accountDAO.updateFreezedAmount(account);
                    } catch (Exception e) {
                        System.out.println("一阶段异常," + e);
                        throw new TransactionFailException("一阶段操作失败", e);
                    }
            return null;
        }
    });
}
```

对应的二阶段提交操作

```java

public boolean commit(final BusinessActionContext businessActionContext) {
    transactionTemplate.execute(new TransactionCallback() {
        @Override
        public Object doInTransaction(TransactionStatus status) {
            try {
                    //找到账户操作流水
                    AccountTransaction accountTransaction = accountTransactionDAO
                        .findTransaction(businessActionContext.getTxId());
                    //事务数据被删除了
                    if (accountTransaction == null) {
                        throw new TransactionFailException("事务信息被删除");
                    }
                    //重复提交幂等保证只做一次
                    if (StringUtils.equalsIgnoreCase("C", accountTransaction.getStatus())) {
                        return true;
                    }
                    Account account = accountDAO.getAccount(accountTransaction.getAccountNo());
                    //扣钱
                    double amount = account.getAmount() - accountTransaction.getAmount();
                    if (amount < 0) {
                        throw new TransactionFailException("余额不足");
                    }
                    account.setAmount(amount);
                    accountDAO.updateAmount(account);
                    //冻结金额相应减少
                    account.setFreezedAmount(account.getFreezedAmount()
                                             - accountTransaction.getAmount());
                    accountDAO.updateFreezedAmount(account);
                    //事务成功之后更新为C
                    accountTransactionDAO.updateTransaction(businessActionContext.getTxId(), "C");
                } catch (Exception e) {
                    System.out.println("二阶段异常," + e);
                    throw new TransactionFailException("二阶段操作失败", e);
                }
            return null;
        }
    });
    return false;
}
```

对应的二阶段回滚操作

```java
public boolean rollback(final BusinessActionContext businessActionContext) {
    transactionTemplate.execute(new TransactionCallback() {
        @Override
        public Object doInTransaction(TransactionStatus status) {
            try {
                    //回滚冻结金额
                    AccountTransaction accountTransaction = accountTransactionDAO
                        .findTransaction(businessActionContext.getTxId());
                    if (accountTransaction == null) {
                        System.out.println("二阶段---空回滚成功");
                        return null;
                    }
                    Account account = accountDAO.getAccount(accountTransaction.getAccountNo());
                    account.setFreezedAmount(account.getFreezedAmount()
                                             - accountTransaction.getAmount());
                    accountDAO.updateFreezedAmount(account);
                    //删除流水
                    accountTransactionDAO.deleteTransaction(businessActionContext.getTxId());
                } catch (Exception e) {
                    System.out.println("二阶段异常," + e);
                    throw new TransactionFailException("二阶段操作失败", e);
                }
              return null;
        }
   });
   return false;
}
```

## B 银行参与者

我们假设需要对 B 账户入账 100 元钱，所以 B 系统提供了一个入账的服务，对应入账的一阶段接口和相应的二阶段接口基本和 A 银行参与者类似，这里不多做介绍，可以直接查看样例工程下的 xts-sample 工程代码。

## 发起方

前面介绍了参与者的实现细节，接下来看看发起方系统是如何协调这 2 个参与者，达到分布式事务下数据的最终一致性的。相比参与者，发起方的配置要复杂一些。

1) 在发起方自己的数据库里创建 DTS 的表
2) 配置 BusinessActivityControlService

BusinessActivityControlService 是 DTS 分布式事务的启动类，在 SOFA 环境中，我们可以这样使用

```java
<!-- 分布式事务的服务，用来发起分布式事务 -->
<sofa:xts id="businessActivityControlService">
  <!-- 发起方自己的数据源，建议使用zdal数据源组件，这里简单使用dbcp数据源 -->
   <sofa:datasource ref="activityDataSource"/>
  <!-- 如果使用zdal数据源，可以不用配置这个属性，这个dbType是用来区分目标库的类型，以方便xts设置sqlmap -->
   <sofa:dbtype value="mysql"/>
</sofa:xts>
```

在其他环境中，我们也可以将它配置成一个普通 Bean，配置如下

```java
<!-- 分布式事务的服务，用来发起分布式事务 -->
<bean name="businessActivityControlService" class="com.alipay.xts.client.api.impl.sofa.BusinessActivityControlServiceImplSofa">
   <!-- 发起方自己的数据源，建议使用zdal数据源组件，这里简单使用dbcp数据源 -->
   <property name="dataSource" ref="activityDataSource"/>
   <!-- 如果使用zdal数据源，可以不用配置这个属性，这个dbType是用来区分目标库的类型，以方便xts设置sqlmap -->
   <property name="dbType" value="mysql"/>
</bean>
```

3) 配置参与者服务和拦截器。如果是在 SOFA 环境中，DTS 框架会自动拦截参与者方法，拦截器就不用配置了

```java
<!-- 第一个参与者的代理 -->
<bean id="firstAction" class="org.springframework.aop.framework.ProxyFactoryBean">
   <property name="proxyInterfaces" value="com.alipay.xts.client.sample.action.FirstAction"/>
   <property name="target" ref="firstActionTarget"/>
   <property name="interceptorNames">
      <list>
          <value>businessActionInterceptor</value>
      </list>
   </property>
</bean>
<!-- 第一个参与者 -->
<bean id="firstActionTarget" class="com.alipay.xts.client.sample.action.impl.FirstActionImpl">
   <property name="accountTransactionDAO">
      <ref bean="firstActionAccountTransactionDAO" />
   </property>
   <property name="accountDAO">
      <ref bean="firstActionAccountDAO" />
   </property>
   <property name="transactionTemplate">
      <ref bean="firstActionTransactionTemplate" />
   </property>
</bean>
<!-- 第二个参与者的代理 -->
<bean id="secondAction" class="org.springframework.aop.framework.ProxyFactoryBean">
   <property name="proxyInterfaces" value="com.alipay.xts.client.sample.action.SecondAction"/>
   <property name="target" ref="secondActionTarget"/>
   <property name="interceptorNames">
     <list>
        <value>businessActionInterceptor</value>
     </list>
   </property>
</bean>
<!-- 第二个参与者 -->
<bean id="secondActionTarget" class="com.alipay.xts.client.sample.action.impl.SecondActionImpl">
   <property name="accountTransactionDAO">
      <ref bean="secondActionAccountTransactionDAO" />
   </property>
   <property name="accountDAO">
      <ref bean="secondActionAccountDAO" />
   </property>
   <property name="transactionTemplate">
      <ref bean="secondActionTransactionTemplate" />
   </property>
</bean>
<!-- 拦截器，在参与者调用前生效，插入参与者的action记录 -->
<bean id="businessActionInterceptor"
     class="com.alipay.sofa.platform.xts.bacs.integration.BusinessActionInterceptor">
   <property name="businessActivityControlService" ref="businessActivityControlService"/>
</bean>
```

4) 发起分布式事务

启动分布式事务的入口方法

```java
/**
 * 启动一个业务活动。
 * 
 * 为了保证业务活动的唯一性，对同样的businessType与businessId，只能有一次成功记录。
 * 
 * 系统允许多次调用start方式启动业务活动，如果当前业务活动已经存在，再次启动业务活动不会有任何效果，也不会检查业务类型与业务号是否匹配。
 * 
 * @param businessType 业务类型，由业务系统自定义，比如'trade_pay'代表交易支付
 * @param businessId 业务号，如交易号
 * @notice 事务号的格式为: businessType+"-"+businessId，总长度为128
 * @return 
 */
BusinessActivityId start(String businessType, String businessId, Map<String, Object> properties);
```

> businessType + businessId 就是最终的事务号，properties 可以让发起方设置一些全局的事务上下文信息。


转账服务发起分布式事务


```java
/**
 * 执行转账操作
 * 
 * @param from
 * @param to
 * @param amount
 */
public void transfer(final String from, final String to, final double amount) {
    /**
     * 注意：开启xts服务必须包含在发起方的本地事务模版中
     */
    transactionTemplate.execute(new TransactionCallback() {
        @Override
        public Object doInTransaction(TransactionStatus status) {
           System.out.println("开始启动xts分布式事务活动");
                //启动分布式事务，第三个是分布式事务的全局上下文信息
                Map<String, Object> properties = new HashMap<String, Object>();
                BusinessActivityId businessActivityId = businessActivityControlService.start("pay",
                    businessId, properties);
                System.out.println("=====启动分布式事务成功，事务号：" + businessActivityId.toStringForm()
                                   + "=====");
                System.out.println("=====一阶段,准备从B银行执行入账操作=====");
                //第二个参与者入账操作
                if (secondAction.prepare_add(null, to, amount)) {
                    System.out.println("=====一阶段,从B银行执行入账操作成功=====");
                } else {
                    System.out.println("=====一阶段,从B银行执行入账操作失败，准备回滚=====");
                    status.setRollbackOnly();
                    return null;
                }
                System.out.println("=====一阶段,准备从A银行执行扣账操作=====");
                //第一个参与者扣账操作
                if (firstAction.prepare_minus(null, from, amount)) {
                    System.out.println("=====一阶段,从A银行执行扣账操作成功=====");
                } else {
                    System.out.println("=====一阶段,从A银行执行扣账操作失败，准备回滚=====");
                    status.setRollbackOnly();
                }
            return null;
        }
    });
    System.out.println("二阶段----转账成功，钱已到位");
}
```

## 小结

使用 DTS 开发需要关注的就是以上内容。对于参与者来说，最关键的是业务上如何实现两阶段处理来保证最终一致性，对于发起方来说，主要是要配置 DTS 的表。

# 参考资料

[SOFA框架 .pptx](https://github.com/csy512889371/learnDoc/blob/master/javadoc/2018/SOFA%E6%A1%86%E6%9E%B6%20.pptx)


