# SpringBoot 注解事务声明式事务的方式
springboot使用上述注解的几种方式开启事物，可以达到和xml中声明的同样效果，但是却告别了xml，使你的代码远离配置文件。


## springboot 之 xml事务

可以使用 @ImportResource("classpath:transaction.xml") 引入该xml的配置，xml的配置如下

```java
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:aop="http://www.springframework.org/schema/aop"
  xmlns:tx="http://www.springframework.org/schema/tx"
  xsi:schemaLocation="
    http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans.xsd
    http://www.springframework.org/schema/tx
    http://www.springframework.org/schema/tx/spring-tx.xsd
    http://www.springframework.org/schema/aop
    http://www.springframework.org/schema/aop/spring-aop.xsd">
  <bean id="txManager"
    class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
    <property name="dataSource" ref="dataSource" ></property>
  </bean>
  <tx:advice id="cftxAdvice" transaction-manager="txManager">
    <tx:attributes>
      <tx:method name="query*" propagation="SUPPORTS" read-only="true" ></tx:method>
      <tx:method name="get*" propagation="SUPPORTS" read-only="true" ></tx:method>
      <tx:method name="select*" propagation="SUPPORTS" read-only="true" ></tx:method>
      <tx:method name="*" propagation="REQUIRED" rollback-for="Exception" ></tx:method>
    </tx:attributes>
  </tx:advice>
   <aop:config>
    <aop:pointcut id="allManagerMethod" expression="execution (* com.exmaple.fm..service.*.*(..))" />
    <aop:advisor advice-ref="txAdvice" pointcut-ref="allManagerMethod" order="0" />
  </aop:config>
</beans>
```

springboot 启动类如下：
```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ImportResource;
@ImportResource("classpath:transaction.xml")
@SpringBootApplication
public class Application {
  public static void main(String[] args) {
    SpringApplication.run(Application.class, args);
  }
}
```

启动后即可开启事务，不过项目里导入了xml配置，如果不想导入xml配置，可以使用注解的方式

## springboot 之 注解事务

接下来开讲注解开启事务的方法：

### 1、Transactional注解事务

* 需要在进行事物管理的方法上添加注解@Transactional，或者偷懒的话直接在类上面添加该注解，使得所有的方法都进行事物的管理
* 但是依然需要在需要事务管理的类上都添加，工作量比较大

### 2、注解声明式事务

a.方式

* 这里使用Component或Configuration事务都可以生效　
```java

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.aop.Advisor;
import org.springframework.aop.aspectj.AspectJExpressionPointcut;
import org.springframework.aop.support.DefaultPointcutAdvisor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.interceptor.NameMatchTransactionAttributeSource;
import org.springframework.transaction.interceptor.RollbackRuleAttribute;
import org.springframework.transaction.interceptor.RuleBasedTransactionAttribute;
import org.springframework.transaction.interceptor.TransactionAttribute;
import org.springframework.transaction.interceptor.TransactionInterceptor;
/**
 * Created by guozp on 2017/8/28.
 */
@Aspect
//@Component 事务依然生效
@Configuration
public class TxAdviceInterceptor {

  private static final int TX_METHOD_TIMEOUT = 5;
  
  private static final String AOP_POINTCUT_EXPRESSION = "execution (* com.alibaba.fm9..service.*.*(..))";
  
  @Autowired
  private PlatformTransactionManager transactionManager;
  
  @Bean
  public TransactionInterceptor txAdvice() {
  
    NameMatchTransactionAttributeSource source = new NameMatchTransactionAttributeSource();
     /*只读事务，不做更新操作*/
    RuleBasedTransactionAttribute readOnlyTx = new RuleBasedTransactionAttribute();
    readOnlyTx.setReadOnly(true);
    readOnlyTx.setPropagationBehavior(TransactionDefinition.PROPAGATION_NOT_SUPPORTED );
	
    /*当前存在事务就使用当前事务，当前不存在事务就创建一个新的事务*/
    RuleBasedTransactionAttribute requiredTx = new RuleBasedTransactionAttribute();
    requiredTx.setRollbackRules(
      Collections.singletonList(new RollbackRuleAttribute(Exception.class)));
    requiredTx.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
    requiredTx.setTimeout(TX_METHOD_TIMEOUT);
    Map<String, TransactionAttribute> txMap = new HashMap<>();
    txMap.put("add*", requiredTx);
    txMap.put("save*", requiredTx);
    txMap.put("insert*", requiredTx);
    txMap.put("update*", requiredTx);
    txMap.put("delete*", requiredTx);
    txMap.put("get*", readOnlyTx);
    txMap.put("query*", readOnlyTx);
    source.setNameMap( txMap );
	
    TransactionInterceptor txAdvice = new TransactionInterceptor(transactionManager, source);
    return txAdvice;
  }
  
  @Bean
  public Advisor txAdviceAdvisor() {
    AspectJExpressionPointcut pointcut = new AspectJExpressionPointcut();
    pointcut.setExpression(AOP_POINTCUT_EXPRESSION);
    return new DefaultPointcutAdvisor(pointcut, txAdvice());
  }
}
```

