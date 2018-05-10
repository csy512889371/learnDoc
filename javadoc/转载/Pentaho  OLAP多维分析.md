# Pentaho  OLAP多维分析

## 概述

在传统公司中，报表是向上级反映情况的信息表格，：报表就是用表格、图表等格式来动态显示数据，可以用公式表示为：“报表 = 多样的格式 + 动态的数据”。

pentaho是java平台著名商业只能（ＢＩ）项目，他包含多个产品及产品插件和辅助工具。


pentaho报表主要有两种使用方式，一是基于BI service　（不需要写代码），一种是嵌入应用方式传统JFree Report的方式。

报表主要通过报表设计器（PentahoReport Designer, PRD）来定义，好的报表保存为后缀为prpt的文件。

ＰＲＤ本身带了一个示例数据库，在resource/sampledata 目录下，是一个HSQ数据库（内存数据库）。这个数据库可作为pertaho 报表大的示例数据库，也可作为Pentaho Analysis（多维分析）的示例数据库。

## 下载地址

https://sourceforge.net/projects/pentaho/files/Business%20Intelligence%20Server/

https://jaist.dl.sourceforge.net/project/pentaho/Business%20Intelligence%20Server/4.8.0-stable/biserver-ce-4.8.0-stable.zip

https://jaist.dl.sourceforge.net/project/pentaho/Report%20Designer/5.0.1-stable/prd-ce-5.0.1-stable.zip

## 新建一个报表后


从report-designer.bat（或report-desginer.sh）启动PRD。

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/57.png)

在最左边是一列报表元素（可拖入报表），主区域是报表设计区域，右边Structure(显示报表结构)，data信息，右边是Style（元素样式），Attributes设置区域。其中报表样式和报表大小均可以在其中的属性中设计。如果想要设计报表页面大小，可以在file菜单栏下的page Setup选项中设置即可。

另外在上图蓝色圈中的地区我们可以按住Ctr键使用鼠标进行滑动调节新建区域大小。

以上完成只是我们在创建报表的前期步骤。

接下来我们要创建数据库的连接已完成从数据库中读取数据内容选中右边菜单中的data菜单右键Data Sets弹出左边的数据源框，我们点击左边

Available Queries旁边的加号会弹出数据连接页面。在这输入你的主机名称，数据库名称，端口号，用户名，和密码。测试通过点击确认按钮这时候连接工作就已经完成了。

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/58.png)

接下来我们要写sql语句，在写sql的时候我们可以现在sql客户端上写好然后测试在将sql添加进来。如图所示：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/59.png)

同时可以点击Preview来预览查询结果。

当我们sql中有输入查询条件的时候，我们可以在Paraments中添加参数：


![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/60.png)

当然我们在data菜单栏下也可以添加函数，用于求和，汇总或者计算总数，添加序号等等，如添加序号的函数是在function 中的Running 下，如图所示：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/61.png)


这样我们就基本完成了报表的大部分工作。

后续就是我们设计报表。

Structure菜单是用来设计报表样式，一般情况下我们会在Details Header中添加列（就是你要查询的报表的内容）右键Details Header去掉隐藏要素让后在左边就会显示Details Header属性，鼠标指到layOut布局选中row这是我们添加的元素就会成横向排布。符合正常报表的要求。然后点击添加

Add Element 添加label即可。

在Details 可以直接将data 中的查询列一一拖过来要保持与Details Header中属性相一致。

然后可以根据需要在Struture 下设置报表想要的格式。

到此一个基本报表就算完成了。


