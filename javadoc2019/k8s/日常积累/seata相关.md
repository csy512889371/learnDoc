#####  版本1.0.0



相关配置

![image-20200304093133646](F:\3GitHub\learnDoc\javadoc2019\k8s\日常积累\seata相关.assets\image-20200304093133646.png)



pom.xml 配置



![image-20200304093149654](F:\3GitHub\learnDoc\javadoc2019\k8s\日常积累\seata相关.assets\image-20200304093149654.png)



事务处理超时时间

![image-20200304093238296](F:\3GitHub\learnDoc\javadoc2019\k8s\日常积累\seata相关.assets\image-20200304093238296.png)





* 本地事务加@Transactional
* 为了保证事务隔离sql 加上 for update
* 或者保证事务隔离加@GlobalLock



![image-20200304093457823](F:\3GitHub\learnDoc\javadoc2019\k8s\日常积累\seata相关.assets\image-20200304093457823.png)













