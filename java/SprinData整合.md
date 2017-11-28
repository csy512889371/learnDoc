# 搭建SpringMVC 5.0  SpringDataJPA 2.0  Hibernate 5 2017 最新版
本篇对Spring-data-jpa简单的介绍。整合 spring-data 、hibernate

大致整理一个提纲：
>* Spring-data-jpa的基本介绍；
>* 和Spring整合；
>* 基本的使用方式；

## 一、版本说明

>* spring 5.0.0.RELEASE
>* hibernate 5.2.11.Final
>* spring-data-jpa 2.0.0.RELEASE
>* spring-data-commons 2.0.0.RELEASE
>* 开发工具IDEA


```xml
<!-- spring版本号 -->
<spring.version>5.0.0.RELEASE</spring.version>
<!-- hibernate 版本号 -->
<hibernate.version>5.2.11.Final</hibernate.version>
<spring-data-jpa.version>2.0.0.RELEASE</spring-data-jpa.version>
<spring-data-commons.version>2.0.0.RELEASE</spring-data-commons.version>
```

## 二、代码位置



## 三、基本介绍

> Spring-data-jpa的基本介绍：JPA诞生的缘由是为了整合第三方ORM框架，建立一种标准的方式，为了实现ORM的天下归一，目前也是在按照这个方向发展，但是还没能完全实现。在ORM框架中，Hibernate是一支很大的部队，使用很广泛，也很方便，能力也很强，同时Hibernate也是和JPA整合的比较良好，我们可以认为JPA是标准，事实上也是，JPA几乎都是接口，实现都是Hibernate在做，宏观上面看，在JPA的统一之下Hibernate很良好的运行。

------

> Spring-data-jpa 主要是体现在和第三方工具的整合上。而在与第三方整合,于是就有了Spring-data-**这一系列包。包括，Spring-data-jpa,Spring-data-template,Spring-data-mongodb,Spring-data-redis

------

> 在使用持久化工具的时候，一般都有一个对象来操作数据库，在原生的Hibernate中叫做Session，在JPA中叫做EntityManager，在MyBatis中叫做SqlSession，通过这个对象来操作数据库。我们一般按照三层结构来看的话，Service层做业务逻辑处理，Dao层和数据库打交道，在Dao中，就存在着上面的对象。那么ORM框架本身提供的功能有什么呢？答案是基本的CRUD，所有的基础CRUD框架都提供，我们使用起来感觉很方便，很给力，业务逻辑层面的处理ORM是没有提供的，如果使用原生的框架，业务逻辑代码我们一般会自定义，会自己去写SQL语句，然后执行。在这个时候，Spring-data-jpa的威力就体现出来了，ORM提供的能力他都提供，ORM框架没有提供的业务逻辑功能Spring-data-jpa也提供，全方位的解决用户的需求。

------

>使用Spring-data-jpa进行开发的过程中，常用的功能，我们几乎不需要写一条sql语句，至少在我看来，企业级应用基本上可以不用写任何一条sql，当然spring-data-jpa也提供自己写sql的方式


