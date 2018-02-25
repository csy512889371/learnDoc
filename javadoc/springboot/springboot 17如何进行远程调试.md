# 如何进行远程调试

# 远程调试的概念
* 什么是远程调试：本地调用非本地的环境进行调试。
* 原理：两个VM之间通过socket协议进行通信，然后以达到远程调试的目的。
* 注意，如果 Java 源代码与目标应用程序不匹配，调试特性将不能正常工作。

# java启动命令
* -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8000,suspend=n
* 比如：java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8000,suspend=n –jar  spring-boot-demo-24-1-0.0.1-SNAPSHOT.jar
 
 
 
