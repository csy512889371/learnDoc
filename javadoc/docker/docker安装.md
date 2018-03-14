# docker安装

## 一、	升级内核
1、	yum安装3.10内核
```shell
cd /etc/yum.repos.d 
wget http://www.hop5.in/yum/el6/hop5.repo
yum install kernel-ml-aufs kernel-ml-aufs-devel
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/3.png)

2、	修改grub配置文件
修改grub的主配置文件/etc/grub.conf，设置default=0，表示第一个title下的内容为默认启动的kernel（一般新安装的内核在第一个位置）。
```shell
vi /etc/grub.conf
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/4.png)

3、	重启系统，并检查内核

* 重启：shutdown –r now
* 检查内核：uname –r
* 检查内核是否支持aufs：grep aufs /proc/filesystems

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/5.png)

## 二、	安装Docker

### 1、	关闭selinux
```shell
setenforce 0
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/6.png)

```shell
sed -i '/^SELINUX=/c\SELINUX=disabled' /etc/selinux/config
```

2、	在Fedora EPEL源中已经提供了docker-io包，下载安装epel
```shell
rpm -ivh http://mirrors.sohu.com/fedora-epel/6/x86_64/epel-release-6-8.noarch.rpm
sed -i 's/^mirrorlist=https/mirrorlist=http/' /etc/yum.repos.d/epel.repo
```

3、	安装docker-io
```shell
yum -y install docker-io
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/7.png)

4、	启动docker
```shell
service docker start
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/8.png)

5、	查看docker版本
```shell
docker version
```
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/9.png)

6、	查看docker日志
```shell
cat /var/log/docker
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/docker/10.png)

