# docker入门

## 一、	确保docker就绪
查看docker程序是否存在，功能是否正常

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/11.png)

Docker可执行程序的info命令，该命令会返回所有容器和镜像的数量、Docker使用的执行驱动和存储驱动以及Docker的基本配置。

## 二、	构建第一个容器
启动容器，用docker run命令创建容器

```shell
docker run -i -t centos /bin/bash
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/12.png)

* 命令解释：告诉docker执行docker run命令，并指定了-i和-t两个命令行参数，-i: 以交互模式运行容器，通常与 -t 同时使用；-t: 为容器重新分配一个伪输入终端，通常与 -i 同时使用；
* 命令中用的是centos镜像，首先docker会检查本地是否存在centos镜像，如果本地还没有该镜像的话，那么docker就会连接官方维护的Docker Hub Registry，查看Docker Hub中是否有该镜像。
* Docker一旦找到该镜像，就会下载该镜像并将其保存到本地宿主机。
* 之后，Docker在文件系统内部用这个镜像创建一个新容器。该容器拥有自己的网络、IP地址。以及一个用来和宿主机进行通信的桥接网络接口。最后，告诉Docker在新容器中要运行什么命令，本例中运行/bin/bash命令启动了一个Bash shell。
* 当容器创建完毕后，Docker就会执行容器中的/bin/bash命令，这时就会看到容器内的shell。[root@4f6fdd17f86f /]#

## 三、	容器使用

### 1、容器ID

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/13.png)

可以看到hostname就是容器的ID
查看cat /etc/hosts

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/14.png)


Docker已在Hosts文件为该容器的IP地址添加了一条主机配置项。

### 2、	容器中安装软件

容器中安装vim软件，可以在容器中做任何想做的事情，退出的时候输入exit，就可以返回到centos宿主机的命令行提示符。

```shell
[root@4f6fdd17f86f /]# yum install vim
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/15.png)

### 3、	退出容器

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/16.png)

用docker ps –a查看当前系统中容器的列表

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/17.png)

* 默认情况下docker ps只能看到正在运行的容器，但是加上-a会列出所有的容器，包括正在运行的和已经停止的。
* docker ps –l  会列出最后一次运行的容器，包括正在运行的和已经停止的。
* 从该命令的输出结果中我们可以看到容器的很多有用信息：ID、用于创建该容器的镜像、容器最后执行的命令、创建时间以及容器的退出状态（上面退出状态为0，因为容器是通过正常的exit命令退出）
