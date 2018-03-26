# 搭建Scala开发环境，使用Intellij IDEA开发Scala程序

## 一、为什么要学习Scala语言

* 结合Spark处理大数据. 这是Scala的一个主要应用，而且Spark也是那Scala写的。
* Java的脚本语言版.可以直接写Scala的脚本，也可以在.sh直接使用Scala。
* 代替Java.Scala的编程风格更简洁，当然也很可能降低可读性，不过Java语言还是有其优势

## 二、Scala简介

Scala有几项关键特性表明了它的面向对象的本质。例如，Scala中的每个值都是一个对象，包括基本数据类型（即布尔值、数字等）在内，连函数也是对象。另外，类可以被子类化，而且Scala还提供了基于mixin的组合（mixin-based composition）。

与只支持单继承的语言相比，Scala具有更广泛意义上的类重用。Scala允许定义新类的时候重用“一个类中新增的成员定义（即相较于其父类的差异之处）”。Scala称之为mixin类组合。

Scala还包含了若干函数式语言的关键概念，包括高阶函数（Higher-Order Function）、局部套用（Currying）、嵌套函数（Nested Function）、序列解读（Sequence Comprehensions）等等。

Scala是静态类型的，这就允许它提供泛型类、内部类、甚至多态方法（Polymorphic Method）。另外值得一提的是，Scala被特意设计成能够与Java和.NET互操作。Scala当前版本还不能在.NET上运行（虽然上一版可以-_-b），但按照计划将来可以在.NET上运行。

Scala可以与Java互操作。它用scalac这个编译器把源文件编译成Java的class文件（即在JVM上运行的字节码）。你可以从Scala中调用所有的Java类库，也同样可以从Java应用程序中调用Scala的代码。用David Rupp的话来说，

它也可以访问现存的数之不尽的Java类库，这让（潜在地）迁移到Scala更加容易。这让Scala得以使用为Java编写的巨量的Java类库和框架。


## 三、Scala在Windows系统上的安装及环境配置

### 3.1 安装JDK 1.8 （略）


### 3.2 安装scala

**下载Scala**

首先点击这个链接: 

* http://www.scala-lang.org/download
* http://www.scala-lang.org/download/all.html

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/scala/1.png)

**配置环境变量**

* 变量名：SCALA_HOME
* 变量名：PATH 前面增加  %SCALA_HOME%\bin;

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/scala/2.png)


## 四、Intellij IDEA 创建scala 项目

安装Scala 插件

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/scala/7.png)

创建scala项目
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/scala/4.png)



![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/scala/5.png)

设置 Project Encoding
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/scala/3.png)

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/scala/6.png)