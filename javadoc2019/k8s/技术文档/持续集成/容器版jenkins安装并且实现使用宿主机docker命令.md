```
docker版jekins使用宿主机docker命令

docker版jekins安装，实现CI/CD，也就是实现在容器里面使用宿主机docker命令，这样方式为：docker outside deocker

说明：FROM jenkinsci/jenkins  这个jenkins基础镜像用的系统是debain系统

必须按照下面过程来，否则报错


说明: 官方jenkins镜像本身自带jdk

环境：

192.168.0.97  centos7.5


1、安装docker

参照：https://www.cnblogs.com/effortsing/p/10013567.html


配置docker加速

参照：https://i.cnblogs.com/EditPosts.aspx?postid=10060610


拉取jenkins官方镜像：
docker pull jenkinsci/jenkins

或者：

下载原始镜像

链接：https://pan.baidu.com/s/14z5BnFAXYoMnDoXbiNgmuQ 
提取码：ecsq


导入镜像

docker load < jenkinsci.tar/2、/2、/2查看镜像
[root@bogon ~]# docker images
REPOSITORY                            TAG                 IMAGE ID            CREATED             SIZE
jenkinsci/jenkins                     latest              b589aefe29ff        3 months ago        703 MB


2、添加maven


方式一：（做成了，启动容器后可以看到mvn版本,但是版本低，不能选择版本）


cat>/home/jenkins-dockerfile/Dockerfile <<EOF
FROM jenkinsci/jenkins
USER root
RUN apt-get update && apt-get install -y libltdl7.*

RUN apt-git install vim -y
RUN apt-get install maven -y

RUN apt-get install git -y
ARG dockerGid=999
RUN echo "docker:x:${dockerGid}:jenkins" >> /etc/group
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
EOF


上面dockerfile所做的事情如下：

安装libltdl7.*库、添加jenkins用户到docker组里面来实现使用宿主机的docker，安装maven工具，安装git工具


注意：如果制作好镜像后拉取代码报错没有git工具的时候， 上面的dockerfile中就应该安装git工具： RUN apt-get install git -y


方式二：（没做成，启动容器后看不到mvn版本，但是看网上都是这样做的）

准备maven安装包

rz apache-maven-3.5.4-bin.tar.gz
mkdir -p /home/jenkins-dockerfile/
mv apache-maven-3.5.4-bin.tar.gz /home/jenkins-dockerfile/


编写dockerfile

cat>/home/jenkins-dockerfile/Dockerfile <<EOF
FROM jenkinsci/jenkins
USER root
RUN apt-get update && apt-get install -y libltdl7.*
RUN apt-get install vim* -y
ADD apache-maven-3.5.4-bin.tar.gz /usr/local/
ENV MAVEN_HOME=/usr/local/apache-maven-3.5.4
ENV PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH
ARG dockerGid=999
RUN echo "docker:x:${dockerGid}:jenkins" >> /etc/group
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
EOF


上面构建完启动容器后没有mvn版本，按照下面构建完启动容器也是没有mvn版本，但是进入容器后加载下环境变量就会出现mvn版本，

各种尝试进行写dockerfile添加mvn，都是不行的，不要再试了，浪费时间，期待官方jenkins镜像带mvn


cat>/home/jenkins-dockerfile/Dockerfile <<EOF
FROM jenkinsci/jenkins
USER root
RUN apt-get update && apt-get install -y libltdl7.*
RUN apt-get install vim* -y

ADD apache-maven-3.5.4-bin.tar.gz /usr/local/

ARG dockerGid=999
RUN echo "docker:x:${dockerGid}:jenkins" >> /etc/group
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

RUN echo "# set jdk、jre" >> /etc/profile
RUN echo "export JAVA_HOME=/docker-java-home/" >> /etc/profile
RUN echo "export JRE_HOME=/docker-java-home/" >> /etc/profile
RUN echo "export CLASSPATH=.:/docker-java-home/jre/lib/rt.jar:/docker-java-home/lib/dt.jar:/docker-java-home/lib/tools.jar" >> /etc/profile
RUN echo "export PATH=$PATH:/docker-java-home/bin" >> /etc/profile
RUN /bin/bash -c "source /etc/profile"
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN source /etc/profile

RUN echo "#set maven environment" >> /etc/profile
RUN echo "export MAVEN_HOME=/usr/local/apache-maven-3.5.4/" >> /etc/profile
RUN echo "export PATH=/usr/local/apache-maven-3.5.4/bin:/docker-java-home/jre/bin:/usr/local/apache-maven-3.5.4/bin:$PATH" >> /etc/profile
RUN /bin/bash -c "source /etc/profile"
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN source /etc/profile
EOF




注意：上面Dockerfile中必须先执行apt-get update && apt-get install -y libltdl7.*，再安装maven，添加环境变量，否则会报如下错误：

debconf: delaying package configuration, since apt-utils is not installed
dpkg: warning: 'ldconfig' not found in PATH or not executable
dpkg: warning: 'start-stop-daemon' not found in PATH or not executable
E: Sub-process /usr/bin/dpkg returned an error code (2)
The command '/bin/sh -c apt-get update && apt-get install -y libltdl7.*' returned a non-zero code: 100


说明：

libltdl7.*： 如果没有安装这个库，进入容器内部执行docker命令会报错找不到这个库

dockerGid=999  必须步骤

echo "docker:x:${dockerGid}:jenkins" >> /etc/group   必须步骤



3、构建镜像

docker build -t jenkinsci/jenkins:v1 /home/jenkins-dockerfile/


查看镜像

[root@bogon ~]# docker images
REPOSITORY                            TAG                 IMAGE ID            CREATED             SIZE
jenkinsci/jenkins                     v1                  7b9560d56c4e        23 seconds ago      720 MB
jenkinsci/jenkins                     latest              b589aefe29ff        3 months ago        703 MB


4、启动容器

docker run -d -p 8085:8080 --name jenkins --restart=always \
-v /opt:/opt \
-v $(which docker):/usr/bin/docker \
-v /var/run/docker.sock:/var/run/docker.sock  jenkinsci/jenkins:v1


说明：
/var/run/docker.sock 的作用就是让 Jenkins 能通过主机的 Docker 守护进程（也就是 Docker Engine）来操作 docker 容器；

-v $(which docker):/usr/bin/docker ：这个是将外部的docker 挂载到 jenkins 容器内部，以便其能使用 docker 命令；

-v /opt/opt 是数据卷的挂载



浏览器访问jenkins

http://192.168.0.97:8085

注意：不要使用http://192.168.0.97:8085/jenkins 这样访问输入密码后就会报错，这是个bug



获取密码的指令

docker exec jenkins 'cat /var/jenkins_home/secrets/initialAdminPassword'



进入容器内部测试使用docker命令：

[root@bogon ~]# docker ps -l
CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS              PORTS                               NAMES
5d7efb64b114        jenkinsci/jenkins:v1   "/sbin/tini -- /us..."   49 seconds ago      Up 49 seconds       50000/tcp, 0.0.0.0:8085->8080/tcp   jenkins
[root@bogon ~]# 
[root@bogon ~]# docker exec -it 5d7efb64b114 sh
# docker ps -l
CONTAINER ID        IMAGE                  COMMAND                  CREATED              STATUS              PORTS                               NAMES
5d7efb64b114        jenkinsci/jenkins:v1   "/sbin/tini -- /us..."   About a minute ago   Up About a minute   50000/tcp, 0.0.0.0:8085->8080/tcp   jenkins
# 


5、解决出现：^H^H^H^H

把stty erase ^H 添加到.bash_profile中

vim /etc/profile
stty erase ^H

su root

source /etc/profile

或者进入容器后直接切换为root即可解决


6、查看jdk版本

docker exec jenkins 'java -version'


7、查看maven版本

docker exec jenkins 'mvn -v'

8、添加git工具

进入jenkins界面的全局工具配置里面选择自动安装git工具


9、配置jenkins全局工具

添加jdk路径（进入容器里查看jdk家目录） 查看家目录参照： https://www.cnblogs.com/effortsing/p/10012211.html

这里通过mvn -v 查看得到的是： /usr/lib/jvm/java-8-openjdk-amd64/

添加maven路径（进入容器查看mvn家目录） 用 find / -name mvn  查找，查找结果：  /usr/share/maven/bin/mvn   家目录就是/usr/share/maven

10、配置jenkins全局工具：添加settings.xml, 如下图所示：

Maven Configuration -> Settings file in filesystem -> File Path  /usr/share/maven/conf/settings.xml



11、安装Pipeline Maven Integration 插件


参照：

https://www.cnblogs.com/fengjian2016/p/9970778.html

https://segmentfault.com/q/1010000012232299

https://huanqiang.wang/2018/03/30/Jenkins-Gitlab-Kubernetes-%E7%9A%84%E8%87%AA%E5%8A%A8%E5%8C%96%E6%8C%81%E7%BB%AD%E9%9B%86%E6%88%90%E4%B8%8E%E9%83%A8%E7%BD%B2/


linux出现：^H^H^H^H参照：

https://blog.csdn.net/u013907239/article/details/74898123
 
```