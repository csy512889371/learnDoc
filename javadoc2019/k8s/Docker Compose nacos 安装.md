https://nacos.io/zh-cn/docs/quick-start-docker.html

## 操作步骤

Clone 项目

```powershell
git clone https://github.com/nacos-group/nacos-docker.git
cd nacos-docker
```

单机模式 Mysql

```powershell
docker-compose -f example/standalone-mysql.yaml up -d
```

- 服务注册

  ```powershell
  curl -X POST 'http://192.168.66.40:8848/nacos/v1/ns/instance?serviceName=nacos.naming.serviceName&ip=20.18.7.10&port=8080'
  ```

- 服务发现

  ```powershell
  curl -X GET 'http://192.168.66.40:8848/nacos/v1/ns/instances?serviceName=nacos.naming.serviceName'
  ```

- 发布配置

  ```powershell
  curl -X POST "http://192.168.66.40:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test&content=helloWorld"
  ```

- 获取配置

  ```powershell
    curl -X GET "http://192.168.66.40:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test"
  ```

- Nacos 控制台

  link：http://192.168.66.40:8848/nacos/

## Nacos + Grafana + Prometheus

参考：[Nacos监控指南](https://nacos.io/zh-cn/docs/monitor-guide.html)

**Note**: grafana创建一个新数据源时，数据源地址必须是 **[http://prometheus:9090](http://prometheus:9090/)**



dashboard 模板

```java
https://github.com/nacos-group/nacos-template/blob/master/nacos-grafana.json
```

https://nacos.io/zh-cn/docs/monitor-guide.html



## 查看日志

docker-compose -f  example/standalone-mysql.yaml  logs -f 