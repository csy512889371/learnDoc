# 什么是 Jenkins

![img](https://www.funtl.com/assets/jenkins_logo.png)

Jenkins 是一个开源软件项目，是基于 Java 开发的一种持续集成工具，用于监控持续重复的工作，旨在提供一个开放易用的软件平台，使软件的持续集成变成可能。

官方网站：https://jenkins.io/

# 基于 Docker 安装 Jenkins


## docker-compose

Jenkins 是一个简单易用的持续集成软件平台，我们依然采用 Docker 的方式部署，`docker-compose.yml` 配置文件如下：

```text
version: '3.1'
services:
  jenkins:
    restart: always
    image: jenkinsci/jenkins
    container_name: jenkins
    ports:
      # 发布端口
      - 8080:8080
      # 基于 JNLP 的 Jenkins 代理通过 TCP 端口 50000 与 Jenkins master 进行通信
      - 50000:50000
    environment:
      TZ: Asia/Shanghai
    volumes:
      - ./data:/var/jenkins_home
```

安装过程中会出现 `Docker 数据卷` 权限问题，用以下命令解决：

```text
chown -R 1000 /usr/local/docker/jenkins/data
```



## 解锁 Jenkins

Jenkins 第一次启动时需要输入一个初始密码用以解锁安装流程，使用 `docker logs jenkins` 即可方便的查看到初始密码

![img](https://www.funtl.com/assets/Lusifer_20181029010826.png)

![img](https://www.funtl.com/assets/Lusifer_20181029010853.png)

**注意：** 安装时可能会因为网速等原因导致安装时间比较长，请大家耐心等待。如果长时间停留在安装页没反应，请尝试使用 `F5` 刷新一下。

## 使用自定义插件的方式安装

插件是 Jenkins 的核心，其丰富的插件（截止到 `2018.10.29` 共有 `77350` 个插件）可以满足不同人群的不同需求

插件地址：https://plugins.jenkins.io/

![img](https://www.funtl.com/assets/Lusifer_20181029012228.png)

**注意：** 除了默认勾选的插件外，一定要勾选 `Publish over SSH` 插件，这是我们实现持续交付的重点插件。

![img](https://www.funtl.com/assets/Lusifer_20181029013023.png)

**开始安装了，根据网络情况，安装时间可能会比较长，请耐心等待**

![img](https://www.funtl.com/assets/Lusifer_20181029013257.png)

**很多插件装不上怎么办？不要慌，记住这些插件的名字，咱们稍后可以手动安装**

![img](https://www.funtl.com/assets/Lusifer_20181029013529.png)

## 安装成功效果图

- 创建管理员

![img](https://www.funtl.com/assets/Lusifer_20181029014606.png)

- 安装完成，进入首页

![img](https://www.funtl.com/assets/Lusifer_20181029014814.png)

## 附：Jenkins 手动安装插件

### 使用插件管理器安装

- `Manage Jenkins` -> `Manage Plugins` -> `Avaliable`

![img](https://www.funtl.com/assets/Lusifer_20181029015721.png)

- 过滤出想要安装的插件，然后点击 `Download now and install after restart`

![img](https://www.funtl.com/assets/Lusifer_20181029015918.png)

![img](https://www.funtl.com/assets/Lusifer_20181029020240.png)

### 手动上传 `.hpi` 文件

- 点击进入插件中心

![img](https://www.funtl.com/assets/Lusifer_20181029021411.png)

- 点击 `Archives`

![img](https://www.funtl.com/assets/Lusifer_20181029021906.png)

- 下载需要的版本

![img](https://www.funtl.com/assets/Lusifer_20181029022059.png)

- 在插件管理器中选择 `Advanced`

![img](https://www.funtl.com/assets/Lusifer_20181029022309.png)

- 选择上传即可

![img](https://www.funtl.com/assets/Lusifer_20181029022410.png)

### 重启 Jenkins

```text
docker-compose down
docker-compose up -d
```



**注意：** 请留意需要下载插件的警告信息，如果不满足安装条件，Jenkins 是会拒绝安装的。如下图：

![img](https://www.funtl.com/assets/Lusifer_20181029021640.png)