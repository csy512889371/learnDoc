# Python 3
>* Python3 列表
>* Python3 元组
>* Python3 字典

# Python3 列表

序列是Python中最基本的数据结构。序列中的每个元素都分配一个数字 - 它的位置，或索引，第一个索引是0，第二个索引是1，依此类推。
>* 序列都可以进行的操作包括索引，切片，加，乘，检查成员。
>* 此外，Python已经内置确定序列的长度以及确定最大和最小的元素的方法。
>* 列表的数据项不需要具有相同的类型
>* 创建一个列表，只要把逗号分隔的不同的数据项使用方括号括起来即可。如下所示

```python
list1 = ['Google', 'Runoob', 1997, 2000];
list2 = [1, 2, 3, 4, 5 ];
list3 = ["a", "b", "c", "d"];
```
> 与字符串的索引一样，列表索引从0开始。列表可以进行截取、组合等。

## 访问列表中的值

使用下标索引来访问列表中的值，同样你也可以使用方括号的形式截取字符，如下所示：
```python
list1 = ['Google', 'Runoob', 1997, 2000];
list2 = [1, 2, 3, 4, 5, 6, 7 ];
 
print ("list1[0]: ", list1[0])
print ("list2[1:5]: ", list2[1:5])
```
以上实例输出结果：

```python
list1[0]:  Google
list2[1:5]:  [2, 3, 4, 5]
```

## 更新列表

你可以对列表的数据项进行修改或更新，你也可以使用append()方法来添加列表项，如下所示
```python
list = ['Google', 'Runoob', 1997, 2000]
 
print ("第三个元素为 : ", list[2])
list[2] = 2001
print ("更新后的第三个元素为 : ", list[2])
```

## 删除列表元素

```python
list = ['Google', 'Runoob', 1997, 2000]
 
print (list)
del list[2]
print ("删除第三个元素 : ", list)

```

## Python列表脚本操作符

```python

//	长度
len([1, 2, 3])
// 	组合
[1, 2, 3] + [4, 5, 6]

//	重复
['Hi!'] * 4

// 元素是否存在于列表中
3 in [1, 2, 3]

// 	迭代
for x in [1, 2, 3]: print(x, end=" ")
```

## Python列表截取与拼接

Python的列表截取与字符串操作类型，如下所示

```python
L=['Google', 'Runoob', 'Taobao']

// 读取第三个元素
L[2]

//从右侧开始读取倒数第二个元素: count from the right
L[-2]

//输出从第二个元素开始后的所有元素
L[1:]

// 列表还支持拼接操作

>>>squares = [1, 4, 9, 16, 25]
>>> squares + [36, 49, 64, 81, 100]
[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```

## 嵌套列表

```python
>>>a = ['a', 'b', 'c']
>>> n = [1, 2, 3]
>>> x = [a, n]
>>> x
[['a', 'b', 'c'], [1, 2, 3]]
>>> x[0]
['a', 'b', 'c']
>>> x[0][1]
'b'

```
## Python列表函数&方法

Python包含以下函数:

```python
//len() 方法返回列表元素个数
list1 = ['Google', 'Runoob', 'Taobao']
print (len(list1))

//max() 方法返回列表元素中的最大值

list1, list2 = ['Google', 'Runoob', 'Taobao'], [456, 700, 200]

print ("list1 最大元素值 : ", max(list1))
print ("list2 最大元素值 : ", max(list2))

//min() 方法返回列表元素中的最小值
list1, list2 = ['Google', 'Runoob', 'Taobao'], [456, 700, 200]

print ("list1 最小元素值 : ", min(list1))
print ("list2 最小元素值 : ", min(list2))

//list() 方法用于将元组转换为列表

aTuple = (123, 'Google', 'Runoob', 'Taobao')
list1 = list(aTuple)
print ("列表元素 : ", list1)

```
Python包含以下方法