# 四、配置文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:tx="http://www.springframework.org/schema/tx"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:p="http://www.springframework.org/schema/p"
       xmlns:cache="http://www.springframework.org/schema/cache"
       xmlns:jaxws="http://cxf.apache.org/jaxws"
       xmlns:jpa="http://www.springframework.org/schema/data/jpa"
       xsi:schemaLocation="
                    http://www.springframework.org/schema/beans
                    http://www.springframework.org/schema/beans/spring-beans-3.1.xsd
                    http://www.springframework.org/schema/tx
                    http://www.springframework.org/schema/tx/spring-tx-3.1.xsd
                    http://www.springframework.org/schema/aop
                    http://www.springframework.org/schema/aop/spring-aop-3.1.xsd
                    http://www.springframework.org/schema/context
                    http://www.springframework.org/schema/context/spring-context-3.1.xsd
                    http://www.springframework.org/schema/cache
                    http://www.springframework.org/schema/cache/spring-cache-3.1.xsd
                    http://cxf.apache.org/jaxws http://cxf.apache.org/schemas/jaxws.xsd
                    http://www.springframework.org/schema/data/jpa http://www.springframework.org/schema/data/jpa/spring-jpa.xsd"
       default-lazy-init="true">

    <!-- 启动组件扫描，排除@Controller组件，该组件由SpringMVC配置文件扫描 -->
    <context:component-scan base-package="com.rjsoft">
        <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
    </context:component-scan>

    <!-- 属性文件位置 -->
    <context:property-placeholder location="classpath:jdbc.properties"/>

    <!-- 数据源 -->
    <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource" init-method="init" destroy-method="close">
        <property name="driverClassName" value="com.mysql.jdbc.Driver"/>
        <property name="url"
                  value="jdbc:mysql://192.168.210.207:3306/demoone?useUnicode=true&amp;characterEncoding=UTF-8"/>

        <property name="username" value="root"/>
        <property name="password" value="123456"/>

        <property name="filters" value="stat"/>

        <property name="maxActive" value="20"/>
        <property name="initialSize" value="1"/>
        <property name="maxWait" value="60000"/>
        <property name="minIdle" value="1"/>

        <property name="timeBetweenEvictionRunsMillis" value="60000"/>
        <property name="minEvictableIdleTimeMillis" value="300000"/>

        <property name="validationQuery" value="SELECT 'x'"/>
        <property name="testWhileIdle" value="true"/>
        <property name="testOnBorrow" value="false"/>
        <property name="testOnReturn" value="false"/>

        <!-- 超过时间限制是否回收 -->
        <property name="removeAbandoned" value="true"/>
        <!-- 超时时间；单位为秒。180秒=3分钟 -->
        <property name="removeAbandonedTimeout" value="7200"/>
        <!-- 关闭abanded连接时输出错误日志
        <property name="logAbandoned" value="true" />
         -->
    </bean>

    <!-- JPA实体管理器工厂 -->
    <bean id="entityManagerFactory"
          class="org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean">
        <property name="dataSource" ref="dataSource"/>
        <property name="jpaVendorAdapter" ref="hibernateJpaVendorAdapter"/>
        <!-- 加入定制化包路径 -->
        <property name="packagesToScan" value="com.rjsoft.uums.facade.app.entity"/>

        <property name="jpaProperties">
            <props>
                <prop key="hibernate.current_session_context_class">thread</prop>
                <prop key="hibernate.hbm2ddl.auto">update</prop><!-- validate/update/create -->
                <prop key="hibernate.show_sql">false</prop>
                <prop key="hibernate.format_sql">false</prop>
                <!-- 建表的命名规则 -->
                <prop key="hibernate.ejb.naming_strategy">org.hibernate.cfg.ImprovedNamingStrategy</prop>
            </props>
        </property>
    </bean>

    <!-- 设置JPA实现厂商的特定属性 -->
    <bean id="hibernateJpaVendorAdapter"
          class="org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter">
        <property name="databasePlatform" value="${hibernate.dialect}"/>
    </bean>

    <!-- Jpa 事务配置 -->
    <bean id="transactionManager" class="org.springframework.orm.jpa.JpaTransactionManager">
        <property name="entityManagerFactory" ref="entityManagerFactory"/>
    </bean>

    <!-- Spring Data Jpa配置 -->
    <jpa:repositories base-package="com.rjsoft.**.repository"
                      transaction-manager-ref="transactionManager"
                      factory-class="com.rjsoft.common.repository.CustomRepositoryFactoryBean"
                      entity-manager-factory-ref="entityManagerFactory"  />

    <!-- 使用annotation定义事务 -->
    <tx:annotation-driven transaction-manager="transactionManager" proxy-target-class="true"/>


    <tx:advice id="userTxAdvice" transaction-manager="transactionManager">
        <tx:attributes>
            <tx:method name="find*" read-only="true"/>
            <tx:method name="get*" read-only="true"/>
            <tx:method name="load*" read-only="true"/>
            <tx:method name="*" propagation="REQUIRED"/>
        </tx:attributes>
    </tx:advice>
    <aop:config proxy-target-class="true">
        <aop:pointcut id="pc" expression="execution(* com.rjsoft..service..*.*(..))"/>
        <aop:advisor pointcut-ref="pc" advice-ref="userTxAdvice"/>
    </aop:config>


    <!-- 类型转换及数据格式化 -->
    <bean id="conversionService" class="org.springframework.format.support.FormattingConversionServiceFactoryBean"/>

    <!-- 直接把id转换为entity 必须非lazy否则无法注册-->
    <bean id="domainClassConverter" class="org.springframework.data.repository.support.DomainClassConverter">
        <constructor-arg ref="conversionService"/>
    </bean>

    <!--设置查询字符串转换器的conversion service-->
    <bean class="org.springframework.beans.factory.config.MethodInvokingFactoryBean">
        <property name="staticMethod"
                  value="com.rjsoft.common.model.search.utils.SearchableConvertUtils.setConversionService"/>
        <property name="arguments" ref="conversionService"/>
    </bean>

    <!--设置BaseRepositoryImplHelper辅助类所需的entityManagerFactory-->
    <bean class="org.springframework.beans.factory.config.MethodInvokingFactoryBean">
        <property name="staticMethod"
                  value="com.rjsoft.common.repository.RepositoryHelper.setEntityManagerFactory"/>
        <property name="arguments" ref="entityManagerFactory"/>
    </bean>
