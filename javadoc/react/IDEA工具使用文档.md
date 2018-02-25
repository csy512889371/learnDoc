# Idea使用

## 安装

### 安装文件
其中：ideaIU-2017.2.4.exe 为企业版。 IntelliJIDEALicenseServer.zip 为破解服务器。
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/1.png)
> 安装 ideaIU-2017.2.4 直接点击下一步下一步就可以。

> 启动idea 时候 指定验证方式为服务器验证。服务器地址：

![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/2.png)

## 关联svn项目
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/3.png)
> 关联到对应的svn项目。

## 配置svn
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/4.png)

> 注意安装 svn 客户端时候需要选择全部安装。且默认安装到c盘,且安装时候全部勾选。
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/5.png)

## 配置tomcat

![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/6.png)

> 添加tomcat

![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/7.png)

> 配置选择tomcat
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/8.png)
实现热部署：

![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/9.png)
> 选择部署方式：

![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/10.png)

## 配置JDK
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/11.png)

## 配置视图
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/12.png)

## 指定key 模式 和celipse键相同
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/13.png)
## 设置字体大小
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/14.png)
修改字体大小为 18
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/15.png)

![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/16.png)
> 保护色
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/17.png)
## 1.9.	设置代码提示不区分大小写
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/18.png)

## 设置代码检查等级
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/19.png)

>* 这个在界面的右下角，一个老头图标（打开代码文件才能看到）。那个可以拖动的控件就是设置代码检查等级的。
>* Inspections 为最高等级检查，可以检查单词拼写，语法错误，变量使用，方法之间调用等。
>* Syntax 可以检查单词拼写，简单语法错误。
>* None 不设置检查。


## 设置自动导包

![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/20.png)
>* 如上图标注 1 和 2 所示，默认 IntelliJ IDEA 是没有开启自动 import 包的功能。
>* 勾选标注 1 选项，IntelliJ IDEA 将在我们书写代码的时候自动帮我们优化导入的包，比如自动去掉一些没有用到的包。
>* 勾选标注 2 选项，IntelliJ IDEA 将在我们书写代码的时候自动帮我们导入需要用到的包。但是对于那些同名的包，还是需要手动Alt + Enter 进行导入的，IntelliJ IDEA 目前还无法智能到替我们做判断。

## 省电模式
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/21.png)

> IntelliJ IDEA 有一种叫做 省电模式 的状态，开启这种模式之后 IntelliJ IDEA 会关掉代码检查和代码提示等功能。所以一般我也会认为这是一种 阅读模式，如果你在开发过程中遇到突然代码文件不能进行检查和提示可以来看看这里是否有开启该功能。

## 切分窗口
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/22.png)
> IDEA 支持对代码进行垂直或是水平分组。一般在对大文件进行修改的时候，有些修改内容在文件上面，有些内容在文件下面，如果来回操作可能效率会很低，用此方法就可以好很多。当然了，前提是自己的浏览器分辨率要足够高。

## Tab菜单多行显示
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/23.png)

## 打开IDEA设置
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/24.png)

>* 勾选此选项后，启动 IntelliJ IDEA 的时候，默认会打开上次使用的项目。如果你只有一个项目的话，该功能还是很好用的，但是如果你有多个项目的话，建议还是关闭，这样启动 IntelliJ IDEA 的时候可以选择最近打开的某个项目。
>* 下面的选项是设置当我们已经打开一个项目窗口的时候，再打开一个项目窗口的时候是选择怎样的打开方式。

>* Open project in new window 每次都使用新窗口打开。
>* Open project in the same window 每次都替换当前已打开的项目，这样桌面上就只有一个项目窗口。
>* Confirm window to open project in 每次都弹出提示窗口，让我们选择用新窗口打开或是替换当前项目窗口。


## 调整代码字体大小
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/25.png)
> 可以勾选此设置后，增加 Ctrl + 鼠标滚轮 快捷键来控制代码字体大小显示。

## 打开文件时候目录是否打开
> 如上图标注红圈所示，我们可以对指定代码类型进行默认折叠或是展开的设置，勾选上的表示该类型的代码在文件被打开的时候默认是被折叠的，去掉勾选则反之。
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/26.png)

## 拼写检查
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/27.png)
> 如上图箭头所示，IntelliJ IDEA 默认是开启单词拼写检查的，有些人可能有强迫症不喜欢看到单词下面有波浪线，就可以去掉该勾选。但是我个人建议这个还是不要关闭，因为拼写检查是一个很好的功能，当大家的命名都是标准话的时候，这可以在不时方便地帮我们找到代码因为拼写错误引起的 Bug。


## 窗口还原
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/28.png)

## 显示内存
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/29.png)

## 插件
> IDEA已经集成了许多插件，包括前端神器emmet，基本够用，不是特别需要的话没有必要安装其他插件。

