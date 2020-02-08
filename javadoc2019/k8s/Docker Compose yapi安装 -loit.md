#### mongodb 安装

docker-compose.yml



```
version: '3'

services:
    mongodb:
      image: bitnami/mongodb:latest
      volumes:
        - /usr/local/docker/mongodb/mongo-data:/bitnami/mongodb
      ports:
        - "27017:27017"
```



#### yapi 安装

docker-compose.yml

```
version: '3'
services:
  mongo-db:
    image: mongo:latest
    container_name: mongo-db
    #network_mode: "host"
    restart: always
    ports:
      - 27017:27017
    environment:
      TZ: Asia/Shanghai
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: admin@123
    volumes:
      - /usr/local/docker/mongo/db:/data/db
      - /etc/localtime:/etc/localtime
    logging:
      driver: "json-file"
      options:
        max-size: "200k"
        max-file: "10"

  mongo-express:
    image: mongo-express:latest
    container_name: mongo-express
    restart: always
    links:
      - mongo-db:mongodb
    depends_on:
      - mongo-db
    ports:
      - 27018:8081
    environment:
      ME_CONFIG_OPTIONS_EDITORTHEME: 3024-night
      ME_CONFIG_MONGODB_SERVER: mongodb
      ME_CONFIG_MONGODB_ADMINUSERNAME: admin
      ME_CONFIG_MONGODB_ADMINPASSWORD: admin@123
      ME_CONFIG_BASICAUTH_USERNAME: admin
      ME_CONFIG_BASICAUTH_PASSWORD: admin@123

  yapi:
    image: xzxiaoshan/yapi
    container_name: yapi
    network_mode: "host"
    environment:
      SERVER_PORT: 3000
    volumes:
      - /usr/local/docker/yapi/config.json:/api/config.json
    depends_on:
      - mongo-db
    logging:
      driver: "json-file"
      options:
        max-size: "200k"
        max-file: "10"
```



vi /usr/local/docker/yapi/config.json

```
{
  "port": "3000",
  "adminAccount": "admin@admin.com",
  "db": {
    "servername": "127.0.0.1",
    "DATABASE": "yapi",
    "port": 27017,
    "user": "admin",
    "pass": "admin@123",
    "authSource": "admin"
  },
  "mail": {
    "enable": true,
    "host": "smtp.163.com",
    "port": 465,
    "from": "csy@163.com",
    "auth": {
      "user": "csy@163.com",
      "pass": "123456"
    }
  }
}


```

启动docker

```
docker-compose up -d
```

初始化DB

```
docker exec -it yapi npm run install-server
```

五、访问yapi

```
访问 http://192.168.x.x:3000 登录账号为 config.json 中的 adminAccount admin@admin.com，密码 ymfe.org
```

