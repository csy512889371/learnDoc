官网地址

   https://shardingsphere.apache.org/document/current/cn/manual/sharding-jdbc/configuration/config-spring-boot/

* 注意的一个问题：行表达式标识符可以使用${...}或$->{...}，但前者与Spring本身的属性文件占位符冲突，因此在Spring环境中使用行表达式标识符建议使用$->{...}。 



数据分片

```
spring.shardingsphere.datasource.names= #数据源名称，多数据源以逗号分隔
 
spring.shardingsphere.datasource.<data-source-name>.type= #数据库连接池类名称
spring.shardingsphere.datasource.<data-source-name>.driver-class-name= #数据库驱动类名
spring.shardingsphere.datasource.<data-source-name>.url= #数据库url连接
spring.shardingsphere.datasource.<data-source-name>.username= #数据库用户名
spring.shardingsphere.datasource.<data-source-name>.password= #数据库密码
spring.shardingsphere.datasource.<data-source-name>.xxx= #数据库连接池的其它属性
 
spring.shardingsphere.sharding.tables.<logic-table-name>.actual-data-nodes= #由数据源名 + 表名组成，以小数点分隔。多个表以逗号分隔，支持inline表达式。缺省表示使用已知数据源与逻辑表名称生成数据节点。用于广播表（即每个库中都需要一个同样的表用于关联查询，多为字典表）或只分库不分表且所有库的表结构完全一致的情况
 
#分库策略，缺省表示使用默认分库策略，以下的分片策略只能选其一
 
#用于单分片键的标准分片场景
spring.shardingsphere.sharding.tables.<logic-table-name>.database-strategy.standard.sharding-column= #分片列名称
spring.shardingsphere.sharding.tables.<logic-table-name>.database-strategy.standard.precise-algorithm-class-name= #精确分片算法类名称，用于=和IN。该类需实现PreciseShardingAlgorithm接口并提供无参数的构造器
spring.shardingsphere.sharding.tables.<logic-table-name>.database-strategy.standard.range-algorithm-class-name= #范围分片算法类名称，用于BETWEEN，可选。该类需实现RangeShardingAlgorithm接口并提供无参数的构造器
 
#用于多分片键的复合分片场景
spring.shardingsphere.sharding.tables.<logic-table-name>.database-strategy.complex.sharding-columns= #分片列名称，多个列以逗号分隔
spring.shardingsphere.sharding.tables.<logic-table-name>.database-strategy.complex.algorithm-class-name= #复合分片算法类名称。该类需实现ComplexKeysShardingAlgorithm接口并提供无参数的构造器
 
#行表达式分片策略
spring.shardingsphere.sharding.tables.<logic-table-name>.database-strategy.inline.sharding-column= #分片列名称
spring.shardingsphere.sharding.tables.<logic-table-name>.database-strategy.inline.algorithm-expression= #分片算法行表达式，需符合groovy语法
 
#Hint分片策略
spring.shardingsphere.sharding.tables.<logic-table-name>.database-strategy.hint.algorithm-class-name= #Hint分片算法类名称。该类需实现HintShardingAlgorithm接口并提供无参数的构造器
 
#分表策略，同分库策略
spring.shardingsphere.sharding.tables.<logic-table-name>.table-strategy.xxx= #省略
 
spring.shardingsphere.sharding.tables.<logic-table-name>.key-generator.column= #自增列名称，缺省表示不使用自增主键生成器
spring.shardingsphere.sharding.tables.<logic-table-name>.key-generator.type= #自增列值生成器类型，缺省表示使用默认自增列值生成器。可使用用户自定义的列值生成器或选择内置类型：SNOWFLAKE/UUID/LEAF_SEGMENT
spring.shardingsphere.sharding.tables.<logic-table-name>.key-generator.props.<property-name>= #属性配置, 注意：使用SNOWFLAKE算法，需要配置worker.id与max.tolerate.time.difference.milliseconds属性。若使用此算法生成值作分片值，建议配置max.vibration.offset属性
 
spring.shardingsphere.sharding.binding-tables[0]= #绑定表规则列表
spring.shardingsphere.sharding.binding-tables[1]= #绑定表规则列表
spring.shardingsphere.sharding.binding-tables[x]= #绑定表规则列表
 
spring.shardingsphere.sharding.broadcast-tables[0]= #广播表规则列表
spring.shardingsphere.sharding.broadcast-tables[1]= #广播表规则列表
spring.shardingsphere.sharding.broadcast-tables[x]= #广播表规则列表
 
spring.shardingsphere.sharding.default-data-source-name= #未配置分片规则的表将通过默认数据源定位
spring.shardingsphere.sharding.default-database-strategy.xxx= #默认数据库分片策略，同分库策略
spring.shardingsphere.sharding.default-table-strategy.xxx= #默认表分片策略，同分表策略
spring.shardingsphere.sharding.default-key-generator.type= #默认自增列值生成器类型，缺省将使用org.apache.shardingsphere.core.keygen.generator.impl.SnowflakeKeyGenerator。可使用用户自定义的列值生成器或选择内置类型：SNOWFLAKE/UUID/LEAF_SEGMENT
spring.shardingsphere.sharding.default-key-generator.props.<property-name>= #自增列值生成器属性配置, 比如SNOWFLAKE算法的worker.id与max.tolerate.time.difference.milliseconds
 
spring.shardingsphere.sharding.master-slave-rules.<master-slave-data-source-name>.master-data-source-name= #详见读写分离部分
spring.shardingsphere.sharding.master-slave-rules.<master-slave-data-source-name>.slave-data-source-names[0]= #详见读写分离部分
spring.shardingsphere.sharding.master-slave-rules.<master-slave-data-source-name>.slave-data-source-names[1]= #详见读写分离部分
spring.shardingsphere.sharding.master-slave-rules.<master-slave-data-source-name>.slave-data-source-names[x]= #详见读写分离部分
spring.shardingsphere.sharding.master-slave-rules.<master-slave-data-source-name>.load-balance-algorithm-class-name= #详见读写分离部分
spring.shardingsphere.sharding.master-slave-rules.<master-slave-data-source-name>.load-balance-algorithm-type= #详见读写分离部分
 
spring.shardingsphere.props.sql.show= #是否开启SQL显示，默认值: false
spring.shardingsphere.props.executor.size= #工作线程数量，默认值: CPU核数
```


