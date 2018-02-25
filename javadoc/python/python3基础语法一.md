# Python 3


# 基础语法

## python保留字

```python
>>> import keyword
>>> keyword.kwlist
['False', 'None', 'True', 'and', 'as', 'assert', 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except', 'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is', 'lambda', 'nonlocal', 'not', 'or', 'pass', 'raise', 'return', 'try', 'while', 'with', 'yield']

```

## 注释

> Python中单行注释以 # 开头

```python
# 第一个注释
print ("Hello, Python!") # 第二个注释
```

多行注释可以用多个 # 号，还有 ''' 和 """

```python
# 第一个注释
# 第二个注释

'''
第三注释
第四注释
'''

"""
第五注释
第六注释
"""
```

## 行与缩进

>* python最具特色的就是使用缩进来表示代码块，不需要使用大括号({})。
>* 缩进的空格数是可变的，但是同一个代码块的语句必须包含相同的缩进空格数。实例如下：

```python

if True:
    print ("True")
else:
    print ("False")
```

## 多行语句

Python 通常是一行写完一条语句，但如果语句很长，我们可以使用反斜杠(\)来实现多行语句，例如

```python

total = item_one + \
        item_two + \
        item_three
```

在 [], {}, 或 () 中的多行语句，不需要使用反斜杠(\)，例如:

```python

total = ['item_one', 'item_two', 'item_three',
        'item_four', 'item_five']
```

## 数据类型

python中数有四种类型：整数、长整数、浮点数和复数

>* 整数， 如 1
>* 长整数 是比较大的整数
>* 浮点数 如 1.23、3E-2
>* 复数 如 1 + 2j、 1.1 + 2.2j

## 字符串

