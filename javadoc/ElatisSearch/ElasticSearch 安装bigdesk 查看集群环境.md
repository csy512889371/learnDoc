# ElasticSearch 安装bigdesk 查看集群环境


## 安装bigdesk

大致的步骤为


```

git clone https://github.com/hlstudio/bigdesk
cd bigdesk/_site/


python.exe  -m http.server
```

其实就是 
* 下载源码 
* 进入_site文件夹 
* 启动一个web server。

http://192.168.1.1:8000 

* 如果你的目录下有一个叫 index.html 的文件名的文件，那么这个文件就会成为一个默认页，如果没有这个文件，那么，目录列表就会显示出来。
* 这里需要强调一点，只要是在一个网段里，bigdesk是自动识别，会自动把其加入进来。head插件也是一样的

## 其他插件

Marvel插件