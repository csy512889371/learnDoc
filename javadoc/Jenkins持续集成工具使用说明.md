# Jenkins持续集成工具使用说明

## 概要说明

> Jenkins 的作用及其特性

>* 持续、自动地构建/测试软件项目。
>* 监控一些定时执行的任务。
>* 易于安装-只要把jenkins.war部署到servlet容器，不需要数据库支持。
>* 易于配置-所有配置都是通过其提供的web界面实现。
>* 集成RSS/E-mail通过RSS发布构建结果或当构建完成时通过e-mail通知。
>* 生成JUnit/TestNG测试报告
>* 分布式构建支持Jenkins能够让多台计算机一起构建/测试
>* 文件识别:Jenkins能够跟踪哪次构建生成哪些jar，哪次构建使用哪个版本的jar等。
>* 插件支持:支持扩展插件，你可以开发适合自己团队使用的工具。


> 持续集成是个简单重复劳动，人来操作费时费力，使用自动化构建工具完成是最好不过的了。


## Jenkins介绍

### 首选你需要安装好JRE/JDK和Tomcat

```xml
Java_OPTS="-Xms512m -Xmx768m -XX:MaxNewSize=256m -XX:MaxPermSize=128m"
Bin/catalina.sh中添加。防止内存溢出。

<Connector port="9090" URIEncoding="UTF-8" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="9443" />

置UTF-8编码		   
			   
```

### 官网下载jenkins.war包

> 官网地址：http://Jenkins-ci.org/  </br>
> 官网镜像地址：http://mirrors.jenkins-ci.org/war-stable/  </br>
> （在里面可以选择任意版本的war包，lastest为最新的，推荐下载！） </br>
> https://wiki.jenkins-ci.org/display/JENKINS/Use+Jenkins安装配置手册


### tomcat部署
> 将war包在tomcat中进行部署

![image](https://github.com/csy512889371/learnDoc/blob/master/image/jeekins/jeekins1.png)
![image](https://github.com/csy512889371/learnDoc/blob/master/image/jeekins/jeekins2.png)

> 开始安装插件：
![image](https://github.com/csy512889371/learnDoc/blob/master/image/jeekins/jeekins3.png)

> 设置用户账号
![image](https://github.com/csy512889371/learnDoc/blob/master/image/jeekins/jeekins4.png)
![image](https://github.com/csy512889371/learnDoc/blob/master/image/jeekins/jeekins5.png)
![image](https://github.com/csy512889371/learnDoc/blob/master/image/jeekins/jeekins6.png)


## 系统设置
![image](https://github.com/csy512889371/learnDoc/blob/master/image/jeekins/jeekins7.png)

>* “系统消息”这一部分内容会显示在首页顶部，我们可以在里面直接写上HTML内容。里面可以写一些相关的质量管理系统或者项目管理系统的链接，也可以写一些通知或者公告了什么的。
>* “执行者”表示本机同时可以执行的构建数目，不过我们将这里设置为0，也就是不允许这台机器进行任何构建，以后所有构建我们都是通过不同的奴隶节点（slave node）来完成，因为对于非Java的项目，可能构建的系统和需要的开发环境千差万别，都在主节点（master node）上进行构建不但占用太多主节点资源，而且必须给各个项目的相关人员开放登录到主节点的权限，每个人都根据自己的喜好随便在主节点上安装、配置，可能导致极大的混乱和出现各种各样的问题。

## 邮件设置

>* “邮件通知”，填写相关的属性（可以跟IT部门的人申请一个专用的帐号），并且可以勾选“通过发送测试邮件测试配置”来测试一下。
>* 在已运行的Jenkins主页中，点击左侧的系统管理—>系统设置进入如下界面
>* 注：系统管理员邮件地址，填写与下面的邮件配置中用户名一致
![image](https://github.com/csy512889371/learnDoc/blob/master/image/jeekins/jeekins8.png)
![image](https://github.com/csy512889371/learnDoc/blob/master/image/jeekins/jeekins9.png)


> 其中qq客户端授权码获取：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/jeekins/jeekins10.png)
![image](https://github.com/csy512889371/learnDoc/blob/master/image/jeekins/jeekins11.png)
![image](https://github.com/csy512889371/learnDoc/blob/master/image/jeekins/jeekins12.png)

## 管理插件

>* 回到“系统管理”页面，点击“管理插件”，可以在这里对插件进行安装、卸载、升级、降级等操作。
>* 需要注意的是如果想安装自己写的插件，要在高级里面上传插件的 hpi 文件。
![image](https://github.com/csy512889371/learnDoc/blob/master/image/jeekins/jeekins13.png)


## 安装GIT

>* 在“可选插件”页签中，找到“Git Client Plugin”插件，勾选前面的复选框。
![image](https://github.com/csy512889371/learnDoc/blob/master/image/jeekins/jeekins14.png)
>* 再找到“Git Parameter Plugin”，勾选前面的复选框。
![image](https://github.com/csy512889371/learnDoc/blob/master/image/jeekins/jeekins15.png)
>* 然后点击屏幕最下面的“直接安装”按钮，此时开始自动下载安装插件，如果勾选了最后的“当安装成功并且没有运行中的任务时重启”，那么Jenkins会自动重启让插件生效。

>* 要注意的是，此时在首页左侧多出一个“Credentials”来管理证书（同时在进入“系统管理”页面也可以看到一个入口。这个插件是在安装“Git Client Plugin”时安装的被依赖插件。在之前的版本（1.3.0）还没有这个依赖，后面我们使用git签出代码时一起琢磨一下这个插件的用法。
![image](https://github.com/csy512889371/learnDoc/blob/master/image/jeekins/jeekins16.png)

## 节点管理（Master/slaver）待续

## 构建Maven分格的Job

## 用户登陆与权限设定



