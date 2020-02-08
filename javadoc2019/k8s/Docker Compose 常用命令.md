#### Docker Compose 常用命令

**前台运行**

```text
docker-compose up
```

**后台运行**

```text
docker-compose up -d
```

启动

```text
docker-compose start
```

 停止

```text
docker-compose stop
```

停止并移除容器

```text
docker-compose down
```



root 访问容器

```
docker exec -it -u root
```



> 拷贝文件

拷贝出来

```
 docker cp wiki_confluence:/opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-decoder-v2-3.4.1.jar /opt/docker/mysql
```

拷贝进去

```
  docker cp atlassian-extras-decoder-v2-3.4.1.jar wiki_confluence:/opt/atlassian/confluence/confluence/WEB-INF/lib/atlassian-extras-decoder-v2-3.4.1.jar 
```



> Docker保存修改后的镜像

```
docker commit afcaf46e8305 centos-vim

查看镜像centos-vim
docker images | grep centos-vim

查看镜像的详细信息：
docker inspect centos-vim:afcaf46e8305

删除镜像
docker image rm e2f5e9044b5e

删除容器

docker container rm ccc
```





#### 配置 Docker 镜像站



https://www.daocloud.io/mirror#accelerator-doc

##### Linux

```
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
```

该脚本可以将 --registry-mirror 加入到你的 Docker 配置文件 /etc/docker/daemon.json 中。适用于 Ubuntu14.04、Debian、CentOS6 、CentOS7、Fedora、Arch Linux、openSUSE Leap 42.1，其他版本可能有细微不同。更多详情请访问文档。

##### macOS

Docker For Mac

右键点击桌面顶栏的 docker 图标，选择 Preferences ，在 Daemon 标签（Docker 17.03 之前版本为 Advanced 标签）下的 Registry mirrors 列表中加入下面的镜像地址:

```
http://f1361db2.m.daocloud.io
```

点击 Apply & Restart 按钮使设置生效。

Docker Toolbox 等配置方法请参考[帮助文档](http://guide.daocloud.io/dcs/daocloud-9153151.html#docker-toolbox)。

##### Windows

Docker For Windows

在桌面右下角状态栏中右键 docker 图标，修改在 Docker Daemon 标签页中的 json ，把下面的地址:

```
http://f1361db2.m.daocloud.io
```

加到" `registry-mirrors`"的数组里。点击 Apply 。



##### 其他镜像站点

```
中国官方镜像源地址为：https://registry.docker-cn.com
```

