# 8 scala 对象 

## 概述

* Override 覆盖操作
* 抽象类 抽象字段 抽象方法
* trait

## Override 覆盖操作

```
class OverrideOperations {

}

class Person1(val name: String, var age: Int) {
  println("The primary constructor of Person")

  val school = "BJU"

  def sleep = "8 hours"

  override def toString = "I am a Person1!"
}

class Worker(name: String, age: Int, val salary: Long) extends Person1(name, age) {
  println("This is the subClass of Person, Primary constructor of Worker")
  override val school = "Spark"

  override def toString = "I am a Worker!" + super.sleep
}

object OverrideOperations {
  def main(args: Array[String]) {

    val w = new Worker("Spark", 5, 100000)
    println("School :" + w.school)
    println("Salary :" + w.salary)
    println(w.toString())

  }

}
```


## 抽象类 抽象字段 抽象方法


```

class AbstractClassOps {
  var id: Int = _
}

abstract class SuperTeacher(val name: String) {
  var id: Int
  var age: Int

  def teach
}

class TeacherForMaths(name: String) extends SuperTeacher(name) {
  override var id: Int = name.hashCode()
  override var age: Int = 29

  override def teach: Unit = {
    println("Teaching!!!")
  }
}


object AbstractClassOps {
  def main(args: Array[String]) {
    val teacher = new TeacherForMaths("Spark")
    teacher.teach

    println("teacher.id" + ":" + teacher.id)
    println(teacher.name + ":" + teacher.age)

  }
}

```


## trait

对象混入 trait

```
class UseTrait {

}

trait Logger {
  //  def log (msg : String)
  def log(msg: String): Unit = {
    println("logger")
  }
}

class ConcreteLogger extends Logger with Cloneable {

  override def log(msg: String) = println("Log: " + msg)

  def concreteLog {
    log("It's me !!!")
  }
}

trait TraitLogger extends Logger {
  override def log(msg: String) {
    println(" TraitLogger Log content is : " + msg)
  }
}

trait TraitLoggered {
  def loged(msg: String) {
    println("TraitLoggered Log content is : " + msg)
  }
}

trait ConsoleLogger extends TraitLogger {
  override def log(msg: String) {
    println("Log from Console :" + msg)
  }
}

class Test extends ConsoleLogger {
  def test {
    log("Here is Spark!!!")
  }

}

abstract class Account {
  def save
}

class MyAccount extends Account with ConsoleLogger {
  def save {
    log("11")
  }
}

class Human {
  println("Human")

  def go = {
    println("go go go")
  }
}

trait TTeacher extends Human {
  println("TTeacher")

  def teach
}

trait PianoPlayer extends Human {
  println("PianoPlayer")

  def playPiano = {
    println("Im playing piano. ")
  }
}

class PianoTeacher extends Human with TTeacher with PianoPlayer {
  override def teach = {
    println("Im training students. ")
  }
}

//AOP
trait Action {
  def doAction
}

trait TBeforeAfter extends Action {
  abstract override def doAction {
    println("Initialization")
    super.doAction
    println("Destroyed")
  }
}

class Work extends Action {
  override def doAction = println("Working...")
}

object UseTrait extends App {
  val t1 = new PianoTeacher
  t1.playPiano
  t1.go
  t1.teach

  val t2 = new Human with TTeacher with PianoPlayer {
    def teach = {
      println("I'm teaching students.")
    }
  }
  t2.playPiano
  t2 teach


  val work = new Work with TBeforeAfter
  work.doAction

  val logger = new ConcreteLogger with TraitLogger
  //  val logger = new ConcreteLogger
  //logger.concreteLog
  //val logger = new Test
  //logger.test;

  val account = new MyAccount with TraitLoggered
  account.save

}
```


