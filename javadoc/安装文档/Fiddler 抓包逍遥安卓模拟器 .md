# Fiddler 抓包逍遥安卓模拟器 

## 一、介绍

Fiddler是一款非常流行并且实用的http抓包工具，它的原理是在本机开启了一个http的代理服务器，然后它会转发所有的http请求和响应，因此，它比一般的firebug或者是chrome自带的抓包工具要好用的多。不仅如此，它还可以支持请求重放等一些高级功能。显然它是可以支持对手机应用进行http抓包的.

## 二、iddler链接到逍遥安卓模拟器。

1、 启动Fiddler，打开菜单栏中的 工具 >Fiddler选项 ，打开“Fiddler选项”对话框

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mn/1.png)


2、在Fiddler选项”对话框切换到“回话”选项卡，然后勾选“允许远程计算机连接”后面的复选框，然后点击“确定”按钮。

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mn/2.jpg)

（注：记住端口，下边会用到）



3、在本机命令行输入：ipconfig，找到本机的ip地址。

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mn/3.jpg)

4、打开android设备的“设置”->“WLAN”，找到你要连接的网络

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mn/4.jpg)


在上面长按，然后选择“修改网络”

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mn/5.jpg)


弹出网络设置对话框，然勾选“显示高级选项”


如下图


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mn/6.jpg)


5、在“代理”后面的输入框选择“手动”


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mn/7.jpg)


在“代理服务器主机名”后面的输入框输入电脑的ip地址

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mn/8.jpg)


在“代理服务器端口”后面的输入框输入8888，然后点击“保存”按钮。

（注：8888，,就是上边的端口）


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mn/9.jpg)



6、重启fd，然后启动android设备中的浏览器，访问百度的首页，在fiddler中可以看到完成的请求和响应数据

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mn/10.jpg)


## 三、设置https

设置 fiddler的https

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mn/9.png)


在模拟器中的浏览器中输入电脑的ip地址http://ip:8888

并下载安装证书

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/mn/10.png)


