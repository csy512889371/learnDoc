# Python3 函数

函数能提高应用的模块性，和代码的重复利用率。
* 函数
* 匿名函数
* type函数
* 闭包


# 一、函数
## 1、定义一个函数

* 函数代码块以 def 关键词开头，后接函数标识符名称和圆括号 ()
* 任何传入参数和自变量必须放在圆括号中间，圆括号之间可以用于定义参数
* 函数的第一行语句可以选择性地使用文档字符串—用于存放函数说明
* 函数内容以冒号起始，并且缩进
* return [表达式] 结束函数，选择性地返回一个值给调用方。不带表达式的return相当于返回 None


```python
def 函数名（参数列表）:
    函数体
	
	
>>> def hello() :
print("Hello World!")

>>> hello()
Hello World!

```

## 2、参数传递

1) 可更改(mutable)与不可更改(immutable)对象

在 python 中，strings, tuples, 和 numbers 是不可更改的对象，而 list,dict 等则是可以修改的对象

* 不可变类型：变量赋值 a=5 后再赋值 a=10，这里实际是新生成一个 int 值对象 10，再让 a 指向它，而 5 被丢弃，不是改变a的值，相当于新生成了a。
* 可变类型：变量赋值 la=[1,2,3,4] 后再赋值 la[2]=5 则是将 list la 的第三个元素值更改，本身la没有动，只是其内部的一部分值被修改了。

2) python 函数的参数传递:

- **不可变类型**：类似 c++ 的值传递，如 整数、字符串、元组。如fun（a），传递的只是a的值，没有影响a对象本身。比如在 fun（a）内部修改 a 的值，只是修改另一个复制的对象，不会影响 a 本身。
- **可变类型**：类似 c++ 的引用传递，如 列表，字典。如 fun（la），则是将 la 真正的传过去，修改后fun外部的la也会受影响


python 中一切都是对象，严格意义我们不能说值传递还是引用传递，我们应该说传不可变对象和传可变对象。


## 3、参数
* 必需参数
* 关键字参数
* 默认参数
* 不定长参数

关键字参数,以下实例中演示了函数参数的使用不需要使用指定顺序

```python
#可写函数说明
def printinfo( name, age ):
   "打印任何传入的字符串"
   print ("名字: ", name);
   print ("年龄: ", age);
   return;
 
#调用printinfo函数
printinfo( age=50, name="runoob" );
```

默认参数,调用函数时，如果没有传递参数，则会使用默认参数。
```python

#可写函数说明
def printinfo( name, age = 35 ):
   "打印任何传入的字符串"
   print ("名字: ", name);
   print ("年龄: ", age);
   return;
 
#调用printinfo函数
printinfo( age=50, name="runoob" );
print ("------------------------")
printinfo( name="runoob" );
```

不定长参数

```python
# 可写函数说明
def printinfo( arg1, *vartuple ):
   "打印任何传入的参数"
   print ("输出: ")
   print (arg1)
   for var in vartuple:
      print (var)
   return;
 
# 调用printinfo 函数
printinfo( 10 );
printinfo( 70, 60, 50 );
```

## 4、return语句

return [表达式] 语句用于退出函数，选择性地向调用方返回一个表达式。不带参数值的return语句返回None

## 5、变量作用域
变量的作用域决定了在哪一部分程序可以访问哪个特定的变量名称。Python的作用域一共有4种，分别是：
* L （Local） 局部作用域
* E （Enclosing） 闭包函数外的函数中
* G （Global） 全局作用域
* B （Built-in） 内建作用域
以 L –> E –> G –>B 的规则查找，即：在局部找不到，便会去局部外的局部找（例如闭包），再找不到就会去全局找，再者去内建中找。


```python
x = int(2.9)  # 内建作用域
 
g_count = 0  # 全局作用域
def outer():
    o_count = 1  # 闭包函数外的函数中
    def inner():
        i_count = 2  # 局部作用域
		
```

Python 中只有模块（module），类（class）以及函数（def、lambda）才会引入新的作用域，其它的代码块（如 if/elif/else/、try/except、for/while等）是不会引入新的作用域的

## 6、global 和 nonlocal关键字
当内部作用域想修改外部作用域的变量时，就要用到global和nonlocal关键字了。


global
```python
num = 1
def fun1():
    global num  # 需要使用 global 关键字声明
    print(num) 
    num = 123
    print(num)
fun1()
```

nonlocal

