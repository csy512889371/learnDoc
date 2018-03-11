# git安装及本地仓库对应gitlab仓库


## 一、在 Mac 上安装
在 Mac 上安装 Git 有两种方式。最容易的当属使用图形化的 Git 安装工具，界面如图 1-7，下载地址在：

* http://sourceforge.net/projects/git-osx-installer/


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/git/2.png)

## Git OS X 安装工具

另一种是通过 MacPorts (http://www.macports.org) 安装。如果已经装好了 MacPorts，用下面的命令安装 Git：
```shell

$ sudo port install git-core +svn +doc +bash_completion +gitweb
```
这种方式就不需要再自己安装依赖库了，Macports 会帮你搞定这些麻烦事。一般上面列出的安装选项已经够用，要是你想用 Git 连接 Subversion 的代码仓库，还可以加上 +svn 选项，具体将在第八章作介绍。（译注：还有一种是使用 homebrew（https://github.com/mxcl/homebrew）：brew install git。）

## 二、在 Windows 上安装
* 在 Windows 上安装 Git 同样轻松，有个叫做 msysGit 的项目提供了安装包，可以到 GitHub 的页面上下载 exe 安装文件并运行：
* http://msysgit.github.com/
* 完成安装之后，就可以使用命令行的 git 工具（已经自带了 ssh 客户端）了，另外还有一个图形界面的 Git 项目管理工具。
