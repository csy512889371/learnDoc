= 22 scala 笔记

== 隐式类

```

import java.io.File

import scala.io.Source

object Context_Helper {

  implicit class FileEnhancer(file: File) {
    def read = Source.fromFile(file.getPath).mkString
  }

  implicit class Op(x: Int) {
    def addSAP(second: Int) = x + second
  }

}

object Implicits_Class {

  def main(args: Array[String]) {
    import Context_Helper._
    println(1.addSAP(2))
    println(new File("E:\\ctoedu.txt").read)

  }

}
```

== 隐式对象

```
abstract class Template[T] {
  def add(x: T, y: T): T
}

abstract class SubTemplate[T] extends Template[T] {
  def unit: T
}

object Implicits_Object {

  def main(args: Array[String]) {
    implicit object StringAdd extends SubTemplate[String] {
      override def add(x: String, y: String) = x concat y

      override def unit: String = ""
    }
    implicit object IntAdd extends SubTemplate[Int] {
      override def add(x: Int, y: Int) = x + y

      override def unit: Int = 0
    }
    def sum[T](xs: List[T])(implicit m: SubTemplate[T]): T =
      if (xs.isEmpty) m.unit
      else m.add(xs.head, sum(xs.tail))

    println(sum(List(1, 2, 3, 4, 5)))
    println(sum(List("Scala", "Spark", "Kafka")))

  }

}
```


== 隐式最佳使用

```

import scala.io.Source
import java.io.File

class RicherFile(val file:File){
   def read = Source.fromFile(file.getPath()).mkString
}
 
class File_Implicits( path: String) extends File(path)
object File_Implicits{
    implicit def file2RicherFile(file:File)= new RicherFile(file) //File -> RicherFile
}

object Implicits_Internals {
	def main(args: Array[String]) {
		println(new File_Implicits("E:\\ctoedu.txt").read)
	}
} 

```