读写分离
```
#省略数据源配置，与数据分片一致
 
spring.shardingsphere.sharding.master-slave-rules.<master-slave-data-source-name>.master-data-source-name= #主库数据源名称
spring.shardingsphere.sharding.master-slave-rules.<master-slave-data-source-name>.slave-data-source-names[0]= #从库数据源名称列表
spring.shardingsphere.sharding.master-slave-rules.<master-slave-data-source-name>.slave-data-source-names[1]= #从库数据源名称列表
spring.shardingsphere.sharding.master-slave-rules.<master-slave-data-source-name>.slave-data-source-names[x]= #从库数据源名称列表
spring.shardingsphere.sharding.master-slave-rules.<master-slave-data-source-name>.load-balance-algorithm-class-name= #从库负载均衡算法类名称。该类需实现MasterSlaveLoadBalanceAlgorithm接口且提供无参数构造器
spring.shardingsphere.sharding.master-slave-rules.<master-slave-data-source-name>.load-balance-algorithm-type= #从库负载均衡算法类型，可选值：ROUND_ROBIN，RANDOM。若`load-balance-algorithm-class-name`存在则忽略该配置
 
spring.shardingsphere.props.sql.show= #是否开启SQL显示，默认值: false
spring.shardingsphere.props.executor.size= #工作线程数量，默认值: CPU核数
spring.shardingsphere.props.check.table.metadata.enabled= #是否在启动时检查分表元数据一致性，默认值: false
```


数据脱敏

