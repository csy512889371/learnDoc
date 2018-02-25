# git入门使用二
>* Git服务器与远程操作

# Git服务器与远程操作
>* git remote add
>* git clone
>* git push
>* git remote –v
>* ssh 生成公钥私钥文件
>* git fetch
>* git merge
>* git pull


什么要用到Git服务器
>* Git版本数据也是保存在自己的电脑上，这其实非常不安全，因为你可能会感染电脑病毒，会错误删除文件，危害到了git版本数据。
>* 所以我们在本机上保存版本数据，最好的备份方式就是使用git服务器。
>* 使用git服务器不仅保证数据的安全性，还能够多人共享，多人协同开发项目。

## 协议
1. SSH 协议 1
```shell
ssh://[user@]example.com:[:port]/path/to/repo.git/

```
>* 可以在URL中设置用户名和端口。默认端口为22

2. SSH协议 2
```shell
[user@]example.com:[:port]/path/to/repo.git/

```
>* SCP格式表示法，更简洁。但是非默认端口需要通过其他方式（如主机别名方式）

3. GIT协议
```shell
git://example.com[:port]/path/to/repo.git/

```

4. HTTP[S]协议
```shell
http[s]://example.com:[port]/path/to/repo.git

```
>* 兼有智能协议和哑协议


> 还支持其他协议如FTP,RSYNC(这两种属于哑协议)，SSH和GIT协议属于智能协议。两者的区别，我们明白一点就是哑协议：传输速度非常慢，传输进度不可见，不知道什么时候数据传输完成。而智能协议，传输速度快，可以看到传输进度。

## Git服务器与远程操作

>* bitbucket.org
>* github.com
>* 架设自己的Git服务器Gitlab的操作。

演示bitbucket.org的操作 首先要生成公钥和私钥
```shell
1.用SSH生成公钥和私钥
ssh-keygen -t rsa -C “你配置的电子邮件”
ssh-keygen -t rsa -C “tangseng2013git@163.com”
2.把生成的公钥文件用记事本之类的文本编辑软件打开，复制到网站相应的key中

```

```shell
测试SSH公钥是否成功
ssh git@git服务器地址

```

演示bitbucket.org的操作
>* 1.在bitbucket.org上创建一个新项目仓库，克隆这个项目，在本地添加源代码之后，推送上去。
>* 2.在刚才bitbucket.org项目上，演示2个人参与的情况。学习git fetch,git merge,git pull命令。
![image](https://github.com/csyeva/eva/blob/master/img/github/gitrm.png)


## 克隆远程仓库

```shell
$git clone 仓库URL

```
>* 默认情况下git clone 命令本质上就是
>* 自动创建了本地的master 分支用于跟踪远程仓库中的master 分支
>* 打开项目文件夹\.git\config文件可以看到master分支和远程仓库master分支的关联

1. 注册远程版本库
```shell
$git remote add 远程仓库名(我们一般使用origin) 仓库URL

```

2. 推送数据到远程仓库

```shell
git push -u [远程仓库名remote-name] [本地推送的分支名 local branch-name]

//推送本地仓库的所有分支到远程仓库上去
git push -u [远程仓库名remote-name] --all

-u 表示参数建立追踪。 这样git status 时会显示本地分支和远程分支的偏离情况。

```
>* 只有在所克隆的服务器上有写权限，并且同一时刻没有其他人在推数据，这条命令才会如期完成任务。如果在你推数据前，已经有其他人推送了若干更新，那你的推送操作就会被驳回。
>* 你必须先把他们的更新抓取到本地，合并到自己的项目中，然后才可以再次推送。
>* 在你还是太熟悉git命令的时候，最好完整地写出这条命令。
>* 《Git权威指南》P293页有对简略写这条命令，git会如何解释

```shell
git push origin master

```

>* 把本地的master分支推送给了远程仓库origin,并且在远程仓库origin中创建了一个远程的master分支，远程的master分支和本地分支master关联

> 如何查看本地分支与远程分支的联系:
```shell
git branch –vv

```

> 如果本地有个master 和远程的 origin/master分支没有建立跟踪关联
```shell
需要使用
git branch --set-upstream master origin/origin

```

> 查看当前远程仓库
```shell
git remote –v

```

>* 从远程仓库抓取数据
>* 正如之前所看到的，可以用下面的命令从远程仓库抓取数据到本地：
```shell
$ git fetch 远程仓库名
```

远程仓库的分支合并
```shell
$ git merge 远程仓库名/分支名

```

```shell
$ git pull
相当于
$ git fetch
$git merge远程仓库名/分支名

```

查看远程仓库信息
```shell
git remote show [remote-name]

```

远程仓库的重命名
```shell
git remote rename 原名 新名字

```

远程仓库的删除
```shell
git remote rm 远程仓库名

```

## 远程分支

远程分支（remote branch）是对远程仓库状态的索引。我们可以理解为在远程仓库上文件快照的指针，其实和本地分支的是一样的，不过这些分支是在远程仓库上。我们用(远程仓库名)/(分支名) 这样的形式表示远程分支。

> 远程分支的推送
```shell
git push -u [远程仓库名remote-name] [本地推送的分支名 local branch-name]
```

> 跟踪远程分支
```shell
git checkout –b [本地分支名] [远程仓库名]/[分支名]

git branch --track [本地分支名] [远程仓库名]/[分支名]
注意这个是新建一个本地分支，然后跟踪关联远程分支，如果对已经存在的本地分支，关联某一个远程分支，请使用
git branch --set-upstream [本地分支名] [远程仓库名]/[分支名]

```






