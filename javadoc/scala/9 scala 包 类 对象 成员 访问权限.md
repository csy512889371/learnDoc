# scala 包 类 对象 成员 访问权限

* 包对象
* 包 类 对象 成员 访问权限
* 伴生类 伴生对象 访问权限



## 包

```

package com.scala.spark

package object people {
  val defaultName = "Scala"
}

package people {

  class people {
    var name = defaultName
  }

}

import java.awt.{Color, Font}
import java.util.{HashMap => JavaHashMap}
import scala.{StringBuilder => _}


class PackageOps {}


package spark.navigation {

  abstract class Navigator {
    def act
  }
  package tests {

    class NavigatorSuite


  }

  package impls {

    class Action extends Navigator {
      def act = println("Action")
    }

  }

}

package hadoop {

  package navigation {

    class Navigator

  }

  package launch {

    class Booster {
      val nav = new navigation.Navigator
    }

  }

}


object PackageOps {

  def main(args: Array[String]): Unit = {

  }

}
```

## 访问权限

```
package spark {
  package navigation {

    private[spark] class Navigator {
      protected[navigation] def useStarChart() {}

      class LegOfJourney {
        private[Navigator] val distance = 100
      }

      private[this] var speed = 200
    }

  }

  package launch {

    import navigation._

    object Vehicle {

      private[launch] val guide = new Navigator
    }

  }

}

class PackageOps_Advanced {

  import PackageOps_Advanced.power

  private def canMakeItTrue = power > 10001

}

object PackageOps_Advanced {
  private def power = 10000

  def makeItTrue(p: PackageOps_Advanced): Boolean = {
    val result = p.canMakeItTrue
    result
  }
}
```