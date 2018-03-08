# python斐波那契

* Fibonacci数列为：0、1、1、2、3、5、8、13、21
* 数列第一项为0，第二项为1，从第三项开始，每一项为相邻前两项之和
* 用递归方法程序清晰易懂，但是开销大。分别给两个程序加一个计时语句，看看n = 30 时两个程序运行时间相差多少。

## 一、用递归的方法来定义:
```python
F(0) = 0 
F(1) = 1
F(n) = F(n-1) + F(n-2) , n>=2
```

## 二、用递归方法实现代码：

```python
def fibonacci ( n ) :  
	if n < 1:
		print('输入错误')
		return -1
    if n == 0 :   
        return 0  
    elif n == 1 :  
        return 1  
    else :  
        return fibonacci( n - 1 ) + fibonacci( n - 2 )  
		

result = fibonacci(20)

```


## 三、使用非递归
```python
def fibonacci(n):
	n1 = 1
	n2 = 1
	n3 = 1
	
	if n < 1:
		print('输入有误！')
		return -1
	
	while (n-2) > 0:
		n3 = n2 - n1
		n1 = n2
		n2 = n3
		n -= 1
		
	return n3

result = fibonacci(20)
```


