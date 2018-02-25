# Spring boot Mybatis 整合

## 本项目使用的环境

* 开发工具：Intellij IDEA 2017.2.0
* jdk：1.8.0_161
* maven:3.3.9

## 额外功能

* PageHelper 分页插件
* mybatis generator 自动生成代码插件

## 步骤： 

1) 创建一个springboot项目： 
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mybatis/1.png)


2) 创建项目的文件结构以及jdk的版本
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mybatis/2.png)

3) 选择项目所需要的依赖 
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mybatis/3.png)
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mybatis/4.png)


然后点击finish

4) 文件的结构
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mybatis/5.png)


5) application.yml

* 项目不使用application.properties文件 而使用更加简洁的application.yml文件： 
* 将原有的resource文件夹下的application.properties文件删除，创建一个新的application.yml配置文件，

文件的内容如下

```xml

server:
  port: 8080

spring:
  #数据源
  datasource:
    name: test
    url: jdbc:mysql://115.159.152.130:3306/mybatis
    username: root
    password: 123456
    # 使用druid数据源
    type: com.alibaba.druid.pool.DruidDataSource
    driver-class-name: com.mysql.jdbc.Driver
    filters: stat
    maxActive: 20
    initialSize: 1
    maxWait: 60000
    minIdle: 1
    timeBetweenEvictionRunsMillis: 60000
    minEvictableIdleTimeMillis: 300000
    validationQuery: select 'x'
    testWhileIdle: true
    testOnBorrow: false
    testOnReturn: false
    poolPreparedStatements: true
    maxOpenPreparedStatements: 20
mybatis:
  mapper-locations: classpath:mapping/*.xml
  type-aliases-package: com.ctoedu.message.model

#pagehelper分页插件
pagehelper:
  helperDialect: mysql
  reasonable: true
  supportMethodsArguments: true
  params: count=countSql


```

6) 创建数据库：

```sql
DROP TABLE IF EXISTS `rp_transaction_message`;
CREATE TABLE `rp_transaction_message` (
  `id` varchar(50) NOT NULL DEFAULT '' COMMENT '主键ID',
  `version` int(11) NOT NULL DEFAULT '0' COMMENT '版本号',
  `editor` varchar(100) DEFAULT NULL COMMENT '修改者',
  `creater` varchar(100) DEFAULT NULL COMMENT '创建者',
  `edit_time` datetime DEFAULT NULL COMMENT '最后修改时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `message_id` varchar(50) NOT NULL DEFAULT '' COMMENT '消息ID',
  `message_body` longtext NOT NULL COMMENT '消息内容',
  `message_data_type` varchar(50) DEFAULT NULL COMMENT '消息数据类型',
  `consumer_queue` varchar(100) NOT NULL DEFAULT '' COMMENT '消费队列',
  `message_send_times` smallint(6) NOT NULL DEFAULT '0' COMMENT '消息重发次数',
  `areadly_dead` varchar(20) NOT NULL DEFAULT '' COMMENT '是否死亡',
  `status` varchar(20) NOT NULL DEFAULT '' COMMENT '状态',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注',
  `field1` varchar(200) DEFAULT NULL COMMENT '扩展字段1',
  `field2` varchar(200) DEFAULT NULL COMMENT '扩展字段2',
  `field3` varchar(200) DEFAULT NULL COMMENT '扩展字段3',
  PRIMARY KEY (`id`),
  KEY `AK_Key_2` (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

7) 使用mybatis generator 自动生成代码

* 配置pom.xml中generator 插件所对应的配置文件 ${basedir}/src/main/resources/generator/generatorConfig.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE generatorConfiguration
        PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
        "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">
<generatorConfiguration>
    <!-- 数据库驱动:选择你的本地硬盘上面的数据库驱动包-->
    <classPathEntry  location="F:\maven_repo_jt\mysql\mysql-connector-java\5.1.45\mysql-connector-java-5.1.45.jar"/>
    <context id="DB2Tables"  targetRuntime="MyBatis3">
        <commentGenerator>
            <property name="suppressDate" value="true"/>
            <!-- 是否去除自动生成的注释 true：是 ： false:否 -->
            <property name="suppressAllComments" value="true"/>
        </commentGenerator>
        <!--数据库链接URL，用户名、密码 -->
        <jdbcConnection driverClass="com.mysql.jdbc.Driver" connectionURL="jdbc:mysql://115.159.152.130:3306/mybatis" userId="root" password="123456">
        </jdbcConnection>
        <javaTypeResolver>
            <property name="forceBigDecimals" value="false"/>
        </javaTypeResolver>
        <!-- 生成模型的包名和位置-->
        <javaModelGenerator targetPackage="main.java.com.ctoedu.message.model" targetProject="src">
            <property name="enableSubPackages" value="true"/>
            <property name="trimStrings" value="true"/>
        </javaModelGenerator>
        <!-- 生成映射文件的包名和位置-->
        <sqlMapGenerator targetPackage="main.resources.mapping" targetProject="src">
            <property name="enableSubPackages" value="true"/>
        </sqlMapGenerator>
        <!-- 生成DAO的包名和位置-->
        <javaClientGenerator type="XMLMAPPER" targetPackage="main.java.com.ctoedu.message.mapper" targetProject="src">
            <property name="enableSubPackages" value="true"/>
        </javaClientGenerator>
        <!-- 要生成的表 tableName是数据库中的表名或视图名 domainObjectName是实体类名-->
        <table tableName="rp_transaction_message" domainObjectName="RpTransactionMessage" enableCountByExample="false" enableUpdateByExample="false" enableDeleteByExample="false" enableSelectByExample="false" selectByExampleQueryId="false"></table>
    </context>
</generatorConfiguration>
```

