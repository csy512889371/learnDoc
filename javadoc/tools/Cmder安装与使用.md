# Cmder安装与使用


## 概述

cmder是windows下的命令行工具，用来替代windows自带的cmd。下载地址：http://cmder.net/ 。


解压到指定目录后，为了能让它在右键菜单中出现，要进行以下几步设置：

* 设置环境变量，CMDER_HOME=cmder.exe所在目录，并在path中增加%CMDER_HOME%。
* 运行cmder.exe，并执行Cmder.ext /REGISTER ALL。

要使用时，可以选择指定文件夹，右键->Cmder here，即打开了Cmder界面