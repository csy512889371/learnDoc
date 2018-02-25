# git 总结

# 服务器
* https://github.com
* https://coding.net/

# GIT使用流程
* 提交、checkout
* [workspace] -> **add** -> [local cache] -> commit ->[local repository] -> push ->[remote git repository]
* [remote git repository] -> clone -> [git repository] checkout -> [workspace]

主要步骤:
* 添加add
* 提交commit
* 远程推送push
* 远程克隆clone
* 远程更新pull
* 其他命令: branch、tag 、remote 、checkout、 merge 、log 、status、 fetch 、rebase等

# GIT与svn主要区别
1.基于本地进行完整的版本管理，不强制依赖远程仓库
2.GIT把内容按元素方式存储，而SVN是按文件
3.GIT分支和SVN的分支不同


# GIT常用命令讲解

##安装git客户端
[官方客户端](https://git-scm.com/downloads)
[其他客户端](https://tortoisegit.org/download)

# 项目添加到push过程
* 创建项目
* 初始化git仓库
* 提交文件
* 远程关联

## 脚本

```shell
git config --global user.name 'nick'
git config --global user.email '512889371@qq.com'
git init gitlearn # 初始化项目
git status # 查看状态
git add 1.txt # 添加修改到本地缓存
git commit -am '1.txt' # 提交到本地仓库
git remote add origin https://github.com/csy512889371/gitlearn.git #添加远程仓库
git remote #查看远程
git push origin master -u

```






