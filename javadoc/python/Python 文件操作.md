# Python 文件操作

## Python File(文件) 方法

### 1、file.close()
关闭文件。关闭后文件不能再进行读写操作。

### 2、file.flush()

刷新文件内部缓冲，直接把内部缓冲区的数据立刻写入文件, 而不是被动的等待输出缓冲区写入。

### 3、file.fileno()

返回一个整型的文件描述符(file descriptor FD 整型), 可以用在如os模块的read方法等一些底层操作上。

### 4、file.isatty()

如果文件连接到一个终端设备返回 True，否则返回 False。

### 5、file.next()

返回文件下一行。

### 6、file.read([size])

从文件读取指定的字节数，如果未给定或为负则读取所有。

### 7、file.readline([size])

读取整行，包括 "\n" 字符。

### 8、file.readlines([sizehint])

读取所有行并返回列表，若给定sizeint>0，则是设置一次读多少字节，这是为了减轻读取压力。

### 9、file.seek(offset[, whence])

设置文件当前位置

### 10、file.tell()

返回文件当前位置。

### 11、file.truncate([size])

截取文件，截取的字节通过size指定，默认为当前文件位置。

### 12、file.write(str)

将字符串写入文件，没有返回值。

### 13、file.writelines(sequence)

向文件写入一个序列字符串列表，如果需要换行则要自己加入每行的换行符。


## 文件IO流

### 打印到屏幕
```shell
print "Python 是一个非常棒的语言，不是吗？"
```

### 读取键盘输入

raw_input([prompt]) 函数从标准输入读取一个行，并返回一个字符串（去掉结尾的换行符）

```shell
str = raw_input("请输入：")
print "你输入的内容是: ", str


请输入：Hello Python！
你输入的内容是:  Hello Python！


```


input函数
nput([prompt]) 函数和 raw_input([prompt]) 函数基本类似，但是 input 可以接收一个Python表达式作为输入，并将运算结果返回。

```shell
str = input("请输入：")
print "你输入的内容是: ", str

请输入：[x*5 for x in range(2,10,2)]
你输入的内容是:  [10, 20, 30, 40]
```

### 打开和关闭文件

```shell
# 打开一个文件
fo = open("foo.txt", "w")
print "文件名: ", fo.name
print "是否已关闭 : ", fo.closed
print "访问模式 : ", fo.mode
print "末尾是否强制加空格 : ", fo.softspace


文件名:  foo.txt
是否已关闭 :  False
访问模式 :  w
末尾是否强制加空格 :  0
```


close()方法

```shell
# 打开一个文件
fo = open("foo.txt", "w")
print "文件名: ", fo.name
 
# 关闭打开的文件
fo.close()
```

### write()方法
```shell
# 打开一个文件
fo = open("foo.txt", "w")
fo.write( "www.runoob.com!\nVery good site!\n")
 
# 关闭打开的文件
fo.close()
```

### read()方法
```shell
# 打开一个文件
fo = open("foo.txt", "r+")
str = fo.read(10)
print "读取的字符串是 : ", str
# 关闭打开的文件
fo.close()
```

### 文件定位
```shell
# 打开一个文件
fo = open("foo.txt", "r+")
str = fo.read(10)
print "读取的字符串是 : ", str
 
# 查找当前位置
position = fo.tell()
print "当前文件位置 : ", position
 
# 把指针再次重新定位到文件开头
position = fo.seek(0, 0)
str = fo.read(10)
print "重新读取字符串 : ", str
# 关闭打开的文件
fo.close()
```

```shell
读取的字符串是 :  www.runoob
当前文件位置 :  10
重新读取字符串 :  www.runoob
```

### 重命名和删除文件

```shell
# 重命名文件test1.txt到test2.txt。
os.rename( "test1.txt", "test2.txt" )

# 删除一个已经存在的文件test2.txt
os.remove("test2.txt")
```
