# jenkins插件安装与项目拉取、编译、发布

系统管理-插件管理

* git plugin
* publish Over SSH 发布插件

## 配置git、创建项目、发布项目

### 创建项目
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jenkins/22.png)

选择构建一个自由分格的项目

### 配置git
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jenkins/23.png)

* 其中 帐号来源：
* 1.在jenkins 服务器上生成ssh
* 2.gitlab 中新建jenkins 帐号 并将 ssh 中的 公钥上传
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jenkins/24.png)
* 3.配置jenkins 私钥

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jenkins/25.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jenkins/26.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jenkins/27.png)

### 配置maven构建
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jenkins/28.png)

### 构建后 推送代码
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jenkins/29.png)

其中 ssh地址配置：系统管理-系统设置
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jenkins/30.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jenkins/31.png)

* 其中源路径是相对应当前项目路径。
* 目录路径是配置的ssh中的路径+remote path

## 权限配置

* 1、安装插件： Role-based Authorization Strategy
* 2、打开权限： 系统配置-全局安全配置：授权策略：Role-Based Strategy
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jenkins/32.png)
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jenkins/33.png)
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jenkins/34.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jenkins/35.png)

* 全局角色、项目角色

### 分配角色

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jenkins/36.png)

### 新建用户
系统管理-管理用户

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jenkins/37.png)