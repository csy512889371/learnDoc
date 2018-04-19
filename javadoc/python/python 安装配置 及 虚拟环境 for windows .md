# python 安装配置 for windows

## 一、概述
* 百度搜索 python for windows
* https://www.python.org/downloads/windows/

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/python/27.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/python/28.png)

## 二、下载并安装
* 安装2.7 最新的版本
* python 3 的安装版本选择 3.5.x


## 三、虚拟环境的安装和配置

* 隔离开发环境 

```
pip install virtualenv
```

国内镜象源
```
豆瓣镜像地址：https://pypi.douban.com/simple/
```

```
pip install -i http://pypi.douban.com/simple/ virtualenv
```



### 1.0 新建virtualenv

```
virtualenv scrapytest
```

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/python/29.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/python/30.png)

```
dir

cd  scrapytest

cd Scripts

activate.bat

```

以上命令后进入虚拟环境

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/python/31.png)


退出activate
```
ctrl + z

deactivate.bat
```

创建基于python2的虚拟环境

```
virtualenv -p D:\Python27\python.exe scrapytestpy2
```

## 四、虚拟环境管理包

进入python的安装目录

```
pip install virtualenvwrapper
```

如果是window则要安装

```
pip install virtualenvwrapper-win
```

```
workon

```

```
mkvirtualenv py3scrapy
```

默认安装路径

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/python/32.png)


环境变量中添加

WORKON_HOME  E:\python\Envs


进入和退出虚拟环境

```
workon py3scrapy

deactivate

mkvirtualenv -p D:\Python27\python.exe py2scrapy

mkvirtualenv --python=D:\Python27\python.exe py2scrapy
```


## 安装scrapy

```
pip install scrapy
```


## 如果windows安装过程报错

可以到https://www.lfd.uci.edu/~gohlke/pythonlibs/ 找到相应的版本

进入对于的虚拟环境 pip install 下载的包

查看依赖
```
pip list
```