## 添加到收藏夹
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/30.png)

## 窗口不会自动隐藏
> 当我们设置了组件窗口的 Pinned Mode 属性之后，在切换到其他组件窗口的时候，已设置该属性的窗口不会自动隐藏。
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/31.png)

# 常用操作（快捷键）
>* Ctrl+E 最近打开的文件
>* Alt+Insert 生成代码(如get,set方法,构造函数等)
>* Alt+1 快速打开或隐藏工程面板
>* Alt+ left/right 返回至上次浏览的位置
>* 代码标签输入完成后，按Tab，生成代码。
>* Ctrl + Alt +B 快速打开光标处的类或方法
>* 自动补全变量名称 : Ctrl + Alt + v  。
>* 拷贝复制行：Ctrl+Alt 箭头
>* 快注释：Ctrl+Shift + /
>* 单行注释：Ctrl + /
>* 查看方法被哪些类使用：Ctrl+Alt + H


![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/32.png)
> 查看属性 使用到的地方
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/33.png)
> "Find Usage"可以查看一个Java类、方法或变量的直接使用情况 CTRL + G
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/34.png)
> 选中文件时，自动在左侧弹出文件所在位置及文件
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/35.png)
> 在我们按 Ctrl + Shift + R 进行打开某个文件的时候，我们可以直接定位到改文件的行数上。一般我们在调 CSS，根据控制台找空指针异常的时候，使用该方法速度都会相对高一点。

![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/36.png)

> 代码提示： Ctrl + ,

![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/57.png)

> 单行注释加在代码前：
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/37.png)
> 软换行：
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/38.png)
> 查看类的继承关系：
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/39.png)

> 如上图红圈所示，默认 IntelliJ IDEA 是没有勾选 Show line numbers 显示行数的，但是我建议一般这个要勾选上。
> 如上图红圈所示，默认 IntelliJ IDEA 是没有勾选 Show method separators 显示方法线的，这种线有助于我们区分开方法，所以也是建议勾选上的。
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/40.png)



> 我们还可以根据选择的代码，查看该段代码的本地历史，这样就省去了查看文件中其他内容的历史了。除了对文件可以查看历史，文件夹也是可以查看各个文件变化的历史
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/41.png)

> IntelliJ IDEA 自带了代码检查功能，可以帮我们分析一些简单的语法问题和一些代码细节。
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/42.png)

> IntelliJ IDEA 自带模拟请求工具 Rest Client，在开发时用来模拟请求是非常好用的。
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/43.png)

# 快捷键
>* Ctrl+E，最近的文件

# Svn 使用
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/44.png)
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/45.png)
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/46.png)

>* Show Diff 当前文件与服务器上该文件通版本的内容进行比较。
>* Move to Another Changelist 将选中的文件转移到其他的 Change list 中。Change list 是一个重要的概念，这里需要进行重点说明。很多时候，我们开发一个项目同时并发的任务可能有很多，每个任务涉及到的文件可能都是基于业务来讲的。所以就会存在一个这样的情况：我改了 30 个文件，其中 15 个文件是属于订单问题，剩下 15 个是会员问题，那我希望提交代码的时候是根据业务区分这些文件的，这样我填写 Commit Message 是好描述的，同时在文件多的情况下，我也好区分这些要提交的文件业务模块。所以我一般会把属于订单的 15 个文件转移到其他的 Change list中，先把专注点集中在 15 个会员问题的文件，先提交会员问题的 Change list，然后在提交订单会员的 Change list。我个人还有一种用法是把一些文件暂时不提交的文件转移到一个我指定的 Change list，等后面我觉得有必要提交了，再做提交操作，这样这些文件就不会干扰我当前修改的文件提交。总结下 Change list 的功能就是为了让你更好地管理你的版本控制文件，让你的专注点得到更好的集中，从而提供效率。
>* Jump to Source 打开并跳转到被选中。
>* 如上图标注 2 所示，可以根据工具栏按钮进行操作，操作的对象会鼠标选中的文件，多选可以按 Ctrl后不放，需要注意的是这个更前面的复选框是没有多大关系的。
>* 如上图标注 3 所示，可以在提交前自动对被提交的文件进行一些操作事件（该项目使用的 Git，使用其他版本控制可能有些按钮有差异。）：
>* Reformat code 格式化代码，如果是 Web 开发建议不要勾选，因为格式化 JSP 类文件，格式化效果不好。如果都是 Java 类则可以安心格式化。
>* Rearrange code 重新编排代码，IntelliJ IDEA 支持各种复杂的编排设置选项，这个会在后面说。设置好了编码功能之后，这里就可以尝试勾选这个进行自动编排。
>* Optimize imports 优化导入包，会在自动去掉没有使用的包。这个建议都勾选，这个只对 Java 类有作用，所以不用担心有副作用。
>* Perform code analysis 进行代码分析，这个建议不用在提交的时候处理，而是在开发完之后，要专门养成对代码进行分析的习惯。IntelliJ IDEA 集成了代码分析功能。
>* Check TODO 检查代码中的 TODO。TODO 功能后面也会有章节进行讲解，这里简单介绍：这是一个记录待办事项的功能。
>* Cleanup 清除下版本控制系统，去掉一些版本控制系统的错误信息，建议勾选（主要针对 SVN，Git 不适用）。
>* 如上图标注 4 所示，填写提交的信息。
>* 如上图标注 5 所示，Change list 改变列表，这是一个下拉选项，说明我们可以切换不同的 Change list，提交不同的 Change list 文件。
>* 如上图标注箭头所示，我们可以查看我们提交历史中使用的 Commit Message，有些时候，我们做得是同一个任务，但是需要提交多次，为了更好管理项目，建议是提交的 Message 是保持一致的。



