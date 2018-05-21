# 4、scala学习 tuple Array Map

## tuple

```
  def main(args: Array[String]): Unit = {
    
    val triple = (100, "Scala", "Spark")
    println(triple._1)
    println(triple._2)
    println(triple._3)

  }
```

## Array

```

  def main(args: Array[String]) {

    val array = Array(1, 2, 3, 4, 5)
    //    for(i <- 0 until array.length){
    //      println(array(i))
    //    }

    for (elem <- array) println(elem)

  }
```

## Map

```
object MapOperations {
  def main(args: Array[String]) {

    val ages = Map("Rocky" -> 27, "Spark" -> 5)

    //		for((k,v) <- ages){
    //		  println("Key is " + k + ",value is " + v)
    //		}

    for ((k, _) <- ages) { //placeholder
      println("Key is " + k)
    }
    
  }
}
```

## File

```
import scala.io.Source

object FileOps {
  def main(args: Array[String]) {
    //		val file = Source.fromFile("E:\\ctoedu.txt")
    val file = Source.fromURL("http://spark.apache.org/")
    for (line <- file.getLines) {
      println(line)
    }
  }
}
```