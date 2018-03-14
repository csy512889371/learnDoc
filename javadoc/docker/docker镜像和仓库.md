# docker镜像和仓库


## 一、	镜像介绍

* Docker镜像是由文件系统叠加而成。最低端是一个引导文件系统，即bootfs。当一个容器启动后，它将会被移到内存中，而引导文件系统则会被卸载，以留出更多的内存供initrd磁盘镜像使用。
* Docker镜像的第二层是root文件系统rootfs，它位于引导文件系统之上。rootfs可以是一种或多种操作系统。
* 在Docker里，root文件系统永远只能是只读状态，并且Docker利用联合加载技术又会在root文件系统层上加载更多的只读文件系统。联合加载指的是一次同时加载多个文件系统，但是在外面看起来只能看到一个文件系统。联合加载会将各层文件系统叠加到一起，这样最终的文件系统会包含所有底层的文件和目录。
* 当从一个镜像启动容器时，Docker会在该镜像的最顶层加载一个读写文件系统。
* 当Docker第一次启动一个容器时，初始的读写层是空的。当文件系统发生变化时，这些变化都会应用到这一层上。如果修改一个文件，这个文件首先会从该读写层下面的只读层复制到该读写层。该文件的只读版本依然存在，但是已经被读写层中的该文件副本所隐藏。
* 通常这种机制被称为写时复制，这也是使Docker如此强大的技术之一。每个只读镜像层都是只读的，并且以后永远不会变化。当创建一个新容器时，Docker会构建出一个镜像栈，并在栈的最顶端添加一个读写层。这个读写层再加上其下面的镜像层以及一些配置数据，就构成了一个容器。

## 二、	查看镜像
用docker images来查看镜像。


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/18.png)


* 本地镜像都保存在Docker宿主机的/var/lib/docker目录下。每个镜像都保存在Docker所采用的存储驱动目录下面，如aufs或者devicemapper。也可以在/var/lib/docker/containers目录下面看到所有的容器。
* 镜像从仓库下载下来。镜像保存在仓库中，而仓库存在于Registry中。默认的Registry是由Docker公司运营的公共Registry服务，即Docker Hub。

## 三、	拉取镜像

* 用docker run命令从镜像启动一个容器时，如果该镜像不在本地，Docker会先从Docker Hub下载该镜像。如果没有指定具体的镜像标签，那么Docker会自动下载latest标签的镜像。
* docker run -t -i --name test_container centos /bin/bash
* 使用docker pull命令来拉取centos仓库中的内容，使用docker pull命令可以节省从一个新镜像启动一个容器所需的时间。

## 四、	查找镜像
可以通过docker search命令来查找所有Docker Hub上公共的可用镜像。

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/19.png)

字段含义：仓库名、镜像描述、用户评价(Stars)、是否官方、自动构建

## 五、	构建镜像

### 1、	注册docker hub账号并登陆

https://hub.docker.com/login/新建账号

```shell
[root@dst6 containers]# docker login
Username: harbourside
Password: 
Email: hhfc_qq@163.com
WARNING: login credentials saved in /root/.docker/config.json
Login Succeeded
```

### 2、	使用docker commit命令构建镜像
创建Dokcer镜像可以想象为我们是在往版本控制系统里提交变更。先创建一个容器，并在容器里做出修改，最后再将修改提交为一个新镜像。

```shell
[root@dst6 containers]# docker run --net host --name test_dev -t -i centos /bin/bash
```

这里安装vim然后发布为镜像。

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/20.png)

```shell
[root@dst6 ~]# docker commit a11bc8f23aa0 harbourside/bigdata
```

* 用docker commit去提交，指定了要提交的修改过的容器ID，以及一个目标镜像仓库和镜像名。Docker commit提交的只是创建容器的镜像和容器的当前状态之间有差异的部分，这似的该更新非常轻量。

也可以加参数来制定更多的描述。
```shell
docker commit -m=”a new image” --author=”bigdata” a11bc8f23aa0 harbourside/yongyou
:test
```
-m来制定新创建的镜像的提交信息，--author选项用来列出该镜像的作者信息。harbourside/yongyou指定了镜像的用户名和仓库名，并为该镜像增加了一个test标签。

```shell
[root@dst6 ~]# docker push harbourside/bigdata  上传到镜像仓库。
```

### 3、	使用docker build命令和Dockerfile文件构建镜像

