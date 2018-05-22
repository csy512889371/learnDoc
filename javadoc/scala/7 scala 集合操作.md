# 7 scala 集合操作


## Hello list

```
object HelloList {

  def main(args: Array[String]) {

    val bigData = List("Hadoop", "Spark")
    val data = List(1, 2, 3)

    val bigData_Core = "Hadoop" :: ("Spark" :: Nil)
    val data_Int = 1 :: 2 :: 3 :: Nil

    println(data.isEmpty)
    println(data.head)
    println(data.tail.head)

    val List(a, b) = bigData
    println("a : " + a + " === " + " b: " + b)
    val x :: y :: rest = data
    println("x : " + x + " === " + " y: " + y + " === " + rest)

    val shuffledData = List(6, 3, 5, 6, 2, 9, 1)
    println(sortList(shuffledData))

    def sortList(list: List[Int]): List[Int] = list match {
      case List() => List()
      case head :: tail => compute(head, sortList(tail))
    }

    def compute(data: Int, dataSet: List[Int]): List[Int] = dataSet match {
      case List() => List(data)
      case head :: tail => if (data <= head) data :: dataSet
      else head :: compute(data, tail)
    }

  }

}
```

## List 内部函数

```
def main(args: Array[String]) {

    val list: List[Int] = List(1, 2, 3, 4, 5)
    val listAny: List[Any] = list
    println(list.isEmpty)
    println(list.head)
    println(list.tail)
    println(list.length)
    println(list.drop(2))
    list.map(_ * 2)

  }
```


## List 操作

从本质上说，fold函数将一种格式的输入数据转化成另外一种格式返回。fold, foldLeft和foldRight这三个函数除了有一点点不同外，做的事情差不多。

代码开始运行的时候，初始值0作为第一个参数传进到fold函数中，list中的第一个item作为第二个参数传进fold函数中。

```
object List_FirstOrder_Ops {

  def main(args: Array[String]) {
    println(List(1, 2, 3, 4) ::: List(4, 5, 6, 7, 8) ::: List(10, 11))
    println(List(1, 2, 3, 4) ::: (List(4, 5, 6, 7, 8) ::: List(10, 11)))
    println(List(1, 2, 3, 4).length)

    val bigData = List("Hadoop", "Spark", "Kaffka")
    println(bigData.last)
    println(bigData.init)
    println(bigData.reverse)
    println(bigData)
    println(bigData take 2)
    println(bigData drop 1)
    println(bigData splitAt 2)
    println(bigData apply 2)
    println(bigData(2))

    val data = List('a', 'b', 'c', 'd', 'e', 'f')
    println(data.indices)
    println(data.indices zip data)
    println(data.zipWithIndex)
    println(data.toString)
    println(data.mkString("[", ",,", "]"))
    println(data.mkString("******"))
    println(data mkString)

    val buffer = new StringBuilder
    data addString(buffer, "(", ";;", ")")
    println(buffer)
    println(data)

    val array = data.toArray
    println(array.toList)

    val new_Array = new Array[Char](10)
    data.copyToArray(new_Array, 3)
    new_Array.foreach(print)
    println

    val iterator = data.toIterator
    println(iterator.next)
    println(iterator.next)
  }

}
```

## List Fold Sort

```
object List_Fold_Sort {

  def main(args: Array[String]) {
    println((1 to 100).foldLeft(0)(_ + _))
    println((0 /: (1 to 100)) (_ + _))

    println((1 to 5).foldRight(100)(_ - _))
    println(((1 to 5) :\ 100) (_ - _))


    println(List(1, -3, 4, 2, 6) sortWith (_ < _))
    println(List(1, -3, 4, 2, 6) sortWith (_ > _))

  }

}

```

## List 高阶函数


```
object List_HighOrder_Funciton_Ops {

  def main(args: Array[String]) {

    println(List(1, 2, 3, 4, 6) map (_ + 1))
    val data = List("Scala", "Hadoop", "Spark")
    println(data map (_.length))
    println(data map (_.toList.reverse.mkString))

    println(data.map(_.toList))
    println(data.flatMap(_.toList))

    println(List.range(1, 10) flatMap (i => List.range(1, i) map (j => (i, j))))

    var sum = 0
    List(1, 2, 3, 4, 5) foreach (sum += _)
    println("sum : " + sum)

    println(List(1, 2, 3, 4, 6, 7, 8, 9, 10) filter (_ % 2 == 0))
    println(data filter (_.length == 5))

    println(List(1, 2, 3, 4, 5) partition (_ % 2 == 0))
    println(List(1, 2, 3, 4, 5) find (_ % 2 == 0))
    println(List(1, 2, 3, 4, 5) find (_ <= 0))
    println(List(1, 2, 3, 4, 5) takeWhile (_ < 4))
    println(List(1, 2, 3, 4, 5) dropWhile (_ < 4))
    println(List(1, 2, 3, 4, 5) span (_ < 4))

    def hastotallyZeroRow(m: List[List[Int]]) = m exists (row => row forall (_ == 0))

    val m = List(List(1, 0, 0), List(0, 1, 0), List(0, 0, 1))
    println(hastotallyZeroRow(m))

  }

}
```

