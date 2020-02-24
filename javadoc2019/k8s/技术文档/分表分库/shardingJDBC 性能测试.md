##### 测试数据准备

1、拆分10张表: t_order_item_0、t_order_item_1、t_order_item_2  .. t_order_item_9

2、拆分10张表: t_order_0、t_order_1、t_order_2  .. t_order_9

3、t_order 总数据量:**2千500万**, 单表的数据量:2百50万
4、t_order_item 总数据量:**2亿**数据量, 单表的数据量:2千万
5、t_order 分片column: order_id
6、t_order_item 分片column: order_id



##### 测试结果

1、分页查询-如果查询sql跨分片: ，如查询数据t_order_0 ... t_order_9。**2到3秒查询**（涉及到 select、count、以及数据合并、排序等。查询本地数据库性能不是很好）
2、分页查询-如果查询sql不跨分片: 如查询数据t_order_item 相同的订单的订单item 都在同一个表里面如t_order_item_0。**执行效率毫秒级别**
3、update delete insert queryById 设置好索引, **执行效率毫秒级别**







