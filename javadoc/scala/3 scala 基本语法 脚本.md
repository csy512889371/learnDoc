
# 3 scala 基本语法 脚本

## 学习脚本

```
object ScalaBasics {

  //    def looper(x : Long, y : Long) : Long = {
  //    var a = x
  //    var b = y
  //    while(a != 0){
  //      val temp = a
  //      a = b % a
  //      b = temp
  //    }
  //    b
  //  }


  //	  var line = ""
  //	  do {
  //	    println("Please input some words blow......")
  //	    line = readLine()
  //	    println("Read: " + line)
  //	  } while (line != "")


  //
  //
  //
  //
  //
  //  def doWhile(){
  //	  var line = ""
  //			  do {
  //				  line = readLine()
  //				  println("Read: " + line)
  //			  } while (line != "")
  //  }


  def main(args: Array[String]) {

    //    println("This is Spark!!!")
    //    for(arg<-args) println(arg)


    //    var file = "scala.txt"
    //    if (!args.isEmpty) file = args(0)
    //    val file = if(!args.isEmpty) args(0) else "scala.xml"
    ////
    //    println(file)

    //    println(if(!args.isEmpty) args(0) else "Spark.xml")

    //    println(looper(100, 298))
    //    doWhile
    //
    //	for (i <- 1 to 10) {
    //	  println("Number is :" + i)
    //	}
    ////
    //	val files = (new java.io.File(".")).listFiles()
    //	for (file <- files){
    //	  println(file)
    //	}
    //
    //


    val n = 99
    //    val file = "Spark.txt"
    //    openFile(file)
    try {
      val half = if (n % 2 == 0) n / 2 else
        throw new RuntimeException("N must be event")
      // Use the file
    } catch {
      case e: Exception => println("The exception is :" + e.getMessage())
    } finally {
      //      close(file)
    }

  }

}
```


