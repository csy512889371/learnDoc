# scala 环境搭建

## 概述

学习scala 是为了看spark 源码做准备，所以查看spark 对于的scala 版本

![image](![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/193.png))




## 安装scala和配置IDEA


scala 下载地址

https://www.scala-lang.org/download/2.11.12.html

下载 scala-2.11.12.msi

参照:

https://blog.csdn.net/qq_27384769/article/details/79705516

## Scala各种符号的含义


### 1、 :::运算符

:::(三个冒号)表示List的连接操作，比如：

```
val a = List(1, 2)  
val b = List(3, 4)  
val c = a ::: b 
```

* 其中a,b保持不变，a和b连接产生一个新表List(1,2,3,4),而不是在a上面做add操作。
* Scala中的List不同于Java的List，Java声明final List javaList，表示javaList一旦初始化，那么不能再为它赋值，但是它其中的元素可以变化

### 2、 ::运算符

::(两个冒号)表示普通元素与List的连接操作，比如：

```
val a = 1  
val b = List(3, 4)  
val c = 1 :: b  
```

则c的结果是List(1,3,4),需要注意的是，1:: b操作，::是右侧对象的方法，即它是b对象的方法，而::左侧的运算数是::方法的参数，所以1::b的含义是b.::(1)



### 3、(下划线数字)

```
_N(下划线数字)
```

```
val pair = (99, "Luftballons")  
println(pair._1)  
println(pair._2)
```

用于访问元组的第N个元素(N从1开始算起)，元组不同于List或者Array，元组(Tuple)中的元素可以不同

### 4、->

->方法是所有Scala对象都有的方法，比如A->B,->方法调用的结果是返回一个二元的元组(A,B)


### 5、<-

```
def printArgs(args: Array[String]): Unit = {  
   for (arg <- args) //表示什么含义，<-应该是一个函数，这个函数是哪个对象调用的？  
   println(arg)  
} 
```

### 6、Scala方法定义语法

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/zz/194.png)

如果函数体中的语句是一个，那么可以将包着方法体的{}省略，如：

```
def max(x :Int, y :Int) ：Int = if (x > y) x else y
```


### 7、<- 运算符

<-用于for循环中，如下所示

```
for (A <- B) {  
   println(A)  
} 
```

<-用于遍历集合对象(可遍历对象)B，在每次遍历的过程中，生成一个新的对象A，这个A是val，而不是var，然后对循环体中对A进行处理，<-在Scala中称为generator。 不需要显式的指定A的类型，因为Scala使用自动推导的方式根据B的元素类型得出A的类型

### 8、上下界约束符号 <: 与 >:


先举个栗子：

```
def using[A <: Closeable, B](closeable: A) (getB: A => B): B =  
  try {   
    getB(closeable)  
  } finally {  
    closeable.close()   
  }  
```

例子中A <: Closeable(java.io.Cloaseable)的意思就是保证类型参数A是Closeable的子类（含本类），语法“A <: B"定义了B为A的上界；同理相反的A>:B的意思就是A是B的超类（含本类），定义了B为A的下界。


其实<: 和 >: 就等价于java范型编程中的 extends，super

### 9、协变与逆变符号+T， -T

协变”是指能够使用与原始指定的派生类型相比，派生程度更大的类型。e.g. String => AnyRef

“逆变”则是指能够使用派生程度更小的类型。e.g. AnyRef => String

【+T】表示协变，【-T】表示逆变


### 10、view bounds(视界) 与 <%

<%的意思是“view bounds”(视界)，它比<:适用的范围更广，除了所有的子类型，还允许隐式转换过去的类型

### 11、广义类型约束符号 =：=， <:<,  <%<

* A =:= B 表示 A 必须是 B 类型
* A <:< B 表示 A 必须是B的子类型 (类似于简单类型约束 <:)
* A <%< B 表示 A 必须是可视化为 B类型, 可能通过隐式转换 (类似与简单类型约束 <%)


