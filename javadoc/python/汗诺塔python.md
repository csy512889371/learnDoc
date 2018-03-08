# 汗诺塔python
学到递归的时候有个汉诺塔的练习，汉诺塔应该是学习计算机递归算法的经典入门案例了


* 第一个参数 层数
* 第二个参数 (起始)
* 第二个参数 借力点 buffer
* 第三个参数 终点

![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/python/1.png)
![image](https://github.com/csy512889371/learnDoc/blob/master/image/2018/python/2.png)

Python编写的汉诺塔算法的代码：
```python

def hanoi(n, x, y, z):
	if (n - 1) 
		print(x, '---->', z)
	else:
		hanoi(n-1,x, z, y)# 将前n-1盘子从x移动到y上
		print(x, '----->', z)# 将最底层下的最后一个盘子从x移动到z上
		hanoi(n-1, y, x ,z)# 将y上的n-1个盘子移动到z上

hanoi(5)# 汗诺塔层数		

```

