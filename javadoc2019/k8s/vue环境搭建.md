## 一、安装node.js（https://nodejs.org/en/）

![img](https://images2018.cnblogs.com/blog/1329491/201802/1329491-20180228113840130-661730370.png)![img](https://images2018.cnblogs.com/blog/1329491/201802/1329491-20180228114224635-42035726.png)

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

下载完毕后，可以安装node，建议不要安装在系统盘（如C：）。

![img](https://images2018.cnblogs.com/blog/1329491/201802/1329491-20180228114712750-162195532.png)![img](https://images2018.cnblogs.com/blog/1329491/201802/1329491-20180228114718741-339208689.png)

 

**二、设置nodejs prefix（全局）和cache（缓存）路径**

1、在nodejs安装路径下，新建node_global和node_cache两个文件夹

![img](https://images2018.cnblogs.com/blog/1329491/201803/1329491-20180301100114046-393613181.png)

2、设置缓存文件夹

```
npm config set cache "E:\5vueProject\nodejs\node_cache"
```

　设置全局模块存放路径

```
npm config set prefix "E:\5vueProject\nodejs\node_global"
```

设置成功后，之后用命令npm install XXX -g安装以后模块就在D:\vueProject\nodejs\node_global里

 

**三、基于 Node.js 安装cnpm（淘宝镜像）**

```
npm install -g cnpm --registry=https://registry.npm.taobao.org
```

 

**四、设置环境变量（非常重要）**

说明：设置环境变量可以使得住任意目录下都可以使用cnpm、vue等命令，而不需要输入全路径

1、鼠标右键"此电脑"，选择“属性”菜单，在弹出的“系统”对话框中左侧选择“高级系统设置”，弹出“系统属性”对话框。

2、修改系统变量PATH

![img](https://images2018.cnblogs.com/blog/1329491/201803/1329491-20180301101804629-1054069840.png)

![img](https://images2018.cnblogs.com/blog/1329491/201803/1329491-20180301101828137-2115610170.png)

3、新增系统变量NODE_PATH

![img](https://images2018.cnblogs.com/blog/1329491/201803/1329491-20180301101926085-1579993277.png)

 

**五、安装Vue**

```
cnpm install vue -g
```

![img](https://images2018.cnblogs.com/blog/1329491/201803/1329491-20180301102234311-1895724706.png)

 

**六、安装vue命令行工具，即vue-cli 脚手架**

```
cnpm install vue-cli -g
```

![img](https://images2018.cnblogs.com/blog/1329491/201803/1329491-20180301102414833-1304504818.png)

 

 **七、新项目的创建**

1.打开存放新建项目的文件夹

打开开始菜单，输入 CMD，或使用快捷键 win+R，输入 CMD，敲回车，弹出命令提示符。打开你将要新建的项目目录

![img](https://images2018.cnblogs.com/blog/1329491/201803/1329491-20180301102918031-2133258852.png)

2.根据模版创建新项目

在当前目录下输入“vue init webpack-simple 项目名称（使用英文）”。

```
vue init webpack-simple mytest
```

![img](https://images2018.cnblogs.com/blog/1329491/201803/1329491-20180301103133353-1993247237.png)

初始化完成后的项目目录结构如下：

![img](https://images2018.cnblogs.com/blog/1329491/201803/1329491-20180301103251452-1261278308.png)

![img](https://images2018.cnblogs.com/blog/1329491/201803/1329491-20180301144548462-1357435.png)

3、安装工程依赖模块

定位到mytest的工程目录下，安装该工程依赖的模块，这些模块将被安装在：mytest\node_module目录下，node_module文件夹会被新建，而且根据package.json的配置下载该项目的modules

```
cd mytest
cnpm install
```

4、运行该项目，测试一下该项目是否能够正常工作，这种方式是用nodejs来启动。

```
cnpm run dev
```

![img](https://images2018.cnblogs.com/blog/1329491/201803/1329491-20180301103921442-1582928405.png)

![img](https://images2018.cnblogs.com/blog/1329491/201803/1329491-20180301103936380-459495893.png)

![img](https://images2018.cnblogs.com/blog/1329491/201803/1329491-20180301104027296-1087933713.png)

八、借鉴网址：



## 二、安装python



```
链接: https://pan.baidu.com/s/10vBVgIciITrEQw4tNONDtA
提取码: emcr
```



```
npm install -global -production windows-build-tools
```

# Microsoft.NET

```
 npm install --msvs_version 2015

 npm config set msvs_version 2015 --global  --这是全局配置，如果不想改变全局配置，可以在项目下执行：
npm config set msvs_version 2015
```

1.   visual studio
2. 　下载 [Visual C++ 2015 Build Tools](http://landinghub.visualstudio.com/visual-cpp-build-tools)，安装时，选择自定义安装，勾选系统版本对应的Windows SDKs ，直至安装完毕；
3. 　下载 Python2.7，安装时，勾选将 Add Python.exe to PATH，即添加至环境变量，直至安装完毕；
4.   在报错的项目内，重新执行 npm install --msvs_version 2015 进行安装项目依赖，即可完美解决问题了；





1. 删除 .node-gyp/ 
2. 执行 npm i -g node-gyp 
3. 删除 项目/node_modules 
4. 执行 npm i -d 



```
npm install -global -production windows-build-tools
管理员身份运行cmd
```

安装使用微软的所有必要的工具和配置[Windows的构建工具](https://github.com/felixrieseberg/windows-build-tools)使用`npm install --global --production windows-build-tools`从提升的PowerShell或cmd.exe，（以管理员身份运行）。

手动安装工具和配置：

- 安装Visual C ++生成环境：[Visual Studio生成工具](https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=BuildTools) （使用“ Visual C ++ [生成](https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=BuildTools)工具”工作负载）或[Visual Studio 2017社区](https://visualstudio.microsoft.com/pl/thank-you-downloading-visual-studio/?sku=Community) （使用“使用C ++进行桌面开发”工作负载）
- 启动cmd

```
npm config set msvs_version 2017
```

1. run: `

```
npm cache clean --force
```



1. delete node_modules
2. delete packagelock.json and yarn.lock(if have)
3. run: `npm install`

```sh
npm install --global --production windows-build-tools --vs2017
```

下个visiual studio
选部分安装，勾选msbuild





我们把所需文件下载路径复制一份到浏览器里，然后使用浏览器下载文件就可以了。 ....bower 失败了.... !ACOF(TYDYECOKVDYB.png)https://juejin.im/entry/5a77d5e76fb9a0634f40737b
但是今天拉项目的时候又发现了一种：node版本与fsevents版本不兼容。问题复现 这是因为 项目中的 fsevents版本比较低，只有1.2.9以上的才支持node12版本，所以导致编译不通过. 现在可以用 dart-sass 无缝替换 node-sass 了！dart-s… ![img](file:///C:\Users\nick\AppData\Local\Temp\%W@GJ$ACOF(TYDYECOKVDYB.png)https://juejin.im/entry/5d74de15f265da03dc0794c0



这是因为 项目中的 fsevents版本比较低，只有1.2.9以上的才支持node12版本，所以导致编译不通过.





