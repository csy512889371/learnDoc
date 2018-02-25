# 生成环境配置
>* nginx 安装
>* build 。 将build的antd文件上传到nginx对应的目录下
>* 安装docker
>* 安装percona mysql
>* 安装redis
>* 安装tomcat
>* end

# 一、安装 nginx

http://www.linuxidc.com/Linux/2016-09/134907.htm

```shell
yum install gcc-c++

yum install -y pcre pcre-devel

yum install -y zlib zlib-devel
yum install -y openssl openssl-devel

wget -c https://nginx.org/download/nginx-1.12.2.tar.gz

tar -zxvf nginx-1.12.2.tar.gz

1.使用默认配置

cd nginx-1.12.2/
./configure
编译安装

make
make install

查找安装路径：

whereis nginx


启动、停止nginx

cd /usr/local/nginx/sbin/
./nginx  启动
./nginx -s stop  停止
./nginx -s quit 强制退出
./nginx -s reload 重新加载

```

## 运行 antd 项目 run build

>* 将生成的build 文件拷贝到 /var/www/blogArt/
>* 修改权限 

```shell
mkdir /var/www
mkdir /var/www/blogArt/

chmod 777 /var/www/blogArt/
```

## 修改nginx配置文件 nginx.conf
cd /usr/local/nginx/conf
```shell

worker_processes  1;
events {
    worker_connections  1024;
}

http {
	fastcgi_buffer_size 128k;
    fastcgi_buffers 4 256k;
    fastcgi_busy_buffers_size 256k;
    fastcgi_temp_file_write_size 256k;

    gzip on;
    gzip_min_length  1k;
    gzip_buffers     4 16k;
    gzip_http_version 1.0;
    gzip_comp_level 2;
    gzip_types       text/plain application/x-javascript text/css application/xml;
    gzip_vary on;

    server {
        listen 80;
        # server_name your.domain.com;

        root /var/www/blogArt/build;
        index index.html index.htm;

        location / {
                try_files $uri $uri/ /index.html;
        }


        error_page 500 502 503 504 /500.html;
        client_max_body_size 20M;
        keepalive_timeout 10;
	}

}

```
# 安装docker

## 配置 Docker CE

卸载旧版本

```shell
$ sudo yum remove docker \
                  docker-common \
                  docker-selinux \
                  docker-engine

```

> 执行以下命令安装依赖包：

```shell
$ sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```
> 国内源

```shell
$ sudo yum-config-manager \
    --add-repo \
    https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

```

> 如果需要最新版本的 Docker CE 请使用以下命令：

```shell
$ sudo yum-config-manager --enable docker-ce-edge
$ sudo yum-config-manager --enable docker-ce-test

```
> 安装 Docker CE

```shell
> 更新 yum 软件源缓存，并安装 docker-ce。

$ sudo yum makecache fast
$ sudo yum install docker-ce

```

> 使用脚本自动安装

```shell
$ curl -fsSL get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh --mirror Aliyun
执行这个命令后，脚本就会自动的将一切准备工作做好，并且把 Docker CE 的 edge 版本安装在系统中。

```
> 启动 Docker CE

```shell
$ sudo systemctl enable docker
$ sudo systemctl start docker

```



## 镜像加速

>* 配置后体验飞一般的感觉

```shell
对于使用 systemd 的系统，用 systemctl enable docker 启用服务后，编辑 /etc/systemd/system/multi-user.target.wants/docker.service 文件，找到 ExecStart= 这一行，在这行最后添加加速器地址 --registry-mirror=<加速器地址>，如：

ExecStart=/usr/bin/dockerd --registry-mirror=https://jxus37ad.mirror.aliyuncs.com
```

重新加载配置并且重新启动。

```shell
$ sudo systemctl daemon-reload
$ sudo systemctl restart docker
```
## 常用命令

> 信息版本

```shell
# docker version
```
> 查看信息

```shell
# docker info
```

> 查看我们正在运行的容器
```shell
# docker ps -a
```

> 查看映射端口
```shell
docker port pmm-server
```

> 查看应用进程日志

```shell
docker logs -f pmm-server
```
> 查看应用进程

```shell
docker top pmm-server
```

> 重启
```shell
docker start pmm-server
```
> 停止

```shell
docker stop pmm-server
```
> 我们可以使用 docker rm 命令来删除不需要的容器

```shell
docker rm pmm-server
```
> 列出镜像列表

```shell
docker images

REPOSTITORY：表示镜像的仓库源
TAG：镜像的标签
IMAGE ID：镜像ID
CREATED：镜像创建时间
SIZE：镜像大小

```


> 查询出Pid
```shell
docker inspect --format "{{ .State.Pid}}" <container-id>

```
> 然后通过得到的Pid执行
```shell
nsenter --target 6537 --mount --uts --ipc --net --pid
```
> 输出日志

```shell
Docker logs –f container
```

> 进入具体的容器

```shell
Docker exec –it container /bin/bash
```

> 退出容器

```shell
exit
```

# 安装percona mysql 数据库

```shell
docker pull percona:5.7

查看自己最新pull的镜像可以使用
docker images

docker run -d -eMYSQL_ROOT_PASSWORD=“密码”-P percona:5.7
```

>* 注：-d 以daemon的方式在后台运行
>* -e 可以设置mysql的管理密码
>* -P 将容器内部的3306端口映射到宿主机的随机端口
>* -p ip:hostPort:containerPort |ip::containerPort | >* hostPort:containerPort | containerPort     指定宿主机的端口
-v /host:/container  可以指定容器使用的目录


# centos 下安装node js (生产环境可以不用安装！)

## 下载
[官网下载](https://nodejs.org/zh-cn/download/)

## 安装

```shell
cd /usr/local/src/
cp /root/node-v8.9.3-linux-x64.tar.xz .
$ xz -d ***.tar.xz
$ tar -xvf ***.tar
```

```shell
yum install gcc gcc-c++

重命名为node

mv node-v8.9.3-linux-x64 node
```

## 配置环境变量

>* vi /etc/profile
```shell
#set for nodejs  
export NODE_HOME=/usr/local/src/node 
export PATH=$NODE_HOME/bin:$PATH 
```

```shell
source /etc/profile
npm -v
node -v
```

>* 安装yarn: 
npm install -g yarn

>* 下载node_modules模块 
yarn install

>* 编译生成build目录： 
npm run build (发布) 

>* 开始运行： 
npm start 

## 安装cnpm
>* npm install -g cnpm --registry=https://registry.npm.taobao.org
>* cnpm install [name]