## ListBuffer ArrayBuffer Queue Stack 

```

import scala.collection.immutable.Queue

object ListBuffer_ListArray_Queue_Stack {

  def main(args: Array[String]) {
    import scala.collection.mutable.ListBuffer
    val listBuffer = new ListBuffer[Int]
    listBuffer += 1
    listBuffer += 2
    println(listBuffer)

    import scala.collection.mutable.ArrayBuffer
    val arrayBuffer = new ArrayBuffer[Int]()
    arrayBuffer += 1
    arrayBuffer += 2
    println(arrayBuffer)

    val empty = Queue[Int]()
    val queue1 = empty.enqueue(1)
    val queue2 = queue1.enqueue(List(2, 3, 4, 5))
    println(queue2)
    val (element, left) = queue2.dequeue
    println(element + " : " + left)

    import scala.collection.mutable.Queue
    val queue = Queue[String]()
    queue += "a"
    queue ++= List("b", "c")
    println(queue)
    println(queue.dequeue)
    println(queue)

    import scala.collection.mutable.Stack
    val stack = new Stack[Int]
    stack.push(1)
    stack.push(2)
    stack.push(3)
    println(stack.top)
    println(stack)
    println(stack.pop)
    println(stack)


  }

}
```

## ListObjectOps

```
object ListObjectOps {

  def main(args: Array[String]) {
    println(List.apply(1, 2, 3))
    //println(List.make(3, 5))
    println(List.range(1, 5))
    println(List.range(9, 1, -3))

    val zipped = "abcde".toList zip List(1, 2, 3, 4, 5)

    println(zipped)
    println(zipped.unzip)

    println(List(List('a', 'b'), List('c'), List('d', 'e')).flatten)
    println(List.concat(List(), List('b'), List('c')))

    //println(List.map2(List(10, 20), List(10, 10)) (_ * _))

  }

}
```

## MergedSort


```
object MergedSort {

  def main(args: Array[String]) {

    def mergedsort[T](less: (T, T) => Boolean)(input: List[T]): List[T] = {

      def merge(xList: List[T], yList: List[T]): List[T] =
        (xList, yList) match {
          case (Nil, _) => yList
          case (_, Nil) => xList
          case (x :: xtail, y :: ytail) =>
            if (less(x, y)) x :: merge(xtail, yList)
            else y :: merge(xList, ytail)
        }

      val n = input.length / 2
      if (n == 0) input
      else {
        val (x, y) = input splitAt n
        merge(mergedsort(less)(x), mergedsort(less)(y))
      }
    }

    println(mergedsort((x: Int, y: Int) => x < y)(List(3, 7, 9, 5)))
    val reversed_mergedsort = mergedsort((x: Int, y: Int) => x > y) _
    println(reversed_mergedsort(List(3, 7, 9, 5)))


  }
}
```


## Set Map

```

import scala.collection.immutable.TreeMap
import scala.collection.mutable
import scala.collection.mutable.TreeSet

object Set_Map {

  def main(args: Array[String]) {

    val data = mutable.Set.empty[Int]
    data ++= List(1, 2, 3)
    data += 4;
    data --= List(2, 3);
    println(data)
    data += 1;
    println(data)
    data.clear
    println(data)

    val map = mutable.Map.empty[String, String]
    map("Java") = "Hadoop"
    map("Scala") = "Spark"
    println(map)
    println(map("Scala"))

    val treeSet = TreeSet(9, 3, 1, 8, 0, 2, 7, 4, 6, 5)
    println(treeSet)
    val treeSetForChar = TreeSet("Spark", "Scala", "Hadoop")
    println(treeSetForChar)

    var treeMap = TreeMap("Scala" -> "Spark", "Java" -> "Hadoop")
    println(treeMap)


  }

}
```