</beans>
```
### 1. 实体管理器
我们知道原生的jpa的配置信息是必须放在META-INF目录下面的，并且名字必须叫做persistence.xml，这个叫做persistence-unit，就叫做持久化单元，放在这下面我们感觉不方便，不好，于是Spring提供了

```java
org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean
```
这样一个类，可以让你的随心所欲的起这个配置文件的名字，也可以随心所欲的修改这个文件的位置，只需要在这里指向这个位置就行。然而更加方便的做法是，直接把配置信息就写在这里更好，于是就有了这实体管理器这个bean。使用
```xml
<property name="packagesToScan" value="your entity package" />
```
这个属性来加载我们的entity。

### 2. dao
> 解释“dao”这个bean。这里衍生一下，进行一下名词解释，我们知道dao这个层叫做Data Access Object，数据库访问对象，这是一个广泛的词语，在jpa当中，我们还有一个词语叫做Repository，这里我们一般就用Repository结尾来表示这个dao，比如UserDao，这里我们使用UserRepository

------

> 在mybatis中我们一般也不叫dao，mybatis由于使用xml映射文件（当然也提供注解，但是官方文档上面表示在有些地方，比如多表的复杂查询方面，注解还是无解，只能xml），我们一般使用mapper结尾，比如我们也不叫UserDao，而叫UserMapper。

------


>* base-package属性，代表你的Repository接口的位置
>* repository-impl-postfix属性代表接口的实现类的后缀结尾字符，比如我们的UserRepository，那么他的实现类就叫做UserRepositoryImpl，和我们平时的使用习惯完全一致，于此同时，spring-data-jpa的习惯是接口和实现类都需要放在同一个包里面
>* 这里我们的UserRepositoryImpl这个类的定义的时候我们不需要去指定实现UserRepository接口，根据spring-data-jpa自动就能判断二者的关系。

比如：我们的UserRepository和UserRepositoryImpl这两个类就像下面这样来写。
```java
public interface UserRepository 
                extends JpaRepository<User, Integer>{}
public class UserRepositoryImpl {}
```
>* 原理：spring-data-jpa提供基础的CRUD工作，同时也提供业务逻辑的功能。

>* 所以我们的Repository接口要做两项工作，继承spring-data-jpa提供的基础CRUD功能的接口，比如JpaRepository接口，同时自己还需要在UserRepository这个接口中定义自己的方法，那么导致的结局就是UserRepository这个接口中有很多的方法，那么如果我们的UserRepositoryImpl实现了UserRepository接口，导致的后果就是我们势必需要重写里面的所有方法，这是Java语法的规定，如此一来，悲剧就产生了，UserRepositoryImpl里面我们有很多的@Override方法，这显然是不行的，结论就是，这里我们不用去写implements部分。

>* spring-data-jpa实现了上面的能力，那他是怎么实现的呢？这里我们通过源代码的方式来呈现他的来龙去脉，这个过程中cglib发挥了杰出的作用。
>* 在spring-data-jpa内部，有一个类:

```java
public class SimpleJpaRepository<T, ID extends Serializable> implements JpaRepository<T, ID>,
        JpaSpecificationExecutor<T>
