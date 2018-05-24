# 16 scala 模式匹配

## 概述

Scala的模式匹配发生在但绝不仅限于发生在match case语句块中，这是Scala模式匹配之所以重要且有用的一个关键因素

> 模式匹配的种类

在Scala中一共有如下几种类型的模式匹配：

* 通配符匹配（Wildcard Pattern Matching ）
* 常量匹配 （Constant Pattern Matching ）
* 变量匹配（Variable Pattern Matching ）
* 构造函数匹配（Constructor Pattern Matching ）
* 集合类型匹配（Sequence Pattern Matching ）
* 元祖类型匹配（Tuple Pattern Matching ）
* 类型匹配（Typed Pattern Matching ）

## 例子

* 模式匹配 match case 后是函数
* 模式匹配的附加约束（Guard），用if语句来限定匹配条件

```
object Hello_Pattern_Match {

  def main(args: Array[String]) {
    val data = 2
    data match {
      case 1 => println("First")
      case 2 => println("Second")
      case _ => println("Not Known Number")
    }

    val result = data match {
      case i if i == 1 => "The First"
      case number if number == 2 => "The Second" + number
      case _ => "Not Known Number"
    }
    println(result)

    "Spark !" foreach { c =>
      println(
        c match {
          case ' ' => "space"
          case ch => "Char: " + ch
        }
      )
    }


  }

}
```


## 例子二


```
object PatternMatchingDemo {

    case class Person(firstName: String, lastName: String)
    case class Dog(name: String)

    def echoWhatYouGaveMe(x: Any): String = x match {
        // constant patterns
        case 0 => "zero"
        case true => "true"
        case "hello" => "you said 'hello'"
        case Nil => "an empty List"
        // sequence patterns
        case List(0, _, _) => "a three-element list with 0 as the first element"
        case List(1, _*) => "a list beginning with 1, having any number of elements"
        case Vector(1, _*) => "a vector starting with 1, having any number of elements"
        // tuples
        case (a, b) => s"got $a and $b"
        case (a, b, c) => s"got $a, $b, and $c"
        // constructor patterns
        case Person(first, "Alexander") => s"found an Alexander, first name = $first"
        case Dog("Suka") => "found a dog named Suka"
        // typed patterns
        case s: String => s"you gave me this string: $s"
        case i: Int => s"thanks for the int: $i"
        case f: Float => s"thanks for the float: $f"
        case a: Array[Int] => s"an array of int: ${a.mkString(",")}"
        case as: Array[String] => s"an array of strings: ${as.mkString(",")}"
        case d: Dog => s"dog: ${d.name}"
        case list: List[_] => s"thanks for the List: $list"
        case m: Map[_, _] => m.toString
        // the default wildcard pattern
        case _ => "Unknown"
    }

    def main(args: Array[String]) {
        // trigger the constant patterns
        println(echoWhatYouGaveMe(0))
        println(echoWhatYouGaveMe(true))
        println(echoWhatYouGaveMe("hello"))
        println(echoWhatYouGaveMe(Nil))
        // trigger the sequence patterns
        println(echoWhatYouGaveMe(List(0,1,2)))
        println(echoWhatYouGaveMe(List(1,2)))
        println(echoWhatYouGaveMe(List(1,2,3)))
        println(echoWhatYouGaveMe(Vector(1,2,3)))
        // trigger the tuple patterns
        println(echoWhatYouGaveMe((1,2))) // two element tuple
        println(echoWhatYouGaveMe((1,2,3))) // three element tuple
        // trigger the constructor patterns
        println(echoWhatYouGaveMe(Person("Melissa", "Alexander")))
        println(echoWhatYouGaveMe(Dog("Suka")))
        // trigger the typed patterns
        println(echoWhatYouGaveMe("Hello, world"))
        println(echoWhatYouGaveMe(42))
        println(echoWhatYouGaveMe(42F))
        println(echoWhatYouGaveMe(Array(1,2,3)))
        println(echoWhatYouGaveMe(Array("coffee", "apple pie")))
        println(echoWhatYouGaveMe(Dog("Fido")))
        println(echoWhatYouGaveMe(List("apple", "banana")))
        println(echoWhatYouGaveMe(Map(1->"Al", 2->"Alexander")))
        // trigger the wildcard pattern
        println(echoWhatYouGaveMe("33d"))
    }
}
```

## 例子四

```
object Pattern_Match_More {

  def main(args: Array[String]) {

    def match_type(t: Any) = t match {
      case p: Int => println("It is Integer")
      case p: String => println("It is String, the content is : " + p)
      case m: Map[_, _] => m.foreach(println)
      case _ => println("Unknown type!!!")
    }

    match_type(2)
    match_type("Spark")
    match_type(Map("Scala" -> "Spark"))

    def match_array(arr: Any) = arr match {
      case Array(0) => println("Array:" + "0")
      case Array(x, y) => println("Array:" + x + " " + y)
      case Array(0, _*) => println("Array:" + "0 ...")
      case _ => println("something else")
    }

    match_array(Array(0))
    match_array(Array(0, 1))
    match_array(Array(0, 1, 2, 3, 4, 5))


    def match_list(lst: Any) = lst match {
      case 0 :: Nil => println("List:" + "0")
      case x :: y :: Nil => println("List:" + x + " " + y)
      case 0 :: tail => println("List:" + "0 ...")
      case _ => println("something else")
    }

    match_list(List(0))
    match_list(List(3, 4))
    match_list(List(0, 1, 2, 3, 4, 5))


    def match_tuple(tuple: Any) = tuple match {
      case (0, _) => println("Tuple:" + "0")
      case (x, 0) => println("Tuple:" + x)
      case _ => println("something else")
    }

    match_tuple((0, "Scala"))
    match_tuple((2, 0))
    match_tuple((0, 1, 2, 3, 4, 5))

  }

}
```


## 例子五

从元组中提取变量

```
val (number,string)=(1,"a")

```


从构造器中提取额变量

```
val Person(name,age)=Person("John",30)
```

```
def main(args: Array[String]) {
    val Array(arg1,agr2)=args
    .....
}
```

for循环中的模式匹配

```
for ((country, city) <- capitals)
```
