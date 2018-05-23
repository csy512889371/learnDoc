# scala 正则表达式 


## RegExpressOps

```

object RegExpressOps {

  def main(args: Array[String]): Unit = {
    
    val regex="""([0-9]+) ([a-z]+)""".r
    val numPattern = "[0-9]+".r
    val numberPattern = """\s+[0-9]+\s+""".r
    
    for (matchString <- numPattern.findAllIn("99345 Scala, 22298 Spark")) println(matchString)
 
    println(numberPattern.findFirstIn("99ss java, 222 hadoop"))
	
    	
    val numitemPattern="""([0-9]+) ([a-z]+)""".r

    val numitemPattern(num, item) = "99 hadoop"
      
    val line = "93s459 spark"
    line match{
      case numitemPattern(num, blog) => println(num + "\t" + blog)
      case _ => println("Oops...")

    }

  }

}
```