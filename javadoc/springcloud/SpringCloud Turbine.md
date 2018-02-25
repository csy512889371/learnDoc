# SpringCloud Turbine

* turbine是聚合服务器发送事件流数据的一个工具，hystrix的监控中，只能监控单个节点，实际生产中都为集群，因此可以通过 
* turbine来监控集群下hystrix的metrics情况，通过eureka来发现hystrix服务。

# 配置 

> pom.xml 中引入tuibine支持

```java
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-turbine</artifactId>
		</dependency>

```

## 入口类引入Turbine

```java
@EnableTurbine
@SpringBootApplication
public class TurbineApplication {
  public static void main(String[] args) {
    SpringApplication.run(TurbineApplication.class, args);
  }
}
```

## turbine 配置文件

* 可以指定监控具体的微服务：appConfig microservice-consumer-movie-ribbon-with-hystrix
* 
```xml
turbine:
  aggregator:
    clusterConfig: default # 指定聚合哪些集群“,” 分割，默认为default。可用
  appConfig: microservice-consumer-movie-ribbon-with-hystrix,microservice-consumer-movie-feign-with-hystrix
  # appConifg 配置Euraka中的serviceId列表，表明监控哪些服务
  clusterNameExpression: "'default'"
  # 1. clusterNameExpression 指定集群名称，默认表达式appName; 此时 turbine.aggregator.clusterConfig 需要配置要监控的应用名称
  # 2. clusterNameExpression: "'default'" 时 clusterConfig: default 同时设置为default
  # 3. clusterNameExpression: metadata['cluster']时 应用配置 eureka.instance.metadata-map.cluster:ABC 则 clusterConfig 也配置成ABC
  
```

> http://localhost:8031/turbine.stream 地址查看接口信息

## 结合hystrix Dashboard 查看信息

* 运行dashboard
* 访问dashboard http://localhost:8030/hystrix
* 在Hystrix Dashboard 中填入 http://localhost:8031/turbine.stream 
* 点击 Monitor Stream 查看





