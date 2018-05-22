# 6 scala 基础语法 函数 高级函数 隐式转化


## 概述

* 函数 
* 高级函数 
* 隐式转化
* Curring


## Curring 

```
object Curring {

  def main(args: Array[String]) {
    def multiple(x: Int, y: Int) = x * y
    def multipleOne(x: Int) = (y: Int) => x * y
    println(multipleOne(6)(7))

    def curring(x: Int)(y: Int) = x * y

    println(curring(10)(10))

    val a = Array("Hello", "Spark")
    val b = Array("hello", "spark")
    println(a.corresponds(b)(_.equalsIgnoreCase(_)))

  }
```

## 高阶函数

```

import scala.math._

object higher_order_functions {

  def main(args: Array[String]) {

    (1 to 9).map("*" * _).foreach(println _)
    (1 to 9).filter(_ % 2 == 0).foreach(println)
    println((1 to 9).reduceLeft(_ * _))
    "Spark is the most exciting thing happening in big data today".split(" ").
      sortWith(_.length < _.length).foreach(println)


    val fun = ceil _
    val num = 3.14
    println(fun(num))
    Array(3.14, 1.42, 2.0).map(fun).foreach(println)

    val triple = (x: Double) => 3 * x
    Array(3.14, 1.42, 2.0).map((x: Double) => 3 * x)
    Array(3.14, 1.42, 2.0).map { (x: Double) => 3 * x }

    def high_order_functions(f: (Double) => Double) = f(0.25)

    println(high_order_functions(ceil _))
    println(high_order_functions(sqrt _))

    def mulBy(factor: Double) = (x: Double) => factor * x

    val quintuple = mulBy(5)
    println(quintuple(20))

    println(high_order_functions((x: Double) => 3 * x))
    high_order_functions((x) => 3 * x)
    high_order_functions(x => 3 * x)

    println(high_order_functions(3 * _))

    val fun2 = 3 * (_: Double)
    val fun3: (Double) => Double = 3 * _


  }

}
```

## 偏函数

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

## 隐式转化

```
import javax.swing.JButton
import java.awt.event.ActionListener
import java.awt.event.ActionEvent
import javax.swing.JFrame

object SAM {

  def main(args: Array[String]) {

    var data = 0
    val frame = new JFrame("SAM Testing");
    val jButton = new JButton("Counter")
    //  jButton.addActionListener(new ActionListener {
    //    override def actionPerformed(event: ActionEvent) {
    //      data += 1
    //      println(data)
    //    }
    //  })

    implicit def convertedAction(action: (ActionEvent) => Unit) =
      new ActionListener {
        override def actionPerformed(event: ActionEvent) {
          action()
        }
      }

    jButton.addActionListener((event: ActionEvent) => {
      data += 1
      println(data)
    })

    frame.setContentPane(jButton)
    frame.pack()
    frame.setVisible(true)
  }

}
```


## 伴生对象

```

class University {
  val id = University.newStudenNo
  private var number = 0

  def aClass(number: Int) {
    this.number += number
  }

  def getNumber: Int = {
    this.number
  }

}

object University {
  private var studentNo = 0

  def newStudenNo = {
    studentNo += 1
    studentNo
  }

}


object ObjecOps {

  def main(args: Array[String]): Unit = {

    println(University.newStudenNo)
    println(University.newStudenNo)

  }
}
```