#### 一、安装jenkins



```
cd /usr/local/loit/soft/docker/jenkins

vi docker-compose.yml
```



```
version: '3.1'
services:
  jenkins:
    restart: always
    image: jenkins/jenkins:centos
    container_name: jenkins
    ports:
      # 发布端口
      - 12012:8080
      # 基于 JNLP 的 Jenkins 代理通过 TCP 端口 50000 与 Jenkins master 进行通信
      #- 50000:50000
    environment:
      - "TZ=Asia/Shanghai"
      - "PATH=$PATH:$HOME/bin:/var/local/apache-maven-3.6.3/bin"
    #volumes:
      #- ./data:/var/jenkins_home
      #- /var/run/docker.sock:/var/run/docker.sock
      #- /usr/bin/docker:/usr/bin/docker

```



启动 jenkins 

```
docker-compose up -d
```



##### 安装maven



```
wget http://mirror.bit.edu.cn/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz

docker cp apache-maven-3.6.3-bin.tar.gz jenkins:/root/

docker exec -u root -it jenkins bash

cd /root/

tar -zxvf apache-maven-3.6.3-bin.tar.gz

mv apache-maven-3.6.3 /var/local/

vi .bash_profile
```



增加如下

```
PATH=$PATH:$HOME/bin:/var/local/apache-maven-3.6.3/bin
```



```
source .bash_profile

mvn -version

exit
```



##### 将安装了maven的docker 容器保存为新镜像



```
docker ps

docker commit c4b4e129db76 jenkins/jenkins:centos.v1
```



##### 修改docker-compose



* 修改镜像
* 修改挂载点

```
version: '3.1'
services:
  jenkins:
    restart: always
    image: jenkins/jenkins:centos.v1
    container_name: jenkins
    ports:
      # 发布端口
      - 12012:8080
      # 基于 JNLP 的 Jenkins 代理通过 TCP 端口 50000 与 Jenkins master 进行通信
      #- 50000:50000
    environment:
      - "TZ=Asia/Shanghai"
      - "PATH=$PATH:$HOME/bin:/var/local/apache-maven-3.6.3/bin"
    volumes:
      - ./data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/bin/docker:/usr/bin/docker
```



授权

```
chmod 777 /usr/local/loit/soft/docker/jenkins/data
chmod 777 /var/run/docker.sock
chmod 777 /usr/bin/docker
```



删除之前的容器

```
docker-compose down
```



重启 

```
docker-compose up -d

```



##### 配置jenkins

http://39.100.254.140:12012/

![image-20200203103031932](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203103031932.png)



获取初始密码

```
cat /usr/local/loit/soft/docker/jenkins/data/secrets/initialAdminPassword
```

![image-20200203103243607](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203103243607.png)



![image-20200203103312489](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203103312489.png)



勾选上"Publish Over SSH"



![image-20200203103435955](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203103435955.png)

* 安装插件耐心等待，看网速，慢的话要好几个小时

* 安装完成后设置管理员账号并登陆



![image-20200203151704583](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203151704583.png)

#### 二、设置jdk、maven



![image-20200203151924100](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203151924100.png)

![image-20200203152253173](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203152253173.png)





![image-20200203152421019](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203152421019.png)





![image-20200203152514631](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203152514631.png)



![image-20200203152547042](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203152547042.png)



#### 三、设置 Publish over SSH



![image-20200203152833229](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203152833229.png)

![image-20200203152727799](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203152727799.png)



#### 四、新建构建

![image-20200203153032856](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203153032856.png)



![image-20200203153104672](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203153104672.png)







![image-20200203155816858](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203155816858.png)



![image-20200203155839300](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203155839300.png)





![image-20200203155921805](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203155921805.png)



![image-20200203160335314](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203160335314.png)



![image-20200203161049604](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203161049604.png)

#### 五、新建视图



![image-20200203162720916](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203162720916.png)



http://39.100.254.140:12012/newView



#### 六、新建job



###### 普通svn 项目

![image-20200204093747345](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200204093747345.png)



![image-20200204093824787](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200204093824787.png)



![image-20200204093857962](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200204093857962.png)



![image-20200204093921138](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200204093921138.png)



###### 编排构建multijob

![image-20200204094039834](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200204094039834.png)



![image-20200204094425060](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200204094425060.png)





#### 七、脚本修改



jenkins只识别全路径

![image-20200203224648555](F:\3GitHub\learnDoc\javadoc2019\k8s\技术文档\持续集成\loit Jenkins 安装.assets\image-20200203224648555.png)



修改其权限

```
chmod 777 deploy-file-6001.sh
```

