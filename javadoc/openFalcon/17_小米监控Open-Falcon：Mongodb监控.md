# 小米监控Open-Falcon：Mongodb监控

## 一、	功能支持
* 已测试版本: 支持MongoDB版本2.4,2.6 3.0,3.2, 以及Percona MongoDB3.0
* 支持存储引擎：MMAPv1, wiredTiger, RocksDB, PerconaFT 存储引擎(部分存储引擎的指标未  
* 采集完,可直接代码中添加)
* 支持结构: standlone, 副本集,分片集群
* 支持节点：mongod数据节点，配置节点，Primary/Secondary, mongos; 不支持Arbiter节点

## 二、	数据采集

* 1、存活监控: 包括auth
* 2、serverStatus
* 3、replSetGetStatus
* 4、oplog.rs
* 5、mongos

通过cron每分钟采集上报,采集对MongoDB理论无性能影响

## 三、	环境要求

* 操作系统: Linux
* Python 2.6
* PyYAML > 3.10
* python-requests > 0.11

## 四、	程序部署

* 下载地址：https://github.com/ZhuoRoger/mongomon
* 进入目录  cd /data/program/software/mongomon
* 配置当前服务器的MongoDB多实例(mongod,配置节点,mongos)信息,/path/to/mongomon/conf/mongomon.conf 每行记录一个实例: 端口，用户名，密码
```shell
{port: 27017, user: "",password: ""}
```
* 配置crontab, 修改mongomon/conf/mongomon_cron文件中mongomon安装path; cp mongomon_cron /etc/cron.d/
* 几分钟后，可从open-falcon的dashboard中查看MongoDB metric
* endpoint默认是hostname

五、	测试

第四步的配置到crontab中。但是我们也可以自己测试一下，如下：

```shell

cd /data/program/software/mongomon/bin
python  mongodb_monitor.py

```

如果出现如下错误：

```shell
Traceback (most recent call last):
  File "mongodb_monitor.py", line 13, in <module>
    from mongodb_server import mongodbMonitor
  File "/data/program/software/mongomon/bin/mongodb_server.py", line 7, in <module>
    import pymongo
ImportError: No module named pymongo

```

* 解决办法：pip install pymongo
* 然后再执行python  mongodb_monitor.py

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/openFalcon/21.png)


采集的MongoDB指标

