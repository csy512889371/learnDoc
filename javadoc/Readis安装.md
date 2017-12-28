
# 安装redis

```shell
docker pull redis:latest

mkdir /data
mkdir /etc/redis
```

## 上传配置文件

```shell

cd /etc/redis
cp /root/redis.conf .
```
将redis4.0.1 配置文件放在
> /etc/redis/redis.conf

```shell
daemonize yes
默认情况下，redis 不是在后台运行的，如果需要在后台运行，把该项的值更改为yes。


pidfile /var/run/redis_6379.pid
当Redis 在后台运行的时候，Redis 默认会把pid 文件放在/var/run/redis.pid，你可以配置到其他地址。当运行多个redis 服务时，需要指定不同的pid 文件和端口


port
监听端口，默认为6379

#bind 127.0.0.1	
指定Redis 只接收来自于该IP 地址的请求，如果不进行设置，那么将处理所有请求，在生产环境中为了安全最好设置该项。默认注释掉，不开启


```

```shell
docker run -p 6379:6379 --name redis4.0.1 \
 --restart always \
 -v $PWD/redis.conf:/etc/redis/redis.conf -v $PWD/data:/data -d \
 redis:latest redis-server /etc/redis/redis.conf --appendonly yes

```

命令说明：
>* -p 6379:6379 :将容器的6379端口映射到主机的6379端口
>* -v $PWD/data:/data :将主机中当前目录下的data挂载到容器的/data
>* redis-server --appendonly yes :在容器执行redis-server启动命令，并打开redis持久化配置

> 查看安装情况
```shell
docker ps -a

查看映射端口
docker port redis4.0.1

查看应用进程日志
docker logs -f redis4.0.1

重启	
docker start redis4.0.1
停止	
docker stop redis4.0.1

我们可以使用 docker rm 命令来删除不需要的容器	
docker rm redis4.0.1

列出镜像列表
docker images

查询出Pid
docker inspect --format "{{ .State.Pid}}" redis4.0.1

然后通过得到的Pid执行
nsenter --target 3368 --mount --uts --ipc --net --pid

退出容器	
exit

```
## redis 4.1配置文件

> 配置文件修改
```xml
把下面对应的注释掉
# bind 127.0.0.1 

Redis默认不是以守护进程的方式运行，可以通过该配置项修改，使用yes启用守护进程，设置为no
daemonize no

保护模式
protected-mode no 
```




