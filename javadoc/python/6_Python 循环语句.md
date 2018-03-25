# Python 循环语句


# 一、概述

* while 循环	在给定的判断条件为 true 时执行循环体，否则退出循环体。
* for 循环	重复执行语句
* 嵌套循环	你可以在while循环体中嵌套for循环

* break 语句	在语句块执行过程中终止循环，并且跳出整个循环
* continue 语句	在语句块执行过程中终止当前循环，跳出该次循环，执行下一次循环。
* pass 语句	pass是空语句，是为了保持程序结构的完整性。

## 二、 while 循环

```python

while 判断条件：
    执行语句……
```

continue 用于跳过该次循环，break 则是用于退出循环



例子
```python
i = 1
while i < 10:   
    i += 1
    if i%2 > 0:     # 非双数时跳过输出
        continue
    print i         # 输出双数2、4、6、8、10
 
i = 1
while 1:            # 循环条件为1必定成立
    print i         # 输出1~10
    i += 1
    if i > 10:     # 当i大于10时跳出循环
        break
```

### 循环使用 else 语句

```python
count = 0
while count < 5:
   print count, " is  less than 5"
   count = count + 1
else:
   print count, " is not less than 5"
```

## 三、 for 循环语句

```python
for iterating_var in sequence:
   statements(s)
```

例子一
```python
for letter in 'Python':     # 第一个实例
   print '当前字母 :', letter
 
fruits = ['banana', 'apple',  'mango']
for fruit in fruits:        # 第二个实例
   print '当前水果 :', fruit
 

```

序列索引迭代

```python
fruits = ['banana', 'apple',  'mango']
for index in range(len(fruits)):
   print '当前水果 :', fruits[index]
 
print "Good bye!"
```


循环使用 else 语句

```python
for num in range(10,20):  # 迭代 10 到 20 之间的数字
   for i in range(2,num): # 根据因子迭代
      if num%i == 0:      # 确定第一个因子
         j=num/i          # 计算第二个因子
         print '%d 等于 %d * %d' % (num,i,j)
         break            # 跳出当前循环
   else:                  # 循环的 else 部分
      print num, '是一个质数'
```

## 四、Python 循环嵌套

```python
for iterating_var in sequence:
   for iterating_var in sequence:
      statements(s)
   statements(s)
```


```python
while expression:
   while expression:
      statement(s)
   statement(s)
```

## 五、pass 语句

* pass是空语句，是为了保持程序结构的完整性。
* pass 不做任何事情，一般用做占位语句。


```python
# 输出 Python 的每个字母


for letter in 'Python':
   if letter == 'h':
      pass
      print '这是 pass 块'
   print '当前字母 :', letter

print "Good bye!"
```
