# 13 scala 闭包


## 闭包

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

