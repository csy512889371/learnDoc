https://nacos.io/zh-cn/docs/quick-start-docker.html

## 操作步骤

Clone 项目

```powershell
git clone https://github.com/nacos-group/nacos-docker.git
cd nacos-docker
```

单机模式 Derby

```powershell
docker-compose -f example/standalone-derby.yaml up
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
  
  

## 查看日志

docker-compose -f  example/standalone-derby.yaml  logs -f 