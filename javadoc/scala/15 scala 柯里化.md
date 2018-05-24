# 15 scala 柯里化

## 概述

柯里化(Currying)

Scala允许函数定义多组参数列表，每组写在一对圆括号里。当用少于定义数目的参数来调用函数的时候，将返回一个以余下的参数列表为参数的函数。



## 例子



```
    val a = Array("Hello", "Spark")
    val b = Array("hello", "spark")
    val result = a.corresponds(b)(_.equalsIgnoreCase(_))
```

其中 corresponds 是柯里化的方法具体代码如下

```

  def corresponds[B](that: GenSeq[B])(p: (A,B) => Boolean): Boolean = {
    val i = this.iterator
    val j = that.iterator
    while (i.hasNext && j.hasNext)
      if (!p(i.next(), j.next()))
        return false

    !i.hasNext && !j.hasNext
  }

```


```

object Curring {

  def main(args: Array[String]) {
    def multiple(x: Int, y: Int) = x * y
    def multipleOne(x: Int) = (y: Int) => x * y

    val mul = multipleOne(6)

    println(multipleOne(6)(7))

    def curring(x: Int)(y: Int) = x * y

    println(curring(10)(10))

    val a = Array("Hello", "Spark")
    val b = Array("hello", "spark")
    println(a.corresponds(b)(_.equalsIgnoreCase(_)))

  }

}
```