>* python中单引号和双引号使用完全相同。
>* 使用三引号('''或""")可以指定一个多行字符串。
>* 转义符 '\'
>* 自然字符串， 通过在字符串前加r或R。 如 r"this is a line with \n" 则\n会显示，并不是换行。
>* python允许处理unicode字符串，加前缀u或U， 如 u"this is an unicode string"。
>* 字符串是不可变的。
>* 按字面意义级联字符串，如"this " "is " "string"会被自动转换为this is string。

```python

word = '字符串'
sentence = "这是一个句子。"
paragraph = """这是一个段落，
可以由多行组成"""
```

## 空行

>* 函数之间或类的方法之间用空行分隔，表示一段新的代码的开始。类和函数入口之间也用一行空行分隔，以突出函数入口的开始。
>* 空行与代码缩进不同，空行并不是Python语法的一部分。书写时不插入空行，Python解释器运行也不会出错。但是空行的作用在于分隔两段不同功能或含义的代码，便于日后代码的维护或重构。
>* 记住：空行也是程序代码的一部分。


## 等待用户输入

执行下面的程序在按回车键后就会等待用户输入

```python
input("\n\n按下 enter 键后退出。")

```

## 同一行显示多条语句

Python可以在同一行中使用多条语句，语句之间使用分号(;)分割，以下是一个简单的实例：

```python

import sys; x = 'runoob'; sys.stdout.write(x + '\n')
```

## 多个语句构成代码组

```python
if expression : 
   suite
elif expression : 
   suite 
else : 
   suite

```
## Print 输出
print 默认输出是换行的，如果要实现不换行需要在变量末尾加上 end=""：
```python
x="a"
y="b"
# 换行输出
print( x )
print( y )

print('---------')
# 不换行输出
print( x, end=" " )
print( y, end=" " )
print()
```

## import 与 from...import

>* 在 python 用 import 或者 from...import 来导入相应的模块。
>* 将整个模块(somemodule)导入，格式为： import somemodule
>* 从某个模块中导入某个函数,格式为： from somemodule import somefunction
>* 从某个模块中导入多个函数,格式为： from somemodule import firstfunc, secondfunc, thirdfunc
>* 将某个模块中的全部函数导入，格式为： from somemodule import *

### 导入 sys 模块

```python

import sys
print('================Python import mode==========================');
print ('命令行参数为:')
for i in sys.argv:
    print (i)
print ('\n python 路径为',sys.path)
```

### 导入 sys 模块的 argv,path 成员

```python

from sys import argv,path  #  导入特定的成员
 
print('================python from import===================================')
print('path:',path) # 因为已经导入path成员，所以此处引用时不需要加sys.path
```

# Python3 基本数据类型

>* Python 中的变量不需要声明。每个变量在使用前都必须赋值，变量赋值以后该变量才会被创建。
>* 在 Python 中，变量就是变量，它没有类型，我们所说的"类型"是变量所指的内存中对象的类型。
>* 等号（=）用来给变量赋值。
>* 等号（=）运算符左边是一个变量名,等号（=）运算符右边是存储在变量中的值。例如

```python
counter = 100          # 整型变量
miles   = 1000.0       # 浮点型变量
name    = "runoob"     # 字符串

```

## 多个变量赋值

> Python允许你同时为多个变量赋值。例如：

```python
a = b = c = 1
```
以上实例，创建一个整型对象，值为1，三个变量被分配到相同的内存空间上。

```python
a, b, c = 1, 2, "runoob"
```

## 标准数据类型

Python3 中有六个标准的数据类型：

>* Number（数字）
>* String（字符串）
>* List（列表）
>* Tuple（元组）
>* Sets（集合）
>* Dictionary（字典）

### Number（数字）

>* Python3 支持 int、float、bool、complex（复数）。
>* 在Python 3里，只有一种整数类型 int，表示为长整型，没有 python2 中的 Long。
>* 像大多数语言一样，数值类型的赋值和计算都是很直观的。
>* 内置的 type() 函数可以用来查询变量所指的对象类型。

```python
>>> a, b, c, d = 20, 5.5, True, 4+3j
>>> print(type(a), type(b), type(c), type(d))
```
此外还可以用 isinstance 来判断

```python
>>>a = 111
>>> isinstance(a, int)
True

```

### isinstance 和 type 的区别在于

```python
class A:
    pass

class B(A):
    pass

isinstance(A(), A)  # returns True
type(A()) == A      # returns True
isinstance(B(), A)    # returns True
type(B()) == A        # returns False

```
区别就是:
>* type()不会认为子类是一种父类类型。
>* isinstance()会认为子类是一种父类类型。

> Python3 中，把 True 和 False 定义成关键字了，但它们的值还是 1 和 0，它们可以和数字相加。


使用del语句删除一些对象引用
```python

del var
del var_a, var_b
```

## 数值运算

```python

>>>5 + 4  # 加法
9
>>> 4.3 - 2 # 减法
2.3
>>> 3 * 7  # 乘法
21
>>> 2 / 4  # 除法，得到一个浮点数
0.5
>>> 2 // 4 # 除法，得到一个整数
0
>>> 17 % 3 # 取余 
2
>>> 2 ** 5 # 乘方
32
```

注意：
>* 1、Python可以同时为多个变量赋值，如a, b = 1, 2。
>* 2、一个变量可以通过赋值指向不同类型的对象。
>* 3、数值的除法（/）总是返回一个浮点数，要获取整数使用//操作符。
>* 4、在混合计算时，Python会把整型转换成为浮点数。

## String（字符串）
> Python中的字符串用单引号(')或双引号(")括起来，同时使用反斜杠(\)转义特殊字符。

```python

str = 'Runoob'
 
print (str)          # 输出字符串
print (str[0:-1])    # 输出第一个到倒数第二个的所有字符
print (str[0])       # 输出字符串第一个字符
print (str[2:5])     # 输出从第三个开始到第五个的字符
print (str[2:])      # 输出从第三个开始的后的所有字符
print (str * 2)      # 输出字符串两次
print (str + "TEST") # 连接字符串
```
Python 使用反斜杠(\)转义特殊字符，如果你不想让反斜杠发生转义，可以在字符串前面添加一个 r，表示原始字符串


```python
>>> print('Ru\noob')
Ru
oob
>>> print(r'Ru\noob')
Ru\noob
>>> 
```

另外，反斜杠(\)可以作为续行符，表示下一行是上一行的延续。也可以使用 """...""" 或者 '''...''' 跨越多行。


## List（列表）

```python

list = [ 'abcd', 786 , 2.23, 'runoob', 70.2 ]
tinylist = [123, 'runoob']
 
print (list)            # 输出完整列表
print (list[0])         # 输出列表第一个元素
print (list[1:3])       # 从第二个开始输出到第三个元素
print (list[2:])        # 输出从第三个元素开始的所有元素
print (tinylist * 2)    # 输出两次列表
print (list + tinylist) # 连接列表
```
List内置了有很多方法，例如append()、pop()等等

>* 1、List写在方括号之间，元素用逗号隔开。
>* 2、和字符串一样，list可以被索引和切片。
>* 3、List可以使用+操作符进行拼接。
>* 4、List中的元素是可以改变的。

## Tuple（元组）

>* 元组（tuple）与列表类似，不同之处在于元组的元素不能修改。元组写在小括号(())里，元素之间用逗号隔开。
>* 元组中的元素类型也可以不相同：

```python

tuple = ( 'abcd', 786 , 2.23, 'runoob', 70.2  )
tinytuple = (123, 'runoob')
 
print (tuple)             # 输出完整元组
print (tuple[0])          # 输出元组的第一个元素
print (tuple[1:3])        # 输出从第二个元素开始到第三个元素
print (tuple[2:])         # 输出从第三个元素开始的所有元素
print (tinytuple * 2)     # 输出两次元组
print (tuple + tinytuple) # 连接元组
```

## Set（集合）

>* 集合（set）是一个无序不重复元素的序列。
>* 基本功能是进行成员关系测试和删除重复元素。
>* 可以使用大括号 { } 或者 set() 函数创建集合，注意：创建一个空集合必须用 set() 而不是 { }，因为 { } 是用来创建一个空字典。

```python

parame = {value01,value02,...}
或者
set(value)
```

```python

student = {'Tom', 'Jim', 'Mary', 'Tom', 'Jack', 'Rose'}
 
print(student)   # 输出集合，重复的元素被自动去掉
 
# 成员测试
if('Rose' in student) :
    print('Rose 在集合中')
else :
    print('Rose 不在集合中')
 
 
# set可以进行集合运算
a = set('abracadabra')
b = set('alacazam')
 
print(a)
 
print(a - b)     # a和b的差集
 
print(a | b)     # a和b的并集
 
print(a & b)     # a和b的交集
 
print(a ^ b)     # a和b中不同时存在的元素
```

## Dictionary（字典）

>* 列表是有序的对象结合，字典是无序的对象集合。两者之间的区别在于：字典当中的元素是通过键来存取的，而不是通过偏移存取。
>* 字典是一种映射类型，字典用"{ }"标识，它是一个无序的键(key) : 值(value)对集合。

```python

dict = {}
dict['one'] = "1 - 菜鸟教程"
dict[2]     = "2 - 菜鸟工具"
 
tinydict = {'name': 'runoob','code':1, 'site': 'www.runoob.com'}
 
 
print (dict['one'])       # 输出键为 'one' 的值
print (dict[2])           # 输出键为 2 的值
print (tinydict)          # 输出完整的字典
print (tinydict.keys())   # 输出所有键
print (tinydict.values()) # 输出所有值
```

构造函数 dict() 可以直接从键值对序列中构建字典如下


```python
>>>dict([('Runoob', 1), ('Google', 2), ('Taobao', 3)])
{'Taobao': 3, 'Runoob': 1, 'Google': 2}
 
>>> {x: x**2 for x in (2, 4, 6)}
{2: 4, 4: 16, 6: 36}
 
>>> dict(Runoob=1, Google=2, Taobao=3)
{'Taobao': 3, 'Runoob': 1, 'Google': 2}
```
另外，字典类型也有一些内置的函数，例如clear()、keys()、values()


>* 1、字典是一种映射类型，它的元素是键值对。
>* 2、字典的关键字必须为不可变类型，且不能重复。
>* 3、创建空字典使用 { }。

## Python数据类型转换

```python

int(x [,base])
将x转换为一个整数

float(x)
将x转换到一个浮点数

complex(real [,imag])
创建一个复数

str(x)
将对象 x 转换为字符串

repr(x)
将对象 x 转换为表达式字符串

eval(str)
用来计算在字符串中的有效Python表达式,并返回一个对象

tuple(s)
将序列 s 转换为一个元组

list(s)
将序列 s 转换为一个列表

set(s)
转换为可变集合

dict(d)
创建一个字典。d 必须是一个序列 (key,value)元组。

frozenset(s)
转换为不可变集合

chr(x)
将一个整数转换为一个字符

ord(x)
将一个字符转换为它的整数值

hex(x)
将一个整数转换为一个十六进制字符串

oct(x)
将一个整数转换为一个八进制字符串

```