* 并不推荐使用docker commit的方法来构建镜像，推荐使用被称为Dockerfile的定义文件和docker build命令来构建镜像。Dockerfile使用基本的基于DSL语法的指令来构建一个Docker镜像，之后使用docker build命令基于该Dockerfile中的指令构建一个新的镜像。
* 创建文件夹：/data/program/dockerfile
* 创建文件：touch Dockerfile
* 创建了dockerfile目录来保存Dockerfile，这个目录就是构建环境，Docker则称此环境为上下文或者构建上下文。Docker会在构建镜像时将构建上下文和该上下文中的文件和目录上传到Docker守护进程，这样Docker守护进程就能直接访问你想在镜像中存储的任何代码、文件或者其他数据。
* 创建Dockerfile如下：
```shell
（#Version:0.01
FROM centos
MAINTAINER bigdata "79021218@qq.com"
RUN  yum install -y tomcat
EXPOSE 80）

#Version:0.01
FROM centos
MAINTAINER bigdata "79021218@qq.com"
RUN yum -y install wget
RUN wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -ivh epel-release-6-8.noarch.rpm
RUN rpm -Va --nofiles --nodigest
RUN  yum install -y nginx --skip-broken
EXPOSE 80
```

解释：

* Dockerfile支持注释，用#去注释。
* 每条指令，必须大写，例如FROM。
* 每条指令都会创建一个新的镜像层并对镜像金星提交。
* 每个Dockerfile的第一条指令都应该是FROM，指定一个已经存在的镜像，后续指令将基于该镜像进行。
* 指令MAINTAINER，指定镜像的作者和邮件联系方式。
* 之后进行RUN指令，RUN指令会在镜像中运行指定的指令，RUN指令会在shell里使用命令包装器/bin/sh –c来执行，也可以使用RUN[“yum”,”install”,”-y”,”nginx”]。
* 之后设置了EXPOSE指令，告诉Docker该容器内的应用程序将会使用容器的指定端口。

* 使用docker build命令来构建镜像。
* 进入目录，执行 docker build -t="harbourside/dockertest" .  该命令返回一个新镜像，命令中-t设置了仓库和名称。也可以添加标签，例如：docker build -t="harbourside/dockertest:v1" .


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/21.png)

构建缓存：由于docker如果构建失败，下次构建的时候会利用缓存接着上次的过程构建。如果不想利用缓存，从头开始构建那么设置参数。

```shell
docker build --no-cache -t="harbourside/dockertest" .
```

也可以用ENV变量来设置缓存。例如：
```shell
#Version:0.01
FROM centos
MAINTAINER bigdata 79021218@qq.com
ENV REFRESHED_AT 2017-11-28
RUN yum -y install wget
RUN wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -ivh epel-release-6-8.noarch.rpm
RUN rpm -Va --nofiles --nodigest
RUN  yum install -y nginx --skip-broken
EXPOSE 80
```

这个ENV里面的 REFRESHED_AT变量用来表明镜像模板的最后更新时间。如果想重新构建，值需要更改REFRESHED_AT的值，再重新build就可以。

```shell
[root@dst6 dockerfile]# docker history 7b2ba77fb644  查看镜像的构建过程
```

为了方便演示，直接从docker hub下载tomcat的镜像：
```shell
docker pull tomcat:7.0

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/22.png)
```

后台运行启动tomcat：
```shell
[root@dst6 ~]# docker run -d -p 8080 --name tomcatstart tomcat:7.0
```

查看启动容器：
```shell
[root@dst6 ~]# docker ps 
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                     NAMES
8a615d73bcc9        tomcat:7.0          "catalina.sh run"   5 seconds ago       Up 4 seconds        0.0.0.0:32781->8080/tcp   tomcatstart   
```

这里使用了-p标志，该标志用来控制Docker在运行时应该公开哪些网络端口给外部。运行一个容器时，Docker可以通过两种方式来在宿主机上分配端口。

* 1、Docker可以在宿主机上随机选择一个比较大的端口号来映射到容器的8080端口。
* 2、可以在Docker宿主机中指定一个具体的端口号来映射到容器中的8080端口上。

* 可以用docker port 容器id 端口号     查看容器端口的映射情况
* 也可以指定宿主机端口进行映射，将8080端口映射到宿主机的80端口上。
```shell
docker run -d -p 80:8080 --name tomcatstart tomcat:7.0   
```
进入容器查看
```shell
[root@dst6 ~]# docker exec -i -t 474e2570f557 /bin/sh
```

