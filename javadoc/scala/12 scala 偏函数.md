# 12 scala 偏函数


## 偏函数

偏函数(Partial Function)，是一个数学概念它不是"函数"的一种, 它跟函数是平行的概念。

Scala中的Partia Function是一个Trait，其的类型为PartialFunction[A,B]，其中接收一个类型为A的参数，返回一个类型为B的结果。


```

object PartialAppliedFuntion {

  def main(args: Array[String]){
    val data = List(1, 2, 3, 4, 5, 6)
    data.foreach(println _)
    data.foreach(x => println(x))
    
    def sum(a: Int, b: Int, c: Int) = a + b + c
    println(sum(1, 2, 3))

    val fp_a = sum _
    println(fp_a(1, 2, 3))
    println(fp_a.apply(1, 2, 3))
    val fp_b = sum(1, _: Int, 3)
    println(fp_b(2))
    println(fp_b(10))
    
    data.foreach(println _)
    data.foreach(println)
  }

}

```

偏函数内部有一些方法，比如isDefinedAt、OrElse、 andThen、applyOrElse等等。


