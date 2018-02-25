# git入门使用一
>* git 安装
>* Git的基本操作
>* Git分支
>* 分支的合并，解决合并分支的冲突

# 一、git 安装


## Git的学习建议
Git的学习图书和文档
>* 《Pro.Git中文版》---电子文档 比较适合入门
>* 《版本控制之道——使用Git》---比较适合入门
>* 《Git权威指南》--更深入地讲解了Git的操作和背后的原理，还有涉及Git使用的问题
[git官方文档](https://git-scm.com/book/zh/v2/%E8%B5%B7%E6%AD%A5-%E5%AE%89%E8%A3%85-Git)


## Windows下安装和使用Git
>* 下载命令行客户端cygwin,msysGit和图形客户端TortoiseGit
>* 分别安装cygwin，msysGit和TortoiseGit (其实这三种软件的文字安装过程可以参考《Git权威指南》第三章)
>* Linux和Mac OS下也有相应Git软件

### 安装cygwin
[cygwin下载地址](http://www.cygwin.com/)

安装过程中选择安装:
>* cygwin
>* git
>* openssh
>* vim
>* nano

Windows7 下Cygwin添加右键菜单

>* 重写Cygwin目录下的Cygwin.bat
```shell
@echo off
set _T=%CD%
echo %_T
G:
chdir G:\env\cygwin\bin
  
@rem bash --login -i
start mintty.exe -e /bin/bash --login -i
```
>* 修改.bash_profile文件，位于安装目录/home/（用户名）下。在文件最后添加：
```shell
export _T=${_T//\\//}
if [ $_T == "" ]; then
export _T=~
fi
cd "$_T"
```

>* 增加右键菜单。将下列代码存为一个reg文件，假设addMenu.reg
```shell
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\Directory\Background\shell\OpenCygwin]

[HKEY_CLASSES_ROOT\Directory\Background\shell\OpenCygwin\command]
@="G:\\env\\cygwin\\Cygwin.bat"
```
>* 双击运行addMenu.reg，完成操作。


### 安装msysGit


### TortoiseGit



# 二、Git的基本操作

>* git config（使用git命令之前，如何配置用户信息？）
>* git help config（如何使用帮助）
>* git init (git 初始化)
>* git status (如何查看git管理的状态)
>* git add (如何跟踪文件)
>* git commit ( 如何提交到版本库中？)
>* git log (如何查看git的日志)
>* 暂存区，工作区，本地版本库，远程版本库
>* git管理下文件的生命周期，也就是文件的状态（用git status查看）

## 命令行和图形客户端
>* 学习Git，我们先学习Git命令行的操作，这样会对Git有个深入地理解。然后再操作图形客户端TortoiseGit。
>* 如果一开始就使用图形客户端，就会掩盖Git的细节，反而对以后的学习不利。

## 配置用户信息
```shell
$ git config --global user.name "John Doe"
$ git config --global user.email johndoe@example.com

```

这个操作是配置信息
>* cygwin操作之后把信息放在C:\cygwin\home\nick\.gitconfig文件中。
>* MsysGit和TortoiseGit放在C:\Users\nick\.gitconfig文件中nick是我机器上的用户名，每个人的机器自己设定的用户名都有所不同

某个Git命令如何得到详细的帮助
>* $ git help config

## git初始化 （如何从一个项目中建立git版本控制？）

```shell
$ mkdir mysite  //创建一个名为mysite的目录
$ cd mysite //进入mysite的目录
$ git init   //git始化（分别演示在m和t下如何操作）
```

## nano命令

>* nano命令编辑index.html
>* 图形操作：可以用任何IDE编辑文件

```shell
$ nano index.html   
//用之前在安装cygwin时安装过的nano编辑器
//创建一个名为index.html 的文件
<html>
<body>
	<h1>Hello World</h1>
</body>
</html>

```

## git add 
在一个项目文件夹中，如何指定某个文件，让Git来跟踪它
```shell
// 把目录下的index.hmtl，让git来跟踪它
$ git add index.html 

//把Documentation目录下的所有txt文件添加（熟悉了add命令之后，图形客户端有更为简便的操作）
$ git add Documentation/\*.txt  
```


## git commit 
把已经跟踪好的文件提交到版本库中去

```shell
$git commit -m "add hello world HTML" 
//提交到版本库中 ，参数-m的作用为，告诉Git，提交解释信息为add hello world HTML
```
## git log
查看提交记录
```shell
$git log 

```


## 版本号

为何版本号\提交号,不是从1,2,3开始.
>* 当两个人同时在一个代码上工作时候，分别往各自的本地的版本库提交时，相同的提交号对应着不同的修改，如果使用1,2,3这样的数字不能保证唯一性，所以Git使用SHA-1算法产生唯一标识符，保证全球唯一。
>* 比如程序员甲和乙负责共同开发一个聊天软件，使用Git来版本控制。 Git是分布式版本控制，每个人都有一个版本库。如果Git版本控制用1,2,3这样的数字来生成版本号，那么程序员甲和乙代码合并的时候就会出现问题。版本1到底是谁的？
>* SVN是集中式的版本控制，只有一个版本库，所以版本号可以从1,2,3开始。Git是分布式版本控制，每个人都有一个版本库，所以不能从1,2,3开始。

## git status 

查看项目目前的状态
```shell
//查看当前git版本库的状态
$git status
```
git 生命周期
![image](https://github.com/csyeva/eva/blob/master/img/github/gitlife.png)


演示一下一个文件的改变过程

>* 就是想说明在保存在暂存区里的文件，在没有提交之前，又进行修改。
>* Git会对这个文件保存了两种状态，一种是之前在暂存区里的状态，
>* 一种是修改之后在工作区里的代码。还需要再一次使用git add 文件名.
>* 如果嫌麻烦要第二次使用git  add 文件名,可以直接用git commit -am “提交注释”


## Git的几个基本概念

>* index-中文译名-暂存，又名暂存区

>* staging area--暂存区:
暂存区是可以设置哪些变更要提交到版本库，哪些先不提交。我们可以这样理解暂存区，我们种大米，三个月之后，大米成熟了。我们将要把收获的大米放入仓库里储藏起来。在储藏之前，我们找到一个临时存放大米的地方先放着大米，我们可以对大米进行筛选，对一些品质不好，我们不喜欢的大米进行丢弃，把我们认为好的大米放入仓库里。在这个例子中，临时存放大米的地方就相当于Git中的暂存区（staging area）。

>* work area--工作区:
工作区，就是我们进行工作的地方。

>* local repository--本地仓库:
本地仓库，就是我们自己工作的电脑上保存版本数据的地方。

>* remote repository--远程仓库
远程仓库，我们用Git进行操作，为了防止数据在自己电脑上丢失，比如错误删除，病毒攻击等原因造成了数据丢失，我们需要备份到远程的服务器上，这个服务器可以理解为远程仓库。

![image](https://github.com/csyeva/eva/blob/master/img/github/gitgn.png)
![image](https://github.com/csyeva/eva/blob/master/img/github/gitgn2.png)
![image](https://github.com/csyeva/eva/blob/master/img/github/gitgn3.png)

# 三、Git分支

## Git是如何保存数据

```shell
mkdir mybranch
cd mybranch
git init
nano README index.html LICENSE2
git status
git add README index.html LICENSE2
git commit –m “initial commit of my project”

```

>* 当使用git commit 新建一个提交对象前，Git 会先计算每一个子目录（本例中就是项目根目录mybranch目录）的校验和，然后在Git 仓库中将这些目录保存为树（tree）对象。之后Git 创建的提交对象，除了包含相关提交信息以外，还包含着指向这个树对象（项目根目录）的指针，如此它就可以在将来需要的时候，重现此次快照的内容了。
>* 这个就是git保存数据的原理，用文件快照的方式。

作些修改后再次提交，那么这次的提交对象会包含一个指向上次提交对象的指针（即下图中的parent 对象）。两次提交后，仓库历史会变成图:
![image](https://github.com/csyeva/eva/blob/master/img/github/gitsm.png)


```shell
git status
nano index.html //第一次修改
git add -am “add fuction B in index.html”
nano index.html //第二次修改
git add -am “add fuction C in index.html”
git branch testing
git checkout testing
nano index.html

```

作些修改后再次提交，那么这次的提交对象会包含一个指向上次提交对象的指针（即下图中的parent 对象）。两次提交后，仓库历史会变成:
![image](https://github.com/csyeva/eva/blob/master/img/github/gitsm1.png)

![image](https://github.com/csyeva/eva/blob/master/img/github/gitsm2.png)

## 深刻理解分支
>* Git 中的分支，其实本质上仅仅是个指向commit 对象的可变指针。Git
>* 会使用master 作为分支的默认名字。在若干次提交后，你其实已经有了一个指向最后一次提交对象commit的master 分支，它在每次提交的时候都会自动向前移动。

![image](https://github.com/csyeva/eva/blob/master/img/github/gitsm3.png)

## 创建分支
$git branch testing //这会在当前commit 对象上新建一个分支指针

![image](https://github.com/csyeva/eva/blob/master/img/github/gitsm4.png)


## Git 是如何知道你当前在哪个分支上工作

>* Git保存着一个名为HEAD 的特别指针。请注意它的HEAD和其他版本控制系统（如SVN或CVS）里的HEAD 概念大不相同。
>* 在Git 中，它是一个指向你正在工作中的本地分支的指针。
>* 运行git branch 命令，仅仅是建立了一个新的分支，但不会自动切换到这个分支中去，所以在这个例子中，我们依然还在master 分支里工作。
![image](https://github.com/csyeva/eva/blob/master/img/github/gitsm5.png)

## 如何切换到其他分支
$ git checkout testing //转换到新建的testing分支
![image](https://github.com/csyeva/eva/blob/master/img/github/gitsm6.png)

```shell
$ nano index.html
$ git commit -a -m ‘在index.html中增加No.4功能‘

```
![image](https://github.com/csyeva/eva/blob/master/img/github/gitsm7.png)

```shell
git checkout master
```
>* 该命令把HEAD 指针移回到master 分支，并把工作目录中的文件换成了master 分支所指向的快照内容。
>* 也就是说，现在开始所做的改动，将始于本项目中一个较老的版本。
>* 它的主要作用是将testing 分支里作出的修改暂时取消，这样你就可以向另一个方向进行开发

![image](https://github.com/csyeva/eva/blob/master/img/github/gitsm8.png)


我们作些修改后再次提交
```shell
$ nano index.html 
$ git commit -a -m ‘在index.html中增加No.5功能’
```
>* 现在我们的项目提交历史产生了分叉，因为刚才我们创建了一个分支，转换到其中进行了一些工作，然后又回到原来的主分支进行了另外一些工作。
>* 这些改变分别孤立在不同的分支里：我们可以在不同分支里反复切换，并在时机成熟时把它们合并到一起。
>* 而所有这些工作，仅仅需要branch 和checkout 这两条命令就可以完成。
![image](https://github.com/csyeva/eva/blob/master/img/github/gitsm9.png)

## 总结
>* 由于Git 中的分支实际上仅是一个包含所指对象校验和（40 个字符长度SHA-1 字串）的文件，所以创建和销毁一个分支就变得非常廉价。
>* 说白了，新建一个分支就是向一个文件写入41 个字节（外加一个换行符）那么简单，当然也就很快了。
>* 这和大多数版本控制系统形成了鲜明对比，它们管理分支大多采取备份所有项目文件到特定目录的方式，所以根据项目文件数量和大小不同，可能花费的时间也会有相当大的差别，快则几秒，慢则数分钟。
>* 而Git 的实现与项目复杂度无关，它永远可以在几毫秒的时间内完成分支的创建和切换。
>* 同时，因为每次提交时都记录了祖先信息（译注：即parent 对象），所以以后要合并分支时，寻找恰当的合并基础（译注：即共同祖先）的工作其实已经完成了一大半，实现起来非常容易。
>* Git 鼓励开发者频繁使用分支，正是因为有着这些特性作保障。
>* git和之前的版本控制软件如SVN实现的分支算法实现不同，
>* git更先进。所以分支的创建和销毁，切换都非常快。Git是鼓励在实际的工作中使用分支的。

# 分支的合并，解决合并分支的冲突

>* git branch bracnName (如何创建分支)
>* git checkout branchName(如何切换到想要的分支上去)
>* git checkout -b (上述两个命令的合并)
>* git merge branchname （合并分支）
>* git add (解决合并冲突之后，用add命令标记为已经解决了)
>* git stash


1. 工程师在项目中工作，并且提交了几次更新
![image](https://github.com/csyeva/eva/blob/master/img/github/gitmerge.png)

2. 工程师修补错误跟踪系统上的编号为53号错误
```shell
$ git checkout -b iss53
Switched to a new branch "iss53“
相当于下面这两条命令：
$ git branch iss53
$ git checkout iss53
```
执行的结果，如图

![image](https://github.com/csyeva/eva/blob/master/img/github/gitmerge1.png)


3. 修补问题跟踪系统上的#53问题
```shell
$ nano index.html //孙悟空修补了index.html代码
$ git commit -a -m “fix issue53”


```
执行的结果，如图
![image](https://github.com/csyeva/eva/blob/master/img/github/gitmerge2.png)

>* 工程师接到项目负责人唐僧的电话，要求修补已经发布的项目错误，也就是C2版本的出现的突然发现的错误。
>* 这个错误不是错误跟踪系统编号为53号的已知错误。
>* 工程师要从iss53分支切换到master分支。切换之前，注意工作区的暂存区或者工作目录里，那些还没有提交的修改，它会和你即将检出的分支产生冲突从而阻止Git 为你转换分支。
>* 转换分支的时候最好保持一个清洁的工作区域。稍后会介绍几个绕过这种问题的办法（分别叫做stashing 和amending 具体做法请自己看<<Pro.Git中文版>>6.3小节）。
>* 目前已经提交了所有的修改，所以接下来可以正常转换到master 分支：

```shell
$ git checkout master
Switched to branch "master“

```

4. 接下来，你得进行紧急修补。我们创建一个紧急修补分支（hotfix）来开展工作，直到搞定

```shell
$ git checkout -b hotfix
Switched to a new branch "hotfix"
$ nano index.html
$ git commit -a -m 'fixed the broken email address'
[hotfix]: created 3a0874c: "fixed the broken email address"
1 files changed, 0 insertions(+), 1 deletions(-)

```
![image](https://github.com/csyeva/eva/blob/master/img/github/gitmerge3.png)



5. 提交之前应该做测试，确保修补是成功的，然后把它合并到master 分支并发布到生产服务器。用git merge 命令来进行合并：【如何合并git分支？】
```shell
$ git checkout master
$ git merge hotfix
Updating f42c576..3a0874c
Fast forward
README | 1 -
1 files changed, 0 insertions(+), 1 deletions(-)
```
>* 请注意，合并时出现了“Fast forward”（快进）提示。
>* 由于当前master 分支所在的commit 是要并入的hotfix 分支的直接上游，Git 只需把指针直接右移。
>* 换句话说，如果顺着一个分支走下去可以到达另一个分支，那么Git 在合并两者时，只会简单地把指针前移，因为没有什么分歧需要解决，所以这个过程叫做快进（Fast forward）。
![image](https://github.com/csyeva/eva/blob/master/img/github/gitmerge4.png)

6. 在那个超级重要的修补发布以后，工程师想要回到被打扰之前的工作。因为现在hotfix 分支和master 指向相同的提交，现在没什么用了，可以先删掉它。使用git branch 的-d 选项表示删除：
```shell
$ git branch -d hotfix
Deleted branch hotfix (3a0874c).
现在可以回到未完成的问题#53 分支继续工作了（图3-15）：
$ git checkout iss53
Switched to branch "iss53"
$ nano index.html
$ git commit -a -m 'finished the new footer [issue 53]'
[iss53]: created ad82d7a: "finished the new footer [issue 53]"
1 files changed, 1 insertions(+), 0 deletions(-)
```
![image](https://github.com/csyeva/eva/blob/master/img/github/gitmerge5.png)

**合并解释**
>* 这次合并的实现，并不同于之前hotfix 的并入方式。
>* 这一次，你的开发历史是从更早的地方开始分叉的。
>* 由于当前master 分支所指向的commit (C4)并非想要并入分支（iss53）的直接祖先，Git 不得不进行一些处理。就此例而言，Git 会用两个分支的末端（C4 和C5）和它们的共同祖先（C2）进行一次简单的三方合并计算。
>* 下图标出了Git在用于合并的三个更新快照：
>* Git 没有简单地把分支指针右移，而是对三方合并的结果作一新的快照，并自动创建一个指向它的commit（C6）。
>* 我们把这个特殊的commit 称作合并提交（mergecommit），因为它的祖先不止一个。
>* 值得一提的是Git 可以自己裁决哪个共同祖先才是最佳合并基础；这和CVS 或Subversion（1.5 以后的版本）不同，它们需要开发者手工指定合并基础。
>* 所以此特性让Git 的合并操作比其他系统都要简单不少。
![image](https://github.com/csyeva/eva/blob/master/img/github/gitmerge6.png)

合并解释
Git合并的结果如图。
![image](https://github.com/csyeva/eva/blob/master/img/github/gitmerge7.png)


7. 既然你的工作成果已经合并了，iss53 也就没用了。你可以就此删除它，并在问题追踪系统里把该问题关闭。
```shell
$ git branch -d iss53
```

8. 解决合并中发生的冲突
```shell
$git checkout –b feature1
$nano index.html
$git commit –am “feature1 update index.html”
$git checkout master
$git checkout –b feature2
$nano index.html
$git commit –am “feature1 update index.html”
(两个分支有相同的文件，而且内容不相同，如果feature1和feature2合并,git会提示合并冲突)
在feature1上先合并feature2,这个时候Git提示合并冲突，
Auto-merging index.html
CONFLICT (content): Merge conflict in index.html
Automatic merge failed; fix conflicts and then commit the result.
这个时候请手动修改index.html后，把文件用git add 文件名来表示修改冲突成功，加入暂存区。
$git status 
可以看到git提示
Unmerged paths
$git add index.html //用git add命令来表示冲突已经解决
$git commit –m “分支feature1和feature2冲突已经解决”
请注意两个分支的同一个文件的不同地方合并，git会自动合并，不会产生冲突。
```
请注意两个分支的同一个文件的不同地方合并，git会自动合并，不会产生冲突。
>* 比如分支feture1对index.html原来的第二行之前加入了一段代码。
>* 分支feature2对index.html在原来的最后一行的后面加入了一段代码。
>* 这个时候在对两个分支合并，git不会产生冲突，因为两个分支是修改同一文件的不同位置。
>* git自动合并成功。不管是git自动合并成功，还是在人工解决冲突下合并成功，提交之前，都要对代码进行测试。

![image](https://github.com/csyeva/eva/blob/master/img/github/gitmerge8.png)

```shell
9. git stash命令

```
![image](https://github.com/csyeva/eva/blob/master/img/github/gitmerge9.png)

>* 当你正在进行项目中某一部分的工作，里面的东西处于一个比较杂乱的状态，而你想转到其他分支上进行一些工作。
>* 问题是，你不想提交进行了一半的工作，否则以后你无法回到这个工作点。解决这个问题的办法就是git stash命令。

```shell
stash 储藏
git stash （储藏当前状态之后，就能切换到别的分支）
git stash list (查看储藏状态的列表)
git stash apply 储藏的名字 （回到原来的分支之后，如何恢复到之前那种混乱的工作状态）
```

10. 分支—工作中使用分支
>* Git 的开发者都喜欢以这种方式来开展工作，在master 分支中保留完全稳定的代码，即已经发布或即将发布的代码。
>* 与此同时，他们还有一个名为develop 专门用于后续的开发，或仅用于稳定性测试。
>* 当然并不是说一定要绝对稳定，不过一旦进入某种稳定状态，便可以把它合并到master 里。
>* 还有在工作中，把开发任务分解为各个功能或者模块，用topic（topic branch主题分支，有又成为feature branch特性分支），实现之后并测试稳定之后，可以合并到其他分支。

![image](https://github.com/csyeva/eva/blob/master/img/github/gitfz.png)
![image](https://github.com/csyeva/eva/blob/master/img/github/gitfz1.png)