点击run-Edit Configurations

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mybatis/6.png)

添加配置

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mybatis/7.png)

运行

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mybatis/8.png)

最后生成的文件以及结构：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mybatis/9.png)


我们还需要修改有点东西，因为生成的类中的路径写了全路径，所以我们要把前面多余的删掉：


RpTransactionMessage.java

```java

public class RpTransactionMessage {
    private String id;

    private Integer version;

    private String editor;

    private String creater;

    private Date editTime;

    private Date createTime;

    private String messageId;

    private String messageDataType;

    private String consumerQueue;

    private Short messageSendTimes;

    private String areadlyDead;

    private String status;

    private String remark;

    private String field1;

    private String field2;

    private String field3;

    private String messageBody;

   //get set
}
```

RpTransactionMessageMapper.java
```java

public interface RpTransactionMessageMapper {
    int deleteByPrimaryKey(String id);

    int insert(RpTransactionMessage record);

    int insertSelective(RpTransactionMessage record);

    RpTransactionMessage selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(RpTransactionMessage record);

    int updateByPrimaryKeyWithBLOBs(RpTransactionMessage record);

    int updateByPrimaryKey(RpTransactionMessage record);

    //查询所有消息
    List<RpTransactionMessage> selectAllMessage();
}
```


对于sql语句这种黄色的背景，真心是看不下去了（解决方案）： 

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mybatis/10.png)

