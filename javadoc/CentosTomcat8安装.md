# docker仓库上搜索

```shell
docker search tomcat

mkdir /var/www
mkdir /var/www/blogServer

chmod 777 /var/www/blogServer

docker run --privileged=true --name blogServer --restart always -v /var/www/blogServer:/usr/local/tomcat/webapps/ROOT  -d -p 8080:8080 tomcat:8

```

```shell
docker ps -a

查看映射端口
docker port blogServer

查看应用进程日志
docker logs -f blogServer


重启	
docker start blogServer
停止	
docker stop blogServer

我们可以使用 docker rm 命令来删除不需要的容器	
docker rm blogServer

列出镜像列表
docker images

查询出Pid
docker inspect --format "{{ .State.Pid}}" blogServer

然后通过得到的Pid执行
nsenter --target 3368 --mount --uts --ipc --net --pid

退出容器	
exit
```


