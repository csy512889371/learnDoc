# jvm内存运行机制以及参数配置
* 方法区 Method
* 堆Heap
* 虚拟机栈 Virtual Machine Stack
* 本地方法堆栈 Native Method Stack
* 程序计数器 Program Counter Register

## 一、方法区 Method

* 存放虚拟机加载的类信息、常量、静态变量即时编译器编译后的代码等数据
* 通过-XX:permSize和-XX:MaxPermSize设置该空间大小
* 当方法区无法满足内存分配需求时就会抛出OutOfMemoryError

## 二、堆Heap

* 虚拟机管理的最大的一块内存，同时也是被所有线程所共享的。
* 它在虚拟机启动时创建，存在的意义就是存放对象实例
* 几乎所有的对象实例以及数组都要在这里分配内存
* 这里存放的对象被自动管理，也就是俗称的GC(GarbageCollector)所管理
* Java堆的容量可以通过-Xmx和-Xms参数调整空间大小
* 堆所使用的内存不需要保证是物理连续的，只要逻辑上是连续的既可
* 如果堆中没有可用内存完成实例分配并且堆无法扩展这时就会抛OutOfMemoryError

## 三、虚拟机栈 Virtual Machine Stack

* 虚拟机栈描述的是Java方法执行的内存模型
* 每个方法被执行的时候都会同时创建一个堆桢（StackFrame）用于存储局部变量表、操作数栈、动态链接、方法出口等信息。
* 通过-Xss参数可设置栈大小


## 四、本地方法堆栈 Native Method Stack
* 本地方法栈与虚拟机作用相似，后者为虚拟机执行Java方法服务、而前者为虚拟机用到的Native方法服务。
* 虚拟机规范对于本地方法栈中方法使用的语言 使用方法和数据结构没有强制规定，甚至有的虚拟机（比如HotSpot）直接把二者合二为一

## 五、 程序计数器 Program Counter Register
当前线程程序执行的字节码所在行号指示器，如果当前的是基本方法，指示器对应的值为undefined.

## 六、运行时常量池（Runtime Constant Pool）

* 它是方法区的一部分。Class文件中除了有类的版本、字段、方法、接口等描述信息外，还有一项信息是常量池（ConstantPool Table）,用于存放编译期生成的各种字面量和符号引用
* 这部分内容将在类加载后存放到方法区的运行时常量池中

## 图

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/vm/1.png)










