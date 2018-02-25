# data jpa扩展支持动态sql

# 前言

一般在写业务接口的过程中，很有可能需要实现可以动态组合各种查询条件的接口。如果我们根据一种查询条件组合一个方法的做法来写，那么将会有大量方法存在，繁琐，维护起来相当困难。想要实现动态查询，其实就是要实现拼接SQL语句。

* [spring data jpa扩展](http://blog.csdn.net/qq_27384769/article/details/78652351)

# 代码地址github

[spring-data-jpa-extra](https://github.com/csy512889371/spring-data-jpa-extra)

# 一、如何使用之定义动态sql在文件

* sql 默认支持后缀sftl和xml

> 定义sql文件默认与实体类名字相同如：Sample.sftl
## 使用sftl定义方式

```xml
-- findByContent
  SELECT * FROM t_sample WHERE 1 = 1
  <#if content??>
        AND content LIKE :content
  </#if>

--countContent
SELECT count(*) FROM t_sample WHERE 1 = 1
<#if content??>
  AND content LIKE :content
</#if>

--findDtos
SELECT id, content as contentShow FROM t_sample

--findByTemplateQueryObject
SELECT * FROM t_sample WHERE 1 = 1
<#if content??>
 AND content LIKE :content
</#if>

--findMap
SELECT * FROM t_sample

```

## xml方式定义
```xml
<?xml version="1.0" encoding="utf-8" ?>
<sqls xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns="http://www.slyak.com/schema/templatequery"
      xsi:schemaLocation="http://www.slyak.com/schema/templatequery http://www.slyak.com/schema/templatequery.xsd">

    <sql name="findByContent">
        <![CDATA[
          SELECT * FROM t_sample WHERE 1=1
          <#if content??>
            AND content LIKE :content
          </#if>
        ]]>
    </sql>
    <sql name="countContent">
        <![CDATA[
          SELECT count(*) FROM t_sample WHERE 1=1
          <#if content??>
            AND content LIKE :content
          </#if>
        ]]>
    </sql>
    <sql name="findDtos">
        <![CDATA[
          SELECT id,content as contentShow FROM t_sample
        ]]>
    </sql>
    <sql name="findByTemplateQueryObject">
        <![CDATA[
          SELECT * FROM t_sample WHERE 1=1
          <#if content??>
            AND content LIKE :content
          </#if>
        ]]>
    </sql>
</sqls>
```

# 二、如何使用之 SampleRepository 

* @TemplateQuery 自定义注解：repository 中的方法如果有注解TemplateQuery,则会根据方法名字到对于的文件中查找对于的sql

```java

public interface SampleRepository extends GenericJpaRepository<Sample, Long> {

	@TemplateQuery
	Page<Sample> findByContent(String content, Pageable pageable);

	@TemplateQuery
	List<Sample> findByTemplateQueryObject(SampleQuery sampleQuery, Pageable pageable);

	@TemplateQuery
	Long countContent(String content);

	@TemplateQuery
	List<SampleDTO> findDtos();

	// #{name?:'and content like :name'}
	@Query(nativeQuery = true, value = "select * from t_sample where content like ?1")
	List<Sample> findDtos2(String name);

	@TemplateQuery
	List<Map<String,Object>> findMap();
}

```

# 源代码解析

## 一、自定义一注解用于区分哪些方法需要使用到动态sql
TemplateQuery.java
```java
@Retention(RetentionPolicy.RUNTIME)
@Target({ ElementType.METHOD })
@QueryAnnotation
@Documented
public @interface TemplateQuery {
	String value() default "";
}
```

## 二、GenericJpaRepositoryFactory.java

* GenericJpaRepositoryFactory 中重写getQueryLookupStrategy（动态创建查询方法）

```java
	@Override
	protected QueryLookupStrategy getQueryLookupStrategy(QueryLookupStrategy.Key key,
			EvaluationContextProvider evaluationContextProvider) {
		return TemplateQueryLookupStrategy.create(entityManager, key, extractor, evaluationContextProvider);
	}
```


## 三、TemplateQueryLookupStrategy.java

TemplateQueryLookupStrategy 模版查询策略 其中关键代码：
```java
	@Override
	public RepositoryQuery resolveQuery(Method method, RepositoryMetadata metadata, ProjectionFactory factory,
			NamedQueries namedQueries) {
		if (method.getAnnotation(TemplateQuery.class) == null) {
			return jpaQueryLookupStrategy.resolveQuery(method, metadata, factory, namedQueries);
		}
		else {
			return new FreemarkerTemplateQuery(new JpaQueryMethod(method, metadata, factory, extractor), entityManager);
		}
	}
```
* resolveQuery 中解析query。判断方法上是否有注解TemplateQuery。如果有则使用动态sql。如果没有则使用jpa默认

## 四、FreemarkerTemplateQuery

* FreemarkerTemplateQuery 结合freemarker动态构造Query对象
* 关键代码如下
```java
    @Override
    protected TypedQuery<Long> doCreateCountQuery(Object[] values) {
        TypedQuery query = (TypedQuery) getEntityManager()
                .createNativeQuery(QueryBuilder.toCountQuery(getQuery(values)));
        bind(query, values);
        return query;
    }
```

## 关键类解析
* FreemarkerSqlTemplates 从文件中解析sql。使用freemarker
* SftlNamedTemplateResolver 解析.sftl文件 其中的sql 使用分隔符-- 隔开
* QueryBuilder.toCountQuery 根据select sql 构造出 count sql 查询总条目


