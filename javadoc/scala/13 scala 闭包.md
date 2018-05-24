# 13 scala 闭包


## 闭包

闭包是一个函数，返回值依赖于声明在函数外部的一个或多个变量。

```
object ClosureOps {
  def main(args: Array[String]) {
    val data = List(1, 2, 3, 4, 5, 6)
    var sum = 0
    data.foreach(sum += _)

    def add(more: Int) = (x: Int) => x + more

    val a = add(1)
    val b = add(9999)
    println(a(10))
    println(b(10))
  }
}
```


## 例子二

```
var factor = 3  
val multiplier = (i:Int) => i * factor  
```

在 multiplier 中有两个变量：i 和 factor。其中的一个 i 是函数的形式参数，在 multiplier 函数被调用时，i 被赋予一个新的值。然而，factor不是形式参数，而是自由变量

这样定义的函数变量 multiplier 成为一个"闭包"，因为它引用到函数外面定义的变量，定义这个函数的过程是将这个自由变量捕获而构成一个封闭的函数。