```

>  我们可以看到这个类是实现了JpaRepository接口的，事实上如果我们按照上面的配置，在同一个包下面有UserRepository，但是没有UserRepositoryImpl这个类的话，在运行时期UserRepository这个接口的实现就是上面的SimpleJpaRepository这个接口。而如果有UserRepositoryImpl这个文件的话，那么UserRepository的实现类就是UserRepositoryImpl，而UserRepositoryImpl这个类又是SimpleJpaRepository的子类，如此一来就很好的解决了上面的这个不用写implements的问题。我们通过阅读这个类的源代码可以发现，里面包装了entityManager，底层的调用关系还是entityManager在进行CRUD。

-----

Spring Data JPA在JPA上又做了一层封装，只要编写接口就够了，不用写一行实现代码，CRUD方法啦，分页啦，自动将findByLoginName()的方法定义翻译成适当的QL啦都由它包了： 

```java
public interface UserDao extends PagingAndSortingRepository<User, Long> { 
	User findByLoginName(String loginName); 
} 
```

> spring-data-jpa会根据方法的名字来自动生成sql语句，我们只需要按照方法定义的规则即可，上面的方法findByNameAndPassword，spring-data-jpa规定，方法都以findBy开头，sql的where部分就是NameAndPassword


![image](https://github.com/csy512889371/reactLearn/blob/master/img/learn/springdata1.png)

通过上面，基本CRUD和基本的业务逻辑操作都得到了解决，我们要做的工作少到仅仅需要在UserRepository接口中定义几个方法，其他所有的工作都由spring-data-jpa来完成。


## 五、DAO代码
### 1. 实体类
```java

@Entity
@Table(name="UMS_APPLICATION")
public class UmsApp extends UUIDEntity<String>{

	private static final long serialVersionUID = 1L;
	/**
	 * 系统标识符
	 */
	private String sn;
	/**
	 * 系统名称
	 */
	private String name;
	/**
	 * 系统Url
	 */
	private String url;

	/**
	 * 系统描述
	 */
	private String description;

	/**
	 * 系统单点登录标志
	 */
	private Short ssoFlag;
	
	// getter,setter
```

### 2. UmsAppRepository

```java
public interface UmsAppRepository extends JpaRepository<UmsApp,String> {

    @Query("select o from UmsApp o where o.sn=?1")
    public UmsApp findAppBySn(String appSn);

    @Query("select o from UmsApp o where o.name=?1")
    public UmsApp findAppByName(String name);

}
```

### 3. UmsAppService

```java
@Service("umsAppService")
public class UmsAppService  {
    @Autowired
    private UmsAppRepository umsAppRepository;

    /**
     * 保存应用系统信息
     */
    public UmsApp saveApp(UmsApp app){
        if(findAppBySn(app.getSn())!=null){
            throw new AppSnExistsException();
        }
        return save(app);
    }

```

## 封装 Repository


### 1. CustomRepository
```java

@NoRepositoryBean
public interface CustomRepository<T, ID extends Serializable>extends JpaRepository<T, ID>,JpaSpecificationExecutor<T> {

    /**
     * 根据条件查询所有
     * 条件 + 分页 + 排序
     *
     * @param searchable
     * @return
     */
    public Page<T> findAll(Searchable searchable);


    /**
     * 根据条件统计所有记录数
     *
     * @param searchable
     * @return
     */
    public long count(Searchable searchable);

