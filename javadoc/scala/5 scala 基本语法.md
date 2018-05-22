# 5 scala 基本语法


## Array 代码

for yield

* 针对每一次 for 循环的迭代, yield 会产生一个值，被循环记录下来 (内部实现上，像是一个缓冲区).
* 当循环结束后, 会返回所有 yield 的值组成的集合.
* 返回集合的类型与被遍历的集合类型是一致的.

```
import scala.collection.mutable.ArrayBuffer

object ArrayOps {

  def main(args: Array[String]): Unit = {
    val nums = new Array[Int](10)
    val a = new Array[String](10)
    val s = Array("Hello", "World")
    s(0) = "Goodbye"

    val b = ArrayBuffer[Int]()
    b += 1
    b += (1, 2, 3, 5)
    b ++= Array(8, 13, 21)
    b.trimEnd(5)
    b.insert(2, 6)
    b.insert(2, 7, 8, 9)
    b.remove(2)
    b.remove(2, 3)
    b.toArray

    for (i <- 0 until a.length)
      println(i + ": " + a(i))


    val c = Array(2, 3, 5, 7, 11)
    val result = for (elem <- c) yield 2 * elem

    for (elem <- c if elem % 2 == 0) yield 2 * elem
    c.filter(_ % 2 == 0).map(2 * _)

    Array(1, 7, 2, 9).sum
    ArrayBuffer("Mary", "had", "a", "little", "lamb").max

    val d = ArrayBuffer(1, 7, 2, 9)
    val bSorted = d.sorted

    val e = Array(1, 7, 2, 9)
    scala.util.Sorting.quickSort(e)

    e.mkString(" and ")
    a.mkString("<", ",", ">")

    val matrix = Array.ofDim[Double](3, 4)
    matrix(2)(1) = 42
    val triangle = new Array[Array[Int]](10)
    for (i <- 0 until triangle.length)
      triangle(i) = new Array[Int](i + 1)

  }

}
```



## Lazy 操作

```

import scala.io.Source

object LazyOps {

  def main(args: Array[String]): Unit = {
    lazy val file = Source.fromFile("E:\\Sparkctoedu.txt")

    println("Scala")
    for (line <- file.getLines) println(line)
  }

}

```

## Map 和 Tuple

```

object Map_Tuple {

  def main(args: Array[String]): Unit = {
    val map = Map("book" -> 10, "gun" -> 18, "ipad" -> 1000)
    for ((k, v) <- map) yield (k, v * 0.9)

    val scores = scala.collection.mutable.Map("Scala" -> 7, "Hadoop" -> 8, "Spark" -> 10)
    val hadoopScore = scores.getOrElse("Hadoop", 0)
    scores += ("R" -> 9)
    scores -= "Hadoop"

    val sortedScore = scala.collection.immutable.SortedMap("Scala" -> 7, "Hadoop" -> 8, "Spark" -> 10)

    val tuple = (1, 2, 3.14, "Rocky", "Spark")
    val third = tuple._3
    val (first, second, thirda, fourth, fifth) = tuple
    val (f, s, _, _, _) = tuple

    "Rocky Spark".partition(_.isUpper)

    val symbols = Array("[", "-", "]")
    val counts = Array(2, 5, 2)
    val pairs = symbols.zip(counts)
    for ((x, y) <- pairs) print(x * y)

  }

}

```

## 函数

```
object For_Function_Advanced {

  def main(args: Array[String]): Unit = {

    for (i <- 1 to 2; j <- 1 to 2) print((100 * i + j) + "  ")
    println

    for (i <- 1 to 2; j <- 1 to 2 if i != j) print((100 * i + j) + "  ")
    println


    def addA(x: Int) = x + 100

    val add = (x: Int) => x + 200
    println("The result from a function is : " + addA(2))
    println("The result from a val is : " + add(2))

    def fac(n: Int): Int = if (n <= 0) 1 else n * fac(n - 1)

    println("The result from a fac is : " + fac(10))

    def combine(content: String, left: String = "[", right: String = "]") = left + content + right

    println("The result from a combine is : " + combine("I love Spark", "<<"))

    def connected(args: Int*) = {
      var result = 0
      for (arg <- args) result += arg
      result
    }

    println("The result from a connected is : " + connected(1, 2, 3, 4, 5, 6))

  }


}
```