```python

//append() 方法用于在列表末尾添加新的对象
list1 = ['Google', 'Runoob', 'Taobao']
list1.append('Baidu')
print ("更新后的列表 : ", list1)

//count() 方法用于统计某个元素在列表中出现的次数
aList = [123, 'Google', 'Runoob', 'Taobao', 123];
print ("123 元素个数 : ", aList.count(123))

//extend() 函数用于在列表末尾一次性追加另一个序列中的多个值（用新列表扩展原来的列表）
list1 = ['Google', 'Runoob', 'Taobao']
list2=list(range(5)) # 创建 0-4 的列表
list1.extend(list2)  # 扩展列表
print ("扩展后的列表：", list1)

//index() 函数用于从列表中找出某个值第一个匹配项的索引位置。
list1 = ['Google', 'Runoob', 'Taobao']
print ('Runoob 索引值为', list1.index('Runoob'))
print ('Taobao 索引值为', list1.index('Taobao'))

//insert() 函数用于将指定对象插入列表的指定位置。
list1 = ['Google', 'Runoob', 'Taobao']
list1.insert(1, 'Baidu')
print ('列表插入元素后为 : ', list1)

//pop() 函数用于移除列表中的一个元素（默认最后一个元素），并且返回该元素的值。
list1 = ['Google', 'Runoob', 'Taobao']
list1.pop()
print ("列表现在为 : ", list1)

//remove() 函数用于移除列表中某个值的第一个匹配项。
list1 = ['Google', 'Runoob', 'Taobao', 'Baidu']
list1.remove('Taobao')

//reverse() 函数用于反向列表中元素。
list1 = ['Google', 'Runoob', 'Taobao', 'Baidu']
list1.reverse()
print ("列表反转后: ", list1)

//sort() 函数用于对原列表进行排序，如果指定参数，则使用比较函数指定的比较函数。
list1 = ['Google', 'Runoob', 'Taobao', 'Baidu']
list1.sort()
print ("列表排序后 : ", list1)


//Python3 List clear()方法
list1 = ['Google', 'Runoob', 'Taobao', 'Baidu']
list1.clear()
print ("列表清空后 : ", list1)

//copy() 函数用于复制列表
list1 = ['Google', 'Runoob', 'Taobao', 'Baidu']
list2 = list1.copy()

//两个list 比较
从第一个元素开始比较。
list1 = [000,1111]
list2 = [222,000]
list1 < list2

True

```

## Python3 元组

>* Python 的元组与列表类似，不同之处在于元组的元素不能修改。
>* 元组使用小括号，列表使用方括号。
>* 元组创建很简单，只需要在括号中添加元素，并使用逗号隔开即可。

```python
tup1 = ('Google', 'Runoob', 1997, 2000);
tup2 = (1, 2, 3, 4, 5 );
tup3 = "a", "b", "c", "d";

//创建空元组
tup1 = ();
元组中只包含一个元素时，需要在元素后面添加逗号，否则括号会被当作运算符使用：
>>> tup1 = (50)
>>> type(tup1)     # 不加逗号，类型为整型
<class 'int'>

>>> tup1 = (50,)
>>> type(tup1)     # 加上逗号，类型为元组
<class 'tuple'>


```

## 访问元组

元组可以使用下标索引来访问元组中的值，如下实例

```python
tup1 = ('Google', 'Runoob', 1997, 2000)
tup2 = (1, 2, 3, 4, 5, 6, 7 )

print ("tup1[0]: ", tup1[0])
print ("tup2[1:5]: ", tup2[1:5])
```

## 修改元组

元组中的元素值是不允许修改的，但我们可以对元组进行连接组合，如下实例

```python
tup1 = (12, 34.56);
tup2 = ('abc', 'xyz')

# 以下修改元组元素操作是非法的。
# tup1[0] = 100

# 创建一个新的元组
tup3 = tup1 + tup2;
print (tup3)
```

## 删除元组

```python

tup = ('Google', 'Runoob', 1997, 2000)

print (tup)
del tup;
print ("删除后的元组 tup : ")
print (tup)
```

