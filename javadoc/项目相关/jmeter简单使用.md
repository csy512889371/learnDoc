# jmeter简单使用


## Jmeter的基本概念

### 百度百科：
Apache JMeter是Apache组织开发的基于Java的压力测试工具。用于对软件做压力测试，它最初被设计用于Web应用测试，但后来扩展到其他测试领域。 它可以用于测试静态和动态资源，例如静态文件、Java 小服务程序、CGI 脚本、Java 对象、数据库、FTP 服务器， 等等。JMeter 可以用于对服务器、网络或对象模拟巨大的负载，来自不同压力类别下测试它们的强度和分析整体性能。另外，JMeter能够对应用程序做功能/回归测试，通过创建带有断言的脚本来验证你的程序返回了你期望的结果。为了最大限度的灵活性，JMeter允许使用正则表达式创建断言

### 我们为什么使用Jmeter
开源免费，基于Java编写，可集成到其他系统可拓展各个功能插件
支持接口测试，压力测试等多种功能，支持录制回放，入门简单
相较于自己编写框架活其他开源工具，有较为完善的UI界面，便于接口调试
多平台支持，可在Linux，Windows，Mac上运行


# Jmeter安装配置
Windows下Jmeter下载安装

登录 http://jmeter.apache.org/download_jmeter.cgi ，根据自己平台，下载对应文件

安装JDK，配置环境变量（具体步骤不做介绍）
将下载Jmeter文件解压，打开/bin/jmeter.bat

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jmeter/1.png)


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jmeter/3.png)

## 配置中文

选项->选择语言->中文


## 线程组
Test Plan 点击右键 =>添加=>threads=>线程组

* 设置 线程数 1000 在10秒中启动 循环调用1次
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jmeter/2.png)


## 配置HTTP默认请求默认值

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/miaosha/4.png)

## 配置 http Header

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/miaosha/5.png)


## 配置http请求

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/miaosha/6.png)


## 添加聚合报告查询结果

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/miaosha/7.png)

其中 重要指标 
1.	Error% 错误率
2.	Throughput 每秒钟服务器的接口的处理能力


## 定义变量

CVS数据原件配置。可以定义变量

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jmeter/5.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jmeter/6.png)


## 命令行压测

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/jmeter/4.png)


