# gitblit Git服务器
* Git服务现在独树一帜，相比与SVN有更多的灵活性，最流行的开源项目托管网站Github上面，如果托管开源项目，那么就是免费使用的，但是闭源的项目就会收取昂贵的费用，如果你不缺米，那么不在本文讨论的范围内，既然这样，我们可以自己搭建我们的Git服务器。
* gitblit是使用java语言开发的一个git管理工具，其后台使用的是servlet配置作为网页服务器，引用一句话：Gitblit 是一个纯 Java 库用来管理、查看和处理 Git 资料库.相当于 Git 的 Java 管理工具.git的管家

* gitblit
* gitlab 收费

## 下载地址

下载地址：http://www.gitblit.com/

## gitblit钩子
gitblit钩子与git hook差不多，只是配置方式不一样，gitblit钩子的配置使用groovy进行逻辑处理，而git hook基本上使用的是shell或cmd命令。groovy是JVM的一个替代语言。其语法与java相似并且可以使用import命令引入jar包

## gitblit 优点：
* 中文，全部中文操作
* 创建项目，用户、权限用法很简单
* 算得上稳定的，只是出了问题要看运气能否启动的起来。
* 只用一个安装包即可。

## 安装步骤

* 解压缩下载的压缩包即可，无需安装。
* 创建用于存储资料的文件夹
* 配置gitblit.properties 文件
1） 找到Git目录下的data文件下的gitblit.properties文件，“记事本”打开
2） 找到git.repositoriesFolder(资料库路径)，赋值为第七步创建好的文件目录
3） 找到server.httpPort，设定http协议的端口号
4） 找到server.httpBindInterface，设定服务器的IP地址。这里就设定你的服务器IP
5） 找到server.httpsBindInterface，设定为localhost
6） 保存，关闭文件

* 运行gitblit.cmd 批处理文件。
1） 找到bitblit目录中的gitblit.cmd文件，双击
1） 在浏览器中打开,现在就可以使用GitBlit了


* 设置以Windows Service方式启动Gitblit.
1） 在Gitblit目录下，找到installService.cmd文件
2） 用“记事本”打开
3） 修改 ARCH

```xml
32位系统：SET ARCH=x86

64位系统：SET ARCH=amd64
```
4) 添加 CD 为程序目录
SET CD=D:\Git\Gitblit-1.6.0
5) 修改StartParams里的启动参数，给空就可以了
6) 保存，关闭文件


* 以Windows Service方式启动Gitblit.

1) 双击Gitblit目录下的installService.cmd文件(以管理员身份运行)
2) 在服务器的服务管理下，就能看到已经存在的gitblit服务了
3) 平时使用时，保持这个服务是启动状态就可以了