元组运算符
```python
//计算元素个数
len((1, 2, 3))

//	连接
(1, 2, 3) + (4, 5, 6)

//复制
('Hi!',) * 4

//元素是否存在
3 in (1, 2, 3)

//	迭代
for x in (1, 2, 3): print x,


```

## 元组索引，截取

```python
L = ('Google', 'Taobao', 'Runoob')
//	读取第三个元素
L[2]

//反向读取；读取倒数第二个元素
L[-2]

//截取元素，从第二个开始后的所有元素。
L[1:]

```

## 元组内置函数

```python
//len(tuple) 计算元组元素个数。
>>> tuple1 = ('Google', 'Runoob', 'Taobao')
>>> len(tuple1)

//max(tuple) 返回元组中元素最大值。
>>> tuple2 = ('5', '4', '8')
>>> max(tuple2)

//min(tuple) 返回元组中元素最小值。
>>> tuple2 = ('5', '4', '8')
>>> min(tuple2)

//	tuple(seq) 将列表转换为元组
>>> list1= ['Google', 'Taobao', 'Runoob', 'Baidu']
>>> tuple1=tuple(list1)
>>> tuple1
('Google', 'Taobao', 'Runoob', 'Baidu')


```

## Python3 字典

>* 字典是另一种可变容器模型，且可存储任意类型对象。
>* 字典的每个键值(key=>value)对用冒号(:)分割，每个对之间用逗号(,)分割，整个字典包括在花括号({})中 ,格式如下所示

```python
d = {key1 : value1, key2 : value2 }
```
>* 键必须是唯一的，但值则不必。
>* 值可以取任何数据类型，但键必须是不可变的，如字符串，数字或元组。

```python
dict1 = { 'abc': 456 };
dict2 = { 'abc': 123, 98.6: 37 };
```

## 访问字典里的值
把相应的键放入熟悉的方括弧，如下实例
```python
dict = {'Name': 'Runoob', 'Age': 7, 'Class': 'First'}

print ("dict['Name']: ", dict['Name'])
print ("dict['Age']: ", dict['Age'])
```
>* 如果用字典里没有的键访问数据，会输出错误


## 修改字典
向字典添加新内容的方法是增加新的键/值对，修改或删除已有键/值对如下实例

```python
dict = {'Name': 'Runoob', 'Age': 7, 'Class': 'First'}

dict['Age'] = 8;               # 更新 Age
dict['School'] = "菜鸟教程"  # 添加信息

print ("dict['Age']: ", dict['Age'])
print ("dict['School']: ", dict['School'])
```

## 删除字典元素

```python
dict = {'Name': 'Runoob', 'Age': 7, 'Class': 'First'}

del dict['Name'] # 删除键 'Name'
dict.clear()     # 清空字典
del dict         # 删除字典
```
>* 执行 del 操作后字典不再存在

## 字典键的特性
字典值可以是任何的 python 对象，既可以是标准的对象，也可以是用户定义的，但键不行。

> 两个重要的点需要记住：

>* 不允许同一个键出现两次。创建时如果同一个键被赋值两次，后一个值会被记住
>* 键必须不可变，所以可以用数字，字符串或元组充当，而用列表就不行

## 字典内置函数&方法

```python
//len(dict) 计算字典元素个数，即键的总数。
>>> dict = {'Name': 'Runoob', 'Age': 7, 'Class': 'First'}
>>> len(dict)

//str(dict) 输出字典，以可打印的字符串表示。
>>> dict = {'Name': 'Runoob', 'Age': 7, 'Class': 'First'}
>>> str(dict)

//type(variable) 返回输入的变量类型，如果变量是字典就返回字典类型。
>>> dict = {'Name': 'Runoob', 'Age': 7, 'Class': 'First'}
>>> type(dict)

```

## Python字典包含了以下内置方法