```python
def outer():
    num = 10
    def inner():
        nonlocal num   # nonlocal关键字声明
        num = 100
        print(num)
    inner()
    print(num)
outer()
```


# 二、匿名函数

python 使用 lambda 来创建匿名函数，所谓匿名，意即不再使用 def 语句这样标准的形式定义一个函数

* lambda 只是一个表达式，函数体比 def 简单很多。
* lambda的主体是一个表达式，而不是一个代码块。仅仅能在lambda表达式中封装有限的逻辑进去。
* lambda 函数拥有自己的命名空间，且不能访问自己参数列表之外或全局命名空间里的参数。

```python
lambda [arg1 [,arg2,.....argn]]:expression
```

例子
```python
# 可写函数说明
sum = lambda arg1, arg2: arg1 + arg2;
 
# 调用sum函数
print ("相加后的值为 : ", sum( 10, 20 ))
print ("相加后的值为 : ", sum( 20, 20 ))
```


# 三、type() 函数

type() 函数如果你只有第一个参数则返回对象的类型，三个参数返回新的类型对象

```python

isinstance() 与 type() 区别：
	type() 不会认为子类是一种父类类型，不考虑继承关系。
	isinstance() 会认为子类是一种父类类型，考虑继承关系。
如果要判断两个类型是否相同推荐使用 isinstance()。
```

语法

```python
class type(name, bases, dict)

```
* name -- 类的名称。
* bases -- 基类的元组。
* dict -- 字典，类内定义的命名空间变量。

```python
# 一个参数实例
>>> type(1)
<type 'int'>
>>> type('runoob')
<type 'str'>
>>> type([2])
<type 'list'>
>>> type({0:'zero'})
<type 'dict'>
>>> x = 1          
>>> type( x ) == int    # 判断类型是否相等
True
 
# 三个参数
>>> class X(object):
...     a = 1
...
>>> X = type('X', (object,), dict(a=1))  # 产生一个新的类型 X
>>> X
<class '__main__.X'>
```

type() 与 isinstance()区别：

```python
class A:
    pass
 
class B(A):
    pass
 
isinstance(A(), A)    # returns True
type(A()) == A        # returns True
isinstance(B(), A)    # returns True
type(B()) == A        # returns False

```

# 四、闭包

总结出在python语言中形成闭包的三个条件，缺一不可：

1) 必须有一个内嵌函数(函数里定义的函数）——这对应函数之间的嵌套
2) 内嵌函数必须引用一个定义在闭合范围内(外部函数里)的变量——内部函数引用外部变量
3) 外部函数必须返回内嵌函数——必须返回那个内部函数

```python
def funx():
    x=5
    def funy():
        nonlocal x
        x+=1
        return x
    return funy
```

我们根据上面的三准则创造了一个函数，其中的funy就是所谓的闭包，而funy内部所引用过的x就是所谓的闭包变量

## 闭包有什么用

```python
>>> a=funx()
>>> a()
6
>>> a()
7
>>> a()
8
>>> a()
9
>>> x
Traceback (most recent call last):
  File "<pyshell#19>", line 1, in <module>
    x
NameError: name 'x' is not defined
>>> 
```

* 我们会发现，funx中的x变量原本仅仅是funx的一个局部变量。但是形成了闭包之后，它的行为就好像是一个全局变量一样
* 但是最后的错误说明x并不是一个全局变量。其
* 实这就是闭包的一个十分浅显的作用，形成闭包之后，闭包变量能够随着闭包函数的调用而实时更新，就好像是一个全局变量那样。

## 进一步探究

```python
>>> a.__closure__
(<cell at 0x0000002F346FB408: int object at 0x00000000667D02D0>,)
>>> type(a.__closure__)
<class 'tuple'>
>>> type(a.__closure__[0])
<class 'cell'>
>>> a.__closure__[0].cell_contents
9
>>> a()
10
>>> a.__closure__[0].cell_contents
10
>>> def test():pass

>>> test.__closure__==None
True
>>> 
```
* 这样我们就明白了，形成闭包之后，闭包函数会获得一个非空的__closure__属性（对比我们最后的函数test，test是一个不具备闭包的函数，它的__closure__属性是None），这个属性是一个元组。
* 元组里面的对象为cell对象，而访问cell对象的cell_contents属性则可以得到闭包变量的当前值（即上一次调用之后的值）。
* 而随着闭包的继续调用，变量会再次更新。
* 所以可见，一旦形成闭包之后，python确实会将__closure__和闭包函数绑定作为储存闭包变量的场所。







