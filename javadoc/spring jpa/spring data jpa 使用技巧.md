# spring data jpa 使用技巧

# @NamedQuery 命名查询

1） 现在实体类上定义方法已经具体查询语句

```java

@Entity
@NamedQuery(name = "Task.findByTaskName",
  query = "select t from Task t where t.taskName = ?1")
public class Task{

}
```

2) 然后我们继承接口之后，就可以直接用这个方法了，它会执行我们定义好的查询语句并返回结果

```java
public interface TaskDao extends JpaRepository<Task, Long> {
  Task findByTaskName(String taskName);
}
```

# @Query 直接在方法上定义查询语句

## hql 写法如下

```java
public interface TaskDao extends JpaRepository<Task, Long> {
  @Query("select t from Task t where t.taskName = ?1")
  Task findByTaskName(String taskName);
}
```

## sql语句 写法如下

```java

public interface TaskDao extends JpaRepository<Task, Long> {
  @Query("select * from tb_task t where t.task_name = ?1", nativeQuery = true)
  Task findByTaskName(String taskName);
}
```

## 参数绑定

* @Param 在参数绑定上，我们还可以这样子用

```java
public interface TaskDao extends JpaRepository<Task, Long> {
   @Query("select t from Task t where t.taskName = :taskName and t.createTime = :createTime")
  Task findByTaskName(@Param("taskName")String taskName,@Param("createTime") Date createTime);
}
```

* 当然在参数绑定上，我们还可以直写问号
```java
public interface TaskDao extends JpaRepository<Task, Long> {
   @Query("select t from Task t where t.taskName = ? and t.createTime = ?")
  Task findByTaskName(String taskName, Date createTime);
}
```

* 再利用SpEL表达式，我们把实体类写成动态的
```java
public interface TaskDao extends JpaRepository<Task, Long> {
   @Query("select t from #{#entityName} t where t.taskName = ? and t.createTime = ?")
  Task findByTaskName(String taskName, Date createTime);
}
```

## spring data jpa的查询策略

spring data jpa可以利用创建方法进行查询，也可以利用@Query注释进行查询，那么如果在命名规范的方法上使用了@Query，那spring data jpa是执行我们定义的语句进行查询，还是按照规范的方法进行查询呢？

* 查询策略的配置可以在配置query-lookup-strategy 如：
```java
<jpa:repositories base-package="com.liuxg.**.dao"
        repository-impl-postfix="Impl" 
        query-lookup-strategy = "create-if-not-found"
        entity-manager-factory-ref="entityManagerFactory"
        transaction-manager-ref="transactionManager" >
    </jpa:repositories>
```

三种值可以配置: 
1) create-if-not-found(默认)：如果通过 @Query指定查询语句，则执行该语句，如果没有，则看看有没有@NameQuery指定的查询语句，如果还没有，则通过解析方法名进行查询
2) create：通过解析方法名字来创建查询。即使有 @Query，@NameQuery都会忽略
3) use-declared-query：通过执行@Query定义的语句来执行查询，如果没有，则看看有没有通过执行@NameQuery来执行查询，还没有则抛出异常


# 调用存储过程实例

## 定义存储过程查询IN/OUT参数

```java
@SqlResultSetMappings({
        @SqlResultSetMapping(
                name = "MyTableMapping",
                classes = {
                        @ConstructorResult(
                                targetClass = MyTableDto.class,
                                columns = {
                                        @ColumnResult(name = "TYPE", type = String.class),
                                        @ColumnResult(name = "FYF", type = String.class),
                                        @ColumnResult(name = "VALUE_", type = String.class)
                                }
                        )
                }
        )
})
@NamedStoredProcedureQueries({
        @NamedStoredProcedureQuery(
                name = "procMytable",
                procedureName = "in_only_test",
                resultSetMappings = "MyTableMapping",
                parameters = {
                        @StoredProcedureParameter(name = "startDate", mode = ParameterMode.IN, type = Date.class),
                        @StoredProcedureParameter(name = "endDate", mode = ParameterMode.IN, type = Date.class),
                        @StoredProcedureParameter(name = "p_cur", mode = ParameterMode.REF_CURSOR, type = void.class)
                }
        )
})
```

1) 存储过程使用了注释@NamedStoredProcedureQuery，并绑定到一个JPA表。
2) procedureName是存储过程的名字
3) name是JPA中的存储过程的名字
4) 使用注释@StoredProcedureParameter来定义存储过程使用的IN/OUT参数


## 调用存储过程实例

```java
public interface MyTableRepository extends CrudRepository<MyTable, Long> {
    @Procedure(name = "in_only_test")
    void inOnlyTest(@Param("inParam1") String inParam1);
}
```


# 本地查询注解SqlResultSetMapping的使用

```java

@SqlResultSetMapping  
(  
        name = "ItemResults",  
        entities = {  
            @EntityResult(  
                entityClass = Item.class, //就是当前这个类的名字  
                fields = {  
                    @FieldResult(name = "id", column = "id"),  
                    @FieldResult(name = "itemId", column = "item_id"),  
                }  
            )  
        },  
        columns = {  
            @ColumnResult(name = "item_id")  
        }  
)  
@Entity  
@Table(name="item_permission")  
public class Item implements Serializable {  
  
    @Id  
    @GeneratedValue(strategy=GenerationType.IDENTITY)  
    private String id;  
  
    @Column(name="item_id")  
    private Integer itemId;  
  
    public Item(){}  
  
} 
```

查询
```java

public ItemDAO{  
  
ItemPermissionDAO dao = new ItemPermissionDAO();  
        Query query = dao.getEntityManager().createNativeQuery(  
                "select * from item_permission", "ItemResults");  
        @SuppressWarnings("unchecked")  
        List<Object[]> items = query.getResultList();  
        for (Object[] item : items) {  
            System.out.println(item[1]);  
        }  
  
}  

```


