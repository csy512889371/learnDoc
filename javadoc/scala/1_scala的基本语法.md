# 1_scala的基本语法

# 概述

下面是对一些与java 语法不同的地方进行说明。

## 1、Scala 使用 import 关键字引用包。

```scala
import java.awt.Color  // 引入Color
 
import java.awt._  // 引入包内所有成员
 
def handler(evt: event.ActionEvent) { 

}
```

如果想要引入包中的几个成员，可以使用selector（选取器）：

```scala
import java.awt.{Color, Font}
 
// 重命名成员
import java.util.{HashMap => JavaHashMap}
 
// 隐藏成员
import java.util.{HashMap => _, _} // 引入了util包的所有成员，但是HashMap被隐藏了
```

## 2、多行字符串的表示方法

* 多行字符串用三个双引号来表示分隔符，格式为：""" ... """。

```scala
val foo = """hello
www.ctoedu.cn
www.ctoedu.cn
www.ctoedu.cn
以上三个地址"""
```

## 3、Null 值


* 空值是 scala.Null 类型。
* Scala.Null和scala.Nothing是用统一的方式处理Scala面向对象类型系统的某些"边界情况"的特殊类型。
* Null类是null引用对象的类型，它是每个引用类（继承自AnyRef的类）的子类。Null不兼容值类型。

## 4、变量声明

在 Scala 中，使用关键词 "var" 声明变量，使用关键词 "val" 声明常量。

```scala
var myVar : String = "Foo"
var myVar : String = "Too"
```

如果在没有指明数据类型的情况下声明变量或常量必须要给出其初始值，否则将会报错。

```scala
var myVar = 10;
val myVal = "Hello, Scala!";
```


Scala 多个变量声明

```scala
val xmax, ymax = 100  // xmax, ymax都声明为100

```

## 5、Scala 访问修饰符

Scala 访问修饰符基本和Java的一样，分别有：private，protected，public。

* rivate关键字修饰，带有此标记的成员仅在包含了成员定义的类或对象内部可见
* （Protected）成员的访问比 java 更严格一些。因为它只允许保护成员在定义了该成员的的类的子类中被访问。
* Scala中，如果没有指定任何的修饰符，则默认为 public。这样的成员在任何地方都可以被访问。

### 5.1 作用域保护

```scala
private[x] 

或 

protected[x]
```

* 这里的x指代某个所属的包、类或单例对象。如果写成private[x],读作"这个成员除了对[…]中的类或[…]中的包中的类及它们的伴生对像可见外，对其它所有类都是private。
* 这种技巧在横跨了若干包的大型项目中非常有用，它允许你定义一些在你项目的若干子包中可见但对于项目外部的客户却始终不可见的东西。


```scala
package navigation {

    private[bobsrockets] class Navigator {
      protected[navigation] def useStarChart() {}

      class LegOfJourney {
        private[Navigator] val distance = 100
      }

      private[this] var speed = 200
    }

  }

  package launch {

    import navigation._

    object Vehicle {
      private[launch] val guide = new Navigator
    }

  }

}
```
* 上述例子中，类Navigator被标记为private[bobsrockets]就是说这个类对包含在bobsrockets包里的所有的类和对象可见。
* 比如说，从Vehicle对象里对Navigator的访问是被允许的，因为对象Vehicle包含在包launch中，而launch包在bobsrockets中，相反，所有在包bobsrockets之外的代码都不能访问类Navigator。

