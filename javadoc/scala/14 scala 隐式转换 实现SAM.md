# 14 scala 隐式转换 实现SAM

## 概述

* 在Scala中，要某个函数做某件事时，会传一个函数参数给它。 
* 而在Java中，并不支持传送参数。通常Java的实现方式是将动作放在一个实现某接口的类中， 然后将该类的一个实例传递给另一个方法。很多时候，这些接口只有单个抽象方法（single abstract method）， 在Java中被称为SAM类型。 



```
object SAM {

  def main(args: Array[String]) {

    var data = 0
    val frame = new JFrame("SAM Testing");
    val jButton = new JButton("Counter")
    //	jButton.addActionListener(new ActionListener {
    //	  override def actionPerformed(event: ActionEvent) {
    //	    data += 1
    //	    println(data)
    //	  }
    //	})

    implicit def convertedAction(action: (ActionEvent) => Unit) =
      new ActionListener {
        override def actionPerformed(event: ActionEvent) {
          action(event)
        }
      }
    //
    jButton.addActionListener((event: ActionEvent) => {
      data += 1;
      println(data)
    })

    frame.setContentPane(jButton);
    frame.pack();
    frame.setVisible(true);
  }

}
```

* scala方式: 隐式转换,将一种类型自动转换成另外一种类型，是个函数。 
* 因为在Scala中，函数是头等公民，所以隐式转换的作用也大大放大了。 
* 将这个函数和界面代码放在一起，就可以在所有预期ActionListener对象的地方，传入(ActionEvent)=>Unit函数参数。 