    /**
     * 根据主键删除
     *
     * @param ids
     */
    public void delete(ID[] ids);


}
```
注意 @NoRepositoryBean一定要有的

### 2. CustomRepositoryImpl 
```java
public class CustomRepositoryImpl<T, ID extends Serializable>
        extends SimpleJpaRepository<T, ID> implements CustomRepository<T, ID> {

    public static final String FIND_QUERY_STRING = "from %s x where 1=1 ";
    public static final String COUNT_QUERY_STRING = "select count(x) from %s x where 1=1 ";

    private SearchCallback searchCallback = SearchCallback.DEFAULT;

    @SuppressWarnings("unused")
    private final EntityManager entityManager;

    private final RepositoryHelper repositoryHelper;

    /**
     * 查询所有的QL
     */
    private String findAllQL;
    /**
     * 统计QL
     */
    private String countAllQL;


    public CustomRepositoryImpl(Class<T> domainClass, EntityManager entityManager) {
        super(domainClass, entityManager);
        this.entityManager = entityManager;

        repositoryHelper = new RepositoryHelper(domainClass);
        findAllQL = String.format(FIND_QUERY_STRING, domainClass.getName());
        countAllQL = String.format(COUNT_QUERY_STRING, domainClass.getName());
    }

    @Override
    public List<T> findAll() {
        return repositoryHelper.findAll(findAllQL);
    }

    @Override
    public List<T> findAll(final Sort sort) {
        return repositoryHelper.findAll(findAllQL, sort);
    }

    @Override
    public Page<T> findAll(final Pageable pageable) {
        return new PageImpl<T>(
                repositoryHelper.<T>findAll(findAllQL, pageable),
                pageable,
                repositoryHelper.count(countAllQL)
        );
    }

    @Override
    public long count() {
        return repositoryHelper.count(countAllQL);
    }

    public void delete(ID id) {
        T m = getOne(id);
        delete(m);
    }

    @Override
    public void delete(T entity) {
        if (entity == null) {
            return;
        }
        if (entity instanceof LogicDeleteable) {
            ((LogicDeleteable) entity).markDeleted();
            save(entity);
        } else {
            super.delete(entity);
        }
    }

    @Override
    public Page<T> findAll(final Searchable searchable) {
        List<T> list = repositoryHelper.findAll(findAllQL, searchable, searchCallback);
        long total = searchable.hasPageable() ? count(searchable) : list.size();
        return new PageImpl<T>(
                list,
                searchable.getPage(),
                total
        );
    }

    @Override
    public long count(final Searchable searchable) {
        return repositoryHelper.count(countAllQL, searchable, searchCallback);
    }

    @Override
    public void delete(ID[] ids) {
        for(ID id:ids){
            this.delete(id);
        }
    }


}
```
### 3.CustomRepositoryFactoryBean

```java
public class CustomRepositoryFactoryBean<T extends JpaRepository<S, ID>, S, ID extends Serializable>
        extends JpaRepositoryFactoryBean<T, S, ID> {

    public CustomRepositoryFactoryBean(Class<? extends T> repositoryInterface) {
        super(repositoryInterface);
    }

    @Override
    protected RepositoryFactorySupport createRepositoryFactory(EntityManager entityManager) {
        return new CustomRepositoryFactory(entityManager);
    }

    private static class CustomRepositoryFactory extends JpaRepositoryFactory {


        public CustomRepositoryFactory(EntityManager entityManager) {
            super(entityManager);
        }

        @Override
        protected <T, ID extends Serializable> SimpleJpaRepository<?, ?> getTargetRepository(
                RepositoryInformation information, EntityManager entityManager) {
            return new CustomRepositoryImpl<T, ID>((Class<T>) information.getDomainType(), entityManager);

        }

        @Override
        protected Class<?> getRepositoryBaseClass(RepositoryMetadata metadata) {// 5
            return CustomRepositoryImpl.class;
        }
    }
}
```
4. RepositoryHelper
```java
public class RepositoryHelper {

    private static EntityManager entityManager;
    private Class<?> entityClass;
    private boolean enableQueryCache = false;

    /**
     * @param entityClass 是否开启查询缓存
     */
    public RepositoryHelper(Class<?> entityClass) {
        this.entityClass = entityClass;

        EnableQueryCache enableQueryCacheAnnotation =
                AnnotationUtils.findAnnotation(entityClass, EnableQueryCache.class);

        boolean enableQueryCache = false;
        if (enableQueryCacheAnnotation != null) {
            enableQueryCache = enableQueryCacheAnnotation.value();
        }
        this.enableQueryCache = enableQueryCache;
    }

