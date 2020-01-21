# 基于 Docker 安装 Nexus

我们使用 Docker 来安装和运行 Nexus，docker-compose.yml 配置如下：

```
version: '3.1'
services:
  nexus:
    restart: always
    image: sonatype/nexus3
    container_name: nexus
    ports:
      - 8082:8081
    volumes:
      - /usr/local/docker/nexus/data:/nexus-data
```

注： 启动时如果出现权限问题可以使用：`chmod 777 /usr/local/docker/nexus/data`赋予数据卷目录可读可写的权限

注：默认挂在卷位置

```
/var/lib/docker/volumes/mmmmm
```



# 登录控制台验证安装

地址：`http://ip:port/`用户名：`admin`密码：`admin123`

# 在项目中使用 Maven 私服

## 配置认证信息

在 `Maven settings.xml`中添加 Nexus 认证信息(`servers`节点下)：

```
<server>
  <id>nexus-releases</id>
  <username>admin</username>
  <password>adminloit</password>
</server>

<server>
  <id>nexus-snapshots</id>
  <username>admin</username>
  <password>adminloit</password>
</server>
```

## 配置自动化部署

在 `pom.xml`中添加如下代码：

```
<distributionManagement>  
  <repository>  
    <id>nexus-releases</id>  
    <name>Nexus Release Repository</name>  
    <url>http://192.168.66.40:8082/repository/maven-releases/</url>  
  </repository>  
  <snapshotRepository>  
    <id>nexus-snapshots</id>  
    <name>Nexus Snapshot Repository</name>  
    <url>http://192.168.66.40:8082/repository/maven-snapshots/</url>  
  </snapshotRepository>  
</distributionManagement> 
```

注意事项：

- ID 名称必须要与 settings.xml 中 Servers 配置的 ID 名称保持一致。
- 项目版本号中有 SNAPSHOT 标识的，会发布到 Nexus Snapshots Repository, 否则发布到 Nexus Release Repository，并根据 ID 去匹配授权账号。

## 配置代理仓库

```
<repositories>
    <repository>
        <id>nexus</id>
        <name>Nexus Repository</name>
        <url>http://192.168.66.40:8082/repository/maven-public/</url>
        <snapshots>
            <enabled>true</enabled>
        </snapshots>
        <releases>
            <enabled>true</enabled>
        </releases>
    </repository>
</repositories>
<pluginRepositories>
    <pluginRepository>
        <id>nexus</id>
        <name>Nexus Plugin Repository</name>
        <url>http://192.168.66.40:8082/repository/maven-public/</url>
        <snapshots>
            <enabled>true</enabled>
        </snapshots>
        <releases>
            <enabled>true</enabled>
        </releases>
    </pluginRepository>
</pluginRepositories>
```



## repository

```
http://maven.aliyun.com/nexus/content/groups/public/
https://repo.spring.io/libs-milestone-local
https://repo.spring.io/libs-snapshot-local

maven-releases 设置成 maven-releases
https://repo.spring.io/milestone
https://repo.spring.io/release
https://repo.spring.io/snapshot
http://unidal.org/nexus/content/repositories/releases/


```



nexus 3 Anonymous 用户权限。勾选上 Allow anonymous users to access the server

推荐设置查看账号 https://blog.csdn.net/zhuwei_clark/article/details/90522174



## idea maven设置 勾选 Always update snapshots



配置deployment角色

很简单，只需要配置如下5个权限即可！

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020011915553356.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI3Mzg0NzY5,size_16,color_FFFFFF,t_70)