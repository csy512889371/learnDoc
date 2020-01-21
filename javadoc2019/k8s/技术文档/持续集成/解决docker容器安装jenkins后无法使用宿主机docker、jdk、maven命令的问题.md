# 新建一个目录

```
sudo mkdir /var/local/jenkins
```

新建 Dockfile 文件

```
FROM jenkins/jenkins:2.138.4
USER root
ARG dockerGid=999
RUN echo "docker:x:${dockerGid}:jenkins" >> /etc/group
RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y libltdl7 && apt-get update
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
USER jenkins

```

2.138.4 是版本号，不建议使用官方最新版本，有些问题

创建新的 jenkins 镜像
```
sudo docker build -t jenkins/jenkins:1.0 .
```

创建 jenkins 容器
```
sudo docker run -d -p 8080:8080 --name jenkins \
-v /usr/bin/docker:/usr/bin/docker \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /usr/bin/mv:/usr/bin/mv \
-v /var/local/jdk1.8.0_191/bin/java:/usr/bin/jdk1.8.0_191/java \
-v /var/local/jdk1.8.0_191:/var/local/jdk1.8.0_191 \ 
-v /var/local/apache-maven-3.6.0:/var/local/apache-maven-3.6.0 \ 
-v /var/jenkins_home:/var/jenkins_home jenkins/jenkins:1.0
```

```
-d 后台运行镜像
-p 80:8080 将镜像的8080端口映射到服务器的80端口
-p 50000:50000 将镜像的50000端口映射到服务器的50000端口
-v jenkins:/var/jenkins_home /var/jenkins_home目录为jenkins工作目录，我们将硬盘上的一个目录挂载到这个位置，方便后续更新镜像后继续使用原来的工作目录。
-v /etc/localtime:/etc/localtime 让容器使用和服务器同样的时间设置。
–name jenkins 给容器起一个别名
```

注意挂载目录授权
```
sudo chown -R 1000 /var/jenkins_home 
```

验证宿主机jdk maven调用

## 说明

目前采用的方式是：在宿主机 centos 上安装 docker、jdk、maven。然后，在 docker 中再运行 jenkins 容器，jenkins 中使用 docker、jdk、maven 等命令有多种方式（比如：在 jenkins 容器中安装，这里不多说），我这里采用的是使用宿主机的环境，然后就涉及到挂载和权限的问题。