```
#省略数据源配置，与数据分片一致
 
spring.shardingsphere.encrypt.encryptors.<encryptor-name>.type= #加解密器类型，可自定义或选择内置类型：MD5/AES 
spring.shardingsphere.encrypt.encryptors.<encryptor-name>.props.<property-name>= #属性配置, 注意：使用AES加密器，需要配置AES加密器的KEY属性：aes.key.value
spring.shardingsphere.encrypt.tables.<table-name>.columns.<logic-column-name>.plainColumn= #存储明文的字段
spring.shardingsphere.encrypt.tables.<table-name>.columns.<logic-column-name>.cipherColumn= #存储密文的字段
spring.shardingsphere.encrypt.tables.<table-name>.columns.<logic-column-name>.assistedQueryColumn= #辅助查询字段，针对ShardingQueryAssistedEncryptor类型的加解密器进行辅助查询
spring.shardingsphere.encrypt.tables.<table-name>.columns.<logic-column-name>.encryptor= #加密器名字
```


治理 

```
#省略数据源、数据分片、读写分离和数据脱敏配置
 
spring.shardingsphere.orchestration.name= #治理实例名称
spring.shardingsphere.orchestration.overwrite= #本地配置是否覆盖注册中心配置。如果可覆盖，每次启动都以本地配置为准
spring.shardingsphere.orchestration.registry.type= #配置中心类型。如：zookeeper
spring.shardingsphere.orchestration.registry.server-lists= #连接注册中心服务器的列表。包括IP地址和端口号。多个地址用逗号分隔。如: host1:2181,host2:2181
spring.shardingsphere.orchestration.registry.namespace= #注册中心的命名空间
spring.shardingsphere.orchestration.registry.digest= #连接注册中心的权限令牌。缺省为不需要权限验证
spring.shardingsphere.orchestration.registry.operation-timeout-milliseconds= #操作超时的毫秒数，默认500毫秒
spring.shardingsphere.orchestration.registry.max-retries= #连接失败后的最大重试次数，默认3次
spring.shardingsphere.orchestration.registry.retry-interval-milliseconds= #重试间隔毫秒数，默认500毫秒
spring.shardingsphere.orchestration.registry.time-to-live-seconds= #临时节点存活秒数，默认60秒
spring.shardingsphere.orchestration.registry.props= #配置中心其它属性
```



其他

```
spring.shardingsphere.orchestration.reg.name= #Orchestration instance name
spring.shardingsphere.orchestration.reg.type= #Example:zookeeper,nacos,apollo
spring.shardingsphere.orchestration.reg.server-lists= 
spring.shardingsphere.orchestration.reg.namespace= 
spring.shardingsphere.orchestration.reg.digest= 
spring.shardingsphere.orchestration.reg.operation-timeout-milliseconds= 
spring.shardingsphere.orchestration.reg.max-retries= 
spring.shardingsphere.orchestration.reg.retry-interval-milliseconds= 
spring.shardingsphere.orchestration.reg.time-to-live-seconds= 
spring.shardingsphere.orchestration.reg.props= 
spring.shardingsphere.orchestration.conf.name= #Orchestration instance name
spring.shardingsphere.orchestration.conf.overwrite= 
spring.shardingsphere.orchestration.conf.type= #Example:zookeeper,nacos,apollo
spring.shardingsphere.orchestration.conf.server-lists= 
spring.shardingsphere.orchestration.conf.namespace= 
spring.shardingsphere.orchestration.conf.digest= 
spring.shardingsphere.orchestration.conf.operation-timeout-milliseconds= 
spring.shardingsphere.orchestration.conf.max-retries= 
spring.shardingsphere.orchestration.conf.retry-interval-milliseconds= 
spring.shardingsphere.orchestration.conf.time-to-live-seconds= 
spring.shardingsphere.orchestration.conf.props= 
spring.shardingsphere.orchestration.leaf.name= #Orchestration instance name
spring.shardingsphere.orchestration.leaf.type= #Example:zookeeper,nacos,apollo
spring.shardingsphere.orchestration.leaf.server-lists= 
spring.shardingsphere.orchestration.leaf.namespace= 
spring.shardingsphere.orchestration.leaf.digest= 
spring.shardingsphere.orchestration.leaf.operation-timeout-milliseconds= 
spring.shardingsphere.orchestration.leaf.max-retries= 
spring.shardingsphere.orchestration.leaf.retry-interval-milliseconds= 
spring.shardingsphere.orchestration.leaf.time-to-live-seconds= 
spring.shardingsphere.orchestration.leaf.props= 
```