    public static void setEntityManagerFactory(EntityManagerFactory entityManagerFactory) {
        entityManager = SharedEntityManagerCreator.createSharedEntityManager(entityManagerFactory);
    }

    public static EntityManager getEntityManager() {
        Assert.notNull(entityManager, "entityManager must null, please see " +
                "[com.rjsoft.common.repository.RepositoryHelper#setEntityManagerFactory]");

        return entityManager;
    }


    public static void flush() {
        getEntityManager().flush();
    }

    public static void clear() {
        flush();
        getEntityManager().clear();
    }

    /**
     * <p>ql条件查询<br/>
     * searchCallback默认实现请参考 <br/>
     * <p/>
     * @param ql
     * @param searchable     查询条件、分页 排序
     * @param searchCallback 查询回调  自定义设置查询条件和赋值
     * @return
     */
    @SuppressWarnings("unchecked")
	public <M> List<M> findAll(final String ql, final Searchable searchable, final SearchCallback searchCallback) {

        assertConverted(searchable);
        StringBuilder s = new StringBuilder(ql);
        searchCallback.prepareQL(s, searchable);
        searchCallback.prepareOrder(s, searchable);
        Query query = getEntityManager().createQuery(s.toString());
        applyEnableQueryCache(query);
        searchCallback.setValues(query, searchable);
        searchCallback.setPageable(query, searchable);

        return query.getResultList();
    }

    /**
     * <p>按条件统计<br/>
     *
     * @param ql
     * @param searchable
     * @param searchCallback
     * @return
     */
    public long count(final String ql, final Searchable searchable, final SearchCallback searchCallback) {

        assertConverted(searchable);

        StringBuilder s = new StringBuilder(ql);
        searchCallback.prepareQL(s, searchable);
        Query query = getEntityManager().createQuery(s.toString());
        applyEnableQueryCache(query);
        searchCallback.setValues(query, searchable);

        return (Long) query.getSingleResult();
    }

    /**
     * 按条件查询一个实体
     *
     * @param ql
     * @param searchable
     * @param searchCallback
     * @return
     */
	public <M> M getOne(final String ql, final Searchable searchable, final SearchCallback searchCallback) {

        assertConverted(searchable);

        StringBuilder s = new StringBuilder(ql);
        searchCallback.prepareQL(s, searchable);
        searchCallback.prepareOrder(s, searchable);
        Query query = getEntityManager().createQuery(s.toString());
        applyEnableQueryCache(query);
        searchCallback.setValues(query, searchable);
        searchCallback.setPageable(query, searchable);
        query.setMaxResults(1);
        List<M> result = query.getResultList();

        if (result.size() > 0) {
            return result.get(0);
        }
        return null;
    }


    /**
     * @param ql
     * @param params
     * @param <M>
     * @return
     * @see RepositoryHelper#findAll(String, org.springframework.data.domain.Pageable, Object...)
     */
    public <M> List<M> findAll(final String ql, final Object... params) {

        //此处必须 (Pageable) null  否则默认有调用自己了 可变参列表
        return findAll(ql, (Pageable) null, params);

    }

    /**
     * <p>根据ql和按照索引顺序的params执行ql，pageable存储分页信息 null表示不分页<br/>
     *
     * @param pageable null表示不分页
     * @param params
     * @param <M>
     * @return
     */
    @SuppressWarnings("unchecked")
	public <M> List<M> findAll(final String ql, final Pageable pageable, final Object... params) {

        Query query = getEntityManager().createQuery(ql + prepareOrder(pageable != null ? pageable.getSort() : null));
        applyEnableQueryCache(query);
        setParameters(query, params);
        if (pageable != null) {
            query.setFirstResult((int) pageable.getOffset());
            query.setMaxResults(pageable.getPageSize());
        }

        return query.getResultList();
    }

    /**
     * <p>根据ql和按照索引顺序的params执行ql，sort存储排序信息 null表示不排序<br/>
     *
     * @param ql
     * @param sort   null表示不排序
     * @param params
     * @param <M>
     * @return
     */
    @SuppressWarnings("unchecked")
	public <M> List<M> findAll(final String ql, final Sort sort, final Object... params) {

        Query query = getEntityManager().createQuery(ql + prepareOrder(sort));
        applyEnableQueryCache(query);
        setParameters(query, params);

        return query.getResultList();
    }