b.方式

* 这里使用Component或Configuration事务都可以生效

```java
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import org.springframework.aop.aspectj.AspectJExpressionPointcutAdvisor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.interceptor.NameMatchTransactionAttributeSource;
import org.springframework.transaction.interceptor.RollbackRuleAttribute;
import org.springframework.transaction.interceptor.RuleBasedTransactionAttribute;
import org.springframework.transaction.interceptor.TransactionAttribute;
import org.springframework.transaction.interceptor.TransactionAttributeSource;
import org.springframework.transaction.interceptor.TransactionInterceptor;

/**
 * Created by guozp on 2017/8/29.
 */
//@Component 事务依然生效
@Configuration
public class TxAnoConfig {


  /*事务拦截类型*/
  @Bean("txSource")
  public TransactionAttributeSource transactionAttributeSource(){
    NameMatchTransactionAttributeSource source = new NameMatchTransactionAttributeSource();
     /*只读事务，不做更新操作*/
    RuleBasedTransactionAttribute readOnlyTx = new RuleBasedTransactionAttribute();
    readOnlyTx.setReadOnly(true);
    readOnlyTx.setPropagationBehavior(TransactionDefinition.PROPAGATION_NOT_SUPPORTED );
    /*当前存在事务就使用当前事务，当前不存在事务就创建一个新的事务*/
    //RuleBasedTransactionAttribute requiredTx = new RuleBasedTransactionAttribute();
    //requiredTx.setRollbackRules(
    //  Collections.singletonList(new RollbackRuleAttribute(Exception.class)));
    //requiredTx.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
    RuleBasedTransactionAttribute requiredTx = new RuleBasedTransactionAttribute(TransactionDefinition.PROPAGATION_REQUIRED,
      Collections.singletonList(new RollbackRuleAttribute(Exception.class)));
    requiredTx.setTimeout(5);
    Map<String, TransactionAttribute> txMap = new HashMap<>();
    txMap.put("add*", requiredTx);
    txMap.put("save*", requiredTx);
    txMap.put("insert*", requiredTx);
    txMap.put("update*", requiredTx);
    txMap.put("delete*", requiredTx);
    txMap.put("get*", readOnlyTx);
    txMap.put("query*", readOnlyTx);
    source.setNameMap( txMap );
    return source;
  }
  
  /**切面拦截规则 参数会自动从容器中注入*/
  @Bean
  public AspectJExpressionPointcutAdvisor pointcutAdvisor(TransactionInterceptor txInterceptor){
    AspectJExpressionPointcutAdvisor pointcutAdvisor = new AspectJExpressionPointcutAdvisor();
    pointcutAdvisor.setAdvice(txInterceptor);
    pointcutAdvisor.setExpression("execution (* com.alibaba.fm9..service.*.*(..))");
    return pointcutAdvisor;
  }
  
  
  /*事务拦截器*/
  @Bean("txInterceptor")
  TransactionInterceptor getTransactionInterceptor(PlatformTransactionManager tx){
    return new TransactionInterceptor(tx , transactionAttributeSource()) ;
  }
}　
```

c.方式
* 这里使用Component或Configuration事务都可以生效

