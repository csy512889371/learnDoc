# pickle模块

在机器学习中，我们常常需要把训练好的模型存储起来，这样在进行决策时直接将模型读出，而不需要重新训练模型，这样就大大节约了时间。Python提供的pickle模块就很好地解决了这个问题，它可以序列化对象并保存到磁盘中，并在需要的时候读取出来，任何对象都可以执行序列化操作。

* 1、pickle.load(file) 函数的功能：将file中的对象序列化读出。

* 2、pickle.dump(obj, file, [,protocol]) 函数的功能：将obj对象序列化存入已经打开的file中。
* 2.1、参数讲解：

```xml
obj：想要序列化的obj对象。
file:文件名称。
protocol：序列化使用的协议。如果该项省略，则默认为0。如果为负值或HIGHEST_PROTOCOL，则使用最高的协议版本。
```
		
## 代码

```python

#pickle模块主要函数的应用举例  
import pickle  
dataList = [[1, 1, 'yes'],  
            [1, 1, 'yes'],  
            [1, 0, 'no'],  
            [0, 1, 'no'],  
            [0, 1, 'no']]  
dataDic = { 0: [1, 2, 3, 4],  
            1: ('a', 'b'),  
            2: {'c':'yes','d':'no'}}  
  
#使用dump()将数据序列化到文件中  
fw = open('dataFile.txt','wb')  
# Pickle the list using the highest protocol available.  
pickle.dump(dataList, fw, -1)  
# Pickle dictionary using protocol 0.  
pickle.dump(dataDic, fw)  
fw.close()  
  
#使用load()将数据从文件中序列化读出  
fr = open('dataFile.txt','rb')  
data1 = pickle.load(fr)  
print(data1)  
data2 = pickle.load(fr)  
print(data2)  
fr.close()  
  
#使用dumps()和loads()举例  
p = pickle.dumps(dataList)  
print( pickle.loads(p) )  
p = pickle.dumps(dataDic)  
print( pickle.loads(p) )  
```