    /**
     * <p>根据ql和按照索引顺序的params查询一个实体<br/>
     *
     * @param ql
     * @param params
     * @param <M>
     * @return
     */
    public <M> M findOne(final String ql, final Object... params) {

        List<M> list = findAll(ql, PageRequest.of(0, 1), params);

        if (list.size() > 0) {
            return list.get(0);
        }
        return null;
    }


    /**
     * <p>根据ql和按照索引顺序的params执行ql统计<br/>
     *
     * @param ql
     * @param params
     * @return
     */
    public long count(final String ql, final Object... params) {

        Query query = entityManager.createQuery(ql);
        applyEnableQueryCache(query);
        setParameters(query, params);

        return (Long) query.getSingleResult();
    }

    /**
     * <p>执行批处理语句.如 之间insert, update, delete 等.<br/>
     *
     * @param ql
     * @param params
     * @return
     */
    public int batchUpdate(final String ql, final Object... params) {

        Query query = getEntityManager().createQuery(ql);
        setParameters(query, params);

        return query.executeUpdate();
    }


    /**
     * 按顺序设置Query参数
     *
     * @param query
     * @param params
     */
    public void setParameters(Query query, Object[] params) {
        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                query.setParameter(i + 1, params[i]);
            }
        }
    }

    /**
     * 拼排序
     * @param sort
     * @return
     */
    public String prepareOrder(Sort sort) {
        if (sort == null || !sort.iterator().hasNext()) {
            return "";
        }
        StringBuilder orderBy = new StringBuilder("");
        orderBy.append(" order by ");
        orderBy.append(sort.toString().replace(":", " "));
        return orderBy.toString();
    }


    public <T> JpaEntityInformation<T, ?> getMetadata(Class<T> entityClass) {
        return JpaEntityInformationSupport.getEntityInformation(entityClass, entityManager);
    }

    public String getEntityName(Class<?> entityClass) {
        return getMetadata(entityClass).getEntityName();
    }


    private void assertConverted(Searchable searchable) {
        if (!searchable.isConverted()) {
            searchable.convert(this.entityClass);
        }
    }


    public void applyEnableQueryCache(Query query) {
        if (enableQueryCache) {
            query.setHint("org.hibernate.cacheable", true);//开启查询缓存
        }
    }

}
```

### 配置文件

```xml
    <jpa:repositories base-package="com.rjsoft.**.repository"
                      transaction-manager-ref="transactionManager"
                      factory-class="com.rjsoft.common.repository.CustomRepositoryFactoryBean"
                      entity-manager-factory-ref="entityManagerFactory"  />
					  
					  <!-- 直接把id转换为entity 必须非lazy否则无法注册-->
    <bean id="domainClassConverter" class="org.springframework.data.repository.support.DomainClassConverter">
        <constructor-arg ref="conversionService"/>
    </bean>

    <!--设置查询字符串转换器的conversion service-->
    <bean class="org.springframework.beans.factory.config.MethodInvokingFactoryBean">
        <property name="staticMethod"
                  value="com.rjsoft.common.model.search.utils.SearchableConvertUtils.setConversionService"/>
        <property name="arguments" ref="conversionService"/>
    </bean>

    <!--设置BaseRepositoryImplHelper辅助类所需的entityManagerFactory-->
    <bean class="org.springframework.beans.factory.config.MethodInvokingFactoryBean">
        <property name="staticMethod"
                  value="com.rjsoft.common.repository.RepositoryHelper.setEntityManagerFactory"/>
        <property name="arguments" ref="entityManagerFactory"/>
    </bean>
```


## 六、动态查询（待续）

## 七、类型匹配语法

首先解下AspectJ类型匹配的通配符：         
 *：匹配任何数量字符；         
 ..：匹配任何数量字符的重复，如在类型模式中匹配任何数量子包；而在方法参数模式中匹配任何数量参数。        
 +：匹配指定类型的子类型；仅能作为后缀放在类型模式后边。



 

 