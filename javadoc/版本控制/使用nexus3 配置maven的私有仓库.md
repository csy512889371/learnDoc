# 使用nexus3 配置maven的私有仓库


# 一、安装配置Nexus

1) 下载nexus
* https://www.sonatype.com/download-oss-sonatype
2) 解压：tar-zxfnexus-3.5.2-unix.tar.gz
3) 进入bin目录启动 ./nexus run &
* 出现如下界面启动成功

```shell

 Started Sonatype Nexus OSS 3.5.2.01


```

4) 访问http://ip:8081 可以登录

>* 默认端口号：8081
>* 默认帐号：admin
>* 默认密码：admin123

5) 配置修改

* 修改允许nexus3使用的用户
```shell
#vi nexus.rc

run_as_user="root"

```
* 修改nexus3启动所使用的jdk版本
```shell
#vi nexus
INSTALL4J_JAVA_HOME_OVERRIDE=/data/program/software/java8
```
* 修改nexus3 默认端口
```shell
#vi nexus-default.properties
application-port=8082
```

* 修改nexus3数据以及相关日志的存储位置
```shell
#vi nexus.vmoptions
-XX:LogFile=./sonatype-work/nexus3/log/jvm.log/jvm
-Dkaraf.data=./sonatype-work/nexus3
-Djava.io.tempdir=./sonatype-work/nexus3/tmp
```

# 二、修改setting.xml配置 使用nexus私有库

```xml
	<mirror>
		<id>nexus</id>
		<name>{name}</name>
		<url>http://{host}:{port}/repository/maven-public/</url>
		<mirrorOf>central</mirrorOf>
	</mirror>


	
	 <!-- 发布的服务器和密码，暂时未限制权限 -->
   <servers>
    <server>
    <id>nexus</id>
    <username>admin</username>
    <password>admin123</password>
	</server>
  </servers>

   <profile>
         <id>Nexus152</id>
         <activation>
             <jdk>1.8</jdk>
         </activation>
         <repositories>
            <repository>
                <id>public</id>
                <url>http://xxx:8081/repository/maven-public/</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
             </repository>
         </repositories>

         <pluginRepositories>
             <pluginRepository>
                    <id>central</id>
                    <url>http://xxx:8081/repository/maven-central/</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>false</enabled>
                    </snapshots>
             </pluginRepository>
         </pluginRepositories>
    </profile>
```

# 三、配置与说明

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/maven/1.png)


1) 创建一个仓库（Create Repositories）

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/maven/2.png)
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/maven/3.png)

2) 发布maven项目

在pom文件中的project节点中的最后添加

```xml
<distributionManagement>
    <repository>
        <id>{server ID}</id>   <!--setting.xml中server的id-->
        <name>{repository name}</name> <!--Nexus中repository的名字-->
        <url>{repository URL}</url>  <!--Nexus中repository的URL-->
    </repository>
</distributionManagement>


```
执行Maven命令

```shell
mvn deploy -DskipTests
```
3) 发布独立jar包
```shell
mvn deploy:deploy-file -DgroupId={group} -DartifactId={artifact} -Dversion={vsersion} -Dpackaging=jar -Dfile={jar path} -Durl=http://{host}:{port}/repository/{repository name}/ -DrepositoryId={server id}

```
参数说明：
* group、artifact、vsersion对应Maven中的三个坐标参数
* jar path为你要发布的jar的绝对路径
* host、port为你私仓的主机地址和端口
* repository name为你要发布到的repository的URL（可在nexus中copy）
* server id对应了在maven中配置的server的ID（如果server所对应的角色权限不足，则会发布失败）


