## Git开发版本管理规范V1.0

#### Git版本开发主要事项

- Tag 项目版本归档，与版本编号一一对应
- master ————> 归档
- release ————> 发布上线
- dev ————> 开发&test
- Bugfix(更新是否使用)

> 主要关注dev分支，研发多个人，可以创建多个分支，最终发布测试，合并dev,进行测试发布，【预发布，合并到release,进行版本发布】，正式上线后，release合并到master,打标签tag进行归档

###### 各分支使用办法说明如下：

master分支

master和develop分支都是主分支，主分支是所有开发活动的核心分支。所有的开发活动产生的输出物最终都会反映到主分支的代码中。

master分支上存放的应该是随时可供在生产环境中部署的代码（Production Ready state）。当开发活动告一段落，产生了一份新的可供部署的代码时，master分支上的代码会被更新。同时，每一次更新，都有对应的版本号标签（TAG）。

develop分支

develop分支是保存当前最新开发成果的分支。通常这个分支上的代码也是可进行每日夜间发布的代码（Nightly build）。因此这个分支有时也可以被称作“integration branch”。

当develop分支上的代码已实现了软件需求说明书中所有的功能，通过了所有的测试后，并且代码已经足够稳定时，就可以将所有的开发成果合并回master分支了。对于master分支上的新提交的代码建议都打上一个新的版本号标签（TAG），供后续代码跟踪使用。

release分支

使用规范：

1.可以从develop分支派生

2.必须合并回develop分支和master分支

3.分支命名惯例：release-*

release分支是为发布新的产品版本而设计的。在这个分支上的代码允许做小的缺陷修正、准备发布版本所需的各项说明信息（版本号、发布时间、编译时间等等）。通过在release分支上进行这些工作可以让develop分支空闲出来以接受新的feature分支上的代码提交，进入新的软件开发迭代周期。

当develop分支上的代码已经包含了所有即将发布的版本中所计划包含的软件功能，并且已通过所有测试时，我们就可以考虑准备创建release分支了。而所有在当前即将发布的版本之外的业务需求一定要确保不能混到release分支之内（避免由此引入一些不可控的系统缺陷）。

成功的派生了release分支，并被赋予版本号之后，develop分支就可以为“下一个版本”服务了。所谓的“下一个版本”是在当前即将发布的版本之后发布的版本。版本号的命名可以依据项目定义的版本号命名规则进行。

hotfix分支

使用规范：

1.可以从master分支派生

2.必须合并回master分支和develop分支

3.分支命名惯例：fix-*

除了是计划外创建的以外，hotfix分支与release分支十分相似：都可以产生一个新的可供在生产环境部署的软件版本。当生产环境中的软件遇到了异常情况或者发现了严重到必须立即修复的软件缺陷的时候，就需要从master分支上指定的TAG版本派生hotfix分支来组织代码的紧急修复工作。

### 整体交付流程如下：

![img](http://doc.bigaka.com/Public/Uploads/2018-05-28/5b0bec9d0d9d3.png)

#### dev(开发分支)

*开发分支是研发同学最需要关心的，所有的开发工作应该围绕dev分支进行展开，创建dev分支脚本如下：*

dev分支在实际工作中主要有两种常用场景：

1. 单个版本开发
2. 多个版本并行开发

第一种情况，属于比较常见的情况，即开发过程中都是按顺序进行的，即1.0.0开发完成之后才会进行开发1.1.0的需求开发，1.1.0完成上线后再进行1.2.0的版本开发，针对这种，工作直接在dev分支上开展就可以了，不需要做特殊处理，因为不会产生任何干扰~~

相关操作脚本：

```
#切换到dev分支下进行开发git checkout dev#同步最新的代码git pull#。。。。。开发代码，各种commit,push，这里就不列了#。。。。。#开发完测试通过后合并到主干，先把本地的dev代码更新到最新，接着执行下面脚本git checkout mastergit pullgit merge --no-ff devgit push
```

针对第二种情况，可能在互联网公司会比较常见，在开发资源比较充足的情况下，多个版本可能同时并行，即1.1.0和1.2.0或者更多版本在同时开发，但是又想快速试水一些功能，不可能等到全部做完都上线，所以1.1.0会先发，1.2.0会在另外一个时间点发，产品经理通常会很着急，认为错过这个时间点就会损失十几亿的感觉，碎碎的忧伤，所以分支的合理管理非常重要，不然在开发过程中会显得非常混乱，如果都在dev分支上进行开发就会把没做完的功能都发线上了，这时候就更碎了~~~ git 也给我们使用feature功能模式，即功能分支，可以通过这个来划分，如下：

先创建两个feature分支，跟创建dev分支一样，不过这次是从dev分支进行创建

```
git checkout -b feature-1.1 dev  git checkout -b feature-1.2 dev
```

开发1.1.0版本操作的相关脚本：

```
git checkout feature-1.1#又是各种commit push操作，开发完成测试通过后执行下面操作，合并代码到dev分支：git checkout devgit pull origin devgit merge --no-ff feature-1.1git push#删除本地feature分支git branch -d feature-1.1#删除远程feature分支git push origin --delete feature-1.1
```

开发1.2.0版本操作的相关脚本：

```
git checkout feature-1.2#又是各种commit push操作，开发完成测试通过后执行下面操作，合并代码到dev分支：git checkout devgit pull origin devgit merge --no-ff feature-1.2git push#删除本地feature分支git branch -d feature-1.2#删除远程feature分支git push origin --delete feature-1.2
```