```xml
Counters	Type	Notes

mongo_local_alive	GAUGE	mongodb存活本地监控，如果开启Auth，要求连接认证成功
asserts_msg	COUNTER	消息断言数/秒
asserts_regular	COUNTER	常规断言数/秒
asserts_rollovers	COUNTER	计数器roll over的次数/秒,计数器每2^30个断言就会清零
asserts_user	COUNTER	用户断言数/秒
asserts_warning	COUNTER	警告断言数/秒
page_faults	COUNTER	页缺失次数/秒
connections_available	GAUGE	未使用的可用连接数
connections_current	GAUGE	当前所有客户端的已连接的连接数
connections_used_percent	GAUGE	已使用连接数百分比
connections_totalCreated	COUNTER	创建的新连接数/秒
globalLock_currentQueue_total	GAUGE	当前队列中等待锁的操作数
globalLock_currentQueue_readers	GAUGE	当前队列中等待读锁的操作数
globalLock_currentQueue_writers	GAUGE	当前队列中等待写锁的操作数
locks_Global_acquireCount_ISlock	COUNTER	实例级意向共享锁获取次数
locks_Global_acquireCount_IXlock	COUNTER	实例级意向排他锁获取次数
locks_Global_acquireCount_Slock	COUNTER	实例级共享锁获取次数
locks_Global_acquireCount_Xlock	COUNTER	实例级排他锁获取次数
locks_Global_acquireWaitCount_ISlock	COUNTER	实例级意向共享锁等待次数
locks_Global_acquireWaitCount_IXlock	COUNTER	实例级意向排他锁等待次数
locks_Global_timeAcquiringMicros_ISlock	COUNTER	实例级共享锁获取耗时 单位:微秒
locks_Global_timeAcquiringMicros_IXlock	COUNTER	实例级共排他获取耗时 单位:微秒
locks_Database_acquireCount_ISlock	COUNTER	数据库级意向共享锁获取次数
locks_Database_acquireCount_IXlock	COUNTER	数据库级意向排他锁获取次数
locks_Database_acquireCount_Slock	COUNTER	数据库级共享锁获取次数
locks_Database_acquireCount_Xlock	COUNTER	数据库级排他锁获取次数
locks_Collection_acquireCount_ISlock	COUNTER	集合级意向共享锁获取次数
locks_Collection_acquireCount_IXlock	COUNTER	集合级意向排他锁获取次数
locks_Collection_acquireCount_Xlock	COUNTER	集合级排他锁获取次数
opcounters_command	COUNTER	数据库执行的所有命令/秒
opcounters_insert	COUNTER	数据库执行的插入操作次数/秒
opcounters_delete	COUNTER	数据库执行的删除操作次数/秒
opcounters_update	COUNTER	数据库执行的更新操作次数/秒
opcounters_query	COUNTER	数据库执行的查询操作次数/秒
opcounters_getmore	COUNTER	数据库执行的getmore操作次数/秒
opcountersRepl_command	COUNTER	数据库复制执行的所有命令次数/秒
opcountersRepl_insert	COUNTER	数据库复制执行的插入命令次数/秒
opcountersRepl_delete	COUNTER	数据库复制执行的删除命令次数/秒
opcountersRepl_update	COUNTER	数据库复制执行的更新命令次数/秒
opcountersRepl_query	COUNTER	数据库复制执行的查询命令次数/秒
opcountersRepl_getmore	COUNTER	数据库复制执行的gtemore命令次数/秒
network_bytesIn	COUNTER	数据库接受的网络传输字节数/秒
network_bytesOut	COUNTER	数据库发送的网络传输字节数/秒
network_numRequests	COUNTER	数据库接收到的请求的总次数/秒
mem_virtual	GAUGE	数据库进程使用的虚拟内存
mem_resident	GAUGE	数据库进程使用的物理内存
mem_mapped	GAUGE	mapped的内存,只用于MMAPv1 存储引擎
mem_bits	GAUGE	64 or 32bit
mem_mappedWithJournal	GAUGE	journal日志消耗的映射内存，只用于MMAPv1 存储引擎
backgroundFlushing_flushes	COUNTER	数据库刷新写操作到磁盘的次数/秒
backgroundFlushing_average_ms	GAUGE	数据库刷新写操作到磁盘的平均耗时，单位ms
backgroundFlushing_last_ms	COUNTER	当前最近一次数据库刷新写操作到磁盘的耗时，单位ms
backgroundFlushing_total_ms	GAUGE	数据库刷新写操作到磁盘的总耗时/秒，单位ms
cursor_open_total	GAUGE	当前数据库为客户端维护的游标总数
cursor_timedOut	COUNTER	数据库timout的游标个数/秒
cursor_open_noTimeout	GAUGE	设置DBQuery.Option.noTimeout的游标数
cursor_open_pinned	GAUGE	打开的pinned的游标数
repl_health	GAUGE	复制的健康状态
repl_myState	GAUGE	当前节点的副本集状态
repl_oplog_window	GAUGE	oplog的窗口大小
repl_optime	GAUGE	上次执行的时间戳
replication_lag_percent	GAUGE	延时占比(lag/oplog_window)
repl_lag	GAUGE	Secondary复制延时，单位秒
shards_size	GAUGE	数据库集群的分片个数; config.shards.count
shards_mongosSize	GAUGE	数据库集群中mongos节点个数；config.mongos.count
shards_chunkSize	GAUGE	数据库集群的chunksize大小设置，以config.settings集合中获取
shards_activeWindow	GAUGE	数据库集群的数据均衡器是否设置了时间窗口，1/0
shards_activeWindow_start	GAUGE	数据库集群的数据均衡器时间窗口开始时间，格式23.30表示 23：30分
shards_activeWindow_stop	GAUGE	数据库集群的数据均衡器时间窗口结束时间，格式23.30表示 23：30分
shards_BalancerState	GAUGE	数据库集群的数据均衡器的状态，是否为打开
shards_isBalancerRunning	GAUGE	数据库集群的数据均衡器是否正在运行块迁移
wt_cache_used_total_bytes	GAUGE	wiredTiger cache的字节数
wt_cache_dirty_bytes	GAUGE	wiredTiger cache中"dirty"数据的字节数
wt_cache_readinto_bytes	COUNTER	数据库写入wiredTiger cache的字节数/秒
wt_cache_writtenfrom_bytes	COUNTER	数据库从wiredTiger cache写入到磁盘的字节数/秒
wt_concurrentTransactions_write	GAUGE	write tickets available to the WiredTiger storage engine
wt_concurrentTransactions_read	GAUGE	read tickets available to the WiredTiger storage engine
wt_bm_bytes_read	COUNTER	block-manager read字节数/秒
wt_bm_bytes_written	COUNTER	block-manager write字节数/秒
wt_bm_blocks_read	COUNTER	block-manager read块数/秒
wt_bm_blocks_written	COUNTER	block-manager write块数/秒
rocksdb_num_immutable_mem_table		
rocksdb_mem_table_flush_pending		
rocksdb_compaction_pending		
rocksdb_background_errors		
rocksdb_num_entries_active_mem_table		
rocksdb_num_entries_imm_mem_tables		
rocksdb_num_snapshots		
rocksdb_oldest_snapshot_time		
rocksdb_num_live_versions		
rocksdb_total_live_recovery_units		
PerconaFT_cachetable_size_current		
PerconaFT_cachetable_size_limit		
PerconaFT_cachetable_size_writing		
PerconaFT_checkpoint_count		
PerconaFT_checkpoint_time		
PerconaFT_checkpoint_write_leaf_bytes_compressed		
PerconaFT_checkpoint_write_leaf_bytes_uncompressed		
PerconaFT_checkpoint_write_leaf_count		
PerconaFT_checkpoint_write_leaf_time		
PerconaFT_checkpoint_write_nonleaf_bytes_compressed		
PerconaFT_checkpoint_write_nonleaf_bytes_uncompressed		
PerconaFT_checkpoint_write_nonleaf_count		
PerconaFT_checkpoint_write_nonleaf_time		
PerconaFT_compressionRatio_leaf		
PerconaFT_compressionRatio_nonleaf		
PerconaFT_compressionRatio_overall		
PerconaFT_fsync_count		
PerconaFT_fsync_time		
PerconaFT_log_bytes		
PerconaFT_log_count		
PerconaFT_log_time		
PerconaFT_serializeTime_leaf_compress		
PerconaFT_serializeTime_leaf_decompress		
PerconaFT_serializeTime_leaf_deserialize		
PerconaFT_serializeTime_leaf_serialize		
PerconaFT_serializeTime_nonleaf_compress		
PerconaFT_serializeTime_nonleaf_decompress		
PerconaFT_serializeTime_nonleaf_deserialize		
PerconaFT_serializeTime_nonleaf_serialize		

```