```java
import java.util.Properties;
import org.springframework.aop.framework.autoproxy.BeanNameAutoProxyCreator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Component;
import org.springframework.transaction.interceptor.TransactionInterceptor;
/**
 * Created by guozp on 2017/8/28.
 *
 */
//@Component
@Configuration
public class TxConfigBeanName {
  @Autowired
  private DataSourceTransactionManager transactionManager;
  // 创建事务通知
  @Bean(name = "txAdvice")
  public TransactionInterceptor getAdvisor() throws Exception {
    Properties properties = new Properties();
    properties.setProperty("get*", "PROPAGATION_REQUIRED,-Exception,readOnly");
    properties.setProperty("add*", "PROPAGATION_REQUIRED,-Exception,readOnly");
    properties.setProperty("save*", "PROPAGATION_REQUIRED,-Exception,readOnly");
    properties.setProperty("update*", "PROPAGATION_REQUIRED,-Exception,readOnly");
    properties.setProperty("delete*", "PROPAGATION_REQUIRED,-Exception,readOnly");
    TransactionInterceptor tsi = new TransactionInterceptor(transactionManager,properties);
    return tsi;
  }
  @Bean
  public BeanNameAutoProxyCreator txProxy() {
    BeanNameAutoProxyCreator creator = new BeanNameAutoProxyCreator();
    creator.setInterceptorNames("txAdvice");
    creator.setBeanNames("*Service", "*ServiceImpl");
    creator.setProxyTargetClass(true);
    return creator;
  }
}
```


方式
* 这里使用Component或Configuration并不是所有事务都可以生效

```java
import java.util.Properties;
import javax.sql.DataSource;
import org.springframework.aop.aspectj.AspectJExpressionPointcut;
import org.springframework.aop.support.DefaultPointcutAdvisor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.interceptor.TransactionInterceptor;
/**
 * Created by guozp on 2017/8/28.
 *            ???????
 */
@Configuration //事务失效,都移动到一个方法不失效
//@Component // 事务可行，不用都移动到一个方法
public class TxOtherConfigDefaultBean {
  public static final String transactionExecution = "execution (* com.alibaba.fm9..service.*.*(..))";
  @Autowired
  private PlatformTransactionManager transactionManager;
  //@Bean
  //@ConditionalOnMissingBean
  //public PlatformTransactionManager transactionManager() {
  //  return new DataSourceTransactionManager(dataSource);
  //}
  @Bean
  public TransactionInterceptor transactionInterceptor() {
    Properties attributes = new Properties();
    attributes.setProperty("get*", "PROPAGATION_REQUIRED,-Exception");
    attributes.setProperty("add*", "PROPAGATION_REQUIRED,-Exception");
    attributes.setProperty("update*", "PROPAGATION_REQUIRED,-Exception");
    attributes.setProperty("delete*", "PROPAGATION_REQUIRED,-Exception");
    //TransactionInterceptor txAdvice = new TransactionInterceptor(transactionManager(), attributes);
    TransactionInterceptor txAdvice = new TransactionInterceptor(transactionManager, attributes);
    return txAdvice;
  }
  //@Bean
  //public AspectJExpressionPointcut aspectJExpressionPointcut(){
  //  AspectJExpressionPointcut pointcut = new AspectJExpressionPointcut();
  //  pointcut.setExpression(transactionExecution);
  //  return pointcut;
  //}
  @Bean
  public DefaultPointcutAdvisor defaultPointcutAdvisor(){
    //AspectJExpressionPointcut pointcut = new AspectJExpressionPointcut();
    //pointcut.setExpression(transactionExecution);
    //DefaultPointcutAdvisor advisor = new DefaultPointcutAdvisor();
    //advisor.setPointcut(pointcut);
    //advisor.setAdvice(transactionInterceptor());
    AspectJExpressionPointcut pointcut = new AspectJExpressionPointcut();
    pointcut.setExpression(transactionExecution);
    DefaultPointcutAdvisor advisor = new DefaultPointcutAdvisor();
    advisor.setPointcut(pointcut);
    Properties attributes = new Properties();
    attributes.setProperty("get*", "PROPAGATION_REQUIRED,-Exception");
    attributes.setProperty("add*", "PROPAGATION_REQUIRED,-Exception");
    attributes.setProperty("update*", "PROPAGATION_REQUIRED,-Exception");
    attributes.setProperty("delete*", "PROPAGATION_REQUIRED,-Exception");
    TransactionInterceptor txAdvice = new TransactionInterceptor(transactionManager, attributes);
    advisor.setAdvice(txAdvice);
    return advisor;
  }
}　
```

springboot使用上述注解的几种方式开启事物，可以达到和xml中声明的同样效果，但是却告别了xml，使你的代码远离配置文件。
