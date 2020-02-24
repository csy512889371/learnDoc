# 一、创建三节点 zookeeper 集群

1. **将 docker-compose.yml 保存到当前命令行目录下**

docker-compose.yml 文件

```
version: '2'
networks:
  zk:
services:
  zookeeper1:
    image: zookeeper
    container_name: zk1.cloud
    networks:
        - zk
    ports:
        - "2181:2181"
    environment:
      ZOO_MY_ID: 1
      ZOO_SERVERS: server.1=0.0.0.0:2888:3888 server.2=zk2.cloud:2888:3888 server.3=zk3.cloud:2888:3888
  zookeeper2:
    image: zookeeper
    container_name: zk2.cloud
    networks:
        - zk
    ports:
        - "2182:2181"
    environment:
      ZOO_MY_ID: 2
      ZOO_SERVERS: server.1=zk1.cloud:2888:3888 server.2=0.0.0.0:2888:3888 server.3=zk3.cloud:2888:3888
  zookeeper3:
    image: zookeeper
    container_name: zk3.cloud
    networks:
        - zk
    ports:
        - "2183:2181"
    environment:
      ZOO_MY_ID: 3
      ZOO_SERVERS: server.1=zk1.cloud:2888:3888 server.2=zk2.cloud:2888:3888 server.3=0.0.0.0:2888:3888
```

2. **执行命令，如果是首次获取 zookeeper 镜像，输出会有不同**

输入

```
docker pull zookeeper
```

输出

```
latest: Pulling from library/zookeeper
Digest: sha256:3f03c6f5a91e0f638f3d6a755b2d32c06583766031353be87e2d633fa3006c23
Status: Image is up to date for zookeeper:latest
```

 

3. **后台启动 zookeeper 集群**

```
docker-compose up -d
```

 

输出命令

```
Creating network "dczk_zk" with the default driver
Creating zk2.cloud ... done
Creating zk1.cloud ... done
Creating zk3.cloud ... done
```

------

 

# 二、检查进程状态

输入

```
docker ps
```

 

输出

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                        NAMES
cb176c76c620        zookeeper           "/docker-entrypoint.…"   6 minutes ago       Up 6 minutes        2888/tcp, 3888/tcp, 0.0.0.0:2183->2181/tcp   zk3.cloud
ee00aba1c766        zookeeper           "/docker-entrypoint.…"   6 minutes ago       Up 6 minutes        2888/tcp, 0.0.0.0:2181->2181/tcp, 3888/tcp   zk1.cloud
5d95baa693c2        zookeeper           "/docker-entrypoint.…"   6 minutes ago       Up 6 minutes        2888/tcp, 3888/tcp, 0.0.0.0:2182->2181/tcp   zk2.cloud
```

 

```
docker-compose ps
```

 

输出

```
Name                 Command               State                     Ports
-----------------------------------------------------------------------------------------------
zk1.cloud   /docker-entrypoint.sh zkSe ...   Up      0.0.0.0:2181->2181/tcp, 2888/tcp, 3888/tcp
zk2.cloud   /docker-entrypoint.sh zkSe ...   Up      0.0.0.0:2182->2181/tcp, 2888/tcp, 3888/tcp
zk3.cloud   /docker-entrypoint.sh zkSe ...   Up      0.0.0.0:2183->2181/tcp, 2888/tcp, 3888/tcp
```

------

 

# 三、测试

## **1. docker 3 为leader**

输入

```
docker exec -it zk1.cloud bash ./bin/zkServer.sh status
```


输出

```
ZooKeeper JMX enabled by default
Using config: /conf/zoo.cfg
Mode: follower
```

输入

```
docker exec -it zk2.cloud bash ./bin/zkServer.sh status
```

 

输出

```
ZooKeeper JMX enabled by default
Using config: /conf/zoo.cfg
Mode: follower
```

输入

```
docker exec -it zk3.cloud bash ./bin/zkServer.sh status
```

 

输出

```
ZooKeeper JMX enabled by default
Using config: /conf/zoo.cfg
Mode: leader
```

 

## **2. 关闭 zk3.cloud 后检查leader变化情况**

输入

```
docker stop zk3.cloud
docker exec -it zk2.cloud bash ./bin/zkServer.sh status
```

输出

```
ZooKeeper JMX enabled by default
Using config: /conf/zoo.cfg
Mode: leader
```

 

## **3. 再次启动 zk3.cloud 后检查 leader变化情况**

输入

```
docker start zk3.cloud
docker exec -it zk2.cloud bash ./bin/zkServer.sh status
```

输出

```
ZooKeeper JMX enabled by default
Using config: /conf/zoo.cfg
Mode: leader
```

输入

```
docker exec -it zk3.cloud bash ./bin/zkServer.sh status
```

输出

```
ZooKeeper JMX enabled by default
Using config: /conf/zoo.cfg
Mode: follower
```

 

## **4. 关闭 zk2.cloud 后检查 leader变化情况**

输入

```
docker stop zk2.cloud
docker exec -it zk3.cloud bash ./bin/zkServer.sh status
```

输出

```
ZooKeeper JMX enabled by default
Using config: /conf/zoo.cfg
Mode: leader
```