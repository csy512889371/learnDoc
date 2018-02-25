# Mybatis分页插件PageHelper

# 一、概述

对于使用Mybatis时，最头痛的就是写分页，需要先写一个查询count的select语句，然后再写一个真正分页查询的语句，当查询条件多了之后，会发现真不想花双倍的时间写count和select

如下就是项目在没有使用分页插件的时候的语句

```xml
<!-- 根据查询条件获取查询获得的数据量 -->
    <select id="size" parameterType="Map" resultType="Long">
        select count(*) from t_ass_stu
        <where>
            <if test="stuId != null and stuId != ''">
                AND stu_id like
                CONCAT(CONCAT('%',
                #{stuId,jdbcType=VARCHAR}),'%')
            </if>
            <if test="name != null and name != ''">
                AND name like
                CONCAT(CONCAT('%',
                #{name,jdbcType=VARCHAR}),'%')
            </if>
            <if test="deptId != null">
                AND dept_id in
                <foreach item="item" index="index" collection="deptId" open="("
                    separator="," close=")">
                    #{item}
                </foreach>
            </if>
            <if test="bankName != null">
                AND bank_name in
                <foreach item="item" index="index" collection="bankName"
                    open="(" separator="," close=")">
                    #{item}
                </foreach>
            </if>
        </where>
    </select>
    <!-- 分页查询获取获取信息 -->
    <select id="selectByPageAndSelections" parameterType="com.ctoedu.stu.common.QueryBase"
        resultMap="BaseResultMap">
        select * from t_ass_stu
        <where>
            <if test="parameters.stuId != null and parameters.stuId != ''">
                AND stu_id like
                CONCAT(CONCAT('%',
                #{parameters.stuId,jdbcType=VARCHAR}),'%')
            </if>
            <if test="parameters.name != null and parameters.name != ''">
                AND name like
                CONCAT(CONCAT('%',
                #{parameters.name,jdbcType=VARCHAR}),'%')
            </if>
            <if test="parameters.deptId != null">
                AND dept_id in
                <foreach item="item" index="index" collection="parameters.deptId"
                    open="(" separator="," close=")">
                    #{item}
                </foreach>
            </if>
            <if test="parameters.bankName != null">
                AND bank_name in
                <foreach item="item" index="index" collection="parameters.bankName"
                    open="(" separator="," close=")">
                    #{item}
                </foreach>
            </if>
        </where>
        order by dept_id,stu_id
        limit #{firstRow},#{pageSize}
    </select>

```

* 重复的代码太多
* 使用分页插件只需要写一个select 语句，count由插件根据select语句自动完成。


# 二、配置分页插件

```xml
<!-- 配置分页插件 -->
    <plugins>
        <plugin interceptor="com.github.pagehelper.PageInterceptor">
            <!-- 设置数据库类型 Oracle,Mysql,MariaDB,SQLite,Hsqldb,PostgreSQL六种数据库-->
            <property name="helperDialect" value="mysql"/>
        </plugin>
    </plugins>
```

编写mapper.xml文件

```xml
<select id="selectByPageAndSelections" resultMap="BaseResultMap">
        SELECT *
        FROM doc
        ORDER BY doc_abstract
    </select>
```

然后在Mapper.java中编写对应的接口

```java
public List<Doc> selectByPageAndSelections();
```

分页

```java

@Service
public class DocServiceImpl implements IDocService {
    @Autowired
    private DocMapper docMapper;

    @Override
    public PageInfo<Doc> selectDocByPage1(int currentPage, int pageSize) {
        PageHelper.startPage(currentPage, pageSize);
        List<Doc> docs = docMapper.selectByPageAndSelections();
        PageInfo<Doc> pageInfo = new PageInfo<>(docs);
        return pageInfo;
    }
}
```
* 使用了PageHelper.startPage(currentPage, pageSize) 入侵mapper代码
* 插件对mybatis执行流程进行了增强，添加了limit以及count查询，属于物理分页


```xml
什么时候会导致不安全的分页？

PageHelper 方法使用了静态的 ThreadLocal 参数，分页参数和线程是绑定的。

只要你可以保证在 PageHelper 方法调用后紧跟 MyBatis 查询方法，这就是安全的。因为 PageHelper 在 finally 代码段中自动清除了 ThreadLocal 存储的对象。

如果代码在进入 Executor 前发生异常，就会导致线程不可用，这属于人为的 Bug（例如接口方法和 XML 中的不匹配，导致找不到 MappedStatement 时）， 这种情况由于线程不可用，也不会导致 ThreadLocal 参数被错误的使用。

但是如果你写出下面这样的代码，就是不安全的用法：

PageHelper.startPage(1, 10);
List<Country> list;
if(param1 != null){
    list = countryMapper.selectIf(param1);
} else {
    list = new ArrayList<Country>();
}
这种情况下由于 param1 存在 null 的情况，就会导致 PageHelper 生产了一个分页参数，但是没有被消费，这个参数就会一直保留在这个线程上。当这个线程再次被使用时，就可能导致不该分页的方法去消费这个分页参数，这就产生了莫名其妙的分页。

上面这个代码，应该写成下面这个样子：

List<Country> list;
if(param1 != null){
    PageHelper.startPage(1, 10);
    list = countryMapper.selectIf(param1);
} else {
    list = new ArrayList<Country>();
}
这种写法就能保证安全。

如果你对此不放心，你可以手动清理 ThreadLocal 存储的分页参数，可以像下面这样使用：

List<Country> list;
if(param1 != null){
    PageHelper.startPage(1, 10);
    try{
        list = countryMapper.selectAll();
    } finally {
        PageHelper.clearPage();
    }
} else {
    list = new ArrayList<Country>();
}
这么写很不好看，而且没有必要。
```

