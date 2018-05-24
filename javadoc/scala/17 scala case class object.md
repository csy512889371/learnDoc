# 17 scala case class object


## 概述
> case class

* 1、case 类在编译的时候会自动增加一个 单列对象（single object）。
* 2、产生了一个apply的方法，那么我们可以直接把对象当作方法来用，比如 Person(12,Tom),就代表已经创建一个Person的对象，同时调用了這个对象的apply方法
* 3、产生了一个upapply的方法，也就是说在模式匹配的时候可以用case class Person来作为 age和name的提取器
* 4、继承了Product和Serializable（implements Product, Serializable），也就是说已经序列化和可以应用Product的方法
* 5、age和name字段都是由final 修饰，也就是说是不可改变的，那么用scala的语言来阐述，那么就是 case class 的参数默认是  immutable类型的。
* 6、也包含了toString,hashCode,copy,equals方法。

> case object

* 1、case object Person相比于case class Person(age:Int,name:String)缺少了apply、unapply方法，因为case object
是没有参数输入的，所以对于apply 和unapply的方法也自然失去。
* 2、因为class 和 object 在编译的时候，object是只有一个编译文件，而当两者加上case之后发现两者都是有2个编译文件，也就是说case object 不在像object那样仅仅是一个单列对象，而是有像类（class）一样的特性。
* 3、都有toString,hashCode,copy,equals方法和继承了Product和Serializable（implements Product, Serializable）


## 例子

```
abstract class Person

case class Student(age: Int) extends Person

case class Worker(age: Int, salary: Double) extends Person

case object Shared extends Person

object case_class_object {

  def main(args: Array[String]) {
    def caseOps(person: Person) = person match {
      case Student(age) => println("I am " + age + "years old")
      case Worker(_, salary) => println("Wow, I got " + salary)
      case Shared => println("No property")
    }

    caseOps(Student(19))
    caseOps(Shared)

    val worker = Worker(29, 10000.1)
    val worker2 = worker.copy(salary = 19.95)
    val worker3 = worker.copy(age = 30)
  }

}
```