```python
//Python 字典 clear() 函数用于删除字典内所有元素
dict = {'Name': 'Zara', 'Age': 7}

print ("字典长度 : %d" %  len(dict))
dict.clear()
print ("字典删除后长度 : %d" %  len(dict))


// copy() 函数返回一个字典的浅复制
dict1 = {'Name': 'Runoob', 'Age': 7, 'Class': 'First'}
 
dict2 = dict1.copy()
print ("新复制的字典为 : ",dict2)

//fromkeys() 函数用于创建一个新字典，以序列seq中元素做字典的键，value为字典所有键对应的初始值
seq = ('name', 'age', 'sex')

dict = dict.fromkeys(seq)
print ("新的字典为 : %s" %  str(dict))

dict = dict.fromkeys(seq, 10)
print ("新的字典为 : %s" %  str(dict))

新的字典为 : {'age': None, 'name': None, 'sex': None}
新的字典为 : {'age': 10, 'name': 10, 'sex': 10}

// get() 函数返回指定键的值，如果值不在字典中返回默认值
dict = {'Name': 'Runoob', 'Age': 27}

print ("Age 值为 : %s" %  dict.get('Age'))
print ("Sex 值为 : %s" %  dict.get('Sex', "NA"))

//Python 字典 in 操作符用于判断键是否存在于字典中，如果键在字典dict里返回true，否则返回false。
dict = {'Name': 'Runoob', 'Age': 7}

# 检测键 Age 是否存在
if  'Age' in dict:
    print("键 Age 存在")
else :
    print("键 Age 不存在")

# 检测键 Sex 是否存在
if  'Sex' in dict:
    print("键 Sex 存在")
else :
    print("键 Sex 不存在")
	
##  items() 方法以列表返回可遍历的(键, 值) 元组数组。
dict = {'Name': 'Runoob', 'Age': 7}

print ("Value : %s" %  dict.items())
Value : dict_items([('Age', 7), ('Name', 'Runoob')])
	
//keys() 方法以列表返回一个字典所有的键。

dict = {'Name': 'Runoob', 'Age': 7}

print ("字典所有的键为 : %s" %  dict.keys())
字典所有的键为 : dict_keys(['Age', 'Name'])

// setdefault() 方法和get()方法类似, 如果键不已经存在于字典中，将会添加键并将值设为默认值。

dict = {'Name': 'Runoob', 'Age': 7}

print ("Age 键的值为 : %s" %  dict.setdefault('Age', None))
print ("Sex 键的值为 : %s" %  dict.setdefault('Sex', None))
print ("新字典为：", dict)

Age 键的值为 : 7
Sex 键的值为 : None
新字典为： {'Age': 7, 'Name': 'Runoob', 'Sex': None}

//update() 函数把字典dict2的键/值对更新到dict里。

dict = {'Name': 'Runoob', 'Age': 7}
dict2 = {'Sex': 'female' }

dict.update(dict2)
print ("更新字典 dict : ", dict)
更新字典 dict :  {'Sex': 'female', 'Age': 7, 'Name': 'Runoob'}

//values() 方法以列表返回字典中的所有值。
dict = {'Sex': 'female', 'Age': 7, 'Name': 'Zara'}

print ("字典所有值为 : ",  list(dict.values()))
字典所有值为 :  ['female', 'Zara', 7]

//pop() 方法删除字典给定键 key 所对应的值，返回值为被删除的值。key值必须给出。 否则，返回default值。

>>> site= {'name': '菜鸟教程', 'alexa': 10000, 'url': 'www.runoob.com'}
>>> pop_obj=site.pop('name')
>>> print(pop_obj)

//popitem() 方法随机返回并删除字典中的一对键和值(一般删除末尾对)。

site= {'name': '菜鸟教程', 'alexa': 10000, 'url': 'www.runoob.com'}
pop_obj=site.popitem()
print(pop_obj)   
print(site)

('url', 'www.runoob.com')
{'name': '菜鸟教程', 'alexa': 10000}


```


