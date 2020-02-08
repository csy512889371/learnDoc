# 相关配置

## standalone-mysql.yaml

example/standalone-mysql.yaml



* nacos/nacos-server:loitv2 有做样式修改

```
version: "2"
services:
  nacos:
    image: nacos/nacos-server:loitv2
    container_name: nacos-standalone-mysql
    environment:
      - PREFER_HOST_MODE=hostname
      - MODE=standalone
      - SPRING_DATASOURCE_PLATFORM=mysql
      - MYSQL_MASTER_SERVICE_HOST=mysql-master
      - MYSQL_MASTER_SERVICE_DB_NAME=nacos_devtest
      - MYSQL_MASTER_SERVICE_PORT=3306
      - MYSQL_SLAVE_SERVICE_HOST=mysql-slave
version: "2"
services:
  nacos:
    image: nacos/nacos-server:loitv2
    container_name: nacos-standalone-mysql
    environment:
      - PREFER_HOST_MODE=hostname
      - MODE=standalone
      - SPRING_DATASOURCE_PLATFORM=mysql
      - MYSQL_MASTER_SERVICE_HOST=mysql-master
      - MYSQL_MASTER_SERVICE_DB_NAME=nacos_devtest
      - MYSQL_MASTER_SERVICE_PORT=3306
      - MYSQL_SLAVE_SERVICE_HOST=mysql-slave
      - MYSQL_SLAVE_SERVICE_PORT=3305
      - MYSQL_MASTER_SERVICE_USER=nacos
      - MYSQL_MASTER_SERVICE_PASSWORD=nacos
    volumes:
      - ./standalone-logs/:/home/nacos/logs
      - ./init.d/custom.properties:/home/nacos/init.d/custom.properties
    ports:
      - "8103:8848"
      - "9555:9555"
    depends_on:
      - mysql-slave
    restart: on-failure
  mysql-master:
    container_name: mysql-master
    image: nacos/nacos-mysql-master:latest
    env_file:
      - ../env/mysql-common.env
      - ../env/mysql-master.env
    volumes:
      - ./mysql-master:/var/lib/mysql
    ports:
      - "12092:3306"
  mysql-slave:
    container_name: mysql-slave
    image: nacos/nacos-mysql-slave:latest
    env_file:
      - ../env/mysql-common.env
      - ../env/mysql-slave.env

```



##  custom.properties

/docker/nacos-docker/example/init.d/custom.properties

```
spring.security.enabled=false
management.security=false
security.basic.enabled=false
nacos.security.ignore.urls=/**
#management.metrics.export.elastic.host=http://localhost:9200
# metrics for prometheus
management.endpoints.web.exposure.include=*

# metrics for elastic search
#management.metrics.export.elastic.enabled=false
#management.metrics.export.elastic.host=http://localhost:9200

# metrics for influx
#management.metrics.export.influx.enabled=false
#management.metrics.export.influx.db=springboot
#management.metrics.export.influx.uri=http://localhost:8086
#management.metrics.export.influx.auto-create-db=true
#management.metrics.export.influx.consistency=one
#management.metrics.export.influx.compressed=true
```


### application.properties

docker/nacos-docker/build/conf/application.properties

修改：
* server.port 
* db.url.0
* db.url.1


```
# spring
server.servlet.contextPath=${SERVER_SERVLET_CONTEXTPATH:/nacos}
server.contextPath=/nacos
server.port=8103
spring.datasource.platform=${SPRING_DATASOURCE_PLATFORM:""}
nacos.cmdb.dumpTaskInterval=3600
nacos.cmdb.eventTaskInterval=10
nacos.cmdb.labelTaskInterval=300
nacos.cmdb.loadDataAtStart=false
db.num=${MYSQL_DATABASE_NUM:2}
db.url.0=jdbc:mysql://localhost:12092/${MYSQL_MASTER_SERVICE_DB_NAME}?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true
db.url.1=jdbc:mysql://localhost:12091/${MYSQL_MASTER_SERVICE_DB_NAME}?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true
db.user=${MYSQL_MASTER_SERVICE_USER}
db.password=${MYSQL_MASTER_SERVICE_PASSWORD}
server.tomcat.accesslog.enabled=${TOMCAT_ACCESSLOG_ENABLED:false}
server.tomcat.accesslog.pattern=%h %l %u %t "%r" %s %b %D
# default current work dir
server.tomcat.basedir=
## spring security config
### turn off security

nacos.security.ignore.urls=/,/**/*.css,/**/*.js,/**/*.html,/**/*.map,/**/*.svg,/**/*.png,/**/*.ico,/console-fe/public/**,/v1/auth/login,/v1/console/health/**,/v1/cs/**,/v1/ns/**,/v1/cmdb/**,/actuator/**,/v1/console/server/**
# metrics for elastic search
management.metrics.export.elastic.enabled=false
management.metrics.export.influx.enabled=false

nacos.naming.distro.taskDispatchThreadCount=10
nacos.naming.distro.taskDispatchPeriod=200
nacos.naming.distro.batchSyncKeyCount=1000
nacos.naming.distro.initDataRatio=0.9
nacos.naming.distro.syncRetryDelay=5000
nacos.naming.data.warmup=true
```



### 启动

```

cd /usr/local/loit/soft/docker/nacos-docker

# 停止
docker-compose -f example/standalone-mysql.yaml stop

# 启动
docker-compose -f example/standalone-mysql.yaml start
```