RpTransactionMessageMapper.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="com.ctoedu.message.mapper.RpTransactionMessageMapper" >
  <resultMap id="BaseResultMap" type="com.ctoedu.message.model.RpTransactionMessage" >
    <id column="id" property="id" jdbcType="VARCHAR" />
    <result column="version" property="version" jdbcType="INTEGER" />
    <result column="editor" property="editor" jdbcType="VARCHAR" />
    <result column="creater" property="creater" jdbcType="VARCHAR" />
    <result column="edit_time" property="editTime" jdbcType="TIMESTAMP" />
    <result column="create_time" property="createTime" jdbcType="TIMESTAMP" />
    <result column="message_id" property="messageId" jdbcType="VARCHAR" />
    <result column="message_data_type" property="messageDataType" jdbcType="VARCHAR" />
    <result column="consumer_queue" property="consumerQueue" jdbcType="VARCHAR" />
    <result column="message_send_times" property="messageSendTimes" jdbcType="SMALLINT" />
    <result column="areadly_dead" property="areadlyDead" jdbcType="VARCHAR" />
    <result column="status" property="status" jdbcType="VARCHAR" />
    <result column="remark" property="remark" jdbcType="VARCHAR" />
    <result column="field1" property="field1" jdbcType="VARCHAR" />
    <result column="field2" property="field2" jdbcType="VARCHAR" />
    <result column="field3" property="field3" jdbcType="VARCHAR" />
  </resultMap>
  <resultMap id="ResultMapWithBLOBs" type="com.ctoedu.message.model.RpTransactionMessage" extends="BaseResultMap" >
    <result column="message_body" property="messageBody" jdbcType="LONGVARCHAR" />
  </resultMap>
  <sql id="Base_Column_List" >
    id, version, editor, creater, edit_time, create_time, message_id, message_data_type, 
    consumer_queue, message_send_times, areadly_dead, status, remark, field1, field2, 
    field3
  </sql>
  <sql id="Blob_Column_List" >
    message_body
  </sql>
  <select id="selectByPrimaryKey" resultMap="ResultMapWithBLOBs" parameterType="java.lang.String" >
    select 
    <include refid="Base_Column_List" />
    ,
    <include refid="Blob_Column_List" />
    from rp_transaction_message
    where id = #{id,jdbcType=VARCHAR}
  </select>

  <select id="selectAllMessage" resultMap="ResultMapWithBLOBs">
    select
    <include refid="Base_Column_List" />
    from rp_transaction_message
  </select>

  <delete id="deleteByPrimaryKey" parameterType="java.lang.String" >
    delete from rp_transaction_message
    where id = #{id,jdbcType=VARCHAR}
  </delete>
  <insert id="insert" parameterType="com.ctoedu.message.model.RpTransactionMessage" >
    insert into rp_transaction_message (id, version, editor, 
      creater, edit_time, create_time, 
      message_id, message_data_type, consumer_queue, 
      message_send_times, areadly_dead, status, 
      remark, field1, field2, 
      field3, message_body)
    values (#{id,jdbcType=VARCHAR}, #{version,jdbcType=INTEGER}, #{editor,jdbcType=VARCHAR}, 
      #{creater,jdbcType=VARCHAR}, #{editTime,jdbcType=TIMESTAMP}, #{createTime,jdbcType=TIMESTAMP}, 
      #{messageId,jdbcType=VARCHAR}, #{messageDataType,jdbcType=VARCHAR}, #{consumerQueue,jdbcType=VARCHAR}, 
      #{messageSendTimes,jdbcType=SMALLINT}, #{areadlyDead,jdbcType=VARCHAR}, #{status,jdbcType=VARCHAR}, 
      #{remark,jdbcType=VARCHAR}, #{field1,jdbcType=VARCHAR}, #{field2,jdbcType=VARCHAR}, 
      #{field3,jdbcType=VARCHAR}, #{messageBody,jdbcType=LONGVARCHAR})
  </insert>
  <insert id="insertSelective" parameterType="com.ctoedu.message.model.RpTransactionMessage" >
    insert into rp_transaction_message
    <trim prefix="(" suffix=")" suffixOverrides="," >
      <if test="id != null" >
        id,
      </if>
      <if test="version != null" >
        version,
      </if>
      <if test="editor != null" >
        editor,
      </if>
      <if test="creater != null" >
        creater,
      </if>
      <if test="editTime != null" >
        edit_time,
      </if>
      <if test="createTime != null" >
        create_time,
      </if>
      <if test="messageId != null" >
        message_id,
      </if>
      <if test="messageDataType != null" >
        message_data_type,
      </if>
      <if test="consumerQueue != null" >
        consumer_queue,
      </if>
      <if test="messageSendTimes != null" >
        message_send_times,
      </if>
      <if test="areadlyDead != null" >
        areadly_dead,
      </if>
      <if test="status != null" >
        status,
      </if>
      <if test="remark != null" >
        remark,
      </if>
      <if test="field1 != null" >
        field1,
      </if>
      <if test="field2 != null" >
        field2,
      </if>
      <if test="field3 != null" >
        field3,
      </if>
      <if test="messageBody != null" >
        message_body,
      </if>
    </trim>
    <trim prefix="values (" suffix=")" suffixOverrides="," >
      <if test="id != null" >
        #{id,jdbcType=VARCHAR},
      </if>
      <if test="version != null" >
        #{version,jdbcType=INTEGER},
      </if>
      <if test="editor != null" >
        #{editor,jdbcType=VARCHAR},
      </if>
      <if test="creater != null" >
        #{creater,jdbcType=VARCHAR},
      </if>
      <if test="editTime != null" >
        #{editTime,jdbcType=TIMESTAMP},
      </if>
      <if test="createTime != null" >
        #{createTime,jdbcType=TIMESTAMP},
      </if>
      <if test="messageId != null" >
        #{messageId,jdbcType=VARCHAR},
      </if>
      <if test="messageDataType != null" >
        #{messageDataType,jdbcType=VARCHAR},
      </if>
      <if test="consumerQueue != null" >
        #{consumerQueue,jdbcType=VARCHAR},
      </if>
      <if test="messageSendTimes != null" >
        #{messageSendTimes,jdbcType=SMALLINT},
      </if>
      <if test="areadlyDead != null" >
        #{areadlyDead,jdbcType=VARCHAR},
      </if>
      <if test="status != null" >
        #{status,jdbcType=VARCHAR},
      </if>
      <if test="remark != null" >
        #{remark,jdbcType=VARCHAR},
      </if>
      <if test="field1 != null" >
        #{field1,jdbcType=VARCHAR},
      </if>
      <if test="field2 != null" >
        #{field2,jdbcType=VARCHAR},
      </if>
      <if test="field3 != null" >
        #{field3,jdbcType=VARCHAR},
      </if>
      <if test="messageBody != null" >
        #{messageBody,jdbcType=LONGVARCHAR},
      </if>
    </trim>
  </insert>
  <update id="updateByPrimaryKeySelective" parameterType="com.ctoedu.message.model.RpTransactionMessage" >
    update rp_transaction_message
    <set >
      <if test="version != null" >
        version = #{version,jdbcType=INTEGER},
      </if>
      <if test="editor != null" >
        editor = #{editor,jdbcType=VARCHAR},
      </if>
      <if test="creater != null" >
        creater = #{creater,jdbcType=VARCHAR},
      </if>
      <if test="editTime != null" >
        edit_time = #{editTime,jdbcType=TIMESTAMP},
      </if>
      <if test="createTime != null" >
        create_time = #{createTime,jdbcType=TIMESTAMP},
      </if>
      <if test="messageId != null" >
        message_id = #{messageId,jdbcType=VARCHAR},
      </if>
      <if test="messageDataType != null" >
        message_data_type = #{messageDataType,jdbcType=VARCHAR},
      </if>
      <if test="consumerQueue != null" >
        consumer_queue = #{consumerQueue,jdbcType=VARCHAR},
      </if>
      <if test="messageSendTimes != null" >
        message_send_times = #{messageSendTimes,jdbcType=SMALLINT},
      </if>
      <if test="areadlyDead != null" >
        areadly_dead = #{areadlyDead,jdbcType=VARCHAR},
      </if>
      <if test="status != null" >
        status = #{status,jdbcType=VARCHAR},
      </if>
      <if test="remark != null" >
        remark = #{remark,jdbcType=VARCHAR},
      </if>
      <if test="field1 != null" >
        field1 = #{field1,jdbcType=VARCHAR},
      </if>
      <if test="field2 != null" >
        field2 = #{field2,jdbcType=VARCHAR},
      </if>
      <if test="field3 != null" >
        field3 = #{field3,jdbcType=VARCHAR},
      </if>
      <if test="messageBody != null" >
        message_body = #{messageBody,jdbcType=LONGVARCHAR},
      </if>
    </set>
    where id = #{id,jdbcType=VARCHAR}
  </update>
  <update id="updateByPrimaryKeyWithBLOBs" parameterType="com.ctoedu.message.model.RpTransactionMessage" >
    update rp_transaction_message
    set version = #{version,jdbcType=INTEGER},
      editor = #{editor,jdbcType=VARCHAR},
      creater = #{creater,jdbcType=VARCHAR},
      edit_time = #{editTime,jdbcType=TIMESTAMP},
      create_time = #{createTime,jdbcType=TIMESTAMP},
      message_id = #{messageId,jdbcType=VARCHAR},
      message_data_type = #{messageDataType,jdbcType=VARCHAR},
      consumer_queue = #{consumerQueue,jdbcType=VARCHAR},
      message_send_times = #{messageSendTimes,jdbcType=SMALLINT},
      areadly_dead = #{areadlyDead,jdbcType=VARCHAR},
      status = #{status,jdbcType=VARCHAR},
      remark = #{remark,jdbcType=VARCHAR},
      field1 = #{field1,jdbcType=VARCHAR},
      field2 = #{field2,jdbcType=VARCHAR},
      field3 = #{field3,jdbcType=VARCHAR},
      message_body = #{messageBody,jdbcType=LONGVARCHAR}
    where id = #{id,jdbcType=VARCHAR}
  </update>
  <update id="updateByPrimaryKey" parameterType="com.ctoedu.message.model.RpTransactionMessage" >
    update rp_transaction_message
    set version = #{version,jdbcType=INTEGER},
      editor = #{editor,jdbcType=VARCHAR},
      creater = #{creater,jdbcType=VARCHAR},
      edit_time = #{editTime,jdbcType=TIMESTAMP},
      create_time = #{createTime,jdbcType=TIMESTAMP},
      message_id = #{messageId,jdbcType=VARCHAR},
      message_data_type = #{messageDataType,jdbcType=VARCHAR},
      consumer_queue = #{consumerQueue,jdbcType=VARCHAR},
      message_send_times = #{messageSendTimes,jdbcType=SMALLINT},
      areadly_dead = #{areadlyDead,jdbcType=VARCHAR},
      status = #{status,jdbcType=VARCHAR},
      remark = #{remark,jdbcType=VARCHAR},
      field1 = #{field1,jdbcType=VARCHAR},
      field2 = #{field2,jdbcType=VARCHAR},
      field3 = #{field3,jdbcType=VARCHAR}
    where id = #{id,jdbcType=VARCHAR}
  </update>
</mapper>
```


打开类SpringbootMybatisApplication.java，这个是springboot的启动类。我们需要添加点东西

```java
@SpringBootApplication
@MapperScan("com.ctoedu.message.mapper")//将项目中对应的mapper类的路径加进来就可以了
public class SpringBootMessageApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringBootMessageApplication.class, args);
	}
}
```

8) 现在controller，service层的代码

RpTransactionMessageController

```java
@Controller
@RequestMapping(value = "/message")
public class RpTransactionMessageController {
    @Autowired
    private RpTransactionMessageService rpTransactionMessageService;

