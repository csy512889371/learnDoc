## 1. 测试

1. 分布式事务成功，模拟正常下单、扣库存

   localhost:9091/order/placeOrder/commit

2. 分布式事务失败，模拟下单成功、扣库存失败，最终同时回滚

   localhost:9091/order/placeOrder/rollback


