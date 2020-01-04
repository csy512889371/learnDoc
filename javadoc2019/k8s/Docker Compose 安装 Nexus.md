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

# 登录控制台验证安装

地址：`http://ip:port/`用户名：`admin`密码：`admin123`

# 在项目中使用 Maven 私服

## 配置认证信息

在 `Maven settings.xml`中添加 Nexus 认证信息(`servers`节点下)：

```
<server>
  <id>nexus-releases</id>
  <username>admin</username>
  <password>admin123</password>
</server>

<server>
  <id>nexus-snapshots</id>
  <username>admin</username>
  <password>admin123</password>
</server>
```

## 配置自动化部署

在 `pom.xml`中添加如下代码：

```
<distributionManagement>  
  <repository>  
    <id>nexus-releases</id>  
    <name>Nexus Release Repository</name>  
    <url>http://127.0.0.1:8081/repository/maven-releases/</url>  
  </repository>  
  <snapshotRepository>  
    <id>nexus-snapshots</id>  
    <name>Nexus Snapshot Repository</name>  
    <url>http://127.0.0.1:8081/repository/maven-snapshots/</url>  
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
        <url>http://127.0.0.1:8081/repository/maven-public/</url>
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
        <url>http://127.0.0.1:8081/repository/maven-public/</url>
        <snapshots>
            <enabled>true</enabled>
        </snapshots>
        <releases>
            <enabled>true</enabled>
        </releases>
    </pluginRepository>
</pluginRepositories>
```