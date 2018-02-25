# python3 语法

## 一、__doc__(文档字符串)

定义

> 如果将一个字符串作为函数的第一部分，而没有名称去引用它，python将它存储在函数中，以便以后可以引用它，这个字符串通常叫做docstring,是documentation string(文档字符串)的缩写。简单的说就是给函数一个描述

```python
def add(a,b):  
    """this a function to additon"""   #文档字符串  
    sum = a+b  
    return sum
```


显示

> 文档字符串通过函数名称后加英文句点显示

```python
print("%s" % add.__doc__)

help(print)

```

## 二、关键字参数

关键字参数是在传递构成中不必按照顺序传递，必须要提供”传递参数名=传递参数值”形式的参数，而传递过程中也转变为dict的键值对map关系

```python
def person(name, age, **kw):
        profile = {}
        profile['name'] = name
        profile['age'] = age
        for key,value in kw.items():
                profile[key] = value
        return profile

user_profile = person('Adam', 45, gender='M', job='Engineer')
print(user_profile)

```

## 三、默认参数

默认参数(又称为位置参数，听名字就知道这个要一一对应)是可以在对应的位置可写可不写的参数。

```python
  def Func(x, y, z = 2, w = 4):
    print x,y,z,w

  Func(1,2)	#默认参数
  Func(1,2 ,z = 5, w = 3)#关键字参数
  
```