    @ResponseBody
    @RequestMapping(value = "/add", produces = {"application/json;charset=UTF-8"})
    public int addMessage(RpTransactionMessage message) {
        return rpTransactionMessageService.addRpTransactionMessage(message);
    }

    @ResponseBody
    @RequestMapping(value = "/all/{pageNum}/{pageSize}", produces = {"application/json;charset=UTF-8"})
    public Object findAllMessage(@PathVariable("pageNum") int pageNum, @PathVariable("pageSize") int pageSize) {

        return rpTransactionMessageService.findAllMessage(pageNum, pageSize);
    }
}
```

RpTransactionMessageService

```java
public interface RpTransactionMessageService {

    int addRpTransactionMessage(RpTransactionMessage message);

    List<RpTransactionMessage> findAllMessage(int pageNum, int pageSize);
}
```

```java

@Service(value = "rpTransactionMessageService")
public class RpTransactionMessageServiceImpl implements RpTransactionMessageService {

    @Autowired
    private RpTransactionMessageMapper rpTransactionMessageMapper;

    @Override
    public int addRpTransactionMessage(RpTransactionMessage message) {
        return rpTransactionMessageMapper.insertSelective(message);
    }

    /*
    * 这个方法中用到了我们开头配置依赖的分页插件pagehelper
    * 很简单，只需要在service层传入参数，然后将参数传递给一个插件的一个静态方法即可；
    * pageNum 开始页数
    * pageSize 每页显示的数据条数
    * */
    @Override
    public List<RpTransactionMessage> findAllMessage(int pageNum, int pageSize) {
        //将参数传给这个方法就可以实现物理分页了，非常简单。
        PageHelper.startPage(pageNum, pageSize);
        return rpTransactionMessageMapper.selectAllMessage();
    }
}
```

会报错，不影响 。如果强迫症看不下去那个报错：（解决方法）
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mybatis/11.png)


测试我使用了idea一个很用心的功能。 

可以发http请求的插件

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mybatis/12.png)