![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/47.png)
> 上图 Local Changes 这个 Tab 表示当前项目的 SVN 中各个文件的总的情况预览。这里的 Default 是 IntelliJ IDEA 的默认 change list 名称，no commit 是我自己创建的一个change list，我个人有一个习惯是把一些暂时不需要提交的先放这个 list 里面。change list 很常用而且重要，本文前面也有强调过了，所以一定好认真对待。unversioned Files表示项目中未加到版本控制系统中的文件，你可以点击 Click to browse，会弹出一个弹出框列表显示这些未被加入的文件。

![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/48.png)
> 上图 Repository 这个 Tab 表示项目的 SVN 信息汇总，内容非常的详细，也是我平时用最多的地方。如果你点击这个 Tab 没看到数据，是因为你需要点击上图红圈这个刷新按钮。初次使用下默认的过滤条件不是我上图这样的，我习惯根据 User 进行过滤筛选，所以上图箭头中的 Filter 我是选择 User。选择之后，如上图标注 1 所示，显示了这个项目中参与提交的各个用户名，选择一个用户之后，上图标注 2 所以会显示出该用户提交了哪些记录。选择标注 2 区域中的某个提交记录后，标注 3 显示对应的具体提交细节，我们可以对这些文件进行右键操作，具体操作内容跟本文上面提到的那些提交时的操作按钮差不多，这里不多讲。
> 总的来说，SVN 这个功能用来管理和审查开发团队中人员的代码是非常好用的，所以非常非常建议你一定要学会该功能。

## Svn 导入项目
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/49.png)
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/50.png)
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/51.png)
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/52.png)
## Idea 序列号
serialVersionUID的作用：
> 通过判断实体类的serialVersionUID来验证版本一致性的。在进行反序列化时，JVM会把传来的字节流中的serialVersionUID与本地相应实体类的serialVersionUID进行比较，如果相同就认为是一致的，可以进行反序列化，否则就会出现序列化版本不一致的异常。
> 生成实体类的serialVersionUID方法：

```java
1、写上默认的1L，比如：private static final long serialVersionUID = 1L;
2、用idea自动生成。
①点击File->Setting->Plugins->Browse Repositories，然后搜索GenerateSerialVersionUID的插件，下载、安装后关闭IDEA，然后再打开项目。
②默认情况下IntellijIDEA是关闭了继承了java.io.Serializable的类生成serialVersionUID的警告。如果需要idea提示生成serialVersionUID，那么需要做以下设置：
Ⅰ、File->setting->Inspections->Serializationissues，将其展开后将serialzable class without "serialVersionUID"打上勾；
```

![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/53.png)

> 将光标放到类名上，按alt＋enter键，就会提示生成serialVersionUID了。

## Properties 中文
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/54.png)

## IDEA如何全局替换
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/56.png)
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/58.png)
## 开启nodejs 提示
![image](https://github.com/csy512889371/reactLearn/blob/master/img/idea/55.png)

## IDEA引MAVEN项目jar包依赖导入问题解决


IDEA内置了Maven环境，默认采用Maven解决项目依赖问题。在新建项目后，项目的路径中会生成pom.xml文件和
项目名.iml文件。新建项目后，IDEA不会自动刷新Maven的依赖。以Spring Application为例，新建项目编译时提示以下错误信息： 
> 刷新Maven配置的方法为：

>* 右键单击项目；
>* 在弹出菜单中选择Maven|Reimport菜单项。

此时，IDEA将通过网络自动下载相关依赖，并存放在Maven的本地仓库中。另外，可以将Maven的刷新设置为自动，配置方法为：

>* 单击File|Setting菜单项，打开Settings选项卡；
>* 在左侧的目录树中，展开Maven节点；
>* 勾选Import Maven projects automatically选择项。















